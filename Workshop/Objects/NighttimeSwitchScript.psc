scriptname Zebrina:Workshop:Objects:NighttimeSwitchScript extends ObjectReference conditional

group AutoFill_Properties
    GlobalVariable property GameHour auto const mandatory
endgroup

group DayNightSwitch_Properties
    float property fTurnOnAtGameHour = 20.0 auto conditional
    float property fTurnOffAtGameHour = 6.0 auto conditional
endgroup

float function GetRemainingHours(float afTargetHour)
    float delta = afTargetHour - GameHour.GetValue()
    if (delta < 0)
        return delta + 24.0
    endif
    return delta
endfunction

function UpdateSwitchState()
    self.SetOpen(!(GameHour.GetValue() >= fTurnOnAtGameHour || GameHour.GetValue() < fTurnOffAtGameHour))
endfunction

float function CalculateAndQueueNextUpdate()
    if (self.GetOpenState() == 3) ; Active
        StartTimerGameTime(GetRemainingHours(fTurnOffAtGameHour))
    else ; Inactive
        StartTimerGameTime(GetRemainingHours(fTurnOnAtGameHour))
    endif
endfunction

event OnTimerGameTime(int aiTimerID)
    UpdateSwitchState()
    CalculateAndQueueNextUpdate()
endevent

event OnLoad()
    UpdateSwitchState()
    CalculateAndQueueNextUpdate()
endevent
event OnUnload()
    CancelTimerGameTime()
endevent

event OnWorkshopObjectPlaced(ObjectReference akWorkshopRef)
    UpdateSwitchState()
    CalculateAndQueueNextUpdate()
endevent

event OnPowerOn(ObjectReference akPowerGenerator)
    UpdateSwitchState()
    CalculateAndQueueNextUpdate()
endevent
event OnPowerOff()
    CancelTimerGameTime()
endevent
