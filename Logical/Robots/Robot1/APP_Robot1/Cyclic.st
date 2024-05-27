PROGRAM _CYCLIC

	CASE State OF

		/////////////////////////////////////////////////////////////////////////////
		STATE_WAIT:
		/////////////////////////////////////////////////////////////////////////////
			IF  ControlPanel.Input.Start THEN
				State := STATE_INIT;
			END_IF
			
		/////////////////////////////////////////////////////////////////////////////
		STATE_INIT:
			/////////////////////////////////////////////////////////////////////////////
			IF NOT (MC_BR_TrackingPathReadStatus_In.TrackingPathReady OR MC_BR_TrackingPathReadStatus_Out.TrackingPathReady) THEN	
				/// Wait
			ELSIF MC_BR_GroupHome_X.Busy OR MC_GroupReset_X.Busy OR NOT MC_GroupReadStatus_X.Valid OR NOT MC_BR_GroupReadInfo_X.Valid THEN
				// wait
			ELSIF MC_GroupReadStatus_X.Error OR MC_BR_GroupHome_X.Error OR MC_BR_GroupPower_X.Error OR MC_BR_MoveProgram_X.Error OR MC_GroupReset_X.Error OR MC_BR_GroupReadInfo_X.Error THEN
				MC_GroupReset_X.Execute := TRUE;
			
			ELSIF NOT MC_BR_GroupReadInfo_X.PowerOn THEN
				MC_BR_GroupPower_X.Enable := TRUE;
				
			ELSIF NOT MC_BR_GroupReadInfo_X.IsHomed	THEN
				MC_BR_GroupHome_X.Execute := TRUE;
				
			ELSIF MC_GroupReadStatus_X.GroupStandby THEN
				PickTrackingObject := 0;
				PlaceTrackingObject := 0;
				brsmemset(ADR(Products_In), 0, SIZEOF(Products_In));
				brsmemset(ADR(Products_Out), 0, SIZEOF(Products_Out));
				MC_BR_MoveProgram_X.Name := ProgramLink;
				MC_BR_MoveProgram_X.Execute := TRUE;
				MC_BR_PauseWorkspaceMonitoring_X.Enable := FALSE;
				State := STATE_PRODUCTION;
						
			END_IF
				
		
		/////////////////////////////////////////////////////////////////////////////	
		STATE_PRODUCTION:
		/////////////////////////////////////////////////////////////////////////////			
			
			// ------------------------------------------------------------------------------------------------------------------------------------------------
			// Case Pick Frame: choose which frame is the next to pick which is not already grabbed and not already in manipulation
			// ------------------------------------------------------------------------------------------------------------------------------------------------
			chooseNextSlots;

			// ------------------------------------------------------------------------------------------------------------------------------------------------
			// Case Grip Product: Hande M Commands on Tracked object
			// ------------------------------------------------------------------------------------------------------------------------------------------------
			handleMFunctions;
			
			// ------------------------------------------------------------------------------------------------------------------------------------------------		
			// Case Scene Viewer Update Robot 1: Update Positions in Tracking case, to get a Scene Viewer Visu
			// ------------------------------------------------------------------------------------------------------------------------------------------------		
		
			updateSceneViewer;	

			// ------------------------------------------------------------------------------------------------------------------------------------------------
			// Case State M. Production : Handle End of Process
			// ------------------------------------------------------------------------------------------------------------------------------------------------
			IF MC_GroupReadStatus_X.Error OR MC_GroupReadStatus_X.GroupErrorStop OR MC_BR_MoveProgram_X.Error THEN
				State := STATE_ERROR;
				MC_GroupStop_X.Execute := TRUE;
				ControlPanel.Input.Start := FALSE;
			
			ELSIF NOT(ControlPanel.Input.Start) THEN

				MC_GroupStop_X.Execute := TRUE;
				MC_BR_GroupPower_X.Enable := FALSE;
					
				IF MC_GroupReadStatus_X.GroupDisabled THEN
					State := STATE_WAIT;
					
				ELSIF MC_GroupReadStatus_X.GroupErrorStop THEN	
					State := STATE_ERROR;
				END_IF
				
			END_IF
		
				
		///////////////////////////////////////////////////////////////////////////////
		STATE_ERROR:
		///////////////////////////////////////////////////////////////////////////////
			IF MC_GroupReset_X.Busy OR MC_GroupReadStatus_X.Error OR MC_GroupReadStatus_X.GroupErrorStop THEN
				IF ControlPanel.Input.Reset THEN
					MC_GroupReset_X.Execute := NOT MC_GroupReset_X.Busy;
					MC_BR_GroupHome_X.Execute := NOT MC_BR_GroupHome_X.Busy;	
				END_IF
			ELSE
				State := STATE_WAIT;
			END_IF
					
	END_CASE
	
	PlaceTrackingObjectDetails ACCESS PlaceTrackingObject;
	PickTrackingObjectDetails ACCESS PickTrackingObject;
	runFUBs;
			 
END_PROGRAM
