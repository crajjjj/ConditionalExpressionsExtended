Scriptname CondiExp_StartMod extends ReferenceAlias  
import CondiExp_log
import CondiExp_util
import CondiExp_Interface_Appr2
import CondiExp_Interface_Sla
import CondiExp_Interface_SL

Spell Property CondiExp_Fatigue1 Auto ;condi_effects spell
Actor Property PlayerRef Auto
Formlist property CondiExp_Drugs Auto
Formlist property CondiExp_Drinks Auto
Keyword Property VendorItemFood Auto
Keyword Property VendorItemIngredient Auto
GlobalVariable Property CondiExp_CurrentlyBusy Auto
GlobalVariable Property Condiexp_CurrentlyBusyImmediate Auto
GlobalVariable Property CondiExp_PlayerIsHigh Auto
GlobalVariable Property CondiExp_PlayerIsDrunk Auto
GlobalVariable Property CondiExp_PlayerJustAte Auto

GlobalVariable Property Condiexp_GlobalTrauma Auto
GlobalVariable Property Condiexp_CurrentlyTrauma Auto
GlobalVariable Property Condiexp_MinTrauma Auto
GlobalVariable Property Condiexp_TraumaZBFFactionEnabled Auto

GlobalVariable Property Condiexp_GlobalDirty Auto
GlobalVariable Property Condiexp_CurrentlyDirty Auto
GlobalVariable Property Condiexp_MinDirty Auto

GlobalVariable Property Condiexp_GlobalCold Auto
GlobalVariable Property Condiexp_ColdMethod Auto
GlobalVariable Property Condiexp_CurrentlyCold Auto
GlobalVariable Property Condiexp_ColdGlobal Auto ;to delete

GlobalVariable Property Condiexp_GlobalAroused Auto
GlobalVariable Property Condiexp_CurrentlyAroused Auto
GlobalVariable Property Condiexp_MinAroused Auto
GlobalVariable Property Condiexp_GlobalArousalModifiers Auto
GlobalVariable Property Condiexp_GlobalArousalModifiersNotifications Auto

GlobalVariable Property Condiexp_ModSuspended Auto

GlobalVariable Property Condiexp_Sounds Auto

GlobalVariable Property Condiexp_UpdateInterval Auto
GlobalVariable Property Condiexp_FollowersUpdateInterval Auto
GlobalVariable Property Condiexp_Verbose Auto

GlobalVariable Property Condiexp_GlobalEating Auto

GlobalVariable Property Condiexp_SuspendedByDhlpEvent Auto
GlobalVariable Property Condiexp_SuspendedByKey Auto
GlobalVariable Property Condiexp_PO3ExtenderInstalled Auto

GlobalVariable Property Condiexp_HKPause Auto
GlobalVariable Property Condiexp_HKRegisterFollowers Auto
Quest Property CondiExpFollowerQuest Auto

Race Property KhajiitRace Auto
Race Property KhajiitRaceVampire Auto
Race Property OrcRace Auto
Race Property OrcRaceVampire Auto
Keyword property Vampire Auto
Faction Property SexLabAnimatingFaction Auto ;empty - to delete

String Property LoadedBathMod Auto Hidden
Bool Property isSuspendedByDhlpEvent Auto Hidden  ;to delete

Spell Property DiseaseAtaxia Auto
Spell Property DiseaseBoneBreakFever Auto
Spell Property DiseaseBrainRot Auto
Spell Property DiseaseRattles Auto
Spell Property DiseaseRockjoint Auto
Spell Property DiseaseSanguinareVampiris Auto
Spell Property DiseaseWitbane Auto
Spell Property TrapDiseaseAtaxia Auto
Spell Property TrapDiseaseBoneBreakFever Auto
Spell Property TrapDiseaseBrainRot Auto
Spell Property TrapDiseaseRattles Auto
Spell Property TrapDiseaseRockjoint Auto
Spell Property TrapDiseaseWitbane Auto

CondiExp_BaseExpression Property arousalExpr Auto
CondiExp_BaseExpression Property traumaExpr Auto
CondiExp_BaseExpression Property dirtyExpr Auto
CondiExp_BaseExpression Property painExpr Auto
CondiExp_BaseExpression Property randomExpr Auto

