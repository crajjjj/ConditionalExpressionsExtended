Scriptname CondiExp_Expression_Util Hidden

; Import Debug
Import CondiExp_util
import Utility
import Math
import CondiExp_log


bool Function PlayArousedExpression(Actor act, int aroused, CondiExp_BaseExpression expr) global
	Int power = aroused
	if power > 75
		power = 75
	endif
	int i = 0
	
	;random skip 30%
	Int randomSkip = Utility.RandomInt(1, 10)
	if randomSkip > 3
		int topMargin = 3
		if aroused > 50 &&  aroused <= 80
			topMargin = 5
		else
			topMargin = 7
		endif 
		Int randomEffect = Utility.RandomInt(1, topMargin)
		expr.Apply(act, randomEffect, power)
		RandomLook(act)
		return true
	Else
		CondiExp_log.trace(act, "Aroused: Arousal: " + aroused + ".Effect: skip ")
		return false
	endif
EndFunction

Function PlayDrunkExpression(Actor act) global
	
	Int randomSmile = Utility.RandomInt(1, 100)
	Int randomDelay = Utility.RandomInt(1, 10)
	
	SmoothSetExpression(act, 2, 50, 1.0) ; Dialogue Happy (sloppy, content drunkenness)
	SmoothSetPhoneme(act, 0, 50, 1.0)   ; Aah (open mouth, mid-ramble or laughter)
	SmoothSetModifier(act, 6, 7, 50, 1.0) ; Brow Up L + Brow Up R (raised eyebrows, goofy expression)
	
	RandomLook(act)
	if randomSmile > 30
		Smile(80, act)
	endif
	Utility.Wait(5 + randomDelay)
	resetMFGSmooth(act)
	SmoothSetExpression(act, 9, 40, 1.0) ; Mood Fear (dazed, unfocused)
	SmoothSetPhoneme(act, 11, 40, 1.0)   ; Oh (loose lips, slightly open mouth)
	SmoothSetModifier(act, 8, 9, 40, 1.0) ; LookDown + LookLeft (drowsy, unfocused gaze)
	Utility.Wait(5 + randomDelay)
	RandomLook(act)
	resetMFGSmooth(act)
	SmoothSetExpression(act, 2, 50, 1.0)  ; Dialogue Happy (drunken smirk)
	SmoothSetPhoneme(act, 11, 40, 1.0)   ; Oh (lips loosely open, derpy look)
	SmoothSetModifier(act, 4, 5, 40, 1.0) ; Brow In L + Brow In R (slightly confused expression)
	SmoothSetModifier(act, 12, 13, 30, 1.0) ; SquintL + SquintR (half-closed, sleepy drunk eyes)
	RandomLook(act)
	Utility.Wait(5 + randomDelay)
	resetMFGSmooth(act)
EndFunction

Function PlayScoomaExpression(Actor act) global
	Int randomDelay = Utility.RandomInt(1, 10)
	; Phase 1: Blissed-out euphoria
	SmoothSetExpression(act, 2, 80, 1.0) ; Dialogue Happy (mellow euphoria)
	SmoothSetModifier(act, 6, 7, 40, 1.0) ; Brows Up (relaxed, spaced out)
	SmoothSetPhoneme(act, 0, 30, 1.0) ; Aah (open mouth, slight breathiness)
	RandomLook(act)
	Utility.Wait(5 + randomDelay)
	resetMFGSmooth(act)

	; Phase 2: Slow detachment or dissociation
    int randomhappy = Utility.RandomInt(30, 70)
    int randomsmile = Utility.RandomInt(10, 50)
    SetModifier(act,11, 55)
    SetPhoneme(act,4,randomsmile)
    SmoothSetExpression(act,2,randomhappy)
	LookDown(30, act)
	Utility.Wait(2 + randomDelay)
	resetMFGSmooth(act)

	; Phase 3: Hyper-focus or minor paranoia hit
	SmoothSetExpression(act, 4, 50, 1.0) ; Mood Surprise/Alert
	SmoothSetModifier(act, 4, 5, 50, 1.0) ; Brow In L + R (internal pressure)
	SmoothSetPhoneme(act, 7, 50, 1.0) ; EE (tight mouth, internal tension)
	RandomLook(act)
	Utility.Wait(4 + randomDelay)
	RandomLook(act)
	resetMFGSmooth(act)
