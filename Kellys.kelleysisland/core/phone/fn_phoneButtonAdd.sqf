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
#define PHONE_MAIN 61201
#define PHONE_ADDCONTACT 61202
#define PHONE_CONTACTS 61203
#define PHONE_MESSAGES 61204
#define PHONE_CALLS 61205
#define PHONE_SMSSEND 61206
#define PHONE_CHANGE 61207
disableSerialization;

private [];

if(!alive player || !dialog) exitWith {};
//if(HANDCUFFED(player) || ISSURRENDERED(player)) exitWith {}; //ace check if player has his hands free
//if(ISUNCONSCIOUS(player)) exitWith {}; //ace check if player is unconscious

_display = _this select 0;


_dialog = findDisplay _display;

if(life_phone_beingCalled) exitWith {
	life_phone_answered = 1;
	closeDialog 0;
};

switch(_display) do {
	case PHONE_ADDCONTACT: {
		_name = ctrlText 3004;
		_number = ctrlText 3003;
		[_number, _name] call life_fnc_phoneAddContact;
		[_display] call life_fnc_phoneButtonReturn;
	};
	case PHONE_CONTACTS: {
		closeDialog 0;
		[] spawn life_fnc_phoneDialogAddContact;
	};
	case PHONE_CALLS: {
		_list = _dialog displayCtrl 3005;
		_index = lbCurSel _list;
		_number = _list lbData _index;
		closeDialog 0;
		[_number] call life_fnc_phoneDialogAddContact;
	};
	case PHONE_MESSAGES: {
		_list = _dialog displayCtrl 3005;
		_index = lbCurSel _list;
		_number = "";
		{
			if(life_phone_activeCard == _x select 0) then {
				_array = _x select 1;
				if (((_array select _index) select 0) != life_phone_activeNumber) then {
					_number = ((_array select _index) select 0);
				} else {
					_number = ((_array select _index) select 1);
				};
			};
		} forEach life_phone_sms;
		closeDialog 0;
		[_number] call life_fnc_phoneDialogAddContact;
	};
};
life_phone_lastDiaglog = _display;