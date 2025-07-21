scriptname CondiExp_BaseExpression extends ReferenceAlias
import CondiExp_log
import CondiExp_util
import PapyrusUtil

string property Name auto
bool property Enabled auto hidden
GlobalVariable Property Condiexp_Verbose Auto
GlobalVariable Property Condiexp_ExpressionStr Auto
GlobalVariable Property Condiexp_ModifierStr Auto
GlobalVariable Property Condiexp_PhonemeStr Auto

; Gender Types
int property Male       = 0 autoreadonly
int property Female     = 1 autoreadonly
; MFG Types
int property Phoneme  = 0 autoreadonly
int property Modifier = 16 autoreadonly
int property Mood     = 30 autoreadonly
; ID loop ranges
int property PhonemeIDs  = 15 autoreadonly
int property ModifierIDs = 13 autoreadonly
int property MoodIDs     = 16 autoreadonly

string property File hidden
	string function get()
		return "../CondiExp/Expression_"+Name+".json"
	endFunction
endProperty

Event OnInit()
	Initialize()
EndEvent

int[] Phases
int[] property PhaseCounts hidden
	int[] function get()
		return Phases
	endFunction
endProperty
int property PhasesMale hidden
	int function get()
		return Phases[Male]
	endFunction
endProperty
int property PhasesFemale hidden
	int function get()
		return Phases[Female]
	endFunction
endProperty

float[] Male1
float[] Male2
float[] Male3
float[] Male4
float[] Male5
float[] Male6
float[] Male7

float[] Female1
float[] Female2
float[] Female3
float[] Female4
float[] Female5
float[] Female6
float[] Female7
; ------------------------------------------------------- ;
; --- Application Functions                           --- ;
; ------------------------------------------------------- ;

function Apply(Actor ActorRef, int PhaseNum, int exprPower)
	If (!Enabled)
		Log("Expressions not loaded. Cannot apply: "+ Name)
		return
	EndIf
	trace(ActorRef,  Name + " .Effect: " + PhaseNum, Condiexp_Verbose.GetValueInt())
	int Gender = ActorRef.GetActorBase().GetSex()
	_ApplyPhase(ActorRef, PickPhase(PhaseNum, Gender), exprPower)
endFunction

function _ApplyPhase(Actor ActorRef, int Phase, int exprPower)
	int Gender = ActorRef.GetActorBase().GetSex()
	if Phase <= Phases[Gender]
		_ApplyPresetFloats(ActorRef, GenderPhase(Phase, Gender), exprPower)
	endIf
endFunction

int function PickPhase(int PhaseNum, int Gender)
	return PapyrusUtil.ClampInt(PhaseNum, 1, Phases[Gender])
endFunction

float[] function SelectPhase(int PhaseNum, int Gender)
	return GenderPhase(PickPhase(PhaseNum, Gender), Gender)
endFunction

function _ApplyPresetFloats(Actor ActorRef, float[] Preset, int exprPower) 
	if !ActorRef || Preset.Length < 32
		return
	endIf
	float exprStrModifier = Condiexp_ExpressionStr.GetValue()
	float modStrModifier = Condiexp_ModifierStr.GetValue()
	float phStrModifier = Condiexp_PhonemeStr.GetValue()
	float randomSpeed = Utility.RandomFloat(0.65, 1.0)
	bool openMouth = false
	if !CondiExp_util.isInDialogueMFG(ActorRef)
		CondiExp_util.ApplyExpressionPreset(ActorRef, Preset, openMouth, exprPower,  exprStrModifier,  modStrModifier,  phStrModifier, randomSpeed)
	else
		trace(ActorRef,  Name + " .Skipping cause dialogue", Condiexp_Verbose.GetValueInt())
		return
	endif
	
endFunction


; ------------------------------------------------------- ;
; --- Phase Accessors                                 --- ;
; ------------------------------------------------------- ;

bool function HasPhase(int Phase, Actor ActorRef)
	if !ActorRef || Phase < 1
		return false
	endIf
	int Gender = ActorRef.GetLeveledActorBase().GetSex()
	return (Gender == 1 && Phase <= PhasesFemale) || (Gender == 0 && Phase <= PhasesMale)
endFunction

