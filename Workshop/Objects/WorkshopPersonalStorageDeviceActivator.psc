scriptname Zebrina:Workshop:Objects:WorkshopPersonalStorageDeviceActivator extends ObjectReference const

Quest property WorkshopPersonalStorageDevice auto const mandatory
ReferenceAlias property PersonalStorageDeviceContainer auto const mandatory

event OnActivate(ObjectReference akActionRef)
    if (WorkshopPersonalStorageDevice.IsRunning() == false && WorkshopPersonalStorageDevice.Start() == false)
        return
    endif
    PersonalStorageDeviceContainer.GetReference().MoveTo(self)
    PersonalStorageDeviceContainer.GetReference().Activate(akActionRef, true)
endevent
