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

_vehicle setVariable ["TGC_vehicle_emptyEHs", [_damageEH]];
