
TYPE
	ConveyorSettings : 	STRUCT  (*Command Buttons*)
		YShift : LREAL; (*Min Y Pos in Random mode*)
		VelocityProduction : REAL; (*Velocity for production [ppm]*)
		IndexingDistance : REAL; (*Indexing distance [mm]*)
		ProductGap : REAL; (*Length of the product [mm]*)
		DeletePosition : REAL; (*Position where objects are deleted*)
	END_STRUCT;
	ControlPanelInputs : 	STRUCT  (*Command Buttons*)
		Start : BOOL; (*Run Applicaion*)
		Reset : BOOL; (*Reset Error states*)
		Conveyor1 : ConveyorSettings; (*Buttons *)
		Conveyor2 : ConveyorSettings; (*Buttons *)
		ProgramRobot1 : STRING[32]; (*Program name for robot 1*)
	END_STRUCT;
	ControlPanelType : 	STRUCT  (*Control Panel*)
		Input : ControlPanelInputs; (*Buttons *)
	END_STRUCT;
END_TYPE

(*Device Interface*)
(*
Enumerators for State Machnie (used at Conveyor and Robot)*)

TYPE
	DeviceStatesListEnum : 
		( (*State of the robot / axis*)
		STATE_WAIT, (*Standby*)
		STATE_INIT, (*Initialization*)
		STATE_PRODUCTION, (*Production*)
		STATE_ERROR, (*Emenrgency*)
		STATE_RESET (*Reset*)
		);
END_TYPE

(*
Product positions for SceneViewer*)

TYPE
	ProdPosType : 	STRUCT  (*Visu position for Scene Viewer*)
		Full : BOOL; (*Display object*)
		Valid : BOOL; (*Display object*)
		Element1 : BOOL; (*Display object*)
		Element2 : BOOL; (*Display object*)
		Empty : BOOL; (*Display object*)
		PositionX : REAL; (*Pos X*)
		PositionY : REAL; (*Pos Y*)
		PositionZ : REAL; (*Pos Z*)
		Material : UDINT; (*Material Color to show Tracking*)
	END_STRUCT;
END_TYPE
