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

int function GetVersion()
    return CondiExp_util.GetVersion()
endFunction

Event OnConfigInit()
	Notification("MCM menu initialized")	
EndEvent

event OnVersionUpdate(int a_version)
    if (a_version > 1)
      DetectRace()
	endIf
endEvent

Event OnConfigOpen()
	Pages = New String[3]
	Pages[0] = "Expressions"
	Pages[1] = "Settings"
	Pages[2] = "Maintenance"

	EatingFastSlowList = new string[3]
	EatingFastSlowList[0] = "Quick Eating"
	EatingFastSlowList[1] = "Slow Eating"
	EatingFastSlowList[2] = "Disabled"

	ColdMethodList = new string[5]
	ColdMethodList[0] = "Vanilla - Snowing"
	ColdMethodList[1] = "Frostfall"
	ColdMethodList[2] = "Frostbite"
	ColdMethodList[3] = "Sunhelm Survival"
	ColdMethodList[4] = "Automatic"
EndEvent

Event OnPageReset(string page)
	If (page == "")
		LoadCustomContent("MCM/MCM_CondiExp.dds", 0.0, 0.0)
	Else
		UnloadCustomContent()
	Endif
	
	if (page == "Expressions")
		Expressions()
	elseIf (page == "Settings")
		Settings()
	elseIf (page == "Maintenance")
		Maintenance()
	endIf
EndEvent


Function Expressions()
	SetCursorFillMode(LEFT_TO_RIGHT)
	AddHeaderOption("Conditional Expressions Extended. Version: " + GetVersionString())
	AddHeaderOption("List of Expressions")
	AddEmptyOption()
	AddEmptyOption()
	AddEmptyOption()
	EatingFastSlow_M = AddMenuOption("Eating Expression", EatingFastSlowList[EatingFastSlowIndex])
	If PlayerRef.IsInCombat()
		Combat_B = AddToggleOption("Less Dramatic Combat Expression", CombatToggle, OPTION_FLAG_DISABLED)
		else
		Combat_B = AddToggleOption("Less Dramatic Combat Expression", CombatToggle)
	endif
	Random_B = AddToggleOption("Random Idle Expressions", RandomToggle)
	Cold_B = AddToggleOption("Cold Expression", ColdToggle)
	Stamina_B = AddToggleOption("Out of Stamina Expression", StaminaToggle)
	coldmethod_M = AddMenuOption("Cold Detection", ColdMethodList[ColdMethodIndex]) 
	Pain_B = AddToggleOption("In Pain Expression", PainToggle)
	Drunk_B = AddToggleOption("Drunk Expression", DrunkToggle)
	Skooma_B = AddToggleOption("'This Is Good Skooma' Expression", SkoomaToggle)
	Clothes_B = AddToggleOption("Embarrassed - No Clothes Expression", ClothesToggle)
	Sneaking_B = AddToggleOption("Sneaking Expression", SneakingToggle)
	Water_B = AddToggleOption("Water/Torch Expression", WaterToggle)
	Headache_B = AddToggleOption("Headache/Diseased", HeadacheToggle)
	Trauma_B = AddToggleOption("Trauma Expression", TraumaToggle)
	Dirty_B = AddToggleOption("Dirty Expression", DirtyToggle)
	Aroused_B = AddToggleOption("Aroused Expression", ArousedToggle)
EndFunction

Function Settings()
	SetCursorFillMode(TOP_TO_BOTTOM)
	AddHeaderOption("Settings")
	AddEmptyOption()
	Sounds_B = AddToggleOption("Breathing Sounds", SoundsToggle)
	_update_interval_slider = AddSliderOption("Update interval", Condiexp_UpdateInterval.GetValueInt(), "{0}", OPTION_FLAG_NONE)
	_expression_strength_slider = AddSliderOption("Expression Strength", Condiexp_ExpressionStr.GetValue(), "{2}", OPTION_FLAG_NONE)
	_modifier_strength_slider = AddSliderOption("Modifier Strength", Condiexp_ModifierStr.GetValue(), "{2}", OPTION_FLAG_NONE)
	_phoneme_strength_slider = AddSliderOption("Phoneme Strength", Condiexp_PhonemeStr.GetValue(), "{2}", OPTION_FLAG_NONE)
	AddHeaderOption("Followers")
	Followers_B =  AddToggleOption("Followers Support", CondiExpFollowerQuest.IsRunning())
	_update_interval_followers_slider = AddSliderOption("Update interval Followers", Condiexp_FollowersUpdateInterval.GetValueInt(), "{0}", _getFlag(FollowersToggle))
	registerFollowers = AddTextOption("Register Followers", "")
EndFunction

Function Maintenance()
	SetCursorFillMode(TOP_TO_BOTTOM)
	AddHeaderOption("Maintenance")
	AddEmptyOption()
	Update = AddTextOption("Update/Restart", "")
	restore = AddTextOption("Reset Current Expression: "+ currentExpression, "")
	Uninstall = AddTextOption("Prepare to Uninstall", "")
	Verbose_B =  AddToggleOption("Verbose Notifications", VerboseToggle)
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
		Condiexp_ColdMethod.SetValueInt(4)
	elseif index == 1
		Condiexp_ColdMethod.SetValueInt(1)
	elseif index == 2
		Condiexp_ColdMethod.SetValueInt(2)
	elseif index == 3
		Condiexp_ColdMethod.SetValueInt(3)	
	else
		Condiexp_ColdMethod.SetValueInt(4)
