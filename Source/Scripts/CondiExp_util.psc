Scriptname CondiExp_util Hidden

Import Debug
Import CondiExp_util
Import CondiExp_log
import Utility
import Math

String Function GetModName() Global
	return "Conditional Expressions Extended"
EndFunction

;SemVer support
Int Function GetVersion() Global
    Return 106000
	;	0.00.000
    ; 1.0.0   -> 100000
    ; 1.1.0   -> 101000
    ; 1.1.1  -> 101001
    ; 1.61  -> 161000
    ; 10.61.20 -> 1061020
EndFunction

String Function GetVersionString() Global
    Return "1.6.0"
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

;do not use. Breaks LE
;Bool Function isDependencyReady(String modname) Global
	;Return Game.IsPluginInstalled(modname)
;EndFunction

Bool Function isDependencyReady(String modname) Global
	int index = Game.GetModByName(modname)
	if index == 255 || index == -1
		return false
	else
		return true
	endif
EndFunction

int Function getSmoothDelay() global
	return 20
endfunction
int Function getSmoothSpeed() global
	return 5
endfunction
int Function getHardDelay() global
	return 0
endfunction
int Function getHardSpeed() global
	return 100
endfunction


Function SetPhoneme(Actor act, Int number, Int str_dest, float modifier = 1.0) global
	str_dest = (str_dest * modifier) as Int
	PyramidUtils.SetPhonemeModifierSmooth(act, 0, number, -1, str_dest, getHardSpeed(), getHardDelay())
EndFunction
Function SetModifier(Actor act, Int mod1, Int str_dest, float strModifier = 1.0) global
	str_dest = (str_dest * strModifier) as Int
	PyramidUtils.SetPhonemeModifierSmooth(act, 1, mod1, -1, str_dest, getHardSpeed(), getHardDelay())
EndFunction

; get phoneme/modifier/expression
int function GetPhoneme(Actor act, int id) global
	return PyramidUtils.GetPhonemeValue(act, id)
endfunction
int function GetModifier(Actor act, int id) global
	return PyramidUtils.GetModifierValue(act, id)
endfunction

; return expression value which is enabled. (enabled only one at a time.)
int function GetExpressionValue(Actor act) global
	return PyramidUtils.GetExpressionValue(act)
endfunction

; return expression ID which is enabled.
int function GetExpressionID(Actor act) global
	return PyramidUtils.GetExpressionId(act)
endfunction
Function SmoothSetModifier(Actor act, Int mod1, Int mod2, Int str_dest, float strModifier = 1.0) global
	str_dest = (str_dest * strModifier) as Int
	PyramidUtils.SetPhonemeModifierSmooth(act, 1, mod1, mod2, str_dest, getSmoothSpeed(), getSmoothDelay())
EndFunction
Function SmoothSetPhoneme(Actor act, Int number, Int str_dest, float modifier = 1.0) global
	str_dest = (str_dest * modifier) as Int
	PyramidUtils.SetPhonemeModifierSmooth(act, 0, number, -1, str_dest, getSmoothSpeed(), getSmoothDelay())
EndFunction

Function ApplyExpressionPreset(Actor akActor, float[] expression, bool openMouth, int exprPower, float exprStrModifier, float modStrModifier, float phStrModifier, float afSpeed, int aiDelay) global
	 PyramidUtils.ApplyExpressionPreset(akActor, expression, openMouth, exprPower, exprStrModifier, modStrModifier, phStrModifier, afSpeed, aiDelay)
EndFunction

Function SmoothSetExpression(Actor act, Int aiMood, Int aiStrength, int aiCurrentStrength, float aiModifier = 1.0) global
	PyramidUtils.SetExpressionSmooth(act, aiMood, aiStrength, aiCurrentStrength, aiModifier, getSmoothSpeed(), getSmoothDelay())
EndFunction

Function resetMFG(Actor act) global
	PyramidUtils.SetPhonemeModifierSmooth(act, -1, 0, -1, 0, 0, 0)
endfunction

Function resetMFGSmooth(Actor ac) global
	PyramidUtils.ResetMFGSmooth(ac, -1, getSmoothSpeed(), getSmoothDelay())
endfunction


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

Int Function RandomNumber(bool isPO3ExtenderInstalled, int a, int b) global
	if isPO3ExtenderInstalled
	  return PO3_SKSEFunctions.GenerateRandomInt(a, b)
	else
	  return Utility.RandomInt(a,b)
	endif
  EndFunction

