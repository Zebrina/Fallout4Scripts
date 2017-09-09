scriptname Zebrina:Default:SafeQuestAliasContainer extends ObjectReference const

Quest property OwningQuest auto const mandatory
bool property bMoveInventoryToPlayerOnDelete = true auto const

event OnInit()
    self.BlockActivation(true, true)
    self.RegisterForRemoteEvent(OwningQuest, "OnQuestShutdown")
endevent

event Quest.OnQuestShutdown(Quest akSender)
    if (bMoveInventoryToPlayerOnDelete)
        self.RemoveAllItems(Game.GetPlayer())
    endif
    self.Disable()
    self.Delete()
endevent
