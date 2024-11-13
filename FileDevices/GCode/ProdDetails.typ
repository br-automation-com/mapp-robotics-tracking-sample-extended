
TYPE
	ProductDetailsType : 	STRUCT  (*Additional data added as attributes to every tracking object*)
		This : UDINT; (*Adress to the memory - debugging*)
		Element1 : BOOL; (*Gripper is close, product in manipulation*)
		Element2 : BOOL; (*Gripper is close, product in manipulation*)
		Used : BOOL; (*Gripper is close, product in manipulation*)
		Pos : McPosType; (*Actual Position of object*)
		TrackingFrameID : UDINT; (*tracking frame id*)
		InTracking : BOOL; (*Object is now active in Tracking*)
	END_STRUCT;
	DevicesListEnum : 
		( (*device definition of manipulating robots and axis*)
		DEV_Conveyor := 0, (*object id for conveyor*)
		DEV_Robot_1 := 1 (*id for robot 1*)
		);
END_TYPE
