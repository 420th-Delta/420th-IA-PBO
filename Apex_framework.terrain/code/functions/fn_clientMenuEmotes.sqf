/*/
File: fn_clientMenuEmotes.sqf
Author:
	
	Quiksilver
	
Last Modified:

	21/02/2025 A3 2.18 by Quiksilver

Description:

	Emotes Menu
__________________________________________________________/*/

params ['_type','_display'];
if (_type isEqualTo 'onLoad') exitWith {
    disableSerialization;
    _idcListbox = 1804;
    _idcSelect = 1810;
    _idcShow = 1811;
    _listBox = _display displayCtrl _idcListbox;
    _buttonSelect = _display displayCtrl _idcSelect;
    _buttonSelect ctrlEnable FALSE;
    _buttonShow = _display displayCtrl _idcShow;
    private _list = QS_emotes_list;
    if (_list isEqualTo []) exitWith {
        50 cutText [localize 'STR_QS_Text_500','PLAIN DOWN',0.3];	
    };
    {
        _listBox lnbAddRow [''];
        _listBox lnbSetPicture [[_forEachIndex,0],_x];
    } forEach _list;
    private _selectedIndex = 0;
    _listBox lnbSetCurSelRow _selectedIndex;
    _listBoxEH1 = _listBox ctrlAddEventHandler ['LBDblClick',{
        params ['_control','_selectedIndex'];
        ['Select',ctrlParent _control] call (missionNamespace getVariable 'QS_fnc_clientMenuEmotes');
    }];
    localNamespace setVariable ['QS_menu_emotes_selectedIndex',_selectedIndex];
    ctrlSetFocus _listBox;
    _showText = {
        if (!(missionNamespace getVariable ['QS_missionConfig_emotes',TRUE])) exitWith {
            (localize 'STR_QS_Text_504')
        };
        if (localNamespace getVariable ['QS_emotes_enabled',TRUE]) exitWith {
            (localize 'STR_QS_Text_505')
        };
        if (!(localNamespace getVariable ['QS_emotes_enabled',TRUE])) exitWith {
            (localize 'STR_QS_Text_506')
        };
        ''
    };
    _selectText = {
        if (!(missionNamespace getVariable ['QS_missionConfig_emotes',TRUE])) exitWith {
            (localize 'STR_QS_Text_504')
        };
        if (diag_tickTime < (localNamespace getVariable ['QS_menu_emotes_cooldown',-1])) exitWith {
            _text = format [
                '%1',
                ([((localNamespace getVariable ['QS_menu_emotes_cooldown',-1]) - diag_tickTime) max 0,'SS.MS'] call BIS_fnc_secondsToString)
            ];
            _text
        };
        (localize 'STR_QS_Dialogs_066')
    };
    _conditionSelectEnabled = {
        (
            (diag_tickTime > (localNamespace getVariable ['QS_menu_emotes_cooldown',-1])) &&
            ((lifeState focusOn) in ['HEALTHY','INJURED','INCAPACITATED'])
        )
    };
    _conditionExit = {
        FALSE
    };
    for '_z' from 0 to 1 step 0 do {
        uiSleep (diag_deltaTime * 3);
        if ((lnbCurSelRow _listBox) isNotEqualTo _selectedIndex) then {
            _selectedIndex = lnbCurSelRow _listBox;
            {
                localNamespace setVariable _x;
            } forEach [
                ['QS_menu_emotes_selectedIndex',_selectedIndex]
            ];
        };
        _buttonSelect ctrlSetText (call _selectText);
        _buttonSelect ctrlEnable (call _conditionSelectEnabled);
        _buttonShow ctrlSetText (call _showText);
        if (call _conditionExit) exitWith {};
        if (isNull _display) exitWith {};
    };
    _listBox ctrlRemoveEventHandler ['LBDblClick',_listBoxEH1];
    if (!isNull (uiNamespace getVariable ['QS_display_emotes',displayNull])) then {
        (uiNamespace getVariable ['QS_display_emotes',displayNull]) closeDisplay 2;
        uiNamespace setVariable ['QS_display_emotes',displayNull];
    };
};
if (_type isEqualTo 'Select') exitWith {
    if (diag_tickTime < (localNamespace getVariable ['QS_menu_emotes_cooldown',-1])) exitWith {
        _text = format [localize 'STR_QS_Text_501',([((localNamespace getVariable ['QS_menu_emotes_cooldown',-1]) - diag_tickTime) max 0,'SS.MS'] call BIS_fnc_secondsToString)];
        50 cutText [_text,'PLAIN DOWN',0.5];
    };
    localNamespace setVariable ['QS_menu_emotes_cooldown',diag_tickTime + 5];
    if ((localNamespace getVariable ['QS_menu_emotes_selectedIndex',-1]) isNotEqualTo -1) then {
        player setVariable ['QS_unit_emote',(localNamespace getVariable ['QS_menu_emotes_selectedIndex',-1]),TRUE];
    };
};
if (_type isEqualTo 'Hide') exitWith {
    if (localNamespace getVariable ['QS_emotes_enabled',TRUE]) then {
        localNamespace setVariable ['QS_emotes_enabled',FALSE];
        missionProfileNamespace setVariable ['QS_emotes_enabled',FALSE];
        50 cutText [localize 'STR_QS_Text_503','PLAIN',0.5];
    } else {
        localNamespace setVariable ['QS_emotes_enabled',TRUE];
        missionProfileNamespace setVariable ['QS_emotes_enabled',TRUE];
        50 cutText [localize 'STR_QS_Text_502','PLAIN',0.5];
    };
    saveMissionProfileNamespace;
};
if (_type isEqualTo 'init_system') exitWith {
    private _emotesList = (call QS_data_emotes_1) select { fileExists _x };
    if (_emotesList isNotEqualTo []) then {
        _emotesList = _emotesList apply { getMissionPath _x };
    };
    missionNamespace setVariable ['QS_emotes_list',_emotesList,FALSE];
    localNamespace setVariable ['QS_emotes_enabled',(missionProfileNamespace getVariable ['QS_emotes_enabled',TRUE])];
    localNamespace setVariable ['QS_missionConfig_emotes',(missionNamespace getVariable ['QS_missionConfig_emotes',TRUE])];
};