Scriptname condiexp_MCM extends SKI_ConfigBase
import CondiExp_util
import CondiExp_log

GlobalVariable Property Condiexp_GlobalCombat Auto
GlobalVariable Property Condiexp_GlobalDrunk Auto
GlobalVariable Property Condiexp_GlobalNoClothes Auto
GlobalVariable Property Condiexp_GlobalEating Auto
GlobalVariable Property Condiexp_GlobalPain Auto
GlobalVariable Property Condiexp_GlobalRandom Auto
GlobalVariable Property Condiexp_GlobalCold Auto
GlobalVariable Property Condiexp_GlobalSkooma Auto
GlobalVariable Property Condiexp_GlobalSneaking Auto
GlobalVariable Property Condiexp_GlobalStamina Auto
GlobalVariable Property Condiexp_GlobalWater Auto
GlobalVariable Property Condiexp_CurrentlyBusy Auto
GlobalVariable Property Condiexp_ColdMethod Auto
GlobalVariable Property Condiexp_GlobalMana Auto
GlobalVariable Property Condiexp_Sounds Auto
GlobalVariable Property Condiexp_GlobalTrauma Auto
GlobalVariable Property Condiexp_GlobalDirty Auto
GlobalVariable Property Condiexp_GlobalAroused Auto
GlobalVariable Property Condiexp_GlobalArousalModifiers Auto
GlobalVariable Property Condiexp_GlobalArousalModifiersNotifications Auto
GlobalVariable Property Condiexp_Verbose Auto
GlobalVariable Property Condiexp_UpdateInterval Auto
GlobalVariable Property Condiexp_FollowersUpdateInterval Auto
GlobalVariable Property Condiexp_PO3ExtenderInstalled Auto

GlobalVariable Property Condiexp_ExpressionStr Auto
GlobalVariable Property Condiexp_ModifierStr Auto
GlobalVariable Property Condiexp_PhonemeStr Auto
String Property currentExpression Auto


Race Property OrcRace Auto
Race Property OrcRaceVampire Auto
Race Property KhajiitRace Auto
Race Property KhajiitRaceVampire Auto

CondiExp_StartMod Property Go Auto
Spell Property CondiExp_Effects Auto
Actor Property PlayerRef Auto
Quest Property CondiExpQuest Auto
Quest Property CondiExpFollowerQuest Auto


int Combat_B
int Drunk_B
int Clothes_B
int Pain_B
int Random_B
int Cold_B
int Skooma_B
int Sneaking_B
int Stamina_B
int Water_B
int headache_B
int restore
int update
int uninstall
int Sounds_B
int Trauma_B
int Dirty_B
int Aroused_B
int ArousedModifiers_B
int ArousedModifiersNotifications_B
int Verbose_B
int Followers_B
int registerFollowers
int _update_interval_slider
int _update_interval_followers_slider
int _expression_strength_slider
int _modifier_strength_slider
int _phoneme_strength_slider

bool CombatToggle = true
bool DrunkToggle = true
bool ClothesToggle = true
bool PainToggle = true
bool RandomToggle = true
bool ColdToggle = true
bool SkoomaToggle = true
bool SneakingToggle = true
bool StaminaToggle = true
bool WaterToggle = true
bool HeadacheToggle = True
bool SoundsToggle = True
bool TraumaToggle = true
bool DirtyToggle = true
bool ArousedToggle = true
bool ArousedModifiersToggle = true
bool ArousedModifiersNotificationsToggle = true
bool VerboseToggle = false 
bool FollowersToggle = false 

int EatingFastSlow_M
string EatingFastSlow
int EatingFastSlowIndex = 1
string[] EatingFastSlowList

int ColdMethod_M
string ColdMethod
int ColdMethodIndex = 4
string[] ColdMethodList

Int oidHKPause
Int oidHKRegisterFollowers
GlobalVariable Property Condiexp_HKPause Auto ; HOTKEY ==========
GlobalVariable Property Condiexp_HKRegisterFollowers Auto ; HOTKEY ==========

int function GetVersion()
    return CondiExp_util.GetVersion()
endFunction

