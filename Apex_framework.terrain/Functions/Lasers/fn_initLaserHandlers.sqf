/*
Function: TGC_fnc_initLaserHandlers

Description:
    Set up laser target handlers.
    Function must be executed in scheduled environment.

Author:
    thegamecracks

*/
// TODO: add stringtable for localization
private _category = "420th Delta";
private _laser = "Laser Designators";
[
    "TGC_laserTarget_ignore",
    "CHECKBOX",
    ["Prevent AI Targeting", "Prevent AI in your group from targeting lasers. Useful for AI gunners in vehicles."],
    [_category, _laser],
    true,
    false,
    {
        // TODO: retroactively apply to existing laser targets
    },
    false
] call TGC_fnc_addSetting;
[
    "TGC_laserTarget_ignore_skipLocal",
    "CHECKBOX",
    ["Allow Local Targets", "When preventing AI targeting, allow AI to target your own lasers."],
    [_category, _laser],
    true,
    false,
    {
        // TODO: retroactively apply to existing laser targets
    },
    false
] call TGC_fnc_addSetting;
[
    "TGC_laserTarget_draw3D",
    "CHECKBOX",
    ["Visualize Laser Targets", "Render 3D icons for laser targets detected by your vehicle's sensors."],
    [_category, _laser],
    true,
    false,
    {},
    false
] call TGC_fnc_addSetting;

if (!hasInterface) exitWith {};

addMissionEventHandler ["EntityCreated", {
    params ["_entity"];
    if (!TGC_laserTarget_ignore) exitWith {};
    if (TGC_laserTarget_ignore_skipLocal && {local _entity}) exitWith {};
    if !(_entity isKindOf "LaserTarget") exitWith {};

    private _groups = allGroups select {local _x};
    {_x ignoreTarget _entity} forEach _groups;
}];

addMissionEventHandler ["Draw3D", {
    if (!TGC_laserTarget_draw3D) exitWith {};

    private _vehicle = objectParent focusOn;
    if (isNull _vehicle) exitWith {};

    assignedVehicleRole focusOn params [["_role", ""]];
    if !(_role in ["driver", "turret"]) exitWith {};

    private _laserTargets =
        getSensorTargets _vehicle
        select {_x # 1 isEqualTo "lasertarget"}
        apply {_x # 0};
    if (count _laserTargets < 1) exitWith {};

    private _side = side group focusOn;
    private _laserInstigators = [_side] call TGC_fnc_findLaserInstigators;
    {
        private _isTarget = cursorTarget isEqualTo _x;
        private _distance = focusOn distanceSqr _x;
        private _size = linearConversion [2500, 6250000, _distance, 1, 0.5, true];

        _laserInstigators
            get netId _x
            params [["_vehicle", objNull], ["_instigator", objNull]];
        if (_vehicle isEqualTo _instigator) then {_vehicle = objNull};

        private _vehicleName = configOf _vehicle call BIS_fnc_displayName;
        private _name = switch (true) do {
            case (isPlayer _instigator): {name _instigator};
            case (!isNull _instigator): {"AI"};
            default {""};
        };
        private _text = switch (true) do {
            case (_vehicleName != "" && {_name != ""}): {format ["%1 (%2)", _vehicleName, _name]};
            case (_vehicleName != ""): {_vehicleName};
            default {_name};
        };

        drawIcon3D [
            "\a3\ui_f_curator\data\cfgcurator\laser_ca.paa",
            [1, 0.2, 0.2, [0.5, 0.9] select _isTarget],
            getPosATL _x,
            _size,
            _size,
            0,
            _text,
            2
        ];
    } forEach _laserTargets;
}];
