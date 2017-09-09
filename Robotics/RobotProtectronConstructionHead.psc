scriptname Zebrina:Robotics:RobotProtectronConstructionHead extends ActiveMagicEffect const

event OnCombatStateChanged(Actor akTarget, int aeCombatState)
    if (aeCombatState == 0)
        self.GetTargetActor().PlayAnimation("x_headOff")
    else
        self.GetTargetActor().PlayAnimation("x_headOn")
    endif
endevent
