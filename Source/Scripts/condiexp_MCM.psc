Scriptname condiexp_MCM extends SKI_ConfigBase
import CondiExp_util

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

Race Property OrcRace Auto
Race Property OrcRaceVampire Auto
Race Property KhajiitRace Auto
Race Property KhajiitRaceVampire Auto

CondiExp_StartMod Property Go Auto
Spell Property CondiExp_Effects Auto
Actor Property PlayerRef Auto
Quest Property CondiExpQuest Auto

int function GetVersion()
    return CondiExp_util.GetVersion()
endFunction

event OnVersionUpdate(int a_version)
    if (a_version > 1)
      DetectRace()
	  endIf
endEvent

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

int EatingFastSlow_M
string EatingFastSlow
int EatingFastSlowIndex = 1
string[] EatingFastSlowList

int ColdMethod_M
string ColdMethod
int ColdMethodIndex = 3
string[] ColdMethodList

Event OnConfigInit()
	Pages = new string[1]
	Pages[0] = "Settings"
EndEvent

event OnInit()
	parent.OnInit()
	EatingFastSlowList = new string[3]
	EatingFastSlowList[0] = "Quick Eating"
	EatingFastSlowList[1] = "Slow Eating"
	EatingFastSlowList[2] = "Disabled"

	ColdMethodList = new string[4]
	ColdMethodList[0] = "Vanilla - Snowing"
	ColdMethodList[1] = "Frostfall"
	ColdMethodList[2] = "Frostbite"
	ColdMethodList[3] = "Automatic"
endEvent

Event OnPageReset(string page)
	If (page == "")
				LoadCustomContent("MCM/MCM_CondiExp.dds", 0.0, 0.0)
		Else
		UnloadCustomContent()
	Endif

If (page == "Settings")

SetCursorFillMode(LEFT_TO_RIGHT)
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
If Condiexp_GlobalRandom.GetValue() == 1
Cold_B = AddToggleOption("Cold Expression", ColdToggle)
else
Cold_B = AddToggleOption("Cold Expression", ColdToggle, OPTION_FLAG_DISABLED)
endif
Stamina_B = AddToggleOption("Out of Stamina Expression", StaminaToggle)
coldmethod_M = AddMenuOption("Cold Detection", ColdMethodList[ColdMethodIndex]) 
Pain_B = AddToggleOption("In Pain Expression", PainToggle)
Drunk_B = AddToggleOption("Drunk Expression", DrunkToggle)
Skooma_B = AddToggleOption("'This Is Good Skooma' Expression", SkoomaToggle)
Clothes_B = AddToggleOption("Embarrassed - No Clothes Expression", ClothesToggle)
Sneaking_B = AddToggleOption("Sneaking Expression", SneakingToggle)
Water_B = AddToggleOption("Water/Torch Expression", WaterToggle)
Headache_B = AddToggleOption("Headache/Diseased", HeadacheToggle)
Sounds_B = AddToggleOption("Breathing Sounds", SoundsToggle)
Trauma_B = AddToggleOption("Trauma Expression", TraumaToggle)
Dirty_B = AddToggleOption("Dirty Expression", DirtyToggle)
AddEmptyOption()
AddEmptyOption()
AddHeaderOption("Maintenance")
Update = AddTextOption("Update/Restart", "")
restore = AddTextOption("Reset Current Expression", "")
Uninstall = AddTextOption("Prepare to Uninstall", "")

EndIf
endEvent

event OnOptionMenuOpen(int option)
	if (option == EatingFastSlow_M)
		SetMenuDialogOptions(EatingFastSlowList)
		SetMenuDialogStartIndex(EatingFastSlowIndex)
		SetMenuDialogDefaultIndex(1)

	elseif (option == ColdMethod_M)
		SetMenuDialogOptions(ColdMethodList)
		SetMenuDialogStartIndex(ColdMethodIndex)
		SetMenuDialogDefaultIndex(3)
	endIf
endEvent


event OnOptionMenuAccept(int option, int index)
	if (option == EatingFastSlow_M)
		EatingFastSlowIndex = index
		SetMenuOptionValue(EatingFastSlow_M, EatingFastSlowList[EatingFastSlowIndex])
	if index == 0
Condiexp_GlobalEating.SetValue(2)
	elseif index == 1
Condiexp_GlobalEating.SetValue(1)
	elseif index == 2
Condiexp_GlobalEating.SetValue(0)
	endif
	endif

If (option == ColdMethod_M)
		ColdMethodindex = index
		SetMenuOptionValue(coldmethod_M, coldmethodList[coldmethodindex])
	if index == 0
