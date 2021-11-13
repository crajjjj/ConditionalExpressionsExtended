Scriptname Condiexp_RandomFrostbite extends activemagiceffect  
import CondiExp_util

Actor Property PlayerRef Auto
GlobalVariable Property Condiexp_CurrentlyCold Auto
GlobalVariable Property Condiexp_ColdGlobal Auto
GlobalVariable Property Condiexp_CurrentlyBusy Auto
GlobalVariable Property CondiExp_PlayerIsHigh Auto
GlobalVariable Property CondiExp_PlayerIsDrunk Auto
GlobalVariable Property Condiexp_GlobalRandomFrequency Auto
GlobalVariable Property Condiexp_CurrentlyTrauma Auto
GlobalVariable Property Condiexp_CurrentlyDirty Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)

If Condiexp_ColdGlobal.GetValue() == 1
	Spell Cold1 = Game.GetFormFromFile(0x00029028, "Frostbite.esp") as Spell
	Spell Cold2 = Game.GetFormFromFile(0x00029029, "Frostbite.esp") as Spell
	Spell Cold3 = Game.GetFormFromFile(0x0002902C, "Frostbite.esp") as Spell
	If PlayerRef.HasSpell(Cold1) || PlayerRef.HasSpell(Cold2) || PlayerRef.HasSpell(Cold3)  
		Condiexp_CurrentlyCold.SetValue(1)
		else
		Condiexp_CurrentlyCold.SetValue(0)
	endif

	If Condiexp_CurrentlyCold.GetValue() == 0 && Condiexp_CurrentlyBusy.GetValue() == 0 && Condiexp_CurrentlyTrauma.GetValue() == 0 && Condiexp_CurrentlyDirty.GetValue() == 0
		Utility.Wait(0.5)
		ShowExpression()
	endif
endif
EndEvent


Function ShowExpression() 
	RandomEmotion(PlayerRef)
	Utility.Wait(1)
	If !PlayerRef.IsRunning() || !PlayerRef.GetAnimationVariableInt("i1stPerson")
		Int Seconds = Utility.RandomInt(2, 5)
		RegisterForSingleUpdate(Seconds)
	endif
EndFunction


Event OnUpdate()
If !PlayerRef.GetAnimationVariableInt("i1stPerson")
	If Condiexp_CurrentlyBusy.GetValue() == 0
		ShowExpression()
	EndIf
endif
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)

If Condiexp_CurrentlyBusy.GetValue() == 0 && Condiexp_CurrentlyTrauma.GetValue() == 0 && Condiexp_CurrentlyDirty.GetValue() == 0
	PlayerRef.ClearExpressionOverride()
	MfgConsoleFunc.ResetPhonemeModifier(PlayerRef)
endif

EndEvent