Event OnConfigInit()
	ModName="Conditional Expressions Extended"
	Notification("MCM menu initialized")
EndEvent

event OnVersionUpdate(int a_version)
    if (a_version > 1)
      DetectRace()
	endIf
endEvent

Event OnConfigOpen()
	Pages = New String[3]
	Pages[0] = "$CEE_A3"
	Pages[1] = "$CEE_A4"
	Pages[2] = "$CEE_A5"

	EatingFastSlowList = new string[3]
	EatingFastSlowList[0] = "$CEE_A6"
	EatingFastSlowList[1] = "$CEE_A7"
	EatingFastSlowList[2] = "$CEE_A8"

	ColdMethodList = new string[5]
	ColdMethodList[0] = "$CEE_A9"
	ColdMethodList[1] = "$CEE_B1"
	ColdMethodList[2] = "$CEE_B2"
	ColdMethodList[3] = "$CEE_B3"
	ColdMethodList[4] = "$CEE_B4"
EndEvent

Event OnPageReset(string page)
	If (page == "")
		LoadCustomContent("MCM/MCM_CondiExp.dds", 0.0, 0.0)
	Else
		UnloadCustomContent()
	Endif
	
	if (page == "$CEE_A3")
		Expressions()
	elseIf (page == "$CEE_A4")
		Settings()
	elseIf (page == "$CEE_A5")
		Maintenance()
	endIf
EndEvent


Function Expressions()
	SetCursorFillMode(LEFT_TO_RIGHT)
	AddHeaderOption("Conditional Expressions Extended.Version: " + GetVersionString())
	AddHeaderOption("$CEE_B7")
	AddEmptyOption()
	AddEmptyOption()
	AddEmptyOption()
	EatingFastSlow_M = AddMenuOption("$CEE_B8", EatingFastSlowList[EatingFastSlowIndex])
	If PlayerRef.IsInCombat()
		Combat_B = AddToggleOption("$CEE_B9", CombatToggle, OPTION_FLAG_DISABLED)
		else
		Combat_B = AddToggleOption("$CEE_B9", CombatToggle)
	endif
	Random_B = AddToggleOption("$CEE_C1", RandomToggle)
	Cold_B = AddToggleOption("$CEE_C2", ColdToggle)
	Stamina_B = AddToggleOption("$CEE_C3", StaminaToggle)
	coldmethod_M = AddMenuOption("$CEE_C4", ColdMethodList[ColdMethodIndex]) 
	Pain_B = AddToggleOption("$CEE_C5", PainToggle)
	Drunk_B = AddToggleOption("$CEE_C6", DrunkToggle)
	Skooma_B = AddToggleOption("$CEE_C7", SkoomaToggle)
	Clothes_B = AddToggleOption("$CEE_C8", ClothesToggle)
	Sneaking_B = AddToggleOption("$CEE_C9", SneakingToggle)
	Water_B = AddToggleOption("$CEE_D1", WaterToggle)
	Headache_B = AddToggleOption("$CEE_D2", HeadacheToggle)
	Trauma_B = AddToggleOption("$CEE_D3", TraumaToggle)
	Dirty_B = AddToggleOption("$CEE_D4", DirtyToggle)
	Aroused_B = AddToggleOption("$CEE_D5", ArousedToggle)
EndFunction


Function Settings()
	SetCursorFillMode(TOP_TO_BOTTOM)
	AddHeaderOption("$CEE_D6")
	AddEmptyOption()
	Sounds_B = AddToggleOption("$CEE_D7", SoundsToggle)
	_update_interval_slider = AddSliderOption("$CEE_D8", Condiexp_UpdateInterval.GetValueInt(), "{0}", OPTION_FLAG_NONE)
	_expression_strength_slider = AddSliderOption("$CEE_D9", Condiexp_ExpressionStr.GetValue(), "{2}", OPTION_FLAG_NONE)
	_modifier_strength_slider = AddSliderOption("$CEE_E1", Condiexp_ModifierStr.GetValue(), "{2}", OPTION_FLAG_NONE)
	_phoneme_strength_slider = AddSliderOption("$CEE_E2", Condiexp_PhonemeStr.GetValue(), "{2}", OPTION_FLAG_NONE)
	AddHeaderOption("$CEE_E3")
	Followers_B =  AddToggleOption("$CEE_E4", CondiExpFollowerQuest.IsRunning())
	_update_interval_followers_slider = AddSliderOption("$CEE_E5", Condiexp_FollowersUpdateInterval.GetValueInt(), "{0}", _getFlag(FollowersToggle))
	registerFollowers = AddTextOption("$CEE_E6", "")
	oidHKRegisterFollowers = AddKeyMapOption("Register followers key", Condiexp_HKRegisterFollowers.GetValueInt())
	ArousedModifiers_B = AddToggleOption("Aroused Modifiers", ArousedModifiersToggle)
	ArousedModifiersNotifications_B = AddToggleOption("Aroused Modifiers Notifications", ArousedModifiersNotificationsToggle)
