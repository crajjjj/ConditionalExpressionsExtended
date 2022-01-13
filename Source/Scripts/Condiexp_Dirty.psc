Scriptname Condiexp_Dirty extends ActiveMagicEffect  
import CondiExp_log
import CondiExp_util
Import mfgconsolefunc

GlobalVariable Property Condiexp_CurrentlyBusy Auto
GlobalVariable Property Condiexp_CurrentlyDirty Auto
Actor Property PlayerRef Auto
GlobalVariable Property Condiexp_Verbose Auto

bool playing = false

;dirty is not strong emotion and can be overridden by pain etc
Event OnEffectStart(Actor akTarget, Actor akCaster)
	Condiexp_CurrentlyBusy.SetValue(1)
	playing = true
	Int Seconds = Utility.RandomInt(2, 4)
	Utility.Wait(Seconds)
	trace("Condiexp_Dirty OnEffectStart")
	ShowExpression() 
EndEvent


Function ShowExpression() 
    Int dirty = Condiexp_CurrentlyDirty.GetValue() as Int

	Utility.Wait(1)
	
	Int power = 100

	;random skip 33%
	Int randomSkip = Utility.RandomInt(1, 10)
	if randomSkip > 3
		verbose("Condiexp_Dirty playing effect: " + dirty, Condiexp_Verbose.GetValue() as Int )
    	_sadVariants(dirty, PlayerRef, power, power)
	else
		verbose("Condiexp_Dirty skipping effect: " + dirty, Condiexp_Verbose.GetValue() as Int )
	endif

	Int randomLook = Utility.RandomInt(1, 10)
	If randomLook == 2
		LookLeft(50, PlayerRef)
	ElseIf randomLook == 4
		LookRight(50, PlayerRef)
	ElseIf randomLook == 8
		LookDown(50, PlayerRef)
	endif
	Utility.Wait(7)
	playing = false
EndFunction


Event OnEffectFinish(Actor akTarget, Actor akCaster)
	; keep script running
	int safeguard = 0
	While (playing && safeguard <= 30)
		Utility.Wait(1)
		safeguard = safeguard + 1
	EndWhile
	resetMFGSmooth(PlayerRef)
	verbose("Condiexp_Dirty OnEffectFinish.Time: " + safeguard, Condiexp_Verbose.GetValue() as Int)
	Utility.Wait(3)
	Condiexp_CurrentlyBusy.SetValue(0)
EndEvent

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

Function _sadVariants(Int index, Actor act, int Power, int PowerCur)
	Int expression = Utility.RandomInt(1, index)

	if expression == 1
	
		SmoothSetExpression(act, 3, 30, 0)
		SmoothSetPhoneme(act,2,100)
	
	elseIf expression == 2
	
		SmoothSetModifier(act,2,3,50)
		SmoothSetModifier(act,4,5,50)
		SmoothSetModifier(act,12,13,50)

		SmoothSetExpression( act,3, 60, 0)
        SmoothSetPhoneme(act, 1, 10)
		SmoothSetPhoneme(act, 2, 100)
		
	else
		SmoothSetModifier(act,2,3,50)
		SmoothSetModifier(act,4,5,50)

		SmoothSetModifier(act,12,13,50)
		SmoothSetExpression(act,3, 90, 0)
		
		SmoothSetPhoneme(act, 2, 100)
		SmoothSetPhoneme(act, 7, 50)
		SmoothSetPhoneme(act, 1, 10)
	endIf
endFunction