scriptname Zebrina:Default:ReferenceParentScript extends ObjectReference

struct ChildReference
    ObjectReference ref = none hidden
    Form baseObject
    bool linkSelfToParent = false
    Keyword linkSelfToParentKeyword = none
    bool linkParentToSelf = false
    Keyword linkParentToSelfKeyword = none
    string attachNode = "REF_ATTACH_NODE"
    bool bAttachToNode = false
    { Set to false to move the reference instead of attaching it. }
endstruct

group ChildReference_Properties
    ChildReference[] property Children auto mandatory
endgroup

function UpdateNonAttachedChildren(bool abEnable)
    int i = 0
    while (i < Children.Length)
        if (Children[i].bAttachToNode == false)
            ChildReference child = Children[i]
            if (abEnable)
                child.ref.MoveToNode(self, child.attachNode)
            	child.ref.EnableNoWait()
            else
                child.ref.DisableNoWait()
            endif
        endif
        i += 1
    endwhile
endfunction

function InitializeChildReference(ObjectReference akChildRef, Keyword akLinkKeyword)
    ; To be overriden.
endfunction

event OnWorkshopObjectPlaced(ObjectReference akWorkshopRef)
    int i = 0
    while (i < Children.Length)
        ChildReference child = Children[i]
        child.ref = self.PlaceAtNode(child.attachNode, child.baseObject, abAttach = child.bAttachToNode)
        if (child.linkParentToSelf)
            child.ref.SetLinkedRef(self, child.linkParentToSelfKeyword)
        endif
        if (child.linkSelfToParent)
            self.SetLinkedRef(child.ref, child.linkSelfToParentKeyword)
        endif
        InitializeChildReference(child.ref, child.linkSelfToParentKeyword)
        i += 1
    endwhile
endevent
event OnWorkshopObjectGrabbed(ObjectReference akReference)
    UpdateNonAttachedChildren(false)
endevent
event OnWorkshopObjectMoved(ObjectReference akReference)
    UpdateNonAttachedChildren(true)
endevent
event OnWorkshopObjectDestroyed(ObjectReference akWorkshopRef)
    int i = 0
    while (i < Children.Length)
        ChildReference child = Children[i]
        child.ref.DisableNoWait()
        child.ref.Delete()
        i += 1
    endwhile
endevent
