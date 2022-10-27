Scriptname CondiExp_util Hidden

Import Debug
Import CondiExp_util
Import CondiExp_log
Import mfgconsolefunc
import Utility
import Math

String Function GetModName() Global
	return "Conditional Expressions Extended"
EndFunction

;SemVer support
Int Function GetVersion() Global
    Return 103012
    ; 1.0.0   -> 10000
    ; 1.1.0   -> 10100
    ; 1.1.1  -> 10101
    ; 1.61  -> 16100
    ; 10.61.20 -> 106120 
EndFunction

String Function GetVersionString() Global
    Return "1.3.12"
EndFunction

Function ResetQuest(Quest this_quest) Global
	StopQuest(this_quest)
	StartQuest(this_quest)
EndFunction

Function StopQuest(Quest this_quest) Global
	While (this_quest.IsStarting() || this_quest.IsStopping())
		Wait(1.0)
	EndWhile
	If (this_quest.IsRunning())
		CondiExp_log.log("Stopping Quest:" + this_quest.GetName())
		this_quest.Reset()
		this_quest.Stop()
	EndIf
EndFunction

Function StartQuest(Quest this_quest) Global
	While (this_quest.IsStarting() || this_quest.IsStopping())
		Wait(1.0)
	EndWhile
	If (this_quest.IsStopped())
		CondiExp_log.log("Starting Quest:" + this_quest.GetName())
		this_quest.Start()
	EndIf
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

Bool Function isToysReady() Global
	Return isDependencyReady("Toys.esm")
EndFunction

Bool Function isDependencyReady(String modname) Global
	Return Game.IsPluginInstalled(modname)
EndFunction



;Aah 0    BigAah 1
;BMP 2    ChjSh 3
;DST 4    Eee 5
;Eh 6     FV 7
;i 8      k 9
;N 10     Oh 11
;OohQ 12  R 13
;Th 14    W 15
;https://steamcommunity.com/sharedfiles/filedetails/?l=english&id=187155077
Function SmoothSetPhoneme(Actor act, Int number, Int str_dest, float modifier = 1.0) global
	While (!SetModifier(act, 14, 0))
		Wait(5.0)
	EndWhile
	Int t1 = GetPhoneme(act, number)
	Int t2
	Int speed = 3
	str_dest = (str_dest * modifier) as Int
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

;for changing 2 values at the same time (e.g. eyes squint)
;set -1 to mod2 if not needed 
Function SmoothSetModifier(Actor act, Int mod1, Int mod2, Int str_dest, float strModifier = 1.0) global
	Int speed_blink_min = 25
	Int speed_blink_max = 60
	Int speed_eye_move_min = 5
	Int speed_eye_move_max = 15
	Int speed_blink = 0

	int safeguard = 0
	While (!SetModifier(act, 14, 0) && safeguard <= 5)
		Wait(5.0)
		safeguard = safeguard + 1
	EndWhile
	Int t1 = GetModifier(act, mod1)
	Int t2
	Int t3
	Int speed
	str_dest = (str_dest * strModifier) as Int
	If (mod1 < 2)
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
	ElseIf (mod1 > 7 && mod1 < 12)
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
		If (!(mod2 < 0 || mod2 > 13))
			t3 = RandomInt(0, 1)
			SetModifier(act, mod1 * t3 + mod2 * (1 - t3), t1)
			SetModifier(act, mod2 * t3 + mod1 * (1 - t3), t1)
		Else
			SetModifier(act, mod1, t1)
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
Int Function SmoothSetExpression(Actor act, Int number, Int exp_dest, int exp_value, float modifier = 1.0) global
	int safeguard = 0
	While (!SetModifier(act, 14, 0) && safeguard <= 5)
		Wait(5.0)
		safeguard = safeguard + 1
	EndWhile
	Int t2
	Int speed = 2
	exp_dest = (exp_dest * modifier) as Int
	While (exp_value != exp_dest)
		t2 = (exp_dest - exp_value) / Abs(exp_dest - exp_value) as Int
		exp_value = exp_value + t2 * speed
		If ((exp_dest - exp_value) / t2 < 0)
			exp_value = exp_dest
		EndIf
		act.SetExpressionOverride(number, exp_value)
	EndWhile
	return exp_value
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

Int Function RandomNumber(bool isPO3ExtenderInstalled, int a, int b) global
	if isPO3ExtenderInstalled
	  return PO3_SKSEFunctions.GenerateRandomInt(a, b)
	else
	  Utility.RandomInt(a,b)
	endif
  EndFunction