/*
Function: TGC_fnc_refreshChannels

Description:
    Update all enabled channels with respect to channel masks.

Author:
    thegamecracks

*/
if (isNil "TGC_channels_masks") then {TGC_channels_masks = []};
if (isNil "TGC_channels_enabled") then {isNil {
    TGC_channels_enabled = [];
    for "_i" from 0 to 15 do {
        TGC_channels_enabled pushBack [_i, _i call _channelEnabled];
    };
}};

{
    _x params ["_channel", "_enabled"];
    private _mask = [_channel] call TGC_fnc_getChannelMask;
    _enabled = [0, 1] apply {_enabled # _x && {_mask # _x}};
    _channel enableChannel _enabled;
} forEach TGC_channels_enabled;
