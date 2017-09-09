scriptname Zebrina:Workshop:Objects:RemoteTwoStateActivator extends Zebrina:Default:TwoStateActivator const

group RemoteActivator_Properties
    Activator property RemoteActivatorBase auto const mandatory
    Keyword property LinkKeyword = none auto const
    string property sRefAttachNode = "REF_ATTACH_NODE" auto const
    bool property bAttachToNode = true auto const
endgroup

function ResetRemoteActivatorPosition()
    ObjectReference myRemoteActivator = self.GetLinkedRef(LinkKeyword)
    ;myRemoteActivator.SetAngle(self.GetAngleX(), self.GetAngleY(), self.GetAngleZ())
    myRemoteActivator.MoveToNode(self, sRefAttachNode)
endfunction

event OnLoad()
    if (!bAttachToNode && self.GetLinkedRef(LinkKeyword) != none)
        ResetRemoteActivatorPosition()
    endif

    parent.OnLoad()
endevent

; Default:TwoStateActivator override.
event OnActivate(ObjectReference akActionRef)
    ; Do nothing.
endevent

event ObjectReference.OnActivate(ObjectReference akSender, ObjectReference akActionRef)
    parent.OnActivate(akActionRef)
endevent

event OnWorkshopObjectPlaced(ObjectReference akWorkshopRef)
    ObjectReference myRemoteActivator = self.PlaceAtNode(sRefAttachNode, RemoteActivatorBase, abAttach = bAttachToNode)
    self.SetLinkedRef(myRemoteActivator, LinkKeyword)
    self.RegisterForRemoteEvent(myRemoteActivator, "OnActivate")
endevent
event OnWorkshopObjectGrabbed(ObjectReference akReference)
    if (!bAttachToNode)
        self.GetLinkedRef(LinkKeyword).DisableNoWait()
    endif
endevent
event OnWorkshopObjectMoved(ObjectReference akReference)
    if (!bAttachToNode)
        ResetRemoteActivatorPosition()
        self.GetLinkedRef(LinkKeyword).EnableNoWait()
    endif
endevent
event OnWorkshopObjectDestroyed(ObjectReference akActionRef)
    ObjectReference myRemoteActivator = self.GetLinkedRef(LinkKeyword)
    myRemoteActivator.DisableNoWait()
    myRemoteActivator.Delete()
endevent
