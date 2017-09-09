;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
Scriptname Zebrina:Fragments:Terminals:SharedSetButtonTimeout Extends Terminal Hidden Const

;BEGIN FRAGMENT Fragment_Terminal_01
Function Fragment_Terminal_01(ObjectReference akTerminalRef)
;BEGIN CODE
SetButtonTimeout(5.0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_02
Function Fragment_Terminal_02(ObjectReference akTerminalRef)
;BEGIN CODE
SetButtonTimeout(10.0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_03
Function Fragment_Terminal_03(ObjectReference akTerminalRef)
;BEGIN CODE
SetButtonTimeout(15.0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_04
Function Fragment_Terminal_04(ObjectReference akTerminalRef)
;BEGIN CODE
SetButtonTimeout(20.0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_05
Function Fragment_Terminal_05(ObjectReference akTerminalRef)
;BEGIN CODE
SetButtonTimeout(30.0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_06
Function Fragment_Terminal_06(ObjectReference akTerminalRef)
;BEGIN CODE
SetButtonTimeout(60.0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_07
Function Fragment_Terminal_07(ObjectReference akTerminalRef)
;BEGIN CODE
SetButtonTimeout(120.0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_08
Function Fragment_Terminal_08(ObjectReference akTerminalRef)
;BEGIN CODE
SetButtonTimeout(300.0)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

function SetButtonTimeout(float afValue)
    ObjectReference configureObjectRef = Game.GetPlayer().GetLinkedRef(WorkshopLinkObjectConfiguration)
    if (configureObjectRef != none && configureObjectRef is Zebrina:Workshop:Objects:ButtonScript)
        (configureObjectRef as Zebrina:Workshop:Objects:ButtonScript).fTimeoutSeconds = afValue
        configTerminalSharedSetButtonTimeoutGlobal_CurrentValue.SetValue(afValue)
    endif
endfunction

GLobalVariable property configTerminalSharedSetButtonTimeoutGlobal_CurrentValue auto const mandatory
Keyword property WorkshopLinkObjectConfiguration auto const mandatory
