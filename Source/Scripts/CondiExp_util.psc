Scriptname CondiExp_util Hidden

Import Debug
Import CondiExp_log
import Utility
import Math

String Function GetModName() Global
	return "Conditional Expressions Extended"
EndFunction

;SemVer support
Int Function GetVersion() Global
    Return 201004
	;	0.00.000
    ; 1.0.0   -> 100000
    ; 1.1.0   -> 101000
    ; 1.1.1  -> 101001
    ; 1.61  -> 161000
    ; 10.61.20 -> 1061020
EndFunction

String Function GetVersionString() Global
    Return "2.1.4"
EndFunction

Function ResetQuest(Quest this_quest) Global
	StopQuest(this_quest)
	WaitMenuMode(0.1)
	StartQuest(this_quest)
EndFunction

Function StopQuest(Quest this_quest) Global
	While (this_quest.IsStarting() || this_quest.IsStopping())
		WaitMenuMode(1.0)
	EndWhile
	If (this_quest.IsRunning())
		CondiExp_log.log("Stopping Quest:" + this_quest.GetName())
		this_quest.Reset()
		this_quest.Stop()
	EndIf
EndFunction

Function StartQuest(Quest this_quest) Global
	While (this_quest.IsStarting() || this_quest.IsStopping())
		WaitMenuMode(1.0)
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

Bool Function isDDassetsReady() Global
	Return isDependencyReady("Devious Devices - Assets.esm") 
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

Bool Function isSunHelmReady() Global
	Return isDependencyReady("SunHelmSurvival.esp") 
EndFunction
Bool Function isFrostFallReady() Global
	Return isDependencyReady("Frostfall.esp") 
EndFunction
Bool Function isFrostbiteReady() Global
	Return isDependencyReady("Frostbite.esp") 
EndFunction

Bool Function isSLSurvivalReady() Global
	Return isDependencyReady("SL Survival.esp") 
EndFunction

GlobalVariable Function getCurrentlyBusyVar() Global
	Return Game.GetFormFromFile(0x21381B, "Conditional Expressions.esp") as GlobalVariable
EndFunction

GlobalVariable Function getModSuspendedVar() Global
	Return Game.GetFormFromFile(0x21381E, "Conditional Expressions.esp") as GlobalVariable
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

bool function isInDialogue(Actor act, bool isPC, Actor playerSpeechTargetAct) global
	if !act
		return false
	endif
	if isPC
		if playerSpeechTargetAct
			return true
		else
			return false
		endif
	else
		if MfgConsoleFuncExt.IsInDialogue(act) || act.IsInDialogueWithPlayer() || act == playerSpeechTargetAct
			return true
		endif
	endif
	return false
endfunction

Function RelationshipRankExpression(Actor act, Actor targetActor) Global

	; Validation checks
	if !act || !targetActor || targetActor == act || act.IsDead() || act.IsInCombat()
		return
	endif

	int relationship = act.GetRelationshipRank(targetActor)
	int roll = Utility.RandomInt(1, 100)
	int exprType = 0 ; 0 = Neutral, 1 = Friendly, 2 = Hostile

	; Relationship-weighted expression type
	if relationship >= 2
		If (roll <= 75)
			exprType = 1
		else
			exprType = 0
		EndIf
		;exprType = (roll <= 75) ? 1 : 0 ; 75% Friendly
	elseif relationship <= -2
		If (roll <= 75)
			exprType = 2
		else
			exprType = 0
		EndIf
		;exprType = (roll <= 75) ? 2 : 0 ; 75% Hostile
	else
		exprType = 0 ; Default Neutral
	endif

	int moodID = 0
	int strength = Utility.RandomInt(40, 100)

	; Choose moodID by type
	if exprType == 1
		; FRIENDLY: Happy (4), Surprise (6), Neutral (0)
		int moodRoll = Utility.RandomInt(1, 100)
		if moodRoll <= 60
			moodID = 4 ; Happy
		elseif moodRoll <= 85
			moodID = 6 ; Surprise
		else
			moodID = 0 ; Neutral fallback
		endif

	elseif exprType == 2
		; HOSTILE: Anger (1), Disgust (2), Frown/Sad (5)
		int moodRoll = Utility.RandomInt(1, 100)
		if moodRoll <= 50
			moodID = 1 ; Anger
		elseif moodRoll <= 85
			moodID = 2 ; Disgust
		else
			moodID = 5 ; Sad/Frown
		endif

	else
		; NEUTRAL: Neutral (0), Puzzled (7), Surprise (6)
		int moodRoll = Utility.RandomInt(1, 100)
		if moodRoll <= 60
			moodID = 0 ; Neutral
		elseif moodRoll <= 85
			moodID = 7 ; Puzzled
		else
			moodID = 6 ; Mild Surprise
		endif
	endif
	SmoothSetExpression(act, moodID, strength, 0.75)
