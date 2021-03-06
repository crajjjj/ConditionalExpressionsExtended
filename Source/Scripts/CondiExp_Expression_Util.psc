Scriptname CondiExp_Expression_Util Hidden

Import Debug
Import mfgconsolefunc
import Utility
import Math
import CondiExp_log
import CondiExp_util

Function PlayArousedExpression(Actor act, int aroused, condiexp_MCM config) global
	Int power = 20 + aroused
	if power > 100
		power = 100
	endif
	int i = 0
	
	;random skip 20%
	Int randomSkip = Utility.RandomInt(1, 10)
	if randomSkip > 2
		int topMargin = 3
		if aroused > 50 &&  aroused <= 80
			topMargin = 5
		else
			topMargin = 7
		endif 
		Int randomEffect = Utility.RandomInt(1, topMargin)
		verbose(act, "Aroused: Arousal: " + aroused + ".Effect: " + randomEffect, config.Condiexp_Verbose.GetValueInt())
		_arousedVariants(randomEffect, act, power, config)
	endif

	Int randomLook = Utility.RandomInt(1, 10)
	If randomLook == 2
		LookLeft(50, act)
	ElseIf randomLook == 4
		LookRight(50, act)
	ElseIf randomLook == 8
		LookDown(50, act)
	endif
EndFunction

Function PlayTraumaExpression(Actor act, int trauma, condiexp_MCM config) global
	Int power = 20 + trauma * 10
	if power > 100
		power = 100
	endif
	
	;random skip 20%
	Int randomSkip = Utility.RandomInt(1, 10)
	if randomSkip > 2
		int topMargin = 3
		int bottomMargin = 1
		if trauma > 4 && trauma <= 7
			topMargin = 6
		else
			bottomMargin = 4
			topMargin = 10
		endif 
		Int randomEffect = Utility.RandomInt(bottomMargin, topMargin)
		verbose(act,"Trauma: Trauma: " + trauma + ".Effect: " + randomEffect, config.Condiexp_Verbose.GetValueInt())
		_traumaVariants(randomEffect, act, power, config)
	else
		verbose(act,"Trauma: skipping. Trauma: " + trauma, config.Condiexp_Verbose.GetValueInt())
	endif
	Utility.Wait(1)

	Int randomLook = Utility.RandomInt(1, 10)
	If randomLook == 2
		LookLeft(50, act)
	ElseIf randomLook == 4
		LookRight(50, act)
	ElseIf randomLook == 8
		LookDown(50, act)
	endif 
	Utility.Wait(5)
EndFunction

Function PlayDirtyExpression(Actor act, int dirty, condiexp_MCM config) global
	Int power = 100
	;random skip 33%
	Int randomSkip = Utility.RandomInt(1, 10)
	if randomSkip > 3
		verbose(act, "Dirty: playing effect: " + dirty, config.Condiexp_Verbose.GetValueInt())
    	_dirtyVariants(dirty, act, power, config)
	else
		verbose(act, "Dirty: skipping effect: " + dirty, config.Condiexp_Verbose.GetValueInt())
	endif

	Int randomLook = Utility.RandomInt(1, 10)
	If randomLook == 2
		LookLeft(50, act)
	ElseIf randomLook == 4
		LookRight(50, act)
	ElseIf randomLook == 8
		LookDown(50, act)
	endif
EndFunction

Function Breathe(Actor act, bool final = true) global
	If act.IsDead() && act.IsSwimming()
		return
	Endif
	Inhale(33,73, act)
	Exhale(73,33, act)
	if final
		Exhale(33,0,act)
	endif
EndFunction

