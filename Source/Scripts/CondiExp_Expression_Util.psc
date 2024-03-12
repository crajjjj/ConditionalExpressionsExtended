Scriptname CondiExp_Expression_Util Hidden

Import Debug
Import CondiExp_util
import Utility
import Math
import CondiExp_log

int Function getSmoothSpeed() global
	return 100 ;10
endfunction
int Function getSmoothSpeedHalf() global
	return 100 ;10
endfunction
int Function getHardSpeed() global
	return 100 ;50
endfunction

Function PlayArousedExpression(Actor act, int aroused, CondiExp_BaseExpression expr) global
	Int power = aroused
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
		expr.Apply(act, randomEffect, power)
	Else
		CondiExp_log.trace(act, "Aroused: Arousal: " + aroused + ".Effect: skip ")
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

Function PlayTraumaExpression(Actor act, int trauma, CondiExp_BaseExpression expr) global
	Int power = 10 + trauma * 10
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
		;verbose(act,"Trauma: Trauma: " + trauma + ".Effect: " + randomEffect, config.Condiexp_Verbose.GetValueInt())
		;_traumaVariants(randomEffect, act, power, config)
		expr.Apply(act, randomEffect, power)
	else
		CondiExp_log.trace(act, "Trauma: Trauma: " + trauma + ".Effect: skip ")
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

Function PlayDirtyExpression(Actor act, int dirty, CondiExp_BaseExpression expr) global
	Int power = 25 + dirty * 25
	if power > 100
		power = 100
	endif
;random skip 33%
	Int randomSkip = Utility.RandomInt(1, 10)
	if randomSkip > 3
		int topMargin = 2
		if dirty > 2
			topMargin = 7
		endif 
		Int randomEffect = Utility.RandomInt(1, topMargin)
		expr.Apply(act, randomEffect, power)
	else
		CondiExp_log.trace(act, "Dirty: Dirty: " + dirty + ".Effect: skip ")
	endif

	Int randomLook = Utility.RandomInt(1, 10)
	If randomLook == 2
		LookLeft(50, act)
	ElseIf randomLook == 4
		LookRight(50, act)
	ElseIf randomLook == 8
		LookDown(50, act)
	Elseif randomLook == 9
		Disgust(60, act)
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

Function PlayPainExpression(Actor act, CondiExp_BaseExpression expr) global
    Int Order = Utility.RandomInt(1, 4)
	expr.Apply(act, Order, 100)
EndFunction

Function PlayRandomExpression(Actor act, condiexp_MCM config) global
	verbose(act,"Random emotion", config.Condiexp_Verbose.GetValueInt())
	RandomEmotion(act, config)
EndFunction

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
	CondiExp_util.SetModifier(act, 9,i)
	i = i + getSmoothSpeed()
	if (i >n)
	i = n
	Endif
	Utility.Wait(0.01)
	endwhile
	
	Utility.Wait(0.8)
	
	while i > 0
	CondiExp_util.SetModifier(act, 9,i)
	i = i - getSmoothSpeed()
	if (i < 0)
	i = 0
	Endif
	Utility.Wait(0.01)
	endwhile
endfunction
	
	
Function LookRight(int n, Actor act) Global
	
	int i = 0
	
	while i < n
	CondiExp_util.SetModifier(act, 10,i)
	i = i + getSmoothSpeed()
	if (i > n)
	i = n
	Endif
	Utility.Wait(0.05)
	endwhile
	
	Utility.Wait(1.5)
	
	while i > 0
	CondiExp_util.SetModifier(act, 10,i)
	i = i - getSmoothSpeed()
	if (i < 0)
	i = 0
	Endif
	Utility.Wait(0.01)
	endwhile
endfunction
	
	
Function Squint(Actor act) Global
	
	int i = 0
	
	while i < 55
	CondiExp_util.SetModifier(act, 12, i)
	CondiExp_util.SetModifier(act, 13, i)
	i = i + getSmoothSpeed()
	if (i >55)
	i = 55
	Endif
	Utility.Wait(0.05)
	endwhile
	
	Utility.Wait(3.5)
	
	while i > 0
	CondiExp_util.SetModifier(act, 12, i)
	CondiExp_util.SetModifier(act, 13, i)
	i = i - getSmoothSpeed()
	if (i < 0)
	i = 0
	Endif
	Utility.Wait(0.01)
	endwhile
	endfunction
	
