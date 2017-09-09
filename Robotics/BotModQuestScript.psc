scriptname Zebrina:Robotics:BotModQuestScript extends Quest

group Quests
    ;DLC01:DLC01BotModQuestScript property DLC01BotModQuest auto const mandatory
    DLC04:DLC04BotModQuestScript property DLC04BotModQuest auto const mandatory
    DLC04:DLC04GZMainQuestScript property DLC04GZMainQuest auto const mandatory
endgroup

group WorkbenchRobotLists
    FormList property DLC01WorkbenchRobotListHead auto const mandatory
    FormList property DLC01WorkbenchRobotListPaint auto const mandatory
    FormList property DLC01WorkbenchRobotListTorso auto const mandatory
endgroup
group BotExclusionLists
    FormList property DLC01Workbench_ExclusionList auto const mandatory
    FormList property RobotWorkbench_RobobrainAccessoryHeadExclusion auto const mandatory
    FormList property RobotWorkbench_RobobrainAccessoryTorsoExclusion auto const mandatory
endgroup
group BotRemovalLists
    FormList property DLC01Workbench_RemovalList auto const mandatory
    FormList property DLC01Workbench_RemovalListHandyHands auto const mandatory
    FormList property DLC01Workbench_RemovalListHandyRightHand auto const mandatory
    FormList property DLC01Workbench_RemovalListJezebel auto const mandatory
    FormList property DLC01Workbench_RemovalListProtectronHeadDomeArmors auto const mandatory
    FormList property RobotWorkbench_RemovalListProtectronHeadConstructionArmors auto const mandatory
    FormList property RobotWorkbench_RemovalListRobobrainAccessoryHead auto const mandatory
    FormList property RobotWorkbench_RemovalListRobobrainAccessoryTorso auto const mandatory
endgroup
group MrHandyAssignmentLists
    FormList property DLC01_RobotWorkbench_Index0_AssignmentList auto const mandatory
    FormList property DLC01_RobotWorkbench_Index1_AssignmentList auto const mandatory
    FormList property DLC01_RobotWorkbench_Index2_AssignmentList auto const mandatory
endgroup

group NewBotAttachPoints
    Keyword property ap_Bot_Accessory_Protectron_Head auto const mandatory
    Keyword property ap_Bot_Accessory_MrHandy_Head auto const mandatory
    Keyword property ap_Bot_Accessory_Robobrain_Face auto const mandatory
    Keyword property ap_Bot_Accessory_Robobrain_Head auto const mandatory
    Keyword property ap_Bot_Accessory_Robobrain_Torso auto const mandatory
    Keyword property ap_Bot_Accessory_SentryBot_Head auto const mandatory
    Keyword property ap_Bot_Paint_Protectron auto const mandatory
    Keyword property ap_Bot_Paint_MrHandy auto const mandatory
    Keyword property ap_Bot_Paint_Assaultron auto const mandatory
    Keyword property ap_Bot_Decal_MrHandy auto const mandatory
    Keyword property ap_Bot_Decal_Assaultron auto const mandatory
    Keyword property ap_Bot_Decal_SentryBot auto const mandatory
endgroup
group NewBotMods
    ObjectMod property DLC01Bot_Head_Protectron_Armor_Construction02 auto const mandatory
    ObjectMod property DLC01Bot_Head_Protectron_Armor_Fireman01 auto const mandatory
    ObjectMod property DLC01Bot_Head_Protectron_Armor_Medic01 auto const mandatory
    ObjectMod property DLC01Bot_Head_Protectron_Armor_Police01 auto const mandatory
    ObjectMod property DLC01Bot_Voice_Protectron auto const mandatory
    ObjectMod property DLC01Bot_Voice_Curie auto const mandatory
    ObjectMod property DLC01Bot_Voice_MrGutsy auto const mandatory
    ObjectMod property DLC01Bot_Voice_MrHandy auto const mandatory
    ObjectMod property DLC04Bot_Hand_MrGutsy_Weap_Laser_Blue_Left auto const mandatory
    ObjectMod property DLC04Bot_Hand_MrGutsy_Weap_Laser_Blue_Middle auto const mandatory
    ObjectMod property DLC04Bot_Hand_MrGutsy_Weap_Laser_Blue_Right auto const mandatory
    ObjectMod property DLC04Bot_Hand_MrGutsy_Weap_Laser_Left auto const mandatory
    ObjectMod property DLC04Bot_Hand_MrGutsy_Weap_Laser_Middle auto const mandatory
    ObjectMod property DLC04Bot_Hand_MrGutsy_Weap_Laser_Right auto const mandatory
    ObjectMod property DLC04Bot_Hand_MisterHandy_Weap_Mister_Left auto const mandatory
    ObjectMod property DLC04Bot_Hand_MisterHandy_Weap_Mister_Middle auto const mandatory
    ObjectMod property DLC04Bot_Hand_MisterHandy_Weap_Mister_Right auto const mandatory
