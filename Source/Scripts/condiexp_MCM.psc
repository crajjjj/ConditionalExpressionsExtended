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
String status_string=""


Race Property OrcRace Auto
Race Property OrcRaceVampire Auto
Race Property KhajiitRace Auto
Race Property KhajiitRaceVampire Auto

CondiExp_StartMod Property Go Auto
Spell Property CondiExp_Effects Auto
Actor Property PlayerRef Auto
Quest Property CondiExpQuest Auto
Quest Property CondiExpFollowerQuest Auto
CondiExp_BaseExpression Property arousalExpr Auto
CondiExp_BaseExpression Property traumaExpr Auto
CondiExp_BaseExpression Property dirtyExpr Auto
CondiExp_BaseExpression Property painExpr Auto
CondiExp_BaseExpression Property randomExpr Auto

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
int status
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
int arousalExprRegistered
int traumaExprRegistered
int dirtyExprRegistered
int painExprRegistered
int randomExprRegistered

Int  arousalChillyThreshold_slider 
Int  arousalChilly_slider 
Int  arousalColdThreshold_slider 
Int  arousalCold_slider  
Int  arousalFreezingThreshold_slider 
Int  arousalFreezing_slider 

Int  arousalPainThreshold_slider
Int  arousalPain_slider

Int  arousalTraumaMinorThreshold_slider
Int  arousalTraumaMinor_slider

Int  arousalTraumaMajorThreshold_slider
Int  arousalTraumaMajor_slider

Int  arousalSwimThreshold_slider
Int  arousalSwim_slider

Int  arousalRainThreshold_slider
Int  arousalRain_slider

Int  arousalHeadacheThreshold_slider
Int  arousalHeadache_slider

bool FollowersToggle = false 

int EatingFastSlow_M
string EatingFastSlow
int EatingFastSlowIndex = 1
string[] EatingFastSlowList

int Phase_M
string[] PhaseList
int PhaseListIndex = 1
int ExpressionType_M
string[] ExpressionTypeList
int ExpressionTypeListIndex = 1
int TestExpr

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
	Pages = New String[4]
	Pages[0] = "$CEE_A3"
	Pages[1] = "$CEE_A4"
	Pages[2] = "$CEE_A5"
	Pages[3] = "$CEE_A51"

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

	PhaseList = new string[7]
	PhaseList[0] = "1"
	PhaseList[1] = "2"
	PhaseList[2] = "3"
	PhaseList[3] = "4"
	PhaseList[4] = "5"
	PhaseList[5] = "6"
	PhaseList[6] = "7"

	ExpressionTypeList = new string[5]
	ExpressionTypeList[0] = "Pain"
	ExpressionTypeList[1] = "Arousal"
	ExpressionTypeList[2] = "Trauma"
	ExpressionTypeList[3] = "Dirty"
	ExpressionTypeList[4] = "Random"
	FollowersToggle = CondiExpFollowerQuest.IsRunning()
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
	elseIf (page == "$CEE_A51")
		ArousedModifiers()
	endIf
EndEvent


