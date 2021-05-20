unit KM_ResInterpolation;
{$I KaM_Remake.inc}
interface
uses
  Classes, SysUtils,
  KM_Defaults, KM_Points, KM_ResTypes;

function GetHouseInterpSpriteOffset(aHT: TKMHouseType; aAct: TKMHouseActionType): Integer;
function GetTreeInterpSpriteOffset(aTree: Integer): Integer;
function GetThoughtInterpSpriteOffset(aTh: TKMUnitThought): Integer;
function GetUnitInterpSpriteOffset(aUnit: TKMUnitType; aAct: TKMUnitActionType; aDir: TKMDirection): Integer;
function GetCarryInterpSpriteOffset(aWare: TKMWareType; aDir: TKMDirection): Integer;


implementation
uses
  KM_ResMapElements;



function GetHouseInterpSpriteOffset(aHT: TKMHouseType; aAct: TKMHouseActionType): Integer;
const HOUSE_INTERP_LOOKUP: array[TKMHouseType, TKMHouseActionType] of Integer = (
  (-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1), // htNone
  (-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1), // htAny
  (-1,2100,2100,2340,2340,2580,-1,2612,2852,-1,-1,2892,2940,2988,3036,3084,3132,3180,3228), // htArmorSmithy
  (-1,3276,3516,3756,-1,-1,-1,3996,4236,-1,-1,4316,2988,3228,3036,4364,4412,3132,2892), // htArmorWorkshop
  (-1,4460,4652,-1,-1,2580,-1,4892,5132,-1,-1,2892,5212,4316,4316,5260,5308,5356,5260), // htBakery
  (-1,-1,-1,-1,-1,-1,-1,-1,5404,5444,5484,5564,4364,4412,5612,3180,5308,5660,2988), // htBarracks
  (5708,5828,6044,6284,-1,-1,-1,6308,6468,-1,-1,5260,2988,3228,6548,3180,2892,3132,4412), // htButchers
  (6596,6836,-1,-1,6956,-1,-1,-1,7196,-1,-1,2892,4316,3228,3036,7236,7284,3132,3084), // htCoalMine
  (-1,-1,-1,-1,-1,-1,-1,7332,7572,-1,-1,3228,2892,4412,4316,5260,7652,5212,7700), // htFarm
  (-1,-1,-1,-1,-1,-1,-1,7748,5404,-1,-1,2892,3228,2988,3036,4412,3180,4412,5212), // htFisherHut
  (-1,7988,-1,-1,-1,-1,-1,8116,8356,8396,-1,2892,4316,3228,3036,7236,7284,3084,2892), // htGoldMine
  (-1,-1,-1,-1,-1,-1,-1,-1,8436,8396,8476,3228,2988,5308,5612,2940,3180,4412,6548), // htInn
  (-1,8556,-1,-1,-1,-1,-1,8684,8436,-1,-1,2892,4316,2940,3036,7236,3132,3084,3036), // htIronMine
  (-1,8924,9164,-1,-1,2580,-1,9404,9484,-1,-1,2892,3228,7236,4364,3036,4412,5260,7700), // htIronSmithy
  (-1,-1,-1,-1,-1,-1,-1,-1,9564,9604,9644,9684,9732,9780,9828,9876,9924,9972,10020), // htMarketplace
  (-1,10068,10292,10532,-1,2580,-1,10772,2852,-1,-1,3084,5212,4364,4412,3180,4316,2988,3084), // htMetallurgists
  (-1,11012,-1,-1,-1,-1,11076,11156,8356,-1,-1,7236,3132,2988,3228,2892,5564,3084,5308), // htMill
  (-1,11396,-1,-1,11540,-1,-1,11780,8356,-1,-1,7236,3132,2940,3084,7700,5564,4412,2892), // htQuary
  (11924,12164,-1,-1,12244,-1,-1,12484,12724,-1,-1,2892,3228,4316,4412,3036,5260,7236,3084), // htSawmill
  (12804,13044,13284,13524,13764,-1,-1,-1,8476,-1,-1,3132,5308,5564,5612,5260,5308,7284,3132), // htSchool
  (-1,14004,14244,14484,-1,-1,-1,14724,8356,-1,-1,2892,3228,4364,2892,2892,3228,3084,7236), // htSiegeWorkshop
  (14964,15204,15444,15684,15924,-1,-1,16164,16308,-1,-1,3132,4412,5612,5564,3228,2988,7652,7284), // htStables
  (-1,-1,-1,-1,-1,-1,-1,-1,5444,5404,-1,3132,2892,2988,3228,5212,3180,4412,5260), // htStore
  (-1,16388,16628,-1,-1,-1,-1,16868,17108,-1,-1,3132,5660,3228,3084,2988,3180,6548,2940), // htSwine
  (17188,17420,-1,-1,-1,2580,-1,17516,17756,-1,-1,5260,4364,2988,7236,3228,6548,3084,2940), // htTannery
  (-1,-1,-1,-1,-1,-1,-1,-1,8356,17756,-1,2892,3228,4364,5308,5660,3180,6548,5660), // htTownHall
  (-1,-1,-1,-1,-1,-1,-1,17796,4236,-1,-1,2892,3228,4316,4364,5564,7284,2940,4412), // htWatchTower
  (18036,18276,18276,18516,18756,2580,-1,18996,19236,-1,-1,2892,3228,4316,4412,3036,5260,4364,7236), // htWeaponSmithy
  (19316,19444,19684,19924,20164,-1,-1,20404,20644,-1,-1,7236,2988,3132,6548,3228,3036,7652,4412), // htWeaponWorkshop
  (20724,20964,-1,-1,21156,-1,-1,21380,7196,-1,-1,5564,5356,2988,4412,3180,5612,5564,2940), // htWineyard
  (-1,-1,-1,-1,-1,-1,-1,21620,7196,-1,-1,2892,2940,3132,4316,3036,7236,5564,3228) // htWoodcutters
);
begin
  if INTERPOLATED_ANIMS then
  begin
    Result := HOUSE_INTERP_LOOKUP[aHT, aAct];
  end
  else
    Result := -1;
