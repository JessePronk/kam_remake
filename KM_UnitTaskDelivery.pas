unit KM_UnitTaskDelivery;
interface
uses Classes, KM_CommonTypes, KM_Defaults, KM_Utils, KM_Houses, KM_Units, KromUtils, SysUtils;

type
  TDeliverKind = (dk_House, dk_Unit);

{Perform delivery}
type
    TTaskDeliver = class(TUnitTask)
    private
      fFrom:TKMHouse;
      fToHouse:TKMHouse;
      fToUnit:TKMUnit;
      fResourceType:TResourceType;
      fDeliverID:integer;
    public
      DeliverKind:TDeliverKind;
      constructor Create(aSerf:TKMUnitSerf; aFrom:TKMHouse; toHouse:TKMHouse; toUnit:TKMUnit; Res:TResourceType; aID:integer);
      constructor Load(LoadStream:TKMemoryStream); override;
      procedure SyncLoad(); override;
      destructor Destroy; override;
      procedure Abandon; override;
      function WalkShouldAbandon:boolean; override;
      procedure Execute(out TaskDone:boolean); override;
      procedure Save(SaveStream:TKMemoryStream); override;
    end;

implementation
uses KM_PlayersCollection, KM_Units_Warrior, KM_UnitActionWalkTo;


{ TTaskDeliver }
constructor TTaskDeliver.Create(aSerf:TKMUnitSerf; aFrom:TKMHouse; toHouse:TKMHouse; toUnit:TKMUnit; Res:TResourceType; aID:integer);
begin
  Inherited Create(aSerf);
  fTaskName := utn_Deliver;
  fLog.AssertToLog((toHouse=nil)or(toUnit=nil),'Deliver to House AND Unit?');
  if aFrom <> nil then fFrom:=aFrom.GetSelf;
  if toHouse <> nil then fToHouse:=toHouse.GetSelf;
  if toUnit <> nil then fToUnit:=toUnit.GetSelf;
  fResourceType:=Res;
  fDeliverID:=aID;

  if toHouse<>nil then
    DeliverKind:=dk_House;
  if toUnit<>nil then
    DeliverKind:=dk_Unit;

  if WRITE_DETAILED_LOG then fLog.AppendLog('Serf '+inttostr(fUnit.ID)+' created delivery task '+inttostr(fDeliverID));
  fUnit.SetActionLockedStay(0,ua_Walk);
end;


constructor TTaskDeliver.Load(LoadStream:TKMemoryStream);
begin
  Inherited;
  LoadStream.Read(fFrom, 4);
  LoadStream.Read(fToHouse, 4);
  LoadStream.Read(fToUnit, 4);
  LoadStream.Read(fResourceType, SizeOf(fResourceType));
  LoadStream.Read(fDeliverID);
  LoadStream.Read(DeliverKind, SizeOf(DeliverKind));
end;


procedure TTaskDeliver.SyncLoad();
begin
  Inherited;
  fFrom    := fPlayers.GetHouseByID(cardinal(fFrom));
  fToHouse := fPlayers.GetHouseByID(cardinal(fToHouse));
  fToUnit  := fPlayers.GetUnitByID(cardinal(fToUnit));
end;


destructor TTaskDeliver.Destroy;
begin
  if fFrom    <> nil then fFrom.RemovePointer;
  if fToHouse <> nil then fToHouse.RemovePointer;
  if fToUnit  <> nil then fToUnit.RemovePointer;
  Inherited Destroy;
end;


procedure TTaskDeliver.Abandon();
begin
  if WRITE_DETAILED_LOG then fLog.AppendLog('Serf '+inttostr(fUnit.ID)+' abandoned delivery task '+inttostr(fDeliverID)+' at phase ' + inttostr(fPhase));
  fPlayers.Player[byte(fUnit.GetOwner)].DeliverList.AbandonDelivery(fDeliverID);
  Inherited;
end;


function TTaskDeliver.WalkShouldAbandon:boolean;
begin
  //Note: Phase is -1 because it will have been increased at the end of last Execute
  Result := false;
  if (Phase-1 = 0) then Result := fFrom.IsDestroyed; //We are walking to fFromHouse. Check if it's destroyed
  if (Phase-1 = 5) and (DeliverKind = dk_House) then Result := fToHouse.IsDestroyed; //We are walking to fToHouse. Check if it's destroyed
  //If we are delivering to a unit we don't care because if it dies action will abandon anyway (units are tracked by walk action)
end;


procedure TTaskDeliver.Execute(out TaskDone:boolean);
var NewDelivery: TUnitTask;
begin
TaskDone:=false;

