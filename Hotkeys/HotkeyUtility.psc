scriptname HotkeyUtilityScript extends Quest


struct SuppressorData
	ObjectMod PreferredMuzzle
	ObjectMod SuppressorMuzzle
endstruct


Actor property PlayerRef auto const mandatory

;/
Weapon property _10mm auto
ObjectMod property mod_10mm_Muzzle_Compensator auto
ObjectMod property mod_10mm_Muzzle_MuzzleBrake auto
ObjectMod property mod_10mm_Muzzle_Suppressor auto
FormList property _10mm_Muzzle_AttachPriorityList

Weapon property AssaultRifle auto
ObjectMod property mod_AssaultRifle_Muzzle_Compensator auto
ObjectMod property mod_AssaultRifle_Muzzle_MuzzleBrake auto
ObjectMod property mod_AssaultRifle_Muzzle_Suppressor auto
FormList property AssaultRifle_Muzzle_AttachPriorityList

Weapon property CombatRifle auto
ObjectMod property mod_CombatRifle_Muzzle_BayonetLarge auto
ObjectMod property mod_CombatRifle_Muzzle_Compensator auto
ObjectMod property mod_CombatRifle_Muzzle_MuzzleBrake auto
ObjectMod property mod_CombatRifle_Muzzle_Suppressor auto
FormList property CombatRifle_Muzzle_AttachPriorityList

Weapon property CombatShotgun auto
ObjectMod property mod_CombatShotgun_Muzzle_BayonetLarge auto
ObjectMod property mod_CombatShotgun_Muzzle_Compensator auto
ObjectMod property mod_CombatShotgun_Muzzle_MuzzleBrake auto
ObjectMod property mod_CombatShotgun_Muzzle_Suppressor auto
FormList property CombatShotgun_Muzzle_AttachPriorityList

Weapon property Deliverer auto
ObjectMod property mod_Deliverer_Suppressor auto
FormList property Deliverer_Muzzle_AttachPriorityList

Weapon property GaussRifle auto
ObjectMod property mod_GaussRifle_Muzzle_Compensator auto
ObjectMod property mod_GaussRifle_Muzzle_Suppressor auto
FormList property GaussRifle_Muzzle_AttachPriorityList

Weapon property HuntingRifle auto
ObjectMod property mod_HuntingRifle_Muzzle_BayonetLarge auto
ObjectMod property mod_HuntingRifle_Muzzle_Compensator auto
ObjectMod property mod_HuntingRifle_Muzzle_MuzzleBrake auto
ObjectMod property mod_HuntingRifle_Muzzle_Suppressor auto
FormList property HuntingRifle_Muzzle_AttachPriorityList

Weapon property PipeBoltAction auto
ObjectMod property mod_PipeBoltAction_Muzzle_BayonetSmall auto
ObjectMod property mod_PipeBoltAction_Muzzle_BayonetLarge auto
ObjectMod property mod_PipeBoltAction_Muzzle_Compensator auto
ObjectMod property mod_PipeBoltAction_Muzzle_MuzzleBrake auto
ObjectMod property mod_PipeBoltAction_Muzzle_Suppressor auto
FormList property PipeBoltAction_Muzzle_AttachPriorityList

Weapon property PipeGun auto
ObjectMod property mod_PipeGun_Muzzle_BayonetSmall auto
ObjectMod property mod_PipeGun_Muzzle_BayonetLarge auto
ObjectMod property mod_PipeGun_Muzzle_Compensator auto
ObjectMod property mod_PipeGun_Muzzle_MuzzleBrake auto
ObjectMod property mod_PipeGun_Muzzle_Suppressor auto
FormList property PipeGun_Muzzle_AttachPriorityList

Weapon property PipeRevolver auto
ObjectMod property mod_PipeRevolver_Muzzle_BayonetSmall auto
ObjectMod property mod_PipeRevolver_Muzzle_BayonetLarge auto
ObjectMod property mod_PipeRevolver_Muzzle_Compensator auto
ObjectMod property mod_PipeRevolver_Muzzle_MuzzleBrake auto
ObjectMod property mod_PipeRevolver_Muzzle_Suppressor auto
FormList property PipeRevolver_Muzzle_AttachPriorityList

Weapon property SubmachineGun auto
ObjectMod property mod_SubmachineGun_Muzzle_Compensator auto
ObjectMod property mod_SubmachineGun_Muzzle_MuzzleBrake auto
ObjectMod property mod_SubmachineGun_Muzzle_Suppressor auto
FormList property SubmachineGun_Muzzle_AttachPriorityList
/;

FormList property WeaponsWithSuppressorList auto const mandatory

Form[] property WeaponSlots auto

