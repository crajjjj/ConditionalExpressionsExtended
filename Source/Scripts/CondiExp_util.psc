Scriptname CondiExp_util Hidden

Import Debug

String Function GetModName() Global
	return "Conditional Expressions Extended"
EndFunction

;SemVer support
Int Function GetVersion() Global
    Return 10202
    ; 1.0.0   -> 10000
    ; 1.1.0   -> 10100
    ; 1.1.1  -> 10101
    ; 1.61  -> 16100
    ; 10.61.20 -> 106120 
EndFunction

String Function GetVersionString() Global
    Return "1.2.2"
EndFunction

String Function StringIfElse(Bool isTrue, String returnTrue, String returnFalse = "") Global
    If isTrue
        Return returnTrue
    Else
        Return returnFalse
    EndIf
EndFunction

Bool Function isAprReady() Global
	Return isDependencyReady("Apropos2.esp") 
EndFunction

Bool Function isDDintegrationReady() Global
	Return isDependencyReady("Devious Devices - Integration.esm") 
EndFunction

Bool Function isZaZReady() Global
	Return isDependencyReady("ZaZAnimationPack.esm") 
EndFunction

bool Function isSLReady() global
	return isDependencyReady("SexLab.esm")
EndFunction

Bool Function isSLAReady() Global
	Return isDependencyReady("SexLabAroused.esm") 
EndFunction


Bool Function isDependencyReady(String modname) Global
	Return Game.GetModbyName(modname) != 255
EndFunction

Function RandomEmotion(Actor PlayerRef) Global

	Int Order = Utility.RandomInt(1, 80)
If Order == 1 || Order == 33
	LookLeft(70,PlayerRef)
	LookRight(70, PlayerRef)
	Elseif Order == 2 || Order == 34 || Order == 61
	LookLeft(50,PlayerRef)
	LookRight(50,PlayerRef)
	Elseif Order == 3 || Order == 35 || Order == 62
	Angry(PlayerRef)
	Elseif Order == 4 || Order == 36 || Order == 63
	Frown(50,PlayerRef)
	Elseif Order == 5 || Order == 37 || Order == 64
	Smile(25,PlayerRef)
	Elseif Order == 6 || Order == 38 || Order == 65
	Smile(60,PlayerRef)
	elseif Order == 7 || Order == 39 || Order == 66
	Puzzled(25,PlayerRef)
	Elseif Order == 8 || Order == 40 || Order == 67
	BrowsUpSmile(45,PlayerRef)
	Elseif Order == 9 || Order == 47 || Order == 68
	BrowsUpSmile(30,PlayerRef)
	Elseif Order == 10 || Order == 41 || Order == 69
	LookLeft(70,PlayerRef)
	Elseif Order == 11 || Order == 42 || Order == 70
	LookRight(70,PlayerRef)
	Elseif Order == 12 || Order == 43 || Order == 71
	Squint(PlayerRef)
	Elseif Order == 13 || Order == 44 || Order == 72
	Smile(50,PlayerRef)
	Elseif Order == 14 || Order == 45 || Order == 73
	Disgust(60,PlayerRef)
	Elseif Order == 15 || Order == 46 || Order == 74
	Frown(80,PlayerRef)
	Elseif Order == 16
	Yawn(PlayerRef)
	Elseif Order == 17 
	LookDown(40,PlayerRef)
	Elseif Order == 18 || Order == 48 || Order == 75
	BrowsUp(PlayerRef)
	Elseif Order == 19 || Order == 49
	Thinking(15,PlayerRef)
	Elseif Order == 20 || Order == 50 || Order == 80
	Thinking(50,PlayerRef)
	Elseif Order == 21 || Order == 51
	Thinking(30,PlayerRef)
	Elseif Order == 22 || Order == 52
	BrowsUpSmile(40,PlayerRef)
	Elseif Order == 23 || Order == 53 || Order == 76
	BrowsUpSmile(15,PlayerRef)
	elseif Order == 24 || Order == 54
	Disgust(25,PlayerRef)
	elseif Order == 25 || Order == 55
	Puzzled(50,PlayerRef)
	elseif Order == 26 || Order == 56
	Happy(40,PlayerRef)
	elseif Order == 27 || Order == 77
	Happy(25,PlayerRef)
	elseif Order == 28 || Order == 59
	Happy(60,PlayerRef)
	elseif Order == 29 || Order == 58
	Lookleft(50,PlayerRef)
	elseif Order == 30 || Order == 60
	Squint(PlayerRef)
	Lookleft(25,PlayerRef) || Order == 78
	Elseif Order == 31
	Smile(15,PlayerRef)
	Elseif Order == 32 || Order == 79
	Smile(35,PlayerRef)
	Endif
