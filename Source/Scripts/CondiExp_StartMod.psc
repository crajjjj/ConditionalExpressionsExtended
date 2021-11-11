Scriptname CondiExp_StartMod extends ReferenceAlias  
import CondiExp_log

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
GlobalVariable Property Condiexp_ColdMethod Auto
GlobalVariable Property Condiexp_Sounds Auto

Race Property KhajiitRace Auto
Race Property KhajiitRaceVampire Auto
Race Property OrcRace Auto
Race Property OrcRaceVampire Auto

;Apropos2
Quest ActorsQuest

Event OnInit()
	StartMod()
	init()
EndEvent

Event onPlayerLoadGame()
	logAndNotification("Game reload event")
	init()
endEvent

function init()
	if !ActorsQuest
		ActorsQuest = Game.GetFormFromFile(0x02902C, "Apropos2.esp") as Quest	
	endif
	RegisterForModEvent("dhlp-Suspend", "OnDhlpSuspend")
	RegisterForModEvent("dhlp-Resume", "OnDhlpResume")
	RegisterForSingleUpdate(5)
endfunction

Event OnUpdate()
	if Condiexp_GlobalTrauma.GetValue() == 1
		Condiexp_CurrentlyTrauma.SetValue(GetWearState(PlayerRef))
	endif
  	if (PlayerRef.HasSpell(CondiExp_Fatigue1))
		RegisterForSingleUpdate(5)
  	endif
EndEvent

Event OnDhlpSuspend(string eventName, string strArg, float numArg, Form sender)
	logAndNotification("suspended by: " + sender.GetName() )
	StopMod()
 EndEvent
 
 Event OnDhlpResume(string eventName, string strArg, float numArg, Form sender)
	logAndNotification("resumed by: " + sender.GetName())
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
		Int adamage = (AproposTwoAlias as Apropos2ActorAlias).AnalWearTearState
		Int vdamage = (AproposTwoAlias as Apropos2ActorAlias).VaginalWearTearState
		Int odamage = (AproposTwoAlias as Apropos2ActorAlias).OralWearTearState
		int damage = adamage + vdamage + odamage
		log("WT Damage" + damage)
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