Function Expressions()
	SetCursorFillMode(LEFT_TO_RIGHT)
	AddHeaderOption("Conditional Expressions Extended.Version: " + GetVersionString())
	AddHeaderOption("$CEE_B7")
	AddEmptyOption()
	AddEmptyOption()
	EatingFastSlow_M = AddMenuOption("$CEE_B8", EatingFastSlowList[EatingFastSlowIndex])
	If PlayerRef.IsInCombat()
		Combat_B = AddToggleOption("$CEE_B9", _isTG(Condiexp_GlobalCombat), OPTION_FLAG_DISABLED)
		else
		Combat_B = AddToggleOption("$CEE_B9", _isTG(Condiexp_GlobalCombat))
	endif
	Random_B = AddToggleOption("$CEE_C1", _isTG(Condiexp_GlobalRandom))
	Cold_B = AddToggleOption("$CEE_C2", _isTG(Condiexp_GlobalCold))
	Stamina_B = AddToggleOption("$CEE_C3", _isTG(Condiexp_GlobalStamina))
	coldmethod_M = AddMenuOption("$CEE_C4", ColdMethodList[ColdMethodIndex]) 
	Pain_B = AddToggleOption("$CEE_C5", _isTG(Condiexp_GlobalPain))
	Drunk_B = AddToggleOption("$CEE_C6", _isTG(Condiexp_GlobalDrunk))
	Skooma_B = AddToggleOption("$CEE_C7", _isTG(Condiexp_GlobalSkooma))
	Clothes_B = AddToggleOption("$CEE_C8", _isTG(Condiexp_GlobalNoClothes))
	Sneaking_B = AddToggleOption("$CEE_C9", _isTG(Condiexp_GlobalSneaking))
	Water_B = AddToggleOption("$CEE_D1", _isTG(Condiexp_GlobalWater))
	Headache_B = AddToggleOption("$CEE_D2", _isTG(Condiexp_GlobalMana))
	Trauma_B = AddToggleOption("$CEE_D3", _isTG(Condiexp_GlobalTrauma))
	Dirty_B = AddToggleOption("$CEE_D4", _isTG(Condiexp_GlobalDirty))
	Aroused_B = AddToggleOption("$CEE_D5", _isTG(Condiexp_GlobalAroused))
EndFunction


Function Settings()
	SetCursorFillMode(TOP_TO_BOTTOM)
	AddHeaderOption("$CEE_D6")
	AddEmptyOption()
	Sounds_B = AddToggleOption("$CEE_D7", _isTG(Condiexp_Sounds))
	_update_interval_slider = AddSliderOption("$CEE_D8", Condiexp_UpdateInterval.GetValueInt(), "{0}", OPTION_FLAG_NONE)
	_expression_strength_slider = AddSliderOption("$CEE_D9", Condiexp_ExpressionStr.GetValue(), "{2}", OPTION_FLAG_NONE)
	_modifier_strength_slider = AddSliderOption("$CEE_E1", Condiexp_ModifierStr.GetValue(), "{2}", OPTION_FLAG_NONE)
	_phoneme_strength_slider = AddSliderOption("$CEE_E2", Condiexp_PhonemeStr.GetValue(), "{2}", OPTION_FLAG_NONE)
	AddHeaderOption("$CEE_E3")
	Followers_B =  AddToggleOption("$CEE_E4", CondiExpFollowerQuest.IsRunning())
	_update_interval_followers_slider = AddSliderOption("$CEE_E5", Condiexp_FollowersUpdateInterval.GetValueInt(), "{0}", _getFlag(FollowersToggle))
	registerFollowers = AddTextOption("$CEE_E6", "")
	oidHKRegisterFollowers = AddKeyMapOption("Register followers key", Condiexp_HKRegisterFollowers.GetValueInt())
EndFunction

Function Maintenance()
	SetCursorFillMode(LEFT_TO_RIGHT)
	AddHeaderOption("$CEE_E7")
	AddEmptyOption()
	status_string="active"
	if !go.isModEnabled()
		status_string = "suspended according to conditions check" 
		If (go.isSuspendedByDhlpEvent())
			status_string = "suspended according to dhlp event" 
		ElseIf (go.isSuspendedByKey())
			status_string = "suspended by key" 
		EndIf
	endif
	Status = AddTextOption("Status: " + status_string, "")
	AddEmptyOption()
	Update = AddTextOption("$CEE_E8", "")
	restore = AddTextOption("Reset Current Expression: " + currentExpression, "")

	Uninstall = AddTextOption("$CEE_F1", "")
	Verbose_B =  AddToggleOption("$CEE_F2", _isTG(Condiexp_Verbose))

	oidHKPause = AddKeyMapOption("Pause-Unpause mod  key", Condiexp_HKPause.GetValueInt())
	AddEmptyOption()
	
	AddHeaderOption("Loaded expressions")
	AddHeaderOption("Test expressions")

	arousalExprRegistered = AddTextOption("Arousal Expressions:", arousalExpr.PhasesMale + arousalExpr.PhasesFemale)
	ExpressionType_M = AddMenuOption("ExpressionType", ExpressionTypeList[ExpressionTypeListIndex])

 	traumaExprRegistered = AddTextOption("Trauma Expressions:", traumaExpr.PhasesMale + traumaExpr.PhasesFemale)
	Phase_M = AddMenuOption("Phase", PhaseList[PhaseListIndex])

 	dirtyExprRegistered = AddTextOption("Dirty Expressions:", dirtyExpr.PhasesMale + dirtyExpr.PhasesFemale)
	AddTextOptionST("TEST_EXPRESSIONS_STATE","Test Expression","GO", OPTION_FLAG_NONE)

 	painExprRegistered = AddTextOption("Pain Expressions:", painExpr.PhasesMale + painExpr.PhasesFemale)
	AddEmptyOption()
	
	randomExprRegistered = AddTextOption("Random Expressions:", randomExpr.PhasesMale + randomExpr.PhasesFemale)