Function Frown(int n, Actor act) Global
	
	int i = 0
	
	while i < n
	CondiExp_util.SetModifier(act, 2, i)
	CondiExp_util.SetModifier(act, 3, i)
	i = i + getSmoothSpeed()
	if (i > n)
	i = n
	Endif
	Utility.Wait(0.05)
	endwhile
	
	Utility.Wait(2.5)
	
	while i > 0
	CondiExp_util.SetModifier(act, 2, i)
	CondiExp_util.SetModifier(act, 3, i)
	i = i - getSmoothSpeed()
	if (i < 0)
	i = 0
	Endif
	Utility.Wait(0.01)
	endwhile
endfunction
	
Function Smile(int n, Actor act) Global
	
	int i = 0
	
	while i < n
	CondiExp_util.SetPhoneMe(act, 4, i)
	i = i + getSmoothSpeed()
	if (i >n)
	i = n
	Endif
	Utility.Wait(0.05)
	endwhile
	
	Utility.Wait(3)
	
	while i > 0
	CondiExp_util.SetPhoneMe(act, 4, i)
	i = i - getSmoothSpeed()
	if (i < 0)
	i = 0
	Endif
	Utility.Wait(0.01)
	endwhile
endfunction
	
Function Angry(Actor act) Global
	
	int i = 0
	
	while i < 70
	CondiExp_util.SetModifier(act, 2, i)
	CondiExp_util.SetModifier(act, 3, i)
	CondiExp_util.SetModifier(act, 9,i)
	i = i + getSmoothSpeed()
	if (i > 70)
	i = 70
	Endif
	Utility.Wait(0.05)
	endwhile
	
	Utility.Wait(1.5)
	
	while i > 0
	CondiExp_util.SetModifier(act, 2, i)
	CondiExp_util.SetModifier(act, 3, i)
	CondiExp_util.SetModifier(act, 9,i)
	i = i - getSmoothSpeedHalf()
	if (i < 0)
	i = 0
	Endif
	Utility.Wait(0.01)
	endwhile
endfunction
	
Function Thinking(int n, Actor act) Global
	
	int i = 0
	
	while i < n
	CondiExp_util.SetModifier(act, 7, i)
	CondiExp_util.SetPhoneMe(act, 7,i)
	i = i + getSmoothSpeed()
	if (i > n)
	i = n
	Endif
	Utility.Wait(0.05)
	endwhile
	
	Utility.Wait(2.5)
	
	while i > 0
	CondiExp_util.SetModifier(act, 7, i)
	CondiExp_util.SetPhoneMe(act, 7,i)
	i = i - getSmoothSpeed()
	if (i < 0)
	i = 0
	Endif
	Utility.Wait(0.01)
	endwhile
endfunction
	 
Function Yawn(Actor act) Global
	
	int i = 0
	
	while i < 75
	CondiExp_util.SetModifier(act, 0, i)
	CondiExp_util.SetModifier(act, 1, i)
	CondiExp_util.SetModifier(act, 6, i)
	CondiExp_util.SetModifier(act, 7, i)
	CondiExp_util.SetPhoneMe(act, 1,i)
	i = i + getSmoothSpeedHalf()
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
	CondiExp_util.SetModifier(act, 0, i)
	CondiExp_util.SetModifier(act, 1, i)
	CondiExp_util.SetModifier(act, 6, i)
	CondiExp_util.SetModifier(act, 7, i)
	CondiExp_util.SetPhoneMe(act, 1,i)
	i = i - getSmoothSpeedHalf()
	if (i < 0)
	i = 0
	Endif
	Utility.Wait(0.0000001)
	endwhile
endfunction
	
Function LookDown(int n, Actor act) Global
	
	int i = 0
	
	while i < n
	CondiExp_util.SetModifier(act, 8,i)
	i = i + getSmoothSpeed()
	if (i > n)
	i = n
	Endif
	Utility.Wait(0.05)
	endwhile
	
	Utility.Wait(1.5)
	
	while i > 0
	CondiExp_util.SetModifier(act, 8,i)
	i = i - getSmoothSpeed()
	if (i < 0)
	i = 0
	Endif
	Utility.Wait(0.01)
	endwhile
endfunction
	