Function SendSLAModEvent(Int arousalCap, int decrease, String notification, Actor act, String effectName="CondiExpArousalCap") Global
    Int eid = ModEvent.Create("CondiExp_SLAEvent")
	if (eid)
    	ModEvent.PushInt(eid, arousalCap)
		ModEvent.PushInt(eid, decrease)
		ModEvent.PushString(eid, notification)
		ModEvent.PushString(eid, effectName)
		ModEvent.PushForm(eid, act)
   		ModEvent.Send(eid)
	endIf
EndFunction

int[] function ToIntArray(float[] FloatArray) global
	int[] Output = new int[32]
	int i = FloatArray.Length
	while i
		i -= 1
		if i == 30
			Output[i] = FloatArray[i] as int
		else
			Output[i] = (FloatArray[i] * 100.0) as int
		endIf
	endWhile
	return Output
endFunction

float[] function ToFloatArray(int[] IntArray) global
	float[] Output = new float[32]
	int i = IntArray.Length
	while i
		i -= 1
		if i == 30
			Output[i] = IntArray[i] as float
		else
			Output[i] = (IntArray[i] as float) / 100.0
		endIf
	endWhile
	return Output
endFunction


;Aah 0    BigAah 1
;BMP 2    ChjSh 3
;DST 4    Eee 5
;Eh 6     FV 7
;i 8      k 9
;N 10     Oh 11
;OohQ 12  R 13
;Th 14    W 15
;https://steamcommunity.com/sharedfiles/filedetails/?l=english&id=187155077
Function SmoothSetPhonemeOld(Actor act, Int number, Int str_dest, float modifier = 1.0) global
	int safeguard = 0
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
Function SmoothSetModifierOld(Actor act, Int mod1, Int mod2, Int str_dest, float strModifier = 1.0) global
	Int speed_blink_min = 25
	Int speed_blink_max = 60
	Int speed_eye_move_min = 5
	Int speed_eye_move_max = 15
	Int speed_blink = 0
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
		speed = 5
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
;Sets an expression to override any other expression other systems may give this actor.
;7 - Mood Neutral
;0 - Dialogue Anger 8 - Mood Anger 15 - Combat Anger
;1 - Dialogue Fear 9 - Mood Fear 16 - Combat Shout
;2 - Dialogue Happy 10 - Mood Happy
;3 - Dialogue Sad 11 - Mood Sad
;4 - Dialogue Surprise 12 - Mood Surprise
;5 - Dialogue Puzzled 13 - Mood Puzzled
;6 - Dialogue Disgusted 14 - Mood Disgusted
Int Function SmoothSetExpressionOld(Actor act, Int number, Int exp_dest, int exp_value, float modifier = 1.0) global
	Int t2
	Int speed = 4
	exp_dest = (exp_dest * modifier) as Int
	CondiExp_log.log("iter exp_dest" + exp_dest )
	While (exp_value != exp_dest)
		t2 = (exp_dest - exp_value) / Abs(exp_dest - exp_value) as Int
		exp_value = exp_value + t2 * speed
		If ((exp_dest - exp_value) / t2 < 0)
			exp_value = exp_dest
		EndIf
		CondiExp_log.log("iter exp_val" + exp_value )
		act.SetExpressionOverride(number, exp_value)
	EndWhile
	return exp_value
EndFunction

Function resetMFGSmoothOld(Actor ac) global
	;blinks
	SmoothSetModifierOld(ac,0,1,0)
	
	;brows
	SmoothSetModifierOld(ac,2,3,0)
	SmoothSetModifierOld(ac,4,5,0)
	SmoothSetModifierOld(ac,6,7,0)

	;eyes
	SmoothSetModifierOld(ac,8,-1,0)
	SmoothSetModifierOld(ac,9,-1,0)
	SmoothSetModifierOld(ac,10,-1,0)
	SmoothSetModifierOld(ac,11,-1,0)

	;squints
	SmoothSetModifierOld(ac,12,13,0)
	
	;mouth
	int p = 0
	while (p <= 15)
		SmoothSetPhonemeOld(ac, p, 0, 1.0)
		p = p + 1
	endwhile
	;expressions
	SmoothSetExpressionOld(ac, GetExpressionID(ac), 0, GetExpressionValue(ac), 1.0)
endfunction