endgroup

group NukaWorld_BotModGlobals
    ;GlobalVariable property co_DLC04Bot_Hand_MrGutsy_Weap_Laser_Global auto const mandatory
    GlobalVariable property co_DLC04Bot_Hand_MisterHandy_Weap_Mister_Global auto const mandatory
endgroup

group ItemData_Injection
    DLC04:DLC04BotModQuestScript:ItemDatum[] property DLC04ItemData auto const mandatory
endgroup

group Misc_Properties
    Message property InstalledMessage auto const
    Message property UninstalledMessage auto const
    Message property UpdatedMessage auto const
endgroup

int iSaveScriptVersion = 0
int property iScriptVersion hidden
    int function get()
        return 1
    endfunction
endproperty

bool _bBotAttachPointsAdded = false
bool _bBotModsAdded = false
bool _bBotModItemDataInjected = false

bool property bBotAttachPointsAdded hidden
    bool function get()
        return _bBotAttachPointsAdded
    endfunction
endproperty
bool property bBotModsAdded hidden
    bool function get()
        return _bBotModsAdded
    endfunction
endproperty
bool property bBotModItemDataInjected hidden
    bool function get()
        return _bBotModItemDataInjected
    endfunction
endproperty

event OnInit()
    AddNewBotAttachPoints()
    AddNewBotMods()
    InjectBotModItemData()

    if (DLC04GZMainQuest.GetStageDone(1000))
        UnlockNukaWorldBotMods()
    else
        self.RegisterForRemoteEvent(DLC04GZMainQuest, "OnStageSet")
    endif

    iSaveScriptVersion = iScriptVersion

    self.RegisterForRemoteEvent(Game.GetPlayer(), "OnPlayerLoadGame")

    InstalledMessage.Show()
endevent
event OnQuestShutdown()
    RemoveAddedBotAttachPoints()
    RemoveAddedBotMods()
    UndoInjectionOfBotModItemData()

    UninstalledMessage.Show()
endevent

event Actor.OnPlayerLoadGame(Actor akSender)
    if (iSaveScriptVersion == iScriptVersion)
        return
    endif

    iSaveScriptVersion = iScriptVersion

    ;/
    RemoveAddedBotAttachPoints()
    RemoveAddedBotMods()

    AddNewBotAttachPoints()
    AddNewBotMods()
    /;

    UpdatedMessage.Show()
endevent

event Quest.OnStageSet(Quest akSender, int auiStageID, int auiItemID)
    if (akSender == DLC04GZMainQuest)
        if (auiStageID == 1000)
            UnlockNukaWorldBotMods()
            self.UnregisterForRemoteEvent(DLC04GZMainQuest, "OnStageSet")
        endif
    endif
endevent

function UnlockNukaWorldBotMods()
    co_DLC04Bot_Hand_MisterHandy_Weap_Mister_Global.SetValue(1)
    ;co_DLC04Bot_Hand_MrGutsy_Weap_Laser_Global.SetValue(1) ; Not needed. Will already have been set despite not being used by the Nuka World plugin.
endfunction

