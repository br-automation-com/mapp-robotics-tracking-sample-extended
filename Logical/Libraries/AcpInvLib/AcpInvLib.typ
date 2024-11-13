(********************************************************************
 * COPYRIGHT -- Bernecker + Rainer
 ********************************************************************
 * Library: AcpInvLib
 * File: AcpInvLib.typ
 * Author: guglielmia
 * Created: October 14, 2011
 ********************************************************************
 * Data types of library AcpInvLib
 ********************************************************************)

TYPE
	Inverter_Parameter_List_TYP : 	STRUCT 
		NamePlate : Inverter_NamePlate_TYP; (*Name Plate of the motor*)
		UserPar : ARRAY[0..ACPINV_MAX_USER_PARAMS]OF Inverter_UserPar_TYP; (*Array for user parameters*)
		ParamsFile : Inverter_ParamsFile_TYP; (*Sub-structure for specify the file of parameters*)
		Autotuning : Inverter_Autotune_TYP; (*Autotuning informations*)
		Acceleration : REAL; (*Acceleration, time to reach the nominal speed [s]*)
		Deceleration : REAL; (*Deceleration, time to stop the motor from nominal speed [s]*)
		MinFrequency : REAL; (*Minimum frequency [Hz]*)
		MaxFrequency : REAL; (*Maximum frequency [Hz]*)
	END_STRUCT;
	Inverter_NamePlate_TYP : 	STRUCT 
		RatedFrequency : REAL; (*[Hz]*)
		RatedVoltage : UINT; (*[V]*)
		RatedCurrent : REAL; (*[A]*)
		RatedSpeed : UINT; (*[rpm]*)
		CosPhi : REAL;
		Resistence : REAL; (*[Ohm]*)
		RatedPower : REAL; (*[W]*)
	END_STRUCT;
	Inverter_Autotune_TYP : 	STRUCT 
		EnableInfo : BOOL; (*INPUT: Enable to read autotuning status*)
		CmdType : DINT; (*INPUT: Type of autotuning you want to perform*)
		ActiveType : DINT; (*OUTPUT: Active type of autotuning*)
		Status : DINT; (*OUTPUT: Status of autotuning*)
		Info : STRING[80]; (*OUTPUT: Text with more detail about status*)
		Resistence : REAL; (*OUTPUT: Resistence calculated if CmdType=ACP_INV_TUNE_GET_RES [ohm]*)
		Inductance : REAL; (*OUTPUT: Inductance calculated if CmdType=ACP_INV_TUNE_GET_RES [H]*)
		MagnetizCurrent : REAL; (*OUTPUT: Magentizing current calculated if CmdType=ACP_INV_TUNE_GET_RES [A]*)
		RotorTimeConst : REAL; (*OUTPUT: Rotor time constant calculated if CmdType=ACP_INV_TUNE_GET_RES [s]*)
		Done : BOOL; (*OUTPUT: Operation done succesfully*)
		WaitPower : BOOL; (*OUTPUT: The procedure wait a movement of the motor*)
	END_STRUCT;
	Inverter_UserPar_TYP : 	STRUCT 
		ParName : STRING[ACPINV_MAX_PAR_NAME_LEN]; (*Parameter name (example: ACC --> Acceleration)*)
		Value : UDINT; (*Value used in case of write*)
	END_STRUCT;
	Inverter_ParamsFile_TYP : 	STRUCT 
		pDevice : UDINT; (*File Device (for more detail, please read FileIO help pages)*)
		pFile : UDINT; (*Name and path of the file to load*)
	END_STRUCT;
	Inverter_MAP_input_TYP : 	STRUCT 
		ModuleOK : BOOL;
		ETAD_Input : UINT;
		LCR_Input : UINT;
		RFRD_Input : INT;
		ERRD_Input : UINT;
	END_STRUCT;
	Inverter_MAP_OUTPUT_TYP : 	STRUCT 
		CMDD_Output : UINT;
		LFRD_Output : INT;
		CMI_Output : UINT;
	END_STRUCT;
END_TYPE