with fUnit do
case fPhase of
0: if not fFrom.IsDestroyed then begin
     if WRITE_DETAILED_LOG then fLog.AppendLog('Serf '+inttostr(fUnit.ID)+' going to take '+TypeToString(fResourceType)+' from '+TypeToString(GetPosition));
     SetActionWalk(fUnit,KMPointY1(fFrom.GetEntrance))
   end else begin
     Abandon;
     TaskDone:=true;
   end;
1: if not fFrom.IsDestroyed then begin
     if WRITE_DETAILED_LOG then fLog.AppendLog('Serf '+inttostr(fUnit.ID)+' taking '+TypeToString(fResourceType)+' from '+TypeToString(GetPosition));
     SetActionGoIn(ua_Walk,gd_GoInside,fFrom)
   end else begin
     Abandon;
     TaskDone:=true;
   end;
2: if not fFrom.IsDestroyed then
   begin
     if WRITE_DETAILED_LOG then fLog.AppendLog('Serf '+inttostr(fUnit.ID)+' taking '+TypeToString(fResourceType)+' from '+TypeToString(GetPosition));
     if fFrom.ResTakeFromOut(fResourceType) then begin
       TKMUnitSerf(fUnit).GiveResource(fResourceType);
       fPlayers.Player[byte(GetOwner)].DeliverList.TakenOffer(fDeliverID);
     end else begin
       Abandon;
       TaskDone := true;
       fLog.AssertToLog(false,'Resource''s gone..');
     end;
     SetActionStay(5,ua_Walk); //Wait a moment inside
   end else begin
     Abandon;
     TaskDone:=true;
   end;
3: if not fFrom.IsDestroyed then
   begin
     SetActionGoIn(ua_Walk,gd_GoOutside,fFrom);
   end else
     SetActionLockedStay(0,ua_Walk);
4: if TKMUnitSerf(fUnit).Carry=rt_None then TaskDone:=true else SetActionLockedStay(0,ua_Walk);
end;

//Deliver into complete house
if DeliverKind = dk_House then
  if fToHouse.IsComplete then
  with fUnit do
  case fPhase of
  0..4:;
  5: if not fToHouse.IsDestroyed then
       SetActionWalk(fUnit,KMPointY1(fToHouse.GetEntrance))
     else begin
       TKMUnitSerf(fUnit).TakeResource(TKMUnitSerf(fUnit).Carry);
       Abandon;
       TaskDone:=true;
     end;
  6: if not fToHouse.IsDestroyed then
       SetActionGoIn(ua_Walk,gd_GoInside,fToHouse)
     else begin
       TKMUnitSerf(fUnit).TakeResource(TKMUnitSerf(fUnit).Carry);
       Abandon;
       TaskDone:=true;
     end;
  7: SetActionStay(5,ua_Walk); //wait a bit inside
  8: if not fToHouse.IsDestroyed then
     begin
       fToHouse.ResAddToIn(TKMUnitSerf(fUnit).Carry);
       TKMUnitSerf(fUnit).TakeResource(TKMUnitSerf(fUnit).Carry);
       fPlayers.Player[byte(GetOwner)].DeliverList.GaveDemand(fDeliverID);
       fPlayers.Player[byte(GetOwner)].DeliverList.AbandonDelivery(fDeliverID);

       //Now look for another delivery from inside this house
       NewDelivery := TKMUnitSerf(fUnit).GetActionFromQueue(fToHouse);
       if NewDelivery <> nil then
       begin //Take this new delivery
         NewDelivery.Phase := 2; //Skip to resource-taking part of the new task
         TKMUnitSerf(fUnit).SetNewDelivery(NewDelivery);
         Self.Free; //After setting new unit task we should free self. Note do not set TaskDone:=true as this will affect the new task
         exit;
       end
       else //No delivery found then just step outside
         SetActionGoIn(ua_walk,gd_GoOutside,fToHouse);

     end else begin
       TKMUnitSerf(fUnit).TakeResource(TKMUnitSerf(fUnit).Carry);
       Abandon;
       TaskDone:=true;
     end;
  else TaskDone:=true;
  end;

//Deliver into wip house
if DeliverKind = dk_House then
  if not fToHouse.IsComplete then
  if not fToHouse.IsDestroyed then
  begin
    with fUnit do
    case fPhase of
    0..4:;
    5: SetActionWalk(fUnit,fToHouse.GetEntrance,ua_Walk,false); //Any tile next to entrance will do
    6: begin
         fToHouse.ResAddToBuild(TKMUnitSerf(fUnit).Carry);
         TKMUnitSerf(fUnit).TakeResource(TKMUnitSerf(fUnit).Carry);
         fPlayers.Player[byte(GetOwner)].DeliverList.GaveDemand(fDeliverID);
         fPlayers.Player[byte(GetOwner)].DeliverList.AbandonDelivery(fDeliverID);
         SetActionStay(1,ua_Walk);
       end;
    else TaskDone:=true;
    end;
  end else begin
    TKMUnitSerf(fUnit).TakeResource(TKMUnitSerf(fUnit).Carry);
    Abandon;
    TaskDone:=true;
  end;