function AddNewBotAttachPoints()
    ; Head
    DLC01WorkbenchRobotListHead.AddForm(ap_Bot_Accessory_Protectron_Head)
    DLC01WorkbenchRobotListHead.AddForm(ap_Bot_Accessory_Robobrain_Head)
    DLC01WorkbenchRobotListHead.AddForm(ap_Bot_Accessory_Robobrain_Face)
    DLC01WorkbenchRobotListHead.AddForm(ap_Bot_Accessory_SentryBot_Head)

    ; Torso
    DLC01WorkbenchRobotListTorso.AddForm(ap_Bot_Accessory_MrHandy_Head) ; Mr. Handy head accessory must be under torso since it has no head.
    DLC01WorkbenchRobotListTorso.AddForm(ap_Bot_Accessory_Robobrain_Torso)

    ; Signature Paint
    DLC01WorkbenchRobotListPaint.AddForm(ap_Bot_Paint_Protectron)
    DLC01WorkbenchRobotListPaint.AddForm(ap_Bot_Paint_MrHandy)
    DLC01WorkbenchRobotListPaint.AddForm(ap_Bot_Paint_Assaultron)

    ; Decals
    DLC01WorkbenchRobotListPaint.AddForm(ap_Bot_Decal_MrHandy)
    DLC01WorkbenchRobotListPaint.AddForm(ap_Bot_Decal_Assaultron)
    DLC01WorkbenchRobotListPaint.AddForm(ap_Bot_Decal_SentryBot)


    _bBotAttachPointsAdded = true
endfunction
function RemoveAddedBotAttachPoints()
    ; Head
    DLC01WorkbenchRobotListHead.RemoveAddedForm(ap_Bot_Accessory_Protectron_Head)
    DLC01WorkbenchRobotListHead.RemoveAddedForm(ap_Bot_Accessory_Robobrain_Head)
    DLC01WorkbenchRobotListHead.RemoveAddedForm(ap_Bot_Accessory_Robobrain_Face)
    DLC01WorkbenchRobotListHead.RemoveAddedForm(ap_Bot_Accessory_SentryBot_Head)

    ; Torso
    DLC01WorkbenchRobotListTorso.RemoveAddedForm(ap_Bot_Accessory_MrHandy_Head)
    DLC01WorkbenchRobotListTorso.RemoveAddedForm(ap_Bot_Accessory_Robobrain_Torso)

    ; Signature Paint
    DLC01WorkbenchRobotListPaint.RemoveAddedForm(ap_Bot_Paint_Protectron)
    DLC01WorkbenchRobotListPaint.RemoveAddedForm(ap_Bot_Paint_MrHandy)
    DLC01WorkbenchRobotListPaint.RemoveAddedForm(ap_Bot_Paint_Assaultron)

    ; Decals
    DLC01WorkbenchRobotListPaint.RemoveAddedForm(ap_Bot_Decal_MrHandy)
    DLC01WorkbenchRobotListPaint.RemoveAddedForm(ap_Bot_Decal_Assaultron)
    DLC01WorkbenchRobotListPaint.RemoveAddedForm(ap_Bot_Decal_SentryBot)

    _bBotAttachPointsAdded = false
endfunction

