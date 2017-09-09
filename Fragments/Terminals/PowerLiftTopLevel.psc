;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
Scriptname Zebrina:Fragments:Terminals:PowerLiftTopLevel Extends Terminal Hidden Const

;BEGIN FRAGMENT Fragment_Terminal_01
Function Fragment_Terminal_01(ObjectReference akTerminalRef)
;BEGIN CODE
UpdateWorkshopLinkObjectConfiguration()
configTerminalSharedSetPowerLiftSpeedGlobal_CurrentValue.SetValue((Game.GetPlayer().GetLinkedRef(WorkshopLinkObjectConfiguration) as Zebrina:Workshop:Objects:PowerLiftMiniCartScript).fLiftSpeedMult)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

; Needs to be called at the top of each individual fragment.
function UpdateWorkshopLinkObjectConfiguration()
    ; Configuring is initiated at the call buttons but what we want to configure is the power lift. This fixes that.
    Game.GetPlayer().SetLinkedRef((Game.GetPlayer().GetLinkedRef(WorkshopLinkObjectConfiguration)).GetLinkedRef(WorkshopLinkPowerLiftCallButton), WorkshopLinkObjectConfiguration)
endfunction

GlobalVariable property configTerminalSharedSetPowerLiftSpeedGlobal_CurrentValue auto const mandatory
Keyword property WorkshopLinkObjectConfiguration auto const mandatory
Keyword property WorkshopLinkPowerLiftCallButton auto const mandatory
