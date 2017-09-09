scriptname Zebrina:Default:TwoStateActivator extends ObjectReference const

group PreventAutoFill_Properties
    Keyword property TwoStateCollisionKeywordNoAutoFill = none auto const
endgroup

group Animation_Properties
    string property sOpenAnim = "Open" auto const
    string property sCloseAnim = "Close" auto const
    string property sOpenEvent = "Opening" auto const
    string property sCloseEvent = "Closing" auto const
    bool property bIgnoreAnimationEvents = false auto const
endgroup

group Sound_Properties
    Sound property OpenSound = none auto const
    Sound property CloseSound = none auto const
endgroup

group Activator_Properties
    ActorValue property WorkshopObjectOpenStateAV auto const mandatory
    bool property bViolentlyClosed = false auto const
    bool property bStartOpen = false auto const
    string property sStartOpenAnim = "Opened" auto const
    bool property bInvertCollision = false auto const
    bool property bOverrideActivationText = false auto const
    Message property OpenTextOverride = none auto const
    Message property CloseTextOverride = none auto const
endgroup

function PlayAnimationAndWaitInternal(string asAnimation, string asEventName)
    if (bIgnoreAnimationEvents)
        self.PlayAnimation(asAnimation)
    else
        self.PlayAnimationAndWait(asAnimation, asEventName)
    endif
endfunction

function SetDefaultState()
    if (bStartOpen)
        if (bOverrideActivationText)
            self.SetActivateTextOverride(CloseTextOverride)
        endif

        self.PlayAnimationAndWaitInternal(sStartOpenAnim, sOpenEvent)
        EnableCollision(false)
        SetOpenState(1)
    else
        if (bOverrideActivationText)
            self.SetActivateTextOverride(OpenTextOverride)
        endif

        EnableCollision(true)
        SetOpenState(3)
    endif
endfunction

event OnLoad()
    SetDefaultState()
endevent
event OnReset()
	SetDefaultState()
endevent

; Native override.
int function GetOpenState()
    return self.GetValue(WorkshopObjectOpenStateAV) as int
endfunction
bool function IsOpen()
    return self.GetOpenState() == 1
endfunction

function SetOpenState(int aiOpenState)
    self.SetValue(WorkshopObjectOpenStateAV, aiOpenState)
endfunction
function EnableCollision(bool abShouldEnable = true)
    if (TwoStateCollisionKeywordNoAutoFill != none)
        if (abShouldEnable != bInvertCollision)
            self.EnableLinkChain(TwoStateCollisionKeywordNoAutoFill)
        else
            self.DisableLinkChain(TwoStateCollisionKeywordNoAutoFill)
        endif
    endif
endfunction

function SetActivateTextOverrideInternal(ObjectReference akReference, bool setOpenTextOverride)
    if (bOverrideActivationText)
        if (setOpenTextOverride)
            akReference.SetActivateTextOverride(OpenTextOverride)
        else
            akReference.SetActivateTextOverride(CloseTextOverride)
        endif
    endif
endfunction

; Native override.
function SetOpen(bool abOpen = true)
    int openState = self.GetOpenState()
    if (abOpen && (openState == 3 || openState == 4))
        SetOpenState(2)

        if (OpenSound)
            OpenSound.Play(self)
        endif

        self.PlayAnimationAndWaitInternal(sOpenAnim, sOpenEvent)
        EnableCollision(false)
        SetOpenState(1)
    elseif (!abOpen && (openState == 1 || openState == 2))
        SetOpenState(4)

        if (CloseSound)
            CloseSound.Play(self)
        endif

        self.PlayAnimationAndWaitInternal(sCloseAnim, sCloseEvent)
        EnableCollision(true)
        SetOpenState(3)
    endif

    SetActivateTextOverrideInternal(self, !abOpen)
endfunction
