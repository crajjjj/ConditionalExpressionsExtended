Scriptname CondiExp_util Hidden

Import Debug
Import mfgconsolefunc
import Utility
import Math

String Function GetModName() Global
	return "Conditional Expressions Extended"
EndFunction

;SemVer support
Int Function GetVersion() Global
    Return 10205
    ; 1.0.0   -> 10000
    ; 1.1.0   -> 10100
    ; 1.1.1  -> 10101
    ; 1.61  -> 16100
    ; 10.61.20 -> 106120 
EndFunction

String Function GetVersionString() Global
    Return "1.2.5"
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

;Aah 0    BigAah 1
;BMP 2    ChjSh 3
;DST 4    Eee 5
;Eh 6     FV 7
;i 8      k 9
;N 10     Oh 11
;OohQ 12  R 13
;Th 14    W 15
;https://steamcommunity.com/sharedfiles/filedetails/?l=english&id=187155077
Function SmoothSetPhoneme(Actor act, Int number, Int str_dest) global
	While (!SetModifier(act, 14, 0))
		Wait(5.0)
	EndWhile
	Int t1 = GetPhoneme(act, number)
	Int t2
	Int speed = 3
	While (t1 != str_dest)
		t2 = (str_dest - t1) / Abs(str_dest - t1) as Int
		t1 = t1 + t2 * speed
		If ((str_dest - t1) / t2 < 0)
			t1 = str_dest
		EndIf
		SetPhoneme(act, number, t1)
	EndWhile
EndFunction

;mfg modifier
;BlinkL 0
;BlinkR 1
;BrowDownL 2
;BrownDownR 3
;BrowInL 4
;BrowInR 5
;BrowUpL 6
;BrowUpR 7
;LookDown 8
;LookLeft 9
;LookRight 10
;LookUp 11
;SquintL 12
;SquintR 13
;set -1 to number2 if not needed 
Function SmoothSetModifier(Actor act, Int number1, Int number2, Int str_dest) global
	Int speed_blink_min = 25
	Int speed_blink_max = 60
	Int speed_eye_move_min = 5
	Int speed_eye_move_max = 15
	Int speed_blink = 0
	While (!SetModifier(act, 14, 0))
		Wait(5.0)
	EndWhile
	Int t1 = GetModifier(act, number1)
	Int t2
	Int t3
	Int speed
	If (number1 < 2)
		If (str_dest > 0)
			speed_blink = RandomInt(speed_blink_min, speed_blink_max)
			speed = speed_blink
		Else
			If (speed_blink > 0)
				speed = Round(speed_blink * 0.5)
			Else
				speed = Round(RandomInt(speed_blink_min, speed_blink_max) * 0.5)
			EndIf
		EndIf
	ElseIf (number1 > 7 && number1 < 12)
		speed = RandomInt(speed_eye_move_min, speed_eye_move_max)
	Else
		speed = 3
	EndIf
	While (t1 != str_dest)
		t2 = (str_dest - t1) / Abs(str_dest - t1) as Int
		t1 = t1 + t2 * speed
		If ((str_dest - t1) / t2 < 0)
			t1 = str_dest
		EndIf
		If (!(number2 < 0 || number2 > 13))
			t3 = RandomInt(0, 1)
			SetModifier(act, number1 * t3 + number2 * (1 - t3), t1)
			SetModifier(act, number2 * t3 + number1 * (1 - t3), t1)
		Else
			SetModifier(act, number1, t1)
		EndIf
	EndWhile
EndFunction

;mfg expression
;anger 0
;fear 1
;happy 2
;sad 3
;surprise 4
;puzzled 5
;disgust 6
;neutral 7
Function SmoothSetExpression(Actor act, Int number, Int exp_dest, int exp_value ) global
	While (!SetModifier(act, 14, 0))
		Wait(5.0)
	EndWhile
	Int t2
	Int speed = 2
	While (exp_value != exp_dest)
		t2 = (exp_dest - exp_value) / Abs(exp_dest - exp_value) as Int
		exp_value = exp_value + t2 * speed
		If ((exp_dest - exp_value) / t2 < 0)
			exp_value = exp_dest
		EndIf
		act.SetExpressionOverride(number, exp_value)
	EndWhile
EndFunction

Int Function Round(Float f) global
	Return Floor(f + 0.5)
EndFunction

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
	MfgConsoleFunc.ResetPhonemeModifier(ac)
	ac.ClearExpressionOverride()
endfunction

Function resetMFGSmooth(Actor ac) global
	;blinks
	SmoothSetModifier(ac,0,1,0)
	
	;brows
	SmoothSetModifier(ac,2,3,0)
	SmoothSetModifier(ac,4,5,0)
	SmoothSetModifier(ac,6,7,0)

	;eyes
	SmoothSetModifier(ac,8,-1,0)
	SmoothSetModifier(ac,9,-1,0)
	SmoothSetModifier(ac,10,-1,0)
	SmoothSetModifier(ac,11,-1,0)

	;squints
	SmoothSetModifier(ac,12,13,0)
	
	;mouth
	int p = 0
	while (p <= 15)
		SmoothSetPhoneme(ac, p, 0)
		p = p + 1
	endwhile
	;expressions
	SmoothSetExpression(ac, GetExpressionID(ac), 0, GetExpressionValue(ac))
endfunction