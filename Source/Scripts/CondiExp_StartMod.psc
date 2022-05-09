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
GlobalVariable Property CondiExp_CurrentlyBusy Auto
GlobalVariable Property Condiexp_CurrentlyBusyImmediate Auto
GlobalVariable Property CondiExp_PlayerIsHigh Auto
GlobalVariable Property CondiExp_PlayerIsDrunk Auto
GlobalVariable Property CondiExp_PlayerJustAte Auto

GlobalVariable Property Condiexp_GlobalTrauma Auto
GlobalVariable Property Condiexp_CurrentlyTrauma Auto
GlobalVariable Property Condiexp_MinTrauma Auto

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

GlobalVariable Property Condiexp_ModSuspended Auto
GlobalVariable Property Condiexp_Sounds Auto

GlobalVariable Property Condiexp_UpdateInterval Auto
GlobalVariable Property Condiexp_FollowersUpdateInterval Auto
GlobalVariable Property Condiexp_Verbose Auto

Race Property KhajiitRace Auto
Race Property KhajiitRaceVampire Auto
Race Property OrcRace Auto
Race Property OrcRaceVampire Auto
Keyword property Vampire Auto
Faction Property SexLabAnimatingFaction Auto ;empty - to delete



String Property LoadedBathMod Auto Hidden
Bool Property isSuspendedByDhlpEvent Auto Hidden

;Bathing mod
MagicEffect DirtinessStage2Effect 
MagicEffect DirtinessStage3Effect
MagicEffect DirtinessStage4Effect
MagicEffect DirtinessStage5Effect
MagicEffect BloodinessStage2Effect
MagicEffect BloodinessStage3Effect
MagicEffect BloodinessStage4Effect
MagicEffect BloodinessStage5Effect

;Apropos2
Quest ActorsQuest
;Sexlab
Quest sexlab
;Zaz slave faction
Faction zbfFactionSlave
;Devious Devices
MagicEffect vZadGagEffect
;Toys
Keyword ToysEffectMouthOpen 
;SLA
Quest sla
Faction slaArousalFaction

int _checkPlugins = 0

Event OnInit()
	_checkPlugins = 1
	RegisterForSingleUpdate(10)
EndEvent

Event onPlayerLoadGame()
	log("CondiExp_StartMod: Game reload event")
	_checkPlugins = 1
	RegisterForSingleUpdate(1)
endEvent

function init()
	if !ActorsQuest && isAprReady()
		ActorsQuest = Game.GetFormFromFile(0x02902C, "Apropos2.esp") as Quest	
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
	if !vZadGagEffect && isDDintegrationReady()
		vZadGagEffect = Game.GetFormFromFile(0x02B077, "Devious Devices - Integration.esm") as MagicEffect
	endif
	if vZadGagEffect
		log("CondiExp_StartMod: Found Devious Devices - Integration: " + vZadGagEffect.GetName() )
	endif
	if !sla || !slaArousalFaction
		if isSLAReady()
			sla = Game.GetFormFromFile(0x4290F, "SexLabAroused.esm") As Quest
			slaArousalFaction = Game.GetFormFromFile(0x3FC36, "SexLabAroused.esm") As Faction
		endif
	endif
	if sla && slaArousalFaction
		log("CondiExp_StartMod: Found SexLabAroused: " + sla.GetName() )
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
	elseif (isDependencyReady("Keep It Clean.esp") && GetKICDirtinessStage2Effect() != none) ; if Keep it clean is loaded
		LoadedBathMod = "Keep It Clean"
		DirtinessStage2Effect = GetKICDirtinessStage2Effect()
		DirtinessStage3Effect = GetKICDirtinessStage3Effect()
		DirtinessStage4Effect = GetKICDirtinessStage4Effect()
	endif
	log("CondiExp_StartMod: Bathing mod: " + LoadedBathMod)
endfunction

Event OnUpdate()
	;postponed module init
	If _checkPlugins > 0
		_checkPlugins += 1
		If _checkPlugins >= 2
			log("WidgetController: moduleSetup")
			StartMod()
			_checkPlugins = 0
		EndIf
	EndIf

	Condiexp_CurrentlyCold.SetValue(getColdStatus(PlayerRef))
	trace("CondiExp_StartMod: getColdStatus() " + Condiexp_CurrentlyCold.getValue())
	
	Condiexp_CurrentlyTrauma.SetValue(getTraumaStatus(PlayerRef))
	trace("CondiExp_StartMod: getTraumaStatus() " + Condiexp_CurrentlyTrauma.getValue())

	Condiexp_CurrentlyDirty.SetValue(getDirtyStatus(PlayerRef))
	trace("CondiExp_StartMod: getDirtyStatus() " + Condiexp_CurrentlyDirty.getValue())

	Condiexp_CurrentlyAroused.SetValue(getArousalStatus(PlayerRef))
	trace("CondiExp_StartMod: getArousalStatus() " + Condiexp_CurrentlyAroused.getValue())

	;check if there's a conflicting mod based on custom conditions
	if checkIfModShouldBeSuspended(PlayerRef)
		if isModEnabled()
			log("CondiExp_StartMod: suspended according to conditions check")
			Condiexp_ModSuspended.SetValue(1)
		endif	
	else
		if !isModEnabled()
			log("CondiExp_StartMod: resumed according to conditions check")
			Condiexp_ModSuspended.SetValue(0)
		endif
 	endif

	if PlayerRef.HasSpell(CondiExp_Fatigue1)
		RegisterForSingleUpdate(Condiexp_UpdateInterval.GetValue())
	endif
	
