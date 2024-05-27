#include 'ProdDetails.typ'
////////////////////////////////////////////////////////////////////////////////////
// INPUT Variables - read state of the selected products from the PLC
	// PlaceTrackingObject : UDINT;							 Pointer to next object (GCS)
	// PickTrackingObject : UDINT;							 Pointer to next object (GCS)

// OUTPUT Variables - set the parameters to the PLC
	// MaxPickPosX : LREAL;								 	Maximum Position where robot is able to grab something (BCS)
	// MinPickPosX : LREAL;								 	Minimum Position where objects are given to the robot (BCS)
	// MaxPlacePosX : LREAL;								Maximum Position where robot is able to grab something (BCS)
	// MinPlacePosX : LREAL;								Minimum Position where objects are given to the robot (BCS)


VAR
	ActObj : REFERENCE TO ProductDetailsType;
	InTracking			: BOOL;
	ParkPosA 			: McAxisTargetType := (SlaveAxis:=[0, 0, 0, 0]);
	ParkPos 			: McPointType := (Pos:=(X:=   0, Y:= 0, 			Z:= 130), 	Orient:=(Angle1:= 0, Angle2:= 0,  Angle3:= 0));
	TakePosUpSync		: McPointType := (Pos:=(X:=   50, Y:= 0, 			Z:= 70), 	Orient:=(Angle1:= 90, Angle2:= 0,  Angle3:= 0));
	TakePos1Up			: McPointType := (Pos:=(X:=   50, Y:= 0, 			Z:= 30), 	Orient:=(Angle1:= 90, Angle2:= 0,  Angle3:= 0));
	TakePos1Down		: McPointType := (Pos:=(X:=   50, Y:= 0, 			Z:= 20), 	Orient:=(Angle1:= 90, Angle2:= 0,  Angle3:= 0));
	TakePos2Up			: McPointType := (Pos:=(X:=   50, Y:= 0, 			Z:= 30), 	Orient:=(Angle1:= -90, Angle2:= 0,  Angle3:= 0));
	TakePos2Down		: McPointType := (Pos:=(X:=   50, Y:= 0, 			Z:= 20), 	Orient:=(Angle1:= -90, Angle2:= 0,  Angle3:= 0));
	TakePos3Up			: McPointType := (Pos:=(X:=   50, Y:= 0, 			Z:= 70), 	Orient:=(Angle1:= -90, Angle2:= 0,  Angle3:= 0));
	SynchPosUpPlace1		: McPointType := (Pos:=(X:=   0, Y:= 0, 		Z:= 130), 	Orient:=(Angle1:= 90, Angle2:= 0,  Angle3:= 0));
	SynchPosDownPlace1		: McPointType := (Pos:=(X:=   0, Y:= 0, 		Z:= 125), 	Orient:=(Angle1:= 90, Angle2:= 90,  Angle3:= 0));
	SynchPosDownPlace1_1	: McPointType := (Pos:=(X:=   -130, Y:= 0, 		Z:= 125), 	Orient:=(Angle1:= 90, Angle2:= 90,  Angle3:= 0));
	SynchPosUpPlace2		: McPointType := (Pos:=(X:=   0, Y:= 0, 		Z:= 130), 	Orient:=(Angle1:= 90, Angle2:= 0,  Angle3:= 0));
	SynchPosDownPlace2		: McPointType := (Pos:=(X:=   0, Y:= 0, 		Z:= 125), 	Orient:=(Angle1:= 90, Angle2:= -90,  Angle3:= 0));
	SynchPosDownPlace2_1	: McPointType := (Pos:=(X:=   130, Y:= 0, 		Z:= 125), 	Orient:=(Angle1:= 90, Angle2:= -90,  Angle3:= 0));
	
	F_C1 : McFrameType := (Pos:=(X:=-150, Y:=350, Z:=0));
    F_0 : McFrameType := (0);
    C1 : McMonitoredCuboidType := (DimensionX:=300,DimensionY:=650,DimensionZ:=150);