Function PlayPainExpression(Actor act, condiexp_MCM config) global
    Int Order = Utility.RandomInt(1, 4)
	
    verbose(act,"Pain: Effect: " + Order, config.Condiexp_Verbose.GetValueInt())
    If Order == 1
        act.SetExpressionOverride(9,60)
        MfgConsoleFunc.SetModifier(act,2,52)
        MfgConsoleFunc.SetModifier(act,3,52)
        MfgConsoleFunc.SetPhoneMe(act,5,30)
    elseif Order == 2
        MfgConsoleFunc.SetModifier(act,4,115)
        MfgConsoleFunc.SetModifier(act,5,115)
        MfgConsoleFunc.SetPhoneMe(act,4,30)
        act.SetExpressionOverride(3,50)
    elseif Order == 3
        MfgConsoleFunc.SetModifier(act,4,115)
        MfgConsoleFunc.SetModifier(act,5,115)
        MfgConsoleFunc.SetModifier(act,0,70)
        MfgConsoleFunc.SetPhoneMe(act,4,30)
    elseif Order == 4
        MfgConsoleFunc.SetModifier(act,4,115)
        MfgConsoleFunc.SetModifier(act,5,115)
        MfgConsoleFunc.SetModifier(act,1,70)
        MfgConsoleFunc.SetPhoneMe(act,4,30)
    Endif
EndFunction

Function PlayRandomExpression(Actor act, condiexp_MCM config) global
	verbose(act,"Random emotion", config.Condiexp_Verbose.GetValueInt())
	RandomEmotion(act, config)
EndFunction

; Sets an expression to override any other expression other systems may give this actor.
;							7 - Mood Neutral
; 0 - Dialogue Anger		8 - Mood Anger		15 - Combat Anger
; 1 - Dialogue Fear			9 - Mood Fear		16 - Combat Shout
; 2 - Dialogue Happy		10 - Mood Happy
; 3 - Dialogue Sad			11 - Mood Sad
; 4 - Dialogue Surprise		12 - Mood Surprise
; 5 - Dialogue Puzzled		13 - Mood Puzzled
; 6 - Dialogue Disgusted	14 - Mood Disgusted
; aiStrength is from 0 to 100 (percent)
Function _arousedVariants(Int index, Actor act, int Power, condiexp_MCM config) global
	if Power > 100
		Power = 100
	endif

	float exprStr = config.Condiexp_ExpressionStr.GetValue()
	float modStr = config.Condiexp_ModifierStr.GetValue()
	float phStr = config.Condiexp_PhonemeStr.GetValue()

	if index == 1

		SmoothSetExpression(act, 2, Power, 0, exprStr)
		SmoothSetPhoneme(act, 5, 30, phStr)
		SmoothSetPhoneme(act, 6, 10, phStr)
	elseIf  index == 2
		SmoothSetExpression(act, 10, Power, 0, exprStr)
		
		SmoothSetModifier(act,0,1,10,modStr)
		SmoothSetModifier(act,2,3,25,modStr)
		SmoothSetModifier(act,6,7,100,modStr)
		SmoothSetModifier(act,12,13,30,modStr)
		
		SmoothSetPhoneme(act, 4, 35, phStr)
		SmoothSetPhoneme(act, 10, 20, phStr)
		SmoothSetPhoneme(act, 12, 30, phStr)
	elseIf  index == 3
		SmoothSetExpression(act, 4, Power, 0, exprStr)

		SmoothSetModifier(act, 11,-1, 20, modStr)

		SmoothSetPhoneme(act, 1, 10, phStr)
		SmoothSetPhoneme(act, 11, 10, phStr)
	elseIf  index == 4

		SmoothSetExpression(act, 10, Power, 0, exprStr)
		SmoothSetPhoneme(act, 0, 30, phStr)
		SmoothSetPhoneme(act, 7, 60, phStr)
		SmoothSetPhoneme(act, 12, 60, phStr)

		SmoothSetModifier(act,0,1,30, modStr)
		SmoothSetModifier(act,4,5,100, modStr)
		SmoothSetModifier(act,12,13,30, modStr)
	elseIf index == 5
		SmoothSetExpression(act, 5, Power, 0, exprStr)
		SmoothSetPhoneme(act, 8, 25, phStr)
		SmoothSetModifier(act,2,3,20, modStr)
	elseIf index == 6
		SmoothSetExpression(act, 10, Power, 0, exprStr)
		SmoothSetPhoneme(act, 0, 60, phStr)
		SmoothSetPhoneme(act, 6, 50, phStr)
		SmoothSetPhoneme(act, 7, 50, phStr)

		SmoothSetModifier(act,0,1,30, modStr)
		SmoothSetModifier(act,2,3,70, modStr)
		SmoothSetModifier(act,4,5,100, modStr)
		SmoothSetModifier(act,12,13,40, modStr)
	else
		SmoothSetExpression(act, 7, Power, 0, exprStr)
		SmoothSetPhoneme(act, 0, 60, phStr)
		SmoothSetPhoneme(act, 6, 50, phStr)
		SmoothSetPhoneme(act, 7, 50, phStr)

		SmoothSetModifier(act,0,1,30, modStr)
		SmoothSetModifier(act,2,3,80, modStr)
		SmoothSetModifier(act,4,5,100, modStr)
		SmoothSetModifier(act,12,13,60, modStr)
	endIf
