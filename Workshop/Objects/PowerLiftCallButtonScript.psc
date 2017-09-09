scriptname Zebrina:Workshop:Objects:PowerLiftCallButtonScript extends ObjectReference const

import Zebrina:Common

Keyword property WorkshopPowerLiftKeyword auto const mandatory
Keyword property WorkshopLinkPowerLiftCallButton auto const mandatory
float property fPowerLiftSearchRadius = 16384.0 auto const

bool function IsACloserXYThanB(ObjectReference a, ObjectReference b)
    if (b.IsEnabled() == false)
        return true
    endif

    float deltaX = self.GetPositionX() - a.GetPositionX()
    float deltaY = self.GetPositionY() - a.GetPositionY()

    float comparableDistA = (deltaX * deltaX) + (deltaY * deltaY)

    deltaX = self.GetPositionX() - b.GetPositionX()
    deltaY = self.GetPositionY() - b.GetPositionY()

    float comparableDistB = (deltaX * deltaX) + (deltaY * deltaY)

    return comparableDistA < comparableDistB
endfunction

function FindOrUpdatePowerLift()
    ObjectReference powerLift = self.GetLinkedRef(WorkshopLinkPowerLiftCallButton)
    if (powerLift)
        (powerLift as Zebrina:Workshop:Objects:PowerLiftMiniCartScript).UnregisterCallButton(self)
    endif

    Utility.Wait(0.5) ; Wait for power lifts eventually being removed to finish.

    ObjectReference[] allPowerLifts = self.FindAllReferencesWithKeyword(WorkshopPowerLiftKeyword, fPowerLiftSearchRadius)
    Debug.Notification("PowerLiftCallButtonScript::FindOrUpdatePowerLift: Found " + allPowerLifts.Length + " power lift(s).")
    PrintPowerLiftArray(allPowerLifts)

    if (allPowerLifts.Length > 0)
        ; If multiple elevators, find the closest on the xy-axis.
        powerLift = allPowerLifts[0]
        int i = 1
        while (i < allPowerLifts.Length)
            if (IsACloserXYThanB(allPowerLifts[i], powerLift))
                powerLift = allPowerLifts[i]
            endif
            i += 1
        endwhile

        (powerLift as Zebrina:Workshop:Objects:PowerLiftMiniCartScript).RegisterCallButton(self)
    endif
endfunction

event OnWorkshopObjectPlaced(ObjectReference akReference)
    self.RegisterForRemoteEvent(akReference, "OnWorkshopObjectPlaced")
    self.RegisterForRemoteEvent(akReference, "OnWorkshopObjectMoved")
    self.RegisterForRemoteEvent(akReference, "OnWorkshopObjectDestroyed")
    FindOrUpdatePowerLift()
endevent
event OnWorkshopObjectMoved(ObjectReference akReference)
    FindOrUpdatePowerLift()
endevent
event OnWorkshopObjectDestroyed(ObjectReference akReference)
    ObjectReference powerLift = self.GetLinkedRef(WorkshopLinkPowerLiftCallButton)
    if (powerLift)
        (powerLift as Zebrina:Workshop:Objects:PowerLiftMiniCartScript).UnregisterCallButton(self)
    endif
endevent

event ObjectReference.OnWorkshopObjectPlaced(ObjectReference akSender, ObjectReference akReference)
    if (akReference.HasKeyword(WorkshopPowerLiftKeyword))
        FindOrUpdatePowerLift()
    endif
endevent
event ObjectReference.OnWorkshopObjectMoved(ObjectReference akSender, ObjectReference akReference)
    if (akReference != self && akReference.HasKeyword(WorkshopPowerLiftKeyword))
        FindOrUpdatePowerLift()
    endif
endevent
event ObjectReference.OnWorkshopObjectDestroyed(ObjectReference akSender, ObjectReference akReference)
    if (akReference != self && akReference.HasKeyword(WorkshopPowerLiftKeyword))
        FindOrUpdatePowerLift()
    endif
endevent

function PrintPowerLiftArray(ObjectReference[] powerLifts) debugonly
    if (powerLifts != none)
        int i = 0
        while (i < powerLifts.Length)
            Debug.Notification("PowerLifts[" + i + "] = " + IntToHex(powerLifts[i].GetFormID()))
            i += 1
        endwhile
    endif
endfunction