EndFunction


Function RandomLook(Actor act) global
	Int randomLook = Utility.RandomInt(1, 20)
	If randomLook == 2 || randomLook == 12
		LookLeft(50, act)
	ElseIf randomLook == 4 || randomLook == 14
		LookRight(50, act)
	ElseIf randomLook == 8
		LookDown(40, act)
	endif
EndFunction

bool Function PlayTraumaExpression(Actor act, int trauma, CondiExp_BaseExpression expr) global
	Int power = 10 + trauma * 10
	if power > 80
		power = 80
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
		expr.Apply(act, randomEffect, power)
		Utility.Wait(1)
		RandomLook(act)
		Utility.Wait(5)
		return true
	else
		CondiExp_log.trace(act, "Trauma: Trauma: " + trauma + ".Effect: skip ")
	endif
	return false
EndFunction

bool Function PlayDirtyExpression(Actor act, int dirty, CondiExp_BaseExpression expr) global
	Int power = 25 + dirty * 25
	if power > 80
		power = 80
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
		RandomLook(act)
		Utility.Wait(1)
		return true
	else
		CondiExp_log.trace(act, "Dirty: Dirty: " + dirty + ".Effect: skip ")
	endif
	return false
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

Function PlayRandomExpression(Actor act, condiexp_MCM config, CondiExp_BaseExpression expr) global
	Int Order = Utility.RandomInt(1, 110)
	verbose(act,"Random emotion. Order: " + Order, config.Condiexp_Verbose.GetValueInt())
	RandomEmotion(act, config, expr, order)
EndFunction

Function RandomEmotion(Actor act, condiexp_MCM config, CondiExp_BaseExpression expr, int Order) Global

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
	Puzzled(25,act, 4.0)
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
	Puzzled(50,act, 4.0)
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
	Elseif Order == 31 || Order == 78
	Smile(15,act)
	Elseif Order == 32 || Order == 79
	Smile(35,act)
	Else
		Int exprNumber = Utility.RandomInt(1, 7)
		verbose(act,"Expression_Random. Number: " + exprNumber, config.Condiexp_Verbose.GetValueInt())
		expr.Apply(act, exprNumber, 60)
		int exprDuration = Utility.RandomInt(1,3)
		Utility.Wait(exprDuration)
		resetMFGSmooth(act)
	Endif
EndFunction

