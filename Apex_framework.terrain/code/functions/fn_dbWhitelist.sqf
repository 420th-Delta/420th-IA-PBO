/*/
File: fn_dbWhitelist.sqf
Author:

	thegamecracks

Last modified:

	4/30/2023 A3 2.12 by thegamecracks

Description:

	Retrieves whitelisted IDs for the given role,
	acting as a replacement to whitelist.sqf.
___________________________________________________________________________/*/
// Normally whitelist.sqf would return a list, but given that it's only used
// for membership testing, it would be more performant to use a hash map instead
params [["_type", ""]];
if (isNil "QS_whitelist_data") exitWith {createHashMap};
QS_whitelist_data getOrDefaultCall [_type, {createHashMap}];