END_VAR


PROGRAM _MAIN
	MaxPickPosX  := 600;
	MinPickPosX  := 0;
	MaxPlacePosX := 600;
	MinPlacePosX := 100;
	
	//Absolute();
	Feedrate(15000);						// default feedrate non rapid  
	SetPCS(MachineFrame);					// reset frame in case of restart
	MoveAR(ParkPosA);
	MoveLR(ParkPos);						// move to par position
	WaitTime(2.0);
	InTracking := FALSE;
	WHILE TRUE DO
		IF PickTrackingObject <> 0 THEN										// A product is in area of interest, lets start 
			
			InTracking := TRUE;												// Flag indication of tracking mode
			ActObj ACCESS PickTrackingObject;								// Access the pointer structure of an object			
			TrackObjectR(ActObj.TrackingFrameID, TakePosUpSync, 50, 50); 		// Move to the take position 
			MoveLR(TakePos1Down);											// Move from upper position to the height where the product is grapped
			AccuracyHold();													// Simulate Grabber close time
			SetProductLoad('ProductLoad_1');								// Change dynamic parameter
			SetM(8);														// Take the product
			WaitUntilSync(PickTrackingObject <> ADR(ActObj));				// Wait until the next place slot is avaliable --> here is no fallback to track stop!
			MoveLR(TakePos1Up);												// lift the product
			
			WaitUntil(PickTrackingObject <> 0);
			ActObj ACCESS PickTrackingObject;								// Access the pointer structure of an object
			TrackObjectR(ActObj.TrackingFrameID, TakePos2Up, 50, 50); 		// Move to the take position 
			MoveLR(TakePos2Down);											// Move from upper position to the height where the product may be grapped
			AccuracyHold();													// Simulate Grabber close time
			SetProductLoad('ProductLoad_2');								// Change dynamic parameter
			SetM(9);														// Take the product
			WaitALAP();														// wait here to select box target
			MoveLR(TakePos3Up);												// lift the product
			
			IF PlaceTrackingObject = 0 THEN
				TrackStopR(MachineFrame, ParkPos, 50, 50);					// Call and wait for a box if nothing is there
				WaitUntilSync(PlaceTrackingObject <> 0);					// clear motion chain and wait
			END_IF
			
			ActObj ACCESS PlaceTrackingObject;								// Change reference to get frame ID
			TrackObjectR(ActObj.TrackingFrameID, SynchPosUpPlace1, 50, 50); // Start positoin to place first element
			
			SetM(20);														// Disable Workspace Monitoring
			MoveLR(SynchPosDownPlace1);										// Move inside the box
			MoveL(SynchPosDownPlace1_1);									// Move to place position of element 1
			WaitTime(0.2);													// Simulate Grabber open time
			SetProductLoad('ProductLoad_1');								// Change dynamic parameter
			SetM(17);														// place the product
			MoveL(SynchPosDownPlace1);										// move back to inside box position
			MoveLR(SynchPosUpPlace1);										// Move to outside box position
			
			MoveL(SynchPosUpPlace2);										// Change orientation to place next product
			MoveL(SynchPosDownPlace2);										// Move inside the box
			MoveL(SynchPosDownPlace2_1);									// place element 2
			WaitTime(0.2);													// Simulate Grabber open time
			ResetProductLoad();
			SetM(16);														// place the product
			MoveL(SynchPosDownPlace2);										// move back to inside start position
			MoveLR(SynchPosUpPlace2);										// move to outside box position
			SetM(21);														// Enable Workspace Monitoring

			
		ELSE
			IF InTracking THEN
				TrackStopR(MachineFrame, ParkPos, 50, 50);					// Call a track stop to move to an BCS park position
			END_IF
		
			InTracking := FALSE;											// Flag indication of tracking mode
			MoveLR(ParkPos);												// Move to park position
			WaitEndMove();													// Be sure that the movement has been stopped			
			WaitIp();														// wait until next product is avaliable
		END_IF

	END_WHILE
	
END_PROGRAM

 