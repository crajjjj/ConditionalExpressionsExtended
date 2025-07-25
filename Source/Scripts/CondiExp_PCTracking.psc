Scriptname CondiExp_PCTracking extends ReferenceAlias  
import CondiExp_log
import CondiExp_util
Actor Property PlayerRef Auto
Quest Property CondiExpFollowerQuest Auto
CondiExp_StartMod Property sm Auto

GlobalVariable Property Condiexp_Verbose Auto
GlobalVariable Property Condiexp_GlobalEating Auto
Formlist property CondiExp_Drugs Auto
Formlist property CondiExp_Drinks Auto
GlobalVariable Property CondiExp_CurrentlyBusy Auto
GlobalVariable Property Condiexp_CurrentlyBusyImmediate Auto
GlobalVariable Property CondiExp_PlayerIsHigh Auto
GlobalVariable Property CondiExp_PlayerIsDrunk Auto
GlobalVariable Property CondiExp_PlayerJustAte Auto
GlobalVariable Property Condiexp_ModSuspended Auto
GlobalVariable Property Condiexp_Sounds Auto
Keyword Property VendorItemFood Auto
Keyword Property VendorItemIngredient Auto
Keyword Property VendorItemFoodRaw Auto
Race Property KhajiitRace Auto
Race Property KhajiitRaceVampire Auto
Race Property OrcRace Auto
Race Property OrcRaceVampire Auto
Keyword property Vampire Auto

;Devious Devices
MagicEffect vZadGagEffect
Keyword zad_DeviousGag
;Toys
Keyword ToysEffectMouthOpen 
;Zaz
Keyword zbfWornGag
Keyword zbfEffectOpenMouth
;Sunhelm keywords
Keyword _SH_LightFoodKeyword
Keyword _SH_MediumFoodKeyword
Keyword _SH_HeavyFoodKeyword
Keyword _SH_SoupKeyword
Keyword _SH_AlcoholDrinkKeyword

;SLS
Keyword _SLS_TongueKeyword

Event OnInit()
	log("CondiExp_Tracking: Init")
	init()
EndEvent

Event onPlayerLoadGame()
	log("CondiExp_Tracking: Game reload event")
	init()
	If CondiExp_Sounds.GetValueInt() > 0
		sm.NewRace()
	Endif
	RegisterForMenu("Loading Menu")
	sm.RegisterForSingleUpdate(5)
endEvent

Event OnMenuClose(String menuName)
    If menuName == "Loading Menu"
		trace_line("CondiExp_Tracking: OnMenuClose reload event catched", Condiexp_Verbose.GetValueInt())
		If (Condiexp_ModSuspended.GetValueInt() == 0 && (CondiExp_CurrentlyBusy.GetValueInt() > 0 || Condiexp_CurrentlyBusyImmediate.GetValueInt() > 0))
			trace_line("CondiExp_Tracking: OnMenuClose reload triggered", Condiexp_Verbose.GetValueInt())
        	sm.StopMod()
			sm.StartMod()
		EndIf
    Endif 
EndEvent

bool function isSHInitialised()
	return  _SH_LightFoodKeyword && _SH_MediumFoodKeyword && _SH_HeavyFoodKeyword && _SH_SoupKeyword && _SH_AlcoholDrinkKeyword
endfunction