Function BrowsUp( Actor act) Global
	
	int i = 0
	
	while i < 75
	CondiExp_util.SetModifier(act, 6, i)
	CondiExp_util.SetModifier(act, 7, i)
	i = i + getSmoothSpeed()
	if (i > 75)
	i = 75
	Endif
	Utility.Wait(0.05)
	endwhile
	
	Utility.Wait(2)
	
	while i > 0
	CondiExp_util.SetModifier(act, 6, i)
	CondiExp_util.SetModifier(act, 7, i)
	i = i - getSmoothSpeed()
	if (i < 0)
	i = 0
	Endif
	Utility.Wait(0.01)
	endwhile
endfunction
	
	
Function BrowsUpSmile(int n, Actor act) Global
	
	int i = 0
	
	while i < n
	CondiExp_util.SetModifier(act, 6, i)
	CondiExp_util.SetModifier(act, 7, i)
	CondiExp_util.SetPhoneMe(act, 5, i)
	
	i = i + getSmoothSpeed()
	if (i > n)
	i = n
	Endif
	Utility.Wait(0.05)
	endwhile
	
	Utility.Wait(1.5)
	
	while i > 0
	CondiExp_util.SetModifier(act, 6, i)
	CondiExp_util.SetModifier(act, 7, i)
	CondiExp_util.SetPhoneMe(act, 5, i)
	
	i = i - getSmoothSpeed()
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
	
	i = i + getSmoothSpeed()
	if (i > n)
	i = n
	Endif
	Utility.Wait(0.05)
	endwhile
	
	Utility.Wait(1.5)
	
	while i > 0
	act.SetExpressionOverride(14,i)
	
	i = i - getSmoothSpeed()
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
	
	i = i + getSmoothSpeed()
	if (i > n)
	i = n
	Endif
	Utility.Wait(0.05)
	endwhile
	
	Utility.Wait(4.5)
	
	while i > 0
	act.SetExpressionOverride(10,i)
	
	i = i - getSmoothSpeed()
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
   CondiExp_util.SetPhoneme(act, 0,i)
   i = i + getSmoothSpeedHalf()
   If (i >j)
   i = j
   Endif
   Utility.Wait(0.04)
   endwhile
EndFunction
 
Function Exhale(int n, int j, Actor act) Global

	int i = n
   
   while i > j
  	 CondiExp_util.SetPhoneme(act, 0, i)
  	 i = i - getSmoothSpeedHalf()
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
	
	i = i + getSmoothSpeed()
	if (i > n)
	i = n
	Endif
	Utility.Wait(0.05)
	endwhile
	
	Utility.Wait(3.5)
	
	while i > 0
	act.SetExpressionOverride(13,i)
	
	i = i - getSmoothSpeedHalf()
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
		CondiExp_util.SetPhoneMe(act, 10,i)
		i = i + getHardSpeed()
		if (i > 100)
			i = 100
		Endif
		Utility.Wait(0.0001)
	endwhile
	
	Utility.Wait(0.2)
	
	while i > 0
		CondiExp_util.SetPhoneMe(act, 10,i)
		i = i - getHardSpeed()
		if (i < 0)
			i = 0
		Endif
		Utility.Wait(0.0001)
	endwhile
EndFunction
	
	
Function VampireOuch(Actor act) global
	
	int i = 0
	
	while i < 60
		CondiExp_util.SetPhoneMe(act, 10,i)
		CondiExp_util.SetPhoneMe(act, 9,i)
		CondiExp_util.SetPhoneMe(act, 5,i)
	i = i + getHardSpeed()
		if (i > 60)
			i = 60
		Endif
		Utility.Wait(0.0001)
	endwhile
	
	Utility.Wait(4)
	
	while i > 0
		CondiExp_util.SetPhoneMe(act, 10,i)
		CondiExp_util.SetPhoneMe(act, 9,i)
		CondiExp_util.SetPhoneMe(act, 5,i)
		i = i - getHardSpeed()
		if (i < 0)
			i = 0
		Endif
		Utility.Wait(0.0001)
	endwhile
EndFunction

Function Headache(Actor act) global
    int i = 0
    while i < 95
         i = i + getSmoothSpeed()
         if (i > 95)
            i = 95
         Endif
         act.SetExpressionOverride(3,i)
         Utility.Wait(0.1)
    endwhile
    Utility.Wait(5)
    i = 95
    while i > 0
     i = i - getSmoothSpeed()
        if (i < 0)
            i = 0
        Endif
        act.SetExpressionOverride(3,i)
     Utility.Wait(0.1)
    endwhile
    Utility.Wait(3)
endfunction