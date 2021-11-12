Scriptname CondiExp_RandomVanilla extends activemagiceffect  
import CondiExp_util
import CondiExp_log

Actor Property PlayerRef Auto
GlobalVariable Property Condiexp_CurrentlyCold Auto
GlobalVariable Property Condiexp_ColdGlobal Auto
GlobalVariable Property Condiexp_CurrentlyBusy Auto
GlobalVariable Property CondiExp_PlayerIsHigh Auto
GlobalVariable Property CondiExp_PlayerIsDrunk Auto
GlobalVariable Property Condiexp_GlobalRandomFrequency Auto
Keyword property Vampire Auto
GlobalVariable Property Condiexp_CurrentlyTrauma Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
	
If Condiexp_ColdGlobal.GetValue() == 1
	If Weather.GetCurrentWeather().GetClassification() == 3 && !PlayerRef.HasKeyword(Vampire) && !PlayerRef.IsinInterior()
		Condiexp_CurrentlyCold.SetValue(1)
	else
		Condiexp_CurrentlyCold.SetValue(0)
	endif
endif

If Condiexp_CurrentlyCold.GetValue() == 0 && Condiexp_CurrentlyBusy.GetValue() == 0 && Condiexp_CurrentlyTrauma.GetValue() == 0
	Utility.Wait(0.5)
	ShowExpression()
endif
EndEvent

Function ShowExpression()
	log("Random playing effect") 
	CondiExp_util.RandomEmotion(PlayerRef)
	Utility.Wait(1)
	If !PlayerRef.IsRunning() || !PlayerRef.GetAnimationVariableInt("i1stPerson")
		Int Seconds = Utility.RandomInt(2, 5)
		RegisterForSingleUpdate(Seconds)
	endif
EndFunction


Event OnUpdate()
If PlayerRef.GetAnimationVariableInt("i1stPerson")
else
	If Condiexp_CurrentlyBusy.GetValue() == 0
		ShowExpression()
	EndIf
endif
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
If Condiexp_CurrentlyBusy.GetValue() == 0 && Condiexp_CurrentlyTrauma.GetValue() == 0
	log("Random finishing effect")
	PlayerRef.ClearExpressionOverride()
	MfgConsoleFunc.ResetPhonemeModifier(PlayerRef)
endif

EndEvent