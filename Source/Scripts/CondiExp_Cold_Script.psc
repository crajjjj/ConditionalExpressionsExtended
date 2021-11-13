Scriptname CondiExp_Cold_Script extends ActiveMagicEffect 

Actor Property PlayerRef Auto
GlobalVariable Property Condiexp_CurrentlyCold Auto 
GlobalVariable Property Condiexp_CurrentlyBusy Auto
GlobalVariable Property Condiexp_ColdMethod Auto
int Method = 0;
GlobalVariable Temp ;Method 1 = Game.GetFormFromFile(0x00068119, "Frostfall.esp") as GlobalVariable
Spell Cold1   		;Method 2 = Game.GetFormFromFile(0x00029028, "Frostbite.esp") as Spell
Spell Cold2   		;Method 2 = Game.GetFormFromFile(0x00029029, "Frostbite.esp") as Spell
Spell Cold3   		;Method 2 = Game.GetFormFromFile(0x0002902C, "Frostbite.esp") as Spell
int coldExpression = 0 
 


Event OnEffectStart(Actor akTarget, Actor akCaster)
	Condiexp_CurrentlyBusy.SetValue(1)
	GetMethod()
	RegisterForSingleUpdate(0.01)
EndEvent


; cache these values, getting them is taxing so we dont want to poll for them each update
function GetMethod()
	Method = Condiexp_ColdMethod.GetValue() as int
	If Method == 1
		Temp = Game.GetFormFromFile(0x00068119, "Frostfall.esp") as GlobalVariable
	elseIf Method == 2 
		Cold1 = Game.GetFormFromFile(0x00029028, "Frostbite.esp") as Spell
		Cold2 = Game.GetFormFromFile(0x00029029, "Frostbite.esp") as Spell
		Cold3 = Game.GetFormFromFile(0x0002902C, "Frostbite.esp") as Spell
	endif
endfunction

;more immediate check
bool function CheckForCold()
	If Method == 1 
		return (Temp && Temp.GetValue() > 2)
	elseif Method == 2
		return  ((Cold1 && PlayerRef.HasSpell(Cold1)) || (Cold2 && PlayerRef.HasSpell(Cold2)) || (Cold3 && PlayerRef.HasSpell(Cold3)))  
	elseif Method == 3 
		return (Weather.GetCurrentWeather().GetClassification() == 3 && PlayerRef.IsInInterior() == false)
	endif
endfunction 


event OnUpdate()
	if (CheckForCold())
		Condiexp_CurrentlyCold.SetValue(1)
		PlayerRef.SetExpressionOverride(1,50)
		
		
		 ; cold intro
		if (coldExpression <= 65) 
			if (coldExpression < 0)
				coldExpression = 0
			endif
			PlayerRef.SetExpressionOverride(1,50)
			MfgConsoleFunc.SetModifier(PlayerRef, 12, coldExpression)
			MfgConsoleFunc.SetModifier(PlayerRef, 13, coldExpression)
			MfgConsoleFunc.SetModifier(PlayerRef, 4, coldExpression)
			coldExpression += 5
			
			RegisterForSingleUpdate(0.5)
		else ; this is Tremble
			MfgConsoleFunc.SetPhoneMe(PlayerRef, 0,0)
			Utility.Wait(0.01)
			MfgConsoleFunc.SetPhoneMe(PlayerRef, 0,6)
			Utility.Wait(0.01)
			MfgConsoleFunc.SetPhoneMe(PlayerRef, 0,12)
			Utility.Wait(0.01)
			MfgConsoleFunc.SetPhoneMe(PlayerRef, 0,6)
			Utility.Wait(0.01)
			MfgConsoleFunc.SetPhoneMe(PlayerRef, 0,6)
			Utility.Wait(0.01)
			MfgConsoleFunc.SetPhoneMe(PlayerRef, 0,12)
			Utility.Wait(0.01)
			MfgConsoleFunc.SetPhoneMe(PlayerRef, 0,6)
			Utility.Wait(0.01)
			MfgConsoleFunc.SetPhoneMe(PlayerRef, 0,6)
			Utility.Wait(0.01)
			MfgConsoleFunc.SetPhoneMe(PlayerRef, 0,12)
			Utility.Wait(0.01)
			MfgConsoleFunc.SetPhoneMe(PlayerRef, 0,6)
			RegisterForSingleUpdate(0.5)
		endif
	else
		;cold outro
		if (coldExpression >= 0)
			if (coldExpression > 65)
				coldExpression = 65
			endif
			MfgConsoleFunc.SetModifier(PlayerRef, 12, coldExpression)
			MfgConsoleFunc.SetModifier(PlayerRef, 13, coldExpression)
			MfgConsoleFunc.SetModifier(PlayerRef, 4, coldExpression)
			coldExpression  -= 5
			RegisterForSingleUpdate(0.5)
		else ; if the outro is done we clean up and stop calling update
			MfgConsoleFunc.SetPhoneMe(PlayerRef, 0,0)
			PlayerRef.ClearExpressionOverride()
			Condiexp_CurrentlyCold.SetValue(0)
			Condiexp_CurrentlyBusy.SetValue(0)
		endif
	endif
endevent


Event OnEffectFinish(Actor akTarget, Actor akCaster)			

;OnEffectFinish is called, this script instance will only remain existing so long this function hasn't ended
;an OnUpdate might be still going so we first wait for it

	; now we start/continue the outro sequence
	while (coldExpression >= 0)
		if (coldExpression > 65)
			coldExpression = 65
		endif
		MfgConsoleFunc.SetModifier(PlayerRef, 12, coldExpression)
		MfgConsoleFunc.SetModifier(PlayerRef, 13, coldExpression)
		MfgConsoleFunc.SetModifier(PlayerRef, 4, coldExpression)
		coldExpression  -= 5
		Utility.Wait(0.5) ; !!!
	endwhile

	MfgConsoleFunc.SetPhoneMe(PlayerRef, 0,0)
	PlayerRef.ClearExpressionOverride()
	Condiexp_CurrentlyCold.SetValue(0)
	Condiexp_CurrentlyBusy.SetValue(0)
EndEvent
