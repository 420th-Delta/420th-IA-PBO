/*/
File: fn_clientArsenal.sqf
Author:

	Quiksilver

Last Modified:

	4/11/2022 A3 2.10 by Quiksilver

Description:

	Setup Client Arsenal
____________________________________________________/*/

params [['_unit',player],['_checkRunningScript',true]];

// Below is a very primitive way of preventing concurrency
// and is prone to race conditions:
// 1. Multiple calls to QS_fnc_clientArsenal will be ignored,
//    potentially missing out on updates if the script is almost done
// 2. This check is not atomic and two scripts can still be spawned at once
if (
	_checkRunningScript
	&& {!isNil 'QS_client_arsenalScript'
	&& {!scriptDone QS_client_arsenalScript}}
) exitWith {
	waitUntil {scriptDone QS_client_arsenalScript};
};
// if (
// 	!_checkRunningScript
// 	&& {!isNil '_thisScript'
// 	&& {!isNil 'QS_client_arsenalScript'
// 	&& {_thisScript isNotEqualTo QS_client_arsenalScript}}}
// ) exitWith {};
if (_checkRunningScript) exitWith {
	QS_client_arsenalScript = [_unit,false] spawn QS_fnc_clientArsenal;
	waitUntil {scriptDone QS_client_arsenalScript};
};

_unit setVariable ['bis_addVirtualWeaponCargo_cargo',[[],[],[],[]],FALSE];

if (QS_missionConfig_Arsenal isEqualTo 3) exitWith {};
private _configRestrictions = getMissionConfigValue ['arsenalRestrictedItems',[]];

// This script can take a long time depending on installed mods
// so we'll record performance statistics per step
private _startTime = diag_tickTime;
private _lastStepTime = _startTime;
private _logDurationThreshold = 1;
private _logStatistics = [];
private _getStepTime = {
	private _time = diag_tickTime;
	private _delta = _time - _lastStepTime;
	_lastStepTime = _time;
	_delta;
};
private _logStep = {
	_logStatistics pushBack [_this,call _getStepTime];
};

/*/ To Do: Implement this instead of the below lists
(call (missionNamespace getVariable 'QS_data_restrictedGear')) params [
	['_restrictedWeapons',[]],
	['_restrictedMagazines',[]],
	['_restrictedItems',[]],
	['_restrictedBackpacks',[]]
];
/*/

