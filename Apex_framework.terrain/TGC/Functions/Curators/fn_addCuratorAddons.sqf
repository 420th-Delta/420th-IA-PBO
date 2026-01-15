/*
Function: TGC_fnc_addCuratorAddons

Description:
    Add a client's addons to their curator module.
    Function must be remote executed on server from a client.

Parameters:
    Object player:
        The player whose curator module to add addons for.
    Array addons:
        The addons to add to the player's curator module.

Author:
    thegamecracks

*/
params ["_player", "_addons"];
if (!isServer) exitWith {};
if (!isPlayer _player) exitWith {};
if (isMultiplayer && {!isRemoteExecuted}) exitWith {};
if (owner _player isNotEqualTo remoteExecutedOwner) exitWith {};

// WARNING: possible race condition if re-assignment happens during this
private _module = getAssignedCuratorLogic _player;
if (isNull _module) exitWith {};

_module addCuratorAddons _addons;