CondiExp_PCTracking Property pctracking Auto

bool  Property coldOverride  = false Auto
bool  Property dirtOverride  = false Auto
bool  Property traumaOverride  = false Auto
bool  Property arousalOverride  = false Auto

;Bathing mod
MagicEffect DirtinessStage2Effect 
MagicEffect DirtinessStage3Effect
MagicEffect DirtinessStage4Effect
MagicEffect DirtinessStage5Effect
MagicEffect BloodinessStage2Effect
MagicEffect BloodinessStage3Effect
MagicEffect BloodinessStage4Effect
MagicEffect BloodinessStage5Effect
Spell Cold1
Spell Cold2
Spell Cold3
GlobalVariable Temp
;Apropos2
Quest ActorsQuest
;Sexlab
Quest sexlab
;Zaz slave faction
Faction zbfFactionSlave
;Devious Devices
MagicEffect vZadGagEffect
Keyword zad_DeviousGag
;Toys
Keyword ToysEffectMouthOpen 
;SLA
Quest sla
Faction slaArousalFaction
Faction slaExposureFaction

Int property arousalChillyThreshold = 40 auto hidden
Int property arousalChilly = 80 auto hidden
Int property arousalColdThreshold = 20 auto hidden
Int property arousalCold = 120 auto hidden
Int property arousalFreezingThreshold = 0 auto hidden
Int property arousalFreezing = 200 auto hidden

Int property arousalPainThreshold = 0 auto hidden
Int property arousalPain = 200 auto hidden

Int property arousalTraumaMinorThreshold = 30 auto hidden
Int property arousalTraumaMinor = 100 auto hidden

Int property arousalTraumaMajorThreshold = 0 auto hidden
Int property arousalTraumaMajor = 200 auto hidden

Int property arousalSwimThreshold = 40 auto hidden
Int property arousalSwim = 60 auto hidden

Int property arousalRainThreshold = 40 auto hidden
Int property arousalRain = 100 auto hidden

Int property arousalHeadacheThreshold = 40 auto hidden
Int property arousalHeadache = 60 auto hidden

int _checkPlugins = 0

Event OnInit()
	_checkPlugins = 1
	RegisterForSingleUpdate(10)
EndEvent

