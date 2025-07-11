/*
Function: TGC_fnc_findLaserInstigators

Description:
    Return a mapping of all laser target instigators from a given side.
    Lasers created locally, i.e. with a netId of "0:0", are not included.

Parameters:
    Side side:
        The side to retrieve laser targets from.

Returns:
    HashMap
        A mapping of laser target net IDs to [vehicle, instigator].

Author:
    thegamecracks

*/
params ["_side"];

private _units = units _side select {isPlayer _x || {unitIsUAV _x}};
private _laserInstigators = createHashMap;
{
    private _vehicle = objectParent _x;
    private _lasers = [];

    _lasers pushBack laserTarget _x;
    _lasers pushBack (_vehicle laserTarget (_vehicle unitTurret _x));

    _lasers =
        _lasers
        select {!isNull _x}
        apply {netId _x}
        select {_x isNotEqualTo "0:0"};

    if (count _lasers < 1) then {continue};

    private _instigator = switch (true) do {
        case (!isNull (UAVControl _vehicle # 0)): {UAVControl _vehicle # 0};
        case (isPlayer _x): {_x};
        case (isPlayer leader _x): {leader _x};
        default {_x};
    };
    private _parents = [vehicle _x, _instigator];

    {_laserInstigators set [_x, _parents]} forEach _lasers;
} forEach _units;

_laserInstigators