EndFunction

Function LookLeft(int n, Actor PlayerRef) Global
	int i = 0
	
	while i < n
	MfgConsoleFunc.SetModifier(PlayerRef, 9,i)
	i = i + 5
	if (i >n)
	i = n
	Endif
	Utility.Wait(0.01)
	endwhile
	
	Utility.Wait(0.8)
	
	while i > 0
	MfgConsoleFunc.SetModifier(PlayerRef, 9,i)
	i = i - 5
	if (i < 0)
	i = 0
	Endif
	Utility.Wait(0.01)
	endwhile
endfunction
	
	
Function LookRight(int n, Actor PlayerRef) Global
	
	int i = 0
	
	while i < n
	MfgConsoleFunc.SetModifier(PlayerRef, 10,i)
	i = i + 5
	if (i > n)
	i = n
	Endif
	Utility.Wait(0.05)
	endwhile
	
	Utility.Wait(1.5)
	
	while i > 0
	MfgConsoleFunc.SetModifier(PlayerRef, 10,i)
	i = i - 5
	if (i < 0)
	i = 0
	Endif
	Utility.Wait(0.01)
	endwhile
endfunction
	
	
Function Squint(Actor PlayerRef) Global
	
	int i = 0
	
	while i < 55
	MfgConsoleFunc.SetModifier(PlayerRef, 12, i)
	MfgConsoleFunc.SetModifier(PlayerRef, 13, i)
	i = i + 5
	if (i >55)
	i = 55
	Endif
	Utility.Wait(0.05)
	endwhile
	
	Utility.Wait(3.5)
	
	while i > 0
	MfgConsoleFunc.SetModifier(PlayerRef, 12, i)
	MfgConsoleFunc.SetModifier(PlayerRef, 13, i)
	i = i - 5
	if (i < 0)
	i = 0
	Endif
	Utility.Wait(0.01)
	endwhile
	endfunction
	
Function Frown(int n, Actor PlayerRef) Global
	
	int i = 0
	
	while i < n
	MfgConsoleFunc.SetModifier(PlayerRef, 2, i)
	MfgConsoleFunc.SetModifier(PlayerRef, 3, i)
	i = i + 5
	if (i > n)
	i = n
	Endif
	Utility.Wait(0.05)
	endwhile
	
	Utility.Wait(2.5)
	
	while i > 0
	MfgConsoleFunc.SetModifier(PlayerRef, 2, i)
	MfgConsoleFunc.SetModifier(PlayerRef, 3, i)
	i = i - 5
	if (i < 0)
	i = 0
	Endif
	Utility.Wait(0.01)
	endwhile
endfunction
	
Function Smile(int n, Actor PlayerRef) Global
	
	int i = 0
	
	while i < n
	MfgConsoleFunc.SetPhoneMe(PlayerRef, 4, i)
	i = i + 5
	if (i >n)
	i = n
	Endif
	Utility.Wait(0.05)
	endwhile
	
	Utility.Wait(3)
	
	while i > 0
	MfgConsoleFunc.SetPhoneMe(PlayerRef, 4, i)
	i = i - 5
	if (i < 0)
	i = 0
	Endif
	Utility.Wait(0.01)
	endwhile
endfunction
	
Function Angry(Actor PlayerRef) Global
	
	int i = 0
	
	while i < 70
	MfgConsoleFunc.SetModifier(PlayerRef, 2, i)
	MfgConsoleFunc.SetModifier(PlayerRef, 3, i)
	MfgConsoleFunc.SetModifier(PlayerRef, 9,i)
	i = i + 5
	if (i > 70)
	i = 70
	Endif
	Utility.Wait(0.05)
	endwhile
	
	Utility.Wait(1.5)
	
	while i > 0
	MfgConsoleFunc.SetModifier(PlayerRef, 2, i)
	MfgConsoleFunc.SetModifier(PlayerRef, 3, i)
	MfgConsoleFunc.SetModifier(PlayerRef, 9,i)
	i = i - 2
	if (i < 0)
	i = 0
	Endif
	Utility.Wait(0.01)
	endwhile
endfunction
	
Function Thinking(int n, Actor PlayerRef) Global
	
	int i = 0
	
	while i < n
	MfgConsoleFunc.SetModifier(PlayerRef, 7, i)
	MfgConsoleFunc.SetPhoneMe(PlayerRef, 7,i)
	i = i + 5
	if (i > n)
	i = n
	Endif
	Utility.Wait(0.05)
	endwhile
	
	Utility.Wait(2.5)
	
	while i > 0
	MfgConsoleFunc.SetModifier(PlayerRef, 7, i)
	MfgConsoleFunc.SetPhoneMe(PlayerRef, 7,i)
	i = i - 5
	if (i < 0)
	i = 0
	Endif
	Utility.Wait(0.01)
	endwhile