function init()
	if !ActorsQuest && isAprReady()
		ActorsQuest = Quest.GetQuest("Apropos2Actors")
		;ActorsQuest = Game.GetFormFromFile(0x02902C, "Apropos2.esp") as Quest	
	endif
	if ActorsQuest
		log("CondiExp_StartMod: Found Apropos: " + ActorsQuest.GetName() )
	endif
	if !zbfFactionSlave && isZaZReady()
		zbfFactionSlave = Game.GetFormFromFile(0x0096AE, "ZaZAnimationPack.esm") as Faction	
	endif
	if zbfFactionSlave
		log("CondiExp_StartMod: Found ZaZAnimationPack: " + zbfFactionSlave.GetName() )
	endif
	if !zad_DeviousGag && isDDassetsReady()
		zad_DeviousGag = Game.GetFormFromFile(0x007EB8, "Devious Devices - Assets.esm") as Keyword 
	endif
	if zad_DeviousGag
		log("CondiExp_StartMod: Found Devious Devices - Assets: " + zad_DeviousGag.GetName() )
	endif
	if !sla || !slaArousalFaction || !slaExposureFaction
		if isSLAReady()
			sla = Game.GetFormFromFile(0x4290F, "SexLabAroused.esm") As Quest
			slaArousalFaction = Game.GetFormFromFile(0x3FC36, "SexLabAroused.esm") As Faction
			slaExposureFaction = Game.GetFormFromFile(0x25837, "SexLabAroused.esm") As Faction
		endif
	endif
	if sla && slaArousalFaction
		log("CondiExp_StartMod: Found SexLabAroused: " + sla.GetName())
	endif
	if !sexlab && isSLReady()
		sexlab = Game.GetFormFromFile(0x000D62, "SexLab.esm") As Quest
	endif
	if sexlab
		log("CondiExp_StartMod: Found SexLab: " + sexlab.GetName())
	endif
	if !ToysEffectMouthOpen && isToysReady()
		ToysEffectMouthOpen = Game.GetFormFromFile(0x0008C2, "Toys.esm") as Keyword
	endif
	if ToysEffectMouthOpen
		log("CondiExp_StartMod: Found Toys: " + ToysEffectMouthOpen.GetName())
	endif
	if skse.GetPluginVersion("powerofthree's Papyrus Extender") > -1    ;Papyrus Extender is installed
		log("CondiExp_StartMod: Found Papyrus Extender")
		Condiexp_PO3ExtenderInstalled.SetValue(1)
	endif

	;check cold mods
	If Condiexp_ColdMethod.GetValueInt() == 1
		Temp = Game.GetFormFromFile(0x00068119, "Frostfall.esp") as GlobalVariable
	elseIf Condiexp_ColdMethod.GetValueInt() == 2
		Cold1 = Game.GetFormFromFile(0x00029028, "Frostbite.esp") as Spell
	 	Cold2 = Game.GetFormFromFile(0x00029029, "Frostbite.esp") as Spell
		Cold3 = Game.GetFormFromFile(0x0002902C, "Frostbite.esp") as Spell
	elseIf Condiexp_ColdMethod.GetValueInt() == 3
		Cold1 = Game.GetFormFromFile(0x006E81E0, "SunHelmSurvival.esp") as Spell
	 	Cold2 = Game.GetFormFromFile(0x006E81E2, "SunHelmSurvival.esp") as Spell
	 	Cold3 = Game.GetFormFromFile(0x006E81E4, "SunHelmSurvival.esp") as Spell
	endif
	
	; checking what bath mod is loaded
	LoadedBathMod = "None Found"
	if (isDependencyReady("Dirt and Blood - Dynamic Visuals.esp") && GetDABDirtinessStage2Effect() != none) ; if Dirt and Blood is loaded
		LoadedBathMod = "Dirt And Blood"
		DirtinessStage2Effect = GetDABDirtinessStage2Effect()
		DirtinessStage3Effect = GetDABDirtinessStage3Effect()
		DirtinessStage4Effect = GetDABDirtinessStage4Effect()
		DirtinessStage5Effect = GetDABDirtinessStage5Effect()
		BloodinessStage2Effect = GetDABBloodinessStage2Effect()
		BloodinessStage3Effect = GetDABBloodinessStage3Effect()
		BloodinessStage4Effect = GetDABBloodinessStage4Effect()
		BloodinessStage5Effect = GetDABBloodinessStage5Effect()
	elseif (isDependencyReady("Bathing in Skyrim - Main.esp") && GetBISDirtinessStage2Effect() != none) ; if Bathing In Skyrim is loaded
		LoadedBathMod = "Bathing In Skyrim"
		DirtinessStage2Effect = GetBISDirtinessStage2Effect()
		DirtinessStage3Effect = GetBISDirtinessStage3Effect()
		DirtinessStage4Effect = GetBISDirtinessStage4Effect()
	elseif (isDependencyReady("Bathing in Skyrim.esp") && GetBISRDirtinessStage2Effect() != none) ; if Bathing in Skyrim - Renewed is loaded
		LoadedBathMod = "Bathing in Skyrim Renewed"
		DirtinessStage2Effect = GetBISRDirtinessStage2Effect()
		DirtinessStage3Effect = GetBISRDirtinessStage3Effect()
		DirtinessStage4Effect = GetBISRDirtinessStage4Effect()
	elseif (isDependencyReady("Keep It Clean.esp") && GetKICDirtinessStage2Effect() != none) ; if Keep it clean is loaded
		LoadedBathMod = "Keep It Clean"
		DirtinessStage2Effect = GetKICDirtinessStage2Effect()
		DirtinessStage3Effect = GetKICDirtinessStage3Effect()
		DirtinessStage4Effect = GetKICDirtinessStage4Effect()
	endif
	log("CondiExp_StartMod: Bathing mod: " + LoadedBathMod)
	
	; load expressions
	arousalExpr.Initialize()
	traumaExpr.Initialize()
	dirtyExpr.Initialize()
	painExpr.Initialize()
	randomExpr.Initialize()
endfunction

