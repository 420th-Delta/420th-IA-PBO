/*
Function: TGC_fnc_setChannelMasks

Description:
    Set and apply channel masks.
    To clear all channel masks, pass an empty array to this function.

Parameters:
    Array masks:
        An array in the format [[id, [text, von]], ...].

Author:
    thegamecracks

*/
params ["_masks"];
// TODO: validate remoteExecutedOwner
if (!isNil "TGC_channels_masks" && {TGC_channels_masks isEqualTo _masks}) exitWith {};

TGC_channels_masks = _masks;
[] call TGC_fnc_refreshChannels;

diag_log text format ["%1: Updated to %2", _fnc_scriptName, _masks];
