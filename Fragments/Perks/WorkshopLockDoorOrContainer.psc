;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
Scriptname Zebrina:Fragments:Perks:WorkshopLockDoorOrContainer Extends Perk Hidden Const

;BEGIN FRAGMENT Fragment_Entry_00
Function Fragment_Entry_00(ObjectReference akTargetRef, Actor akActor)
;BEGIN CODE
LockDoor(akTargetRef)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Entry_01
Function Fragment_Entry_01(ObjectReference akTargetRef, Actor akActor)
;BEGIN CODE
LockDoor(akTargetRef, false)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

function LockDoor(ObjectReference akTargetRef, bool abLock = true)
	if (abLock)
		akTargetRef.SetValue(WorkshopDoorLockedAV, 1)
		akTargetRef.SetLockLevel(255)
		akTargetRef.Lock()
		UILockpickingUnlock.Play(akTargetRef)
	else
		akTargetRef.SetValue(WorkshopDoorLockedAV, 0)
		akTargetRef.SetLockLevel(0)
		akTargetRef.Lock(false)
		UILockpickingUnlock.Play(akTargetRef)
	endif
endfunction

ActorValue property WorkshopDoorLockedAV auto const mandatory
Sound property UILockpickingUnlock auto const mandatory
