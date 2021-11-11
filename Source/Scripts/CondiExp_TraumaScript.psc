Scriptname CondiExp_TraumaScript extends ActiveMagicEffect  
import CondiExp_log

Actor Property PlayerRef Auto
GlobalVariable Property Condiexp_CurrentlyBusy Auto
GlobalVariable Property Condiexp_CurrentlyTrauma Auto
Faction Property SexLabAnimatingFaction Auto



Event OnEffectStart(Actor akTarget, Actor akCaster)
	Condiexp_CurrentlyBusy.SetValue(1)
	log("[CE] triggered")

	If Condiexp_CurrentlyTrauma.GetValue() > 0
		RegisterForSingleUpdate(0.01)
	endif

EndEvent

event OnUpdate()
	if (PlayerRef.IsInFaction(SexLabAnimatingFaction))
		return
	endif

    Int sadOrder = Utility.RandomInt(1, 16)
    Int painOrder = Utility.RandomInt(4, 5)
    Int trauma = Condiexp_CurrentlyTrauma.GetValue() as Int

	PlayerRef.ClearExpressionOverride()
	MfgConsoleFunc.ResetPhonemeModifier(PlayerRef)

    If trauma == 0
        MfgConsoleFunc.SetPhoneMe(PlayerRef, 0,0)
        Condiexp_CurrentlyBusy.SetValue(0)
		Condiexp_CurrentlyTrauma.SetValue(0)
        return
    endif

	logAndNotification("[CE] playing anim: " + painOrder)
	_painVariants(painOrder, PlayerRef, trauma*10)
	Utility.Wait(5)
	Int Seconds = Utility.RandomInt(2, 5)
	RegisterForSingleUpdate(Seconds)

EndEvent

function _rollUpAndDownPain(Int index, Actor act, Int Power)
    int i = 0
    while i < Power
    _painVariants(index, act, i)
        i = i + 5
        if (i > Power)
            i = Power
        Endif
        Utility.Wait(0.1)
    endwhile
    Utility.Wait(5)
    i = Power
    while i > 0
    _painVariants(index, act, i)
     i = i - 5
    if (i < 0)
     i = 0
    Endif
    Utility.Wait(0.1)
    endwhile
endFunction

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	log("[CE] OnEffectFinish")
	PlayerRef.ClearExpressionOverride()
	MfgConsoleFunc.ResetPhonemeModifier(PlayerRef)
	Condiexp_CurrentlyBusy.SetValue(0)
EndEvent

Function _painVariants(Int index, Actor act, Int Power)
	if index == 1
		act.SetExpressionOverride(3, Power)
		mfgconsolefunc.SetModifier(act, 2, 10)
		mfgconsolefunc.SetModifier(act, 3, 10)
		mfgconsolefunc.SetModifier(act, 6, 50)
		mfgconsolefunc.SetModifier(act, 7, 50)
		mfgconsolefunc.SetModifier(act, 11, 30)
		mfgconsolefunc.SetModifier(act, 12, 30)
		mfgconsolefunc.SetModifier(act, 13, 30)
		mfgconsolefunc.SetPhoneme(act, 0, 20)
	elseIf index == 2
		act.SetExpressionOverride(8, Power)
		mfgconsolefunc.SetModifier(act, 0, 100)
		mfgconsolefunc.SetModifier(act, 1, 100)
		mfgconsolefunc.SetModifier(act, 2, 100)
		mfgconsolefunc.SetModifier(act, 3, 100)
		mfgconsolefunc.SetModifier(act, 4, 100)
		mfgconsolefunc.SetModifier(act, 5, 100)
		mfgconsolefunc.SetPhoneme(act, 2, 100)
		mfgconsolefunc.SetPhoneme(act, 5, 100)
		mfgconsolefunc.SetPhoneme(act, 11, 40)
	elseIf index == 3
		act.SetExpressionOverride(9, Power)
		mfgconsolefunc.SetModifier(act, 2, 100)
		mfgconsolefunc.SetModifier(act, 3, 100)
		mfgconsolefunc.SetModifier(act, 4, 100)
		mfgconsolefunc.SetModifier(act, 5, 100)
		mfgconsolefunc.SetModifier(act, 11, 90)
		mfgconsolefunc.SetPhoneme(act, 0, 100)
		mfgconsolefunc.SetPhoneme(act, 2, 100)
		mfgconsolefunc.SetPhoneme(act, 11, 40)
	elseIf index == 4
		act.SetExpressionOverride(8, Power)
		mfgconsolefunc.SetModifier(act, 0, 100)
		mfgconsolefunc.SetModifier(act, 1, 100)
		mfgconsolefunc.SetModifier(act, 2, 100)
		mfgconsolefunc.SetModifier(act, 3, 100)
		mfgconsolefunc.SetModifier(act, 4, 100)
		mfgconsolefunc.SetModifier(act, 5, 100)
		mfgconsolefunc.SetPhoneme(act, 2, 100)
		mfgconsolefunc.SetPhoneme(act, 5, 40)
	elseIf index == 5
		act.SetExpressionOverride(9, Power)
		mfgconsolefunc.SetModifier(act, 2, 100)
		mfgconsolefunc.SetModifier(act, 3, 100)
		mfgconsolefunc.SetModifier(act, 4, 100)
		mfgconsolefunc.SetModifier(act, 5, 100)
		mfgconsolefunc.SetModifier(act, 11, 90)
		mfgconsolefunc.SetPhoneme(act, 0, 30)
		mfgconsolefunc.SetPhoneme(act, 2, 30)
	elseIf index == 6
		act.SetExpressionOverride(3, Power)
		mfgconsolefunc.SetModifier(act, 11, 50)
		mfgconsolefunc.SetModifier(act, 13, 14)
		mfgconsolefunc.SetPhoneme(act, 2, 50)
		mfgconsolefunc.SetPhoneme(act, 13, 20)
		mfgconsolefunc.SetPhoneme(act, 15, 40)
	elseIf index == 7
		act.SetExpressionOverride(1, Power)
		mfgconsolefunc.SetModifier(act, 0, 30)
		mfgconsolefunc.SetModifier(act, 1, 20)
		mfgconsolefunc.SetModifier(act, 12, 90)
		mfgconsolefunc.SetModifier(act, 13, 90)
		mfgconsolefunc.SetPhoneme(act, 2, 100)
		mfgconsolefunc.SetPhoneme(act, 5, 80)
	else
		act.SetExpressionOverride(3, Power)
		mfgconsolefunc.SetModifier(act, 0, 30)
		mfgconsolefunc.SetModifier(act, 1, 30)
		mfgconsolefunc.SetModifier(act, 4, 80)
		mfgconsolefunc.SetModifier(act, 5, 80)
		mfgconsolefunc.SetPhoneme(act, 2, 100)
		mfgconsolefunc.SetPhoneme(act, 4, 50)
		mfgconsolefunc.SetPhoneme(act, 5, 100)
	endIf
endFunction