endFunction

; Sets an expression to override any other expression other systems may give this actor.
;							7 - Mood Neutral
; 0 - Dialogue Anger		8 - Mood Anger		15 - Combat Anger
; 1 - Dialogue Fear			9 - Mood Fear		16 - Combat Shout
; 2 - Dialogue Happy		10 - Mood Happy
; 3 - Dialogue Sad			11 - Mood Sad
; 4 - Dialogue Surprise		12 - Mood Surprise
; 5 - Dialogue Puzzled		13 - Mood Puzzled
; 6 - Dialogue Disgusted	14 - Mood Disgusted
; aiStrength is from 0 to 100 (percent)
Function _traumaVariants(Int index, Actor act, int Power, condiexp_MCM config) global
	if Power > 100
		Power = 100
	endif

	float exprStr = config.Condiexp_ExpressionStr.GetValue()
	float modStr = config.Condiexp_ModifierStr.GetValue()
	float phStr = config.Condiexp_PhonemeStr.GetValue()


	if index == 1
		SmoothSetExpression(act,1,Power,0, exprStr)
		SmoothSetPhoneme(act, 1, 10, phStr)
		SmoothSetPhoneme(act, 5, 30, phStr)
		SmoothSetPhoneme(act, 7, 70, phStr)
		SmoothSetPhoneme(act, 15, 60, phStr)
	elseIf index == 2
		
		SmoothSetExpression(act,3,Power,0, exprStr)

		SmoothSetModifier(act,11,-1,50, modStr)
		SmoothSetModifier(act,13,-1,14, modStr)

		SmoothSetPhoneme(act, 2, 50, phStr)
		SmoothSetPhoneme(act, 13, 10, phStr)
		SmoothSetPhoneme(act, 15, 20, phStr)
	elseIf index == 3
	
		SmoothSetExpression(act,3,Power,0, exprStr)

		SmoothSetModifier(act,11,-1,50, modStr)
		SmoothSetModifier(act,13,-1,14, modStr)

		SmoothSetPhoneme(act, 2, 50, phStr)
		SmoothSetPhoneme(act, 13, 15, phStr)
		SmoothSetPhoneme(act, 15, 25, phStr)
	elseIf index == 4
		SmoothSetExpression(act,3,Power,0, exprStr)
	
		SmoothSetModifier(act,11,-1,50, modStr)
		SmoothSetModifier(act,13,-1,14, modStr)

		SmoothSetPhoneme(act, 2, 50, phStr)
		SmoothSetPhoneme(act, 13, 10, phStr)
		SmoothSetPhoneme(act, 15, 20, phStr)
	elseIf index == 5
	
		SmoothSetExpression(act,9, Power, 0, exprStr)
	
		SmoothSetModifier(act,2,3,100, modStr)
		SmoothSetModifier(act,4,5,100, modStr)
		SmoothSetModifier(act,11,-1,90, modStr)

		SmoothSetPhoneme(act, 2, 10, phStr)
		SmoothSetPhoneme(act, 0, 10, phStr)
	elseIf index == 6
		SmoothSetExpression(act,9,Power,0, exprStr)

		SmoothSetModifier(act,2,3,100, modStr)
		SmoothSetModifier(act,4,5,100, modStr)
		SmoothSetModifier(act,11,-1,90, modStr)

		SmoothSetPhoneme(act, 0, 10, phStr)
		SmoothSetPhoneme(act, 2, 100, phStr)
		SmoothSetPhoneme(act, 11, 20, phStr)
	elseIf index == 7
		SmoothSetExpression(act,8,Power,0, exprStr)

		SmoothSetModifier(act,0,1,100, modStr)
		SmoothSetModifier(act,2,3,100, modStr)

		SmoothSetModifier(act,4,5,100, modStr)
		SmoothSetPhoneme(act, 2, 100, phStr)
		SmoothSetPhoneme(act, 5, 40, phStr)
	else
		SmoothSetExpression(act,8,Power,0, exprStr)
	
		SmoothSetModifier(act,0,1,100, modStr)
		SmoothSetModifier(act,2,3,100, modStr)
		SmoothSetModifier(act,4,5,100, modStr)

		SmoothSetPhoneme(act, 2, 50, phStr)
		SmoothSetPhoneme(act, 5, 50, phStr)
		SmoothSetPhoneme(act, 11, 10, phStr)
	endIf
