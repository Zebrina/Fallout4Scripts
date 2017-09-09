scriptname Zebrina:Robotics:RoboticsWorkshopMasterScript extends Quest

event OnInit()
    self.RegisterForRemoteEvent(Game.GetPlayer(), "OnPlayerLoadGame")
endevent

event Actor.OnPlayerLoadGame(Actor akSender)
endevent
