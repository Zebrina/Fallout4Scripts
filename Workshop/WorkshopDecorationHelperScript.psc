scriptname Zebrina:Workshop:WorkshopDecorationHelperScript extends ReferenceAlias
{ Script to help decoration. Blocks activation and disables physics on manipulated objects when leaving workshop mode. Attach to CurrentWorkshop alias. }

import Zebrina:Common

GlobalVariable property WorkshopModeDecorationHelperEnabled auto const mandatory
{ Global variable to toggle this feature. }

ObjectReference[] manipulatedReferences

event OnAliasInit()
    manipulatedReferences = new ObjectReference[0]
endevent

bool function IsReferenceValidType(ObjectReference akReference)
    Form baseObject = akReference.GetBaseObject()
    return baseObject is Ammo || baseObject is Armor || baseObject is Book || baseObject is Holotape || baseObject is MiscObject || baseObject is Potion || baseObject is Weapon
endfunction

function DisablePhysicsAndBlockActivationOnReference(ObjectReference akReference)
    if (akReference.Is3DLoaded())
        akReference.BlockActivation(true, true)
        akReference.SetMotionType(akReference.Motion_Keyframed)
    endif
endfunction

auto state WaitForWorkshopObjectGrabbed
    event OnWorkshopmode(bool abStart)
        if (IsGlobalSet(WorkshopModeDecorationHelperEnabled) && !abStart)
            GoToState("DisablePhysicsAndBlockActivation")

            int i = 0
            while (i < manipulatedReferences.Length)
                DisablePhysicsAndBlockActivationOnReference(manipulatedReferences[i])
                i += 1
            endwhile

            manipulatedReferences.Clear()

            GoToState("WaitForWorkshopObjectGrabbed")
        endif
    endevent

    event OnWorkshopObjectGrabbed(ObjectReference akReference)
        if (IsReferenceValidType(akReference))
            akReference.SetMotionType(akReference.Motion_Dynamic)
            if (manipulatedReferences.Find(akReference) < 0)
                manipulatedReferences.Add(akReference)
            endif
        endif
    endevent
endstate

state DisablePhysicsAndBlockActivation
    ; Empty state where we ignore events.
endstate