end;


function GetTreeInterpSpriteOffset(aTree: Integer): Integer;
const
  TREE_INTERP_LOOKUP: array [0..OBJECTS_CNT] of Integer = (
  -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
  -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
  -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
  -1,-1,-1,-1,-1,260,388,516,644,772,868,964,-1,964,-1,-1,
  -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
  -1,-1,-1,-1,-1,-1,-1,1060,1124,1188,1252,1412,1460,1524,1588,1652,
  1060,1124,1188,1812,1876,1060,1124,1188,2036,2100,1060,1124,2260,2324,2388,2548,
  2596,2692,2788,2548,2596,2692,2948,3044,1412,3204,3268,3332,3396,-1,-1,-1,
  -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
  -1,-1,-1,-1,3556,3628,3676,3740,3556,3628,3900,3964,3556,3628,3900,4124,
  4188,3556,3628,3676,4348,4412,3556,3628,3676,4572,4412,4636,-1,-1,-1,-1,
  -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
  -1,-1,-1,-1,-1,-1,-1,4700,4796,4892,4988,5084,5180,5276,-1,-1,
  -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
  -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
  -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1);
begin
  if INTERPOLATED_ANIMS and (aTree <= High(TREE_INTERP_LOOKUP)) then
  begin
    Result := TREE_INTERP_LOOKUP[aTree];
  end
  else
    Result := -1;
end;


function GetThoughtInterpSpriteOffset(aTh: TKMUnitThought): Integer;
const THOUGHT_INTERP_LOOKUP: array[TKMUnitThought] of Integer = (
  -1,90156,90220,90284,90348,90412,90476,90540,90604
);
begin
  if INTERPOLATED_ANIMS then
  begin
    Result := THOUGHT_INTERP_LOOKUP[aTh];
  end
  else
    Result := -1;
