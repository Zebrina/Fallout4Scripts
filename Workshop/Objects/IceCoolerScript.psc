scriptname Zebrina:Workshop:Objects:IceCoolerScript extends ObjectReference

group AutoFill_Properties
    Keyword property WorkshopCanBePowered auto const mandatory
endgroup

group IceCooler_Properties
    FormList property CoolableDrinks auto const mandatory
    FormList property CoolableDrinks_IceCold auto const mandatory
    float property fCoolingTimeGameHours = 24.0 auto const
endgroup

struct CoolableDrinkEntry
    float coolingTime
    Form drinkForm
    int count
endstruct

CoolableDrinkEntry[] myInventory

function StartCoolingTimer()
    if (myInventory.Length > 0 && (!self.HasKeyword(WorkshopCanBePowered) || self.IsPowered()))
        CoolableDrinkEntry entry = myInventory[myInventory.Length - 1]
        self.StartTimerGameTime(entry.coolingTime - (Utility.GetCurrentGameTime() * 24.0))
    endif
endfunction

Event OnInit()
    myInventory = new CoolableDrinkEntry[0]
EndEvent
Event OnLoad()
    self.RemoveAllInventoryEventFilters()
    self.AddInventoryEventFilter(CoolableDrinks)
EndEvent

Event OnCellAttach()
    StartCoolingTimer()
EndEvent
Event OnCellDetach()
    self.CancelTimerGameTime()
EndEvent

Event OnPowerOn(ObjectReference akPowerGenerator)
    int count = myInventory.Length
    while (count > 0)
        count -= 1
        CoolableDrinkEntry entry = myInventory[count]
        entry.coolingTime = (Utility.GetCurrentGameTime() * 24.0) + fCoolingTimeGameHours
    endwhile
EndEvent
Event OnPowerOff()
    self.CancelTimerGameTime()
EndEvent

Event OnTimerGameTime(int aiTimerID)
    if (myInventory.Length > 0)
        CoolableDrinkEntry drink = myInventory[myInventory.Length - 1]
        float coolingTime = drink.coolingTime
        while (myInventory.Length > 0 && myInventory[myInventory.Length - 1].coolingTime == coolingTime)
            self.RemoveItem(drink.drinkForm, drink.count)
            myInventory.RemoveLast()
        endwhile
    endif
    StartCoolingTimer()
EndEvent

event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
    CoolableDrinkEntry entry = new CoolableDrinkEntry
    entry.coolingTime = (Utility.GetCurrentGameTime() * 24.0) + fCoolingTimeGameHours
    entry.drinkForm = akBaseItem
    entry.count = aiItemCount
    myInventory.Insert(entry, 0)

    StartCoolingTimer()
EndEvent
Event OnItemRemoved(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akDestContainer)
    if (akDestContainer == none)
        int index = CoolableDrinks.Find(akBaseItem)
        if (index >= 0)
            self.AddItem(CoolableDrinks_IceCold.GetAt(index), aiItemCount)
        endif
    endif
EndEvent
