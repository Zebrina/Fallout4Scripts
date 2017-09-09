scriptname Zebrina:Workshop:Objects:PowerLiftMiniCartScript extends Zebrina:Default:ReferenceParentScript conditional

import Math

group PowerLift_ConstProperties
	Keyword property WorkshopLinkPowerLift auto const mandatory
	Keyword property WorkshopLinkPowerLiftCallButton auto const mandatory
	Keyword property WorkshopLinkPowerLiftCallButtonMain auto const mandatory
	Keyword property WorkshopLinkPowerLiftButtonUp auto const mandatory
	Keyword property WorkshopLinkPowerLiftButtonDown auto const mandatory
	float property fCartPositionZOffset = 16.0 auto const
	float property fFullDistanceZ = 4096.0 auto const
	float property fFullAnimationDuration = 53.333 auto const
	float property fCartSafeRadius = 112.0 auto const
endgroup

group PowerLift_NonConstProperties
	float property fLiftSpeedMult = 1.0 auto
	int property UniqueID = 1 auto hidden
endgroup

float function GetLiftSpeedMult()
	if (fLiftSpeedMult <= 0.0)
		return 1.0
	endif
	return 1.0 / fLiftSpeedMult
endfunction

string sLiftHeightAnimVar = "fValue" const
string sLiftSpeedAnimVar = "fSpeed" const

ObjectReference property CallButtonMain hidden
	ObjectReference function get()
		return self.GetLinkedRef(WorkshopLinkPowerLiftCallButtonMain)
	endfunction
endproperty
ObjectReference property LiftButtonUp hidden
	ObjectReference function get()
		return self.GetLinkedRef(WorkshopLinkPowerLiftButtonUp)
	endfunction
endproperty
ObjectReference property LiftButtonDown hidden
	ObjectReference function get()
		return self.GetLinkedRef(WorkshopLinkPowerLiftButtonDown)
	endfunction
endproperty

bool bCartMoving = false conditional

function RegisterCallButton(ObjectReference akButton)
	if (akButton && akButton is Zebrina:Workshop:Objects:PowerLiftCallButtonScript)
        akButton.SetLinkedRef(self, WorkshopLinkPowerLiftCallButton)
		self.RegisterForRemoteEvent(akButton, "OnActivate")
		Debug.Notification("Power Lift call button registered")
	endif
endfunction
function UnregisterCallButton(ObjectReference akButton)
	if (akButton && akButton is Zebrina:Workshop:Objects:PowerLiftCallButtonScript)
		self.UnregisterForRemoteEvent(akButton, "OnActivate")
		akButton.SetLinkedRef(none, WorkshopLinkPowerLiftCallButton)
		Debug.Notification("Power Lift call button unregistered")
	endif
endfunction

; Zebrina:Default:ReferenceParentBaseScript override.
function InitializeChildReference(ObjectReference akChildRef, Keyword akLinkKeyword)
	; Call buttons will be linked with keywords and the panels without.
	if (akLinkKeyword != none)
		self.RegisterForRemoteEvent(akChildRef, "OnActivate")
	endif
endfunction

event OnLoad()

endevent

event OnWorkshopObjectPlaced(ObjectReference akReference)
	parent.OnWorkshopObjectPlaced(akReference)

	;/
	; Find all other power lifts linked to workshop.
	Zebrina:Workshop:Objects:PowerLiftMiniCartScript[] workshopPowerLifts = akReference.GetRefsLinkedToMe(WorkshopLinkPowerLift) as Zebrina:Workshop:Objects:PowerLiftMiniCartScript[]

	; Find available id.
	int i = 0
	while (i < workshopPowerLifts.Length)
		if (UniqueID == workshopPowerLifts[i].UniqueID)
			UniqueID += 1
			i = 0 ; Start over.
		else
			i += 1
		endif
	endwhile

	; Assign name with id.
	Zebrina:Utility:TextReplacement.SetNameWithID(self, UniqueID)
	/;

	; Link self to workshop.
	self.SetLinkedRef(akReference, WorkshopLinkPowerLift)

	Debug.Notification("Power Lift placed.")
endevent

float function GetCartPositionZMax()
	return self.GetPositionZ() + fCartPositionZOffset
endfunction
float function GetCartPositionZMin()
	return GetCartPositionZMax() - fFullDistanceZ