float[] function GenderPhase(int Phase, int Gender)
	float[] Preset
	if Gender == Male
		if Phase == 1
			Preset = Male1
		elseIf Phase == 2
			Preset = Male2
		elseIf Phase == 3
			Preset = Male3
		elseIf Phase == 4
			Preset = Male4
		elseIf Phase == 5
			Preset = Male5
		elseIf Phase == 6
			Preset = Male6
		elseIf Phase == 7
			Preset = Male7
		endIf
	else
		if Phase == 1
			Preset = Female1
		elseIf Phase == 2
			Preset = Female2
		elseIf Phase == 3
			Preset = Female3
		elseIf Phase == 4
			Preset = Female4
		elseIf Phase == 5
			Preset = Female5
		elseIf Phase == 6
			Preset = Female6
		elseIf Phase == 7
			Preset = Female7
		endIf
	endIf
	if Preset.Length != 32
		return new float[32]
	endIf
	return Preset
endFunction

float[] function GetPhonemes(int Phase, int Gender)
	float[] Output = new float[16]
	float[] Preset = GenderPhase(Phase, Gender)
	int i
	while i <= PhonemeIDs
		Output[i] = Preset[Phoneme + i]
		i += 1
	endWhile
	return Output
endFunction

float[] function GetModifiers(int Phase, int Gender)
	float[] Output = new float[14]
	float[] Preset = GenderPhase(Phase, Gender)
	int i
	while i <= ModifierIDs
		Output[i] = Preset[Modifier + i]
		i += 1
	endWhile
	return Output
endFunction

int function GetMoodType(int Phase, int Gender)
	return GenderPhase(Phase, Gender)[30] as int
endFunction

int function GetMoodAmount(int Phase, int Gender)
	return (GenderPhase(Phase, Gender)[31] * 100.0) as int
endFunction

int function GetIndex(int Phase, int Gender, int Mode, int id)
	return (GenderPhase(Phase, Gender)[Mode + id] * 100.0) as int
endFunction

; ------------------------------------------------------- ;
; --- System Use                                      --- ;
; ------------------------------------------------------- ;

int function ValidatePreset(float[] Preset)
	if Preset.Length == 32 ; Must be appropiate size
		int i = 31
		while i
			i -= 1
			if Preset[i] > 0.0
				return 1 ; Must have alteast one phoneme or modifier value or expression
			endIf
		endWhile
	endIf
	return 0
endFunction

function CountPhases()
	; Only count the phase if previous phase existed.
	Phases = new int[2]	
	; Male phases
	Phases[0] = ValidatePreset(Male1)
	if Phases[0] == 1
		Phases[0] = Phases[0] + ValidatePreset(Male2)
	endIf
	if Phases[0] == 2
		Phases[0] = Phases[0] + ValidatePreset(Male3)
	endIf
	if Phases[0] == 3
		Phases[0] = Phases[0] + ValidatePreset(Male4)
	endIf
	if Phases[0] == 4
		Phases[0] = Phases[0] + ValidatePreset(Male5)
	endIf
	if Phases[0] == 5
		Phases[0] = Phases[0] + ValidatePreset(Male6)
	endIf
	if Phases[0] == 6
		Phases[0] = Phases[0] + ValidatePreset(Male7)
	endIf
	; Female phases
	Phases[1] = ValidatePreset(Female1)
	if Phases[1] == 1
		Phases[1] = Phases[1] + ValidatePreset(Female2)
	endIf
	if Phases[1] == 2
		Phases[1] = Phases[1] + ValidatePreset(Female3)
	endIf
	if Phases[1] == 3
		Phases[1] = Phases[1] + ValidatePreset(Female4)
	endIf
	if Phases[1] == 4
		Phases[1] = Phases[1] + ValidatePreset(Female5)
	endIf
	if Phases[1] == 5
		Phases[1] = Phases[1] + ValidatePreset(Female6)
	endIf
	if Phases[1] == 6
		Phases[1] = Phases[1] + ValidatePreset(Female7)
	endIf
	; Enable it if phases are present
	Enabled = Phases[0] > 0 || Phases[1] > 0
endFunction


function Initialize()
	Log("initialising base expressions: "+ Name)
	Enabled = false
	; Gender phase counts
	Phases = new int[2]
	; Individual Phases
	Male1   = Utility.CreateFloatArray(0)
	Male2   = Utility.CreateFloatArray(0)
	Male3   = Utility.CreateFloatArray(0)
	Male4   = Utility.CreateFloatArray(0)
	Male5   = Utility.CreateFloatArray(0)
	Male6   = Utility.CreateFloatArray(0)
	Male7   = Utility.CreateFloatArray(0)
	Female1 = Utility.CreateFloatArray(0)
	Female2 = Utility.CreateFloatArray(0)
	Female3 = Utility.CreateFloatArray(0)
	Female4 = Utility.CreateFloatArray(0)
	Female5 = Utility.CreateFloatArray(0)
	Female6 = Utility.CreateFloatArray(0)
	Female7 = Utility.CreateFloatArray(0)

	ImportJson()
	If (Enabled)
		Log("initialising done: "+ Name+". Loaded female expressions:" + Phases[1] + ". Loaded male expressions:" + Phases[0])
	else
		Log("Failed to enable expression profile: "+ File, 2)
	EndIf
