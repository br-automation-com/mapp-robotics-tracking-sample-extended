// This action choses the next Product to be manipulated by the robot
ACTION chooseNextSlots:
	XPosMax := 0;
	j := MAX_TRACKING_FRAMES + 1;
	FOR i := 0 TO MAX_TRACKING_FRAMES DO
		IF Products_In[i].TrackingFrameID <> 0 AND 
			Products_In[i].Attribute <> 0 AND 
			Products_In[i].TrackingFrameID <> MC_BR_TrackingStatus_PathGen_X.TrackingAdditionalInfo.TrackedFrame.FrameId THEN
			ProdDetails ACCESS Products_In[i].Attribute;
										
			// current frame is suitable - find the optimal one
			IF ProdDetails.Used = FALSE  AND	// no other robot has manipulate this object
				Products_In[i].Distance < (MaxPickPosX) AND // not already outside of the position
				Products_In[i].Distance > XPosMax AND // the object is the nearest to the robot
				Products_In[i].Distance > (MinPickPosX) THEN // product is within the scope of the robot
				// select as next object
				XPosMax := Products_In[i].Distance;
				j := i;
			END_IF
		END_IF
	END_FOR
	
				
	IF j <= MAX_TRACKING_FRAMES THEN
		PickTrackingObject := Products_In[j].Attribute;
		MC_GroupContinue_X.Execute := MC_BR_GroupReadInfo_X.AdditionalInfo.GroupInterrupted AND NOT MC_GroupContinue_X.Busy ;
	ELSE
		PickTrackingObject := 0;
	END_IF
	
	XPosMax := 0;
	j := MAX_TRACKING_FRAMES + 1;
	FOR i := 0 TO MAX_TRACKING_FRAMES DO
		IF Products_Out[i].TrackingFrameID <> 0 AND 
			Products_Out[i].Attribute <> 0 AND 
			Products_Out[i].TrackingFrameID <> MC_BR_TrackingStatus_PathGen_X.TrackingAdditionalInfo.TrackedFrame.FrameId THEN
			ProdDetails ACCESS Products_Out[i].Attribute;
										
			// current frame is suitable - find the optimal one
			IF ProdDetails.Used = FALSE  AND	// no other robot has manipulate this object
				Products_Out[i].Distance < (MaxPlacePosX) AND // not already outside of the position
				Products_Out[i].Distance > XPosMax AND // the object is the nearest to the robot
				Products_Out[i].Distance > (MinPlacePosX) THEN // product is within the scope of the robot
				// select as next object
				XPosMax := Products_Out[i].Distance;
				j := i;
			END_IF
		END_IF
	END_FOR
			
	IF j <= MAX_TRACKING_FRAMES THEN
		PlaceTrackingObject := Products_Out[j].Attribute;
	ELSE
		PlaceTrackingObject := 0;
	END_IF
	
	
	
END_ACTION

// This action operates the Gripper, 
ACTION handleMFunctions:
	FOR i := 0 TO MAX_TRACKING_FRAMES DO
		IF MC_BR_TrackingStatus_PathGen_X.TrackingAdditionalInfo.TrackedFrame.FrameId <> 0 THEN
			ProdDetails ACCESS 0;
			IF MC_BR_TrackingStatus_PathGen_X.TrackingAdditionalInfo.TrackedFrame.FrameId = Products_In[i].TrackingFrameID THEN
				ProdDetails ACCESS Products_In[i].Attribute;
			END_IF
			IF MC_BR_TrackingStatus_PathGen_X.TrackingAdditionalInfo.TrackedFrame.FrameId = Products_Out[i].TrackingFrameID THEN
				ProdDetails ACCESS Products_Out[i].Attribute;
			END_IF
			
			IF ADR(ProdDetails) <> 0 THEN
				IF M8 OR M9 OR M16 OR M17 THEN
					ProdDetails.Used := TRUE;
				END_IF
							
				IF M8 THEN
					ProdDetails.Element1 := FALSE;
				END_IF
				
				IF M9 THEN
					ProdDetails.Element2 := FALSE;
				END_IF
				
				IF M16 THEN
					ProdDetails.Element1 := TRUE;
				END_IF
				
				IF M17 THEN
					ProdDetails.Element2 := TRUE;
				END_IF
				
			END_IF	
		END_IF
	END_FOR
	
	IF M8 THEN
		Grab1Closed := TRUE;
	END_IF
	
	IF M16 THEN
		Grab1Closed := FALSE;
	END_IF
	
	IF M9 THEN
		Grab2Closed := TRUE;
	END_IF
	
	IF M17 THEN
		Grab2Closed := FALSE;
	END_IF
	
	IF M20 THEN
		MC_BR_PauseWorkspaceMonitoring_X.Enable := TRUE;
	END_IF
	
	IF M21 THEN
		MC_BR_PauseWorkspaceMonitoring_X.Enable := FALSE;
	END_IF
	
	
	M8 := FALSE;
	M16 := FALSE;
	M9 := FALSE;
	M17 := FALSE;
	M20 := FALSE;
	M21 := FALSE;
END_ACTION	