EndEvent

Bool function checkIfModShouldBeSuspended(Actor act)
	if isSuspendedByDhlpEvent
		return true
	endif

	if (vZadGagEffect && act.HasMagicEffect(vZadGagEffect))
		log("CondiExp_StartMod: dd gag effect was detected. Will suspend for actor:" + act.GetName() )
		return true
	endif

	if (ToysEffectMouthOpen && act.WornHasKeyword(ToysEffectMouthOpen))
		log("CondiExp_StartMod: ToysEffectMouthOpen effect was detected. Will suspend for actor:" + act.GetName())
		return true
	endif

	if (sexlab && IsActorActive(sexlab, act))
		log("CondiExp_StartMod: actor is in sl faction. Will suspend for actor:" + act.GetName())
		return true
	endif
	
	return false
endfunction

int function getColdStatus(Actor act )
	if Condiexp_GlobalCold.GetValue() == 0
		return 0
	endif
	If Condiexp_ColdMethod.GetValue() == 1
		GlobalVariable Temp = Game.GetFormFromFile(0x00068119, "Frostfall.esp") as GlobalVariable
		If Temp.GetValue() > 2 
			return 1
			else
			return 0
		endif
	elseIf Condiexp_ColdMethod.GetValue() == 2
		Spell Cold1 = Game.GetFormFromFile(0x00029028, "Frostbite.esp") as Spell
		Spell Cold2 = Game.GetFormFromFile(0x00029029, "Frostbite.esp") as Spell
		Spell Cold3 = Game.GetFormFromFile(0x0002902C, "Frostbite.esp") as Spell
		If act.HasSpell(Cold1) || act.HasSpell(Cold2) || act.HasSpell(Cold3)  
			return 1
			else
			return 0
		endif
	elseIf Condiexp_ColdMethod.GetValue() == 3
		If !act.HasKeyword(Vampire) && !act.IsinInterior() && Weather.GetCurrentWeather().GetClassification() == 3
			return 1
		else
			return 0
		endif
	endif
	
endfunction

int function getDirtyStatus(Actor act)
	If (Condiexp_GlobalDirty.GetValue() == 0 || LoadedBathMod == "None Found")
		return 0
	EndIf

	int dirty = 0
	if act.HasMagicEffect(DirtinessStage2Effect) || (BloodinessStage2Effect && act.HasMagicEffect(BloodinessStage2Effect))
		dirty = 1  ;not enough dirt to be sad
	elseif (act.HasMagicEffect(DirtinessStage3Effect) || (BloodinessStage3Effect && act.HasMagicEffect(BloodinessStage3Effect)))
		dirty = 2
	elseif (act.HasMagicEffect(DirtinessStage4Effect) || (BloodinessStage4Effect && act.HasMagicEffect(BloodinessStage4Effect)) || (DirtinessStage5Effect && act.HasMagicEffect(DirtinessStage5Effect)) || (BloodinessStage5Effect && act.HasMagicEffect(BloodinessStage5Effect)))
		dirty = 3
	else
		dirty = 0
	endIf
	
	;check cum oral
	if sexlab && dirty < 3
		if IsPlayerCumsoakedOral(sexlab, act)
			dirty = 3
			log("CondiExp_StartMod: updateDirtyStatus(): cumsoaked 3")
		endif
	endif

	;check cum else
	if sexlab && dirty < 2
		if IsPlayerCumsoakedVagOrAnal(sexlab, act)
			dirty = 2
			log("CondiExp_StartMod: updateDirtyStatus(): cumsoaked 2")
		endif
	endif

	If dirty > 0 && dirty > Condiexp_MinDirty.GetValue()
		return dirty
	else
		return 0
	EndIf
endfunction