endFunction

bool function ImportJson()
	if JsonUtil.GetStringValue(File, "Name") == "" || (JsonUtil.FloatListCount(File, "Female1") != 32 && JsonUtil.FloatListCount(File, "Male1") != 32)
		Log("Failed to import " + File, 2)
		return false
	endIf

	if JsonUtil.FloatListCount(File, "Male1") == 32
		Male1 = new float[32]
		JsonUtil.FloatListSlice(File, "Male1", Male1)
		if Male1[30] > 14 ; Prevent issues with OpenMouth
			Male1[30] = 0
		endIf
	endIf
	if JsonUtil.FloatListCount(File, "Male2") == 32
		Male2 = new float[32]
		JsonUtil.FloatListSlice(File, "Male2", Male2)
		if Male2[30] > 14 ; Prevent issues with OpenMouth
			Male2[30] = 0
		endIf
	endIf
	if JsonUtil.FloatListCount(File, "Male3") == 32
		Male3 = new float[32]
		JsonUtil.FloatListSlice(File, "Male3", Male3)
		if Male3[30] > 14 ; Prevent issues with OpenMouth
			Male3[30] = 0
		endIf
	endIf
	if JsonUtil.FloatListCount(File, "Male4") == 32
		Male4 = new float[32]
		JsonUtil.FloatListSlice(File, "Male4", Male4)
		if Male4[30] > 14 ; Prevent issues with OpenMouth
			Male4[30] = 0
		endIf
	endIf
	if JsonUtil.FloatListCount(File, "Male5") == 32
		Male5 = new float[32]
		JsonUtil.FloatListSlice(File, "Male5", Male5)
		if Male5[30] > 14 ; Prevent issues with OpenMouth
			Male5[30] = 0
		endIf
	endIf
	if JsonUtil.FloatListCount(File, "Male6") == 32
		Male6 = new float[32]
		JsonUtil.FloatListSlice(File, "Male6", Male6)
		if Male6[30] > 14 ; Prevent issues with OpenMouth
			Male6[30] = 0
		endIf
	endIf
	if JsonUtil.FloatListCount(File, "Male7") == 32
		Male7 = new float[32]
		JsonUtil.FloatListSlice(File, "Male7", Male7)
		if Male7[30] > 14 ; Prevent issues with OpenMouth
			Male7[30] = 0
		endIf
	endIf

	if JsonUtil.FloatListCount(File, "Female1") == 32
		Female1 = new float[32]
		JsonUtil.FloatListSlice(File, "Female1", Female1)
		if Female1[30] > 14 ; Prevent issues with OpenMouth
			Female1[30] = 0
		endIf
	endIf
	if JsonUtil.FloatListCount(File, "Female2") == 32
		Female2 = new float[32]
		JsonUtil.FloatListSlice(File, "Female2", Female2)
		if Female2[30] > 14 ; Prevent issues with OpenMouth
			Female2[30] = 0
		endIf
	endIf
	if JsonUtil.FloatListCount(File, "Female3") == 32
		Female3 = new float[32]
		JsonUtil.FloatListSlice(File, "Female3", Female3)
		if Female3[30] > 14 ; Prevent issues with OpenMouth
			Female3[30] = 0
		endIf
	endIf
	if JsonUtil.FloatListCount(File, "Female4") == 32
		Female4 = new float[32]
		JsonUtil.FloatListSlice(File, "Female4", Female4)
		if Female4[30] > 14 ; Prevent issues with OpenMouth
			Female4[30] = 0
		endIf
	endIf
	if JsonUtil.FloatListCount(File, "Female5") == 32
		Female5 = new float[32]
		JsonUtil.FloatListSlice(File, "Female5", Female5)
		if Female5[30] > 14 ; Prevent issues with OpenMouth
			Female5[30] = 0
		endIf
	endIf
	if JsonUtil.FloatListCount(File, "Female6") == 32
		Female6 = new float[32]
		JsonUtil.FloatListSlice(File, "Female6", Female6)
		if Female6[30] > 14 ; Prevent issues with OpenMouth
			Female6[30] = 0
		endIf
	endIf
	if JsonUtil.FloatListCount(File, "Female7") == 32
		Female7 = new float[32]
		JsonUtil.FloatListSlice(File, "Female7", Female7)
		if Female7[30] > 14 ; Prevent issues with OpenMouth
			Female7[30] = 0
		endIf
	endIf

	CountPhases()

	return true
endFunction