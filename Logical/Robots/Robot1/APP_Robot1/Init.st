PROGRAM _INIT
	
	// This action defines the links to the conveyeor and the robot
	DefineLinks;
	
	// M-Functions triggered in Interpreter Program
	M8;
	M9;
	M16;
	M17;
	
	
	MC_BR_TrackingPathReadStatus_In.TrackingPath 				:= TrackLinkConveyorIn;
	MC_BR_TrackingPathReadStatus_In.Enable						:= TRUE;
	MC_BR_TrackingPathGetFrames_In.TrackingPath 				:= TrackLinkConveyorIn;
	MC_BR_TrackingPathGetFrames_In.Parameters.CoordSystem		:= mcACS;
	MC_BR_TrackingPathGetFrames_In.Parameters.DataAddress 		:= ADR(Products_In);
	MC_BR_TrackingPathGetFrames_In.Parameters.GetMode			:= mcTRKPATH_GET_MOD_ALL_FRAMES;
	MC_BR_TrackingPathGetFrames_In.Parameters.InfoMode			:= mcTRKPATH_INFO_MOD_ALL;
	MC_BR_TrackingPathGetFrames_In.Parameters.NumberOfFrames 	:= SIZEOF(Products_In)/SIZEOF(McTrkFrmInfoType);
	MC_BR_TrackingPathGetFrames_In.Parameters.TrackingFrameID 	:= 0;	
	
	MC_BR_TrackingPathReadStatus_Out.TrackingPath 				:= TrackLinkConveyorOut;
	MC_BR_TrackingPathReadStatus_Out.Enable						:= TRUE;
	MC_BR_TrackingPathGetFrames_Out.TrackingPath 				:= TrackLinkConveyorOut;
	MC_BR_TrackingPathGetFrames_Out.Parameters.CoordSystem		:= mcACS;
	MC_BR_TrackingPathGetFrames_Out.Parameters.DataAddress 		:= ADR(Products_Out);
	MC_BR_TrackingPathGetFrames_Out.Parameters.GetMode			:= mcTRKPATH_GET_MOD_ALL_FRAMES;
	MC_BR_TrackingPathGetFrames_Out.Parameters.InfoMode			:= mcTRKPATH_INFO_MOD_ALL;
	MC_BR_TrackingPathGetFrames_Out.Parameters.NumberOfFrames 	:= SIZEOF(Products_Out)/SIZEOF(McTrkFrmInfoType);
	MC_BR_TrackingPathGetFrames_Out.Parameters.TrackingFrameID 	:= 0;	
	
	
	MC_GroupReadActualPosition_X.CoordSystem := mcMCS;
	MC_GroupReadActualPosition_X.Enable := TRUE;
	
	// Offset of the Robot (Object Hierachy)
	MC_BR_TrackingStatus_PathGen_X.Enable := TRUE;
	MC_BR_GroupReadInfo_X.Enable := TRUE;
	MC_GroupReadStatus_X.Enable := TRUE;
	MC_BR_PathInfo_X.Enable := TRUE;

	
END_PROGRAM