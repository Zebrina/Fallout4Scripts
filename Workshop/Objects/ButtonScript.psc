scriptname Zebrina:Workshop:Objects:ButtonScript extends ObjectReference

group Animation_Properties
    string property sPressAnimation = "Press" auto const
	string property sTurnOnAnimation = "TurnOn01" auto const
    string property sTurnOffAnimation = "TurnOff01" auto const
endgroup

group Button_Properties
    bool property bIsGenerator = false auto const
endgroup

bool bIsAnimating = false
bool bJustActivated = false

float property fTimeoutSeconds = 5.0 auto hidden

function LockForAnimation()
    while (bIsAnimating)
        Utility.Wait(0.1)
    endwhile
    bIsAnimating = true
endfunction

function Press()
    LockForAnimation()
    self.PlayAnimationAndWait(sPressAnimation, "End")
    bIsAnimating = false
endfunction

function TurnOn()
    LockForAnimation()
    self.SetOpen(false)
    self.PlayAnimationAndWait(sTurnOnAnimation, "End")
    bIsAnimating = false
endfunction

function TurnOff()
    LockForAnimation()
    self.PlayAnimationAndWait(sTurnOffAnimation, "End")
    self.SetOpen()
    bIsAnimating = false
endfunction

event OnLoad()
    self.BlockActivation()
    self.SetOpen()
endevent

state Active
    event OnActivate(ObjectReference akActionRef)
        if (!bJustActivated)
            bJustActivated = true

            Press()
            StartTimer(fTimeoutSeconds)

            bJustActivated = false
        endif
    endevent

    event OnTimer(int aiTimerID)
        GoToState("TurningOff")
        TurnOff()
        GoToState("Idle")
    endevent

    event OnPowerOff()
        if (!bIsGenerator)
            GoToState("TurningOff")
            TurnOff()
            GoToState("Idle")
        endif
    endevent
endstate

auto state Idle
    event OnActivate(ObjectReference akActionRef)
        if (!bJustActivated)
            bJustActivated = true

            Press()

            if (bIsGenerator || self.IsPowered())
                TurnOn()
                StartTimer(fTimeoutSeconds)
                GoToState("Active")
            endif

            bJustActivated = false
        endif
    endevent
endstate
