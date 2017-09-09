scriptname Zebrina:Combat:CombatMasterScript extends Quest

CustomEvent UpdateActorCombatInfo

Quest property AddCombatPerksQuest auto const mandatory
{ This quest adds the combat perk to all npcs in a new location that does not have it. }
Perk property UniversalCombatActorPerk auto const mandatory
{ The combat perk. }

group Versioning
    int property iScriptVersion_SaveGame auto hidden
    int property iScriptVersion_Latest = 1 auto hidden const
endgroup

function Trace(string asFunctionName, string asTextToPrint) debugonly
    Debug.TraceSelf(self, asFunctionName, asTextToPrint)
endfunction

Zebrina:Combat:CombatMasterScript function GetScript() global
    return Game.GetFormFromFile(0x4f9fcc, "ZebrinasWorkshop.esp") as Zebrina:Combat:CombatMasterScript
endfunction

function Initialize()
    Actor player = Game.GetPlayer()

    self.RegisterForRemoteEvent(player, "OnLocationChange")
    self.RegisterForRemoteEvent(player, "OnPlayerLoadGame")
endfunction

event OnInit()
    Initialize()
endevent
event Actor.OnPlayerLoadGame(Actor akSender)
    if (iScriptVersion_SaveGame == iScriptVersion_Latest)
        return
    endif

    self.UnregisterForAllRemoteEvents()
    Initialize()

    iScriptVersion_SaveGame = iScriptVersion_Latest
endevent

function InitializeCombatActor(Actor akActor)
    if (akActor == none)
        return
    endif

    akActor.AddPerk(UniversalCombatActorPerk)
    Trace("InitializeCombatActor", "Added combat perk to: " + akActor)
endfunction

event Actor.OnLocationChange(Actor akSender, Location akOldLoc, Location akNewLoc)
    AddCombatPerksQuest.Start()
endevent