;nothing happens, automatic
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
		ShowMessage("Default expression restored - If in the middle of a face animation, expression will be restored once animation is finished.")
		Go.resetConditions()
		resetMFG(PlayerRef)
		if (CondiExpFollowerQuest.IsRunning())
			ResetQuest(CondiExpFollowerQuest)
		endIf

	elseif option == uninstall
		ShowMessage("Mod is now prepared to be uninstalled. Please, exit menu, save and uninstall. Keep in mind: It's never 100% safe to uninstall mods mid-game, always make back-ups of your saves before installing mods!")
		Go.StopMod()
		StopQuest(CondiExpFollowerQuest)
		StopQuest(CondiExpQuest)


	elseif option == update
		ShowMessage("Please, exit menu. All functionalities will be restarted.")
		Utility.Wait(0.5)
		Go.StopMod()
		Go.StartMod()
		if (CondiExpFollowerQuest.IsRunning())
			ResetQuest(CondiExpFollowerQuest)
		endIf
		Notification("Restarted correctly!")
	
	elseif option == registerFollowers
		if (CondiExpFollowerQuest.IsRunning())
			ResetQuest(CondiExpFollowerQuest)
			ShowMessage("Please, exit menu. Followers were registered")
		else
			ShowMessage("Followers support is disabled")
		endIf
		
endif

endevent


event OnOptionHighlight(int option) 
if (option == EatingFastSlow_M) 
	SetInfoText("Quick and slow refer to how fast your character starts chewing.\nDepending on your eating animation mod, one or the other will fit better.") 
elseif (option == Combat_B)
	SetInfoText("This enables a more focused combat expression. Disabling this will revert back\n to the vanilla combat expression. Cannot be disabled during combat") 
elseif (option == Random_B)
	SetInfoText("When your character is idle, they will often have random subtle expressions.\nThis must be enabled for cold animations to work.")
elseif (option == Cold_B)
	SetInfoText("Your character will react to being cold depending on your 'cold-manager' mod.\n") 
elseif (option == Stamina_B)
	SetInfoText("When out of Stamina, your character will be out of breath.") 
elseif (option == Pain_B)
	SetInfoText("During low health, your character will be in pain/scared.") 
elseif (option == Drunk_B)
	SetInfoText("After drinking alcohol, your character will be 'happy' for 1 to 2 hours.") 
elseif (option == Skooma_B)
	SetInfoText("After taking skooma, your character will have \na random happier-than-usual expression for 1 to 2 hours.") 
elseif (option == Clothes_B)
	SetInfoText("When not at home, your character will have \nan embarrassed expression when wearing no clothes.") 
elseif (option == Sneaking_B)
	SetInfoText("Your character will squint their eyes \nand look at their surroundings when sneaking.") 
elseif (option == Water_B)
	SetInfoText("Your character will squint their eyes \nwhen swimming or diving underwater.") 
elseif (option == restore)
	SetInfoText("If for some reason the face of your character \nis glitched, click here to reset it back to normal.") 
elseif (option == uninstall)
	SetInfoText("Clicking here will stop all functionalities of the mod.\nDo this ONLY if you are planning on uninstalling the mod right after.")
elseif (option == coldmethod_M)
	SetInfoText("The Automatic option scans your load order for frostfall or frostbite. Change this manually only\nif you have switched from one mod to another or want to use the vanilla detection method.")
elseif (option == Update)
	SetInfoText("Clicking here will stop and restart the mod's functionalities.\nThis is useful if you have updated to a new version.")
elseif (option == Headache_B)
	SetInfoText("Your character will have a 'headache' look when almost out of mana.\nSame look will be applied when you have a disease.")
elseif (option == Sounds_B)
	SetInfoText("When out of stamina, you can hear your character (quietly) breathing\n heavily until they recover half of their stamina. Enables trauma sounds as well")
elseif (option == Trauma_B)
	SetInfoText("Your character will react to trauma or disease (painful subtle expressions).\n There's also a pain sound once in a while")
elseif (option == Dirty_B)
	SetInfoText("Your character will react to dirt (disgusted subtle expressions).\n Integrated with Dirt&Blood,Keep it clean,Bathing in Skyrim")
elseif (option == Aroused_B)
	SetInfoText("Your character will react to arousal (pleasure subtle expressions).\n Integrated with OSL Aroused")
elseif (option == Verbose_B)
	SetInfoText("Verbose debug notifications. Shows what emotion is playing")
elseif (option == Followers_B)
	SetInfoText("Toggle  followers support")
elseif (option == registerFollowers)
	SetInfoText("Clicking here will register new followers. Followers are also registered when game is loaded.")
elseif (option == _update_interval_followers_slider)
	SetInfoText("Update period for followers expressions")
elseif (option == _update_interval_slider)
	SetInfoText("Update period for long term conditions checking. Set to 0 if you want to disable them")
elseif (option == _expression_strength_slider)
	SetInfoText("Expression strength - 1 means default unmodified")
elseif (option == _modifier_strength_slider)
	SetInfoText("Modifier strength - 1 means default unmodified")
elseif (option == _phoneme_strength_slider)
	SetInfoText("Phoneme strength - 1 means default unmodified")	
endif
endevent


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