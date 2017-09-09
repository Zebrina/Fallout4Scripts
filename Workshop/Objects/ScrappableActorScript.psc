scriptname Zebrina:Workshop:Objects:ScrappableActorScript extends Actor const

Keyword property UnscrappableObject auto const mandatory

event OnLoad()
    if (!self.IsDead())
        self.AddKeyword(UnscrappableObject)
    endif
endevent

event OnDeath(Actor akKiller)
    self.ResetKeyword(UnscrappableObject)
endevent