private _QS_restrictedItems = [
	'h_helmetleadero_oucamo',
	'h_helmetleadero_ocamo',
	'h_helmetleadero_ghex_f',
	'h_helmeto_oucamo',
	'h_helmeto_ocamo',
	'h_helmeto_ghex_f',
	'h_racinghelmet_1_black_f',
	'h_racinghelmet_1_blue_f',
	'h_racinghelmet_2_f',
	'h_racinghelmet_1_f',
	'h_racinghelmet_1_green_f',
	'h_racinghelmet_1_orange_f',
	'h_racinghelmet_1_red_f',
	'h_racinghelmet_3_f',
	'h_racinghelmet_4_f',
	'h_racinghelmet_1_white_f',
	'h_racinghelmet_1_yellow_f',
	'u_c_idap_man_cargo_f',
	'u_c_idap_man_jeans_f',
	'u_c_idap_man_casual_f',
	'u_c_idap_man_shorts_f',
	'u_c_idap_man_tee_f',
	'u_c_idap_man_teeshorts_f',
	'u_c_driver_1_black',
	'u_c_driver_1_blue',
	'u_c_driver_2',
	'u_c_driver_1',
	'u_c_driver_1_green',
	'u_c_driver_1_orange',
	'u_c_driver_1_red',
	'u_c_driver_3',
	'u_c_driver_4',
	'u_c_driver_1_white',
	'u_c_driver_1_yellow',
	'u_o_t_soldier_f',
	'u_o_combatuniform_ocamo',
	'u_o_combatuniform_oucamo',
	'u_o_fullghillie_ard',
	'u_o_t_fullghillie_tna_f',
	'u_o_fullghillie_lsh',
	'u_o_fullghillie_sard',
	'u_o_t_sniper_f',
	'u_o_ghilliesuit',
	'u_orestesbody',
	'u_o_officer_noinsignia_hex_f',
	'u_o_t_officer_f',
	'u_o_officeruniform_ocamo',
	'u_o_pilotcoveralls',
	'u_o_specopsuniform_ocamo',
	'u_o_v_soldier_viper_f',
	'u_o_v_soldier_viper_hex_f',
	'v_plain_medical_f',
	'v_eod_idap_blue_f',
	'apersminedispenser_mag',
	'integrated_nvg_f',
	'integrated_nvg_ti_0_f',
	'integrated_nvg_ti_1_f',
	'o_uavterminal',
	'i_uavterminal',
	'c_uavterminal',
	'i_e_uavterminal'
];
_QS_restrictedItems append _configRestrictions;
private _QS_restrictedWeapons = [
	'apersminedispenser_mag'
];
private _QS_restrictedMagazines = [
	'apersminedispenser_mag'
];
private _QS_restrictedBackpacks = [
	'weapon_bag_base',
	'o_hmg_01_support_f',
	'i_hmg_01_support_f',
	'o_hmg_01_support_high_f',
	'i_hmg_01_support_high_f',
	'o_hmg_01_weapon_f',
	'i_hmg_01_weapon_f',
	'b_hmg_01_a_weapon_f',
	'o_hmg_01_a_weapon_f',
	'i_hmg_01_a_weapon_f',
	'i_hmg_02_support_f',
	'i_e_hmg_02_support_f',
	//'i_c_hmg_02_support_f',		// These are allowed in Arsenal until BIS fixes the Blufor variant
	'i_g_hmg_02_support_f',
	'i_hmg_02_support_high_f',
	'i_e_hmg_02_support_high_f',
	//'i_c_hmg_02_support_high_f',
	'i_g_hmg_02_support_high_f',
	'i_hmg_02_weapon_f',
	'i_e_hmg_02_weapon_f',
	//'i_c_hmg_02_weapon_f',
	'i_g_hmg_02_weapon_f',
	'i_hmg_02_high_weapon_f',
	'i_e_hmg_02_high_weapon_f',
	//'i_c_hmg_02_high_weapon_f',
	'i_g_hmg_02_high_weapon_f',
	'o_gmg_01_weapon_f',
	'i_gmg_01_weapon_f',
	'b_gmg_01_a_weapon_f',
	'o_gmg_01_a_weapon_f',
	'i_gmg_01_a_weapon_f',
	'o_hmg_01_high_weapon_f',
	'i_hmg_01_high_weapon_f',
	'o_gmg_01_high_weapon_f',
	'i_gmg_01_high_weapon_f',
	'o_mortar_01_support_f',
	'i_mortar_01_support_f',
	'o_mortar_01_weapon_f',
	'i_mortar_01_weapon_f',
	'b_o_parachute_02_f',
	'b_i_parachute_02_f',
	'o_aa_01_weapon_f',
	'i_aa_01_weapon_f',
	'o_at_01_weapon_f',
	'i_at_01_weapon_f',
	'o_uav_01_backpack_f',
	'i_uav_01_backpack_f',
	'b_respawn_tentdome_f',
	'b_respawn_tenta_f',
	'b_respawn_sleeping_bag_f',
	'b_respawn_sleeping_bag_blue_f',
	'b_respawn_sleeping_bag_brown_f',
	'o_static_designator_02_weapon_f',
	'b_patrol_respawn_bag_f',
	'b_messenger_idap_f',
	'c_idap_uav_01_backpack_f',
	'o_uav_06_backpack_f',
	'i_uav_06_backpack_f',
	'c_idap_uav_06_backpack_f',
	'c_uav_06_backpack_f',
	'c_idap_uav_06_antimine_backpack_f',
	'o_uav_06_medical_backpack_f',
	'i_uav_06_medical_backpack_f',
	'c_idap_uav_06_medical_backpack_f',
	'c_uav_06_medical_backpack_f',
	'i_e_mortar_01_support_f',
	'i_e_mortar_01_weapon_f',
	'i_e_hmg_01_support_high_f',
	'i_e_hmg_01_support_f',
	'i_e_gmg_01_a_weapon_f',
	'i_e_hmg_01_a_weapon_f',
	'i_e_hmg_01_high_weapon_f',
	'i_e_hmg_01_weapon_f',
	'i_e_gmg_01_high_weapon_f',
	'i_e_gmg_01_weapon_f',
	'i_e_ugv_02_demining_backpack_f',
	'i_ugv_02_science_backpack_f',
	'o_ugv_02_science_backpack_f',
	'i_e_ugv_02_science_backpack_f',
	'i_e_aa_01_weapon_f',
	'i_e_at_01_weapon_f',
	'i_e_uav_06_backpack_f',
	'i_e_uav_06_medical_backpack_f',
	'i_e_uav_01_backpack_f',
	'c_idap_ugv_02_demining_backpack_f',
	'i_ugv_02_demining_backpack_f',
	'o_ugv_02_demining_backpack_f'
];

