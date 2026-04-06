/*
Function: TGC_fnc_addEmptyVehicleHandlers

Description:
    Set up empty vehicle handlers.

Parameters:
    Object vehicle:
        The vehicle to add handlers to.

Author:
    thegamecracks

*/
params ["_vehicle"];
if (!isNil {_vehicle getVariable "TGC_vehicle_emptyEHs"}) exitWith {};

private _damageEH = ["HandleDamage", _vehicle addEventHandler ["HandleDamage", {call {
    params ["_vehicle", "", "", "", "", "_hitIndex"];
    if (side group _vehicle isNotEqualTo sideUnknown) exitWith {}; // occupied
    if (!call TGC_fnc_isFriendlyFire) exitWith {};
    if (_hitIndex >= 0) then {_vehicle getHitIndex _hitIndex} else {damage _vehicle}
}}]];

private _getInEH = ["GetIn", _vehicle addEventHandler ["GetIn", {
    params ["_vehicle", "", "_unit"];
    if (unitIsUAV _vehicle) exitWith {};
    if (_unit isKindOf "B_UAV_AI") exitWith {};
    private _targets = crew _vehicle select {local _x && {_x isKindOf "B_UAV_AI"}};
    {_vehicle deleteVehicleCrew _x} forEach _targets;
}]];

private _getOutEH = ["GetOut", _vehicle addEventHandler ["GetOut", {
    params ["_vehicle", "", "_unit"];
    if (side group _vehicle isNotEqualTo sideUnknown) exitWith {}; // occupied
    if (unitIsUAV _vehicle) exitWith {};
    if (_unit isKindOf "B_UAV_AI") exitWith {};

    private _side = _vehicle getVariable "TGC_vehicle_side";
    if (isNil "_side") exitWith {};

    // For vehicles with two or fewer seats like quadbikes, gunships, and jets,
    // taking up that seat will impede players from entering it.
    //
    // A workaround could be adding an action for players to delete our unit,
    // but it's easier to ignore them and only add units to vehicles with more seats.
    //
    // Note that most vanilla MBTs only have 3 seats.
    if (_vehicle emptyPositions "" < 3) exitWith {};

    private _group = grpNull;
    private _unit = objNull;
    private _createUnit = {
        _group = createGroup [_side, true];
        _unit = _group createUnit ["B_UAV_AI", [0,0,0], [], 0, "CAN_COLLIDE"];
        // [_unit] remoteExec ["TGC_fnc_setFriendlyName", 0, _unit];
        [_unit] joinSilent _group;
        _unit disableAI "ALL";
        _unit
    };

    private _turrets =
        fullCrew [_vehicle, "turret", true]
        select {isNull (_x # 0) && {isNull (_x # 5)}};

    switch (true) do {
        case (_vehicle emptyPositions "Cargo" > 0): {
            call _createUnit moveInCargo _vehicle;
        };
        case (_turrets isNotEqualTo []): {
            call _createUnit moveInTurret [_vehicle, _turrets # 0 # 3];
        };
        case (_vehicle emptyPositions "Commander" > 0): {
            call _createUnit moveInCommander _vehicle;
        };
        case (_vehicle emptyPositions "Gunner" > 0): {
            call _createUnit moveInGunner _vehicle;
        };
        // case (_vehicle emptyPositions "Driver" > 0): {
        //     call _createUnit moveInDriver _vehicle;
        // };
    };

    if (isNull objectParent _unit) then {deleteVehicle _unit}; // move in failed
}]];

_vehicle setVariable ["TGC_vehicle_emptyEHs", [_damageEH, _getInEH, _getOutEH]];
