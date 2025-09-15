/*
Function: TGC_fnc_initStaffKeybinds

Description:
    Set up keybinds for staff actions.

Parameters:
    String init:
        (Optional, default "")
        The type of initialization this was called from, usually preInit or postInit.
        https://community.bistudio.com/wiki/Arma_3:_Functions_Library

Author:
    thegamecracks
*/
#include "\a3\ui_f\hpp\definedikcodes.inc"
params [["_init", ""]];

if (!hasInterface) exitWith {};
if (_init in ["preInit", "postInit"]) exitWith {
    // Avoid hanging mission loading screen
    [""] spawn TGC_fnc_initStaffKeybinds;
};

waitUntil {!isNull findDisplay 46};
findDisplay 46 displayAddEventHandler ["KeyDown", {
    params ["", "_key", "_shift", "_ctrl", "_alt"];

    // See DIK macros: https://community.bistudio.com/wiki/DIK_KeyCodes
    switch [_key, _shift, _ctrl, _alt] do {
        case [DIK_F2, true, true, false]: {
            call TGC_fnc_staffGUI;
        };
    };

    nil
}];