function init()
	if !zad_DeviousGag && isDDassetsReady()
		zad_DeviousGag = Game.GetFormFromFile(0x007EB8, "Devious Devices - Assets.esm") as Keyword 
	endif
	if zad_DeviousGag
		log("CondiExp_Tracking: Found Devious Devices - Assets: " + zad_DeviousGag.GetName() )
	endif
	if !zbfWornGag && isZaZReady() 
		zbfWornGag = Game.GetFormFromFile(0x008A4D, "ZaZAnimationPack.esm") as Keyword 
	endif
	if zbfWornGag
		log("CondiExp_Tracking: Found ZaZAnimationPack: " + zbfWornGag.GetName() )
	endif
	if !zbfEffectOpenMouth && isZaZReady() 
		zbfEffectOpenMouth = Game.GetFormFromFile(0x008A35, "ZaZAnimationPack.esm") as Keyword 
	endif
	if zbfEffectOpenMouth
		log("CondiExp_Tracking: Found ZaZAnimationPack: " + zbfEffectOpenMouth.GetName() )
	endif
	if !ToysEffectMouthOpen && isToysReady()
		ToysEffectMouthOpen = Game.GetFormFromFile(0x0008C2, "Toys.esm") as Keyword
	endif
	if ToysEffectMouthOpen
		log("CondiExp_Tracking: Found Toys: " + ToysEffectMouthOpen.GetName())
	endif
	if !isSHInitialised() && isSunHelmReady()
		_SH_LightFoodKeyword = Game.GetFormFromFile(0xF3DD6D, "SunHelmSurvival.esp") as Keyword
		_SH_MediumFoodKeyword = Game.GetFormFromFile(0xF3DD6E, "SunHelmSurvival.esp") as Keyword 
		_SH_HeavyFoodKeyword = Game.GetFormFromFile(0xF3DD6F, "SunHelmSurvival.esp") as Keyword 
		_SH_SoupKeyword = Game.GetFormFromFile(0xF3DD74, "SunHelmSurvival.esp") as Keyword 
		_SH_AlcoholDrinkKeyword = Game.GetFormFromFile(0xF3DD73, "SunHelmSurvival.esp") as Keyword  
	endif
	if isSHInitialised()
		log("CondiExp_Tracking: Found SunHelm keywords")
	endif

	if !_SLS_TongueKeyword && isSLSurvivalReady()
		_SLS_TongueKeyword = Game.GetFormFromFile(0x0B74B5, "SL Survival.esp") as Keyword 
	endif
	if _SLS_TongueKeyword
		log("CondiExp_Tracking: Found SL Survival: " + _SLS_TongueKeyword.GetName())
	endif
	
endfunction

bool function checkFaceWearables(Form akBaseObject)
	bool result = false
	if zad_DeviousGag && akBaseObject.HasKeyWord(zad_DeviousGag)
		result = true
	endif
	if zbfWornGag && akBaseObject.HasKeyWord(zbfWornGag)
		result = true
	endif
	if zbfEffectOpenMouth && akBaseObject.HasKeyWord(zbfEffectOpenMouth)
		result = true
	endif
	if ToysEffectMouthOpen && akBaseObject.HasKeyWord(ToysEffectMouthOpen)
		result = true
	endif
	if _SLS_TongueKeyword && akBaseObject.HasKeyWord(_SLS_TongueKeyword)
		result = true
	endif
	return result
endfunction

bool function checkIfModShouldBeSuspendedByWearables(Actor act)
	if (zad_DeviousGag && act.WornHasKeyword(zad_DeviousGag))
		log("CondiExp_StartMod: dd gag was detected. Will suspend for actor:" + act.GetLeveledActorBase().GetName() )
		return true
	endif
	if (ToysEffectMouthOpen && act.WornHasKeyword(ToysEffectMouthOpen))
		log("CondiExp_StartMod: ToysEffectMouthOpen keyword was detected. Will suspend for actor:" + act.GetLeveledActorBase().GetName())
		return true
	endif
	if (_SLS_TongueKeyword && act.WornHasKeyword(_SLS_TongueKeyword))
		log("CondiExp_StartMod: _SLS_TongueKeyword keyword was detected. Will suspend for actor:" + act.GetLeveledActorBase().GetName())
		return true
	endif
	if zbfWornGag && act.WornHasKeyword(zbfWornGag)
		log("CondiExp_StartMod: zbfWornGag keyword was detected. Will suspend for actor:" + act.GetLeveledActorBase().GetName())
		return true
	endif
	if zbfEffectOpenMouth && act.WornHasKeyword(zbfEffectOpenMouth)
		log("CondiExp_StartMod: zbfEffectOpenMouth keyword was detected. Will suspend for actor:" + act.GetLeveledActorBase().GetName())
		return true
	endif
	return false
endfunction

