scriptname Zebrina:Workshop:Objects:WorkshopObjectNoPlayerCommentScript extends WorkshopObjectScript
{ Inherits WorkshopObjectScript. Same functionality except player does not make a comment when activated. }

; WorkshopObjectScript override.
event OnActivate(ObjectReference akActionRef)
    if (akActionRef == Game.Getplayer() && self.CanProduceForWorkshop() && self.HasKeyword(WorkshopParent.WorkshopRadioObject))
		bRadioOn = !bRadioOn
		WorkshopParent.UpdateRadioObject(self)
	endif

	if (self.GetBaseObject() is Flora)
		self.SetValue(WorkshopParent.WorkshopFloraHarvestTime, Utility.GetCurrentGameTime())
	endif
endevent