;=============================================================
; Relationship‑driven facial expression selector
;=============================================================
Function RelationshipRankEmotion(Actor act, condiexp_MCM config, CondiExp_BaseExpression expr, int relationshipRank) Global
	;
	;int verboseInt = config.Condiexp_Verbose.GetValueInt()
	;verbose(act, "Relationship rank: " + rel, verboseInt)

	int exprType = 0 ; 0 = Neutral, 1 = Friendly, 2 = Hostile
	int roll = Utility.RandomInt(1, 100)
	
	int FRIENDLY_THRESHOLD   = 2        ; >= this → friendly
    int HOSTILE_THRESHOLD    = -2       ; <= this → hostile
    int FRIENDLY_CHANCE_PCT  = 70
    int HOSTILE_CHANCE_PCT   = 70

	if relationshipRank >= FRIENDLY_THRESHOLD
		if roll <= FRIENDLY_CHANCE_PCT
			exprType = 1 ; friendly
		else
			exprType = 0 ; neutral
		endif
	elseif relationshipRank <= HOSTILE_THRESHOLD
		if roll <= HOSTILE_CHANCE_PCT
			exprType = 2 ; hostile
		else
			exprType = 0 ; neutral
		endif
	else
		exprType = 0 ; neutral
	endif

	if exprType == 1
		; FRIENDLY expressions
		int mood = Utility.RandomInt(1, 6)
		if mood == 1
			Smile(Utility.RandomInt(25, 60), act)
		elseif mood == 2
			Happy(Utility.RandomInt(25, 60), act)
		elseif mood == 3
			BrowsUpSmile(Utility.RandomInt(30, 50), act)
		elseif mood == 4
			Smile(35, act)
			LookLeft(50, act)
		elseif mood == 5
			BrowsUpSmile(45, act)
			Squint(act)
		elseif mood == 6
			LookLeft(40, act)
			LookRight(40, act)
			Smile(25, act)
		endif

	elseif exprType == 2
		; HOSTILE expressions
		int mood = Utility.RandomInt(1, 6)
		if mood == 1
			Angry(act)
		elseif mood == 2
			Disgust(Utility.RandomInt(25, 60), act)
		elseif mood == 3
			Frown(Utility.RandomInt(50, 80), act)
		elseif mood == 4
			Frown(60, act)
			Squint(act)
		elseif mood == 5
			LookRight(70, act)
			Angry(act)
		elseif mood == 6
			LookLeft(40, act)
			LookRight(40, act)
			Frown(50, act)
		endif
	else
		; NEUTRAL expressions
		int mood = Utility.RandomInt(1, 10)
		if mood == 1
			Puzzled(Utility.RandomInt(25, 50), act, 4.0)
		elseif mood == 2
			Thinking(Utility.RandomInt(15, 50), act)
		elseif mood == 3
			LookLeft(Utility.RandomInt(40, 70), act)
		elseif mood == 4
			LookRight(Utility.RandomInt(40, 70), act)
		elseif mood == 5
			Squint(act)
			LookLeft(25, act)
		elseif mood == 6
			Thinking(30, act)
			BrowsUp(act)
		elseif mood == 7
			if Utility.RandomInt(0, 1) == 0
  			 LookLeft(35, act)
   			 LookRight(35, act)
			else
   			 LookRight(35, act)
   			 LookLeft(35, act)
			endif
		else
			Int exprNumber = Utility.RandomInt(1, 7)
			trace(act,"Expression_Random (Rel). Number: " + exprNumber, config.Condiexp_Verbose.GetValueInt())
			expr.Apply(act, exprNumber, 60)
		endif
	endif
EndFunction




Function LookLeft(int n, Actor act, float time = 2.0) Global
	CondiExp_util.SetModifier(act, 9,n, 1, 1)

	Utility.Wait(time)

	CondiExp_util.SetModifier(act, 9,0, 1, 1)
	Utility.Wait(1.0)
endfunction
	
	
Function LookRight(int n, Actor act, float time = 2.0) Global
	CondiExp_util.SetModifier(act, 10,n,1,1)
	
	Utility.Wait(time)
	
	CondiExp_util.SetModifier(act, 10,0,1,1)
	Utility.Wait(1.0)
endfunction
	
	
Function Squint(Actor act) Global
	CondiExp_util.SetModifier(act, 12, 55,1,1)
	CondiExp_util.SetModifier(act, 13, 55,1,1)

	Utility.Wait(4.5)
	
	CondiExp_util.SetModifier(act, 12, 0,1,1)
	CondiExp_util.SetModifier(act, 13, 0,1,1)
	Utility.Wait(1.0)
endfunction
	
Function Frown(int n, Actor act) Global
	CondiExp_util.SetModifier(act, 2, n, 1)
	CondiExp_util.SetModifier(act, 3, n, 1)

	Utility.Wait(2.5)
	
	CondiExp_util.SetModifier(act, 2, 0, 1)
	CondiExp_util.SetModifier(act, 3, 0, 1)
	Utility.Wait(1.0)
endfunction
	
Function Smile(int n, Actor act) Global
	CondiExp_util.SetPhoneMe(act, 4, n)

	Utility.Wait(4)

	CondiExp_util.SetPhoneMe(act, 4, 0)
	Utility.Wait(1.0)
endfunction
	