private _unitSide = _unit getVariable ['QS_unit_side',WEST];
if (_unitSide in [EAST,RESISTANCE]) then {
	_QS_restrictedItems = _QS_restrictedItems -	[
		'','u_i_c_soldier_bandit_4_f','u_i_c_soldier_bandit_1_f','u_i_c_soldier_bandit_2_f','u_i_c_soldier_bandit_5_f','u_i_c_soldier_bandit_3_f','u_o_t_soldier_f',
		'u_o_combatuniform_ocamo','u_o_combatuniform_oucamo','u_o_fullghillie_ard','u_o_t_fullghillie_tna_f','u_o_fullghillie_lsh','u_o_fullghillie_sard','u_o_t_sniper_f',
		'u_o_ghilliesuit','u_bg_guerrilla_6_1','u_bg_guerilla1_1','u_bg_guerilla1_2_f','u_bg_guerilla2_2','u_bg_guerilla2_1','u_bg_guerilla2_3','u_bg_guerilla3_1','u_bg_leader',
		'u_o_officer_noinsignia_hex_f','u_o_t_officer_f','u_o_officeruniform_ocamo','u_i_c_soldier_para_2_f','u_i_c_soldier_para_3_f','u_i_c_soldier_para_5_f','u_i_c_soldier_para_4_f',
		'u_i_c_soldier_para_1_f','u_o_pilotcoveralls','u_o_specopsuniform_ocamo','u_i_c_soldier_camo_f'
	];
};

_combinedRestrictions = [];
_combinedRestrictions append _QS_restrictedItems;
_combinedRestrictions append _QS_restrictedWeapons;
_combinedRestrictions append _QS_restrictedMagazines;
_combinedRestrictions append _QS_restrictedBackpacks;
QS_arsenal_missionBlacklist = [
	[_QS_restrictedItems,_QS_restrictedWeapons,_QS_restrictedMagazines,_QS_restrictedBackpacks],
	_combinedRestrictions
];
'Define restrictions' call _logStep;

// Optimize membership testing for above restrictions
_combinedRestrictionsMap = createHashMap;
{_combinedRestrictionsMap set [_x,true]} forEach _combinedRestrictions;
'Create restriction hashmap' call _logStep;