function AddNewBotMods()
    ; Exclusion/removal lists.
    DLC01Workbench_ExclusionList.AddForm(RobotWorkbench_RobobrainAccessoryHeadExclusion)
    DLC01Workbench_RemovalList.AddForm(RobotWorkbench_RemovalListRobobrainAccessoryHead)
    DLC01Workbench_ExclusionList.AddForm(RobotWorkbench_RobobrainAccessoryTorsoExclusion)
    DLC01Workbench_RemovalList.AddForm(RobotWorkbench_RemovalListRobobrainAccessoryTorso)

    ; Protectron Dome Head Armor removal list.
    DLC01Workbench_RemovalListProtectronHeadDomeArmors.AddForm(DLC01Bot_Head_Protectron_Armor_Construction02)
    DLC01Workbench_RemovalListProtectronHeadDomeArmors.AddForm(DLC01Bot_Head_Protectron_Armor_Fireman01)
    DLC01Workbench_RemovalListProtectronHeadDomeArmors.AddForm(DLC01Bot_Head_Protectron_Armor_Medic01)
    DLC01Workbench_RemovalListProtectronHeadDomeArmors.AddForm(DLC01Bot_Head_Protectron_Armor_Police01)

    ; Protectron construction armors removal list.
    RobotWorkbench_RemovalListProtectronHeadConstructionArmors.AddForm(DLC01Bot_Head_Protectron_Armor_Construction02)
    RobotWorkbench_RemovalListProtectronHeadConstructionArmors.AddForm(DLC01Bot_Head_Protectron_Armor_Fireman01)
    RobotWorkbench_RemovalListProtectronHeadConstructionArmors.AddForm(DLC01Bot_Head_Protectron_Armor_Medic01)
    RobotWorkbench_RemovalListProtectronHeadConstructionArmors.AddForm(DLC01Bot_Head_Protectron_Armor_Police01)

    ; Mr. Handy removal lists.
    ; Mr. Frothy mister.
    DLC01Workbench_RemovalListHandyHands.AddForm(DLC04Bot_Hand_MisterHandy_Weap_Mister_Middle)
    DLC01Workbench_RemovalListHandyHands.AddForm(DLC04Bot_Hand_MisterHandy_Weap_Mister_Right)
    DLC01Workbench_RemovalListHandyHands.AddForm(DLC04Bot_Hand_MisterHandy_Weap_Mister_Left)
    DLC01Workbench_RemovalListHandyRightHand.AddForm(DLC04Bot_Hand_MisterHandy_Weap_Mister_Right)
    ; Mr. Gutsy red laser.
    DLC01Workbench_RemovalListHandyHands.AddForm(DLC04Bot_Hand_MrGutsy_Weap_Laser_Middle)
    DLC01Workbench_RemovalListHandyHands.AddForm(DLC04Bot_Hand_MrGutsy_Weap_Laser_Right)
    DLC01Workbench_RemovalListHandyHands.AddForm(DLC04Bot_Hand_MrGutsy_Weap_Laser_Left)
    DLC01Workbench_RemovalListHandyRightHand.AddForm(DLC04Bot_Hand_MrGutsy_Weap_Laser_Right)
    ; Mr. Gutsy blue laser.
    DLC01Workbench_RemovalListHandyHands.AddForm(DLC04Bot_Hand_MrGutsy_Weap_Laser_Blue_Middle)
    DLC01Workbench_RemovalListHandyHands.AddForm(DLC04Bot_Hand_MrGutsy_Weap_Laser_Blue_Right)
    DLC01Workbench_RemovalListHandyHands.AddForm(DLC04Bot_Hand_MrGutsy_Weap_Laser_Blue_Left)
    DLC01Workbench_RemovalListHandyRightHand.AddForm(DLC04Bot_Hand_MrGutsy_Weap_Laser_Blue_Right)

    ; Mr. Handy assignment lists.
    ; Mr. Frothy mister.
    DLC01_RobotWorkbench_Index0_AssignmentList.AddForm(DLC04Bot_Hand_MisterHandy_Weap_Mister_Middle)
    DLC01_RobotWorkbench_Index1_AssignmentList.AddForm(DLC04Bot_Hand_MisterHandy_Weap_Mister_Right)
    DLC01_RobotWorkbench_Index2_AssignmentList.AddForm(DLC04Bot_Hand_MisterHandy_Weap_Mister_Left)
    ; Mr. Gutsy red laser.
    DLC01_RobotWorkbench_Index0_AssignmentList.AddForm(DLC04Bot_Hand_MrGutsy_Weap_Laser_Middle)
    DLC01_RobotWorkbench_Index1_AssignmentList.AddForm(DLC04Bot_Hand_MrGutsy_Weap_Laser_Right)
    DLC01_RobotWorkbench_Index2_AssignmentList.AddForm(DLC04Bot_Hand_MrGutsy_Weap_Laser_Left)
    ; Mr. Gutsy blue laser.
    DLC01_RobotWorkbench_Index0_AssignmentList.AddForm(DLC04Bot_Hand_MrGutsy_Weap_Laser_Blue_Middle)
    DLC01_RobotWorkbench_Index1_AssignmentList.AddForm(DLC04Bot_Hand_MrGutsy_Weap_Laser_Blue_Right)
    DLC01_RobotWorkbench_Index2_AssignmentList.AddForm(DLC04Bot_Hand_MrGutsy_Weap_Laser_Blue_Left)

    ; Jezebel removal list.
    DLC01Workbench_RemovalListJezebel.AddForm(DLC01Bot_Voice_Protectron)
    DLC01Workbench_RemovalListJezebel.AddForm(DLC01Bot_Voice_Curie)
    DLC01Workbench_RemovalListJezebel.AddForm(DLC01Bot_Voice_MrGutsy)
    DLC01Workbench_RemovalListJezebel.AddForm(DLC01Bot_Voice_MrHandy)

    _bBotModsAdded = true
