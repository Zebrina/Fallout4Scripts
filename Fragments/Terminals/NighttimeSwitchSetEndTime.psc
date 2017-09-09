;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
Scriptname Zebrina:Fragments:Terminals:NighttimeSwitchSetEndTime Extends Terminal Hidden Const

;BEGIN FRAGMENT Fragment_Terminal_01
Function Fragment_Terminal_01(ObjectReference akTerminalRef)
;BEGIN CODE
SetTimeParam(5, akTerminalRef)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_02
Function Fragment_Terminal_02(ObjectReference akTerminalRef)
;BEGIN CODE
SetTimeParam(6, akTerminalRef)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_03
Function Fragment_Terminal_03(ObjectReference akTerminalRef)
;BEGIN CODE
SetTimeParam(7, akTerminalRef)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_04
Function Fragment_Terminal_04(ObjectReference akTerminalRef)
;BEGIN CODE
SetTimeParam(8, akTerminalRef)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

function SetTimeParam(float gameHour, ObjectReference terminalRef)
    ObjectReference[] linkedRefArray = terminalRef.getLinkedRefArray(LinkTerminalNighttimeSwitch)

	int i = 0
	while (i < linkedRefArray.length)
		Zebrina:Workshop:Objects:NighttimeSwitchScript theObject = linkedRefArray[i] as Zebrina:Workshop:Objects:NighttimeSwitchScript
		if (theObject)
			theObject.fTurnOffAtGameHour = gameHour
		endif
		i += 1
	endWhile
endfunction

Keyword property LinkTerminalNighttimeSwitch auto const mandatory