Event OnUpdate()
	if (!PlayerRef)
		log("CondiExp_StartMod: PlayerRef empty")
		RegisterForSingleUpdate(5)
		return
	endif
	OnUpdateExecute(PlayerRef)
	if PlayerRef.HasSpell(CondiExp_Fatigue1) && Condiexp_UpdateInterval.GetValueInt() > 0
		RegisterForSingleUpdate(Condiexp_UpdateInterval.GetValueInt())
	endif
EndEvent

function OnUpdateExecute(Actor act)
	;postponed module init
	If _checkPlugins > 0
		_checkPlugins += 1
		If _checkPlugins >= 2
			log("CondiExp_StartMod: setup")
			StartMod()
			_checkPlugins = 0
		EndIf
	EndIf

	Actor playerSpeechTargetAct = MfgConsoleFuncExt.GetPlayerSpeechTarget()
	;check if there's a conflicting mod based on custom conditions
	if checkIfModShouldBeSuspended(act, playerSpeechTargetAct)
		if isModEnabled()
			log("CondiExp_StartMod: suspended according to conditions check")
			Condiexp_ModSuspended.SetValueInt(1)
			bool inDialogue = isInDialogue(act, act == PlayerRef, playerSpeechTargetAct)
			mfgCleanupWithContext(act, inDialogue)
			Condiexp_CurrentlyBusy.SetValueInt(0)
			Condiexp_CurrentlyBusyImmediate.SetValueInt(0)
		endif
	else
		if !isModEnabled()
			log("CondiExp_StartMod: resumed according to conditions check")
			Condiexp_ModSuspended.SetValueInt(0)
		endif
 	endif

	Condiexp_CurrentlyCold.SetValueInt(getColdStatus(act))
	Condiexp_CurrentlyTrauma.SetValueInt(getTraumaStatus(act))
	Condiexp_CurrentlyDirty.SetValueInt(getDirtyStatus(act))
	Condiexp_CurrentlyAroused.SetValueInt(getArousalStatus(act))

	if !act.IsinInterior() && Weather.GetCurrentWeather().GetClassification() == 2 
		OnCondiExpSLAEvent(arousalRainThreshold, arousalRain, "is not feeling very aroused because it's raining", "CondiExpRaining", act)
	endif
	
	if act.GetActorValuePercentage("Health") < 0.5
		OnCondiExpSLAEvent(arousalPainThreshold, arousalPain, "not feeling aroused because of very strong pain", "CondiExpPain", act)
	endif

	if act.GetActorValuePercentage("Magicka") < 0.3
		OnCondiExpSLAEvent(arousalHeadacheThreshold, arousalHeadache, "not feeling very aroused because of headache", "CondiExpHeadache", act)
	endif
	
	if act.IsSwimming()
		OnCondiExpSLAEvent(arousalSwimThreshold, arousalSwim, "not feeling very aroused because of swimming", "CondiExpSwimming", act)
    endif

	if Condiexp_Verbose.GetValueInt() == 1
		String msg = "Status: CondiExp_CurrentlyBusy:" + CondiExp_CurrentlyBusy.GetValueInt() + ":::" + "Condiexp_CurrentlyBusyImmediate:" + Condiexp_CurrentlyBusyImmediate.GetValueInt()
		trace(act, msg, 1)
	endif
endfunction

Bool function checkIfModShouldBeSuspended(Actor act, Actor playerSpeechTargetAct)
	if isSuspendedByDhlpEvent()
		log("CondiExp_StartMod: dhlp event. Will suspend for actor:" + act.GetLeveledActorBase().GetName() )
		return true
	endif

	if isSuspendedByKey()
		log("CondiExp_StartMod: key down event. Will suspend for actor:" + act.GetLeveledActorBase().GetName() )
		return true
	endif

	if (pctracking.checkIfModShouldBeSuspendedByWearables(act))
		log("CondiExp_StartMod: wearable was detected. Will suspend for actor:" + act.GetLeveledActorBase().GetName() )
		return true
	endif

	if (sexlab && IsActorActive(sexlab, act))
		log("CondiExp_StartMod: actor is in sl faction. Will suspend for actor:" + act.GetLeveledActorBase().GetName())
		return true
	endif

	if (isInDialogue(act, act == PlayerRef, playerSpeechTargetAct))
		log("CondiExp_StartMod: actor is in dialogue. Will suspend for actor:" + act.GetLeveledActorBase().GetName())
		return true
	endif
	return false
