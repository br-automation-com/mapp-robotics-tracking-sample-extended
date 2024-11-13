PROGRAM _INIT
	
	TrackLinkConveyor := ADR(gTrackingPathConveyorIn);
	AxGroupLink := ADR(AxConveyorIn);
	ConvSettings ACCESS ADR(ControlPanel.Input.Conveyor1);
	AxWithCommandConsideration := FALSE;
	
	initConveyor;
	
END_PROGRAM