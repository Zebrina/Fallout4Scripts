scriptname Zebrina:Hotkeys:HotkeyMasterScript extends Quest

CustomEvent HotkeyInvoke
CustomEvent HotkeyInvokeCustom
;CustomEvent HotkeyAssign

struct HotkeyAssignmentMessage
    string command
    Message messageToShow
endstruct

struct HotkeyAssignment
    string command
    ReferenceAlias equipActor
    Message invokeMessage
    bool toggleEquipped
    Form item1
    Form item2
    Form item3
    Form item4
    Form item5
endstruct

group AutoFill_Properties
    ReferenceAlias property Player auto const mandatory
    ReferenceAlias property Companion auto const mandatory
endgroup

group Message_Properties
    Message property HotkeyAssignmentMode_SuccessfulMessage auto const mandatory
    Message property HotkeyAssignmentMode_CancelMessage auto const mandatory
    Message property HotkeyAssignmentMode_ErrorMessage auto const mandatory
    HotkeyAssignmentMessage[] property HotkeyAssignmentModeMessages auto const mandatory
endgroup

HotkeyAssignment[] property Hotkeys auto hidden

;/
int iHasWornSlot30_HairTop = 0 conditional
;int iHasWornSlot31_HairLong = 0 conditional
int iHasWornSlot33_BODY = 0 conditional
int iHasWornSlot34_LHand = 0 conditional
;int iHasWornSlot35_RHand = 0 conditional
;int iHasWornSlot36_Underarmor_Torso = 0 conditional
;int iHasWornSlot37_Underarmor_LArm = 0 conditional
;int iHasWornSlot38_Underarmor_RArm = 0 conditional
;int iHasWornSlot39_Underarmor_LLeg = 0 conditional
;int iHasWornSlot40_Underarmor_RLeg = 0 conditional
int iHasWornSlot41_Overarmor_Torso = 0 conditional
int iHasWornSlot42_Overarmor_LArm = 0 conditional
int iHasWornSlot43_Overarmor_RArm = 0 conditional
int iHasWornSlot44_Overarmor_LLeg = 0 conditional
int iHasWornSlot45_Overarmor_RLeg = 0 conditional
int iHasWornSlot46_Headband = 0 conditional
int iHasWornSlot47_Eyes = 0 conditional
;int iHasWornSlot48_Beard = 0 conditional
int iHasWornSlot49_Mouth = 0 conditional
int iHasWornSlot50_Neck = 0 conditional
int iHasWornSlot51_Ring = 0 conditional
int iHasWornSlot54_Unnamed = 0 conditional
int iHasWornSlot55_Unnamed = 0 conditional
int iHasWornSlot56_Unnamed = 0 conditional
int iHasWornSlot57_Unnamed = 0 conditional
int iHasWornSlot58_Unnamed = 0 conditional
int iHasWornSlot61_FX = 0 conditional
/;

event OnInit()
    Hotkeys = new HotkeyAssignment[0]
endevent

bool function ActorEquipItemInternal(Actor akActor, Form akItem)
	if (akItem && akActor.GetItemCount(akItem) > 0)
		akActor.EquipItem(akItem, abSilent = true)
        return true
	endif
    return false
endfunction
bool function ActorUnequipItemInternal(Actor akActor, Form akItem)
	if (akItem && akActor.GetItemCount(akItem) > 0)
		akActor.UnequipItem(akItem, abSilent = true)
        return true
	endif
    return false
endfunction

function ActorEquipItem(Actor akActor, Form akItem1, Form akItem2 = none, Form akItem3 = none, Form akItem4 = none, Form akItem5 = none, bool abToggleEquipped = false)
    if (abToggleEquipped && akActor.IsEquipped(akItem1))
        ActorUnequipItemInternal(akActor, akItem1)
    else
        ActorEquipItemInternal(akActor, akItem1)
    endif
    if (akItem2 != none)
        if (abToggleEquipped && akActor.IsEquipped(akItem2))
            ActorUnequipItemInternal(akActor, akItem2)
        else
            ActorEquipItemInternal(akActor, akItem2)
        endif
    endif
    if (akItem3 != none)
        if (abToggleEquipped && akActor.IsEquipped(akItem3))
            ActorUnequipItemInternal(akActor, akItem3)
        else
            ActorEquipItemInternal(akActor, akItem3)
        endif
    endif
    if (akItem4 != none)
        if (abToggleEquipped && akActor.IsEquipped(akItem4))
            ActorUnequipItemInternal(akActor, akItem4)
        else
            ActorEquipItemInternal(akActor, akItem4)
        endif
    endif
    if (akItem5 != none)
        if (abToggleEquipped && akActor.IsEquipped(akItem5))
            ActorUnequipItemInternal(akActor, akItem5)
        else
            ActorEquipItemInternal(akActor, akItem5)
        endif
    endif
endfunction
function ActorEquipItemWithPriority(Actor akActor, Form akItem1, Form akItem2 = none, Form akItem3 = none, Form akItem4 = none, Form akItem5 = none)
	ActorEquipItemInternal(akActor, akItem1) \
    || ActorEquipItemInternal(akActor, akItem2) \
    || ActorEquipItemInternal(akActor, akItem3) \
    || ActorEquipItemInternal(akActor, akItem4) \
	|| ActorEquipItemInternal(akActor, akItem5)
endfunction

function PlayerEquipItem(Form akItem1, Form akItem2 = none, Form akItem3 = none, Form akItem4 = none, Form akItem5 = none)
    ActorEquipItem(Game.GetPlayer(), akItem1, akItem2, akItem3, akItem4, akItem5)
