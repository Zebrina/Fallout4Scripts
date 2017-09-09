;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
Scriptname Zebrina:Fragments:Perks:WorkshopQuickConfig Extends Perk Hidden Const

;BEGIN FRAGMENT Fragment_Entry_00
Function Fragment_Entry_00(ObjectReference akTargetRef, Actor akActor)
;BEGIN CODE
StartConfiguration(akTargetRef)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

import Zebrina:Common

;/
int function FormListRecursiveFind(FormList list, Form formToFind)
	int i = list.GetSize() - 1
	while (i >= 0)
		Form nForm = list.GetAt(i)
		if (nForm == formToFind || (nForm is FormList && FormListRecursiveFind(nForm as FormList, formToFind) >= 0))
			return i
		endif
		i -= 1
	endwhile
	return i
endfunction
/;

function StartConfiguration(ObjectReference akTargetRef)
	Terminal configTerminal = TranslateForm(akTargetRef.GetBaseObject(), ConfigurableWorkshopObjectList, ConfigurableWorkshopObjectTerminalList) as Terminal
	if (configTerminal == none)
		return
	endif

    InputEnableLayer myLayer = InputEnableLayer.Create()
    myLayer.DisablePlayerControls()

    Actor player = Game.GetPlayer()

    player.SetLinkedRef(akTargetRef, WorkshopLinkObjectConfiguration)
    Game.ForceFirstPerson()
    player.PlayIdle(IdlePipBoyJackIn)
    Utility.Wait(0.833)

    myLayer.EnablePlayerControls()

	; Register for pipboy menu close to clear linked ref.
    configTerminal.ShowOnPipboy()
	self.StartTimer(10.0)
endfunction

event OnTimer(int aiTimerID)
	Utility.Wait(0.1)
    Game.GetPlayer().SetLinkedRef(none, WorkshopLinkObjectConfiguration)
endevent

Idle property IdlePipBoyJackIn auto const mandatory
Idle property IdlePipBoyJackOut auto const mandatory
FormList property ConfigurableWorkshopObjectList auto const mandatory
FormList property ConfigurableWorkshopObjectTerminalList auto const mandatory
Keyword property WorkshopLinkObjectConfiguration auto const mandatory