endfunction

Bool function checkIfModShouldBeSuspendedForNPCs(Actor act, Actor playerSpeechTargetAct)
	if isSuspendedByDhlpEvent()
		log("CondiExp_StartMod: dhlp event. Will suspend for actor:" + act.GetLeveledActorBase().GetName() )
		return true
	endif

	if isSuspendedByKey()
		log("CondiExp_StartMod: key down event. Will suspend for actor:" + act.GetLeveledActorBase().GetName() )
		return true
	endif

	if (sexlab && IsActorActive(sexlab, act))
		log("CondiExp_StartMod: actor is in sl faction. Will suspend for actor:" + act.GetLeveledActorBase().GetName())
		return true
	endif

	 if (isInDialogue(act, act == PlayerRef, playerSpeechTargetAct))
	 	log("CondiExp_StartMod: actor is in dialogue. Will suspend for actor:" + act.GetLeveledActorBase().GetName())
	 	return true
	 endif
	return false
endfunction

function mfgCleanupWithContext(Actor act, bool inDialogue)
    ; ▸ Bail if actor is invalid
    if (!act || act.IsDead())
        return
    endif

    ; ------------------------------------------------------------------
    ; Decide what to wipe
    bool cleanPhonemes     = true
    bool cleanModifiers    = true
    bool cleanExpressions  = true

    bool gagged = pctracking.checkIfModShouldBeSuspendedByWearables(act)
    if (gagged)
        ; Keep the mouth closed – don’t touch phonemes *or* expression override
        cleanPhonemes    = false
        cleanExpressions = false
    endif

    ; Dialogue: we *do* want a blank slate unless gag suppresses it
    if (inDialogue && !gagged)
        cleanExpressions = true
    endif
    ; ------------------------------------------------------------------

    ; ▸ Nothing to do?  Exit early
    if (!cleanPhonemes && !cleanModifiers && !cleanExpressions)
        return
    endif

    ; ▸ All-in-one wipe is cheapest
    if (cleanPhonemes && cleanModifiers && cleanExpressions)
        resetMFGSmooth(act)
        return
    endif

    ; ▸ Selective cleanup
    if (cleanPhonemes)
        resetPhonemesSmooth(act)
    endif
    if (cleanModifiers)
        resetModifiersSmooth(act)
    endif
    if (cleanExpressions)
        resetExpressionsSmooth(act)
        act.ClearExpressionOverride() ; only if we really wiped expressions
    endif
endfunction

int function getColdStatus(Actor act )
	If (coldOverride)
		return 1
	ElseIf (traumaOverride || dirtOverride || arousalOverride)
			return 0
	EndIf
	if Condiexp_GlobalCold.GetValueInt() == 0
		return 0
	endif
	If Condiexp_ColdMethod.GetValueInt() == 1
		If Temp.GetValueInt() > 2
			trace(act,"CondiExp_StartMod: getColdStatus frostfall:  is cold", Condiexp_Verbose.GetValueInt())
			OnCondiExpSLAEvent(arousalColdThreshold, arousalCold, "is not feeling aroused because of cold", "CondiExpCold", act)
			return 1
			else
			return 0
		endif
	elseIf Condiexp_ColdMethod.GetValueInt() == 2 || Condiexp_ColdMethod.GetValueInt() == 3
		If act.HasSpell(Cold1)
				trace(act,"CondiExp_StartMod: getColdStatus frosbite/sunhelm: is chilly", Condiexp_Verbose.GetValueInt())
				OnCondiExpSLAEvent(arousalChillyThreshold, arousalChilly, "is not feeling very aroused because it's chilly", "CondiExpChilly", act)
				return 1
			ElseIf act.HasSpell(Cold2)
				trace(act,"CondiExp_StartMod: getColdStatus frosbite/sunhelm: is cold", Condiexp_Verbose.GetValueInt())
				OnCondiExpSLAEvent(arousalColdThreshold, arousalCold, "is not feeling aroused because it's cold", "CondiExpCold", act)
				return 1
			elseif act.HasSpell(Cold3)
				trace(act,"CondiExp_StartMod: getColdStatus frosbite/sunhelm: is freezing", Condiexp_Verbose.GetValueInt())
				OnCondiExpSLAEvent(arousalFreezingThreshold, arousalFreezing, "is not feeling aroused because it's freezing", "CondiExpFreezing", act)
				return 1
			else
				return 0
		endif
	elseIf Condiexp_ColdMethod.GetValueInt() == 4
		If !act.HasKeyword(Vampire) && !act.IsinInterior() && Weather.GetCurrentWeather().GetClassification() == 3
			trace(act,"CondiExp_StartMod: getColdStatus vanilla: is cold", Condiexp_Verbose.GetValueInt())
			OnCondiExpSLAEvent(arousalColdThreshold, arousalCold, "is not feeling aroused because of cold", "CondiExpCold", act)
			return 1
		else
			return 0
		endif
	elseIf Condiexp_ColdMethod.GetValueInt() == 5
		log("Condiexp_ColdMethod is set to auto and wasn't updated", 1)
	endif

	return 0
