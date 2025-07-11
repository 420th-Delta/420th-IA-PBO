/*/
File: fn_dbWhitelistRefresher.sqf
Author:

	thegamecracks

Last modified:

	2023/10/01 A3 2.12 by thegamecracks

Description:

	Periodically updates the whitelist.
___________________________________________________________________________/*/
for "_i" from 0 to 1 step 0 do {
	try {
		private _whitelists = ["getWhitelists"] call TGC_fnc_dbQuery;
		QS_whitelist_data = createHashMap;
		{
			_x params ["_id", "_role"];
			QS_whitelist_data
				getOrDefaultCall [_role, {createHashMap}, true]
				set [_id, 1];
		} forEach _whitelists;
		publicVariable "QS_whitelist_data";
	} catch {
		diag_log format ["Ignoring exception in fn_dbWhitelistRefresher.sqf: %1", _exception];
	};
	uiSleep QS_missionConfig_dbWhitelistRefreshInterval;
};