_isBlacklisted = QS_missionConfig_Arsenal isEqualTo 2;
if (_isBlacklisted || {QS_missionConfig_Arsenal isEqualTo 0}) then {
	// If using blacklist, we first have to add everything, so we can remove the blacklisted items.

	if (!isNil 'QS_client_arsenalCache') exitWith {
		_unit setVariable ['bis_addVirtualWeaponCargo_cargo',+QS_client_arsenalCache,FALSE];
		'Reuse cached arsenal data' call _logStep;
	};

	private _internalRestrictions = TRUE;		// Caution, leave TRUE unless you know what you're doing. Set FALSE to disable hard-coded restrictions (respawn backpacks, racing + vr uniforms, etc).

	private _configArray = [];
	_configArray append (
		'
		configName _x isKindOf ["ItemCore",configFile >> "CfgWeapons"]
		|| {configName _x isKindOf ["DetectorCore",configFile >> "CfgWeapons"]
		|| {configName _x isKindOf ["NVGoggles",configFile >> "CfgWeapons"]}}
		' configClasses (configFile >> 'CfgWeapons')
	);
	_configArray append (
		'
		getNumber (_x >> "scope") isEqualTo 2
		&& {getNumber (_x >> "isBackpack") isEqualTo 1}
		' configClasses (configFile >> 'CfgVehicles')
	);
	_configArray append (
		'true' configClasses (configFile >> 'CfgGlasses')
	);
	format ['Filter item configs (total: %1)',count _configArray] call _logStep;

	if !(_internalRestrictions) then {
		_combinedRestrictionsMap = createHashMap;
	};

	// Collect item classes (slow!)
	private _cfgItems = createHashMap;
	{
		private _class = _x;
		private _className = configName _class;

		private _scope = if (isNumber (_class >> 'scopeArsenal')) then {
			getNumber (_class >> 'scopeArsenal')
		} else {
			getNumber (_class >> 'scope')
		};
		if (_scope isNotEqualTo 2) then {continue};

		if (getText (_class >> 'model') isEqualTo '') then {continue};

		private _isBase = (
			!(isArray (_class >> 'muzzles'))
			|| {_className call QS_fnc_baseWeapon == _className}
		);
		if (!_isBase) then {continue};

		private _weaponType = _className call BIS_fnc_itemType;
		private _weaponTypeCategory = _weaponType # 0;
		if (_weaponTypeCategory == 'VehicleWeapon') then {continue};

		if (toLowerANSI _className in _combinedRestrictionsMap) then {continue};

		_cfgItems set [_className,true];
	} forEach _configArray;
	_cfgItems = keys _cfgItems;
	format ['Collect item classes (total: %1)',count _cfgItems] call _logStep;

	// Collect weapon classes
	private _cfgWeapons = (
		'
		getNumber (_x >> "scope") isEqualTo 2
		&& {getNumber (_x >> "type") < 5}
		|| getNumber (_x >> "type") isEqualTo 4096
		' configClasses (configFile >> 'CfgWeapons')
	);
	_cfgWeapons = _cfgWeapons select {
		private _name = configName _x;
		(
			!(toLowerANSI _name in _combinedRestrictionsMap)
			&& {_name call QS_fnc_baseWeapon == _name}
		)
	};
	_cfgWeapons = _cfgWeapons apply {configName _x};
	format ['Collect weapon classes (total: %1)',count _cfgWeapons] call _logStep;

	// Collect magazine classes
	private _cfgMagazines = createHashMap;
	{
		private _weaponClass = _x;
		private _weapon = configFile >> 'CfgWeapons' >> _weaponClass;
		{
			private _mag = _x;
			if (toLowerANSI _x in _combinedRestrictionsMap) then {continue};
			_cfgMagazines set [_x,true];
		} forEach (getArray (_weapon >> 'magazines'));
	} forEach _cfgWeapons;
	{
		private _weaponClass = _x;
		private _weapon = configFile >> 'CfgWeapons' >> _weaponClass;
		private _muzzles = getArray (_weapon >> 'muzzles');
		{
			private _muzzle = _x;
			private _magazines = getArray (configFile >> 'CfgWeapons' >> _weaponClass >> _muzzle >> 'magazines');
			{
				if (isClass (configFile >> 'CfgMagazines' >> _x)) then {
					if ((getNumber (configFile >> 'CfgMagazines' >> _x >> 'scope')) isEqualTo 2) then {
						_cfgMagazines set [_x,true];
					};
				};
			} forEach _magazines;
		} forEach _muzzles;
	} forEach ['Throw','Put'];
	_cfgMagazines = keys _cfgMagazines;
	format ['Collect magazine classes (total: %1)',count _cfgMagazines] call _logStep;

	// Collect backpack classes
	private _cfgBackpacks = (
		'
		getNumber (_x >> "scope") >= 1
		&& {getNumber (_x >> "isBackpack") isEqualTo 1}
		' configClasses (configFile >> 'CfgVehicles')
	);
	_cfgBackpacks = _cfgBackpacks select {
		private _name = configName _x;
		(
			!(toLowerANSI _name in _combinedRestrictionsMap)
			&& {_name call QS_fnc_baseBackpack == _name}
		)
	};
	_cfgBackpacks = _cfgBackpacks apply {configName _x};
	format ['Collect backpack classes (total: %1)',count _cfgBackpacks] call _logStep;

	QS_client_arsenalCache = [_cfgItems,_cfgWeapons,_cfgMagazines,_cfgBackpacks];
	_unit setVariable ['bis_addVirtualWeaponCargo_cargo',+QS_client_arsenalCache,FALSE];
};