endfunction
function RemoveAddedBotMods()
    ; Exclusion/removal lists.
    DLC01Workbench_ExclusionList.RemoveAddedForm(RobotWorkbench_RobobrainAccessoryHeadExclusion)
    DLC01Workbench_RemovalList.RemoveAddedForm(RobotWorkbench_RemovalListRobobrainAccessoryHead)
    DLC01Workbench_ExclusionList.RemoveAddedForm(RobotWorkbench_RobobrainAccessoryTorsoExclusion)
    DLC01Workbench_RemovalList.RemoveAddedForm(RobotWorkbench_RemovalListRobobrainAccessoryTorso)

    ; Protectron Dome Head Armor removal list.
    DLC01Workbench_RemovalListProtectronHeadDomeArmors.RemoveAddedForm(DLC01Bot_Head_Protectron_Armor_Construction02)
    DLC01Workbench_RemovalListProtectronHeadDomeArmors.RemoveAddedForm(DLC01Bot_Head_Protectron_Armor_Fireman01)
    DLC01Workbench_RemovalListProtectronHeadDomeArmors.RemoveAddedForm(DLC01Bot_Head_Protectron_Armor_Medic01)
    DLC01Workbench_RemovalListProtectronHeadDomeArmors.RemoveAddedForm(DLC01Bot_Head_Protectron_Armor_Police01)

    ; Protectron construction armors removal list.
    RobotWorkbench_RemovalListProtectronHeadConstructionArmors.RemoveAddedForm(DLC01Bot_Head_Protectron_Armor_Construction02)
    RobotWorkbench_RemovalListProtectronHeadConstructionArmors.RemoveAddedForm(DLC01Bot_Head_Protectron_Armor_Fireman01)
    RobotWorkbench_RemovalListProtectronHeadConstructionArmors.RemoveAddedForm(DLC01Bot_Head_Protectron_Armor_Medic01)
    RobotWorkbench_RemovalListProtectronHeadConstructionArmors.RemoveAddedForm(DLC01Bot_Head_Protectron_Armor_Police01)

    ; Mr. Handy removal lists.
    ; Mr. Frothy mister.
    DLC01Workbench_RemovalListHandyHands.RemoveAddedForm(DLC04Bot_Hand_MisterHandy_Weap_Mister_Middle)
    DLC01Workbench_RemovalListHandyHands.RemoveAddedForm(DLC04Bot_Hand_MisterHandy_Weap_Mister_Right)
    DLC01Workbench_RemovalListHandyHands.RemoveAddedForm(DLC04Bot_Hand_MisterHandy_Weap_Mister_Left)
    DLC01Workbench_RemovalListHandyRightHand.RemoveAddedForm(DLC04Bot_Hand_MisterHandy_Weap_Mister_Right)
    ; Mr. Gutsy red laser.
    DLC01Workbench_RemovalListHandyHands.RemoveAddedForm(DLC04Bot_Hand_MrGutsy_Weap_Laser_Middle)
    DLC01Workbench_RemovalListHandyHands.RemoveAddedForm(DLC04Bot_Hand_MrGutsy_Weap_Laser_Right)
    DLC01Workbench_RemovalListHandyHands.RemoveAddedForm(DLC04Bot_Hand_MrGutsy_Weap_Laser_Left)
    DLC01Workbench_RemovalListHandyRightHand.RemoveAddedForm(DLC04Bot_Hand_MrGutsy_Weap_Laser_Right)
    ; Mr. Gutsy blue laser.
    DLC01Workbench_RemovalListHandyHands.RemoveAddedForm(DLC04Bot_Hand_MrGutsy_Weap_Laser_Blue_Middle)
    DLC01Workbench_RemovalListHandyHands.RemoveAddedForm(DLC04Bot_Hand_MrGutsy_Weap_Laser_Blue_Right)
    DLC01Workbench_RemovalListHandyHands.RemoveAddedForm(DLC04Bot_Hand_MrGutsy_Weap_Laser_Blue_Left)
    DLC01Workbench_RemovalListHandyRightHand.RemoveAddedForm(DLC04Bot_Hand_MrGutsy_Weap_Laser_Blue_Right)

    ; Mr. Handy assignment lists.
    ; Mr. Frothy mister.
    DLC01_RobotWorkbench_Index0_AssignmentList.RemoveAddedForm(DLC04Bot_Hand_MisterHandy_Weap_Mister_Middle)
    DLC01_RobotWorkbench_Index1_AssignmentList.RemoveAddedForm(DLC04Bot_Hand_MisterHandy_Weap_Mister_Right)
    DLC01_RobotWorkbench_Index2_AssignmentList.RemoveAddedForm(DLC04Bot_Hand_MisterHandy_Weap_Mister_Left)
    ; Mr. Gutsy red laser.
    DLC01_RobotWorkbench_Index0_AssignmentList.RemoveAddedForm(DLC04Bot_Hand_MrGutsy_Weap_Laser_Middle)
    DLC01_RobotWorkbench_Index1_AssignmentList.RemoveAddedForm(DLC04Bot_Hand_MrGutsy_Weap_Laser_Right)
    DLC01_RobotWorkbench_Index2_AssignmentList.RemoveAddedForm(DLC04Bot_Hand_MrGutsy_Weap_Laser_Left)
    ; Mr. Gutsy blue laser.
    DLC01_RobotWorkbench_Index0_AssignmentList.RemoveAddedForm(DLC04Bot_Hand_MrGutsy_Weap_Laser_Blue_Middle)
    DLC01_RobotWorkbench_Index1_AssignmentList.RemoveAddedForm(DLC04Bot_Hand_MrGutsy_Weap_Laser_Blue_Right)
    DLC01_RobotWorkbench_Index2_AssignmentList.RemoveAddedForm(DLC04Bot_Hand_MrGutsy_Weap_Laser_Blue_Left)

    ; Jezebel removal list.
    DLC01Workbench_RemovalListJezebel.RemoveAddedForm(DLC01Bot_Voice_Protectron)
    DLC01Workbench_RemovalListJezebel.RemoveAddedForm(DLC01Bot_Voice_Curie)
    DLC01Workbench_RemovalListJezebel.RemoveAddedForm(DLC01Bot_Voice_MrGutsy)
    DLC01Workbench_RemovalListJezebel.RemoveAddedForm(DLC01Bot_Voice_MrHandy)

    _bBotModsAdded = false
