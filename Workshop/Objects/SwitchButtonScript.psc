scriptname Zebrina:Workshop:Objects:SwitchButtonScript extends ObjectReference const

group Animation_Properties
    string property sPressAnimation = "Press" auto const
    string property sPressAnimationEvent = "End" auto const
    float property fPressAnimationDuration = 0.667 auto const
	string property sTurnOnAnimation = "TurnOn01" auto const
    string property sTurnOnAnimationEvent = "End" auto const
    string property sTurnOffAnimation = "TurnOff01" auto const
    string property sTurnOffAnimationEvent = "End" auto const
endgroup

event OnLoad()
    ; Just in case...
    self.BlockActivation(false)

    UpdateButtonState()
endevent

function UpdateButtonState(bool abNoDelay = false)
    self.WaitFor3DLoad()

    if (!abNoDelay && fPressAnimationDuration > 0.0)
        Utility.Wait(fPressAnimationDuration)
    endif

    if (self.GetOpenState() == 3 && self.IsPowered())
        ; Play "turn on" animation.
        self.PlayAnimationAndWait(sTurnOnAnimation, sTurnOnAnimationEvent)
    else
        ; Play "turn off" animation.
        self.PlayAnimationAndWait(sTurnOffAnimation, sTurnOffAnimationEvent)
    endif
endfunction

event OnActivate(ObjectReference akActionRef)
    if (self.Is3DLoaded() && self.IsActivationBlocked() == false)
        self.BlockActivation(true)

        ; Play "press" animation.
        self.PlayAnimationAndWait(sPressAnimation, sPressAnimationEvent)
        UpdateButtonState(true)

        self.BlockActivation(false)
    endif
endevent

event OnOpen(ObjectReference akActionRef)
    UpdateButtonState()
endevent
event OnClose(ObjectReference akActionRef)
    UpdateButtonState()
endevent

event OnPowerOn(ObjectReference akPowerGenerator)
    UpdateButtonState()
endevent
event OnPowerOff()
    UpdateButtonState()
endevent