endfunction

int function getDirtyStatus(Actor act)
	If (dirtOverride)
		return 3
	ElseIf (traumaOverride || coldOverride || arousalOverride)
			return 0
	EndIf

	If (Condiexp_GlobalDirty.GetValueInt() == 0)
		return 0
	EndIf

	int dirty = 0
	If (LoadedBathMod != "None Found")
		if act.HasMagicEffect(DirtinessStage2Effect) || (BloodinessStage2Effect && act.HasMagicEffect(BloodinessStage2Effect))
			dirty = 1  ;not enough dirt to be sad
		elseif (act.HasMagicEffect(DirtinessStage3Effect) || (BloodinessStage3Effect && act.HasMagicEffect(BloodinessStage3Effect)))
			dirty = 2
		elseif (act.HasMagicEffect(DirtinessStage4Effect) || (BloodinessStage4Effect && act.HasMagicEffect(BloodinessStage4Effect)) || (DirtinessStage5Effect && act.HasMagicEffect(DirtinessStage5Effect)) || (BloodinessStage5Effect && act.HasMagicEffect(BloodinessStage5Effect)))
			dirty = 3
		else
			dirty = 0
		endIf
	EndIf
	
	;check cum oral
	if sexlab && dirty < 3
		if IsPlayerCumsoakedOral(sexlab, act)
			dirty = 3
			trace(act,"CondiExp_StartMod: updateDirtyStatus(): cumsoaked 3", Condiexp_Verbose.GetValueInt())
		endif
	endif

	;check cum else
	if sexlab && dirty < 2
		if IsPlayerCumsoakedVagOrAnal(sexlab, act)
			dirty = 2
			trace(act,"CondiExp_StartMod: updateDirtyStatus(): cumsoaked 2", Condiexp_Verbose.GetValueInt())
		endif
	endif

	If dirty > 0 && dirty > Condiexp_MinDirty.GetValueInt()
		return dirty
	else
		return 0
	EndIf
	return 0
endfunction

int function getTraumaStatus(Actor act)
	If (traumaOverride)
		return 6
	ElseIf (dirtOverride || coldOverride || arousalOverride)
			return 0
	EndIf
	if Condiexp_GlobalTrauma.GetValueInt() == 0
		return 0
	endif
	int trauma = 0

	;check apropos
	if ActorsQuest
		trauma = GetWearState0to10(act, ActorsQuest)
		if trauma > 1 && trauma > Condiexp_MinTrauma.GetValueInt()
			trace(act, "CondiExp_StartMod: updateTraumaStatus - AverageAbuseState: " + trauma, Condiexp_Verbose.GetValueInt())
			;No arousal when high trauma
			int AROUSAL_BLOCKING_TRAUMA_MAJOR = 6
			int AROUSAL_BLOCKING_TRAUMA_MINOR = 3
			if trauma >= AROUSAL_BLOCKING_TRAUMA_MAJOR
				trace(act, "CondiExp_StartMod: blocking arousal cause of high trauma", Condiexp_Verbose.GetValueInt())
				OnCondiExpSLAEvent(arousalTraumaMajorThreshold, arousalTraumaMajor, " not feeling aroused because of strong trauma", "CondiExpTraumaStrong", act)
				;setArousaToValue(act, sla, slaArousalFaction, 0)
			elseif trauma >= AROUSAL_BLOCKING_TRAUMA_MINOR
				OnCondiExpSLAEvent(arousalTraumaMinorThreshold, arousalTraumaMinor, " not feeling very aroused because of trauma", "CondiExpTrauma", act)
			endif
			return trauma
		endif
	endif
		
	;check zap slave
	if zbfFactionSlave && Condiexp_TraumaZBFFactionEnabled.GetValueInt() == 1
		if (act.IsInFaction(zbfFactionSlave))
			trauma = 5
			trace(act, "CondiExp_StartMod: updateTraumaStatus - zbfFactionSlave:  " + trauma, Condiexp_Verbose.GetValueInt())
			return trauma
		endif
	endif

	;nothing found: 0
	return 0
