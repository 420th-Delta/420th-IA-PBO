/*
Function: TGC_fnc_isFriendlyFire

Description:
    Check if the given damage should be considered friendly fire.
    Parameters are the same as those passed to the HandleDamage EH.
    https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#HandleDamage

Author:
    thegamecracks

*/
params ["_unit", "", "", "_source", "_projectile", "", "_instigator"];

private _sideA = side group _unit;
private _sideB = side group _instigator;
if (_sideA isEqualTo sideUnknown) then {_sideA = _unit getVariable ["TGC_vehicle_side", sideUnknown]};

_sideA isEqualTo _sideB
