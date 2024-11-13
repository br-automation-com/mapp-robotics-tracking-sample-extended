PROGRAM _CYCLIC	

	CASE State OF
		
		/////////////////////////////////////////////////////////////////////////////
		STATE_WAIT:
		/////////////////////////////////////////////////////////////////////////////
			IF  ControlPanel.Input.Start THEN
				State := 	STATE_INIT;
			END_IF

		/////////////////////////////////////////////////////////////////////////////
		STATE_INIT:
		////////////////////////////////////////////////////////////////////////////
			
			IF MpAxConveyor.CommandBusy THEN
				// wait	
			ELSIF NOT(MpAxConveyor.Active) THEN
				MpAxConveyor.Enable := TRUE;
				
			ELSIF MpAxConveyor.Error THEN
				MpAxConveyor.ErrorReset := TRUE;
											
			ELSIF NOT(MpAxConveyor.PowerOn) THEN
				MpAxConveyor.Power := TRUE;
			
			ELSIF NOT(MpAxConveyor.IsHomed) THEN
				AxParConveyor.Homing.Mode := mcHOMING_DIRECT;
				AxParConveyor.Homing.Position := 0;
				MpAxConveyor.Home := TRUE;
				
			ELSIF MpAxConveyor.Info.CommunicationReady THEN
				LastProductPosition := MpAxConveyor.Position - ConvSettings.ProductGap;
				brsmemset(ADR(Products), 0, SIZEOF(Products));
				State := STATE_PRODUCTION;
			END_IF
				
		//////////////////////////////////////// Frame Handling! + Stat Machine Conveyor///////////////////////////////////////
		STATE_PRODUCTION: 
		///////////////////////////////////////////////////////////////////////////////

			// Frame Handling
			MC_BR_TrackingPathGetFrames_0.Execute := NOT(MC_BR_TrackingPathGetFrames_0.Done);
			IF MC_BR_TrackingPathGetFrames_0.Done AND NOT MC_BR_TrackingPathGetFrames_0.Busy AND NOT(MC_BR_TrackingFrameDelete_0.Execute) AND NOT(MC_BR_TrackingFrameCreate_0.Execute) THEN
				
				// Update the Data of the products stored in the product buffer
				updateProductData;
				// Find & Delete Products, which are out of scope
				deleteOutOfScopeProducts;	
				IF  NOT (MC_BR_TrackingFrameDelete_0.Execute)																																	AND
					((MpAxConveyor.Position >= LastProductPosition + ConvSettings.ProductGap) 																							OR 
					(MpAxConveyor.Position < LastProductPosition AND (LastProductPosition + ConvSettings.ProductGap >= McCfgAxConveyor.BaseType.LinearPeriodic.PeriodSettings.Period))) 	THEN

					addNewObjects;
				END_IF	
					
			END_IF
			
			IF MC_MoveAdditive_0.Error OR MC_MoveVelocity_0.Error OR MC_Stop_0.Error OR MpAxConveyor.Error OR MC_BR_TrackingPathReadStatus_0.TrackingPathErrorStop THEN
				State := STATE_ERROR;
				MpAxConveyor.Power := FALSE;
				
			ELSIF NOT(ControlPanel.Input.Start) THEN
				IF MpAxConveyor.MoveActive THEN
					MC_Stop_0.Execute := NOT MC_Stop_0.Busy;
				ELSIF MpAxConveyor.PowerOn AND NOT MC_Stop_0.Busy THEN
					MpAxConveyor.Power := FALSE;
				ELSE
					State := STATE_WAIT;
				END_IF 
			ELSE
				applyBeltMovement;
			END_IF
			
		///////////////////////////////////////////////////////////////////////////////
		STATE_ERROR:
		///////////////////////////////////////////////////////////////////////////////
			MpAxConveyor.Power := FALSE;
			IF MpAxConveyor.Error OR MpAxConveyor.CommandBusy OR MC_BR_TrackingPathReset_0.Busy OR MC_BR_TrackingPathReset_0.Error OR MC_BR_TrackingPathReadStatus_0.TrackingPathErrorStop THEN
				IF ControlPanel.Input.Reset THEN
					MpAxConveyor.ErrorReset := TRUE;
					MC_BR_TrackingPathReset_0.Execute := TRUE;
					
					brsmemset(ADR(Products), 0, SIZEOF(Products));
					brsmemset(ADR(ProductDetails), 0, SIZEOF(ProductDetails));
				END_IF
			ELSE 
				State := STATE_WAIT;
			END_IF		
					
	END_CASE
	
	

	(* *************************************************************************************************************************** *)
	(* *************************************************************************************************************************** *)
	(* *************************************************************************************************************************** *)

	// Function blocks call
	MpAxConveyor(MpLink := AxGroupLink,	Parameters := ADR(AxParConveyor));
	
	// movement fubs
	MC_MoveAdditive_0(Axis := AxGroupLink);
	MC_MoveAdditive_1(Axis := AxGroupLink);
	MC_MoveVelocity_0(Axis := AxGroupLink);
	MC_Stop_0(Axis := AxGroupLink);
	
	// Tracking commands
	MC_BR_TrackingFrameCreate_0(TrackingPath := TrackLinkConveyor);
	MC_BR_TrackingPathGetFrames_0(TrackingPath := TrackLinkConveyor);
	MC_BR_TrackingFrameDelete_0(TrackingPath := TrackLinkConveyor);
	MC_BR_TrackingPathReset_0(TrackingPath := TrackLinkConveyor);
	MC_BR_TrackingPathReadStatus_0(TrackingPath := TrackLinkConveyor);
	
	// Update Scene Viewer positions
	updateSceneViewerPositions;	

	(* *************************************************************************************************************************** *)
	(*                                                    RESET PARAMETER 														   *)
	(* *************************************************************************************************************************** *)
	
	resetFUBs;

END_PROGRAM