endFunction

; Sets an expression to override any other expression other systems may give this actor.
;							7 - Mood Neutral
; 0 - Dialogue Anger		8 - Mood Anger		15 - Combat Anger
; 1 - Dialogue Fear			9 - Mood Fear		16 - Combat Shout
; 2 - Dialogue Happy		10 - Mood Happy
; 3 - Dialogue Sad			11 - Mood Sad
; 4 - Dialogue Surprise		12 - Mood Surprise
; 5 - Dialogue Puzzled		13 - Mood Puzzled
; 6 - Dialogue Disgusted	14 - Mood Disgusted
; aiStrength is from 0 to 100 (percent)

Function _dirtyVariants(Int index, Actor act, int Power, condiexp_MCM config) global
	Int expression = Utility.RandomInt(1, index)
	
	float exprStr = config.Condiexp_ExpressionStr.GetValue()
	float modStr = config.Condiexp_ModifierStr.GetValue()
	float phStr = config.Condiexp_PhonemeStr.GetValue()
	
	if expression == 1
	
		SmoothSetExpression(act, 3, 30, 0, exprStr)
		SmoothSetPhoneme(act,2,100, phStr)
	
	elseIf expression == 2
	
		SmoothSetModifier(act,2,3,50, modStr)
		SmoothSetModifier(act,4,5,50, modStr)
		SmoothSetModifier(act,12,13,50, modStr)

		SmoothSetExpression( act,3, 60, 0, exprStr)
        SmoothSetPhoneme(act, 1, 10, phStr)
		SmoothSetPhoneme(act, 2, 100, phStr)
		
	else
		SmoothSetModifier(act,2,3,50, modStr)
		SmoothSetModifier(act,4,5,50, modStr)

		SmoothSetModifier(act,12,13,50, modStr)
		SmoothSetExpression(act,3, 90, 0, exprStr)
		
		SmoothSetPhoneme(act, 2, 100, phStr)
		SmoothSetPhoneme(act, 7, 50, phStr)
		SmoothSetPhoneme(act, 1, 10, phStr)
	endIf
endFunction



