;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
Scriptname Zebrina:Fragments:Terminals:PowerButtonTopLevel Extends Terminal Hidden Const

;BEGIN FRAGMENT Fragment_Terminal_01
Function Fragment_Terminal_01(ObjectReference akTerminalRef)
;BEGIN CODE
configTerminalSharedSetButtonTimeoutGlobal_ID.SetValue(1)
configTerminalSharedSetButtonTimeoutGlobal_CurrentValue.SetValue((Game.GetPlayer().GetLinkedRef(WorkshopLinkObjectConfiguration) as Zebrina:Workshop:Objects:ButtonScript).fTimeoutSeconds)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_02
Function Fragment_Terminal_02(ObjectReference akTerminalRef)
;BEGIN CODE
configTerminalSharedSetPowerRadiationGlobal_ID.SetValue(0)
configTerminalSharedSetPowerRadiationGlobal_CurrentValue.SetValue(Game.GetPlayer().GetLinkedRef(WorkshopLinkObjectConfiguration).GetValue(PowerRadiation))
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

group SetTimeout_Properties
    GlobalVariable property configTerminalSharedSetButtonTimeoutGlobal_ID auto const mandatory
    GlobalVariable property configTerminalSharedSetButtonTimeoutGlobal_CurrentValue auto const mandatory
endgroup
group SetPowerRadiation_Properties
    ActorValue property PowerRadiation auto const mandatory
    GlobalVariable property configTerminalSharedSetPowerRadiationGlobal_ID auto const mandatory
    GlobalVariable property configTerminalSharedSetPowerRadiationGlobal_CurrentValue auto const mandatory
endgroup
group Shared_Properties
    Keyword property WorkshopLinkObjectConfiguration auto const mandatory
endgroup