endfunction
function PlayerEquipItemWithPriority(Form akItem1, Form akItem2 = none, Form akItem3 = none, Form akItem4 = none, Form akItem5 = none)
	ActorEquipItemWithPriority(Game.GetPlayer(), akItem1, akItem2, akItem3, akItem4, akItem5)
endfunction

function CompanionEquipItem(Form akItem1, Form akItem2 = none, Form akItem3 = none, Form akItem4 = none, Form akItem5 = none)
    Actor companionActor = Companion.GetActorReference()
    if (companionActor != none)
        ActorEquipItem(companionActor, akItem1, akItem2, akItem3, akItem4, akItem5)
    endif
endfunction

function Invoke(string command)
    ; Empty definition.
endfunction
function InvokeCustom(string command)
    ; Empty definition.
endfunction
function StartAssignmentMode(string command)
    ; Empty definition.
endfunction

string commandToAssign = ""

auto state UsageMode
    function StartAssignmentMode(string command)
        GoToState("Busy")

        HotkeyAssignmentModeMessages

        commandToAssign = command
        int messageIndex = HotkeyAssignmentModeMessages.FindStruct("command", command)
        if (messageIndex >= 0)
            HotkeyAssignmentModeMessages[messageIndex].messageToShow.Show()
        endif

        GoToState("AssignmentMode")
    endfunction

    function Invoke(string command)
        GoToState("Busy")

        int index = Hotkeys.FindStruct("command", command)
        if (index >= 0)
            HotkeyAssignment hotkey = Hotkeys[index]

            ActorEquipItem(hotkey.equipActor.GetActorReference(), hotkey.item1, hotkey.item2, hotkey.item3, hotkey.item4, hotkey.item5, hotkey.toggleEquipped)

            var[] args = new var[1]
            args[0] = hotkey
            self.SendCustomEvent("HotkeyInvoke", args)
        endif

        GoToState("UsageMode")
    endfunction

    function InvokeCustom(string command)
        GoToState("Busy")

        var[] args = new var[1]
        args[0] = command
        self.SendCustomEvent("HotkeyInvokeCustom", args)

        GoToState("UsageMode")
    endfunction
endstate

state AssignmentMode
    function Invoke(string command)
        GoToState("Busy")

        if (command == "Cancel")
            HotkeyAssignmentMode_CancelMessage.Show()
        else
            HotkeyAssignment hotkey = new HotkeyAssignment
            hotkey.command = command

            bool registrationSuccessful = false
            Actor playerActor = Game.GetPlayer()

            if (commandToAssign == "PlayerWeapon")
                hotkey.equipActor = Player
                hotkey.toggleEquipped = false
                hotkey.item1 = playerActor.GetEquippedWeapon()

                registrationSuccessful = hotkey.item1 != none
            elseif (commandToAssign == "PlayerGrenade")
                hotkey.equipActor = Player
                hotkey.toggleEquipped = false
                hotkey.item1 = playerActor.GetEquippedWeapon(2)

                registrationSuccessful = hotkey.item1 != none
            elseif (commandToAssign == "PlayerOutfit")
                hotkey.equipActor = Player
                hotkey.toggleEquipped = false
                hotkey.item1 = playerActor.GetWornItem(3).Item
                hotkey.item2 = playerActor.GetWornItem(4).Item
                hotkey.item3 = playerActor.GetWornItem(16).Item
                hotkey.item4 = playerActor.GetWornItem(20).Item
                hotkey.item5 = playerActor.GetWornItem(21).Item

                registrationSuccessful = hotkey.item1 != none || hotkey.item2 != none || hotkey.item3 != none || hotkey.item4 != none || hotkey.item5 != none
            elseif (commandToAssign == "PlayerArmor")
                hotkey.equipActor = Player
                hotkey.toggleEquipped = false
                hotkey.item1 = playerActor.GetWornItem(11).Item
                hotkey.item2 = playerActor.GetWornItem(12).Item
                hotkey.item3 = playerActor.GetWornItem(13).Item
                hotkey.item4 = playerActor.GetWornItem(14).Item
                hotkey.item5 = playerActor.GetWornItem(15).Item

                registrationSuccessful = hotkey.item1 != none || hotkey.item2 != none || hotkey.item3 != none || hotkey.item4 != none || hotkey.item5 != none
            elseif (commandToAssign == "PlayerHelmet")
                hotkey.equipActor = Player
                hotkey.toggleEquipped = true
                hotkey.item1 = playerActor.GetWornItem(0).Item

                registrationSuccessful = hotkey.item1 != none
            elseif (commandToAssign == "PlayerGoggles")
                hotkey.equipActor = Player
                hotkey.toggleEquipped = true
                hotkey.item1 = playerActor.GetWornItem(17).Item

                registrationSuccessful = hotkey.item1 != none
            elseif (commandToAssign == "CompanionWeapon")
                hotkey.equipActor = Companion
                hotkey.toggleEquipped = false
                hotkey.item1 = Companion.GetActorReference().GetEquippedWeapon()

                registrationSuccessful = hotkey.item1 != none
            endif

            if (registrationSuccessful)
                int index = Hotkeys.FindStruct("command", command)
                if (index >= 0)
                    Hotkeys[index] = hotkey
                else
                    Hotkeys.Add(hotkey)
                endif

                HotkeyAssignmentMode_SuccessfulMessage.Show()
            else
                HotkeyAssignmentMode_ErrorMessage.Show()
            endif
        endif

        GoToState("UsageMode")
    endfunction
endstate

state Busy
endstate
