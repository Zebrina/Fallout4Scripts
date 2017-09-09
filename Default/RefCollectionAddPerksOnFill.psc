scriptname Zebrina:Default:RefCollectionAddPerksOnFill extends RefCollectionAlias const

Perk[] property PerksToAdd auto const mandatory
bool property bStopQuest = true auto const

function AddPerksToActor(Actor akActor)
    if (akActor == none)
        return
    endif

    int i = PerksToAdd.Length
    while (i != 0)
        i -= 1
        akActor.AddPerk(PerksToAdd[i])
    endwhile
endfunction

event OnAliasInit()
    int i = self.GetCount()
    while (i != 0)
        i -= 1
        AddPerksToActor(self.GetAt(i) as Actor)
    endwhile

    if (bStopQuest)
        self.GetOwningQuest().Stop()
    endif
endevent