EndFunction

Function Maintenance()
	SetCursorFillMode(TOP_TO_BOTTOM)
	AddHeaderOption("$CEE_E7")
	AddEmptyOption()
	Update = AddTextOption("$CEE_E8", "")
	restore = AddTextOption("Reset Current Expression: " + currentExpression, "")
	Uninstall = AddTextOption("$CEE_F1", "")
	Verbose_B =  AddToggleOption("$CEE_F2", VerboseToggle)
	oidHKPause = AddKeyMapOption("Pause-Unpause mod  key", Condiexp_HKPause.GetValueInt())
EndFunction

Event OnOptionSliderOpen(Int mcm_option)
	If (mcm_option == _update_interval_slider)
		SetSliderDialogStartValue(Condiexp_UpdateInterval.GetValueInt())
		SetSliderDialogRange(0, 60)
		SetSliderDialogInterval(1.00)
		SetSliderDialogDefaultValue(5)
	elseif (mcm_option == _update_interval_followers_slider)
		SetSliderDialogStartValue(Condiexp_FollowersUpdateInterval.GetValueInt())
		SetSliderDialogRange(1, 60)
		SetSliderDialogInterval(1.00)
		SetSliderDialogDefaultValue(3)	
	elseif (mcm_option == _expression_strength_slider)
		SetSliderDialogStartValue(Condiexp_ExpressionStr.GetValue())
		SetSliderDialogRange(0, 2.0)
		SetSliderDialogInterval(0.01)
		SetSliderDialogDefaultValue(1.0)
	elseif (mcm_option == _modifier_strength_slider)
		SetSliderDialogStartValue(Condiexp_ModifierStr.GetValue())
		SetSliderDialogRange(0, 2.0)
		SetSliderDialogInterval(0.01)
		SetSliderDialogDefaultValue(1.0)
	elseif (mcm_option == _phoneme_strength_slider)
		SetSliderDialogStartValue(Condiexp_PhonemeStr.GetValue())
		SetSliderDialogRange(0, 2.0)
		SetSliderDialogInterval(0.01)
		SetSliderDialogDefaultValue(1.0)
	endIf
EndEvent

Event OnOptionSliderAccept(Int mcm_option, Float Value)
	If (mcm_option == _update_interval_slider)
		Condiexp_UpdateInterval.SetValue(Value)
		SetSliderOptionValue(mcm_option, Value, "{0}")
	elseif (mcm_option == _update_interval_followers_slider)
		Condiexp_FollowersUpdateInterval.SetValue(Value)
		SetSliderOptionValue(mcm_option, Value, "{0}")
	elseif (mcm_option == _expression_strength_slider)
		Condiexp_ExpressionStr.SetValue(Value)
		SetSliderOptionValue(mcm_option, Value, "{2}")
	elseif (mcm_option == _modifier_strength_slider)
		Condiexp_ModifierStr.SetValue(Value)
		SetSliderOptionValue(mcm_option, Value, "{2}")
	elseif (mcm_option == _phoneme_strength_slider)
		Condiexp_PhonemeStr.SetValue(Value)
		SetSliderOptionValue(mcm_option, Value, "{2}")
	endIf
EndEvent

