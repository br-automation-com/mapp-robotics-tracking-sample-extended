(********************************************************************
 * COPYRIGHT -- Bernecker + Rainer
 ********************************************************************
 * Library: AcpInvLib
 * File: AcpInvLib.fun
 * Author: guglielmia
 * Created: October 14, 2011
 ********************************************************************
 * Functions and function blocks of library AcpInvLib
 ********************************************************************)

FUNCTION_BLOCK INVx64_MoveVelocityMap (*FUB Inverter x64 velocity control*)
	VAR_INPUT
		Enable : BOOL; (*Enable FUB*)
		Power : BOOL;
		Run : BOOL;
		UpdateParams : BOOL;
		ReadAllParams : BOOL;
		SpeedRef : REAL;
		Direction : BOOL;
		QuickStop : BOOL;
		Reset : BOOL;
		HardwareReset : BOOL;
		AutoTune : BOOL;
		ParameterMode : DINT; (*Bit 0=Parameters downloaded at startup; Bit 1=Parameters read at startup; .Bit 2=Parameters store in the drive EPROM*)
		WritePar : BOOL;
		ReadPar : BOOL;
		Simulate : BOOL; (*Put the function block in simulation mode, all outputs are simualted*)
		LoadParamsFile : BOOL;
		Param : Inverter_UserPar_TYP;
		Parameters : REFERENCE TO Inverter_Parameter_List_TYP;
		InverterName : STRING[40];
		MapIN : Inverter_MAP_input_TYP;
	END_VAR
	VAR_OUTPUT
		Active : BOOL;
		CommOK : BOOL;
		Ready : BOOL;
		PowerOn : BOOL;
		Error : BOOL;
		ErrorID : UINT;
		DriveError : BOOL;
		DriveErrorID : UINT;
		ErrorInfo : STRING[ACPINV_MAX_PAR_NAME_LEN];
		DriveErrorHex : STRING[ACPINV_MAX_PAR_NAME_LEN];
		ParamsUpdated : BOOL;
		ParamsRead : BOOL;
		RWParDone : BOOL;
		ParamValue : UDINT;
		ParamsFileOK : BOOL;
		Speed : REAL;
		Current : REAL;
		Simulated : BOOL; (*The function block is in simulated mode*)
		MapOUT : Inverter_MAP_OUTPUT_TYP;
	END_VAR
	VAR
		Internal : Internal_x64_MoveVelocity_TYP;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK INVp74_MoveVelocityMap (*FUB Inverter p74 velocity control*)
	VAR_INPUT
		Enable : BOOL;
		Power : BOOL;
		Run : BOOL;
		UpdateParams : BOOL;
		ReadAllParams : BOOL;
		SpeedRef : REAL;
		Direction : BOOL;
		QuickStop : BOOL;
		Reset : BOOL;
		HardwareReset : BOOL;
		AutoTune : BOOL;
		ParameterMode : DINT; (*Bit 0=Parameters downloaded at startup; Bit 1=Parameters read at startup; .Bit 2=Parameters store in the drive EPROM*)
		WritePar : BOOL;
		ReadPar : BOOL;
		Simulate : BOOL; (*Put the function block in simulation mode, all outputs are simualted*)
		LoadParamsFile : BOOL;
		Param : Inverter_UserPar_TYP;
		Parameters : REFERENCE TO Inverter_Parameter_List_TYP;
		InverterName : STRING[40];
		MapIN : Inverter_MAP_input_TYP;
	END_VAR
	VAR_OUTPUT
		Active : BOOL;
		CommOK : BOOL;
		Ready : BOOL;
		PowerOn : BOOL;
		Error : BOOL;
		ErrorID : UINT;
		DriveError : BOOL;
		DriveErrorID : UINT;
		ErrorInfo : STRING[ACPINV_MAX_PAR_NAME_LEN];
		DriveErrorHex : STRING[ACPINV_MAX_PAR_NAME_LEN];
		ParamsUpdated : BOOL;
		ParamsRead : BOOL;
		RWParDone : BOOL;
		ParamValue : UDINT;
		ParamsFileOK : BOOL;
		Speed : REAL;
		Current : REAL;
		Simulated : BOOL; (*The function block is in simulated mode*)
		MapOUT : Inverter_MAP_OUTPUT_TYP;
	END_VAR
	VAR
		Internal : Internal_p74_MoveVelocity_TYP;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK INVp84_MoveVelocityMap (*FUB Inverter p84 velocity control*)
	VAR_INPUT
		Enable : BOOL;
		Power : BOOL;
		Run : BOOL;
		UpdateParams : BOOL;
		ReadAllParams : BOOL;
		SpeedRef : REAL;
		Direction : BOOL;
		QuickStop : BOOL;
		Reset : BOOL;
		HardwareReset : BOOL;
		AutoTune : BOOL;
		ParameterMode : DINT; (*Bit 0=Parameters downloaded at startup; Bit 1=Parameters read at startup; .Bit 2=Parameters store in the drive EPROM*)
		WritePar : BOOL;
		ReadPar : BOOL;
		Simulate : BOOL; (*Put the function block in simulation mode, all outputs are simualted*)
		LoadParamsFile : BOOL;
		Param : Inverter_UserPar_TYP;
		Parameters : REFERENCE TO Inverter_Parameter_List_TYP;
		InverterName : STRING[40];
		MapIN : Inverter_MAP_input_TYP;
	END_VAR
	VAR_OUTPUT
		Active : BOOL;
		CommOK : BOOL;
		Ready : BOOL;
		PowerOn : BOOL;
		Error : BOOL;
		ErrorID : UINT;
		DriveError : BOOL;
		DriveErrorID : UINT;
		ErrorInfo : STRING[ACPINV_MAX_PAR_NAME_LEN];
		DriveErrorHex : STRING[ACPINV_MAX_PAR_NAME_LEN];
		ParamsUpdated : BOOL;
		ParamsRead : BOOL;
		RWParDone : BOOL;
		ParamValue : UDINT;
		ParamsFileOK : BOOL;
		Speed : REAL;
		Current : REAL;
		Simulated : BOOL; (*The function block is in simulated mode*)
		MapOUT : Inverter_MAP_OUTPUT_TYP;
	END_VAR
	VAR
		Internal : Internal_p84_MoveVelocity_TYP;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION GetEnumFromValue : DINT (*Get enumerator number from value*)
	VAR_INPUT
		Value : UINT;
		EnumName : UINT;
	END_VAR
