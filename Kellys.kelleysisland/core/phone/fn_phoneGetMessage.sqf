#include "..\..\script_macros.hpp"
/*
	Author: Kajetan "Kruk" Mruk
	

	Description:
	Execute received remote execution

	Parameter(s):
	_this select 0: STRING - Packet variable name (always "life_fnc_MP_packet")
	_this select 1: ARRAY - Packet value (sent by life_fnc_MP function; see it's description for more details)
	
	Returns:
	BOOL - true if function was executed successfully
*/
#define msg(var) hint var
_from = _this select 0;
_message = _this select 1;

_contact = [_from] spawn life_fnc_phoneGetContact;

if(count _contact != 0) then {_fromName = _contact select 1;} else {_fromName = _from;}
msg(format["Nowa wiadomosc od: %1\n%2",_fromName,_message]);

life_phone_sms = [life_phone_activeNumber, _from, _message] + life_phone_sms;