endfunction

int function getArousalStatus(Actor act)
	If (arousalOverride)
		return 99
	ElseIf (traumaOverride || coldOverride || dirtOverride)
			return 0
	EndIf
	if Condiexp_GlobalAroused.GetValueInt() == 0
		return 0
	endif
	int aroused = 0
	;check sla
	if sla
		aroused = getArousal0To100(act, sla, slaArousalFaction)
		if aroused > 0 && aroused > Condiexp_MinAroused.GetValueInt()
			trace(act, "CondiExp_StartMod: GetActorArousal(): " + aroused, Condiexp_Verbose.GetValueInt())
			return aroused
		endif
	endif

	;nothing found: 0
	return 0
endfunction

bool function isSendArousalEventsEnabled()
	return sla && Condiexp_GlobalArousalModifiers.GetValueInt() == 1
endfunction

Event OnCondiExpSLAEvent(int arousalCap, int decrease, String notification, String effectName, Form act)
	If !isSendArousalEventsEnabled()
		trace_line("Event received but Condiexp_GlobalArousalModifiers is disabled", Condiexp_Verbose.GetValueInt())
		return
	endif
	trace(act as Actor,"CondiExp_StartMod: OnCondiExpSLAEvent: "+ notification, Condiexp_Verbose.GetValueInt())
	bool wasChanged = capExposureAndArousal(act as Actor, sla, slaExposureFaction, slaArousalFaction, arousalCap, decrease, effectName)
	if  wasChanged && (Condiexp_GlobalArousalModifiersNotifications.GetValueInt() == 1)
		Notification((act as Actor).GetLeveledActorBase().GetName() + " " + notification)
	endif
 EndEvent

Event OnDhlpSuspend(string eventName, string strArg, float numArg, Form sender)
	log("CondiExp_StartMod: suspended by: " + sender.GetName())
	Condiexp_SuspendedByDhlpEvent.SetValueInt(1)
	If (isModEnabled())
		Condiexp_ModSuspended.SetValueInt(1)
	EndIf
 EndEvent
 
 Event OnDhlpResume(string eventName, string strArg, float numArg, Form sender)
	log("CondiExp_StartMod: resumed by: " + sender.GetName())
	Condiexp_SuspendedByDhlpEvent.SetValueInt(0)
	If (!isModEnabled())
		Condiexp_ModSuspended.SetValueInt(0)
	EndIf
 EndEvent
 
Function StopMod()
	Condiexp_ModSuspended.SetValueInt(1)
	utility.wait(3)
	resetConditions()
	PlayerRef.RemoveSpell(CondiExp_Fatigue1)
	resetMFG(PlayerRef)
	unregisterEvents()
	log("Stopped")
endfunction

Function StartMod()
	resetConditions()
	PlayerRef.RemoveSpell(CondiExp_Fatigue1)
	resolveAutoColdMethod()
	trace_line("CondiExp_StartMod: Condiexp_ColdMethod(): " + Condiexp_ColdMethod.GetValueInt(), Condiexp_Verbose.GetValueInt())
	init()
	Utility.Wait(0.5)
	PlayerRef.AddSpell(CondiExp_Fatigue1, false)
	;for compatibility with other mods
	unregisterEvents()
	registerEvents()
	If CondiExp_Sounds.GetValueInt() > 0
		NewRace()
	Endif
	Condiexp_ModSuspended.SetValueInt(0)
	RegisterForSingleUpdate(5)
	log("Started")
