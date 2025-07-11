/*
Function: TGC_fnc_lockDroneByUID

Description:
    Lock a drone from the player to prevent connections to it.
    If executed on server, this becomes persistent on JIP players.
    Function should be remote executed on server and all clients.

Parameters:
    Object drone:
        The drone to be locked.
    String uid:
        The player UID to lock the drone to, or "ALL" to lock for all players.
        If an empty string is passed, the drone will be unlocked.

Author:
    thegamecracks

*/
params ["_drone", "_uid"];

if (isServer) then {_drone setVariable ["TGC_drones_owner", _uid, true]};
if (isNull player) exitWith {};

private _locked = !(_uid in ["", getPlayerUID player]);
if (_locked) then {
    player disableUAVConnectability [_drone, false];
} else {
    player enableUAVConnectability [_drone, false];
};