Function RandomEmotion(Actor act, condiexp_MCM config) Global

	Int Order = Utility.RandomInt(1, 80)
	
	If Order == 1 || Order == 33
		LookLeft(70,act)
		LookRight(70, act)
	Elseif Order == 2 || Order == 34 || Order == 61
		LookLeft(50,act)
		LookRight(50,act)
	Elseif Order == 3 || Order == 35 || Order == 62
	Angry(act)
	Elseif Order == 4 || Order == 36 || Order == 63
	Frown(50,act)
	Elseif Order == 5 || Order == 37 || Order == 64
	Smile(25,act)
	Elseif Order == 6 || Order == 38 || Order == 65
	Smile(60,act)
	elseif Order == 7 || Order == 39 || Order == 66
	Puzzled(25,act)
	Elseif Order == 8 || Order == 40 || Order == 67
	BrowsUpSmile(45,act)
	Elseif Order == 9 || Order == 47 || Order == 68
	BrowsUpSmile(30,act)
	Elseif Order == 10 || Order == 41 || Order == 69
	LookLeft(70,act)
	Elseif Order == 11 || Order == 42 || Order == 70
	LookRight(70,act)
	Elseif Order == 12 || Order == 43 || Order == 71
	Squint(act)
	Elseif Order == 13 || Order == 44 || Order == 72
	Smile(50,act)
	Elseif Order == 14 || Order == 45 || Order == 73
	Disgust(60,act)
	Elseif Order == 15 || Order == 46 || Order == 74
	Frown(80,act)
	Elseif Order == 16
	Yawn(act)
	Elseif Order == 17 
	LookDown(40,act)
	Elseif Order == 18 || Order == 48 || Order == 75
	BrowsUp(act)
	Elseif Order == 19 || Order == 49
	Thinking(15,act)
	Elseif Order == 20 || Order == 50 || Order == 80
	Thinking(50,act)
	Elseif Order == 21 || Order == 51
	Thinking(30,act)
	Elseif Order == 22 || Order == 52
	BrowsUpSmile(40,act)
	Elseif Order == 23 || Order == 53 || Order == 76
	BrowsUpSmile(15,act)
	elseif Order == 24 || Order == 54
	Disgust(25,act)
	elseif Order == 25 || Order == 55
	Puzzled(50,act)
	elseif Order == 26 || Order == 56
	Happy(40,act)
	elseif Order == 27 || Order == 77
	Happy(25,act)
	elseif Order == 28 || Order == 59
	Happy(60,act)
	elseif Order == 29 || Order == 58
	Lookleft(50,act)
	elseif Order == 30 || Order == 60
	Squint(act)
	Lookleft(25,act) || Order == 78
	Elseif Order == 31
	Smile(15,act)
	Elseif Order == 32 || Order == 79
	Smile(35,act)
	Endif
EndFunction

Function LookLeft(int n, Actor act) Global
	int i = 0
	
	while i < n
	MfgConsoleFunc.SetModifier(act, 9,i)
	i = i + 5
	if (i >n)
	i = n
	Endif
	Utility.Wait(0.01)
	endwhile
	
	Utility.Wait(0.8)
	
	while i > 0
	MfgConsoleFunc.SetModifier(act, 9,i)
	i = i - 5
	if (i < 0)
	i = 0
	Endif
	Utility.Wait(0.01)
	endwhile
endfunction
	
	
Function LookRight(int n, Actor act) Global
	
	int i = 0
	
	while i < n
	MfgConsoleFunc.SetModifier(act, 10,i)
	i = i + 5
	if (i > n)
	i = n
	Endif
	Utility.Wait(0.05)
	endwhile
	
	Utility.Wait(1.5)
	
	while i > 0
	MfgConsoleFunc.SetModifier(act, 10,i)
	i = i - 5
	if (i < 0)
	i = 0
	Endif
	Utility.Wait(0.01)
	endwhile
endfunction
	
	
Function Squint(Actor act) Global
	
	int i = 0
	
	while i < 55
	MfgConsoleFunc.SetModifier(act, 12, i)
	MfgConsoleFunc.SetModifier(act, 13, i)
	i = i + 5
	if (i >55)
	i = 55
	Endif
	Utility.Wait(0.05)
	endwhile
	
	Utility.Wait(3.5)
	
	while i > 0
	MfgConsoleFunc.SetModifier(act, 12, i)
	MfgConsoleFunc.SetModifier(act, 13, i)
	i = i - 5
	if (i < 0)
	i = 0
	Endif
	Utility.Wait(0.01)
	endwhile
	endfunction
	
Function Frown(int n, Actor act) Global
	
	int i = 0
	
	while i < n
	MfgConsoleFunc.SetModifier(act, 2, i)
	MfgConsoleFunc.SetModifier(act, 3, i)
	i = i + 5
	if (i > n)
	i = n
	Endif
	Utility.Wait(0.05)
	endwhile
	
	Utility.Wait(2.5)
	
	while i > 0
	MfgConsoleFunc.SetModifier(act, 2, i)
	MfgConsoleFunc.SetModifier(act, 3, i)
	i = i - 5
	if (i < 0)
	i = 0
	Endif
	Utility.Wait(0.01)
	endwhile
endfunction
	
