ACTION updateProductData:

	FOR i:=0 TO MAX_TRACKING_FRAMES DO
		IF (Products[i].TrackingFrameID <> 0 AND Products[i].Attribute <> 0) THEN
			ProdDetails ACCESS Products[i].Attribute;
			brsmemcpy(ADR(ProdDetails.Pos), ADR(Products[i].CurrentPosition), SIZEOF(McPosType));
			ProdDetails.This := ADR(ProdDetails);
			ProdDetails.TrackingFrameID := Products[i].TrackingFrameID;
		END_IF			
	END_FOR
	
END_ACTION	

ACTION deleteOutOfScopeProducts:

	FOR i:=0 TO MAX_TRACKING_FRAMES DO
		IF Products[i].Distance >= ConvSettings.DeletePosition THEN // todo: distance as a constant!
			IF (Products[i].Attribute <> 0) THEN
				brsmemset(Products[i].Attribute, 0, SIZEOF(ProductDetailsType));
			END_IF
			MC_BR_TrackingFrameDelete_0.Mode := mcTRKFRM_DELETE_MOD_FRAME;
			MC_BR_TrackingFrameDelete_0.TrackingFrameID	:= Products[i].TrackingFrameID;
			MC_BR_TrackingFrameDelete_0.Execute	:= TRUE;
			EXIT;
		END_IF
	END_FOR
	
END_ACTION	

ACTION addNewObjects:
	
	LastProductPosition := MpAxConveyor.Position;
						
	// Generate a random Y Position --> Here a vision sensor informatin is needed in real systems
	MC_BR_TrackingFrameCreate_0.Parameters.Translation.Y := ConvSettings.YShift;
	
	// Add attributes memory
	FOR i := 0 TO MAX_TRACKING_FRAMES DO
		IF ProductDetails[i].TrackingFrameID = 0 THEN
			brsmemset(ADR(ProductDetails[i]), 0, SIZEOF(ProductDetailsType));
			MC_BR_TrackingFrameCreate_0.Parameters.Attribute := ADR(ProductDetails[i]);
			EXIT;
		END_IF
	END_FOR
				
	// Add frame in the buffer
	MC_BR_TrackingFrameCreate_0.Parameters.LatchedPath.Position := LastProductPosition;
	MC_BR_TrackingFrameCreate_0.Execute	:= TRUE;
	
END_ACTION
	
ACTION updateSceneViewerPositions:
	
	FOR i:= 0 TO MAX_TRACKING_FRAMES DO
		ProductsPosition[i].Valid := Products[i].TrackingFrameID <> 0;
		
		IF Products[i].Attribute <> 0 THEN
			ProdDetails ACCESS Products[i].Attribute;
			IF ProdDetails.InTracking THEN
				ProductsPosition[i].Material := 4; //yellow
			ELSE
				ProductsPosition[i].Material := 1; //red
			END_IF
			ProductsPosition[i].Full := ProdDetails.Used;
			ProductsPosition[i].Empty := NOT ProdDetails.Used;
			ProductsPosition[i].Element1 := ProdDetails.Element1;
			ProductsPosition[i].Element2 := ProdDetails.Element2;
		ELSE
			ProductsPosition[i].Full := FALSE;
			ProductsPosition[i].Empty := FALSE;
			ProductsPosition[i].Element1 := FALSE;
			ProductsPosition[i].Element2 := FALSE;
			ProductsPosition[i].Material := 1;
		END_IF
		
		ProductsPosition[i].PositionX := LREAL_TO_REAL(Products[i].CurrentPosition.X);
		ProductsPosition[i].PositionY := LREAL_TO_REAL(Products[i].CurrentPosition.Y);
		ProductsPosition[i].PositionZ := LREAL_TO_REAL(Products[i].CurrentPosition.Z);
	END_FOR
	
END_ACTION

ACTION applyBeltMovement:
	
	IF AxWithCommandConsideration THEN
		IF NOT MC_MoveAdditive_0.Busy THEN
			MC_MoveAdditive_0.Distance := ConvSettings.IndexingDistance;
			MC_MoveAdditive_0.Velocity := ConvSettings.VelocityProduction;
			MC_MoveAdditive_0.BufferMode := mcABORTING;
			MC_MoveAdditive_0.Execute := TRUE;
		END_IF		
	ELSE
		MC_MoveVelocity_0.Velocity := ConvSettings.VelocityProduction;
		MC_MoveVelocity_0.Execute := MC_MoveVelocity_0.InVelocity OR NOT MC_MoveVelocity_0.Busy;
	END_IF
		
END_ACTION
	

