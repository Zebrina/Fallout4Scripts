scriptname Zebrina:Default:PlayerOrFavorActivationOnly extends ObjectReference const

event OnLoad()
    self.BlockActivation()
endevent

event OnActivate(ObjectReference akActionRef)
    if (akActionRef == Game.GetPlayer() || (akActionRef is Actor && (akActionRef as Actor).IsDoingFavor()))
        self.Activate(akActionRef, true)
    endif
endevent