Function Angry(Actor act) Global
	CondiExp_util.SetModifier(act, 2, 70)
	CondiExp_util.SetModifier(act, 3, 70)
	CondiExp_util.SetModifier(act, 9,70)
	
	Utility.Wait(2.5)
	
	CondiExp_util.SetModifier(act, 2, 0)
	CondiExp_util.SetModifier(act, 3, 0)
	CondiExp_util.SetModifier(act, 9,0)
	Utility.Wait(1.0)
endfunction
	
Function Thinking(int n, Actor act) Global
	CondiExp_util.SetModifier(act, 7, n)
	CondiExp_util.SetPhoneMe(act, 7, n)
	
	Utility.Wait(3.0)
	
	CondiExp_util.SetModifier(act, 7, 0)
	CondiExp_util.SetPhoneMe(act, 7,0)
	Utility.Wait(1.0)
endfunction
	 
Function Yawn(Actor act) Global
	CondiExp_util.SetModifier(act, 0, 75)
	CondiExp_util.SetModifier(act, 1, 75)
	CondiExp_util.SetModifier(act, 6, 75)
	CondiExp_util.SetModifier(act, 7, 75)
	CondiExp_util.SetPhoneMe(act, 1, 75)

	int yawnduration = Utility.RandomInt(1,3)
	if yawnduration == 1
	Utility.Wait(0.7)
	elseif yawnduration == 2
	Utility.Wait(1)
	elseif yawnduration == 3
	Utility.Wait(1.5)
	endif
	
	CondiExp_util.SetModifier(act, 0, 0)
	CondiExp_util.SetModifier(act, 1, 0)
	CondiExp_util.SetModifier(act, 6, 0)
	CondiExp_util.SetModifier(act, 7, 0)
	CondiExp_util.SetPhoneMe(act, 1, 0)
	Utility.Wait(1.0)
endfunction
	
Function LookDown(int n, Actor act, float time = 1.5) Global
	CondiExp_util.SetModifier(act, 8,n)
	Utility.Wait(time)
	CondiExp_util.SetModifier(act, 8,0)
	Utility.Wait(1.0)
endfunction
	
Function BrowsUp( Actor act) Global
	CondiExp_util.SetModifier(act, 6, 75)
	CondiExp_util.SetModifier(act, 7, 75)
	Utility.Wait(2)
	CondiExp_util.SetModifier(act, 6, 0)
	CondiExp_util.SetModifier(act, 7, 0)
	Utility.Wait(1.0)
endfunction

Function BrowsDown( Actor act) Global
	CondiExp_util.SetModifier(act, 2, 75)
	CondiExp_util.SetModifier(act, 3, 75)
	Utility.Wait(2)
	CondiExp_util.SetModifier(act, 2, 0)
	CondiExp_util.SetModifier(act, 3, 0)
	Utility.Wait(1.0)
endfunction
	
Function BrowsUpSmile(int n, Actor act) Global

	CondiExp_util.SetModifier(act, 6, n)
	CondiExp_util.SetModifier(act, 7, n)
	CondiExp_util.SetPhoneMe(act, 5, n)
	Utility.Wait(1.5)
	CondiExp_util.SetModifier(act, 6, 0)
	CondiExp_util.SetModifier(act, 7, 0)
	CondiExp_util.SetPhoneMe(act, 5, 0)
	Utility.Wait(1.0)
endfunction
	
	
Function Disgust(int n, Actor act) Global
	CondiExp_util.SmoothSetExpression(act,14,n)
	Utility.Wait(1.5)
	CondiExp_util.SmoothSetExpression(act,14,0)
	act.ClearExpressionOverride()
endfunction
	
Function Happy(int n, Actor act) Global
	CondiExp_util.SmoothSetExpression(act,10,n)
	Utility.Wait(4.5)
	CondiExp_util.SmoothSetExpression(act,10,0)
	act.ClearExpressionOverride()
	Utility.Wait(1.0)
endfunction

Function Inhale(int n, int j, Actor act) Global
   int i = n
   while i <  j
  	 CondiExp_util.SetPhonemeFast(act, 0, i)
  	 i = i + 5
   	 If (i > j)
   		i = j
     Endif
     Utility.Wait(0.04)
   endwhile
