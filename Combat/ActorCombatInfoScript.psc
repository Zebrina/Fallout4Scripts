scriptname Zebrina:Combat:ActorCombatInfoScript extends ActiveMagicEffect const

group AutoFill_Properties
    Zebrina:Combat:CombatMasterScript property CombatMaster auto const mandatory
    Perk property UniversalCombatActorPerk auto const mandatory
endgroup

group ActorValues
    ActorValue property CombatInfo_DamageTakenMult auto const mandatory
endgroup

group Abilities
    Spell property CombatAbility_DamageHealth1000 auto const mandatory
    Spell property CombatAbility_DamageHealth0900 auto const mandatory
    Spell property CombatAbility_DamageHealth0800 auto const mandatory
    Spell property CombatAbility_DamageHealth0700 auto const mandatory
    Spell property CombatAbility_DamageHealth0600 auto const mandatory
    Spell property CombatAbility_DamageHealth0500 auto const mandatory
    Spell property CombatAbility_DamageHealth0400 auto const mandatory
    Spell property CombatAbility_DamageHealth0300 auto const mandatory
    Spell property CombatAbility_DamageHealth0250 auto const mandatory
    Spell property CombatAbility_DamageHealth0200 auto const mandatory
    Spell property CombatAbility_DamageHealth0150 auto const mandatory
    Spell property CombatAbility_DamageHealth0100 auto const mandatory
    Spell property CombatAbility_DamageHealth0050 auto const mandatory
endgroup

float function GetDamageTakenMultValue(Actor akActor)
    float baseHealthSub80 = akActor.GetBaseValue(Game.GetHealthAV()) - 80
    if (baseHealthSub80 <= 0.0)
        return 1.0
    endif

    return 1.0 + (baseHealthSub80 * 12) / (baseHealthSub80 + 1520.0)
endfunction

function UpdateCombatInfo(Actor akActor)
    ;akActor.SetValue(CombatInfo_DamageTakenMult, GetDamageTakenMultValue(akActor))
endfunction

event OnEffectStart(Actor akTarget, Actor akCaster)
    ;UpdateCombatInfo(akTarget)

    self.RegisterForRemoteEvent(CombatMaster, "OnQuestShutdown")
    self.RegisterForCustomEvent(CombatMaster, "UpdateActorCombatInfo")
endevent
event OnEffectFinish(Actor akTarget, Actor akCaster)
    ;akTarget.SetValue(CombatInfo_DamageTakenMult, 0.0)
endevent

event OnLoad()
    ;UpdateCombatInfo(self.GetTargetActor())
endevent

event Quest.OnQuestShutdown(Quest akSender)
    self.GetTargetActor().RemovePerk(UniversalCombatActorPerk)
endevent
event Zebrina:Combat:CombatMasterScript.UpdateActorCombatInfo(Zebrina:Combat:CombatMasterScript akSender, var[] akArgs)
    ;UpdateCombatInfo(self.GetTargetActor())
endevent
