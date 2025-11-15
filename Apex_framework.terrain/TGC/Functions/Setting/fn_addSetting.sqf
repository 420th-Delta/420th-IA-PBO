/*
Function: TGC_fnc_addSetting

Description:
    A proxy for CBA_fnc_addSetting that assigns the default value if CBA
    is not loaded.

Author:
    thegamecracks

*/
if (isClass (configFile >> "CfgPatches" >> "cba_settings")) exitWith {
    _this call CBA_fnc_addSetting
};

params ["_setting", "_settingType", "", "", "_valueInfo", "", ["_script", {}]];

// Derived from:
// https://github.com/CBATeam/CBA_A3/blob/master/addons/settings/fnc_init.sqf
private "_defaultValue";

switch (toUpper _settingType) do {
    case "CHECKBOX": {
        _defaultValue = _valueInfo param [0, false, [false]];
    };
    case "EDITBOX": {
        _valueInfo params [["_default", "", [""]]];
        _defaultValue = _default;
    };
    case "LIST": {
        _valueInfo params [["_values", [], [[]]], "", ["_defaultIndex", 0, [0]]];
        _defaultValue = _values param [_defaultIndex];
    };
    case "SLIDER": {
        _valueInfo params ["", "", ["_default", 0, [0]]];
        _defaultValue = _default;
    };
    case "COLOR": {
        _defaultValue = [_valueInfo] param [0, [1, 1, 1], [[]], [3, 4]];
    };
    case "TIME": {
        _valueInfo params ["", "", ["_default", 0, [0]]];
        _defaultValue = _default;
    };
};

if (isNil "_defaultValue") exitWith {1};
missionNamespace setVariable [_setting, _defaultValue];
_defaultValue call _script;
0