EndFunction

Function ArousedModifiers()
	SetCursorFillMode(LEFT_TO_RIGHT)
	AddHeaderOption("$CEE_A51")
	AddEmptyOption()
	ArousedModifiers_B = AddToggleOption("Aroused Modifiers", _isTG(Condiexp_GlobalArousalModifiers))
	ArousedModifiersNotifications_B = AddToggleOption("Aroused Modifiers Notifications", _isTG(Condiexp_GlobalArousalModifiersNotifications))
	AddEmptyOption()
	AddEmptyOption()
  arousalChillyThreshold_slider = AddSliderOption("Chilled threshold", Go.arousalChillyThreshold, "{0}", _getFlagGV(Condiexp_GlobalArousalModifiers))
  arousalChilly_slider = AddSliderOption("Chilled cap", Go.arousalChilly, "{0}", _getFlagGV(Condiexp_GlobalArousalModifiers))
  arousalColdThreshold_slider = AddSliderOption("Cold threshold", Go.arousalColdThreshold, "{0}", _getFlagGV(Condiexp_GlobalArousalModifiers))
  arousalCold_slider = AddSliderOption("Cold cap", Go.arousalCold, "{0}", _getFlagGV(Condiexp_GlobalArousalModifiers))
  arousalFreezingThreshold_slider = AddSliderOption("Freezing threshold", Go.arousalFreezingThreshold, "{0}", _getFlagGV(Condiexp_GlobalArousalModifiers))
  arousalFreezing_slider = AddSliderOption("Freezing cap", Go.arousalFreezing, "{0}", _getFlagGV(Condiexp_GlobalArousalModifiers))

  arousalPainThreshold_slider = AddSliderOption("Pain threshold", Go.arousalPainThreshold, "{0}", _getFlagGV(Condiexp_GlobalArousalModifiers))
  arousalPain_slider = AddSliderOption("Pain cap", Go.arousalPain, "{0}", _getFlagGV(Condiexp_GlobalArousalModifiers))

  arousalTraumaMinorThreshold_slider = AddSliderOption("TraumaMinor threshold", Go.arousalTraumaMinorThreshold, "{0}", _getFlagGV(Condiexp_GlobalArousalModifiers))
  arousalTraumaMinor_slider = AddSliderOption("TraumaMinor cap", Go.arousalTraumaMinor, "{0}", _getFlagGV(Condiexp_GlobalArousalModifiers))

  arousalTraumaMajorThreshold_slider = AddSliderOption("TraumaMajor threshold", Go.arousalTraumaMajorThreshold, "{0}", _getFlagGV(Condiexp_GlobalArousalModifiers))
  arousalTraumaMajor_slider = AddSliderOption("TraumaMajor cap", Go.arousalTraumaMajor, "{0}", _getFlagGV(Condiexp_GlobalArousalModifiers))

  arousalSwimThreshold_slider = AddSliderOption("Swim threshold", Go.arousalSwimThreshold, "{0}", _getFlagGV(Condiexp_GlobalArousalModifiers))
  arousalSwim_slider = AddSliderOption("Swim cap", Go.arousalSwim, "{0}", _getFlagGV(Condiexp_GlobalArousalModifiers))

  arousalRainThreshold_slider = AddSliderOption("Rain threshold", Go.arousalRainThreshold, "{0}", _getFlagGV(Condiexp_GlobalArousalModifiers))
  arousalRain_slider = AddSliderOption("Rain cap", Go.arousalRain, "{0}", _getFlagGV(Condiexp_GlobalArousalModifiers))

  arousalHeadacheThreshold_slider = AddSliderOption("Headache threshold", Go.arousalHeadacheThreshold, "{0}", _getFlagGV(Condiexp_GlobalArousalModifiers))
  arousalHeadache_slider = AddSliderOption("Headache cap", Go.arousalHeadache, "{0}", _getFlagGV(Condiexp_GlobalArousalModifiers))

