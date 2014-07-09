//
//  ViewController.h
//  ChiquitoSounds
//
//  Created by Ruben Jeronimo Fernandez on 09/07/14.
//  Copyright (c) 2014 IronHack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@interface ViewController : UIViewController
@property (strong, nonatomic) CMMotionManager *motionManager;
@end
