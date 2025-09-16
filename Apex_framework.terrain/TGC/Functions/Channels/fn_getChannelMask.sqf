/*
Function: TGC_fnc_getChannelMask

Description:
    Get a channel mask.
    If a channel does not yet have a mask defined, the default value
    [true, true] is returned instead.

Parameters:
    Number channel:
        The channel to return a mask in the format [text, von].
        If -1 is passed, all masks are returned in the format
        [[id, [text, von]], ...], not including default values.

Returns:
    Array

Author:
    thegamecracks

*/
params ["_channel"];
if (isNil "TGC_channels_masks") then {TGC_channels_masks = []};
if (_channel < 0) exitWith {+TGC_channels_masks};

private _index = TGC_channels_masks findIf {_x # 0 isEqualTo _channel};
if (_index >= 0) then {TGC_channels_masks # _index # 1} else {[true, true]}