Form property LastUsedChem auto hidden
Form property LastUsedUnarmedWeapon auto hidden
Form property LastUsedMeleeWeapon auto hidden
Form property LastUsedPistol auto hidden
Form property LastUsedRifle auto hidden
Form property LastUsedAutomaticGun auto hidden
Form property LastUsedSniperRifle auto hidden
Form property LastUsedHeavyGun auto hidden

Form property PreviousWeapon auto hidden

Message property HotkeyAssignedMessage const mandatory auto

function TryEquipItem(Actor akActor, Form akItem)
	if (akItem && PlayerRef.GetItemCount(akItem) > 0)
		akActor.EquipItem(akItem, false, true)
	endif
endfunction
function TryUnequipItem(Actor akActor, Form akItem)
	if (akItem && PlayerRef.GetItemCount(akItem) > 0)
		akActor.UnequipItem(akItem, false, true)
	endif
endfunction

function PlayerEquipItem(Form akItem1, Form akItem2 = none, Form akItem3 = none, Form akItem4 = none, Form akItem5 = none, Form akItem6 = none)
	TryEquipItem(PlayerRef, akItem1)
	TryEquipItem(PlayerRef, akItem2)
	TryEquipItem(PlayerRef, akItem3)
	TryEquipItem(PlayerRef, akItem4)
	TryEquipItem(PlayerRef, akItem5)
	TryEquipItem(PlayerRef, akItem6)
endfunction
function PlayerEquipCustomItem(int aiFormID, string asFilename)
	PlayerEquipItem(Game.GetFormFromFile(aiFormID, asFilename))
endfunction

function PlayerCastSpellSelf(Spell akSpellToCast, Keyword akDispelKeyword = none)
	if (akSpellToCast)
		if (PlayerRef.HasMagicEffectWithKeyword(akDispelKeyword))
			PlayerRef.DispelSpell(akSpellToCast)
		else
			akSpellToCast.Cast(PlayerRef)
		endif
	endif
endfunction
function PlayerCastCustomSpellSelf(int aiPrimaryFormID, string asPrimaryFilename, int aiSecondaryFormID = 0, string asSecondaryFilename = "")
	PlayerCastSpellSelf(Game.GetFormFromFile(aiPrimaryFormID, asPrimaryFilename) as Spell, Game.GetFormFromFile(aiSecondaryFormID, asSecondaryFilename) as Keyword)
endfunction

int WestTek_TacticalGogglesBase_ID = 0x002E67 const
int WestTek_TacticalGogglesBase_Forehead_ID = 0x0089B8 const
int WestTek_TacticalEyepiece01Base_ID = 0x002E68 const
int WestTek_TacticalEyepiece01Base_Forehead_ID = 0x0089BA const
string WestTekTacticalOptics_ESP = "WestTekTacticalOptics.esp" const
function PlayerToggleWestTekHeadGear()
	Armor tacticalGogglesBase = Game.GetFormFromFile(WestTek_TacticalGogglesBase_ID, WestTekTacticalOptics_ESP) as Armor
	Armor tacticalGogglesBaseForehead = Game.GetFormFromFile(WestTek_TacticalGogglesBase_Forehead_ID, WestTekTacticalOptics_ESP) as Armor
	Armor tacticalEyepieceBase = Game.GetFormFromFile(WestTek_TacticalEyepiece01Base_ID, WestTekTacticalOptics_ESP) as Armor
	Armor tacticalEyepieceBaseForehead = Game.GetFormFromFile(WestTek_TacticalEyepiece01Base_Forehead_ID, WestTekTacticalOptics_ESP) as Armor

	if (PlayerRef.IsEquipped(tacticalGogglesBase))
		if (PlayerRef.GetItemCount(tacticalGogglesBaseForehead) > 0)
			TryEquipItem(PlayerRef, tacticalGogglesBaseForehead)
		else
			TryUnequipItem(PlayerRef, tacticalGogglesBase)
		endif
	elseif (PlayerRef.IsEquipped(tacticalGogglesBaseForehead))
		TryEquipItem(PlayerRef, tacticalGogglesBase)
	elseif (PlayerRef.IsEquipped(tacticalEyepieceBase))
		if (PlayerRef.GetItemCount(tacticalEyepieceBaseForehead) > 0)
			TryEquipItem(PlayerRef, tacticalEyepieceBaseForehead)
		else
			TryUnequipItem(PlayerRef, tacticalEyepieceBase)
		endif
	elseif (PlayerRef.IsEquipped(tacticalEyepieceBaseForehead))
		TryEquipItem(PlayerRef, tacticalEyepieceBase)
	elseif (PlayerRef.GetItemCount(tacticalGogglesBase))
		TryEquipItem(PlayerRef, tacticalGogglesBase)
	elseif (PlayerRef.GetItemCount(tacticalEyepieceBase))
		TryEquipItem(PlayerRef, tacticalEyepieceBase)
	endif