end;


function GetCarryInterpSpriteOffset(aWare: TKMWareType; aDir: TKMDirection): Integer;
const
  CARRY_INTERP_LOOKUP: array[TKMWareType, TKMDirection] of Integer = (
  (-1,-1,-1,-1,-1,-1,-1,-1,-1), // wtNone
  (-1,75820,75884,75948,76012,76076,76140,76204,76268), // wtTrunk
  (-1,76332,76396,76460,76524,76588,76652,76716,76780), // wtStone
  (-1,76844,76908,76972,77036,77100,77164,77228,77292), // wtWood
  (-1,77356,77420,77484,77548,77612,77676,77740,77804), // wtIronOre
  (-1,77868,77932,77996,78060,78124,78188,78252,78316), // wtGoldOre
  (-1,78380,78444,78508,78572,78636,78700,78764,78828), // wtCoal
  (-1,78892,78956,79020,79084,79148,79212,79276,79340), // wtSteel
  (-1,79404,79468,79532,79596,79660,79724,79788,79852), // wtGold
  (-1,79916,79980,80044,80108,80172,80236,80300,80364), // wtWine
  (-1,80428,80492,80556,80620,80684,80748,80812,80876), // wtCorn
  (-1,80940,81004,81068,81132,81196,81260,81324,81388), // wtBread
  (-1,81452,81516,81580,81644,81708,81772,81836,81900), // wtFlour
  (-1,81964,82028,82092,82156,82220,82284,82348,82412), // wtLeather
  (-1,82476,82540,82604,82668,82732,82796,82860,82924), // wtSausages
  (-1,82988,83052,83116,83180,83244,83308,83372,83436), // wtPig
  (-1,83500,83564,83628,83692,83756,83820,83884,83948), // wtSkin
  (-1,84012,84076,84140,84204,84268,84332,84396,84460), // wtShield
  (-1,84524,84588,84652,84716,84780,84844,84908,84972), // wtMetalShield
  (-1,85036,85100,85164,85228,85292,85356,85420,85484), // wtArmor
  (-1,85548,85612,85676,85740,85804,85868,85932,85996), // wtMetalArmor
  (-1,86060,86124,86188,86252,86316,86380,86444,86508), // wtAxe
  (-1,86572,86636,86700,86764,86828,86892,86956,87020), // wtSword
  (-1,87084,87148,87212,87276,87340,87404,87468,87532), // wtPike
  (-1,87596,87660,87724,87788,87852,87916,87980,88044), // wtHallebard
  (-1,88108,88172,88236,88300,88364,88428,88492,88556), // wtBow
  (-1,88620,88684,88748,88812,88876,88940,89004,89068), // wtArbalet
  (-1,89132,89196,89260,89324,89388,89452,89516,89580), // wtHorse
  (-1,89644,89708,89772,89836,89900,89964,90028,90092), // wtFish
  (-1,-1,-1,-1,-1,-1,-1,-1,-1), // wtAll
  (-1,-1,-1,-1,-1,-1,-1,-1,-1), // wtWarfare
  (-1,-1,-1,-1,-1,-1,-1,-1,-1) // wtFood
);
begin
  if INTERPOLATED_ANIMS then
  begin
    Result := CARRY_INTERP_LOOKUP[aWare, aDir];
  end
  else
    Result := -1;
end;