bool function checkMouthWearable(Actor act)
	int verboseInt = Condiexp_Verbose.GetValueInt()
	if (zad_DeviousGag && act.WornHasKeyword(zad_DeviousGag))
		trace(act, "CondiExp_StartMod: dd gag was detected", verboseInt)
		return true
	endif
	if (ToysEffectMouthOpen && act.WornHasKeyword(ToysEffectMouthOpen))
		trace(act, "CondiExp_StartMod: ToysEffectMouthOpen keyword was detected", verboseInt)
		return true
	endif
	if (_SLS_TongueKeyword && act.WornHasKeyword(_SLS_TongueKeyword))
		trace(act, "CondiExp_StartMod: _SLS_TongueKeyword keyword was detected", verboseInt)
		return true
	endif
	if zbfWornGag && act.WornHasKeyword(zbfWornGag)
		trace(act, "CondiExp_StartMod: zbfWornGag keyword was detected" , verboseInt)
		return true
	endif
	if zbfEffectOpenMouth && act.WornHasKeyword(zbfEffectOpenMouth)
		trace(act, "CondiExp_StartMod: zbfEffectOpenMouth keyword was detected", verboseInt)
		return true
	endif
	return false
endfunction

bool function checkSHFoodKeywords(Form akBaseObject)
	bool result = false
	if !isSHInitialised()
		return result
	endif
	if  akBaseObject.HasKeyWord(_SH_LightFoodKeyword) || akBaseObject.HasKeyWord(_SH_MediumFoodKeyword) || akBaseObject.HasKeyWord(_SH_HeavyFoodKeyword) || akBaseObject.HasKeyWord(_SH_SoupKeyword)
		result = true
	endif
	return result
endfunction


Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
	If (!sm.isModEnabled())
		log("CondiExp_Tracking: OnObjectEquipped stopped: " + akBaseObject.GetName())
		return
	EndIf
	verbose(PlayerRef, "CondiExp_Tracking: OnObjectEquipped triggered: " + akBaseObject.GetName())
	
	if checkFaceWearables(akBaseObject)
		sm.OnUpdateExecute(PlayerRef)
	endif

	If CondiExp_Drugs.HasForm(akBaseObject)
		CondiExp_PlayerIsHigh.SetValueInt(1)
	elseif  CondiExp_Drinks.HasForm(akBaseObject) 
			log("CondiExp_Tracking: OnObjectEquipped AlcoholDrink: " + akBaseObject.GetName())
			CondiExp_PlayerIsDrunk.SetValueInt(1)
	elseif _SH_AlcoholDrinkKeyword && akBaseObject.HasKeyWord(_SH_AlcoholDrinkKeyword)
			log("CondiExp_Tracking: OnObjectEquipped _SH_AlcoholDrink: " + akBaseObject.GetName())
			CondiExp_PlayerIsDrunk.SetValueInt(1)
	elseif akBaseObject.HasKeyWord(VendorItemFood) || akBaseObject.HasKeyWord(VendorItemFoodRaw)
			CondiExp_PlayerJustAte.SetValueInt(1)
			log("CondiExp_Tracking: OnObjectEquipped VendorItemFood(Raw): " + akBaseObject.GetName())
	elseif akBaseObject.HasKeyword(VendorItemIngredient)
		If  Condiexp_GlobalEating.GetValueInt() == 2
				CondiExp_PlayerJustAte.SetValueInt(1)
				log("CondiExp_Tracking: OnObjectEquipped VendorItemIngredient: " + akBaseObject.GetName())
		elseif Condiexp_GlobalEating.GetValueInt() == 1
				Condiexp_GlobalEating.SetValueInt(2)
				CondiExp_PlayerJustAte.SetValueInt(1)
				log("CondiExp_Tracking: OnObjectEquipped VendorItemIngredient: " + akBaseObject.GetName())
				utility.wait(5)
				Condiexp_GlobalEating.SetValueInt(1)
		endif
	elseif checkSHFoodKeywords(akBaseObject) 
		CondiExp_PlayerJustAte.SetValueInt(1)
		log("CondiExp_Tracking: OnObjectEquipped _SH_Food: " + akBaseObject.GetName())
	Endif
EndEvent

Event OnRaceSwitchComplete()
	If CondiExp_Sounds.GetValueInt() > 0
        log("CondiExp_Tracking: OnRaceSwitchComplete")
		sm.NewRace()
	Endif
EndEvent