event OnOptionMenuOpen(int option)
	if (option == EatingFastSlow_M)
		SetMenuDialogOptions(EatingFastSlowList)
		SetMenuDialogStartIndex(EatingFastSlowIndex)
		SetMenuDialogDefaultIndex(1)

	elseif (option == ColdMethod_M)
		SetMenuDialogOptions(ColdMethodList)
		SetMenuDialogStartIndex(ColdMethodIndex)
		SetMenuDialogDefaultIndex(4)
	endIf
endEvent


event OnOptionMenuAccept(int option, int index)
	if (option == EatingFastSlow_M)
		EatingFastSlowIndex = index
		SetMenuOptionValue(EatingFastSlow_M, EatingFastSlowList[EatingFastSlowIndex])
	if index == 0
		Condiexp_GlobalEating.SetValueInt(2)
	elseif index == 1
		Condiexp_GlobalEating.SetValueInt(1)
	elseif index == 2
		Condiexp_GlobalEating.SetValueInt(0)
	endif
	endif

If (option == ColdMethod_M)
		ColdMethodindex = index
		SetMenuOptionValue(coldmethod_M, coldmethodList[coldmethodindex])
	if index == 0
		;ColdMethodList[0] = "Vanilla - Snowing"
		Condiexp_ColdMethod.SetValueInt(4)
	elseif index == 1
		;ColdMethodList[1] = "Frostfall"
		Condiexp_ColdMethod.SetValueInt(1)
	elseif index == 2
		;ColdMethodList[2] = "Frostbite"
		Condiexp_ColdMethod.SetValueInt(2)
	elseif index == 3
		;ColdMethodList[3] = "Sunhelm Survival"
		Condiexp_ColdMethod.SetValueInt(3)
	else
		;ColdMethodList[4] = "Automatic"
		Condiexp_ColdMethod.SetValueInt(5)
		_restart()
		Notification("Restarted to apply Automatic Cold Detection option!")
	endif
	
endif
EndEvent


event OnOptionSelect(int option)

