# mapp-robotics-tracking-sample

## Introduction
This sample serves as an introduction to the mapp Robotics tracking technology with a Codian D5 robot.

<video src="docs/vid/D5DemoVideo.mp4" width="320" height="240" controls></video>

### Features
* multible mappMotion features are used in the demo
  * Tracking on products out of workspace
  * Product load switching
  * Pick&place with Multigripper
* Automatic scene generation for Scene Viewer 6.x
  

## Requirements

* Automation Studio/Runtime 6.x
* mapp Motion 6.2
* Scene Viewer 6.1.x
<img src="docs/img/Requirements.png" width="400"/>

## How-to
* [Download the last release](https://github.com/br-automation-com/mapp-robotics-extended-tracking-sample/releases)↑ of project and open with AS
* Enable simulation, build and transfer the project. Wait for RUN.
* Open a watch window and use the ::ControlPanel:Input structure to start different scenarios
* Watch the action in Scene Viewer (User & Password: gmctest)


### Start application demo
To select an application add the variable ControlPanel to the watch window. 
<img src="docs/img/StartApplication.png" width="700"/>

The NC Programs (Track.st) are located directly in the project folder root. The file device reference is set to the FileDevices folder.
<img src="docs/img/FileDevice.png" width="400"/>


## Detail application description
The application example includes a Pick and Place application which takes products from an infeed belt and places them on an outfeed belt.
With a Codian D5 robot the orientation of the products changes. 

```

PROGRAM _MAIN
    MaxPickPosX  := 600;
    MinPickPosX  := 0;
    MaxPlacePosX := 600;
    MinPlacePosX := 100;
     
    //Absolute();
    Feedrate(15000);                        // default feedrate non rapid 
    SetPCS(MachineFrame);                   // reset frame in case of restart
    MoveAR(ParkPosA);
    MoveLR(ParkPos);                        // move to par position
    WaitTime(2.0);
    InTracking := FALSE;
    WHILE TRUE DO
        IF PickTrackingObject <> 0 THEN                                       // A product is in area of interest, lets start
             
            InTracking := TRUE;                                             // Flag indication of tracking mode
            ActObj ACCESS PickTrackingObject;                               // Access the pointer structure of an object           
            TrackObjectR(ActObj.TrackingFrameID, TakePosUpSync, 50, 50);        // Move to the take position
            MoveLR(TakePos1Down);                                           // Move from upper position to the height where the product is grapped
            AccuracyHold();                                                 // Simulate Grabber close time
            SetProductLoad('ProductLoad_1');                                // Change dynamic parameter
            SetM(8);                                                        // Take the product
            WaitUntilSync(PickTrackingObject <> ADR(ActObj));             // Wait until the next place slot is avaliable --> here is no fallback to track stop!
            MoveLR(TakePos1Up);                                             // lift the product
             
            WaitUntil(PickTrackingObject <> 0);
            ActObj ACCESS PickTrackingObject;                               // Access the pointer structure of an object
            TrackObjectR(ActObj.TrackingFrameID, TakePos2Up, 50, 50);       // Move to the take position
            MoveLR(TakePos2Down);                                           // Move from upper position to the height where the product may be grapped
            AccuracyHold();                                                 // Simulate Grabber close time
            SetProductLoad('ProductLoad_2');                                // Change dynamic parameter
            SetM(9);                                                        // Take the product
            WaitALAP();                                                     // wait here to select box target
            MoveLR(TakePos3Up);                                             // lift the product
             
            IF PlaceTrackingObject = 0 THEN
                TrackStopR(MachineFrame, ParkPos, 50, 50);                  // Call and wait for a box if nothing is there
                WaitUntilSync(PlaceTrackingObject <> 0);                  // clear motion chain and wait
            END_IF
             
            ActObj ACCESS PlaceTrackingObject;                              // Change reference to get frame ID
            TrackObjectR(ActObj.TrackingFrameID, SynchPosUpPlace1, 50, 50); // Start positoin to place first element
             
            SetM(20);                                                       // Disable Workspace Monitoring
            MoveLR(SynchPosDownPlace1);                                     // Move inside the box
            MoveL(SynchPosDownPlace1_1);                                    // Move to place position of element 1
            WaitTime(0.2);                                                  // Simulate Grabber open time
            SetProductLoad('ProductLoad_1');                                // Change dynamic parameter
            SetM(17);                                                       // place the product
            MoveL(SynchPosDownPlace1);                                      // move back to inside box position
            MoveLR(SynchPosUpPlace1);                                       // Move to outside box position
             
            MoveL(SynchPosUpPlace2);                                        // Change orientation to place next product
            MoveL(SynchPosDownPlace2);                                      // Move inside the box
            MoveL(SynchPosDownPlace2_1);                                    // place element 2
            WaitTime(0.2);                                                  // Simulate Grabber open time
            ResetProductLoad();
            SetM(16);                                                       // place the product
            MoveL(SynchPosDownPlace2);                                      // move back to inside start position
            MoveLR(SynchPosUpPlace2);                                       // move to outside box position
            SetM(21);                                                       // Enable Workspace Monitoring
 
             
        ELSE
            IF InTracking THEN
                TrackStopR(MachineFrame, ParkPos, 50, 50);                  // Call a track stop to move to an BCS park position
            END_IF
         
            InTracking := FALSE;                                            // Flag indication of tracking mode
            MoveLR(ParkPos);                                                // Move to park position
            WaitEndMove();                                                  // Be sure that the movement has been stopped          
            WaitIp();                                                       // wait until next product is avaliable
        END_IF
 
    END_WHILE
     
END_PROGRAM
```
