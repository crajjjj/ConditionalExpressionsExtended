Scriptname CondiExp_Followers extends ReferenceAlias

Quest Property this_quest Auto
CondiExp_StartMod Property sm Auto
condiexp_MCM Property config auto
GlobalVariable Property Condiexp_Verbose Auto
GlobalVariable Property Condiexp_FollowersUpdateInterval Auto
Actor Property PlayerRef Auto

Import Utility
Import CondiExp_Expression_Util
Import CondiExp_util
Import CondiExp_log

int additionalLagSmall = 3
int distanceCounter = 6
int additionalLag = 10
int additionalLagBig = 30
bool firstRun = true
Actor act
float lastPosX
float lastPosY
float lastPosZ
float restartDistance = 300.0

;only for player actor
Event OnPlayerLoadGame()
        log("CondiExp_NPCs OnPlayerLoadGame.Actor: " + act.GetLeveledActorBase().GetName())
        lastPosX = PlayerRef.GetPositionX()
        lastPosY = PlayerRef.GetPositionY()
        lastPosZ = PlayerRef.GetPositionZ()
        ResetQuest(this_quest)
EndEvent

Event OnInit()
	    lastPosX = PlayerRef.GetPositionX()
        lastPosY = PlayerRef.GetPositionY()
        lastPosZ = PlayerRef.GetPositionZ()
        RegisterForSingleUpdate(Condiexp_FollowersUpdateInterval.GetValueInt() + additionalLagSmall)
EndEvent

