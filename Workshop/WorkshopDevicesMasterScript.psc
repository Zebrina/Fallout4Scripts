scriptname Zebrina:Workshop:WorkshopDevicesMasterScript extends Quest conditional

group Initialization
    Message property ZebrinasWorkshopDevices_InitializeMessage auto const mandatory
endgroup

group Perks
    Perk property WorkshopQuickConfigPerk auto const mandatory
    Perk property WorkshopLockDoorOrContainerPerk auto const mandatory
    Perk property WorkshopChainDoorPerk auto const mandatory
endgroup

event OnInit()
    Actor player = Game.GetPlayer()

    player.AddPerk(WorkshopLockDoorOrContainerPerk)
    ;player.AddPerk(WorkshopChainDoorPerk)

    self.RegisterForRemoteEvent(player, "OnPlayerLoadGame")

    ZebrinasWorkshopDevices_InitializeMessage.Show()
endevent

event Actor.OnPlayerLoadGame(Actor akSender)
    Actor player = Game.GetPlayer()

    if (!player.HasPerk(WorkshopQuickConfigPerk))
        player.AddPerk(WorkshopQuickConfigPerk)
    endif
endevent