Endfunction

Function unregisterEvents()
	UnregisterForModEvent("dhlp-Suspend")
	UnregisterForModEvent("dhlp-Resume")
	UnregisterForModEvent("ostim_end")
	UnregisterForModEvent("ostim_start")
	UnregisterForModEvent("CondiExp_SLAEvent")
endfunction

Function registerEvents()
	RegisterForModEvent("dhlp-Suspend", "OnDhlpSuspend")
	RegisterForModEvent("dhlp-Resume", "OnDhlpResume")
	RegisterForModEvent("ostim_start", "OnDhlpSuspend")
	RegisterForModEvent("ostim_end", "OnDhlpResume")
	RegisterForModEvent("CondiExp_SLAEvent","OnCondiExpSLAEvent")
endfunction

Function resolveAutoColdMethod()
	If Condiexp_GlobalCold.GetValueInt() == 1 && Condiexp_ColdMethod.GetValueInt() == 5
		If isFrostFallReady()
		;Frostfall Installed
			Condiexp_ColdMethod.SetValueInt(1)
			trace_line("CondiExp_StartMod: Condiexp_ColdMethod(): 1 - Frostfall", Condiexp_Verbose.GetValueInt())
		elseif isFrostbiteReady()
		;Frostbite Installed
			Condiexp_ColdMethod.SetValueInt(2)
			trace_line("CondiExp_StartMod: Condiexp_ColdMethod(): 2 - Frostbite", Condiexp_Verbose.GetValueInt())
		elseif isSunHelmReady()
		;SunHelmSurvival Installed
			Condiexp_ColdMethod.SetValueInt(3)
			trace_line("CondiExp_StartMod: Condiexp_ColdMethod(): 3 - SunHelmSurvival", Condiexp_Verbose.GetValueInt())
		else
		; vanilla cold weathers
			Condiexp_ColdMethod.SetValueInt(4)
			trace_line("CondiExp_StartMod: Condiexp_ColdMethod(): 4 - Vanilla", Condiexp_Verbose.GetValueInt())
		endif
	endif
endfunction

Event OnKeyDown(Int KeyCode)
	if _checkPlugins !=0
		Notification("Initialization in progress. Please wait")
		return
	endif
	If (KeyCode == Condiexp_HKPause.GetValueInt()) ; Action key
		If (Condiexp_SuspendedByKey.GetValueInt() == 1)
			Condiexp_SuspendedByKey.SetValueInt(0)
			Notification("Resumed by key. Please wait")
		else
			Condiexp_SuspendedByKey.SetValueInt(1)
			Notification("Suspended by key. Please wait")
		Endif
	Endif
	If (KeyCode == Condiexp_HKRegisterFollowers.GetValueInt()) ; Action key
		if (CondiExpFollowerQuest.IsRunning())
			ResetQuest(CondiExpFollowerQuest)
			Notification("Followers were registered")
		else
			Notification("Followers support is disabled")
		endIf
	Endif
EndEvent

Function NewRace()
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

Function resetStatuses()
	Condiexp_CurrentlyCold.SetValueInt(0)
	Condiexp_CurrentlyDirty.SetValueInt(0)
	Condiexp_CurrentlyTrauma.SetValueInt(0)
	Condiexp_CurrentlyAroused.SetValueInt(0)
endfunction

Function resetConditions()
	Condiexp_CurrentlyCold.SetValueInt(0)
	Condiexp_CurrentlyDirty.SetValueInt(0)
	Condiexp_CurrentlyTrauma.SetValueInt(0)
	Condiexp_CurrentlyAroused.SetValueInt(0)
	Condiexp_CurrentlyBusy.SetValueInt(0)
	Condiexp_CurrentlyBusyImmediate.SetValueInt(0)
	Condiexp_SuspendedByDhlpEvent.SetValueInt(0)
endfunction

Bool function isModEnabled()
	return Condiexp_ModSuspended.GetValueInt() == 0
endfunction

Bool function isSuspendedByDhlpEvent()
	return Condiexp_SuspendedByDhlpEvent.GetValueInt() == 1
endfunction

Bool function isSuspendedByKey()
	return Condiexp_SuspendedByKey.GetValueInt() == 1
endfunction