ACTION resetFUBs:
	
	IF (MpAxConveyor.Update AND MpAxConveyor.UpdateDone) OR MpAxConveyor.Error THEN
		MpAxConveyor.Update	:= FALSE;
	END_IF
	
	IF (NOT(MpAxConveyor.MoveActive) AND NOT(MpAxConveyor.CommandBusy)) OR MpAxConveyor.Error THEN
		MpAxConveyor.MoveVelocity := FALSE;
		MpAxConveyor.Update := FALSE;
	END_IF	
	
	IF MpAxConveyor.ErrorReset AND NOT(MpAxConveyor.Error) THEN
		MpAxConveyor.ErrorReset := FALSE;
	END_IF
	
	IF (MpAxConveyor.Home AND MpAxConveyor.IsHomed) OR MpAxConveyor.Error THEN
		MpAxConveyor.Home := FALSE;
	END_IF
	
	IF MC_BR_TrackingFrameCreate_0.Done OR MC_BR_TrackingFrameCreate_0.Error THEN
		MC_BR_TrackingFrameCreate_0.Execute	:= FALSE;
	END_IF
			
	IF MC_BR_TrackingFrameDelete_0.Done OR MC_BR_TrackingFrameDelete_0.Error THEN
		MC_BR_TrackingFrameDelete_0.Execute := FALSE;
	END_IF
	
	IF MC_MoveVelocity_0.Error OR MC_MoveVelocity_0.CommandAborted OR MC_MoveVelocity_0.Busy THEN
		MC_MoveVelocity_0.Execute := FALSE;
	END_IF
	
	IF MC_MoveAdditive_0.Error OR MC_MoveAdditive_0.CommandAborted OR MC_MoveAdditive_0.Busy OR MC_MoveAdditive_0.Done THEN
		MC_MoveAdditive_0.Execute := FALSE;
	END_IF
		
	IF MC_Stop_0.Error OR MC_Stop_0.CommandAborted OR MC_Stop_0.Busy OR MC_Stop_0.Done THEN
		MC_MoveAdditive_0.Execute := FALSE;
	END_IF
	
	IF MC_BR_TrackingPathReset_0.Busy OR MC_BR_TrackingPathReset_0.Error OR MC_BR_TrackingPathReset_0.Done THEN
		MC_BR_TrackingPathReset_0.Execute := FALSE;	
	END_IF
	
	IF MC_BR_TrackingPathReadInfo_0.Error THEN
		MC_BR_TrackingPathReadInfo_0.Enable := FALSE;
	END_IF
	
	
END_ACTION

ACTION initConveyor:
	
	// Configure Frame Buffer, to get actual pointer to Products --> Check state of Products
	MC_BR_TrackingPathGetFrames_0.Parameters.CoordSystem := mcACS;
	MC_BR_TrackingPathGetFrames_0.Parameters.DataAddress := ADR(Products);
	MC_BR_TrackingPathGetFrames_0.Parameters.GetMode	:= mcTRKPATH_GET_MOD_ALL_FRAMES;
	MC_BR_TrackingPathGetFrames_0.Parameters.InfoMode	:= mcTRKPATH_INFO_MOD_ALL;
	MC_BR_TrackingPathGetFrames_0.Parameters.NumberOfFrames := MAX_TRACKING_FRAMES;
	MC_BR_TrackingPathGetFrames_0.Parameters.TrackingFrameID := 0;
	
	// Set Default Parameters of the Tracking Frames
	MC_BR_TrackingFrameCreate_0.Parameters.Attribute	:= 0;
	MC_BR_TrackingFrameCreate_0.Parameters.Translation.X := 0.0;
	MC_BR_TrackingFrameCreate_0.Parameters.Translation.Y := 0.0;
	MC_BR_TrackingFrameCreate_0.Parameters.Translation.Z := 0.0;
	MC_BR_TrackingFrameCreate_0.Parameters.Orientation.Angle1 := 0.0;
	MC_BR_TrackingFrameCreate_0.Parameters.Orientation.Angle2 := 0.0;
	MC_BR_TrackingFrameCreate_0.Parameters.Orientation.Angle3 := 0.0;
	MC_BR_TrackingFrameCreate_0.Parameters.Orientation.Type := 0;
	
	MC_BR_TrackingPathReadStatus_0.Enable := TRUE;
	MC_BR_TrackingPathReadInfo_0.Enable := TRUE;
	
	// Configuration of movement command
	MC_MoveAdditive_0.Acceleration := 1000;
	MC_MoveAdditive_0.Deceleration := 1000;
	MC_MoveAdditive_0.Jerk := 10000;
	MC_MoveAdditive_0.BufferMode := mcABORTING;
	
	MC_MoveVelocity_0.Acceleration := 1000;
	MC_MoveVelocity_0.Deceleration := 1000;
	MC_MoveVelocity_0.Direction := mcDIR_POSITIVE;
	MC_MoveVelocity_0.BufferMode := mcABORTING;
	
	MC_Stop_0.Deceleration := 1000;
	MC_Stop_0.Jerk := 10000;	
	
	
	// Belt Position of fixed tracking frame
	ParkPosition := 0;
	
END_ACTION