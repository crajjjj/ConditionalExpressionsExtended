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

Race Property KhajiitRace Auto
Race Property KhajiitRaceVampire Auto
Race Property OrcRace Auto
Race Property OrcRaceVampire Auto
Keyword property Vampire Auto
Faction Property SexLabAnimatingFaction Auto


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
MagicEffect zadGagEffect
;SLA
Quest sla

int _checkPlugins = 0

Event OnInit()
	_checkPlugins = 1
	StartMod()
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
	if !zadGagEffect && isDDintegrationReady()
		zadGagEffect = Game.GetFormFromFile(0x02B077, "Devious Devices - Integration.esm") as MagicEffect
	endif
	if zadGagEffect
		log("CondiExp_StartMod: Found Devious Devices - Integration: " + zadGagEffect.GetName() )
	endif
	if !sla && isSLAReady()
		sla = Game.GetFormFromFile(0x4290F, "SexLabAroused.esm") As Quest
	endif
	if sla
		log("CondiExp_StartMod: Found SexLabAroused: " + sla.GetName() )
	endif
	if !sexlab && isSLReady()
		sexlab = Game.GetFormFromFile(0x000D62, "SexLab.esm") As Quest
	endif
	if sexlab
		log("CondiExp_StartMod: Found SexLab: " + sexlab.GetName())
	endif


	
	; checking what bath mod is loaded
	LoadedBathMod = "None Found"
	if GetDABDirtinessStage2Effect() != none ; if Dirt and Blood is loaded
		LoadedBathMod = "Dirt And Blood"
		DirtinessStage2Effect = GetDABDirtinessStage2Effect()
		DirtinessStage3Effect = GetDABDirtinessStage3Effect()
		DirtinessStage4Effect = GetDABDirtinessStage4Effect()
		DirtinessStage5Effect = GetDABDirtinessStage5Effect()
		BloodinessStage2Effect = GetDABBloodinessStage2Effect()
		BloodinessStage3Effect = GetDABBloodinessStage3Effect()
		BloodinessStage4Effect = GetDABBloodinessStage4Effect()
		BloodinessStage5Effect = GetDABBloodinessStage5Effect()
	elseif GetBISDirtinessStage2Effect() != none ; if Bathing In Skyrim is loaded
		LoadedBathMod = "Bathing In Skyrim"
		DirtinessStage2Effect = GetBISDirtinessStage2Effect()
		DirtinessStage3Effect = GetBISDirtinessStage3Effect()
		DirtinessStage4Effect = GetBISDirtinessStage4Effect()
	elseif (GetKICDirtinessStage2Effect() != none) ; if Keep it clean is loaded
		LoadedBathMod = "Keep It Clean"
		DirtinessStage2Effect = GetKICDirtinessStage2Effect()
		DirtinessStage3Effect = GetKICDirtinessStage3Effect()
		DirtinessStage4Effect = GetKICDirtinessStage4Effect()
	endif
	log("CondiExp_StartMod: Bathing mod: " + LoadedBathMod)
	;for compatibility with other mods
	RegisterForModEvent("dhlp-Suspend", "OnDhlpSuspend")
	RegisterForModEvent("dhlp-Resume", "OnDhlpResume")
endfunction

Event OnUpdate()
	;postponed module init
	If _checkPlugins > 0
		_checkPlugins += 1
		If _checkPlugins >= 2
			log("WidgetController: moduleSetup")
			init()
			_checkPlugins = 0
		EndIf
	EndIf

	updateColdStatus()
	updateTraumaStatus()
	updateDirtyStatus()
	updateArousalStatus()

	;check if there's a conflicting mod based on custom conditions
	if checkIfModShouldBeSuspended()
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

Bool function checkIfModShouldBeSuspended()
	if isSuspendedByDhlpEvent
		return true
	endif

	if zadGagEffect && PlayerRef.HasMagicEffect(zadGagEffect)
		log("CondiExp_StartMod: dd gag effect was detected. Will suspend")
		return true
	endif
	
	if (PlayerRef.IsInFaction(SexLabAnimatingFaction))
		;check is implemented in ck as well
		log("CondiExp_StartMod: player is in sl faction. Will suspend")
		return true
	endif

	return false
endfunction

function updateColdStatus()
	if Condiexp_GlobalCold.GetValue() == 0
		Condiexp_CurrentlyCold.SetValue(0)
		return
	endif
	If Condiexp_ColdMethod.GetValue() == 1
		GlobalVariable Temp = Game.GetFormFromFile(0x00068119, "Frostfall.esp") as GlobalVariable
		If Temp.GetValue() > 2 
			Condiexp_CurrentlyCold.SetValue(1)
			else
			Condiexp_CurrentlyCold.SetValue(0)
		endif
	elseIf Condiexp_ColdMethod.GetValue() == 2
		Spell Cold1 = Game.GetFormFromFile(0x00029028, "Frostbite.esp") as Spell
		Spell Cold2 = Game.GetFormFromFile(0x00029029, "Frostbite.esp") as Spell
		Spell Cold3 = Game.GetFormFromFile(0x0002902C, "Frostbite.esp") as Spell
		If PlayerRef.HasSpell(Cold1) || PlayerRef.HasSpell(Cold2) || PlayerRef.HasSpell(Cold3)  
			Condiexp_CurrentlyCold.SetValue(1)
			else
			Condiexp_CurrentlyCold.SetValue(0)
		endif
	elseIf Condiexp_ColdMethod.GetValue() == 3
		If Weather.GetCurrentWeather().GetClassification() == 3 && !PlayerRef.HasKeyword(Vampire) && !PlayerRef.IsinInterior()
			Condiexp_CurrentlyCold.SetValue(1)
		else
			Condiexp_CurrentlyCold.SetValue(0)
		endif
	endif
	trace("CondiExp_StartMod: updateColdStatus() " + Condiexp_CurrentlyCold.getValue())