EndFunction

State TEST_EXPRESSIONS_STATE
    Event OnSelectST()
        SetOptionFlagsST(OPTION_FLAG_DISABLED)
		int phaseNum = PhaseListIndex + 1
		CondiExp_util.resetMFG(PlayerRef)
		if ExpressionTypeListIndex == 0
			Notification("Pain expression:" + phaseNum )
			painExpr.apply(PlayerRef, phaseNum, 100)
		elseIf (ExpressionTypeListIndex == 1)
			Notification("Arousal expression:" + phaseNum)
			arousalExpr.apply(PlayerRef, phaseNum, 100)
		elseIf (ExpressionTypeListIndex == 2)
			Notification("Trauma expression:" + phaseNum)
			TraumaExpr.apply(PlayerRef, phaseNum, 100)
		elseIf (ExpressionTypeListIndex == 3)
			Notification("Dirty expression:" + phaseNum)
			DirtyExpr.apply(PlayerRef, phaseNum, 100)
		elseIf (ExpressionTypeListIndex == 4)
			Notification("Random expression:" + phaseNum)
			randomExpr.apply(PlayerRef, phaseNum, 100)
		endif

		SetTextOptionValueST("Applied")
        SetOptionFlagsST(OPTION_FLAG_NONE)
    EndEvent
	
	Event OnHighlightST()
		SetInfoText("Click to apply. Pause the mod to stop the update cycle")
    EndEvent