endfunction
	 
Function Yawn(Actor PlayerRef) Global
	
	int i = 0
	
	while i < 75
	MfgConsoleFunc.SetModifier(PlayerRef, 0, i)
	MfgConsoleFunc.SetModifier(PlayerRef, 1, i)
	MfgConsoleFunc.SetModifier(PlayerRef, 6, i)
	MfgConsoleFunc.SetModifier(PlayerRef, 7, i)
	MfgConsoleFunc.SetPhoneMe(PlayerRef, 1,i)
	i = i + 3
	if (i > 75)
	i = 75
	Endif
	Utility.Wait(0.000001)
	endwhile
	
	int yawnduration = Utility.RandomInt(1,3)
	if yawnduration == 1
	Utility.Wait(0.7)
	elseif yawnduration == 2
	Utility.Wait(1)
	elseif yawnduration == 2
	Utility.Wait(1.5)
	endif
	
	while i > 0
	MfgConsoleFunc.SetModifier(PlayerRef, 0, i)
	MfgConsoleFunc.SetModifier(PlayerRef, 1, i)
	MfgConsoleFunc.SetModifier(PlayerRef, 6, i)
	MfgConsoleFunc.SetModifier(PlayerRef, 7, i)
	MfgConsoleFunc.SetPhoneMe(PlayerRef, 1,i)
	i = i - 3
	if (i < 0)
	i = 0
	Endif
	Utility.Wait(0.0000001)
	endwhile
endfunction
	
Function LookDown(int n, Actor PlayerRef) Global
	
	int i = 0
	
	while i < n
	MfgConsoleFunc.SetModifier(PlayerRef, 8,i)
	i = i + 5
	if (i >n)
	i = n
	Endif
	Utility.Wait(0.05)
	endwhile
	
	Utility.Wait(1.5)
	
	while i > 0
	MfgConsoleFunc.SetModifier(PlayerRef, 8,i)
	i = i - 5
	if (i < 0)
	i = 0
	Endif
	Utility.Wait(0.01)
	endwhile
endfunction
	
Function BrowsUp( Actor PlayerRef) Global
	
	int i = 0
	
	while i < 75
	MfgConsoleFunc.SetModifier(PlayerRef, 6, i)
	MfgConsoleFunc.SetModifier(PlayerRef, 7, i)
	i = i + 10
	if (i > 75)
	i = 75
	Endif
	Utility.Wait(0.05)
	endwhile
	
	Utility.Wait(2)
	
	while i > 0
	MfgConsoleFunc.SetModifier(PlayerRef, 6, i)
	MfgConsoleFunc.SetModifier(PlayerRef, 7, i)
	i = i - 5
	if (i < 0)
	i = 0
	Endif
	Utility.Wait(0.01)
	endwhile
endfunction
	
	
Function BrowsUpSmile(int n, Actor PlayerRef) Global
	
	int i = 0
	
	while i < n
	MfgConsoleFunc.SetModifier(PlayerRef, 6, i)
	MfgConsoleFunc.SetModifier(PlayerRef, 7, i)
	MfgConsoleFunc.SetPhoneMe(PlayerRef, 5, i)
	
	i = i + 5
	if (i > n)
	i = n
	Endif
	Utility.Wait(0.05)
	endwhile
	
	Utility.Wait(1.5)
	
	while i > 0
	MfgConsoleFunc.SetModifier(PlayerRef, 6, i)
	MfgConsoleFunc.SetModifier(PlayerRef, 7, i)
	MfgConsoleFunc.SetPhoneMe(PlayerRef, 5, i)
	
	i = i - 5
	if (i < 0)
	i = 0
	Endif
	Utility.Wait(0.01)
	endwhile
endfunction
	
	
Function Disgust(int n, Actor PlayerRef) Global
	int i = 0
	
	while i < n
	PlayerRef.SetExpressionOverride(14,i)
	
	i = i + 5
	if (i > n)
	i = n
	Endif
	Utility.Wait(0.05)
	endwhile
	
	Utility.Wait(1.5)
	
	while i > 0
	PlayerRef.SetExpressionOverride(14,i)
	
	i = i - 5
	if (i < 0)
	i = 0
	Endif
	Utility.Wait(0.01)
	endwhile
	PlayerRef.ClearExpressionOverride()
endfunction
	
