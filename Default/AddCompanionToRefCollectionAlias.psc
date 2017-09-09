scriptname Zebrina:Default:AddCompanionToRefCollectionAlias extends Quest

RefCollectionAlias property AddToRefCollectionAlias auto const mandatory

event OnQuestInit()
	self.RegisterForCustomEvent(FollowersScript.GetScript(), "CompanionChange")
endevent

event FollowersScript.CompanionChange(FollowersScript akSender, Var[] args)
	;args[0] = Actor ActorThatChanged
	;args[1] = bool IsNowCompanion
    Actor actorThatChanged = args[0] as Actor
    bool isNowCompanion = args[1] as bool

	if (actorThatChanged && isNowCompanion)
        AddToRefCollectionAlias.AddRef(actorThatChanged)
	endif
endevent