EndState

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
	elseif (mcm_option == arousalChillyThreshold_slider)
		SetSliderDialogStartValue(Go.arousalChillyThreshold)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
		SetSliderDialogDefaultValue(40)
	elseif (mcm_option == arousalColdThreshold_slider)
		SetSliderDialogStartValue(Go.arousalColdThreshold)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
		SetSliderDialogDefaultValue(20)
	elseif (mcm_option == arousalFreezingThreshold_slider)
		SetSliderDialogStartValue(Go.arousalFreezingThreshold)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
		SetSliderDialogDefaultValue(0)
	elseif (mcm_option == arousalChilly_slider)
		SetSliderDialogStartValue(Go.arousalChilly)
		SetSliderDialogRange(0, 300)
		SetSliderDialogInterval(1)
		SetSliderDialogDefaultValue(40)
	elseif (mcm_option == arousalCold_slider)
		SetSliderDialogStartValue(Go.arousalCold)
		SetSliderDialogRange(0, 300)
		SetSliderDialogInterval(1)
		SetSliderDialogDefaultValue(70)
	elseif (mcm_option == arousalFreezing_slider)
		SetSliderDialogStartValue(Go.arousalFreezing)
		SetSliderDialogRange(0, 300)
		SetSliderDialogInterval(1)
		SetSliderDialogDefaultValue(150)
	elseif (mcm_option == arousalPainThreshold_slider)
		SetSliderDialogStartValue(Go.arousalPainThreshold)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
		SetSliderDialogDefaultValue(0)
	elseif (mcm_option == arousalTraumaMinorThreshold_slider)
		SetSliderDialogStartValue(Go.arousalTraumaMinorThreshold)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
		SetSliderDialogDefaultValue(30)
	elseif (mcm_option == arousalTraumaMajorThreshold_slider)
		SetSliderDialogStartValue(Go.arousalTraumaMajorThreshold)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
		SetSliderDialogDefaultValue(0)
	elseif (mcm_option == arousalSwimThreshold_slider)
		SetSliderDialogStartValue(Go.arousalSwimThreshold)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
		SetSliderDialogDefaultValue(50)
	elseif (mcm_option == arousalRainThreshold_slider)
		SetSliderDialogStartValue(Go.arousalRainThreshold)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
		SetSliderDialogDefaultValue(50)
	elseif (mcm_option == arousalHeadacheThreshold_slider)
		SetSliderDialogStartValue(Go.arousalHeadacheThreshold)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
		SetSliderDialogDefaultValue(40)
	elseif (mcm_option == arousalPain_slider)
		SetSliderDialogStartValue(Go.arousalPain)
		SetSliderDialogRange(0, 300)
		SetSliderDialogInterval(1)
		SetSliderDialogDefaultValue(50)
	elseif (mcm_option == arousalTraumaMinor_slider)
		SetSliderDialogStartValue(Go.arousalTraumaMinor)
		SetSliderDialogRange(0, 300)
		SetSliderDialogInterval(1)
		SetSliderDialogDefaultValue(50)
	elseif (mcm_option == arousalTraumaMajor_slider)
		SetSliderDialogStartValue(Go.arousalTraumaMajor)
		SetSliderDialogRange(0, 300)
		SetSliderDialogInterval(1)
		SetSliderDialogDefaultValue(1.0)
	elseif (mcm_option == arousalSwim_slider)
		SetSliderDialogStartValue(Go.arousalSwim)
		SetSliderDialogRange(0, 300)
		SetSliderDialogInterval(1)
		SetSliderDialogDefaultValue(50)
	elseif (mcm_option == arousalRain_slider)
		SetSliderDialogStartValue(Go.arousalRain)
		SetSliderDialogRange(0, 300)
		SetSliderDialogInterval(1)
		SetSliderDialogDefaultValue(50)
	elseif (mcm_option == arousalHeadache_slider)
		SetSliderDialogStartValue(Go.arousalHeadache)
		SetSliderDialogRange(0, 300)
		SetSliderDialogInterval(1)
		SetSliderDialogDefaultValue(50)
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
	elseif (mcm_option == arousalChillyThreshold_slider)
		Go.arousalChillyThreshold = Value as Int
		SetSliderOptionValue(mcm_option, Value, "{0}")
	elseif (mcm_option == arousalColdThreshold_slider)
		Go.arousalColdThreshold = Value as Int
		SetSliderOptionValue(mcm_option, Value, "{0}")
	elseif (mcm_option == arousalFreezingThreshold_slider)
		Go.arousalFreezingThreshold = Value as Int
		SetSliderOptionValue(mcm_option, Value, "{0}")
	elseif (mcm_option == arousalChilly_slider)
		Go.arousalChilly = Value as Int
		SetSliderOptionValue(mcm_option, Value, "{0}")
	elseif (mcm_option == arousalCold_slider)
		Go.arousalCold = Value as Int
		SetSliderOptionValue(mcm_option, Value, "{0}")
	elseif (mcm_option == arousalFreezing_slider)
		Go.arousalFreezing = Value as Int
		SetSliderOptionValue(mcm_option, Value, "{0}")
	elseif (mcm_option == arousalPainThreshold_slider)
		Go.arousalPainThreshold = Value as Int
		SetSliderOptionValue(mcm_option, Value, "{0}")
	elseif (mcm_option == arousalTraumaMinorThreshold_slider)
		Go.arousalTraumaMinorThreshold = Value as Int
		SetSliderOptionValue(mcm_option, Value, "{0}")
	elseif (mcm_option == arousalTraumaMajorThreshold_slider)
		Go.arousalTraumaMajorThreshold = Value as Int
		SetSliderOptionValue(mcm_option, Value, "{0}")
	elseif (mcm_option == arousalSwimThreshold_slider)
		Go.arousalSwimThreshold = Value as Int
		SetSliderOptionValue(mcm_option, Value, "{0}")
	elseif (mcm_option == arousalRainThreshold_slider)
		Go.arousalRainThreshold = Value as Int
		SetSliderOptionValue(mcm_option, Value, "{0}")
	elseif (mcm_option == arousalHeadacheThreshold_slider)
		Go.arousalHeadacheThreshold = Value as Int
		SetSliderOptionValue(mcm_option, Value, "{0}")
	elseif (mcm_option == arousalPain_slider)
		Go.arousalPain = Value as Int
		SetSliderOptionValue(mcm_option, Value, "{0}")
	elseif (mcm_option == arousalTraumaMinor_slider)
		Go.arousalTraumaMinor = Value as Int
		SetSliderOptionValue(mcm_option, Value, "{0}")
	elseif (mcm_option == arousalTraumaMajor_slider)
		Go.arousalTraumaMajor = Value as Int
		SetSliderOptionValue(mcm_option, Value, "{0}")
	elseif (mcm_option == arousalSwim_slider)
		Go.arousalSwim = Value as Int
		SetSliderOptionValue(mcm_option, Value, "{0}")
	elseif (mcm_option == arousalRain_slider)
		Go.arousalRain = Value as Int
		SetSliderOptionValue(mcm_option, Value, "{0}")
	elseif (mcm_option == arousalHeadache_slider)
		Go.arousalHeadache = Value as Int
		SetSliderOptionValue(mcm_option, Value, "{0}")
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

	elseif (option == ExpressionType_M)
		SetMenuDialogOptions(ExpressionTypeList)
		SetMenuDialogStartIndex(ExpressionTypeListIndex)
		SetMenuDialogDefaultIndex(0)
	elseif (option == Phase_M)
		SetMenuDialogOptions(PhaseList)
		SetMenuDialogStartIndex(PhaseListIndex)
		SetMenuDialogDefaultIndex(0)
	endIf
