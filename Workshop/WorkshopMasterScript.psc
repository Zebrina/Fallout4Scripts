scriptname Zebrina:Workshop:WorkshopMasterScript extends Quest conditional

import WorkshopDataScript

group Initialization_Properties
    Armor property Pipboy auto const mandatory
endgroup

;/
group AutoFill_Properties
	FormList property CA_JunkItems auto const mandatory
	FormList property lootItemsRare auto const mandatory
	FormList property DLC05PitchingMachineList auto const mandatory
endgroup
/;

group TimeScale_Properties
	GlobalVariable property TimeScale auto const mandatory
	float property fDesiredTimeScale = 6.0 auto const
	Message property TimeScaleChanged auto const mandatory
endgroup

group Workshop_Properties
	WorkshopParentScript property WorkshopParent auto const mandatory
	DLC03:DLC03WorkshopParentScript property DLC03WorkshopParent auto const mandatory	; Far Harbor
	DLC04:DLC04WorkshopParentScript property DLC04WorkshopParent auto const mandatory	; Nuka World
	DLC06:DLC06WorkshopParent property DLC06WorkshopParent auto const mandatory			; Vault-Tec Workshop
endgroup

group Settings
	Holotape property SettingsHolotape auto const

	Quest property WorkshopHelperQuest auto const mandatory
endgroup

bool bModInitialized = false conditional
;bool bWorkshopCategoryInstalled = false conditional

string function GetModName() global
	return "ZebrinasWorkshop.esp"
endfunction
WorkshopMasterScript function GetScript() global
	return Game.GetFormFromFile(0x163113, GetModName()) as WorkshopMasterScript
endfunction

function SetTimeScale(float afValue, bool abVerbose = true)
	if (abVerbose)
		TimeScaleChanged.Show(TimeScale.GetValue(), afValue)
	endif
	TimeScale.SetValue(afValue)
endfunction
function InitializeMod()
    WorkshopHelperQuest.Start()

	Actor player = Game.GetPlayer()

	if (player.GetItemCount(SettingsHolotape) == 0)
		player.AddItem(SettingsHolotape)
	endif

    bModInitialized = true

	self.RegisterForRemoteEvent(player, "OnPlayerLoadGame")
	Update()
endfunction

event OnQuestInit()
	if (Game.GetPlayer().IsEquipped(Pipboy))
		InitializeMod()
	else
		self.RegisterForRemoteEvent(Game.GetPlayer(), "OnLocationChange")
	endif
endevent

event Actor.OnLocationChange(Actor akSender, Location akOldLoc, Location akNewLoc)
	if (akSender.IsEquipped(Pipboy))
		InitializeMod()
		self.UnregisterForRemoteEvent(akSender, "OnLocationChange")
	endif
endevent

function Update()
	if (bModInitialized && TimeScale.GetValue() != fDesiredTimeScale)
		SetTimeScale(fDesiredTimeScale)
	endif

	self.UnregisterForAllCustomEvents()
endfunction
event Actor.OnPlayerLoadGame(Actor akSender)
	Update()
endevent

;/

function InstallWorkshopCategory()
	if (WorkshopMenuMain.Find(ZebrinasWorkshopMenuMain) < 0)
		WorkshopMenuMain.AddForm(ZebrinasWorkshopMenuMain)
	endif
	bWorkshopCategoryInstalled = true
endfunction
function UninstallWorkshopCategory()
	if (WorkshopMenuMain.Find(ZebrinasWorkshopMenuMain) >= 0)
		WorkshopMenuMain.RemoveAddedForm(ZebrinasWorkshopMenuMain)
	endif
	bWorkshopCategoryInstalled = false
endfunction

bool function AddFoodType(ActorValue akResourceValue, LeveledItem akFoodObject)
	if (WorkshopParent.WorkshopFoodTypes.RFindStruct("resourceValue", akResourceValue) >= 0)
		return false
	endif

	WorkshopFoodType foodTypeEntry = new WorkshopFoodType
	foodTypeEntry.resourceValue = akResourceValue
	foodTypeEntry.foodObject = akFoodObject

	WorkshopParent.WorkshopFoodTypes.Add(foodTypeEntry)

	return true
endfunction
bool function RemoveFoodType(ActorValue akResourceValue)
	int foodTypeEntryIndex = WorkshopParent.WorkshopFoodTypes.RFindStruct("resourceValue", akResourceValue)
	if (foodTypeEntryIndex >= 0)
		WorkshopParent.WorkshopFoodTypes.Remove(foodTypeEntryIndex)
		return true
	endif

	return false
endfunction
/;