endfunction

function InjectBotModItemData()
    int i = 0
    while (i < DLC04ItemData.Length)
        AddNukaWorldItemData(DLC04ItemData[i])
        i += 1
    endwhile

    _bBotModItemDataInjected = true
endfunction
function UndoInjectionOfBotModItemData()
    int i = 0
    while (i < DLC04ItemData.Length)
        RemoveNukaWorldItemData(DLC04ItemData[i])
        i += 1
    endwhile

    _bBotModItemDataInjected = false
endfunction

;/
function AddAutomatronItemData(DLC01:DLC01BotModQuestScript:ItemDatum itemData)
    if (DLC01BotModQuest.ItemData.FindStruct("ModMiscItem", itemData.ModMiscItem) < 0)
        DLC01BotModQuest.ItemData.Add(itemData)
    endif
endfunction
function RemoveAutomatronItemData(DLC01:DLC01BotModQuestScript:ItemDatum itemData)
    int index = DLC01BotModQuest.ItemData.FindStruct("ModMiscItem", itemData.ModMiscItem)
    if (index >= 0 && DLC01BotModQuest.ItemData[index].BotModKeyword == itemData.BotModKeyword && DLC01BotModQuest.ItemData[index].ModUnlockGlobal == itemData.ModUnlockGlobal)
        DLC01BotModQuest.ItemData.Remove(index)
    endif
endfunction
/;

function AddNukaWorldItemData(DLC04:DLC04BotModQuestScript:ItemDatum itemData)
    if (DLC04BotModQuest.ItemData.FindStruct("ModMiscItem", itemData.ModMiscItem) < 0)
        DLC04BotModQuest.ItemData.Add(itemData)
    endif
endfunction
function RemoveNukaWorldItemData(DLC04:DLC04BotModQuestScript:ItemDatum itemData)
    int index = DLC04BotModQuest.ItemData.FindStruct("ModMiscItem", itemData.ModMiscItem)
    if (index >= 0 && DLC04BotModQuest.ItemData[index].BotModKeyword == itemData.BotModKeyword && DLC04BotModQuest.ItemData[index].ModUnlockGlobal == itemData.ModUnlockGlobal)
        DLC04BotModQuest.ItemData.Remove(index)
    endif
endfunction