Function Smile(int n, Actor act) Global
	
	int i = 0
	
	while i < n
	MfgConsoleFunc.SetPhoneMe(act, 4, i)
	i = i + 5
	if (i >n)
	i = n
	Endif
	Utility.Wait(0.05)
	endwhile
	
	Utility.Wait(3)
	
	while i > 0
	MfgConsoleFunc.SetPhoneMe(act, 4, i)
	i = i - 5
	if (i < 0)
	i = 0
	Endif
	Utility.Wait(0.01)
	endwhile
endfunction
	
Function Angry(Actor act) Global
	
	int i = 0
	
	while i < 70
	MfgConsoleFunc.SetModifier(act, 2, i)
	MfgConsoleFunc.SetModifier(act, 3, i)
	MfgConsoleFunc.SetModifier(act, 9,i)
	i = i + 5
	if (i > 70)
	i = 70
	Endif
	Utility.Wait(0.05)
	endwhile
	
	Utility.Wait(1.5)
	
	while i > 0
	MfgConsoleFunc.SetModifier(act, 2, i)
	MfgConsoleFunc.SetModifier(act, 3, i)
	MfgConsoleFunc.SetModifier(act, 9,i)
	i = i - 2
	if (i < 0)
	i = 0
	Endif
	Utility.Wait(0.01)
	endwhile
endfunction
	
Function Thinking(int n, Actor act) Global
	
	int i = 0
	
	while i < n
	MfgConsoleFunc.SetModifier(act, 7, i)
	MfgConsoleFunc.SetPhoneMe(act, 7,i)
	i = i + 5
	if (i > n)
	i = n
	Endif
	Utility.Wait(0.05)
	endwhile
	
	Utility.Wait(2.5)
	
	while i > 0
	MfgConsoleFunc.SetModifier(act, 7, i)
	MfgConsoleFunc.SetPhoneMe(act, 7,i)
	i = i - 5
	if (i < 0)
	i = 0
	Endif
	Utility.Wait(0.01)
	endwhile
endfunction
	 
Function Yawn(Actor act) Global
	
	int i = 0
	
	while i < 75
	MfgConsoleFunc.SetModifier(act, 0, i)
	MfgConsoleFunc.SetModifier(act, 1, i)
	MfgConsoleFunc.SetModifier(act, 6, i)
	MfgConsoleFunc.SetModifier(act, 7, i)
	MfgConsoleFunc.SetPhoneMe(act, 1,i)
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
	MfgConsoleFunc.SetModifier(act, 0, i)
	MfgConsoleFunc.SetModifier(act, 1, i)
	MfgConsoleFunc.SetModifier(act, 6, i)
	MfgConsoleFunc.SetModifier(act, 7, i)
	MfgConsoleFunc.SetPhoneMe(act, 1,i)
	i = i - 3
	if (i < 0)
	i = 0
	Endif
	Utility.Wait(0.0000001)
	endwhile
endfunction
	
Function LookDown(int n, Actor act) Global
	
	int i = 0
	
	while i < n
	MfgConsoleFunc.SetModifier(act, 8,i)
	i = i + 5
	if (i >n)
	i = n
	Endif
	Utility.Wait(0.05)
	endwhile
	
	Utility.Wait(1.5)
	
	while i > 0
	MfgConsoleFunc.SetModifier(act, 8,i)
	i = i - 5
	if (i < 0)
	i = 0
	Endif
	Utility.Wait(0.01)
	endwhile
endfunction
	
Function BrowsUp( Actor act) Global
	
	int i = 0
	
	while i < 75
	MfgConsoleFunc.SetModifier(act, 6, i)
	MfgConsoleFunc.SetModifier(act, 7, i)
	i = i + 10
	if (i > 75)
	i = 75
	Endif
	Utility.Wait(0.05)
	endwhile
	
	Utility.Wait(2)
	
	while i > 0
	MfgConsoleFunc.SetModifier(act, 6, i)
	MfgConsoleFunc.SetModifier(act, 7, i)
	i = i - 5
	if (i < 0)
	i = 0
	Endif
	Utility.Wait(0.01)
	endwhile
