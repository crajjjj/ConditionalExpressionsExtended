Scriptname CondiExp_StartMod extends ReferenceAlias  
import CondiExp_log
import CondiExp_util

Spell Property CondiExp_Fatigue1 Auto
Actor Property PlayerRef Auto
Formlist property CondiExp_Drugs Auto
Formlist property CondiExp_Drinks Auto
Keyword Property VendorItemFood Auto
GlobalVariable Property CondiExp_CurrentlyBusy Auto
GlobalVariable Property CondiExp_PlayerIsHigh Auto
GlobalVariable Property CondiExp_PlayerIsDrunk Auto
GlobalVariable Property CondiExp_PlayerJustAte Auto
GlobalVariable Property Condiexp_GlobalCold Auto
GlobalVariable Property Condiexp_GlobalTrauma Auto
GlobalVariable Property Condiexp_CurrentlyTrauma Auto
GlobalVariable Property Condiexp_GlobalDirty Auto
GlobalVariable Property Condiexp_CurrentlyDirty Auto
GlobalVariable Property Condiexp_ColdMethod Auto
GlobalVariable Property Condiexp_CurrentlyCold Auto
GlobalVariable Property Condiexp_ColdGlobal Auto
GlobalVariable Property Condiexp_Sounds Auto

Race Property KhajiitRace Auto
Race Property KhajiitRaceVampire Auto
Race Property OrcRace Auto
Race Property OrcRaceVampire Auto
Keyword property Vampire Auto

String Property LoadedBathMod Auto Hidden
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
;Zaz slave faction
Faction zbfFactionSlave



Event OnInit()
	StartMod()
	init()
EndEvent

Event onPlayerLoadGame()
	log("Game reload event")
	init()
endEvent

function init()
	if !ActorsQuest
		ActorsQuest = Game.GetFormFromFile(0x02902C, "Apropos2.esp") as Quest	
		if ActorsQuest
			log("Found Apropos: " + ActorsQuest.GetName() )
		endif
	endif
	if !zbfFactionSlave
		zbfFactionSlave = Game.GetFormFromFile(0x0096AE, "ZaZAnimationPack.esm") as Faction	
		if zbfFactionSlave
			log("Found ZaZAnimationPack: " + zbfFactionSlave.GetName() )
		endif
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
	log("Bathing mod: " + LoadedBathMod)
	;for compatibility with other mods
	RegisterForModEvent("dhlp-Suspend", "OnDhlpSuspend")
	RegisterForModEvent("dhlp-Resume", "OnDhlpResume")
	RegisterForSingleUpdate(5)
endfunction

Event OnUpdate()
	updateColdStatus()
	updateTraumaStatus()
	updateDirtyStatus()

  	if (PlayerRef.HasSpell(CondiExp_Fatigue1))
		RegisterForSingleUpdate(5)
  	endif
EndEvent

function updateColdStatus()
	if Condiexp_ColdGlobal.GetValue() == 0
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
endfunction

function updateDirtyStatus()
	If (Condiexp_GlobalDirty.GetValue() == 0)
		return
	EndIf
	if PlayerRef.HasMagicEffect(DirtinessStage2Effect) || (BloodinessStage2Effect && PlayerRef.HasMagicEffect(BloodinessStage2Effect))
		Condiexp_CurrentlyDirty.SetValue(1.0)
	elseif (PlayerRef.HasMagicEffect(DirtinessStage3Effect) || (BloodinessStage3Effect && PlayerRef.HasMagicEffect(BloodinessStage3Effect)))
		Condiexp_CurrentlyDirty.SetValue(2.0)
	elseif (PlayerRef.HasMagicEffect(DirtinessStage4Effect) || (BloodinessStage4Effect && PlayerRef.HasMagicEffect(BloodinessStage4Effect)) || (DirtinessStage5Effect && PlayerRef.HasMagicEffect(DirtinessStage5Effect)) || (BloodinessStage5Effect && PlayerRef.HasMagicEffect(BloodinessStage5Effect)))
		Condiexp_CurrentlyDirty.SetValue(3.0)
	else
		Condiexp_CurrentlyDirty.SetValue(0.0)
	endIf
endfunction

function updateTraumaStatus()
	if Condiexp_GlobalTrauma.GetValue() == 0
		return
	endif
	int trauma = 0
	;check apropos
	if ActorsQuest
		trauma = GetWearState(PlayerRef)
		if trauma > 0
			Condiexp_CurrentlyTrauma.SetValue(trauma)
			return
		endif	
	endif
		
	;check zap slave
	if zbfFactionSlave
		if (PlayerRef.IsInFaction(zbfFactionSlave))
			trauma = 10
			Condiexp_CurrentlyTrauma.SetValue(trauma)
			return
		endif
	endif

	;nothing found: 0
	Condiexp_CurrentlyTrauma.SetValue(trauma)
	
endfunction

Event OnDhlpSuspend(string eventName, string strArg, float numArg, Form sender)
	log("suspended by: " + sender.GetName())
	StopMod()
 EndEvent
 
 Event OnDhlpResume(string eventName, string strArg, float numArg, Form sender)
	log("resumed by: " + sender.GetName())
	StartMod()
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
	PlayerRef.RemoveSpell(CondiExp_Fatigue1)
	PlayerRef.ClearExpressionOverride()
	MfgConsoleFunc.ResetPhonemeModifier(PlayerRef)
endfunction

Function StartMod()
	log("Started")
	CondiExp_CurrentlyBusy.SetValue(0)
	MfgConsoleFunc.ResetPhonemeModifier(PlayerRef)

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

Int Function GetWearState(Actor PlayerRef) 		
	if !ActorsQuest
		return 0
	endif
	
	ReferenceAlias AproposTwoAlias = GetAproposAlias(PlayerRef, ActorsQuest)
	if GetAproposAlias(PlayerRef, ActorsQuest) != None
		Int damage = (AproposTwoAlias as Apropos2ActorAlias).AverageAbuseState
		;log("WT Damage" + damage)
		If damage <= 10
			return damage
		Else
			return 10
		EndIf
	Else
		return 0
	Endif
EndFunction

ReferenceAlias Function GetAproposAlias(Actor akTarget, Quest apropos2Quest )
	; Search Apropos2 actor aliases as the player alias is not set in stone
	ReferenceAlias AproposTwoAlias = None
	Int i = 0
	ReferenceAlias AliasSelect
	While i < apropos2Quest.GetNumAliases() 
		AliasSelect = ActorsQuest.GetNthAlias(i) as ReferenceAlias
		If AliasSelect.GetReference() as Actor == akTarget
			AproposTwoAlias = AliasSelect
		EndIf
		Return AproposTwoAlias
		i += 1
	EndWhile
	Return AproposTwoAlias
EndFunction