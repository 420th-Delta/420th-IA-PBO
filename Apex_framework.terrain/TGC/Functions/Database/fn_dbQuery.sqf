/*/
File: fn_dbQuery.sqf
Author:

	thegamecracks

Last modified:

	4/28/2023 A3 2.12 by thegamecracks

Description:

	Runs the given prepared statement asynchronously
	and returns its result.

Parameters:
	[_function,_args,_wait]
	String _function: The function to run.
	Array _args:
		The arguments to pass to the function.
		Note that nested arrays must be turned into strings beforehand.
	Boolean _wait: (default: true)
		If enabled, waits for the query to return a response.
		This requires the script to be running in scheduled envrionment.

Returns:
	Whatever response was given, or an empty string if `_wait` is false.
___________________________________________________________________________/*/
// https://github.com/SteezCram/extDB3/blob/master/Optional/legacy/original_source_code/sqf_examples/sqf/fn_async_custom.sqf
params ["_function", ["_args", []], ["_wait", true]];

private _mode = ["1", "2"] select _wait;
private _query = [_function] + (_args apply {str _x call QS_fnc_dbStrip}) joinString ":";
private _args = format ["%1:ina:%2", _mode, _query];
if (QS_missionConfig_dbQueryDebug) then {diag_log format ["fn_dbQuery.sqf: Executing query %1", _query]};
private _key = "extDB3" callExtension _args;

if (!_wait) exitWith {""};
parseSimpleArray _key params ["_type", "_key"];
if (_type isNotEqualTo 2) exitWith {
	throw format ["fn_dbQuery.sqf: Failed to execute query %1 (type %2, data %3)", _query, _type, _key];
};

uisleep random .03;

private _result = "";
for "_i" from 0 to 1 step 0 do {
	private _message = "extDB3" callExtension format ["4:%1", _key];

	if (_message isEqualTo "") exitWith {
		throw format ["fn_dbQuery.sqf: No response received for query %1", _query];
	};

	if (QS_missionConfig_dbQueryDebug) then {
		diag_log format ["fn_dbQuery.sqf: Query %1 received ""%2""", _query, _message];
	};
	_message = parseSimpleArray _message;

	switch (_message # 0) do {
		case 0: {
			throw format ["fn_dbQuery.sqf: Query %1 failed with %2", _query, str (_message # 1)];
			break;
		};
		case 1: {
			_result = _message # 1;
			break;
		};
		case 3: {
			uiSleep 0.1;
		};
		case 5: {
			private _pipe = "extDB3" callExtension format ["5:%1", _key];
			while {_pipe isNotEqualTo ""} do {
				_result = _result + _pipe;
				_pipe = "extDB3" callExtension format ["5:%1", _key];
			};
			_result = parseSimpleArray _result select 1;
			if (QS_missionConfig_dbQueryDebug) then {
				diag_log format [
					"fn_dbQuery.sqf: Query %1 received multipart ""%2""",
					_query, str _result
				];
			};
			break;
		};
		default {
			throw format ["fn_dbQuery.sqf: Unexpected response %1 for query %2", _message, _query];
			break;
		};
	};
};
_result;