endfunction
float function GetCartPositionZ()
	return GetCartPositionZMax() - (self.GetAnimationVariableFloat(sLiftHeightAnimVar) * fFullDistanceZ)
endfunction

float function GetCartSpeedByDistanceZ(float fDistanceZ)
	return (Min(Abs(fDistanceZ), fFullDistanceZ) / fFullDistanceZ) * fFullAnimationDuration * GetLiftSpeedMult()
endfunction

float function GetLiftPositionPercentage(float fPositionZ)
	float posZMax = GetCartPositionZMax()
	if (fPositionZ > posZMax)
		return 1.0
	elseif (fPositionZ < GetCartPositionZMin())
		return 0.0
	endif

	return (posZMax - fPositionZ) / fFullDistanceZ
endfunction

function MoveCartToLevel(float fLevelPercentage)
	float currentHeight = self.GetAnimationVariableFloat(sLiftHeightAnimVar)
	if (fLevelPercentage != currentHeight)
		self.SetAnimationVariableFloat(sLiftSpeedAnimVar, Abs(currentHeight - fLevelPercentage) * fFullAnimationDuration * GetLiftSpeedMult())
		self.SetAnimationVariableFloat(sLiftHeightAnimVar, fLevelPercentage)
		self.PlayAnimationAndWait("Play01", "Done")
	endif
endfunction
function MoveCartToPositionZ(float fPositionZ)
	if (fPositionZ > GetCartPositionZMax())
		return
	endif

	float moveToHeight = GetLiftPositionPercentage(fPositionZ)
	float currentHeight = self.GetAnimationVariableFloat(sLiftHeightAnimVar)
	if (moveToHeight != currentHeight)
		self.SetAnimationVariableFloat(sLiftSpeedAnimVar, Abs(currentHeight - moveToHeight) * fFullAnimationDuration * GetLiftSpeedMult())
		self.SetAnimationVariableFloat(sLiftHeightAnimVar, moveToHeight)
		self.PlayAnimationAndWait("Play01", "Done")
	endif
endfunction
function MoveCartToReference(ObjectReference akReference)
	if (akReference == CallButtonMain)
		MoveCartToLevel(0.0)
	else
		MoveCartToPositionZ(akReference.GetPositionZ())
	endif
endfunction

ObjectReference function FindClosestCallButton(bool abDirectionUp)
	ObjectReference[] callButtons = self.GetRefsLinkedToMe(WorkshopLinkPowerLiftCallButton)
	if (callButtons.Length == 0)
		return none
	endif

	if (abDirectionUp)
		callButtons.Add(CallButtonMain)
	endif

	float cartPosZ = GetCartPositionZ()
	ObjectReference closestCallButton = none
	int i = 0
	while (i < callButtons.Length)
		ObjectReference callButtonRef = callButtons[i]
		if (abDirectionUp && callButtonRef.GetPositionZ() > cartPosZ)
			if (closestCallButton == none || callButtonRef.GetPositionZ() < closestCallButton.GetPositionZ())
				closestCallButton = callButtonRef
			endif
		elseif (!abDirectionUp && callButtonRef.GetPositionZ() < cartPosZ)
			if (closestCallButton == none || callButtonRef.GetPositionZ() > closestCallButton.GetPositionZ())
				closestCallButton = callButtonRef
			endif
		endif
		i += 1
	endwhile
	return closestCallButton
endfunction

;/
function ShakeItUp()
	ObjectReference ShakePoint = GetLinkedRef(LinkCustom04)

	if (Game.GetPlayer().GetDistance(ShakePoint) < 256.0)
		game.ShakeCamera(ShakePoint, 0.2, 0.5)
		game.ShakeController(0.1, 0.1, 0.5)
	endif
endfunction
/;

event ObjectReference.OnActivate(ObjectReference akSender, ObjectReference akActionRef)
	if (bCartMoving == false && akActionRef == Game.GetPlayer())
		bCartMoving = true
		if (akSender == CallButtonMain)
			MoveCartToReference(CallButtonMain)
		elseif (akSender == LiftButtonUp)
			ObjectReference callButton = FindClosestCallButton(true)
			if (callButton)
				MoveCartToReference(callButton)
			endif
		elseif (akSender == LiftButtonDown)
			ObjectReference callButton = FindClosestCallButton(false)
			if (callButton)
				MoveCartToReference(callButton)
			endif
		else
			MoveCartToReference(akSender)
		endif
		bCartMoving = false
	endif
endevent