endEvent


event OnOptionMenuAccept(int option, int index)
	if (option == ExpressionType_M)
		ExpressionTypeListIndex = index
		SetMenuOptionValue(ExpressionType_M, ExpressionTypeList[ExpressionTypeListIndex])
	endif
	if (option == Phase_M)
		PhaseListIndex = index
		SetMenuOptionValue(Phase_M, PhaseList[PhaseListIndex])
	endif
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
	endif
	_restart()
	Notification("Restarted to apply Cold Detection option!")
endif

EndEvent


event OnOptionSelect(int option)

if (option == Combat_B) && _isTG(Condiexp_GlobalCombat) == True
		SetToggleOptionValue(Combat_B, False)
		Condiexp_GlobalCombat.SetValueInt(0)
	elseif (option == Combat_B) && _isTG(Condiexp_GlobalCombat) == False
		SetToggleOptionValue(Combat_B, True)
		Condiexp_GlobalCombat.SetValueInt(1)

	elseif (option == Random_B) && _isTG(Condiexp_GlobalRandom) == True
		SetToggleOptionValue(Random_B, False)
		Condiexp_GlobalRandom.SetValueInt(0)
	elseif (option == Random_B) && _isTG(Condiexp_GlobalRandom) == False
		SetToggleOptionValue(Random_B, True)
		Condiexp_GlobalRandom.SetValueInt(1)
	elseif (option == Cold_B) && _isTG(Condiexp_GlobalCold) == True
		SetToggleOptionValue(Cold_B, False)
		Condiexp_GlobalCold.SetValueInt(0)
	elseif (option == Cold_B) && _isTG(Condiexp_GlobalCold) == False
		SetToggleOptionValue(Cold_B, True)
		Condiexp_GlobalCold.SetValueInt(1)

	elseif (option == Stamina_B) && _isTG(Condiexp_GlobalStamina) == True
		SetToggleOptionValue(Stamina_B, False)
		Condiexp_GlobalStamina.SetValueInt(0)
	elseif (option == Stamina_B) && _isTG(Condiexp_GlobalStamina) == False
		SetToggleOptionValue(Stamina_B, True)
		Condiexp_GlobalStamina.SetValueInt(1)

	elseif (option == Pain_B) && _isTG(Condiexp_GlobalPain) == True
		SetToggleOptionValue(Pain_B, False)
		Condiexp_GlobalPain.SetValueInt(0)
	elseif (option == Pain_B) && _isTG(Condiexp_GlobalPain) == False
		SetToggleOptionValue(Pain_B, True)
		Condiexp_GlobalPain.SetValueInt(1)

	elseif (option == Drunk_B) && _isTG(Condiexp_GlobalDrunk) == True
		SetToggleOptionValue(Drunk_B, False)
		Condiexp_GlobalDrunk.SetValueInt(0)
	elseif (option == Drunk_B) && _isTG(Condiexp_GlobalDrunk) == False
		SetToggleOptionValue(Drunk_B, True)
		Condiexp_GlobalDrunk.SetValueInt(1)

	elseif (option == Skooma_B) && _isTG(Condiexp_GlobalSkooma) == True
		SetToggleOptionValue(Skooma_B, False)
		Condiexp_GlobalSkooma.SetValueInt(0)
	elseif (option == Skooma_B) && _isTG(Condiexp_GlobalSkooma) == False
		SetToggleOptionValue(Skooma_B, True)
		Condiexp_GlobalSkooma.SetValueInt(1)

	elseif (option == Clothes_B) &&  _isTG(Condiexp_GlobalNoClothes) == True
		SetToggleOptionValue(Clothes_B, False)
		Condiexp_GlobalNoClothes.SetValueInt(0)
	elseif (option == Clothes_B) &&  _isTG(Condiexp_GlobalNoClothes) == False
		SetToggleOptionValue(Clothes_B, True )
		Condiexp_GlobalNoClothes.SetValueInt(1)

	elseif (option == Sneaking_B) &&  _isTG(Condiexp_GlobalSneaking) == True
		SetToggleOptionValue(Sneaking_B, False)
		Condiexp_GlobalSneaking.SetValueInt(0)
	elseif (option == Sneaking_B) &&  _isTG(Condiexp_GlobalSneaking) == False
		SetToggleOptionValue(Sneaking_B, True)
		Condiexp_GlobalSneaking.SetValueInt(1)

	elseif (option == Water_B) &&  _isTG(Condiexp_GlobalWater) == True
		SetToggleOptionValue(Water_B, False)
		Condiexp_GlobalWater.SetValueInt(0)
	elseif (option == Water_B) &&  _isTG(Condiexp_GlobalWater) == False
		SetToggleOptionValue(Water_B, True)
		Condiexp_GlobalWater.SetValueInt(1)

	elseif (option == Headache_B) &&  _isTG(Condiexp_GlobalMana) == True
		SetToggleOptionValue(Headache_B, False)
		Condiexp_GlobalMana.SetValueInt(0)
	elseif (option == Headache_B) &&  _isTG(Condiexp_GlobalMana) == False
		SetToggleOptionValue(Headache_B, True)
		Condiexp_GlobalMana.SetValueInt(1)

	elseif (option == Trauma_B) &&  _isTG(Condiexp_GlobalTrauma) == True
		SetToggleOptionValue(Trauma_B, False)
		Condiexp_GlobalTrauma.SetValueInt(0)
	elseif (option == Trauma_B) &&  _isTG(Condiexp_GlobalTrauma) == False
		SetToggleOptionValue(Trauma_B, True)
		Condiexp_GlobalTrauma.SetValueInt(1)

	elseif (option == Dirty_B) &&  _isTG(Condiexp_GlobalDirty) == True
		SetToggleOptionValue(Dirty_B, False)
		Condiexp_GlobalDirty.SetValueInt(0)
	elseif (option == Dirty_B) &&  _isTG(Condiexp_GlobalDirty) == False
		SetToggleOptionValue(Dirty_B, True)
		Condiexp_GlobalDirty.SetValueInt(1)

	elseif (option == Aroused_B) &&  _isTG(Condiexp_GlobalAroused) == True
		SetToggleOptionValue(Aroused_B, False)
		Condiexp_GlobalAroused.SetValueInt(0)
	elseif (option == Aroused_B) &&  _isTG(Condiexp_GlobalAroused) == False
		SetToggleOptionValue(Aroused_B, True)
		Condiexp_GlobalAroused.SetValueInt(1)

	elseif (option == ArousedModifiers_B) && _isTG(Condiexp_GlobalArousalModifiers) == True
		SetToggleOptionValue(ArousedModifiers_B, False) 
		Condiexp_GlobalArousalModifiers.SetValueInt(0)
	elseif (option == ArousedModifiers_B) && _isTG(Condiexp_GlobalArousalModifiers) == False
		SetToggleOptionValue(ArousedModifiers_B, True)
		Condiexp_GlobalArousalModifiers.SetValueInt(1)

	elseif (option == ArousedModifiersNotifications_B) && _isTG(Condiexp_GlobalArousalModifiersNotifications) == True
		SetToggleOptionValue(ArousedModifiersNotifications_B, false)
		Condiexp_GlobalArousalModifiersNotifications.SetValueInt(0)
	elseif (option == ArousedModifiersNotifications_B) && _isTG(Condiexp_GlobalArousalModifiersNotifications) == False
		SetToggleOptionValue(ArousedModifiersNotifications_B, true)
		Condiexp_GlobalArousalModifiersNotifications.SetValueInt(1)
	elseif (option == Verbose_B) &&  _isTG(Condiexp_Verbose) == True
		SetToggleOptionValue(Verbose_B, False)
		Condiexp_Verbose.SetValueInt(0)
	elseif (option == Verbose_B) &&  _isTG(Condiexp_Verbose) == False
		SetToggleOptionValue(Verbose_B, True)
		Condiexp_Verbose.SetValueInt(1)

	elseif (option == Followers_B) && FollowersToggle == True
		FollowersToggle = False
		SetToggleOptionValue(Followers_B, FollowersToggle)
		StopQuest(CondiExpFollowerQuest)
	elseif (option == Followers_B) && FollowersToggle == False
		FollowersToggle = True
		SetToggleOptionValue(Followers_B, FollowersToggle)
		ResetQuest(CondiExpFollowerQuest)

	elseif (option == Sounds_B) && _isTG(Condiexp_Sounds) == True
		SetToggleOptionValue(Sounds_B, False)
		Condiexp_Sounds.SetValueInt(0)
	elseif (option == Sounds_B) && _isTG(Condiexp_Sounds) == False
		SetToggleOptionValue(Sounds_B, True)
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
elseif (option == arousalChillyThreshold_slider || option == arousalFreezingThreshold_slider || option == arousalColdThreshold_slider || option == arousalRainThreshold_slider )
	SetInfoText("Arousal thresholds for weather. Caps or decrease won't be applied if arousal is lower than threshold")
