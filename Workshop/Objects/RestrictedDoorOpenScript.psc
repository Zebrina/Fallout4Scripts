scriptname Zebrina:Workshop:Objects:RestrictedDoorOpenScript extends ObjectReference const

int property iOpenMode = 2 auto const
{ 0 = front and back, 1 = front only, 2 = back only. }
int property iClosingMode = 2 auto const
{ 0 = front and back, 1 = front only, 2 = back only. }

int property iNpcMode = 0 auto const
{ 0 = default, 1 = ignore player, 2 = ignore npcs. }

Message property UnableToOpenMessage = none auto const
Message property UnableToCloseMessage = none auto const

event OnLoad()
    self.BlockActivation()
EndEvent

bool function CanTargetOpenOrClose(ObjectReference akTarget, int iModeValue)
    if (iModeValue == 1)
        float angleToTarget = self.GetHeadingAngle(akTarget)
        return angleToTarget > -90.0 && angleToTarget < 90.0
    elseif (iModeValue == 2)
        float angleToTarget = self.GetHeadingAngle(akTarget)
        return angleToTarget < -90.0 || angleToTarget > 90.0
    endif
    return true
endfunction

event OnActivate(ObjectReference akActionRef)
    bool bIsPlayer = akActionRef == Game.GetPlayer()
    if ((iNpcMode == 1 && bIsPlayer) || (iNpcMode == 2 && !bIsPlayer))
        self.Activate(akActionRef, true)
    else
        int openState = self.GetOpenState()
        if (openState == 1)
            if (CanTargetOpenOrClose(akActionRef, iClosingMode))
                self.Activate(akActionRef, true)
            elseif (UnableToCloseMessage != none && bIsPlayer)
                UnableToCloseMessage.Show()
            endif
        elseif (openState == 3)
            if (CanTargetOpenOrClose(akActionRef, iOpenMode))
                self.Activate(akActionRef, true)
            elseif (UnableToOpenMessage != none && bIsPlayer)
                UnableToOpenMessage.Show()
            endif
        endif
    endif
endevent