(*--------------------- ENUMERATORS -----------------------------------------------------------------------------------------------------------------*)

TYPE
	acp_inverter_state_enu : 
		(
		ACP_INV_NOT_READY_TO_SWITCH_ON,
		ACP_INV_SWITCH_ON_DISABLED,
		ACP_INV_READY_TO_SWITCH_ON,
		ACP_INV_SWITCHED_ON,
		ACP_INV_OPERATION_ENABLED,
		ACP_INV_MALFUNCTION,
		ACP_INV_MALFUNCITION_REAC_ACTIVE,
		ACP_INV_QUICK_STOP_ACTIVE
		);
	acp_inverter_par_mode_enu : 
		(
		ACP_INV_MODE_STARTUP_READ := 1,
		ACP_INV_MODE_STARTUP_DOWN := 2,
		ACP_INV_MODE_SAVE_PAR := 4
		);
	acp_inverter_autotune_type_enu : 
		(
		ACP_INV_TUNE_DISABLED := 0, (*NO*)
		ACP_INV_TUNE_GET_RES := 1, (*PON*)
		ACP_INV_TUNE_AT_ONCE := 112, (*YES*)
		ACP_INV_TUNE_EVERY_MOV := 114, (*RUN*)
		ACP_INV_TUNE_EVERY_POW := 115, (*PON*)
		ACP_INV_TUNE_LI1 := 116, (*LI1*)
		ACP_INV_TUNE_LI2 := 117, (*LI2*)
		ACP_INV_TUNE_LI3 := 118, (*LI3*)
		ACP_INV_TUNE_LI4 := 119, (*LI4*)
		ACP_INV_TUNE_LI5 := 120, (*LI5*)
		ACP_INV_TUNE_LI6 := 121 (*LI6*)
		);
	acp_inverter_autotune_status_enu : 
		(
		ACP_INV_TUNE_DEFAULT := 0, (*TAB*)
		ACP_INV_TUNE_PENDING := 1, (*PEND*)
		ACP_INV_TUNE_PROGRESS := 2, (*PROG*)
		ACP_INV_TUNE_FAIL := 3, (*FAIL*)
		ACP_INV_TUNE_DONE := 4, (*DONE*)
		ACP_INV_TUNE_ENTERED_R1 := 5 (*STRD*)
		);
END_TYPE

(*--------------------- INTERNAL STRUCTURES --------------------------------------------------------------------------------------------------*)