if (option == Combat_B) && CombatToggle == True
		CombatToggle = False
		SetToggleOptionValue(Combat_B, CombatToggle)
		Condiexp_GlobalCombat.SetValueInt(0)
	elseif (option == Combat_B) && CombatToggle == False
		CombatToggle = True
		SetToggleOptionValue(Combat_B, CombatToggle)
		Condiexp_GlobalCombat.SetValueInt(1)

	elseif (option == Random_B) && RandomToggle == True
		RandomToggle = False
		SetToggleOptionValue(Random_B, RandomToggle)
		Condiexp_GlobalRandom.SetValueInt(0)
	elseif (option == Random_B) && RandomToggle == False
		RandomToggle = True
		SetToggleOptionValue(Random_B, RandomToggle)
		Condiexp_GlobalRandom.SetValueInt(1)
	elseif (option == Cold_B) && ColdToggle == True
		ColdToggle = False
		SetToggleOptionValue(Cold_B, ColdToggle)
		Condiexp_GlobalCold.SetValueInt(0)
	elseif (option == Cold_B) && ColdToggle == False
		ColdToggle = True
		SetToggleOptionValue(Cold_B, ColdToggle)
		Condiexp_GlobalCold.SetValueInt(1)

	elseif (option == Stamina_B) && StaminaToggle == True
		StaminaToggle = False
		SetToggleOptionValue(Stamina_B, StaminaToggle)
		Condiexp_GlobalStamina.SetValueInt(0)
	elseif (option == Stamina_B) && StaminaToggle == False
		StaminaToggle = True
		SetToggleOptionValue(Stamina_B, StaminaToggle)
		Condiexp_GlobalStamina.SetValueInt(1)

	elseif (option == Pain_B) && PainToggle == True
		PainToggle = False
		SetToggleOptionValue(Pain_B, PainToggle)
		Condiexp_GlobalPain.SetValueInt(0)
	elseif (option == Pain_B) && PainToggle == False
		PainToggle = True
		SetToggleOptionValue(Pain_B, PainToggle)
		Condiexp_GlobalPain.SetValueInt(1)

	elseif (option == Drunk_B) && DrunkToggle == True
		DrunkToggle = False
		SetToggleOptionValue(Drunk_B, DrunkToggle)
		Condiexp_GlobalDrunk.SetValueInt(0)
	elseif (option == Drunk_B) && DrunkToggle == False
		DrunkToggle = True
		SetToggleOptionValue(Drunk_B, DrunkToggle)
		Condiexp_GlobalDrunk.SetValueInt(1)

	elseif (option == Skooma_B) && SkoomaToggle == True
		SkoomaToggle = False
		SetToggleOptionValue(Skooma_B, SkoomaToggle)
		Condiexp_GlobalSkooma.SetValueInt(0)
	elseif (option == Skooma_B) && SkoomaToggle == False
		SkoomaToggle = True
		SetToggleOptionValue(Skooma_B, SkoomaToggle)
		Condiexp_GlobalSkooma.SetValueInt(1)

	elseif (option == Clothes_B) && ClothesToggle == True
		ClothesToggle = False
		SetToggleOptionValue(Clothes_B, ClothesToggle )
		Condiexp_GlobalNoClothes.SetValueInt(0)
	elseif (option == Clothes_B) && ClothesToggle == False
		ClothesToggle = True
		SetToggleOptionValue(Clothes_B, ClothesToggle )
		Condiexp_GlobalNoClothes.SetValueInt(1)

	elseif (option == Sneaking_B) && SneakingToggle == True
		SneakingToggle = False
		SetToggleOptionValue(Sneaking_B, SneakingToggle)
		Condiexp_GlobalSneaking.SetValueInt(0)
	elseif (option == Sneaking_B) && SneakingToggle == False
		SneakingToggle = True
		SetToggleOptionValue(Sneaking_B, SneakingToggle)
		Condiexp_GlobalSneaking.SetValueInt(1)

	elseif (option == Water_B) && WaterToggle == True
		WaterToggle = False
		SetToggleOptionValue(Water_B, WaterToggle)
		Condiexp_GlobalWater.SetValueInt(0)
	elseif (option == Water_B) && WaterToggle == False
		WaterToggle = True
		SetToggleOptionValue(Water_B, WaterToggle)
		Condiexp_GlobalWater.SetValueInt(1)

	elseif (option == Headache_B) && HeadacheToggle == True
		HeadacheToggle = False
		SetToggleOptionValue(Headache_B, HeadacheToggle)
		Condiexp_GlobalMana.SetValueInt(0)
	elseif (option == Headache_B) && HeadacheToggle == False
		HeadacheToggle = True
		SetToggleOptionValue(Headache_B, HeadacheToggle)
		Condiexp_GlobalMana.SetValueInt(1)

	elseif (option == Trauma_B) && TraumaToggle == True
		TraumaToggle = False
		SetToggleOptionValue(Trauma_B, TraumaToggle)
		Condiexp_GlobalTrauma.SetValueInt(0)
	elseif (option == Trauma_B) && TraumaToggle == False
		TraumaToggle = True
		SetToggleOptionValue(Trauma_B, TraumaToggle)
		Condiexp_GlobalTrauma.SetValueInt(1)

	elseif (option == Dirty_B) && DirtyToggle == True
		DirtyToggle = False
		SetToggleOptionValue(Dirty_B, DirtyToggle)
		Condiexp_GlobalDirty.SetValueInt(0)
	elseif (option == Dirty_B) && DirtyToggle == False
		DirtyToggle = True
		SetToggleOptionValue(Dirty_B, DirtyToggle)
		Condiexp_GlobalDirty.SetValueInt(1)

	elseif (option == Aroused_B) && ArousedToggle == True
		ArousedToggle = False
		SetToggleOptionValue(Aroused_B, ArousedToggle)
		Condiexp_GlobalAroused.SetValueInt(0)
	elseif (option == Aroused_B) && ArousedToggle == False
		ArousedToggle = True
		SetToggleOptionValue(Aroused_B, ArousedToggle)
		Condiexp_GlobalAroused.SetValueInt(1)

	elseif (option == ArousedModifiers_B) && ArousedModifiersToggle == True
		ArousedModifiersToggle = False
		SetToggleOptionValue(ArousedModifiers_B, ArousedModifiersToggle)
		Condiexp_GlobalArousalModifiers.SetValueInt(0)
	elseif (option == ArousedModifiers_B) && ArousedModifiersToggle == False
		ArousedModifiersToggle = True
		SetToggleOptionValue(ArousedModifiers_B, ArousedModifiersToggle)
		Condiexp_GlobalArousalModifiers.SetValueInt(1)

	elseif (option == ArousedModifiersNotifications_B) && ArousedModifiersNotificationsToggle == True
		ArousedModifiersNotificationsToggle = False
		SetToggleOptionValue(ArousedModifiersNotifications_B, ArousedModifiersNotificationsToggle)
		Condiexp_GlobalArousalModifiersNotifications.SetValueInt(0)
	elseif (option == ArousedModifiersNotifications_B) && ArousedModifiersNotificationsToggle == False
		ArousedModifiersNotificationsToggle = True
		SetToggleOptionValue(ArousedModifiersNotifications_B, ArousedModifiersNotificationsToggle)
		Condiexp_GlobalArousalModifiersNotifications.SetValueInt(1)

	elseif (option == Verbose_B) && VerboseToggle == True
		VerboseToggle = False
		SetToggleOptionValue(Verbose_B, VerboseToggle)
		Condiexp_Verbose.SetValueInt(0)
	elseif (option == Verbose_B) && VerboseToggle == False
		VerboseToggle = True
		SetToggleOptionValue(Verbose_B, VerboseToggle)
		Condiexp_Verbose.SetValueInt(1)

	elseif (option == Followers_B) && FollowersToggle == True
		FollowersToggle = False
		SetToggleOptionValue(Followers_B, FollowersToggle)
		StopQuest(CondiExpFollowerQuest)
	elseif (option == Followers_B) && FollowersToggle == False
		FollowersToggle = True
		SetToggleOptionValue(Followers_B, FollowersToggle)
		ResetQuest(CondiExpFollowerQuest)


	elseif (option == Sounds_B) && SoundsToggle == True
		SoundsToggle = False
		SetToggleOptionValue(Sounds_B, SoundsToggle)
		Condiexp_Sounds.SetValueInt(0)
	elseif (option == Sounds_B) && SoundsToggle == False
		SoundsToggle = True
		SetToggleOptionValue(Sounds_B, SoundsToggle)
		DetectRace()
	
	elseif option == restore
		ShowMessage("$CEE_G2")
		Go.resetConditions()
		resetMFG(PlayerRef)
		currentExpression = ""
		if (CondiExpFollowerQuest.IsRunning())
			ResetQuest(CondiExpFollowerQuest)
		endIf

	elseif option == uninstall
		ShowMessage("$CEE_G3")
		Go.StopMod()
		StopQuest(CondiExpFollowerQuest)
		StopQuest(CondiExpQuest)

	elseif option == update
		ShowMessage("$CEE_G4")
		Utility.Wait(0.5)
		_restart()
		Notification("Restarted correctly!")
	
	elseif option == registerFollowers
		if (CondiExpFollowerQuest.IsRunning())
			ResetQuest(CondiExpFollowerQuest)
			ShowMessage("$CEE_G6")
		else
			ShowMessage("$CEE_G7")
		endIf
		
