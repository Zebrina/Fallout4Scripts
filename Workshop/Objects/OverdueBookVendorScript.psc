scriptname Zebrina:Workshop:Objects:OverdueBookVendorScript extends DN011OverdueBookVendingMachineSCRIPT conditional

struct PotentialItemAndCount
    Form baseItem
    int countMin = 1
    int countMax = 1
    int costMult = 1
endstruct

group BookReturnStation_Properties
    GlobalVariable property WorkshopOverdueBookVendMachine_ResetDays auto const mandatory
    GlobalVariable property WorkshopOverdueBookVendMachine_LastReset auto const mandatory
    Quest property WorkshopOverdueBookVendPrizeQuest auto const mandatory
    ReferenceAlias[] property PrizeItemAliases auto const mandatory
endgroup

group BookReturnTerminal_Properties
    Terminal property WorkshopOverdueBookVendTerminal auto const mandatory
    ReferenceAlias property AliasToForceTerminalRefTo auto const mandatory
    { Required to do initialization normally done by a script attached to the terminal. }
endgroup

string sRefAttachNode = "REF_ATTACH_NODE" const

float lastInventoryReset = -1.0
bool isActivated = false

;/
function ResetTerminalPosition()
    ObjectReference myTerminal = self.GetLinkedRef()
    ;myTerminal.SetAngle(self.GetAngleX(), self.GetAngleY(), self.GetAngleZ())
    myTerminal.MoveToNode(self, sRefAttachNode)
endfunction
/;

auto state RunOnLoad
    ; DN011OverdueBookVendingMachineSCRIPT override.
    event OnLoad()
        GoToState("DontRunOnLoad")
    endevent
endstate
;/
state DontRunOnLoad
    ; DN011OverdueBookVendingMachineSCRIPT override.
	event OnLoad()
        ResetTerminalPosition()
	endevent
endstate
/;

event OnActivate(ObjectReference akActionRef)
    if (isActivated == false && akActionRef == Game.GetPlayer())
        isActivated = true
        ; Force our terminal into whatever alias it needs to be and update our info with the latest counts.
        ; We need to do this here since we blocked activation on our terminal to restrict activation to only when powered.
        ObjectReference myTerminal = self.GetLinkedRef()
        AliasToForceTerminalRefTo.ForceRefTo(myTerminal)
        self.UpdateTotalItemCountAndAliases()
        ; Finally do default activation on our terminal.
        myTerminal.Activate(akActionRef, true)
        isActivated = false
    endif
endevent

event ObjectReference.OnActivate(ObjectReference akSender, ObjectReference akActionRef)
    ; Activate ourself instead of the terminal to trigger player comments when activating without power.
    self.Activate(akActionRef)
endevent

event OnWorkshopObjectPlaced(ObjectReference akReference)
    ObjectReference myTerminal = self.PlaceAtNode(sRefAttachNode, WorkshopOverdueBookVendTerminal, abAttach = true)
    ; Link self to terminal both and vice versa. Required by the base script.
    myTerminal.SetLinkedRef(self)
    self.SetLinkedRef(myTerminal)
    ; Block activation and register for OnActivate events to check our power state before activation.
    myTerminal.BlockActivation()
    self.RegisterForRemoteevent(myTerminal, "OnActivate")

    ;HandlePowerStateChange()
endevent
;/
event OnWorkshopObjectGrabbed(ObjectReference akReference)
    self.GetLinkedRef().DisableNoWait()
endevent
event OnWorkshopObjectMoved(ObjectReference akReference)
    if (self.IsPowered())
        ResetTerminalPosition()
        self.GetLinkedRef().EnableNoWait()
    endif
endevent
/;
event OnWorkshopObjectDestroyed(ObjectReference akActionRef)
    ObjectReference myTerminal = self.GetLinkedRef()
    myTerminal.DisableNoWait()
    myTerminal.Delete()
endevent

; DN011OverdueBookVendingMachineSCRIPT override.
function UpdateTotalItemCountAndAliases()
    float gameTime = Utility.GetCurrentGameTime()
    float lastGlobalInventoryReset = WorkshopOverdueBookVendMachine_LastReset.GetValue()
    if (lastGlobalInventoryReset < 0.0 || (gameTime > lastGlobalInventoryReset + WorkshopOverdueBookVendMachine_ResetDays.GetValue()))
        WorkshopOverdueBookVendPrizeQuest.Stop()
        WorkshopOverdueBookVendPrizeQuest.Start()

        WorkshopOverdueBookVendMachine_LastReset.SetValue(gameTime)
        lastGlobalInventoryReset = gameTime
    endif
    if (lastInventoryReset < lastGlobalInventoryReset)
        self.ItemsInMachine = new ItemAndCount[0]
        int i = 0
        while (i < PrizeItemAliases.Length)
            if (PrizeItemAliases[i].GetReference() != none)
                Zebrina:Workshop:Objects:OverdueBookVendorPrizeItem prizeItem = PrizeItemAliases[i] as Zebrina:Workshop:Objects:OverdueBookVendorPrizeItem
                self.ItemsInMachine.Add(prizeItem.ConvertToItemAndCount(self))
            endif
            i += 1
        endwhile

        lastInventoryReset = lastGlobalInventoryReset
    endif

    parent.UpdateTotalItemCountAndAliases()
endfunction
