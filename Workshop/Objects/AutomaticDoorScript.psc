scriptname Zebrina:Workshop:Objects:AutomaticDoorScript extends ObjectReference

Keyword property WorkshopLinkAutomaticDoorTrigger auto const mandatory
Activator property AutomaticDoorTriggerVolume auto const mandatory
string property sAttachNodeName auto const mandatory
{ Preferably the root node. }

event OnWorkshopObjectDestroyed(ObjectReference akActionRef)
    ObjectReference myTriggerVolume = self.GetLinkedRef(WorkshopLinkAutomaticDoorTrigger)
    if (myTriggerVolume)
        myTriggerVolume.DisableNoWait()
        myTriggerVolume.Delete()
    endif
endevent

event ObjectReference.OnTriggerEnter(ObjectReference akSender, ObjectReference akActionRef)
    HandleTriggerEvent(akSender, akActionRef, true)
endevent
event ObjectReference.OnTriggerLeave(ObjectReference akSender, ObjectReference akActionRef)
    HandleTriggerEvent(akSender, akActionRef, false)
endevent

function HandleTriggerEvent(ObjectReference akTriggerVolume, ObjectReference akActionRef, bool abEntered)
endfunction

auto state ScriptInitState
    event OnLoad()
        ObjectReference myTriggerVolume = self.PlaceAtNode(sAttachNodeName, AutomaticDoorTriggerVolume, abAttach = true)
        self.SetLinkedRef(myTriggerVolume, WorkshopLinkAutomaticDoorTrigger)
        self.RegisterForRemoteEvent(myTriggerVolume, "OnTriggerEnter")
        self.RegisterForRemoteEvent(myTriggerVolume, "OnTriggerLeave")
        GoToState("ScriptRunningState")
    endevent
endstate

state ScriptRunningState
    function HandleTriggerEvent(ObjectReference akTriggerVolume, ObjectReference akActionRef, bool abEntered)
        if (!self.IsLocked())
            self.SetOpen(akTriggerVolume.GetTriggerObjectCount() > 0)
        endif
    endfunction

    event OnClose(ObjectReference akActionRef)
        if (akActionRef == Game.GetPlayer() && self.GetLinkedRef(WorkshopLinkAutomaticDoorTrigger).GetTriggerObjectCount() > 0)
            GoToState("ScriptDisabledUntilPlayerLeavesTrigger")
        endif
    endevent
endstate

state ScriptDisabledUntilPlayerLeavesTrigger
    function HandleTriggerEvent(ObjectReference akTriggerVolume, ObjectReference akActionRef, bool abEntered)
        if (!abEntered && (akActionRef == Game.GetPlayer() || akTriggerVolume.GetTriggerObjectCount() == 0))
            GoToState("ScriptEnabled")
        endif
    endfunction
endstate