int function getTraumaStatus(Actor act)
	if Condiexp_GlobalTrauma.GetValue() == 0
		return 0
	endif
	int trauma = 0
	;check apropos
	if ActorsQuest
		trauma = GetWearState0to10(act, ActorsQuest)
		if trauma > 1 && trauma > Condiexp_MinTrauma.GetValue()
			trace("CondiExp_StartMod: updateTraumaStatus - GetWearState(): " + trauma)
			return trauma
		endif
	endif
		
	;check zap slave
	if zbfFactionSlave
		if (act.IsInFaction(zbfFactionSlave))
			trauma = 10
			trace("CondiExp_StartMod: updateTraumaStatus - zbfFactionSlave:  " + trauma)
			return trauma
		endif
	endif

	;nothing found: 0
	return 0
endfunction

int function getArousalStatus(Actor act)
	if Condiexp_GlobalAroused.GetValue() == 0
		return 0
	endif
	int aroused = 0
	;check sla
	if sla
		aroused = getArousal0To100(act, sla, slaArousalFaction)
		if aroused > 0 && aroused > Condiexp_MinAroused.GetValue()
			trace("CondiExp_StartMod: updateArousalStatus(): " + Condiexp_CurrentlyAroused.getValue())
			return aroused
		endif
	endif

	;nothing found: 0
	return 0

endfunction

Event OnDhlpSuspend(string eventName, string strArg, float numArg, Form sender)
	log("CondiExp_StartMod: suspended by: " + sender.GetName())
	isSuspendedByDhlpEvent = true
	If (isModEnabled())
		Condiexp_ModSuspended.SetValue(1)
	EndIf
 EndEvent
 
 Event OnDhlpResume(string eventName, string strArg, float numArg, Form sender)
	log("CondiExp_StartMod: resumed by: " + sender.GetName())
	isSuspendedByDhlpEvent = false
	If (!isModEnabled())
		Condiexp_ModSuspended.SetValue(0)
	EndIf
 EndEvent

Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
	If CondiExp_Drugs.HasForm(akBaseObject)
		CondiExp_PlayerIsHigh.SetValue(1)

	elseif  CondiExp_Drinks.HasForm(akBaseObject)
		CondiExp_PlayerIsDrunk.SetValue(1)

	elseif akBaseObject.HasKeyWord(VendorItemFood)
		CondiExp_PlayerJustAte.SetValue(1)
		utility.wait(5)
		CondiExp_PlayerJustAte.SetValue(0)
	Endif
EndEvent

Function StopMod()
	Condiexp_ModSuspended.SetValue(1)
	utility.wait(3)
	resetConditions()

	PlayerRef.RemoveSpell(CondiExp_Fatigue1)
	resetMFG(PlayerRef)

	UnregisterForModEvent("dhlp-Suspend")
	UnregisterForModEvent("dhlp-Resume")

	log("Stopped")
endfunction

Function StartMod()
	resetConditions()
	init()
	Utility.Wait(0.5)
	PlayerRef.RemoveSpell(CondiExp_Fatigue1)
	PlayerRef.AddSpell(CondiExp_Fatigue1, false)
	;for compatibility with other mods
	UnregisterForModEvent("dhlp-Suspend")
	UnregisterForModEvent("dhlp-Resume")
	UnregisterForModEvent("ostim_end")
	UnregisterForModEvent("ostim_start")
	RegisterForModEvent("dhlp-Suspend", "OnDhlpSuspend")
	RegisterForModEvent("dhlp-Resume", "OnDhlpResume")
	RegisterForModEvent("ostim_start", "OnDhlpSuspend")
	RegisterForModEvent("ostim_end", "OnDhlpResume")

	If CondiExp_Sounds.GetValue() > 0
		NewRace()
	Endif

	If Condiexp_GlobalCold.GetValue() == 1
		If Game.GetModByName("Frostfall.esp") != 255
		;Frostfall Installed
			Condiexp_ColdMethod.SetValue(1)
		elseif Game.GetModByName("Frostbite.esp") != 255
		;Frostbite Installed
			Condiexp_ColdMethod.SetValue(2)
		else
		; vanilla cold weathers
			Condiexp_ColdMethod.SetValue(3)
		endif
	endif
	Condiexp_ModSuspended.SetValue(0)
	RegisterForSingleUpdate(5)
	log("Started")
Endfunction


Event OnRaceSwitchComplete()
If CondiExp_Sounds.GetValue() > 0
	NewRace()
Endif
EndEvent


Function NewRace()
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

Function resetConditions()
	Condiexp_CurrentlyCold.SetValue(0)
	Condiexp_CurrentlyDirty.SetValue(0)
	Condiexp_CurrentlyTrauma.SetValue(0)
	Condiexp_CurrentlyAroused.SetValue(0)
	Condiexp_CurrentlyBusy.SetValue(0)
	Condiexp_CurrentlyBusyImmediate.SetValue(0)
endfunction

Bool function isModEnabled()
	return Condiexp_ModSuspended.getValue() == 0
endfunction
