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

if (!hasInterface) exitWith {};

addMissionEventHandler ["EntityCreated", {
    params ["_entity"];
    if (!TGC_laserTarget_ignore) exitWith {};
    if (TGC_laserTarget_ignore_skipLocal && {local _entity}) exitWith {};
    if !(_entity isKindOf "LaserTarget") exitWith {};

    private _groups = allGroups select {local _x};
    {_x ignoreTarget _entity} forEach _groups;
}];