// Get blacklist/whitelist from arsenal.sqf
private _unitRole = _unit getVariable ['QS_unit_role','rifleman'];
[_unitSide,_unitRole] call QS_data_arsenal params ['_arsenalBlacklist','_arsenalWhitelist'];
(
	[_arsenalWhitelist,_arsenalBlacklist]
	select _isBlacklisted
	params ['_itemsData','_magazines','_backpacks','_weapons']
);

_backpacks = _backpacks select {_x call QS_fnc_baseBackpack == _x};
_weapons = _weapons select {_x call QS_fnc_baseWeapon == _x};
'Get blacklist/whitelist' call _logStep;

private _items = [];
private _goggles = _itemsData # 5;
if (_goggles isNotEqualTo []) then {
	_binGoggles = configFile >> 'CfgGlasses';
	for '_i' from 0 to ((count _binGoggles) - 1) step 1 do {
		private _className = _binGoggles select _i;
		if (isClass _className) then {
			private _goggleClassname = configName _className;
			if (toLowerANSI _goggleClassname in _goggles) then {
				_goggles set [_goggles find (toLowerANSI _goggleClassname),_goggleClassname];
			};
		};
	};
	_itemsData set [5,_goggles];
};
_items append flatten _itemsData;
'Merge blacklist/whitelist' call _logStep;

if (_isBlacklisted) then {
	_cargo = _unit getVariable ['bis_addVirtualWeaponCargo_cargo',[[],[],[],[]]];
	_cargo params ['_cargoItems','_cargoWeapons','_cargoMagazines','_cargoBackpacks'];
	{
		private _class = _x;
		private _foundIndex = _cargoItems findIf {toLowerANSI _x isEqualTo toLowerANSI _class};
		if (_foundIndex isNotEqualTo -1) then {
			_cargoItems deleteAt _foundIndex;
		};
	} forEach _items;
	{
		private _class = configName (configFile >> 'CfgWeapons' >> _x);
		private _foundIndex = _cargoWeapons findIf {toLowerANSI _x isEqualTo toLowerANSI _class};
		if (_foundIndex isNotEqualTo -1) then {
			_cargoWeapons deleteAt _foundIndex;
		};
	} forEach _weapons;
	{
		private _class = configName (configFile >> 'CfgWeapons' >> _x);
		private _foundIndex = _cargoMagazines findIf {toLowerANSI _x isEqualTo toLowerANSI _class};
		if (_foundIndex isNotEqualTo -1) then {
			_cargoMagazines deleteAt _foundIndex;
		};
	} forEach _magazines;
	{
		private _class = _x;
		private _foundIndex = _cargoBackpacks findIf {toLowerANSI _x isEqualTo toLowerANSI _class};
		if (_foundIndex isNotEqualTo -1) then {
			_cargoBackpacks deleteAt _foundIndex;
		};
	} forEach _backpacks;
	_unit setVariable ['bis_addVirtualWeaponCargo_cargo',[_cargoItems,_cargoWeapons,_cargoMagazines,_cargoBackpacks],FALSE];
} else {
	_items = _items select {!(toLowerANSI _x in _combinedRestrictionsMap)};
	_magazines = _magazines select {!(toLowerANSI _x in _combinedRestrictionsMap)};
	_backpacks = _backpacks select {!(toLowerANSI _x in _combinedRestrictionsMap)};
	_weapons = _weapons select {!(toLowerANSI _x in _combinedRestrictionsMap)};
	[_unit,_items,FALSE,FALSE] call BIS_fnc_addVirtualItemCargo;
	[_unit,_magazines,FALSE,FALSE] call BIS_fnc_addVirtualMagazineCargo;
	[_unit,_backpacks,FALSE,FALSE] call BIS_fnc_addVirtualBackpackCargo;
	[_unit,_weapons,FALSE,FALSE] call BIS_fnc_addVirtualWeaponCargo;
};
'Apply blacklist/whitelist' call _logStep;

private _timeElapsed = diag_tickTime - _startTime;
if (_timeElapsed > _logDurationThreshold) then {
	diag_log format ['fn_clientArsenal.sqf took %1 seconds to execute',_timeElapsed];
	{
		_x params ['_message','_time'];
		diag_log format ['%1: %2s',_message,_time];
	} forEach _logStatistics;
};
