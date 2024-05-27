/* Automation Studio generated header file */
/* Do not edit ! */
/* AcpInvLib 3.00.4 */

#ifndef _ACPINVLIB_
#define _ACPINVLIB_
#ifdef __cplusplus
extern "C" 
{
#endif
#ifndef _AcpInvLib_VERSION
#define _AcpInvLib_VERSION 3.00.4
#endif

#include <bur/plctypes.h>

#ifndef _BUR_PUBLIC
#define _BUR_PUBLIC
#endif
#ifdef _SG4
		#include "AsIOAcc.h"
		#include "AsEPL.h"
		#include "AsBrStr.h"
#endif
#ifdef _SG3
		#include "AsIOAcc.h"
		#include "AsEPL.h"
		#include "AsBrStr.h"
#endif
#ifdef _SGC
		#include "AsIOAcc.h"
		#include "AsEPL.h"
		#include "AsBrStr.h"
#endif

/* Constants */
#ifdef _REPLACE_CONST
 #define ACPINV_MAX_USER_PARAMS 9U
 #define ACPINV_MAX_PAR_NAME_LEN 15U
 #define ACP_INV_ER_WRITE_PARAM_NULL 1U
 #define ACP_INV_ER_READ_PARAM_NULL 2U
 #define ACP_INV_ER_TUNE_WRONG_CFG 3U
#else
 #ifndef _GLOBAL_CONST
   #define _GLOBAL_CONST _WEAK const
 #endif
 _GLOBAL_CONST unsigned char ACPINV_MAX_USER_PARAMS;
 _GLOBAL_CONST unsigned char ACPINV_MAX_PAR_NAME_LEN;
 _GLOBAL_CONST unsigned short ACP_INV_ER_WRITE_PARAM_NULL;
 _GLOBAL_CONST unsigned short ACP_INV_ER_READ_PARAM_NULL;
 _GLOBAL_CONST unsigned short ACP_INV_ER_TUNE_WRONG_CFG;
#endif




/* Datatypes and datatypes of function blocks */
typedef enum acp_inverter_state_enu
{	ACP_INV_NOT_READY_TO_SWITCH_ON,
	ACP_INV_SWITCH_ON_DISABLED,
	ACP_INV_READY_TO_SWITCH_ON,
	ACP_INV_SWITCHED_ON,
	ACP_INV_OPERATION_ENABLED,
	ACP_INV_MALFUNCTION,
	ACP_INV_MALFUNCITION_REAC_ACTIVE,
	ACP_INV_QUICK_STOP_ACTIVE
} acp_inverter_state_enu;

typedef enum acp_inverter_par_mode_enu
{	ACP_INV_MODE_STARTUP_READ = 1,
	ACP_INV_MODE_STARTUP_DOWN = 2,
	ACP_INV_MODE_SAVE_PAR = 4
} acp_inverter_par_mode_enu;

typedef enum acp_inverter_autotune_type_enu
{	ACP_INV_TUNE_DISABLED = 0,
	ACP_INV_TUNE_GET_RES = 1,
	ACP_INV_TUNE_AT_ONCE = 112,
	ACP_INV_TUNE_EVERY_MOV = 114,
	ACP_INV_TUNE_EVERY_POW = 115,
	ACP_INV_TUNE_LI1 = 116,
	ACP_INV_TUNE_LI2 = 117,
	ACP_INV_TUNE_LI3 = 118,
	ACP_INV_TUNE_LI4 = 119,
	ACP_INV_TUNE_LI5 = 120,
	ACP_INV_TUNE_LI6 = 121
} acp_inverter_autotune_type_enu;

typedef enum acp_inverter_autotune_status_enu
{	ACP_INV_TUNE_DEFAULT = 0,
	ACP_INV_TUNE_PENDING = 1,
	ACP_INV_TUNE_PROGRESS = 2,
	ACP_INV_TUNE_FAIL = 3,
	ACP_INV_TUNE_DONE = 4,
	ACP_INV_TUNE_ENTERED_R1 = 5
} acp_inverter_autotune_status_enu;

typedef struct Inverter_NamePlate_TYP
{	float RatedFrequency;
	unsigned short RatedVoltage;
	float RatedCurrent;
	unsigned short RatedSpeed;
	float CosPhi;
	float Resistence;
	float RatedPower;
} Inverter_NamePlate_TYP;

typedef struct Inverter_UserPar_TYP
{	plcstring ParName[16];
	unsigned long Value;
} Inverter_UserPar_TYP;

typedef struct Inverter_ParamsFile_TYP
{	unsigned long pDevice;
	unsigned long pFile;
} Inverter_ParamsFile_TYP;

typedef struct Inverter_Autotune_TYP
{	plcbit EnableInfo;
	signed long CmdType;
	signed long ActiveType;
	signed long Status;
	plcstring Info[81];
	float Resistence;
	float Inductance;
	float MagnetizCurrent;
	float RotorTimeConst;
	plcbit Done;
	plcbit WaitPower;
} Inverter_Autotune_TYP;

typedef struct Inverter_Parameter_List_TYP
{	struct Inverter_NamePlate_TYP NamePlate;
	struct Inverter_UserPar_TYP UserPar[10];
	struct Inverter_ParamsFile_TYP ParamsFile;
	struct Inverter_Autotune_TYP Autotuning;
	float Acceleration;
	float Deceleration;
	float MinFrequency;
	float MaxFrequency;
} Inverter_Parameter_List_TYP;

typedef struct Inverter_MAP_input_TYP
{	plcbit ModuleOK;
	unsigned short ETAD_Input;
	unsigned short LCR_Input;
	signed short RFRD_Input;
	unsigned short ERRD_Input;
} Inverter_MAP_input_TYP;

typedef struct Inverter_MAP_OUTPUT_TYP
{	unsigned short CMDD_Output;
	signed short LFRD_Output;
	unsigned short CMI_Output;
} Inverter_MAP_OUTPUT_TYP;

typedef struct inverter_SW_typ
{	plcbit ReadyToSwitchOn;
	plcbit SwitchedOn;
	plcbit OperationEnabled;
	plcbit FaultDetection;
	plcbit VoltageDisabled;
	plcbit QuickStop;
	plcbit SwitchedOnDisabled;
	plcbit Alarm;
	plcbit RemoteCommands;
	plcbit TargetReached;
	plcbit InternalLimitActive;
} inverter_SW_typ;

typedef struct inverter_CW_typ
{	plcbit SwitchOn;
	plcbit DisableVoltage;
	plcbit QuickStop;
	plcbit EnableOperation;
	plcbit FaultReset;
	plcbit DirectionOfRotation;
	plcbit StopCommand;
} inverter_CW_typ;

typedef struct internal_x64_hmi_command_TYP
{	struct AsIOAccRead Read_Par;
	struct AsIOAccWrite Write_Par;
	plcbit WritePar;
	plcbit ReadPar;
	struct Inverter_UserPar_TYP Param;
	signed long Step;
	plcbit RWParDone;
	plcbit SaveEprom;
	plcbit Reset;
	plcbit Error;
	unsigned short ErrorID;
	plcstring UserParNameTemp[16];
	plcstring UserParName[16];
	unsigned long UserParValue;
	unsigned long ParamValue;
	struct TON TON_Save;
	struct TON TON_RW;
	plcbit Autotune;
	struct Inverter_Autotune_TYP Autotuning;
} internal_x64_hmi_command_TYP;

typedef struct Internal_x64_MoveVelocity_TYP
{	signed long Step;
	struct AsIOAccRead Read_Par;
	struct AsIOAccWrite Write_Par;
	struct TON TON_Comm;
	struct TON TON_Save;
	struct TON TON_Tus;
	plcbit InitDone;
	unsigned short SWord;
	unsigned short CWord;
	struct inverter_SW_typ InverterSWord;
	struct inverter_CW_typ InverterCWord;
	enum acp_inverter_state_enu InverterState;
	unsigned short ParamID;
	signed long ReadValueID;
	unsigned short DriveLastErrorID;
	unsigned short ErrorReached;
	float C_SpeedRef;
	unsigned short C_CWord;
	plcbit C_UpdatePar;
	plcbit C_ReadAllPar;
	plcbit C_LoadParamsFile;
	unsigned short UserParID;
	plcstring UserParNameTemp[16];
	plcstring UserParName[16];
	unsigned long UserParValue;
	plcstring UserParNameInfo[16];
	plcbit ParLoopEnd;
	struct internal_x64_hmi_command_TYP CmdHMI;
	plcbit SaveEprom;
	signed short ValueWORD;
	unsigned short ValueUINT;
	plcstring StringNode[11];
	plcstring NodeStr[11];
	signed long CharPos;
	signed long i;
	plcbit StopInverter;
	struct FileOpen FileOpenPar;
	struct FileClose FileClosePar;
	struct FileRead FileReadPar;
	unsigned long FileLen;
	unsigned long FileOffset;
	plcstring FileText[21];
	signed short FirstSpace;
	signed short FindEnd;
	plcstring MyValueStr[21];
	plcbit ProcedureAborted;
	plcbit C_AutoTune;
	signed long TuneCmd;
	signed char ReadAutoTune;
	signed long AutoTuneReq;
	plcbit TuneDone;
	plcbit TuneProgress;
	plcbit TuneRun;
	plcbit DriveReset;
} Internal_x64_MoveVelocity_TYP;

typedef struct internal_p74_hmi_command_TYP
{	struct EplSDORead Read_Par;
	struct EplSDOWrite Write_Par;
	plcbit WritePar;
	plcbit ReadPar;
	struct Inverter_UserPar_TYP Param;
	signed long Step;
	plcbit RWParDone;
	plcbit SaveEprom;
	plcbit Reset;
	plcbit Error;
	unsigned short ErrorID;
	plcstring UserParNameTemp[16];
	plcstring UserParName[16];
	unsigned char UserParSubIndex;
	unsigned short UserParValue;
	unsigned short ParamValue;
	struct TON TON_RW;
	struct TON TON_Save;
	plcbit Autotune;
	struct Inverter_Autotune_TYP Autotuning;
} internal_p74_hmi_command_TYP;

typedef struct Internal_p74_MoveVelocity_TYP
{	signed long Step;
	struct EplSDORead Read_Par;
	struct EplSDOWrite Write_Par;
	struct TON TON_Comm;
	struct TON TON_Save;
	struct TON TON_Tus;
	plcbit InitDone;
	unsigned short SWord;
	unsigned short CWord;
	struct inverter_SW_typ InverterSWord;
	struct inverter_CW_typ InverterCWord;
	enum acp_inverter_state_enu InverterState;
	unsigned short ParamID;
	signed long ReadValueID;
	unsigned short DriveLastErrorID;
	unsigned short ErrorReached;
	float C_SpeedRef;
	unsigned short C_CWord;
	plcbit C_UpdatePar;
	plcbit C_ReadAllPar;
	plcbit C_LoadParamsFile;
	unsigned short UserParID;
	plcstring UserParNameTemp[16];
	plcstring UserParName[16];
	unsigned short UserParValue;
	plcbit ParLoopEnd;
	struct internal_p74_hmi_command_TYP CmdHMI;
	plcbit SaveEprom;
	signed short ValueWORD;
	unsigned short ValueUINT;
	plcstring StringNode[11];
	plcstring NodeStr[11];
	unsigned char EPLnode;
	signed long CharPos;
	signed long i;
	plcbit StopInverter;
	struct FileOpen FileOpenPar;
	struct FileClose FileClosePar;
	struct FileRead FileReadPar;
	unsigned long FileLen;
	unsigned long FileOffset;
	plcstring FileText[21];
	signed short FirstSpace;
	signed short FindEnd;
	plcstring MyValueStr[21];
	plcbit ProcedureAborted;
	plcbit C_AutoTune;
	signed long TuneCmd;
	signed char ReadAutoTune;
	signed long AutoTuneReq;
	plcbit TuneProgress;
	plcbit TuneRun;
	plcbit DriveReset;
} Internal_p74_MoveVelocity_TYP;

typedef struct internal_p84_hmi_command_TYP
{	struct EplSDORead Read_Par;
	struct EplSDOWrite Write_Par;
	plcbit WritePar;
	plcbit ReadPar;
	struct Inverter_UserPar_TYP Param;
	signed long Step;
	plcbit RWParDone;
	plcbit SaveEprom;
	plcbit Reset;
	plcbit Error;
	unsigned short ErrorID;
	plcstring UserParNameTemp[16];
	plcstring UserParName[16];
	unsigned char UserParSubIndex;
	unsigned short UserParValue;
	unsigned short ParamValue;
	struct TON TON_Save;
	struct TON TON_RW;
	plcbit Autotune;
	struct Inverter_Autotune_TYP Autotuning;
} internal_p84_hmi_command_TYP;

typedef struct Internal_p84_MoveVelocity_TYP
{	signed long Step;
	struct EplSDORead Read_Par;
	struct EplSDOWrite Write_Par;
	struct TON TON_Comm;
	struct TON TON_Save;
	struct TON TON_Tus;
	plcbit InitDone;
	unsigned short SWord;
	unsigned short CWord;
	struct inverter_SW_typ InverterSWord;
	struct inverter_CW_typ InverterCWord;
	enum acp_inverter_state_enu InverterState;
	unsigned short ParamID;
	signed long ReadValueID;
	unsigned short DriveLastErrorID;
	unsigned short ErrorReached;
	float C_SpeedRef;
	unsigned short C_CWord;
	plcbit C_UpdatePar;
	plcbit C_ReadAllPar;
	plcbit C_LoadParamsFile;
	unsigned short UserParID;
	plcstring UserParNameTemp[16];
	plcstring UserParName[16];
	unsigned short UserParValue;
	plcbit ParLoopEnd;
	struct internal_p84_hmi_command_TYP CmdHMI;
	plcbit SaveEprom;
	signed short ValueWORD;
	unsigned short ValueUINT;
	plcstring StringNode[11];
	plcstring NodeStr[11];
	unsigned char EPLnode;
	signed long CharPos;
	signed long i;
	plcbit StopInverter;
	struct FileOpen FileOpenPar;
	struct FileClose FileClosePar;
	struct FileRead FileReadPar;
	unsigned long FileLen;
	unsigned long FileOffset;
	plcstring FileText[21];
	signed short FirstSpace;
	signed short FindEnd;
	plcstring MyValueStr[21];
	plcbit ProcedureAborted;
	plcbit C_AutoTune;
	signed long TuneCmd;
	signed char ReadAutoTune;
	signed long AutoTuneReq;
	plcbit TuneProgress;
	plcbit TuneRun;
	plcbit DriveReset;
} Internal_p84_MoveVelocity_TYP;

typedef struct INVx64_MoveVelocityMap
{
	/* VAR_INPUT (analog) */
	float SpeedRef;
	signed long ParameterMode;
	struct Inverter_UserPar_TYP Param;
	struct Inverter_Parameter_List_TYP* Parameters;
	plcstring InverterName[41];
	struct Inverter_MAP_input_TYP MapIN;
	/* VAR_OUTPUT (analog) */
	unsigned short ErrorID;
	unsigned short DriveErrorID;
	plcstring ErrorInfo[16];
	plcstring DriveErrorHex[16];
	unsigned long ParamValue;
	float Speed;
	float Current;
	struct Inverter_MAP_OUTPUT_TYP MapOUT;
	/* VAR (analog) */
	struct Internal_x64_MoveVelocity_TYP Internal;
	/* VAR_INPUT (digital) */
	plcbit Enable;
	plcbit Power;
	plcbit Run;
	plcbit UpdateParams;
	plcbit ReadAllParams;
	plcbit Direction;
	plcbit QuickStop;
	plcbit Reset;
	plcbit HardwareReset;
	plcbit AutoTune;
	plcbit WritePar;
	plcbit ReadPar;
	plcbit Simulate;
	plcbit LoadParamsFile;
	/* VAR_OUTPUT (digital) */
	plcbit Active;
	plcbit CommOK;
	plcbit Ready;
	plcbit PowerOn;
	plcbit Error;
	plcbit DriveError;
	plcbit ParamsUpdated;
	plcbit ParamsRead;
	plcbit RWParDone;
	plcbit ParamsFileOK;
	plcbit Simulated;
} INVx64_MoveVelocityMap_typ;

typedef struct INVp74_MoveVelocityMap
{
	/* VAR_INPUT (analog) */
	float SpeedRef;
	signed long ParameterMode;
	struct Inverter_UserPar_TYP Param;
	struct Inverter_Parameter_List_TYP* Parameters;
	plcstring InverterName[41];
	struct Inverter_MAP_input_TYP MapIN;
	/* VAR_OUTPUT (analog) */
	unsigned short ErrorID;
	unsigned short DriveErrorID;
	plcstring ErrorInfo[16];
	plcstring DriveErrorHex[16];
	unsigned long ParamValue;
	float Speed;
	float Current;
	struct Inverter_MAP_OUTPUT_TYP MapOUT;
	/* VAR (analog) */
	struct Internal_p74_MoveVelocity_TYP Internal;
	/* VAR_INPUT (digital) */
	plcbit Enable;
	plcbit Power;
	plcbit Run;
	plcbit UpdateParams;
	plcbit ReadAllParams;
	plcbit Direction;
	plcbit QuickStop;
	plcbit Reset;
	plcbit HardwareReset;
	plcbit AutoTune;
	plcbit WritePar;
	plcbit ReadPar;
	plcbit Simulate;
	plcbit LoadParamsFile;
	/* VAR_OUTPUT (digital) */
	plcbit Active;
	plcbit CommOK;
	plcbit Ready;
	plcbit PowerOn;
	plcbit Error;
	plcbit DriveError;
	plcbit ParamsUpdated;
	plcbit ParamsRead;
	plcbit RWParDone;
	plcbit ParamsFileOK;
	plcbit Simulated;
} INVp74_MoveVelocityMap_typ;

typedef struct INVp84_MoveVelocityMap
{
	/* VAR_INPUT (analog) */
	float SpeedRef;
	signed long ParameterMode;
	struct Inverter_UserPar_TYP Param;
	struct Inverter_Parameter_List_TYP* Parameters;
	plcstring InverterName[41];
	struct Inverter_MAP_input_TYP MapIN;
	/* VAR_OUTPUT (analog) */
	unsigned short ErrorID;
	unsigned short DriveErrorID;
	plcstring ErrorInfo[16];
	plcstring DriveErrorHex[16];
	unsigned long ParamValue;
	float Speed;
	float Current;
	struct Inverter_MAP_OUTPUT_TYP MapOUT;
	/* VAR (analog) */
	struct Internal_p84_MoveVelocity_TYP Internal;
	/* VAR_INPUT (digital) */
	plcbit Enable;
	plcbit Power;
	plcbit Run;
	plcbit UpdateParams;
	plcbit ReadAllParams;
	plcbit Direction;
	plcbit QuickStop;
	plcbit Reset;
	plcbit HardwareReset;
	plcbit AutoTune;
	plcbit WritePar;
	plcbit ReadPar;
	plcbit Simulate;
	plcbit LoadParamsFile;
	/* VAR_OUTPUT (digital) */
	plcbit Active;
	plcbit CommOK;
	plcbit Ready;
	plcbit PowerOn;
	plcbit Error;
	plcbit DriveError;
	plcbit ParamsUpdated;
	plcbit ParamsRead;
	plcbit RWParDone;
	plcbit ParamsFileOK;
	plcbit Simulated;
} INVp84_MoveVelocityMap_typ;



/* Prototyping of functions and function blocks */
_BUR_PUBLIC void INVx64_MoveVelocityMap(struct INVx64_MoveVelocityMap* inst);
_BUR_PUBLIC void INVp74_MoveVelocityMap(struct INVp74_MoveVelocityMap* inst);
_BUR_PUBLIC void INVp84_MoveVelocityMap(struct INVp84_MoveVelocityMap* inst);
_BUR_PUBLIC signed long GetEnumFromValue(unsigned short Value, unsigned short EnumName);
_BUR_PUBLIC unsigned long GetValueFromEnum(signed long EnumValue, unsigned short EnumName);
_BUR_PUBLIC acp_inverter_state_enu GetInverterState(struct inverter_SW_typ* InverterSWord);
_BUR_PUBLIC unsigned short GetEPLindexFromPar(unsigned char InverterType, plcstring* ParName, unsigned char* pSubIndex, unsigned long* pSize);
_BUR_PUBLIC plcbit DecToHex(unsigned long Value, unsigned long Out);
_BUR_PUBLIC unsigned long ReplaceInString(plcstring* SourceString, plcstring* StringSearch, plcstring* StringReplace);
_BUR_PUBLIC unsigned long RightCutString(plcstring* SourceString, plcstring* CharSearch, unsigned long Result);


#ifdef __cplusplus
};
#endif
#endif /* _ACPINVLIB_ */

