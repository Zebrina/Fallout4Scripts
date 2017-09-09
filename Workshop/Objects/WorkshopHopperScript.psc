scriptname Zebrina:Workshop:Objects:WorkshopHopperScript extends DLC05:WorkshopHopperScript

group WorkshopHopper_Properties
    FormList property WorkshopHopperComponentItemList auto const mandatory
    FormList property WorkshopHopperComponentList auto const mandatory
    Container property OutputContainerBaseObject auto const mandatory
endgroup

struct InventoryEntry
    Form item
    int componentIndex ; -1 if not a component.
endstruct

ObjectReference myWorkshopRef = none
ObjectReference myOutputContainer = none
InventoryEntry[] myInventory
bool bInventoryLock = false

function LockMyInventory()
    while (bInventoryLock)
        Utility.WaitMenuMode(0.1)
    endwhile
    bInventoryLock = true
endfunction

function RefillOutputContainer()
    LockMyInventory()
    int i = 0
    while (i < myInventory.Length)
        InventoryEntry entry = myInventory[i]
        if (entry.componentIndex < 0)
            int count = Math.Min(self.GetItemCount(entry.item), myWorkshopRef.GetItemCount(entry.item)) as int
            if (count > 0)
                myWorkshopRef.RemoveItem(entry.item, count, akOtherContainer = myOutputContainer)
            endif
        else
            Component componentForm = WorkshopHopperComponentList.GetAt(entry.componentIndex) as Component
            int count = Math.Min(self.GetItemCount(entry.item), myWorkshopRef.GetComponentCount(componentForm)) as int
            if (count > 0)
                myWorkshopRef.RemoveComponents(componentForm, count)
                myOutputContainer.AddItem(entry.item, count)
            endif
        endif

        i += 1
    endwhile
    ; Release lock.
    bInventoryLock = false
endfunction

; DLC05:WorkshopHopperScript override.
bool function CheckInventory()
    if (myOutputContainer.GetItemCount() == 0)
        RefillOutputContainer()
    endif
    return myOutputContainer.GetItemCount() > 0
endfunction

; DLC05:WorkshopHopperScript override.
function TryToFireProjectile()
	if (bFiring == false && CheckInventory() && self.IsPowered() && !self.IsDestroyed() && self.Is3DLoaded())
		bFiring = true

		ObjectReference refToFire = myOutputContainer.DropFirstObject(true) ; disabled so not visible
		if (refToFire)
            string firingNode = ProjectileNode

			; check for large item node
			if (LargeItemFormList && LargeItemFormList.HasForm(refToFire.GetBaseObject()))
				firingNode = ProjectileNodeLarge
				refToFire.MoveToNode(self, ProjectileNodeLarge)
			else
				refToFire.MoveToNode(self, ProjectileNode)
			endif

			; calculate havok impulse with current rotation
		  	Vector realVector = RotateVector(baseVector)

			FireProjectile(refToFire, realVector, firingNode)
		endif

		bFiring = false
	endif

	bFiring = false

	; if we still have more inventory, run timer again
	if (CheckInventory())
		StartFiringTimer()
	endif
endFunction

event ObjectReference.OnItemAdded(ObjectReference akSender, Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
    if (akSender == myWorkshopRef)
        StartFiringTimer()
    endif
endevent

event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
    LockMyInventory()
    if (myInventory.FindStruct("item", akBaseItem) < 0)
        InventoryEntry newEntry = new InventoryEntry
        newEntry.item = akBaseItem
        newEntry.componentIndex = WorkshopHopperComponentItemList.Find(akBaseItem)

        myInventory.Add(newEntry)
    endif
    ; Release lock.
    bInventoryLock = false
endevent
event OnItemRemoved(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akDestContainer)
    LockMyInventory()
    if (self.GetItemCount(akBaseItem) == 0)
        int index = myInventory.FindStruct("item", akBaseItem)
        if (index >= 0)
            myInventory.Remove(index)
        endif
    endif
    ; Release lock.
    bInventoryLock = false
endevent

event OnWorkshopObjectPlaced(ObjectReference akReference)
    myWorkshopRef = akReference
    myOutputContainer = self.PlaceAtMe(OutputContainerBaseObject)
    myInventory = new InventoryEntry[0]

    self.RegisterForRemoteEvent(myWorkshopRef, "OnItemAdded")

    myOutputContainer.BlockActivation(true, true)
endevent
event OnWorkshopObjectMoved(ObjectReference akReference)
    myOutputContainer.MoveTo(self)
endevent
event OnWorkshopObjectDestroyed(ObjectReference akActionRef)
    myOutputContainer.RemoveAllItems(myWorkshopRef)
    myOutputContainer.Disable()
    myOutputContainer.Delete()
endevent
