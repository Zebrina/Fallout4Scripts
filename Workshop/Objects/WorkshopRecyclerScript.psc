scriptname Zebrina:Workshop:Objects:WorkshopRecyclerScript extends DLC05:WorkshopHopperScript

group Animation_Properties
	string property sAnimationBuilding = "Manufacture" auto const
	string property sAnimationHalt = "Halt" auto const
endGroup

group WorkshopRecycler_Properties
    FormList property WorkshopHopperComponentItemList auto const mandatory
    FormList property WorkshopHopperComponentList auto const mandatory
    Container property OutputContainerBaseObject auto const mandatory
endgroup

ObjectReference myOutputContainer = none
bool bRecycling = false

function StartRecycling(bool abStart = true)
	if (self.Is3DLoaded())
    	bRecycling = abStart
		if (abStart)
			self.PlayAnimation(sAnimationBuilding)
		else
			self.PlayAnimation(sAnimationHalt)
		endif
	endif
endFunction

; DLC05:WorkshopHopperScript override.
Event OnUnload()
	parent.OnUnload()
	StartRecycling(false)
endEvent

; DLC05:WorkshopHopperScript override.
function StartFiringTimerCustom()
	if (bRecycling == false && CheckInventory())
		StartRecycling()
	endif
endFunction

; DLC05:WorkshopHopperScript override.
bool function CheckInventory()
    return self.GetItemCount() > 0 || myOutputContainer.GetItemCount() > 0
endfunction

; DLC05:WorkshopHopperScript
function TryToFireProjectile()
    if (bFiring == false &&  CheckInventory() && self.IsPowered() && !self.IsDestroyed() && self.Is3DLoaded())
        ObjectReference refToFire = none

        bFiring = true

        if (self.GetItemCount() > 0)
            ObjectReference refToScrap = self.DropFirstObject(true)
            if (refToScrap)
                StartRecycling()
                MiscObject baseOBject = refToScrap.GetBaseObject() as MiscObject
                if (baseObject)
                    int i = 0
                    while (i < WorkshopHopperComponentList.GetSize())
                        int componentCount = baseObject.GetObjectComponentCount(WorkshopHopperComponentList.GetAt(i) as Component)
						if (componentCount > 0)
                        	myOutputContainer.AddItem(WorkshopHopperComponentItemList.GetAt(i), componentCount)
						endif

                        i += 1
                    endwhile

                    refToScrap.Delete()
                else
                    ; Can't be scrapped, fire as is.
                    refToFire = refToScrap
                endif
            endif
        endif

		; If our inventory is empty, start firing scrapped components from myOutputContainer.
        if (refToFire == none)
            refToFire = myOutputContainer.DropFirstObject(true)
        endif

        if (refToFire)
            string firingNode
            ; Check for large item node.
            if (LargeItemFormList && LargeItemFormList.HasForm(refToFire.GetBaseObject()))
                firingNode = ProjectileNodeLarge
            else
				firingNode = ProjectileNode
            endif

            Vector realVector = RotateVector(baseVector)
			refToFire.MoveToNode(self, firingNode)
            FireProjectile(refToFire, realVector, firingNode)
        endif

		bFiring = false
    endif

	; If we still have more inventory, run timer again.
	if (CheckInventory())
        if (self.IsPowered() && !self.IsDestroyed())
            StartRecycling()
    		StartFiringTimer()
        endif
    else
        StartRecycling(false)
	endif
endFunction

event OnWorkshopObjectPlaced(ObjectReference akReference)
    myOutputContainer = self.PlaceAtMe(OutputContainerBaseObject)
    myOutputContainer.BlockActivation(true, true)
endevent
event OnWorkshopObjectMoved(ObjectReference akReference)
    myOutputContainer.MoveTo(self)
endevent
event OnWorkshopObjectDestroyed(ObjectReference akActionRef)
    ObjectReference workshopRef = GetLinkedRef(WorkshopItemKeyword)
    myOutputContainer.RemoveAllItems(workshopRef)
    myOutputContainer.Disable()
    myOutputContainer.Delete()
endevent
