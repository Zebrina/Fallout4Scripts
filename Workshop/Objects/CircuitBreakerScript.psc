scriptname Zebrina:Workshop:Objects:CircuitBreakerScript extends Zebrina:Default:ReferenceParentScript

group CircuitBreaker_Properties
    Message property CircuitBreakerDeniedMessage auto const
	string property sSwitchAnimation = "Play01" auto const
    string property sSwitchEventName = "Done" auto const
    bool property bIsGenerator = false auto const
endgroup

bool bIsAnimating = false
bool bIsActivated = false

function LockForAnimation()
    while (bIsAnimating)
        Utility.Wait(0.1)
    endwhile
    bIsAnimating = true
endfunction

function ToggleState()
    LockForAnimation()

    if ((self.GetOpenState() == 3) != bIsActivated)
        self.PlayAnimationAndWait(sSwitchAnimation, sSwitchEventName)
        bIsActivated = !bIsActivated
    endif

    bIsAnimating = false
endfunction
function SetStateOn(bool abShouldBeActive = true)
    self.SetOpen(!abShouldBeActive)
    if (abShouldBeActive != bIsActivated)
        ToggleState()
    endif
endfunction

bool function IsLidOpen()
    return self.GetLinkedRef().GetOpenState() <= 2
endfunction

function InitializeChildReference(ObjectReference akChildRef, Keyword akLinkKeyword)
    self.BlockActivation(true, true)
    self.RegisterForRemoteEvent(akChildRef, "OnActivate")
    self.RegisterForRemoteEvent(akChildRef, "OnOpen")
    self.RegisterForRemoteEvent(akChildRef, "OnClose")
endfunction

event ObjectReference.OnActivate(ObjectReference akSender, ObjectReference akActionRef)
    if (akSender.GetOpenState() <= 2)
        self.BlockActivation(false, false)
    else
        self.BlockActivation(true, true)
    endif
endevent

event ObjectReference.OnOpen(ObjectReference akSender, ObjectReference akActionRef)
    if (!bIsGenerator && !self.IsPowered())
        SetStateOn(false)
    endif
    self.BlockActivation(false, false)
endevent
event ObjectReference.OnClose(ObjectReference akSender, ObjectReference akActionRef)
    self.BlockActivation(true, true)
endevent

event OnActivate(ObjectReference akActionRef)
    ToggleState()
    if (!bIsGenerator && !self.IsPowered())
        if (akActionRef == Game.GetPlayer())
            CircuitBreakerDeniedMessage.Show()
        endif
        SetStateOn(false)
    endif
endevent

event OnPowerOff()
    if (!bIsGenerator && IsLidOpen())
        SetStateOn(false)
    endif
endevent

event OnWorkshopObjectPlaced(ObjectReference akWorkshopRef)
    parent.OnWorkshopObjectPlaced(akWorkshopRef)

    self.SetOpen() ; Starts OFF.
endevent
