scriptname Zebrina:Utility:TextReplacement extends Quest

group AutoFill_Properties
    ReferenceAlias property myRefAlias01 auto const mandatory
    LocationAlias property myLocAlias01 auto const mandatory
    ReferenceAlias property myRefAlias02 auto const mandatory
    LocationAlias property myLocAlias02 auto const mandatory
endgroup

group DynamicNaming_Properties
    GlobalVariable property DynamicNamingID auto const mandatory
    Quest property TextReplacement_SetNameWithID auto const mandatory
endgroup

bool bBusy = false

TextReplacement function GetTextReplacementQuest() global
    return Game.GetFormFromFile(0x3d762c, "ZebrinasWorkshop.esp") as TextReplacement
endfunction

int function ShowMessage(message akMessageToShow, ObjectReference akRef1 = none, Location akLoc1 = none, ObjectReference akRef2 = none, Location akLoc2 = none) global
	if (akMessageToShow == none)
        return -1
    endif

    TextReplacement textReplacementQuest = GetTextReplacementQuest()

	textReplacementQuest.myRefAlias01.ForceRefTo(akRef1)
	textReplacementQuest.myLocAlias01.ForceLocationTo(akLoc1)
	textReplacementQuest.myRefAlias02.ForceRefTo(akRef2)
	textReplacementQuest.myLocAlias02.ForceLocationTo(akLoc2)

    int messageShown = akMessageToShow.Show()

	textReplacementQuest.myRefAlias01.Clear()
	textReplacementQuest.myLocAlias01.Clear()
	textReplacementQuest.myRefAlias02.Clear()
	textReplacementQuest.myLocAlias02.Clear()

	return messageShown
endfunction

bool function SetNameWithID(ObjectReference akReferenceToRename, int aiObjectID) global
    if (akReferenceToRename == none)
        return false
    endif

    GetTextReplacementQuest().SetNameWithID_Internal(akReferenceToRename, aiObjectID)
endfunction

bool function SetNameWithID_Internal(ObjectReference akReferenceToRename, int aiObjectID)
    if (akReferenceToRename == none)
        return false
    endif

    while (bBusy)
        Utility.Wait(0.5)
    endwhile

    bBusy = true

    myRefAlias01.ForceRefTo(akReferenceToRename)
    DynamicNamingID.SetValue(aiObjectID)
    self.UpdateCurrentInstanceGlobal(DynamicNamingID)

    bool success = TextReplacement_SetNameWithID.Start()
    TextReplacement_SetNameWithID.Stop()
    myRefAlias01.Clear()

    bBusy = false

    return success
endfunction
