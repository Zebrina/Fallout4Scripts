scriptname Zebrina:Items:SilenceableGunScript extends ObjectReference const

struct ObjectModData
    ObjectMod theMod
    Keyword modKeyword
    MiscObject modInventoryItem = none
endstruct

group AutoFill_Properties
    Zebrina:Hotkeys:HotkeyMasterScript property HotkeyMaster auto const mandatory
    Keyword property ma_CanHaveNullMuzzle auto const mandatory
    Keyword property dn_HasMuzzle_Null auto const mandatory
    ObjectMod property mod_Null_Muzzle auto const mandatory
endgroup

group ObjectMod_Properties
    ObjectModData[] property SilencerModPriorityList auto const mandatory
    { Lower index equals higher priority. }
    ObjectModData[] property NonSilencerModPriorityList auto const mandatory
    { Can be empty, but must be filled! Lower index equals higher priority. }
endgroup

group Message_Properties
    Message property SilencerAttachedMessage auto const mandatory
    Message property SilencerDetachedMessage auto const mandatory
endgroup

ObjectModData function FindFirstAttachedMuzzleMod(ObjectModData[] modPriorityList, bool includeNullMuzzle = false)
    if (self.HasKeyword(dn_HasMuzzle_Null))
        if (includeNullMuzzle)
            ObjectModData modData = new ObjectModData
            modData.theMod = mod_Null_Muzzle
            modData.modKeyword = dn_HasMuzzle_Null
            return modData
        endif

        return none
    endif

    int i = modPriorityList.Length
    while (i > 0)
        i -= 1
        ObjectModData modData = modPriorityList[i]

        if (self.HasKeyword(modData.modKeyword))
            return modData
        endif
    endwhile

    return none
endfunction
ObjectModData function FindFirstAvailableMuzzleMod(ObjectModData[] modPriorityList)
    Actor actorContainer = self.GetContainer() as Actor

    int i = modPriorityList.Length
    while (i > 0)
        i -= 1
        ObjectModData modData = modPriorityList[i]
        if (modData.modInventoryItem == none || actorContainer.GetItemCount(modData.modInventoryItem) > 0)
            return modData
        endif
    endwhile

    return none
endfunction

event OnEquipped(Actor akActor)
    if (akActor == Game.GetPlayer()); || akActor == FollowersScript.GetScript().Companion.GetActorReference())
        self.RegisterForCustomEvent(HotkeyMaster, "HotkeyInvokeCustom")
    endif
endevent
event OnUnequipped(Actor akActor)
    self.UnregisterForAllCustomEvents()
endevent

event Zebrina:Hotkeys:HotkeyMasterScript.HotkeyInvokeCustom(Zebrina:Hotkeys:HotkeyMasterScript akSender, var[] akArgs)
    string command = akArgs[0] as string

    if (command == "ToggleSilencer" && Game.IsFightingControlsEnabled())
        Actor actorContainer = self.GetContainer() as Actor

        ; Mods can be changed when the weapon is drawn, but just to be safe let's not. Also it looks more immersive anyway since there is no attach/detach animation.
        ;/
        if (actorContainer.IsWeaponDrawn())
            return
        endif
        /;

        ObjectModData silencerModData = FindFirstAttachedMuzzleMod(SilencerModPriorityList)
        if (silencerModData != none)
            ; We have a silencer attached. Add it's misc item.
            actorContainer.AddItem(silencerModData.modInventoryItem, abSilent = true)

            ObjectModData modData = FindFirstAvailableMuzzleMod(NonSilencerModPriorityList)
            if (modData != none)
                self.AttachMod(modData.theMod)
                actorContainer.RemoveItem(modData.modInventoryItem, abSilent = true)
            elseif (self.HasKeyword(ma_CanHaveNullMuzzle))
                self.AttachMod(mod_Null_Muzzle)
            else
                ; Can't have null muzzle and no muzzle to replace with.
                self.RemoveMod(silencerModData.theMod)
            endif

            SilencerDetachedMessage.Show()
        else
            ; We don't have a silencer attached. Find our silencer with highest priority.
            silencerModData = FindFirstAvailableMuzzleMod(SilencerModPriorityList)
            if (silencerModData != none)
                ; Our actor has a silencer mod in his/her inventory.
                ; Find our currently attached muzzle (if we have one) and add it's misc item to our actor's inventory.
                ObjectModData modData = FindFirstAttachedMuzzleMod(NonSilencerModPriorityList, true) ; Include null muzzle.
                if (modData != none && modData.theMod != mod_Null_Muzzle)
                    actorContainer.AddItem(modData.modInventoryItem, abSilent = true)
                endif

                ; Finally attach the silencer muzzle and remove it's misc item.
                self.AttachMod(silencerModData.theMod)
                actorContainer.RemoveItem(silencerModData.modInventoryItem, abSilent = true)

                SilencerAttachedMessage.Show()
            endif
        endif
    endif
endevent
