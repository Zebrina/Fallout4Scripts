scriptname Zebrina:Workshop:Objects:PoweredDoorLockScript extends ObjectReference const

int property iLockLevel = 253 auto const
{ 253 is 'Terminal Only'. }

function HandlePowerStateChange(bool abIsPowered)
    self.Lock(abIsPowered)
endfunction

event OnPowerOn(ObjectReference akPowerGenerator)
    HandlePowerStateChange(false)
endevent
event OnPowerOff()
    HandlePowerStateChange(true)
endevent

event OnWorkshopObjectPlaced(ObjectReference akReference)
    self.SetLockLevel(iLockLevel)
endevent
