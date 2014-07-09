//
//  DeviceHardwareHelper.h
//  ChiquitoSounds
//
//  Created by Ruben Jeronimo Fernandez on 09/07/14.
//  Copyright (c) 2014 IronHack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceHardwareHelper : NSObject

-(void)onProximityEventApproachDoThis:(void(^)())action;
-(void)onProximityEventLeavingDoThis:(void(^)())action;
+(void)vibrate;
+(void)torchOn;
+(void)torchOff;

@end
