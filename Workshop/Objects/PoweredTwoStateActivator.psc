scriptname Zebrina:Workshop:Objects:PoweredTwoStateActivator extends Zebrina:Default:TwoStateActivator

; Default:TwoStateActivator override.
event OnActivate(ObjectReference akActionRef)
    ; Do nothing.
endevent

bool bPowerStateChangeBeingHandled = false

function HandlePowerStateChange()
    if (bPowerStateChangeBeingHandled == false)
        bPowerStateChangeBeingHandled = true
        while (self.IsPowered() != self.IsOpen())
            self.SetOpen(self.IsPowered())
            ;Utility.Wait(0.1) ; Wait to see if power state still matches open state.
        endwhile
        bPowerStateChangeBeingHandled = false
    endif
endfunction

event OnPowerOn(ObjectReference akPowerGenerator)
    HandlePowerStateChange()
endevent
event OnPowerOff()
    HandlePowerStateChange()
endevent