EndFunction
 
Function Exhale(int n, int j, Actor act) Global
	int i = n
    while i > j
  	  CondiExp_util.SetPhonemeFast(act, 0, i)
  	  i = i - 5
   	  If (i < j)
   		i = j
   	  Endif
  	  Utility.Wait(0.02)
   endwhile
EndFunction

Function Fear(int n, Actor act, float time) Global
	CondiExp_util.SmoothSetExpression(act,9,n)
	CondiExp_util.SetPhoneme(act, 4, 15)
	Utility.Wait(time)
	CondiExp_util.SmoothSetExpression(act,9,0)
	Utility.Wait(1)
	CondiExp_util.resetPhonemesSmooth(act)
	act.ClearExpressionOverride()
endfunction

Function Surprised(int n, Actor act, float time) Global
	CondiExp_util.SmoothSetExpression(act,12,n)
	CondiExp_util.SetPhoneme(act, 11, 20)
	Utility.Wait(time)
	CondiExp_util.SmoothSetExpression(act,12,0)
	Utility.Wait(1)
	CondiExp_util.resetPhonemesSmooth(act)
	act.ClearExpressionOverride()
endfunction

Function Puzzled(int n, Actor act, float time) Global
	CondiExp_util.SmoothSetExpression(act,13,n)
	Utility.Wait(time)
	CondiExp_util.SmoothSetExpression(act,13,0)
	Utility.Wait(1)
	act.ClearExpressionOverride()
endfunction

Function HumanOuch(Actor act) global 
	CondiExp_util.SetPhoneMe(act, 10,100)
	Utility.Wait(0.2)
	CondiExp_util.SetPhoneMe(act, 10, 0)
	Utility.Wait(1)
endfunction
	
Function VampireOuch(Actor act) global
	CondiExp_util.SetPhoneMe(act, 10,60)
	CondiExp_util.SetPhoneMe(act, 9,60)
	CondiExp_util.SetPhoneMe(act, 5,60)

	Utility.Wait(4)
	
	CondiExp_util.SetPhoneMe(act, 10,0)
	CondiExp_util.SetPhoneMe(act, 9,0)
	CondiExp_util.SetPhoneMe(act, 5,0)
	Utility.Wait(1)
EndFunction

Function Headache(Actor act) global
    int i = 0
	CondiExp_util.SmoothSetExpression(act,3,95)
	CondiExp_util.SetModifier(act, 8, 30)
	CondiExp_util.SetModifier(act, 2, 75)
	CondiExp_util.SetModifier(act, 3, 75)
	Utility.Wait(4)
	resetMFGSmooth(act)
endfunction

Function PlayEatingExpression(Actor act) global
	TeethIn(act)
    YumYum(act)
    YumYum(act)
    YumYum(act)
    YumYum(act)
    TeethOut(act)
	resetMFGSmooth(act)
endfunction

Function YumYum(Actor act) global
int i = 0
while i < 44
    CondiExp_util.SetPhonemeFast(act, 0, i)
    i = i + 8
    if (i > 55)
        i = 44
    Endif
    Utility.Wait(0.01)
endwhile

while i > 0
    CondiExp_util.SetPhonemeFast(act, 0, i)
    i = i - 8
    if (i < 0)
      i = 0
    Endif
    Utility.Wait(0.01)
endwhile
endfunction


Function TeethIn(Actor act) global
int i = 0
while i < 25
    CondiExp_util.SetPhonemeFast(act, 12, i)
    i = i + 5
    if (i >25)
     i = 25
    Endif
Utility.Wait(0.01)
endwhile
endfunction


Function TeethOut(Actor act) global
int i = 25
while i > 0
    CondiExp_util.SetPhonemeFast(act, 12, i)
    i = i - 5
    if (i < 0)
    i = 0
    Endif
    Utility.Wait(0.01)
endwhile
CondiExp_util.SetPhonemeFast(act, 12,0)
CondiExp_util.SetPhonemeFast(act, 0,0)
endfunction