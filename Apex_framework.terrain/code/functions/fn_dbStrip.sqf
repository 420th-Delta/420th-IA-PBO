/*/
File: fn_dbStrip.sqf
Author:

	thegamecracks

Last modified:

	4/28/2023 A3 2.12 by thegamecracks

Description:

	Removes all colons from the given string.

Parameters:
	String: The string to filter.

Returns:
	String: The filtered string.
___________________________________________________________________________/*/
// https://github.com/SteezCram/extDB3/blob/master/Optional/legacy/original_source_code/sqf_examples/sqf/fn_strip.sqf
private _chars = toArray _this;
{
	if (_x == 58) then {
		_chars set [_forEachIndex, -1];
	};
} foreach _chars;
_chars = _chars - [-1];
toString _chars;
