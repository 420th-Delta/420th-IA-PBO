if (!isDedicated) exitWith {};
compileScript ['@Apex_cfg\please_enable_filePatching.sqf',TRUE];
call (compileScript ['@Apex_cfg\parameters.sqf']);
0 spawn (missionNamespace getVariable 'QS_fnc_config');
