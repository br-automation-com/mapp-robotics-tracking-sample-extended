PROGRAM _INIT
	
	TrackLinkConveyor := ADR(gTrackingPathConveyorOut);
	AxGroupLink := ADR(AxConveyorOut);
	ConvSettings ACCESS ADR(ControlPanel.Input.Conveyor2);
	AxWithCommandConsideration := TRUE;
	
	initConveyor;
	
END_PROGRAM