scriptName Zebrina:Workshop:Objects:PaintMixerScript extends ObjectReference

group PaintMixer_Properties
	;Activator property FFDiamondCity01PaintMixer01 auto const mandatory
	;{ Activator type in Hardware Town linked to actual paint mixer. }
	;Quest property FFDiamondCity01 auto const mandatory
	Message property FFDiamondCity01NeedPaintMessage auto const mandatory
	Message property PaintMixerPurpleNeedPaintMessage auto const mandatory
	Message property PaintMixerOrangeNeedPaintMessage auto const mandatory
	Message property WorkshopPaintMixerMessage auto const mandatory
	MiscObject property PaintCanBlue auto const mandatory
	MiscObject property PaintCanYellow auto const mandatory
	MiscObject property PaintCanGreen auto const mandatory
	MiscObject property DLC04PaintCanRed auto const mandatory
	MiscObject property PaintCanPurple auto const mandatory
	MiscObject property PaintCanOrange auto const mandatory
endgroup

bool function MixPaint(ObjectReference akActionRef, MiscObject akPaint1, MiscObject akPaint2, MiscObject akPaintMixed, Message akNeedPaintMessage)
	if (akActionRef.GetItemCount(akPaint1) == 0 || akActionRef.GetItemCount(akPaint2) == 0)
		akNeedPaintMessage.Show()
		return false
	endif

	; The paint mixer in HardwareTown01 plays the animation on its linked reference.
	;/
	ObjectReference refToPlayAnimation
	if (self.GetBaseObject() == FFDiamondCity01PaintMixer01)
		refToPlayAnimation = self.GetLinkedRef()
	else
		refToPlayAnimation = self
	endif
	/;
	self.PlayAnimationAndWait("Play01","End")

	akActionRef.AddItem(akPaintMixed, 1)
	akActionRef.RemoveItem(akPaint1, 1)
	akActionRef.RemoveItem(akPaint2, 1)

	return true
endfunction

auto state WaitingForActivation
	event OnActivate(ObjectReference akActionRef)
		if (akActionRef != Game.GetPlayer())
			return
		endif

		; Prevent activation spam.
		GoToState("HasBeenActivated")

		int buttonPressed = WorkshopPaintMixerMessage.Show()
		if (buttonPressed == 1)
			bool mixPaintSuccess = MixPaint(akActionRef, PaintCanBlue, PaintCanYellow, PaintCanGreen, FFDiamondCity01NeedPaintMessage)
			; Advance Abbot quest if on it.
			;/
			if (mixPaintSuccess && FFDiamondCity01.IsRunning() == true && FFDiamondCity01.GetStageDone(30) == 0 && FFDiamondCity01.GetStageDone(10) == 1)
				FFDiamondCity01.SetStage(30)
			endif
			/;
		elseif (buttonPressed == 2)
			MixPaint(akActionRef, PaintCanBlue, DLC04PaintCanRed, PaintCanPurple, PaintMixerPurpleNeedPaintMessage)
		elseif (buttonPressed == 3)
			MixPaint(akActionRef, DLC04PaintCanRed, PaintCanYellow, PaintCanOrange, PaintMixerOrangeNeedPaintMessage)
		else
		endif

		GoToState("WaitingForActivation")
	endevent
endstate


state HasBeenActivated
	; This is an empty state.
endstate
