/*/
File: fn_isBusyAttached.sqf
Author:

	Quiksilver
	
Last Modified:

	30/10/2023 A3 2.14 by Quiksilver
	
Description:

	Is Player Busy (Something attached to them)
_______________________________________________/*/

params ['_unit'];
attachedObjects _unit findIf {
	!isNull _x
	&& {!(typeOf _x in [
		'#lightpoint',
		'#particlesource',
		'DummyWeapon_Wbk_Melee',		// Improved Melee System
		'hatg_mirror',					// Hide Among The Grass
		'Land_Can_V2_F',				// Advanced Rappelling
		'WBK_BrassKnuckles_LEFTHAND'	// Improved Melee System
	])
	&& {!(_x isKindOf 'Helper_Base_F')
	&& {!(_x isKindOf 'Logic')
	&& {!(_x isKindOf 'LaserTarget')}}}}
} isNotEqualTo -1