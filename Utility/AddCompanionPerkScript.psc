scriptname Zebrina:Utility:AddCompanionPerkScript extends Quest const

Message property CompanionInfatuationPerkMessage_Generic auto const mandatory

event OnQuestInit()
	self.RegisterForCustomEvent(FollowersScript.GetScript(), "CompanionChange")
endevent

event FollowersScript.CompanionChange(FollowersScript akSender, var[] args)
	CompanionActorScript actorThatChanged = args[0] as CompanionActorScript ; Sent as Actor but should be CompanionActorScript.
    bool isNowCompanion = args[1] as bool

	if (actorThatChanged && actorThatChanged.InfatuationPerk != none && isNowCompanion && !Game.GetPlayer().HasPerk(actorThatChanged.InfatuationPerk))
		Game.GetPlayer().AddPerk(actorThatChanged.InfatuationPerk)
		;actorThatChanged.InfatuationPerkMessage.Show()
        Zebrina:Utility:TextReplacement.ShowMessage(CompanionInfatuationPerkMessage_Generic, akRef1 = actorThatChanged)
	endif
endevent
