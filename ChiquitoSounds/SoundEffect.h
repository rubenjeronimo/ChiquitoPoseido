//
//  SoundEffect.h
//  ChiquitoSounds
//
//  Created by Ruben Jeronimo Fernandez on 09/07/14.
//  Copyright (c) 2014 IronHack. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SoundEffect;

@protocol SoundEffectDelegate<NSObject>
@optional
-(void) soundEffectDidFinishPlaying:(SoundEffect *)soundEffect;
@end


@interface SoundEffect : NSObject
@property (nonatomic,weak) id<SoundEffectDelegate>delegate;
-(void)play:(NSString *)soundFileName;
-(void) stop;
@end