endfunction
	
	
Function BrowsUpSmile(int n, Actor act) Global
	
	int i = 0
	
	while i < n
	MfgConsoleFunc.SetModifier(act, 6, i)
	MfgConsoleFunc.SetModifier(act, 7, i)
	MfgConsoleFunc.SetPhoneMe(act, 5, i)
	
	i = i + 5
	if (i > n)
	i = n
	Endif
	Utility.Wait(0.05)
	endwhile
	
	Utility.Wait(1.5)
	
	while i > 0
	MfgConsoleFunc.SetModifier(act, 6, i)
	MfgConsoleFunc.SetModifier(act, 7, i)
	MfgConsoleFunc.SetPhoneMe(act, 5, i)
	
	i = i - 5
	if (i < 0)
	i = 0
	Endif
	Utility.Wait(0.01)
	endwhile
endfunction
	
	
Function Disgust(int n, Actor act) Global
	int i = 0
	
	while i < n
	act.SetExpressionOverride(14,i)
	
	i = i + 5
	if (i > n)
	i = n
	Endif
	Utility.Wait(0.05)
	endwhile
	
	Utility.Wait(1.5)
	
	while i > 0
	act.SetExpressionOverride(14,i)
	
	i = i - 5
	if (i < 0)
	i = 0
	Endif
	Utility.Wait(0.01)
	endwhile
	act.ClearExpressionOverride()
endfunction
	
Function Happy(int n, Actor act) Global
	
	int i = 0
	
	while i < n
	act.SetExpressionOverride(10,i)
	
	i = i + 5
	if (i > n)
	i = n
	Endif
	Utility.Wait(0.05)
	endwhile
	
	Utility.Wait(4.5)
	
	while i > 0
	act.SetExpressionOverride(10,i)
	
	i = i - 5
	if (i < 0)
	i = 0
	Endif
	Utility.Wait(0.01)
	endwhile
	act.ClearExpressionOverride()
endfunction

Function Inhale(int n, int j, Actor act) Global
	int i = n
   
   while i <  j
   MfgConsoleFunc.SetPhoneme(act, 0,i)
   i = i + 3
   If (i >j)
   i = j
   Endif
   Utility.Wait(0.04)
   endwhile
EndFunction
 
Function Exhale(int n, int j, Actor act) Global

	int i = n
   
   while i > j
  	 MfgConsoleFunc.SetPhoneme(act, 0, i)
  	 i = i - 3
   	If (i < j)
   		i = j
   	Endif
  	 Utility.Wait(0.02)
   endwhile
EndFunction

Function Puzzled(int n, Actor act) Global
	
	int i = 0
	
	while i < n
	act.SetExpressionOverride(13,i)
	
	i = i + 5
	if (i > n)
	i = n
	Endif
	Utility.Wait(0.05)
	endwhile
	
	Utility.Wait(3.5)
	
	while i > 0
	act.SetExpressionOverride(13,i)
	
	i = i - 5
	if (i < 0)
	i = 0
	Endif
	Utility.Wait(0.01)
	endwhile
	act.ClearExpressionOverride()
endfunction

Function HumanOuch(Actor act) global 

	int i = 0
	
	while i < 100
		MfgConsoleFunc.SetPhoneMe(act, 10,i)
		i = i + 12
		if (i > 100)
			i = 100
		Endif
		Utility.Wait(0.0001)
	endwhile
	
	Utility.Wait(0.2)
	
	while i > 0
		MfgConsoleFunc.SetPhoneMe(act, 10,i)
		i = i - 15
		if (i < 0)
			i = 0
		Endif
		Utility.Wait(0.0001)
	endwhile
EndFunction
	
	
Function VampireOuch(Actor act) global
	
	int i = 0
	
	while i < 60
		MfgConsoleFunc.SetPhoneMe(act, 10,i)
		MfgConsoleFunc.SetPhoneMe(act, 9,i)
		MfgConsoleFunc.SetPhoneMe(act, 5,i)
	i = i + 12
		if (i > 60)
			i = 60
		Endif
		Utility.Wait(0.0001)
	endwhile
	
	Utility.Wait(4)
	
	while i > 0
		MfgConsoleFunc.SetPhoneMe(act, 10,i)
		MfgConsoleFunc.SetPhoneMe(act, 9,i)
		MfgConsoleFunc.SetPhoneMe(act, 5,i)
		i = i - 15
		if (i < 0)
			i = 0
		Endif
		Utility.Wait(0.0001)
	endwhile
EndFunction