endif

endevent


event OnOptionHighlight(int option) 
if (option == EatingFastSlow_M) 
	SetInfoText("$CEE_G8") 
elseif (option == Combat_B)
	SetInfoText("$CEE_G9") 
elseif (option == Random_B)
	SetInfoText("$CEE_G10")
elseif (option == Cold_B)
	SetInfoText("$CEE_G11") 
elseif (option == Stamina_B)
	SetInfoText("$CEE_G12") 
elseif (option == Pain_B)
	SetInfoText("$CEE_G13") 
elseif (option == Drunk_B)
	SetInfoText("$CEE_G14") 
elseif (option == Skooma_B)
	SetInfoText("$CEE_G15") 
elseif (option == Clothes_B)
	SetInfoText("$CEE_G16") 
elseif (option == Sneaking_B)
	SetInfoText("$CEE_G17") 
elseif (option == Water_B)
	SetInfoText("$CEE_G18") 
elseif (option == restore)
	SetInfoText("$CEE_G19") 
elseif (option == uninstall)
	SetInfoText("$CEE_G20")
elseif (option == coldmethod_M)
	SetInfoText("$CEE_G21")
elseif (option == Update)
	SetInfoText("$CEE_G22")
elseif (option == Headache_B)
	SetInfoText("$CEE_G23")