TYPE
	Internal_x64_MoveVelocity_TYP : 	STRUCT 
		Step : DINT;
		Read_Par : AsIOAccRead;
		Write_Par : AsIOAccWrite;
		TON_Comm : TON;
		TON_Save : TON;
		TON_Tus : TON;
		InitDone : BOOL;
		SWord : UINT;
		CWord : UINT;
		InverterSWord : inverter_SW_typ;
		InverterCWord : inverter_CW_typ;
		InverterState : acp_inverter_state_enu;
		ParamID : UINT;
		ReadValueID : DINT;
		DriveLastErrorID : UINT;
		ErrorReached : UINT;
		C_SpeedRef : REAL;
		C_CWord : UINT;
		C_UpdatePar : BOOL;
		C_ReadAllPar : BOOL;
		C_LoadParamsFile : BOOL;
		UserParID : UINT;
		UserParNameTemp : STRING[ACPINV_MAX_PAR_NAME_LEN];
		UserParName : STRING[ACPINV_MAX_PAR_NAME_LEN];
		UserParValue : UDINT;
		UserParNameInfo : STRING[ACPINV_MAX_PAR_NAME_LEN];
		ParLoopEnd : BOOL;
		CmdHMI : internal_x64_hmi_command_TYP;
		SaveEprom : BOOL;
		ValueWORD : INT;
		ValueUINT : UINT;
		StringNode : STRING[10];
		NodeStr : STRING[10];
		CharPos : DINT;
		i : DINT;
		StopInverter : BOOL;
		FileOpenPar : FileOpen;
		FileClosePar : FileClose;
		FileReadPar : FileRead;
		FileLen : UDINT;
		FileOffset : UDINT;
		FileText : STRING[20];
		FirstSpace : INT;
		FindEnd : INT;
		MyValueStr : STRING[20];
		ProcedureAborted : BOOL;
		C_AutoTune : BOOL;
		TuneCmd : DINT;
		ReadAutoTune : SINT;
		AutoTuneReq : DINT;
		TuneDone : BOOL;
		TuneProgress : BOOL;
		TuneRun : BOOL;
		DriveReset : BOOL;
	END_STRUCT;
	internal_x64_hmi_command_TYP : 	STRUCT 
		Read_Par : AsIOAccRead;
		Write_Par : AsIOAccWrite;
		WritePar : BOOL;
		ReadPar : BOOL;
		Param : Inverter_UserPar_TYP;
		Step : DINT;
		RWParDone : BOOL;
		SaveEprom : BOOL;
		Reset : BOOL;
		Error : BOOL;
		ErrorID : UINT;
		UserParNameTemp : STRING[ACPINV_MAX_PAR_NAME_LEN];
		UserParName : STRING[ACPINV_MAX_PAR_NAME_LEN];
		UserParValue : UDINT;
		ParamValue : UDINT;
		TON_Save : TON;
		TON_RW : TON;
		Autotune : BOOL;
		Autotuning : Inverter_Autotune_TYP;
	END_STRUCT;
	Internal_p74_MoveVelocity_TYP : 	STRUCT 
		Step : DINT;
		Read_Par : EplSDORead;
		Write_Par : EplSDOWrite;
		TON_Comm : TON;
		TON_Save : TON;
		TON_Tus : TON;
		InitDone : BOOL;
		SWord : UINT;
		CWord : UINT;
		InverterSWord : inverter_SW_typ;
		InverterCWord : inverter_CW_typ;
		InverterState : acp_inverter_state_enu;
		ParamID : UINT;
		ReadValueID : DINT;
		DriveLastErrorID : UINT;
		ErrorReached : UINT;
		C_SpeedRef : REAL;
		C_CWord : UINT;
		C_UpdatePar : BOOL;
		C_ReadAllPar : BOOL;
		C_LoadParamsFile : BOOL;
		UserParID : UINT;
		UserParNameTemp : STRING[ACPINV_MAX_PAR_NAME_LEN];
		UserParName : STRING[ACPINV_MAX_PAR_NAME_LEN];
		UserParValue : UINT;
		ParLoopEnd : BOOL;
		CmdHMI : internal_p74_hmi_command_TYP;
		SaveEprom : BOOL;
		ValueWORD : INT;
		ValueUINT : UINT;
		StringNode : STRING[10];
		NodeStr : STRING[10];
		EPLnode : USINT;
		CharPos : DINT;
		i : DINT;
		StopInverter : BOOL;
		FileOpenPar : FileOpen;
		FileClosePar : FileClose;
		FileReadPar : FileRead;
		FileLen : UDINT;
		FileOffset : UDINT;
		FileText : STRING[20];
		FirstSpace : INT;
		FindEnd : INT;
		MyValueStr : STRING[20];
		ProcedureAborted : BOOL;
		C_AutoTune : BOOL;
		TuneCmd : DINT;
		ReadAutoTune : SINT;
		AutoTuneReq : DINT;
		TuneProgress : BOOL;
		TuneRun : BOOL;
		DriveReset : BOOL;
	END_STRUCT;
	internal_p74_hmi_command_TYP : 	STRUCT 
		Read_Par : EplSDORead;
		Write_Par : EplSDOWrite;
		WritePar : BOOL;
		ReadPar : BOOL;
		Param : Inverter_UserPar_TYP;
		Step : DINT;
		RWParDone : BOOL;
		SaveEprom : BOOL;
		Reset : BOOL;
		Error : BOOL;
		ErrorID : UINT;
		UserParNameTemp : STRING[ACPINV_MAX_PAR_NAME_LEN];
		UserParName : STRING[ACPINV_MAX_PAR_NAME_LEN];
		UserParSubIndex : USINT;
		UserParValue : UINT;
		ParamValue : UINT;
		TON_RW : TON;
		TON_Save : TON;
		Autotune : BOOL;
		Autotuning : Inverter_Autotune_TYP;
	END_STRUCT;
	Internal_p84_MoveVelocity_TYP : 	STRUCT 
		Step : DINT;
		Read_Par : EplSDORead;
		Write_Par : EplSDOWrite;
		TON_Comm : TON;
		TON_Save : TON;
		TON_Tus : TON;
		InitDone : BOOL;
		SWord : UINT;
		CWord : UINT;
		InverterSWord : inverter_SW_typ;
		InverterCWord : inverter_CW_typ;
		InverterState : acp_inverter_state_enu;
		ParamID : UINT;
		ReadValueID : DINT;
		DriveLastErrorID : UINT;
		ErrorReached : UINT;
		C_SpeedRef : REAL;
		C_CWord : UINT;
		C_UpdatePar : BOOL;
		C_ReadAllPar : BOOL;
		C_LoadParamsFile : BOOL;
		UserParID : UINT;
		UserParNameTemp : STRING[ACPINV_MAX_PAR_NAME_LEN];
		UserParName : STRING[ACPINV_MAX_PAR_NAME_LEN];
		UserParValue : UINT;
		ParLoopEnd : BOOL;
		CmdHMI : internal_p84_hmi_command_TYP;
		SaveEprom : BOOL;
		ValueWORD : INT;
		ValueUINT : UINT;
		StringNode : STRING[10];
		NodeStr : STRING[10];
		EPLnode : USINT;
		CharPos : DINT;
		i : DINT;
		StopInverter : BOOL;
		FileOpenPar : FileOpen;
		FileClosePar : FileClose;
		FileReadPar : FileRead;
		FileLen : UDINT;
		FileOffset : UDINT;
		FileText : STRING[20];
		FirstSpace : INT;
		FindEnd : INT;
		MyValueStr : STRING[20];
		ProcedureAborted : BOOL;
		C_AutoTune : BOOL;
		TuneCmd : DINT;
		ReadAutoTune : SINT;
		AutoTuneReq : DINT;
		TuneProgress : BOOL;
		TuneRun : BOOL;
		DriveReset : BOOL;
	END_STRUCT;
	internal_p84_hmi_command_TYP : 	STRUCT 
		Read_Par : EplSDORead;
		Write_Par : EplSDOWrite;
		WritePar : BOOL;
		ReadPar : BOOL;
		Param : Inverter_UserPar_TYP;
		Step : DINT;
		RWParDone : BOOL;
		SaveEprom : BOOL;
		Reset : BOOL;
		Error : BOOL;
		ErrorID : UINT;
		UserParNameTemp : STRING[ACPINV_MAX_PAR_NAME_LEN];
		UserParName : STRING[ACPINV_MAX_PAR_NAME_LEN];
		UserParSubIndex : USINT;
		UserParValue : UINT;
		ParamValue : UINT;
		TON_Save : TON;
		TON_RW : TON;
		Autotune : BOOL;
		Autotuning : Inverter_Autotune_TYP;
	END_STRUCT;
	inverter_CW_typ : 	STRUCT 
		SwitchOn : BOOL;
		DisableVoltage : BOOL;
		QuickStop : BOOL;
		EnableOperation : BOOL;
		FaultReset : BOOL;
		DirectionOfRotation : BOOL;
		StopCommand : BOOL;
	END_STRUCT;
	inverter_SW_typ : 	STRUCT 
		ReadyToSwitchOn : BOOL;
		SwitchedOn : BOOL;
		OperationEnabled : BOOL;
		FaultDetection : BOOL;
		VoltageDisabled : BOOL;
		QuickStop : BOOL;
		SwitchedOnDisabled : BOOL;
		Alarm : BOOL;
		RemoteCommands : BOOL;
		TargetReached : BOOL;
		InternalLimitActive : BOOL;
	END_STRUCT;
END_TYPE
