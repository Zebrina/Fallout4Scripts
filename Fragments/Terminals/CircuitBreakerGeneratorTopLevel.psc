;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
Scriptname Zebrina:Fragments:Terminals:CircuitBreakerGeneratorTopLevel Extends Terminal Hidden Const

;BEGIN FRAGMENT Fragment_Terminal_01
Function Fragment_Terminal_01(ObjectReference akTerminalRef)
;BEGIN CODE
configTerminalSharedSetPowerRadiationGlobal_ID.SetValue(1)
configTerminalSharedSetPowerRadiationGlobal_CurrentValue.SetValue(Game.GetPlayer().GetLinkedRef(WorkshopLinkObjectConfiguration).GetValue(PowerRadiation))
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

group SetPowerRadiation_Properties
    ActorValue property PowerRadiation auto const mandatory
    GlobalVariable property configTerminalSharedSetPowerRadiationGlobal_ID auto const mandatory
    GlobalVariable property configTerminalSharedSetPowerRadiationGlobal_CurrentValue auto const mandatory
endgroup
group Shared_Properties
    Keyword property WorkshopLinkObjectConfiguration auto const mandatory
endgroup
