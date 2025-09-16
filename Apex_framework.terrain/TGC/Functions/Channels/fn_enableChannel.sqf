/*
Function: TGC_fnc_enableChannel

Description:
    Enable/disable a channel with respect to channel masks.
    TGC_fnc_refreshChannels should be called afterwards to update channels.
    For channels to be restored correctly, this function should
    be called instead of using the enableChannel command directly.

    Channels can be reset by passing -1 as the channel ID to reset all
    channels, or by passing a channel ID and an empty array to reset
    a specific channel. Use caution with this syntax, as this can leave
    channels disabled indefinitely when channel masks are already applied.

Parameters:
    Number channel:
        The channel ID to enable/disable.
        See the enableChannel command for available channels.
        If -1 is passed, all channels are reset to the current values
        returned by the channelEnabled command.
    Array enabled:
        (Optional, default [])
        An array in the format [text, von]].
        If an empty array is passed, the channel is reset to the current value
        returned by the channelEnabled command.
        If channel is -1, this parameter is ignored.

Author:
    thegamecracks

*/
params ["_channel", ["_enabled", []]];

// channelEnabled command currently returns extraneous booleans that throw
// an error when passed back to enableChannel, so we need to discard them.
private _channelEnabled = {channelEnabled _this select [0, 2]};

if (isNil "TGC_channels_enabled" || {_channel < 0}) then {isNil {
    TGC_channels_enabled = [];
    for "_i" from 0 to 15 do {
        TGC_channels_enabled pushBack [_i, _i call _channelEnabled];
    };
}};

if (_channel < 0) exitWith {};
if (_enabled isEqualTo []) then {_enabled = _channel call _channelEnabled};

private _index = TGC_channels_enabled findIf {_x # 0 isEqualTo _channel};
if (_index < 0) exitWith {TGC_channels_enabled pushBack [_channel, _enabled]};
TGC_channels_enabled set [_index, [_channel, _enabled]];