Function Happy(int n, Actor PlayerRef) Global
	
	int i = 0
	
	while i < n
	PlayerRef.SetExpressionOverride(10,i)
	
	i = i + 5
	if (i > n)
	i = n
	Endif
	Utility.Wait(0.05)
	endwhile
	
	Utility.Wait(4.5)
	
	while i > 0
	PlayerRef.SetExpressionOverride(10,i)
	
	i = i - 5
	if (i < 0)
	i = 0
	Endif
	Utility.Wait(0.01)
	endwhile
	PlayerRef.ClearExpressionOverride()
endfunction

Function Inhale(int n, int j, Actor PlayerRef) Global
	int i = n
   
   while i <  j
   MfgConsoleFunc.SetPhoneme(PlayerRef, 0,i)
   i = i + 3
   If (i >j)
   i = j
   Endif
   Utility.Wait(0.04)
   endwhile
EndFunction
 
Function Exhale(int n, int j, Actor PlayerRef) Global

	int i = n
   
   while i > j
  	 MfgConsoleFunc.SetPhoneme(PlayerRef, 0, i)
  	 i = i - 3
   	If (i < j)
   		i = j
   	Endif
  	 Utility.Wait(0.02)
   endwhile
EndFunction

Function Puzzled(int n, Actor PlayerRef) Global
	
	int i = 0
	
	while i < n
	PlayerRef.SetExpressionOverride(13,i)
	
	i = i + 5
	if (i > n)
	i = n
	Endif
	Utility.Wait(0.05)
	endwhile
	
	Utility.Wait(3.5)
	
	while i > 0
	PlayerRef.SetExpressionOverride(13,i)
	
	i = i - 5
	if (i < 0)
	i = 0
	Endif
	Utility.Wait(0.01)
	endwhile
	PlayerRef.ClearExpressionOverride()
endfunction

; Keep It Clean
MagicEffect function GetKICDirtinessStage2Effect() global
    return Game.GetFormFromFile(0xFBDBA, "Keep It Clean.esp") as MagicEffect
endFunction

MagicEffect function GetKICDirtinessStage3Effect() global
    return Game.GetFormFromFile(0xFBDB6, "Keep It Clean.esp") as MagicEffect
endFunction

MagicEffect function GetKICDirtinessStage4Effect() global
    return Game.GetFormFromFile(0x1564EE, "Keep It Clean.esp") as MagicEffect
endFunction

; Bathing In Skyrim
MagicEffect function GetBISDirtinessStage2Effect() global
    return Game.GetFormFromFile(0xE55C, "Bathing in Skyrim - Main.esp") as MagicEffect
endFunction

MagicEffect function GetBISDirtinessStage3Effect() global
    return Game.GetFormFromFile(0xE55D, "Bathing in Skyrim - Main.esp") as MagicEffect
endFunction

MagicEffect function GetBISDirtinessStage4Effect() global
    return Game.GetFormFromFile(0xE55E, "Bathing in Skyrim - Main.esp") as MagicEffect
endFunction

; Dirt and Blood
MagicEffect function GetDABDirtinessStage2Effect() global
    return Game.GetFormFromFile(0x80D, "Dirt and Blood - Dynamic Visuals.esp") as MagicEffect
endFunction

MagicEffect function GetDABDirtinessStage3Effect() global
    return Game.GetFormFromFile(0x80E, "Dirt and Blood - Dynamic Visuals.esp") as MagicEffect
endFunction

MagicEffect function GetDABDirtinessStage4Effect() global
    return Game.GetFormFromFile(0x80F, "Dirt and Blood - Dynamic Visuals.esp") as MagicEffect
endFunction

MagicEffect function GetDABDirtinessStage5Effect() global
    return Game.GetFormFromFile(0x83B, "Dirt and Blood - Dynamic Visuals.esp") as MagicEffect
endFunction

MagicEffect function GetDABBloodinessStage2Effect() global
    return Game.GetFormFromFile(0x810, "Dirt and Blood - Dynamic Visuals.esp") as MagicEffect
endFunction

MagicEffect function GetDABBloodinessStage3Effect() global
    return Game.GetFormFromFile(0x811, "Dirt and Blood - Dynamic Visuals.esp") as MagicEffect
endFunction

MagicEffect function GetDABBloodinessStage4Effect() global
    return Game.GetFormFromFile(0x812, "Dirt and Blood - Dynamic Visuals.esp") as MagicEffect
endFunction

MagicEffect function GetDABBloodinessStage5Effect() global
    return Game.GetFormFromFile(0x83A, "Dirt and Blood - Dynamic Visuals.esp") as MagicEffect
endFunction

Function resetMFG(Actor ac) global
	ac.ClearExpressionOverride()
	MfgConsoleFunc.ResetPhonemeModifier(ac)
endfunction