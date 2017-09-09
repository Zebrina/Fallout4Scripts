scriptname Zebrina:Items:DynamicModScript extends ObjectReference const

struct DynamicModData
    Keyword HasPrimaryModKeyword
    { The reference should have this keyword when the mod is attached. Make sure the primary mod adds the keyword. }
    FormList DynamicModList
    { The script will try to attach all mods in the list so each mod needs its own attach point as a child to the specific mod. }
endstruct

FormList property DynamicModList auto const mandatory
{ All dynamic mods need to be in this list. }
DynamicModData[] property Data auto const mandatory

event OnContainerChanged(ObjectReference akNewContainer, ObjectReference akOldContainer)
    Actor player = Game.GetPlayer()
    ; Npcs can't mod, so ...
    if (akNewContainer == player)
        self.RegisterForRemoteEvent(player, "OnPlayerModArmorWeapon")
    else
        self.UnregisterForRemoteEvent(player, "OnPlayerModArmorWeapon")
    endif
    UpdateDynamicMods()
endevent

event OnInit()
    self.RegisterForRemoteEvent(Game.GetPlayer(), "OnPlayerModArmorWeapon")
endevent

function UpdateDynamicMods()
    int i = 0
    while (i < Data.Length)
        DynamicModData d = Data[i]
        int j = 0
        if (self.HasKeyword(d.HasPrimaryModKeyword))
            while (j < d.DynamicModList.GetSize())
                self.AttachMod(d.DynamicModList.GetAt(j) as ObjectMod)
                j += 1
            endwhile
        else
            while (j < d.DynamicModList.GetSize())
                self.RemoveMod(d.DynamicModList.GetAt(j) as ObjectMod)
                j += 1
            endwhile
        endif
        i += 1
    endwhile
endfunction

event Actor.OnPlayerModArmorWeapon(Actor akSender, Form akBaseObject, ObjectMod akModBaseObject)
    ; Doesn't really matter if it not this specific reference that's being modded (We can't even tell cuz Bethesda). But we check the base object to avoid unneccesary updates.
    ; Very important to check if the mod being added is one of the dynamic mods, otherwise we'll trigger an endless loop.
    if (akBaseObject == self.GetBaseObject() && DynamicModList.Find(akModBaseObject) < 0)
        UpdateDynamicMods()
    endif
endevent
