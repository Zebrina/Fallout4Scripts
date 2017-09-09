scriptname Zebrina:Robotics:RobotSetVoiceTypeAndDismiss extends DLC01:DLC01BotSetVoiceType

event OnEffectStart(Actor akTarget, Actor akCaster)
    parent.OnEffectStart(akTarget, akCaster)

    FollowersScript followers = FollowersScript.GetScript()
    if (followers.IsCompanion(akTarget))
        followers.DismissCompanion(akTarget)
    endif
endevent