elseif (option == Sounds_B)
	SetInfoText("$CEE_G24")
elseif (option == Trauma_B)
	SetInfoText("$CEE_G25")
elseif (option == Dirty_B)
	SetInfoText("$CEE_G26")
elseif (option == Aroused_B)
	SetInfoText("$CEE_G27")
elseif (option == Verbose_B)
	SetInfoText("$CEE_G28")
elseif (option == Followers_B)
	SetInfoText("$CEE_G29")
elseif (option == registerFollowers)
	SetInfoText("$CEE_G30")
elseif (option == _update_interval_followers_slider)
	SetInfoText("$CEE_G31")
elseif (option == _update_interval_slider)
	SetInfoText("$CEE_G32")
elseif (option == _expression_strength_slider)
	SetInfoText("$CEE_G33")
elseif (option == _modifier_strength_slider)
	SetInfoText("$CEE_G34")
elseif (option == _phoneme_strength_slider)
	SetInfoText("$CEE_G35")	
endif
endevent

event OnOptionKeyMapChange(int option, int keyCode, string conflictControl, string conflictName)
	if (option == oidHKPause|| option == oidHKRegisterFollowers)
		bool continue = true
		if (conflictControl != "")
			string msg
			if (conflictName != "")
				msg = "This key is already mapped to:\n\"" + conflictControl + "\"\n(" + conflictName + ")\n\nAre you sure you want to continue?"
			else
				msg = "This key is already mapped to:\n\"" + conflictControl + "\"\n\nAre you sure you want to continue?"
			endIf

			continue = ShowMessage(msg, true, "Yes", "No")
		endIf
		if (continue)
			if (option == oidHKPause)
				SetKeymapOptionValue(oidHKPause, keyCode)
				Go.UnregisterForKey(Condiexp_HKPause.GetValueInt())
				Condiexp_HKPause.SetValueInt(keyCode)
				Go.RegisterForKey(Condiexp_HKPause.GetValueInt())
			elseif (option == oidHKRegisterFollowers)
				SetKeymapOptionValue(oidHKRegisterFollowers, keyCode)
				Go.UnregisterForKey(Condiexp_HKRegisterFollowers.GetValueInt())
				Condiexp_HKRegisterFollowers.SetValueInt(keyCode)
				Go.RegisterForKey(Condiexp_HKRegisterFollowers.GetValueInt())
			endif
		endIf
	endIf
endEvent

Function DetectRace()
ActorBase PlayerBase = PlayerRef.GetActorBase()

If PlayerBase.GetSex() == 0

	if PlayerRef.GetRace() == KhajiitRace || PlayerRef.GetRace() == KhajiitRaceVampire
		Condiexp_Sounds.SetValueInt(1)

	elseif PlayerRef.GetRace() == OrcRace || PlayerRef.GetRace() == OrcRaceVampire
		Condiexp_Sounds.SetValueInt(2)
	else
		Condiexp_Sounds.SetValueInt(3)
	endif
else

	if PlayerRef.GetRace() == KhajiitRace || PlayerRef.GetRace() == KhajiitRaceVampire
		Condiexp_Sounds.SetValueInt(4)

	elseif PlayerRef.GetRace() == OrcRace || PlayerRef.GetRace() == OrcRaceVampire
		Condiexp_Sounds.SetValueInt(5)
	else
		Condiexp_Sounds.SetValueInt(6)
	endif
endif
endfunction

int Function _getFlag(Bool cond = true)
	If  !cond 	
   		return OPTION_FLAG_DISABLED  
	Else
   		return OPTION_FLAG_NONE
	EndIf  
EndFunction

int Function _restart()
	Go.StopMod()
	Go.StartMod()
	currentExpression = ""
	if (CondiExpFollowerQuest.IsRunning())
		ResetQuest(CondiExpFollowerQuest)
	endIf
EndFunction