EndFunction

Function SetPhoneme(Actor act, Int mod1, Int str_dest, float modifier = 1.0, float speed = 0.75) global
	if !act
		return
	endif
	str_dest = (str_dest * modifier) as Int
	MfgConsoleFuncExt.SetPhoneme(act,mod1,str_dest, speed)
EndFunction

Function SetModifier(Actor act, Int mod1, Int str_dest, float strModifier = 1.0, float speed = 0.75) global
	if !act
		return
	endif
	str_dest = (str_dest * strModifier) as Int
	MfgConsoleFuncExt.SetModifier(act,mod1,str_dest, speed)
EndFunction

Function SetPhonemeFast(Actor act, Int mod1, Int str_dest, float modifier = 1.0) global
	if !act
		return
	endif
	str_dest = (str_dest * modifier) as Int
	MfgConsoleFuncExt.SetPhoneme(act,mod1, str_dest, 0)
EndFunction

Function SetModifierFast(Actor act, Int mod1, Int str_dest, float strModifier = 1.0) global
	if !act
		return
	endif
	str_dest = (str_dest * strModifier) as Int
	MfgConsoleFuncExt.SetModifier(act,mod1,str_dest, 0)
EndFunction

; get phoneme/modifier/expression
int function GetPhoneme(Actor act, int id) global
	return MfgConsoleFunc.GetPhoneme(act, id)
endfunction

int function GetModifier(Actor act, int id) global
	return MfgConsoleFunc.GetModifier(act, id)
endfunction

; return expression value which is enabled. (enabled only one at a time.)
int function GetExpressionValue(Actor act) global
	return MfgConsoleFunc.GetExpressionValue(act)
endfunction

; return expression ID which is enabled.
int function GetExpressionID(Actor act) global
	return MfgConsoleFunc.GetExpressionID(act)
endfunction

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
	if !act
		return
	endif
	str_dest = (str_dest * strModifier) as Int
	MfgConsoleFuncExt.SetModifier(act,mod1,str_dest)
	if mod2!= -1
		MfgConsoleFuncExt.SetModifier(act,mod2,str_dest)
	endif
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
Function SmoothSetPhoneme(Actor act, Int mod1, Int str_dest, float modifier = 1.0) global
	if !act
		return
	endif
	str_dest = (str_dest * modifier) as Int
	MfgConsoleFuncExt.SetPhoneme(act,mod1,str_dest)
EndFunction

Function ApplyExpressionPreset(Actor act, float[] expression, bool openMouth, int exprPower, float exprStrModifier, float modStrModifier, float phStrModifier, float speed = 0.75) global
	if !act
		return
	endif
	MfgConsoleFuncExt.ApplyExpressionPresetSmooth(act, expression, openMouth, exprPower, exprStrModifier, modStrModifier, phStrModifier, speed) 
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
Function SmoothSetExpression(Actor act, Int aiMood, Int aiStrength, float aiModifier = 1.0) global
	if !act
		return
	endif
	aiStrength = (aiStrength * aiModifier) as Int
	MfgConsoleFuncExt.SetExpression(act, aiMood, aiStrength)
EndFunction

bool Function isInDialogueMFG(Actor act) global
	if !act
		return false
	endif
	return MfgConsoleFuncExt.isInDialogue(act)
endfunction

Function resetMFG(Actor act) global
	if !act
		return
	endif
	MfgConsoleFunc.ResetPhonemeModifier(act)
endfunction

Function resetMFGSmooth(Actor act) global
	if !act 
		return
	endif
	if !isInDialogue(act, false, MfgConsoleFuncExt.GetPlayerSpeechTarget())
		MfgConsoleFuncExt.ResetMFG(act)
	endif
endfunction

Function resetPhonemesSmooth(Actor act) global
	if !act
		return
	endif
	MfgConsoleFuncExt.ResetPhonemes(act)
endfunction

Function resetModifiersSmooth(Actor act) global
	if !act
		return
	endif
	MfgConsoleFuncExt.ResetModifiers(act)
endfunction

Function resetExpressionsSmooth(Actor act) global
	if !act
		return
	endif
	;neutral expression
	MfgConsoleFuncExt.SetExpression(act, 7, 100)
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
; Bathing In Skyrim Revised
MagicEffect function GetBISRDirtinessStage2Effect() global
    return Game.GetFormFromFile(0x27, "Bathing in Skyrim.esp") as MagicEffect
endFunction

MagicEffect function GetBISRDirtinessStage3Effect() global
    return Game.GetFormFromFile(0x28, "Bathing in Skyrim.esp") as MagicEffect
endFunction

MagicEffect function GetBISRDirtinessStage4Effect() global
    return Game.GetFormFromFile(0x29, "Bathing in Skyrim.esp") as MagicEffect
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