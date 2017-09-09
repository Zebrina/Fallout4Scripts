;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
Scriptname Zebrina:Fragments:Terminals:SharedSetPowerRadiation Extends Terminal Hidden Const

;BEGIN FRAGMENT Fragment_Terminal_01
Function Fragment_Terminal_01(ObjectReference akTerminalRef)
;BEGIN CODE
SetWorkshopObjectPowerRadiation(0.0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_02
Function Fragment_Terminal_02(ObjectReference akTerminalRef)
;BEGIN CODE
SetWorkshopObjectPowerRadiation(256.0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_03
Function Fragment_Terminal_03(ObjectReference akTerminalRef)
;BEGIN CODE
SetWorkshopObjectPowerRadiation(512.0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_04
Function Fragment_Terminal_04(ObjectReference akTerminalRef)
;BEGIN CODE
SetWorkshopObjectPowerRadiation(768.0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_05
Function Fragment_Terminal_05(ObjectReference akTerminalRef)
;BEGIN CODE
SetWorkshopObjectPowerRadiation(1024.0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_06
Function Fragment_Terminal_06(ObjectReference akTerminalRef)
;BEGIN CODE
SetWorkshopObjectPowerRadiation(2048.0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_07
Function Fragment_Terminal_07(ObjectReference akTerminalRef)
;BEGIN CODE
SetWorkshopObjectPowerRadiation(65536.0)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

function SetWorkshopObjectPowerRadiation(float afValue)
    ObjectReference configureObjectRef = Game.GetPlayer().GetLinkedRef(WorkshopLinkObjectConfiguration)
    if (configureObjectRef != none)
        configureObjectRef.SetValue(PowerRadiation, afValue)
        configTerminalSharedSetPowerRadiationGlobal_CurrentValue.SetValue(afValue)
    endif
endfunction

Keyword property WorkshopLinkObjectConfiguration auto const mandatory
ActorValue property PowerRadiation auto const mandatory
GlobalVariable property configTerminalSharedSetPowerRadiationGlobal_CurrentValue auto const mandatory
