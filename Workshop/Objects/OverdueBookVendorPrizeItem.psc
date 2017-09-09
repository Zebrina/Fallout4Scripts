scriptname Zebrina:Workshop:Objects:OverdueBookVendorPrizeItem extends ReferenceAlias

import DN011OverdueBookVendingMachineSCRIPT

int property CountMin = 1 auto const
int property CountMax = 1 auto const
float property CostMult = 1.0 auto const

event OnAliasInit()
    self.GetReference().DisableNoWait()
endevent

ItemAndCount function ConvertToItemAndCount(DN011OverdueBookVendingMachineSCRIPT callingRef)
    ItemAndCount itemData = new ItemAndCount
    itemData.itemReference = self.GetReference()
    itemData.itemCost = ((callingRef.GetPrizeValue(self.GetReference()) as float) * CostMult) as int
    itemData.itemCount = Utility.RandomInt(CountMin, CountMax)
    return itemData
endfunction
