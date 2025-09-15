/*
Function: TGC_fnc_isStaff

Description:
    Check if the current player is a staff member.
    If called in scheduled environment, this function will wait until
    the player object is available.

Returns:
    Boolean

Author:
    thegamecracks

*/
if (!hasInterface) exitWith {false};
if (canSuspend && {getPlayerUID player isEqualTo ""}) then {
    waitUntil {getPlayerUID player isNotEqualTo ""};
};

getPlayerUID player in (['ALL'] call QS_fnc_whitelist)