Condiexp_ColdMethod.SetValue(3)
	elseif index == 1
Condiexp_ColdMethod.SetValue(1)
	elseif index == 2
Condiexp_ColdMethod.SetValue(2)
	elseif index == 3
;nothing happens, automatic
	endif
	endif
EndEvent


event OnOptionSelect(int option)

if (option == Combat_B) && CombatToggle == True
		CombatToggle = False
		SetToggleOptionValue(Combat_B, CombatToggle)
		Condiexp_GlobalCombat.SetValue(0)
	elseif (option == Combat_B) && CombatToggle == False
		CombatToggle = True
		SetToggleOptionValue(Combat_B, CombatToggle)
		Condiexp_GlobalCombat.SetValue(1)

	elseif (option == Random_B) && RandomToggle == True
		RandomToggle = False
		SetToggleOptionValue(Random_B, RandomToggle)
		Condiexp_GlobalRandom.SetValue(0)
		ForcePageReset()
	elseif (option == Random_B) && RandomToggle == False
		RandomToggle = True
		SetToggleOptionValue(Random_B, RandomToggle)
		Condiexp_GlobalRandom.SetValue(1)
		ForcePageReset()

	elseif (option == Cold_B) && ColdToggle == True
		ColdToggle = False
		SetToggleOptionValue(Cold_B, ColdToggle)
		Condiexp_GlobalCold.SetValue(0)
	elseif (option == Cold_B) && ColdToggle == False
		ColdToggle = True
		SetToggleOptionValue(Cold_B, ColdToggle)
		Condiexp_GlobalCold.SetValue(1)

	elseif (option == Stamina_B) && StaminaToggle == True
		StaminaToggle = False
		SetToggleOptionValue(Stamina_B, StaminaToggle)
		Condiexp_GlobalStamina.SetValue(0)
	elseif (option == Stamina_B) && StaminaToggle == False
		StaminaToggle = True
		SetToggleOptionValue(Stamina_B, StaminaToggle)
		Condiexp_GlobalStamina.SetValue(1)

	elseif (option == Pain_B) && PainToggle == True
		PainToggle = False
		SetToggleOptionValue(Pain_B, PainToggle)
		Condiexp_GlobalPain.SetValue(0)
	elseif (option == Pain_B) && PainToggle == False
		PainToggle = True
		SetToggleOptionValue(Pain_B, PainToggle)
		Condiexp_GlobalPain.SetValue(1)

	elseif (option == Drunk_B) && DrunkToggle == True
		DrunkToggle = False
		SetToggleOptionValue(Drunk_B, DrunkToggle)
		Condiexp_GlobalDrunk.SetValue(0)
	elseif (option == Drunk_B) && DrunkToggle == False
		DrunkToggle = True
		SetToggleOptionValue(Drunk_B, DrunkToggle)
		Condiexp_GlobalDrunk.SetValue(1)

	elseif (option == Skooma_B) && SkoomaToggle == True
		SkoomaToggle = False
		SetToggleOptionValue(Skooma_B, SkoomaToggle)
		Condiexp_GlobalSkooma.SetValue(0)
	elseif (option == Skooma_B) && SkoomaToggle == False
		SkoomaToggle = True
		SetToggleOptionValue(Skooma_B, SkoomaToggle)
		Condiexp_GlobalSkooma.SetValue(1)

	elseif (option == Clothes_B) && ClothesToggle == True
		ClothesToggle = False
		SetToggleOptionValue(Clothes_B, ClothesToggle )
		Condiexp_GlobalNoClothes.SetValue(0)
	elseif (option == Clothes_B) && ClothesToggle == False
		ClothesToggle = True
		SetToggleOptionValue(Clothes_B, ClothesToggle )
		Condiexp_GlobalNoClothes.SetValue(1)

	elseif (option == Sneaking_B) && SneakingToggle == True
		SneakingToggle = False
		SetToggleOptionValue(Sneaking_B, SneakingToggle)
		Condiexp_GlobalSneaking.SetValue(0)
	elseif (option == Sneaking_B) && SneakingToggle == False
		SneakingToggle = True
		SetToggleOptionValue(Sneaking_B, SneakingToggle)
		Condiexp_GlobalSneaking.SetValue(1)

	elseif (option == Water_B) && WaterToggle == True
		WaterToggle = False
		SetToggleOptionValue(Water_B, WaterToggle)
		Condiexp_GlobalWater.SetValue(0)
	elseif (option == Water_B) && WaterToggle == False
		WaterToggle = True
		SetToggleOptionValue(Water_B, WaterToggle)
		Condiexp_GlobalWater.SetValue(1)

	elseif (option == Headache_B) && HeadacheToggle == True
		HeadacheToggle = False
		SetToggleOptionValue(Headache_B, HeadacheToggle)
		Condiexp_GlobalMana.SetValue(0)
	elseif (option == Headache_B) && HeadacheToggle == False
		HeadacheToggle = True
		SetToggleOptionValue(Headache_B, HeadacheToggle)
		Condiexp_GlobalMana.SetValue(1)

	elseif (option == Trauma_B) && TraumaToggle == True
		TraumaToggle = False
		SetToggleOptionValue(Trauma_B, TraumaToggle)
		Condiexp_GlobalTrauma.SetValue(0)
	elseif (option == Trauma_B) && TraumaToggle == False
		TraumaToggle = True
		SetToggleOptionValue(Trauma_B, TraumaToggle)
		Condiexp_GlobalTrauma.SetValue(1)

	elseif (option == Dirty_B) && DirtyToggle == True
		DirtyToggle = False
		SetToggleOptionValue(Dirty_B, DirtyToggle)
		Condiexp_GlobalDirty.SetValue(0)
	elseif (option == Dirty_B) && DirtyToggle == False
		DirtyToggle = True
		SetToggleOptionValue(Dirty_B, DirtyToggle)
		Condiexp_GlobalDirty.SetValue(1)

	elseif (option == Sounds_B) && SoundsToggle == True
		SoundsToggle = False
		SetToggleOptionValue(Sounds_B, SoundsToggle)
		Condiexp_Sounds.SetValue(0)
	elseif (option == Sounds_B) && SoundsToggle == False
		SoundsToggle = True
		SetToggleOptionValue(Sounds_B, SoundsToggle)	
		DetectRace()
	
	elseif option == restore
	ShowMessage("Default expression restored - If in the middle of a face animation, expression will be restored once animation is finished.")
	PlayerRef.ClearExpressionOverride()
	Condiexp_CurrentlyBusy.SetValue(0)
	MfgConsoleFunc.ResetPhonemeModifier(PlayerRef)

	elseif option == uninstall
	ShowMessage("Mod is now prepared to be uninstalled. Please, exit menu, save and uninstall. Keep in mind: It's never 100% safe to uninstall mods mid-game, always make back-ups of your saves before installing mods!")
	Go.StopMod()
	CondiExpQuest.Stop()

	elseif option == update
	ShowMessage("Please, exit menu. All functionalities will be restarted.")
	Utility.Wait(0.5)
	PlayerRef.ClearExpressionOverride()
	MfgConsoleFunc.ResetPhonemeModifier(PlayerRef)
	PlayerRef.RemoveSpell(CondiExp_Effects)
	Go.StartMod()
	Debug.Notification("Conditional Expressions has been restarted correctly!")
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
SetInfoText("Your character will react to being cold depending on your 'cold-manager' mod.\nFor this to work, you must enable the Random Idles as well.") 
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
SetInfoText("When out of stamina, you can hear your character (quietly) breathing\n heavily until they recover half of their stamina.")
elseif (option == Trauma_B)
SetInfoText("Your character will react to abuse (painful subtle expressions).\n There's also a pain sound once in a while. Integrated with Apropos2 and Zap slave faction based mods")
elseif (option == Dirty_B)
SetInfoText("Your character will react to dirt (disgusted subtle expressions).\n Integrated with Dirt&Blood,Keep it clean,Bathing in Skyrim")
endif
endevent


Function DetectRace()
ActorBase PlayerBase = PlayerRef.GetActorBase()

If PlayerBase.GetSex() == 0

	if PlayerRef.GetRace() == KhajiitRace || PlayerRef.GetRace() == KhajiitRaceVampire
		Condiexp_Sounds.SetValue(1)

	elseif PlayerRef.GetRace() == OrcRace || PlayerRef.GetRace() == OrcRaceVampire
		Condiexp_Sounds.SetValue(2)
	else
		Condiexp_Sounds.SetValue(3)
	endif
else

	if PlayerRef.GetRace() == KhajiitRace || PlayerRef.GetRace() == KhajiitRaceVampire
		Condiexp_Sounds.SetValue(4)

	elseif PlayerRef.GetRace() == OrcRace || PlayerRef.GetRace() == OrcRaceVampire
		Condiexp_Sounds.SetValue(5)
	else
		Condiexp_Sounds.SetValue(6)
	endif
endif
endfunction