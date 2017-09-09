scriptname Zebrina:Common hidden

import Zebrina:Math2

bool function IsGlobalSet(GlobalVariable akGlobalVariable, bool abFlag = true) global
    return akGlobalVariable != none && (akGlobalVariable.GetValue() != 0) == abFlag
endfunction

bool function IsFormEqualToOrInList(Form akForm, Form akOtherFormOrFormList) global
    return akForm == akOtherFormOrFormList || (akOtherFormOrFormList is FormList && (akOtherFormOrFormList as FormList).HasForm(akForm))
endfunction
bool function IsFormNoneEqualToOrInList(Form akForm, Form akOtherFormOrFormList) global
    return akOtherFormOrFormList == none || IsFormEqualToOrInList(akForm, akOtherFormOrFormList)
endfunction

Form function TranslateForm(Form akForm, FormList akInputFormList, FormList akOutputFormList) global
    if (akInputFormList == none || akOutputFormList == none || akInputFormList.GetSize() != akOutputFormList.GetSize())
        return akForm
    endif

    int i = 0
    while (i < akInputFormList.GetSize())
        Form nthForm = akInputFormList.GetAt(i)
        if (nthForm == akForm || (nthForm is Keyword && akForm.HasKeyword(nthForm as Keyword)) || (nthForm is FormList && (nthForm as FormList).HasForm(akForm)))
            return akOutputFormList.GetAt(i)
        endif
        i += 1
    endwhile
    return akForm
endfunction

float function GetAngleZBetweenTargets(ObjectReference akPrimaryTarget, ObjectReference akSecondaryTarget) global
    if (akPrimaryTarget == none || akSecondaryTarget == none)
        return 0.0
    endif

    return atan2(akPrimaryTarget.Y - akSecondaryTarget.Y, akPrimaryTarget.X - akSecondaryTarget.X)
endfunction


string function IntToHex(int aiValue) global
    if (aiValue >= 0 && aiValue < 16)
        if (aiValue <= 9)
            return aiValue as string
        elseif (aiValue == 10)
            return "a"
        elseif (aiValue == 11)
            return "b"
        elseif (aiValue == 12)
            return "c"
        elseif (aiValue == 13)
            return "d"
        elseif (aiValue == 14)
            return "e"
        elseif (aiValue == 15)
            return "f"
        endif
    endif
    return IntToHex(Math.RightShift(aiValue, 4)) + IntToHex(Math.LogicalAND(aiValue, 0x0000000f))
endfunction