endfunction

function updateDirtyStatus()
	If (Condiexp_GlobalDirty.GetValue() == 0 || LoadedBathMod == "None Found")
		Condiexp_CurrentlyDirty.SetValue(0.0)
		return
	EndIf

	int dirty = 0
	if PlayerRef.HasMagicEffect(DirtinessStage2Effect) || (BloodinessStage2Effect && PlayerRef.HasMagicEffect(BloodinessStage2Effect))
		dirty = 1  ;not enough dirt to be sad
	elseif (PlayerRef.HasMagicEffect(DirtinessStage3Effect) || (BloodinessStage3Effect && PlayerRef.HasMagicEffect(BloodinessStage3Effect)))
		dirty = 2
	elseif (PlayerRef.HasMagicEffect(DirtinessStage4Effect) || (BloodinessStage4Effect && PlayerRef.HasMagicEffect(BloodinessStage4Effect)) || (DirtinessStage5Effect && PlayerRef.HasMagicEffect(DirtinessStage5Effect)) || (BloodinessStage5Effect && PlayerRef.HasMagicEffect(BloodinessStage5Effect)))
		dirty = 3
	else
		dirty = 0
	endIf
	
	;check cum oral
	if sexlab && dirty < 3
		if IsPlayerCumsoakedOral(sexlab, PlayerRef)
			dirty = 3
			trace("CondiExp_StartMod: updateDirtyStatus(): cumsoaked")
		endif
	endif

	;check cum else
	if sexlab && dirty < 2
			if IsPlayerCumsoakedVagOrAnal(sexlab, PlayerRef)
				dirty = 2
				trace("CondiExp_StartMod: updateDirtyStatus(): cumsoaked")
			endif
	endif

	If dirty > 0 && dirty > Condiexp_MinDirty.GetValue()
		Condiexp_CurrentlyDirty.SetValue(dirty)
	else
		Condiexp_CurrentlyDirty.SetValue(0.0)
	EndIf
	
	trace("CondiExp_StartMod: updateDirtyStatus() " + Condiexp_CurrentlyDirty.getValue())
endfunction

function updateTraumaStatus()
	if Condiexp_GlobalTrauma.GetValue() == 0
		Condiexp_CurrentlyTrauma.SetValue(0)
		return
	endif
	int trauma = 0
	;check apropos
	if ActorsQuest
		trauma = GetWearState0to10(PlayerRef, ActorsQuest)
		if trauma > 1 && trauma > Condiexp_MinTrauma.GetValue()
			Condiexp_CurrentlyTrauma.SetValue(trauma)
			trace("CondiExp_StartMod: updateTraumaStatus - GetWearState(): " + Condiexp_CurrentlyTrauma.getValue())
			return
		endif
	endif
		
	;check zap slave
	if zbfFactionSlave
		if (PlayerRef.IsInFaction(zbfFactionSlave))
			trauma = 10
			Condiexp_CurrentlyTrauma.SetValue(trauma)
			trace("CondiExp_StartMod: updateTraumaStatus - zbfFactionSlave:  " + Condiexp_CurrentlyTrauma.getValue())
			return
		endif
	endif

	;nothing found: 0
	Condiexp_CurrentlyTrauma.SetValue(0)
	trace("CondiExp_StartMod: updateTraumaStatus():  " + Condiexp_CurrentlyTrauma.getValue())
	
endfunction

function updateArousalStatus()
	if Condiexp_GlobalAroused.GetValue() == 0
		Condiexp_CurrentlyAroused.SetValue(0)
		return
	endif
	int aroused = 0
	;check sla
	if sla
		aroused = getArousal0To100(PlayerRef, sla)
		if aroused > 0 && aroused > Condiexp_MinAroused.GetValue()
			Condiexp_CurrentlyAroused.SetValue(aroused)
			trace("CondiExp_StartMod: updateArousalStatus(): " + Condiexp_CurrentlyAroused.getValue())
			return
		endif
	endif

	;nothing found: 0
	Condiexp_CurrentlyAroused.SetValue(0)
	trace("CondiExp_StartMod: updateArousalStatus(): " + Condiexp_CurrentlyAroused.getValue())
	
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
	log("Stopped")
	Condiexp_ModSuspended.SetValue(1)
	utility.wait(3)
	resetConditions()
	PlayerRef.RemoveSpell(CondiExp_Fatigue1)
	resetMFG(PlayerRef)
	
endfunction

Function StartMod()
	log("Started")
	CondiExp_CurrentlyBusy.SetValue(0)
	resetMFG(PlayerRef)

	Utility.Wait(0.5)
	PlayerRef.AddSpell(CondiExp_Fatigue1, false)

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
endfunction

Bool function isModEnabled()
	return Condiexp_ModSuspended.getValue() == 0
endfunction