elseif (option == arousalTraumaMinorThreshold_slider || option == arousalTraumaMajorThreshold_slider || option == arousalPainThreshold_slider )
	SetInfoText("Arousal thresholds for pain or trauma. Caps or decrease won't be applied if arousal is lower than threshold")
elseif (option == arousalHeadacheThreshold_slider || option == arousalSwimThreshold_slider)
	SetInfoText("Arousal thresholds for misc conditions. Caps or decrease won't be applied if arousal is lower than threshold")
elseif (option == arousalChilly_slider || option == arousalCold_slider || option == arousalFreezing_slider || option == arousalRain_slider)
	SetInfoText("Arousal caps or decrease for weather. Arousal will be substracted or capped depending on SLA version")
elseif (option == arousalPain_slider || option == arousalTraumaMinor_slider || option == arousalTraumaMajor_slider )
	SetInfoText("Arousal caps or decrease for pain or trauma. Arousal will be substracted or capped depending on SLA version")
elseif (option == arousalSwim_slider || option == arousalHeadache_slider)
	SetInfoText("Arousal caps or decrease for misc conditions. Arousal will be substracted or capped depending on SLA version")
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

int Function _getFlagGV(GlobalVariable gvar)
	If  !_isTG(gvar) 	
   		return OPTION_FLAG_DISABLED  
	Else
   		return OPTION_FLAG_NONE
	EndIf  
EndFunction

bool Function _isTG(GlobalVariable gvar)
	If  gvar.GetValueInt() == 0
   		return false  
	Else
   		return true
	EndIf  
EndFunction

int Function _restart()
	Go.StopMod()
	Go.StartMod()
	currentExpression = ""
	status_string="active"
	if (CondiExpFollowerQuest.IsRunning())
		ResetQuest(CondiExpFollowerQuest)
	endIf
EndFunction