function GetUnitInterpSpriteOffset(aUnit: TKMUnitType; aAct: TKMUnitActionType; aDir: TKMDirection): Integer;
const
  ACTION_INTERP_LOOKUP: array[TKMUnitType, TKMUnitActionType, TKMDirection] of Integer = (
  ( // utNone
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalk
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaSpec
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaDie
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork1
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWorkEnd
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaEat
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkArm
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkTool
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkBooty
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkTool2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkBooty2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1) // uaUnknown
  ),
  ( // utAny
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalk
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaSpec
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaDie
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork1
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWorkEnd
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaEat
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkArm
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkTool
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkBooty
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkTool2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkBooty2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1) // uaUnknown
  ),
  ( // utSerf
    (-1,9300,9364,9428,9492,9556,9620,9684,9748), // uaWalk
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaSpec
    (-1,9812,9812,9940,9940,10052,10052,10172,10172), // uaDie
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork1
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWorkEnd
    (-1,10316,10556,10796,10556,11036,10556,11276,10556), // uaEat
    (-1,11516,11580,11644,11708,11772,11836,11900,11964), // uaWalkArm
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkTool
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkBooty
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkTool2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkBooty2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1) // uaUnknown
  ),
  ( // utWoodcutter
    (-1,12028,12092,12156,12220,12284,12348,12412,12476), // uaWalk
    (-1,12540,12604,-1,12684,-1,12764,-1,12844), // uaWork
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaSpec
    (-1,9812,9812,9940,9940,10052,10052,10172,10172), // uaDie
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork1
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWorkEnd
    (-1,12924,13164,13404,13164,13644,13164,13884,13164), // uaEat
    (-1,14124,14188,14252,14316,14380,-1,14444,14508), // uaWalkArm
    (-1,14572,14636,14700,14764,14828,14892,14956,15020), // uaWalkTool
    (-1,15084,15148,15212,15276,15340,15404,15468,15532), // uaWalkBooty
    (-1,15596,15660,15724,15788,15852,15916,15980,16044), // uaWalkTool2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkBooty2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1) // uaUnknown
  ),
  ( // utMiner
    (-1,16108,16172,16236,16300,16364,16428,16492,16556), // uaWalk
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaSpec
    (-1,9812,9812,9940,9940,10052,10052,10172,10172), // uaDie
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork1
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWorkEnd
    (-1,16620,16860,17100,16860,17340,16860,17580,16860), // uaEat
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkArm
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkTool
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkBooty
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkTool2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkBooty2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1) // uaUnknown
  ),
  ( // utAnimalBreeder
    (-1,17820,17884,17948,18012,18076,18140,18204,18268), // uaWalk
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaSpec
    (-1,9812,9812,9940,9940,10052,10052,10172,10172), // uaDie
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork1
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWorkEnd
    (-1,18332,18572,18812,18572,19052,18572,19292,18572), // uaEat
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkArm
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkTool
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkBooty
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkTool2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkBooty2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1) // uaUnknown
  ),
  ( // utFarmer
    (-1,19532,19596,19660,19724,19788,19852,19916,19980), // uaWalk
    (-1,20044,20172,20172,20300,20300,20428,20428,20044), // uaWork
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaSpec
    (-1,9812,9812,9940,9940,10052,10052,10172,10172), // uaDie
    (-1,20556,20556,20636,20636,20716,20716,20796,20796), // uaWork1
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWorkEnd
    (-1,20876,21116,21356,21116,21596,21116,21836,21116), // uaEat
    (-1,22076,-1,22140,22204,22268,22332,22396,22460), // uaWalkArm
    (-1,22524,22588,22652,22716,22780,22844,22908,22972), // uaWalkTool
    (-1,23036,23100,23164,23228,23292,23356,23420,23484), // uaWalkBooty
    (-1,23548,23612,23676,23740,23804,23868,23932,23996), // uaWalkTool2
    (-1,24060,24124,24188,24252,24316,24380,24444,24508), // uaWalkBooty2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1) // uaUnknown
  ),
  ( // utLamberjack
    (-1,24572,24636,24700,24764,24828,24892,24956,25020), // uaWalk
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaSpec
    (-1,9812,9812,9940,9940,10052,10052,10172,10172), // uaDie
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork1
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWorkEnd
    (-1,25084,25324,25564,25324,25804,25324,26044,25324), // uaEat
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkArm
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkTool
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkBooty
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkTool2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkBooty2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1) // uaUnknown
  ),
  ( // utBaker
    (-1,26284,26348,26412,26476,26540,26604,26668,26732), // uaWalk
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaSpec
    (-1,9812,9812,9940,9940,10052,10052,10172,10172), // uaDie
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork1
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWorkEnd
    (-1,26796,27036,27276,27036,27516,27036,27756,27036), // uaEat
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkArm
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkTool
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkBooty
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkTool2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkBooty2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1) // uaUnknown
  ),
  ( // utButcher
    (-1,27996,28060,28124,28188,28252,28316,28380,28444), // uaWalk
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaSpec
    (-1,9812,9812,9940,9940,10052,10052,10172,10172), // uaDie
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork1
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWorkEnd
    (-1,28508,28748,28988,28748,29228,28748,29468,28748), // uaEat
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkArm
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkTool
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkBooty
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkTool2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkBooty2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1) // uaUnknown
  ),
  ( // utFisher
    (-1,29708,29772,29836,29900,29964,30028,30092,30156), // uaWalk
    (-1,30220,30340,30460,30580,30700,30820,30940,31060), // uaWork
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaSpec
    (-1,9812,9812,9940,9940,10052,10052,10172,10172), // uaDie
    (-1,31180,31284,31388,31492,31596,31700,31804,31908), // uaWork1
    (-1,32012,32252,32492,32732,32972,33212,33452,33692), // uaWork2
    (-1,33932,34052,34172,34292,34412,34532,34652,34772), // uaWorkEnd
    (-1,34892,35132,35372,35132,35612,35132,35852,35132), // uaEat
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkArm
    (-1,36092,36156,36220,36284,36348,36412,36476,36540), // uaWalkTool
    (-1,36604,36668,36732,36796,36860,36924,36988,37052), // uaWalkBooty
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkTool2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkBooty2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1) // uaUnknown
  ),
  ( // utWorker
    (-1,37116,37180,37244,37308,37372,37436,37500,37564), // uaWalk
    (-1,37628,37628,37716,37716,37804,37804,37892,37892), // uaWork
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaSpec
    (-1,9812,9812,9940,9940,10052,10052,10172,10172), // uaDie
    (-1,37980,37980,38076,38076,38172,38172,38268,38268), // uaWork1
    (-1,38364,38364,38452,38452,38540,38540,38628,38628), // uaWork2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWorkEnd
    (-1,38716,38956,39196,38956,39436,38956,39676,38956), // uaEat
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkArm
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkTool
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkBooty
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkTool2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkBooty2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1) // uaUnknown
  ),
  ( // utStoneCutter
    (-1,39916,39980,40044,40108,40172,40236,40300,40364), // uaWalk
    (-1,40428,-1,-1,-1,-1,-1,-1,-1), // uaWork
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaSpec
    (-1,9812,9812,9940,9940,10052,10052,10172,10172), // uaDie
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork1
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWorkEnd
    (-1,40508,40748,40988,40748,41228,40748,41468,40748), // uaEat
    (-1,41708,41772,41836,41900,41964,42028,42092,42156), // uaWalkArm
    (-1,42220,42284,42348,42412,42476,42540,42604,42668), // uaWalkTool
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkBooty
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkTool2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkBooty2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1) // uaUnknown
  ),
  ( // utSmith
    (-1,42732,42796,42860,42924,42988,43052,43116,43180), // uaWalk
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaSpec
    (-1,9812,9812,9940,9940,10052,10052,10172,10172), // uaDie
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork1
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWorkEnd
    (-1,43244,43484,43724,43484,43964,43484,44204,43484), // uaEat
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkArm
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkTool
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkBooty
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkTool2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkBooty2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1) // uaUnknown
  ),
  ( // utMetallurgist
    (-1,44444,44508,44572,44636,44700,44764,44828,44892), // uaWalk
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaSpec
    (-1,9812,9812,9940,9940,10052,10052,10172,10172), // uaDie
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork1
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWorkEnd
    (-1,44956,45196,45436,45196,45676,45196,45916,45196), // uaEat
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkArm
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkTool
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkBooty
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkTool2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkBooty2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1) // uaUnknown
  ),
  ( // utRecruit
    (-1,46156,46220,46284,46348,46412,46476,46540,46604), // uaWalk
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork
    (-1,46668,46668,46668,46668,46668,46668,46668,46668), // uaSpec
    (-1,9812,9812,9940,9940,10052,10052,10172,10172), // uaDie
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork1
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWorkEnd
    (-1,46708,46948,47188,46948,47428,46948,47668,46948), // uaEat
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkArm
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkTool
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkBooty
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkTool2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkBooty2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1) // uaUnknown
  ),
  ( // utMilitia
    (-1,47908,47972,48036,48100,48164,48228,48292,48356), // uaWalk
    (-1,48420,48516,48612,48708,48804,48900,48996,49092), // uaWork
    (-1,49188,49252,49316,49380,49444,49508,49572,49636), // uaSpec
    (-1,9812,9812,9940,9940,10052,10052,10172,10172), // uaDie
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork1
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWorkEnd
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaEat
    (-1,49700,49764,49828,49892,49700,49764,49828,49892), // uaWalkArm
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkTool
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkBooty
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkTool2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkBooty2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1) // uaUnknown
  ),
  ( // utAxeFighter
    (-1,49956,50020,50084,50148,50212,50276,50340,50404), // uaWalk
    (-1,50468,50564,50660,50756,50852,50948,51044,51140), // uaWork
    (-1,51236,51300,51364,51428,51492,51556,51620,51684), // uaSpec
    (-1,9812,9812,9940,9940,10052,10052,10172,10172), // uaDie
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork1
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWorkEnd
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaEat
    (-1,49700,49764,49828,49892,49700,49764,49828,49892), // uaWalkArm
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkTool
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkBooty
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkTool2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkBooty2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1) // uaUnknown
  ),
  ( // utSwordsman
    (-1,51748,51812,51876,51940,52004,52068,52132,52196), // uaWalk
    (-1,52260,52356,52452,52548,52644,52740,52836,52932), // uaWork
    (-1,53028,53092,53156,53220,53284,53348,53412,53476), // uaSpec
    (-1,9812,9812,9940,9940,10052,10052,10172,10172), // uaDie
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork1
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWorkEnd
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaEat
    (-1,49700,49764,49828,49892,49700,49764,49828,49892), // uaWalkArm
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkTool
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkBooty
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkTool2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkBooty2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1) // uaUnknown
  ),
  ( // utBowman
    (-1,53540,53604,53668,53732,53796,53860,53924,53988), // uaWalk
    (-1,54052,54196,54340,54484,54628,54772,54916,55060), // uaWork
    (-1,55204,55244,55284,55324,55364,55404,55444,55484), // uaSpec
    (-1,9812,9812,9940,9940,10052,10052,10172,10172), // uaDie
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork1
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWorkEnd
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaEat
    (-1,55524,55588,55652,55716,55524,55588,55652,55716), // uaWalkArm
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkTool
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkBooty
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkTool2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkBooty2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1) // uaUnknown
  ),
  ( // utArbaletman
    (-1,55780,55844,55908,55972,56036,56100,56164,56228), // uaWalk
    (-1,56292,56516,56740,56964,57188,57412,57636,57860), // uaWork
    (-1,58084,58124,58164,58204,58244,58284,58324,58364), // uaSpec
    (-1,9812,9812,9940,9940,10052,10052,10172,10172), // uaDie
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork1
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWorkEnd
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaEat
    (-1,55524,55588,55652,55716,55524,55588,55652,55716), // uaWalkArm
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkTool
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkBooty
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkTool2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkBooty2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1) // uaUnknown
  ),
  ( // utPikeman
    (-1,58404,58468,58532,58596,58660,58724,58788,58852), // uaWalk
    (-1,58916,59012,59108,59204,59300,59396,59492,59588), // uaWork
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaSpec
    (-1,9812,9812,9940,9940,10052,10052,10172,10172), // uaDie
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork1
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWorkEnd
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaEat
    (-1,59684,59748,59812,59876,59684,59748,59812,59876), // uaWalkArm
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkTool
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkBooty
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkTool2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkBooty2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1) // uaUnknown
  ),
  ( // utHallebardman
    (-1,59940,60004,60068,60132,60196,60260,60324,60388), // uaWalk
    (-1,60452,60548,60644,60740,60836,60932,61028,61124), // uaWork
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaSpec
    (-1,9812,9812,9940,9940,10052,10052,10172,10172), // uaDie
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork1
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWorkEnd
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaEat
    (-1,59684,59748,59812,59876,59684,59748,59812,59876), // uaWalkArm
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkTool
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkBooty
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkTool2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkBooty2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1) // uaUnknown
  ),
  ( // utHorseScout
    (-1,61220,61268,61316,61364,61412,61460,61508,61556), // uaWalk
    (-1,61604,61700,61796,61892,61988,62084,62180,62276), // uaWork
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaSpec
    (-1,62372,62372,62524,62524,62652,62652,62788,62788), // uaDie
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork1
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWorkEnd
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaEat
    (-1,62916,62980,63044,63108,62916,62980,63044,63108), // uaWalkArm
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkTool
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkBooty
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkTool2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkBooty2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1) // uaUnknown
  ),
  ( // utCavalry
    (-1,63172,63220,63268,63316,63364,63412,63460,63508), // uaWalk
    (-1,63556,63652,63748,63844,63940,64036,64132,64228), // uaWork
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaSpec
    (-1,62372,62372,62524,62524,62652,62652,62788,62788), // uaDie
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork1
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWorkEnd
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaEat
    (-1,62916,62980,63044,63108,62916,62980,63044,63108), // uaWalkArm
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkTool
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkBooty
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkTool2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkBooty2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1) // uaUnknown
  ),
  ( // utBarbarian
    (-1,64324,64388,64452,64516,64580,64644,64708,64772), // uaWalk
    (-1,64836,64932,65028,65124,65220,65316,65412,65508), // uaWork
    (-1,65604,65668,65732,65796,65860,65924,65988,66052), // uaSpec
    (-1,9812,9812,9940,9940,10052,10052,10172,10172), // uaDie
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork1
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWorkEnd
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaEat
    (-1,49700,49764,49828,49892,49700,49764,49828,49892), // uaWalkArm
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkTool
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkBooty
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkTool2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkBooty2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1) // uaUnknown
  ),
  ( // utPeasant
    (-1,66116,66180,66244,66308,66372,66436,66500,66564), // uaWalk
    (-1,66628,66724,66820,66916,67012,67108,67204,67300), // uaWork
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaSpec
    (-1,9812,9812,9940,9940,10052,10052,10172,10172), // uaDie
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork1
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWorkEnd
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaEat
    (-1,59684,59748,59812,59876,59684,59748,59812,59876), // uaWalkArm
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkTool
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkBooty
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkTool2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkBooty2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1) // uaUnknown
  ),
  ( // utSlingshot
    (-1,67396,67460,67524,67588,67652,67716,67780,67844), // uaWalk
    (-1,67908,68148,68388,68628,68868,69108,69348,69588), // uaWork
    (-1,69828,69828,69828,69828,69828,69828,69828,69828), // uaSpec
    (-1,9812,9812,9940,9940,10052,10052,10172,10172), // uaDie
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork1
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWorkEnd
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaEat
    (-1,55524,55588,55652,55716,55524,55588,55652,55716), // uaWalkArm
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkTool
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkBooty
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkTool2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkBooty2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1) // uaUnknown
  ),
  ( // utMetalBarbarian
    (-1,69868,69932,69996,70060,70124,70188,70252,70316), // uaWalk
    (-1,70380,70476,70572,70668,70764,70860,70956,71052), // uaWork
    (-1,71148,71212,71276,71340,71404,71468,71532,71596), // uaSpec
    (-1,9812,9812,9940,9940,10052,10052,10172,10172), // uaDie
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork1
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWorkEnd
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaEat
    (-1,49700,49764,49828,49892,49700,49764,49828,49892), // uaWalkArm
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkTool
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkBooty
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkTool2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkBooty2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1) // uaUnknown
  ),
  ( // utHorseman
    (-1,71660,71708,71756,71804,71852,71900,71948,71996), // uaWalk
    (-1,72044,72140,72236,72332,72428,72524,72620,72716), // uaWork
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaSpec
    (-1,62372,62372,62524,62524,62652,62652,62788,62788), // uaDie
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork1
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWorkEnd
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaEat
    (-1,62916,62980,63044,63108,62916,62980,63044,63108), // uaWalkArm
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkTool
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkBooty
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkTool2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkBooty2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1) // uaUnknown
  ),
  ( // utWolf
    (-1,72812,72876,72940,73004,73068,73132,73196,73260), // uaWalk
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaSpec
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaDie
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork1
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWorkEnd
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaEat
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkArm
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkTool
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkBooty
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkTool2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkBooty2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1) // uaUnknown
  ),
  ( // utFish
    (-1,73324,73372,73420,73468,73516,73564,73612,73660), // uaWalk
    (-1,73708,73756,73804,73852,73900,73948,73996,74044), // uaWork
    (-1,74092,74140,74188,74236,74284,74332,74380,74428), // uaSpec
    (-1,74476,74524,74572,74620,74668,74716,74764,74812), // uaDie
    (-1,74860,74908,74956,75004,75052,75100,75148,75196), // uaWork1
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWorkEnd
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaEat
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkArm
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkTool
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkBooty
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkTool2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkBooty2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1) // uaUnknown
  ),
  ( // utWatersnake
    (-1,75244,75292,75340,75388,75436,75484,75532,75580), // uaWalk
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaSpec
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaDie
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork1
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWorkEnd
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaEat
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkArm
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkTool
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkBooty
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkTool2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkBooty2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1) // uaUnknown
  ),
  ( // utSeastar
    (-1,75628,75628,75628,75628,75628,75628,75628,75628), // uaWalk
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaSpec
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaDie
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork1
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWorkEnd
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaEat
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkArm
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkTool
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkBooty
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkTool2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkBooty2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1) // uaUnknown
  ),
  ( // utCrab
    (-1,75692,75692,75692,75692,75692,75692,75692,75692), // uaWalk
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaSpec
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaDie
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork1
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWorkEnd
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaEat
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkArm
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkTool
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkBooty
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkTool2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkBooty2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1) // uaUnknown
  ),
  ( // utWaterflower
    (-1,75724,75724,75724,75724,75724,75724,75724,75724), // uaWalk
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaSpec
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaDie
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork1
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWorkEnd
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaEat
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkArm
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkTool
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkBooty
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkTool2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkBooty2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1) // uaUnknown
  ),
  ( // utWaterleaf
    (-1,75772,75772,75772,75772,75772,75772,75772,75772), // uaWalk
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaSpec
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaDie
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork1
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWorkEnd
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaEat
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkArm
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkTool
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkBooty
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkTool2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkBooty2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1) // uaUnknown
  ),
  ( // utDuck
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalk
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaSpec
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaDie
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork1
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWork2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWorkEnd
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaEat
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkArm
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkTool
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkBooty
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkTool2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1), // uaWalkBooty2
    (-1,-1,-1,-1,-1,-1,-1,-1,-1) // uaUnknown
  )
);
begin
  if INTERPOLATED_ANIMS then
  begin
    Result := ACTION_INTERP_LOOKUP[aUnit, aAct, aDir];
  end
  else
    Result := -1;
end;


end.
