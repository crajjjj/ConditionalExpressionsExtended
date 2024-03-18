Scriptname CondiExp_PCTracking extends ReferenceAlias  
import CondiExp_log
import CondiExp_util
Actor Property PlayerRef Auto
Quest Property CondiExpFollowerQuest Auto
CondiExp_StartMod Property sm Auto

GlobalVariable Property Condiexp_Verbose Auto
GlobalVariable Property Condiexp_GlobalEating Auto
Formlist property CondiExp_Drugs Auto
Formlist property CondiExp_Drinks Auto
GlobalVariable Property CondiExp_CurrentlyBusy Auto
GlobalVariable Property Condiexp_CurrentlyBusyImmediate Auto
GlobalVariable Property CondiExp_PlayerIsHigh Auto
GlobalVariable Property CondiExp_PlayerIsDrunk Auto
GlobalVariable Property CondiExp_PlayerJustAte Auto
GlobalVariable Property Condiexp_ModSuspended Auto
GlobalVariable Property Condiexp_Sounds Auto
Keyword Property VendorItemFood Auto
Keyword Property VendorItemIngredient Auto
Race Property KhajiitRace Auto
Race Property KhajiitRaceVampire Auto
Race Property OrcRace Auto
Race Property OrcRaceVampire Auto
Keyword property Vampire Auto

Event onPlayerLoadGame()
	log("CondiExp_Tracking: Game reload event")
	sm.RegisterForSingleUpdate(5)
endEvent


Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
	If (!sm.isModEnabled())
		log("CondiExp_Tracking: OnObjectEquipped stopped: " + akBaseObject.GetName())
		return
	EndIf
	verbose(PlayerRef, "CondiExp_Tracking: OnObjectEquipped triggered: " + akBaseObject.GetName())
	If CondiExp_Drugs.HasForm(akBaseObject)
		CondiExp_PlayerIsHigh.SetValueInt(1)
	
	elseif  CondiExp_Drinks.HasForm(akBaseObject)
			CondiExp_PlayerIsDrunk.SetValueInt(1)
	
	elseif akBaseObject.HasKeyWord(VendorItemFood)
			CondiExp_PlayerJustAte.SetValueInt(1)
			log("CondiExp_Tracking: OnObjectEquipped VendorItemFood: " + akBaseObject.GetName())
			utility.wait(5)
	
	elseif akBaseObject.HasKeyword(VendorItemIngredient)
	
		If  Condiexp_GlobalEating.GetValueInt() == 2
				CondiExp_PlayerJustAte.SetValueInt(1)
				log("CondiExp_Tracking: OnObjectEquipped VendorItemIngredient: " + akBaseObject.GetName())
				utility.wait(5)
	
		elseif Condiexp_GlobalEating.GetValueInt() == 1
				Condiexp_GlobalEating.SetValueInt(2)
				CondiExp_PlayerJustAte.SetValueInt(1)
				log("CondiExp_Tracking: OnObjectEquipped VendorItemIngredient: " + akBaseObject.GetName())
				utility.wait(5)
				Condiexp_GlobalEating.SetValueInt(1)
		endif
	Endif
EndEvent

Event OnRaceSwitchComplete()
	If CondiExp_Sounds.GetValueInt() > 0
        log("CondiExp_Tracking: OnRaceSwitchComplete")
		sm.NewRace()
	Endif
EndEvent

