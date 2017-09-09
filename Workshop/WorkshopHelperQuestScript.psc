scriptname Zebrina:Workshop:WorkshopHelperQuestScript extends Quest const

import Zebrina:Common

Perk property WorkshopHelperPerk auto const mandatory

event OnQuestInit()
    Actor player = Game.GetPlayer()

    self.RegisterForRemoteEvent(player, "OnPlayerLoadGame")

    Game.GetPlayer().AddPerk(WorkshopHelperPerk)
endevent
event OnQuestShutdown()
    Game.GetPlayer().RemovePerk(WorkshopHelperPerk)
endevent

event Actor.OnPlayerLoadGame(Actor akSender)
endevent