Event OnUpdate()
	int verboseInt = Condiexp_Verbose.GetValueInt()
	act = self.GetActorReference()
	If (!act)
		trace_line("Actor was removed" , verboseInt)
		TryToClear()
		act = None
		Return
	EndIf
	;trace(act, "CondiExp_Followers OnUpdate" , verboseInt)
	; log("CondiExp_Followers OnUpdate. Actor: " + act.GetLeveledActorBase().GetName())
	If (config.CondiExpFollowerQuest.IsStopped())
		trace(act, "NPCs quest was stopped" , verboseInt)
		TryToClear()
		act = None
		Return
	EndIf
	Actor playerSpeechTargetAct = MfgConsoleFuncExt.GetPlayerSpeechTarget()
	;restart flow for player reference only
    If act == PlayerRef
            if firstRun
                    lastPosX = PlayerRef.GetPositionX()
                    lastPosY = PlayerRef.GetPositionY()
                    lastPosZ = PlayerRef.GetPositionZ()
                    RegisterForSingleUpdate(Condiexp_FollowersUpdateInterval.GetValueInt() + additionalLagBig)
                    firstRun = false
                    trace(act, "NPCsQuest: init" , verboseInt)
                    Return
            else
                    float dx = PlayerRef.GetPositionX() - lastPosX
                    float dy = PlayerRef.GetPositionY() - lastPosY
                    float dz = PlayerRef.GetPositionZ() - lastPosZ
                    float distMoved = Math.Sqrt(dx*dx + dy*dy + dz*dz)
					bool needRestart = distMoved > restartDistance  && !isInDialogueMFG(act) && !sm.checkIfModShouldBeSuspendedForNPCs(act, playerSpeechTargetAct) 
                    if needRestart
                            verbose(act, "NPCsQuest: refresh" , verboseInt)
                            firstRun = true
                            lastPosX = PlayerRef.GetPositionX()
                            lastPosY = PlayerRef.GetPositionY()
                            lastPosZ = PlayerRef.GetPositionZ()
                            ResetQuest(this_quest)
                            Return
                    else
                            RegisterForSingleUpdate(Condiexp_FollowersUpdateInterval.GetValueInt() + additionalLag)
                            Return
                    endif
            endif
    EndIf


	float dist = act.GetDistance(PlayerRef)
	If (dist > 1024)
		if (distanceCounter <= 0)
			verbose(act, "Actor is too far for too long. Removing", verboseInt)
			TryToClear()
			act = None
			return
		else
			trace(act, "Actor is too far. Counter:" + distanceCounter, verboseInt)
			distanceCounter = distanceCounter - 1
			RegisterForSingleUpdate(Condiexp_FollowersUpdateInterval.GetValueInt() + additionalLagSmall)
			return
		endif
	Else
		distanceCounter = 6
	EndIf

	bool inDialogue = isInDialogue(act, false, playerSpeechTargetAct)
	bool mouthOpen = sm.pctracking.checkMouthWearable(act)
	
	If (sm.checkIfModShouldBeSuspendedForNPCs(act, playerSpeechTargetAct))
		trace(act, "Suspending on condition" , verboseInt)
		mfgCleanup(act, inDialogue, mouthOpen)
		RegisterForSingleUpdate(Condiexp_FollowersUpdateInterval.GetValueInt() + additionalLagBig)
		return
	endif
	If (mouthOpen)
		trace(act, " is gagged" , verboseInt)
	EndIf
		
	;trace(act, "Followup" , verboseInt)
	mfgCleanup(act, inDialogue, mouthOpen)
	bool isMale = (act.GetLeveledActorBase().GetSex() == 0)

	If (act.IsDead())
		If (RandomInt(0, 1))
			SmoothSetModifier(act, 6, 7, RandomInt(80, 100))
			SmoothSetModifier(act, 11, -1, 100)
			If (!mouthOpen)
				SmoothSetPhoneme(act, 2, 50)
				SmoothSetPhoneme(act, 11, 100)
			EndIf
			SmoothSetModifier(act, 0, 1, RandomInt(20, 50))
		Else
			SmoothSetModifier(act,4, 5, RandomInt(0, 100))
			SmoothSetModifier(act, 0, 1, 90)
		EndIf
		trace(act, "Dead", verboseInt)
		TryToClear()
		act = None
		Return
	EndIf

	If (act.GetSleepState() == 3)
		If (GetModifier(act, 0) != 90)
			SmoothSetModifier(act, 0, 1, 90)
		EndIf
		RegisterForSingleUpdate(Condiexp_FollowersUpdateInterval.GetValueInt())
		Return
	EndIf

	If (act.GetActorValuePercentage("Health") < 0.40 && config.Condiexp_GlobalPain.GetValueInt() == 1)
		trace(act, "Pain", verboseInt)
		PlayPainExpression(act, config.painExpr)
		If (sm.isSendArousalEventsEnabled())
			SendSLAModEvent(sm.arousalPainThreshold, sm.arousalPain, "is not feeling aroused because of pain", act, "CondiExpPain")
		EndIf
		RegisterForSingleUpdate(Condiexp_FollowersUpdateInterval.GetValueInt() + 3)
		Return
	EndIf
	
	;Combat Anger
	If (act.IsInCombat() && act.GetActorValuePercentage("Health") >= 0.40 && act.GetActorValuePercentage("Stamina") > 0.6 && config.Condiexp_GlobalCombat.GetValueInt() == 1)
		trace(act, "Anger", verboseInt)
		SmoothSetExpression(act, 15, RandomInt(35, 80))
		Utility.Wait(5)
		mfgCleanup(act, inDialogue, mouthOpen)
		RegisterForSingleUpdate(Condiexp_FollowersUpdateInterval.GetValueInt())
		Return
	EndIf
	
	If (act.GetActorValuePercentage("Stamina") < 0.6 && act.GetActorValuePercentage("Health") >= 0.40 && config.Condiexp_GlobalStamina.GetValueInt() == 1 && !mouthOpen)
		;random skip 20%
		Int randomSkip = Utility.RandomInt(1, 10)
		if randomSkip > 2
			trace(act, "Fatigue: Effect: Breathing", verboseInt)
			Breathe(act, false)
			Utility.Wait(1)
			Breathe(act, false)
			Utility.Wait(1)
			Breathe(act, true)
			RegisterForSingleUpdate(Condiexp_FollowersUpdateInterval.GetValueInt())
			Return
		endif
	EndIf

	if !isMale
		int trauma = sm.getTraumaStatus(act)
		bool traumaPlayed = false
		If (trauma > 0)
			traumaPlayed = PlayTraumaExpression( act, trauma, config.traumaExpr)
			if traumaPlayed
				mfgCleanup(act, inDialogue, mouthOpen)
				RegisterForSingleUpdate(Condiexp_FollowersUpdateInterval.GetValueInt())
				Return
			endif
		EndIf
	endif
	
	int dirty = sm.getDirtyStatus(act)
	bool dirtyPlayed = false
	If (dirty > 0)
		dirtyPlayed = PlayDirtyExpression( act, dirty, config.dirtyExpr)
		if dirtyPlayed
			Utility.Wait(5)
			mfgCleanup(act, inDialogue, mouthOpen)
			RegisterForSingleUpdate(Condiexp_FollowersUpdateInterval.GetValueInt())
			Return
		endif
	EndIf
	
	if !isMale
		int aroused = sm.getArousalStatus(act)
		bool arousedPlayed = false
		If (aroused > 0 && !isMale)
			arousedPlayed = PlayArousedExpression( act, aroused, config.arousalExpr)
			if arousedPlayed
				Utility.Wait(2)
				resetPhonemesSmooth(act)
				Utility.Wait(RandomNumber(config.Condiexp_PO3ExtenderInstalled.getValue() == 1, 2, 6))
				mfgCleanup(act, inDialogue, mouthOpen)
				RegisterForSingleUpdate(Condiexp_FollowersUpdateInterval.GetValueInt())
				Return
			endif
		EndIf
	endif
	
	If (config.Condiexp_GlobalRandom.GetValueInt() == 1)
		int rel = act.GetRelationshipRank(PlayerRef)
		RelationshipRankEmotion(act, config, config.randomExpr, rel, mouthOpen)
		Int Seconds = RandomNumber(config.Condiexp_PO3ExtenderInstalled.getValue() == 1, 1, 5)
		Utility.Wait(Seconds)
		mfgCleanup(act, inDialogue, mouthOpen)
	EndIf
	
	RegisterForSingleUpdate(Condiexp_FollowersUpdateInterval.GetValueInt())
EndEvent