scriptname Zebrina:Hotkeys:LastUsedItemTrackerScript extends Quest

Event OnQuestInit()
    self.RegisterForRemoteEvent(Game.GetPlayer(), "OnItemEquipped")
EndEvent

Event Actor.OnItemEquipped(Actor akSender, Form akBaseObject, ObjectReference akReference)
EndEvent
