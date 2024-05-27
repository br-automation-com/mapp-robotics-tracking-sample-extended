ACTION DefineLinks:

	// Define Links to the axes of the Robot
	AxQ1 := ADR(gAxisQ1_D5r1100R_1);
	AxQ2 := ADR(gAxisQ2_D5r1100R_1);
	AxQ3 := ADR(gAxisQ3_D5r1100R_1);
	AxQ4 := ADR(gAxisQ4_D5r1100R_1);
	AxQ5 := ADR(gAxisQ5_D5r1100R_1);
	
	// Define Link to the Robot & Conveyor
	MpDeltaName	:= 'gAxesGroup_D5r1100R_1';
	MpLinkDelta	:= ADR(gAxesGroup_D5r1100R_1);
	TrackLinkConveyorIn := ADR(gTrackingPathConveyorIn);
	TrackLinkConveyorOut := ADR(gTrackingPathConveyorOut);
	
	// Define Link to Interpreter Program
	ProgramLink ACCESS ADR(ControlPanel.Input.ProgramRobot1);
	
END_ACTION