//Deliver to builder or soldier
if DeliverKind = dk_Unit then
with fUnit do
case fPhase of
0..4:;
5: if (fToUnit<>nil)and(not fToUnit.IsDead) then
     SetActionWalk(fUnit, fToUnit.GetPosition, KMPoint(0,0), ua_Walk, false, fToUnit) //Pass a pointer to the Target Unit to the walk action so it can track it
   else
   begin
     TKMUnitSerf(fUnit).TakeResource(TKMUnitSerf(fUnit).Carry);
     fPlayers.Player[byte(GetOwner)].DeliverList.GaveDemand(fDeliverID);
     fPlayers.Player[byte(GetOwner)].DeliverList.AbandonDelivery(fDeliverID);
     TaskDone:=true;
   end;
6: begin
      if (fToUnit<>nil)and(not fToUnit.IsDead)and(not(fToUnit.GetUnitTask is TTaskDie)) then
      begin
        //See if the unit has moved. If so we must try again
        if KMLength(fUnit.GetPosition,fToUnit.GetPosition) > 1.5 then
        begin
          fPhase := 5; //Walk to unit again
          SetActionStay(0,ua_Walk);
          exit;
        end;
        //Worker
        if (fToUnit.GetUnitType = ut_Worker)and(fToUnit.GetUnitTask<>nil) then
        begin
          fToUnit.GetUnitTask.Phase := fToUnit.GetUnitTask.Phase + 1;
          fToUnit.SetActionStay(0,ua_Work1);
        end;
        //Warrior
        if (fToUnit is TKMUnitWarrior) then
        begin
          fToUnit.SetFullCondition; //Feed the warrior
          TKMUnitWarrior(fToUnit).SetOrderedFood := false;
        end;
      end;
      TKMUnitSerf(fUnit).TakeResource(TKMUnitSerf(fUnit).Carry);
      fPlayers.Player[byte(GetOwner)].DeliverList.GaveDemand(fDeliverID);
      fPlayers.Player[byte(GetOwner)].DeliverList.AbandonDelivery(fDeliverID);
      SetActionLockedStay(5,ua_Walk); //Pause breifly (like we are handing over the goods)
   end;
7: begin
      //After feeding troops, ask for new delivery and if there is none, walk back to the place we came from so we don't leave serfs all over the battlefield
      if (fToUnit <> nil) and (fToUnit is TKMUnitWarrior) then
      begin
        NewDelivery := TKMUnitSerf(fUnit).GetActionFromQueue;
        if NewDelivery <> nil then
        begin
          //Take this new delivery
          NewDelivery.Phase := 0; //Start at the begining of the new task
          TKMUnitSerf(fUnit).SetNewDelivery(NewDelivery);
          Self.Free; //After setting new unit task we should free self. Note do not set TaskDone:=true as this will affect the new task
          exit;
        end
        else //No delivery found then just walk back to our from house
          SetActionWalk(fUnit,KMPointY1(fFrom.GetEntrance),KMPoint(0,0),ua_Walk,false); //Don't walk to spot as it doesn't really matter
      end
      else
        SetActionStay(0,ua_Walk); //If we're not feeding a warrior then ignore this step
   end;
else TaskDone:=true;
end;

  if TaskDone then exit;
  inc(fPhase);
  if fUnit.GetUnitAction=nil then
    fLog.AssertToLog(false,'fSerf.fCurrentAction=nil)and(not TaskDone)');
end;


procedure TTaskDeliver.Save(SaveStream:TKMemoryStream);
begin
  Inherited;
  if fFrom <> nil then
    SaveStream.Write(fFrom.ID) //Store ID, then substitute it with reference on SyncLoad
  else
    SaveStream.Write(Zero);
  if fToHouse <> nil then
    SaveStream.Write(fToHouse.ID) //Store ID, then substitute it with reference on SyncLoad
  else
    SaveStream.Write(Zero);
  if fToUnit <> nil then
    SaveStream.Write(fToUnit.ID) //Store ID, then substitute it with reference on SyncLoad
  else
    SaveStream.Write(Zero);
  SaveStream.Write(fResourceType, SizeOf(fResourceType));
  SaveStream.Write(fDeliverID);
  SaveStream.Write(DeliverKind, SizeOf(DeliverKind));
end;


end.