ACTION runFUBs:

	MC_BR_GroupHome_X(AxesGroup := MpLinkDelta);
	MC_GroupStop_X(AxesGroup := MpLinkDelta);
	MC_BR_MoveProgram_X(AxesGroup := MpLinkDelta);
	MC_BR_GroupPower_X(AxesGroup := MpLinkDelta);
	MC_GroupReset_X(AxesGroup := MpLinkDelta);
	MC_GroupReadStatus_X(AxesGroup := MpLinkDelta);
	MC_BR_GroupReadInfo_X(AxesGroup := MpLinkDelta);
	MC_BR_TrackingStatus_PathGen_X(AxesGroup := MpLinkDelta);
	MC_BR_PathInfo_X(AxesGroup := MpLinkDelta);
	MC_GroupContinue_X(AxesGroup := MpLinkDelta);
	MC_GroupReadActualPosition_X(AxesGroup := MpLinkDelta);
	MC_BR_PauseWorkspaceMonitoring_X(AxesGroup := MpLinkDelta);
	
		
	MC_GroupReset_X.Execute := MC_GroupReset_X.Execute AND NOT (MC_GroupReset_X.Done OR MC_GroupReset_X.Error);
	MC_GroupStop_X.Execute := MC_GroupStop_X.Execute AND NOT (MC_GroupStop_X.Done OR MC_GroupStop_X.Error OR MC_GroupStop_X.CommandAborted);
	MC_BR_MoveProgram_X.Execute := MC_BR_MoveProgram_X.Execute AND NOT (MC_BR_MoveProgram_X.Done OR MC_BR_MoveProgram_X.Error OR MC_BR_MoveProgram_X.CommandAborted);
	MC_BR_GroupHome_X.Execute := MC_BR_GroupHome_X.Execute AND NOT (MC_BR_GroupHome_X.Done OR MC_BR_GroupHome_X.Error OR MC_BR_GroupHome_X.CommandAborted);
	MC_BR_GroupPower_X.Enable := MC_BR_GroupPower_X.Enable AND NOT (MC_BR_GroupPower_X.Error);
	MC_GroupContinue_X.Execute := MC_GroupContinue_X.Execute AND NOT (MC_GroupContinue_X.Done OR MC_GroupContinue_X.Error OR MC_GroupContinue_X.CommandAborted);
	
	// Tracking of moving objects
	MC_BR_TrackingPathReadStatus_In();
	MC_BR_TrackingPathGetFrames_In();
	MC_BR_TrackingPathReadStatus_Out();
	MC_BR_TrackingPathGetFrames_Out();
	
	// Toogle Execution - needed cause FUB detects positive edge
	IF MC_BR_TrackingPathReadStatus_In.TrackingPathErrorStop OR MC_BR_TrackingPathReadStatus_In.TrackingPathErrorStop THEN
		brsmemset(ADR(Products_Out), 0, SIZEOF(Products_Out));
		brsmemset(ADR(Products_In), 0, SIZEOF(Products_In));
		MC_BR_TrackingPathGetFrames_In.Execute := FALSE;
		MC_BR_TrackingPathGetFrames_Out.Execute := FALSE;
	ELSE	
		MC_BR_TrackingPathGetFrames_In.Execute := NOT(MC_BR_TrackingPathGetFrames_In.Done) AND NOT (MC_BR_TrackingPathGetFrames_In.Error);
		MC_BR_TrackingPathGetFrames_Out.Execute := NOT(MC_BR_TrackingPathGetFrames_Out.Done) AND NOT (MC_BR_TrackingPathGetFrames_Out.Error);
	END_IF
	
		
	IF NOT IPMonitor.Handshake THEN
		IPMonitor.Handshake := TRUE;
	END_IF

	
END_ACTION

ACTION updateSceneViewer:
					
	// ------------------------------------------------------------------------------------------------------------------------------------------------
	// Highliting of actual object tracked for Scene Viewer visu
	// ------------------------------------------------------------------------------------------------------------------------------------------------
	
	FOR i := 0 TO MAX_TRACKING_FRAMES DO
		IF Products_In[i].Attribute <> 0 THEN
			ProdDetails ACCESS Products_In[i].Attribute;
			IF MC_BR_TrackingStatus_PathGen_X.TrackingAdditionalInfo.TrackedFrame.FrameId = ProdDetails.TrackingFrameID AND
				MC_BR_TrackingStatus_PathGen_X.TrackingAdditionalInfo.TrackedFrame.FrameId <> 0 THEN
				ProdDetails.InTracking := TRUE;
			ELSE
				ProdDetails.InTracking := FALSE;
			END_IF
		END_IF
	END_FOR
	
		
	FOR i := 0 TO MAX_TRACKING_FRAMES DO
		IF Products_Out[i].Attribute <> 0 THEN
			ProdDetails ACCESS Products_Out[i].Attribute;
			IF MC_BR_TrackingStatus_PathGen_X.TrackingAdditionalInfo.TrackedFrame.FrameId = ProdDetails.TrackingFrameID AND
				MC_BR_TrackingStatus_PathGen_X.TrackingAdditionalInfo.TrackedFrame.FrameId <> 0 THEN
				ProdDetails.InTracking := TRUE;
			ELSE
				ProdDetails.InTracking := FALSE;
			END_IF
		END_IF
	END_FOR
	
END_ACTION	