endfunction

function AssignWeaponHotkey(int aiIndex)
	if (aiIndex > 0 && aiIndex <= WeaponSlots.Length)
		Weapon equippedWeapon = PlayerRef.GetEquippedWeapon()
		if (equippedWeapon)
			WeaponSlots[aiIndex - 1] = equippedWeapon
			HotkeyAssignedMessage.Show(aiIndex as float)
			Debug.Trace(equippedWeapon + " assigned to slot " + aiIndex + ".")
		endif
	endif
endfunction
function EquipWeaponHotkey(int aiIndex)
	if (aiIndex > 0 && aiIndex <= WeaponSlots.Length)
		PlayerEquipItem(WeaponSlots[aiIndex - 1])
	endif
endfunction

function PlayerToggleEquipItem(Form akPrimaryItem, Form akSecondaryItem = none)
	if (!PlayerRef.IsEquipped(akPrimaryItem))
		PlayerRef.UnequipItem(akSecondaryItem, false, true)
		PlayerEquipItem(akPrimaryItem)
	else
		PlayerRef.UnequipItem(akPrimaryItem, false, true)
		PlayerEquipItem(akSecondaryItem)
	endif
endfunction
function PlayerToggleEquipCustomItem(int aiPrimaryFormID, string asPrimaryFilename, int aiSecondaryFormID = 0, string asSecondaryFilename = "")
	PlayerToggleEquipItem(Game.GetFormFromFile(aiPrimaryFormID, asPrimaryFilename), Game.GetFormFromFile(aiSecondaryFormID, asSecondaryFilename))
endfunction

function PlayerEquipLastUsedItem(string asIdentifier)
	if (asIdentifier == "Chem")
		PlayerEquipItem(LastUsedChem)
	elseif (asIdentifier == "UnarmedWeapon")
		PlayerEquipItem(LastUsedUnarmedWeapon)
	elseif (asIdentifier == "MeleeWeapon")
		PlayerEquipItem(LastUsedMeleeWeapon)
	elseif (asIdentifier == "Pistol")
		PlayerEquipItem(LastUsedPistol)
	elseif (asIdentifier == "Rifle")
		PlayerEquipItem(LastUsedRifle)
	elseif (asIdentifier == "AutomaticGun")
		PlayerEquipItem(LastUsedAutomaticGun)
	elseif (asIdentifier == "SniperRifle")
		PlayerEquipItem(LastUsedSniperRifle)
	elseif (asIdentifier == "HeavyGun")
		PlayerEquipItem(LastUsedHeavyGun)
	else
		Debug.Notification("EquipLastUsedItem: Unknown identifier '" + asIdentifier + "'")
	endif
endfunction

function PlayerEquipPreviousWeapon()
	PlayerEquipItem(PreviousWeapon)
endfunction

SuppressorData function GetSuppressorDataForWeapon(Weapon akWeapon)
	int i = 0
	while (i < WeaponsWithSuppressorList.GetSize())
		if (WeaponsWithSuppressorList.GetAt(i) == akWeapon)
			FormList muzzleList = WeaponsWithSuppressorList.GetAt(i + 1) as FormList
			SuppressorData data = new SuppressorData
			data.SuppressorMuzzle = muzzleList.GetAt(0) as ObjectMod
			int j = 0
			while (j < muzzleList.GetSize())
				Form muzzle = muzzleList.GetAt(j)
				if (PlayerRef.GetItemCount(muzzle) > 0)
					data.PreferredMuzzle = muzzle as ObjectMod
					return data
				endif
				j += 1
			endwhile
			return data
		endif
		i += 2
	endwhile
	return none
endfunction
function PlayerAttachSilencer()
	Weapon kWeapon = PlayerRef.GetEquippedWeapon()
	SuppressorData data = GetSuppressorDataForWeapon(kWeapon)
	if (data)
		if (data.PreferredMuzzle)
			PlayerRef.AttachModToInventoryItem(kWeapon, data.PreferredMuzzle)
		else
			PlayerRef.RemoveModFromInventoryItem(kWeapon, data.SuppressorMuzzle)
		endif
	endif
endfunction

function PlayHolotapeOnPipBoy(Holotape akHolotape, Terminal akTerminal)
	if (PlayerRef.GetItemCount(akHolotape) > 0)
		Game.ForceFirstPerson()
		akTerminal.ShowOnPipBoy()
	endif
endfunction