END_FUNCTION

FUNCTION GetValueFromEnum : UDINT (*Get value from enumerator*)
	VAR_INPUT
		EnumValue : DINT;
		EnumName : UINT;
	END_VAR
END_FUNCTION

FUNCTION GetInverterState : acp_inverter_state_enu (*Get inverter state from Status Word*)
	VAR_INPUT
		InverterSWord : inverter_SW_typ;
	END_VAR
END_FUNCTION

FUNCTION GetEPLindexFromPar : UINT (*Get Powerlink Index and Sub-Index from parameter name*)
	VAR_INPUT
		InverterType : USINT;
		ParName : STRING[16];
		pSubIndex : REFERENCE TO USINT;
		pSize : REFERENCE TO UDINT;
	END_VAR
END_FUNCTION

FUNCTION DecToHex : BOOL (*Converts Decimal value to hex string*)
	VAR_INPUT
		Value : UDINT;
		Out : UDINT;
	END_VAR
	VAR
		locValue : UDINT;
		loc : USINT;
		Find : BOOL;
		car1 : USINT;
		car : USINT;
		strcar : STRING[10];
		result : STRING[10];
	END_VAR
END_FUNCTION

FUNCTION ReplaceInString : UDINT (*Replace all subString in source string*)
	VAR_INPUT
		SourceString : STRING[40];
		StringSearch : STRING[10];
		StringReplace : STRING[10];
	END_VAR
	VAR
		loc : DINT;
		result : STRING[40];
		found : UINT;
	END_VAR
END_FUNCTION

FUNCTION RightCutString : UDINT (*Right cut of a string*)
	VAR_INPUT
		SourceString : STRING[40];
		CharSearch : STRING[1];
		Result : UDINT;
	END_VAR
	VAR
		pRes : REFERENCE TO STRING[40];
		found : UINT;
	END_VAR
END_FUNCTION
