/*
Function: TGC_fnc_setFriendlyName

Description:
    Make the given unit show as friendly.
    Allowed only for units of type "B_UAV_AI".

Parameters:
    Object unit:
        The unit to show as friendly.

Author:
    thegamecracks

*/
params ["_unit"];
if !(_unit isKindOf "B_UAV_AI") exitWith {};
_unit setName ["Friendly", "Friendly", ""];
_unit setSpeaker "NoVoice";
