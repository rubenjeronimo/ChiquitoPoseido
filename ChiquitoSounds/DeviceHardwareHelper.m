//
//  DeviceHardwareHelper.m
//  ChiquitoSounds
//
//  Created by Ruben Jeronimo Fernandez on 09/07/14.
//  Copyright (c) 2014 IronHack. All rights reserved.
//

#import "DeviceHardwareHelper.h"
#import <AVFoundation/AVFoundation.h>

typedef void(^SIMPLE_BLOCK)();

@interface DeviceHardwareHelper()
@property (nonatomic,strong) SIMPLE_BLOCK enterBlock;
@property (nonatomic,strong) SIMPLE_BLOCK leaveBlock;
@end

@implementation DeviceHardwareHelper

-(instancetype)init{
    self = [super init];
    if (self) {
        [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(proximityStateChange) name:UIDeviceProximityStateDidChangeNotification object:nil];

    }
    return self;
}

+(void)vibrate {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}




+(void)torchOn{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType: AVMediaTypeVideo];
    [device lockForConfiguration:nil];
    [device setTorchMode: AVCaptureTorchModeOn];
    [device unlockForConfiguration];
}

+(void)torchOff{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType: AVMediaTypeVideo];
    [device lockForConfiguration:nil];
    [device setTorchMode: AVCaptureTorchModeOff];
    [device unlockForConfiguration];
}

-(void)onProximityEventApproachDoThis:(SIMPLE_BLOCK)action{
    self.enterBlock = action;
    
}

-(void)onProximityEventLeavingDoThis:(SIMPLE_BLOCK)action{
    self.leaveBlock = action;
}

-(void)proximityStateChange{
    if ([[UIDevice currentDevice]proximityState]==YES) { //close to the user
        //lanzar onapproach
        
    }else{
        //lanzar leaving
        
    }
    
}
@end
