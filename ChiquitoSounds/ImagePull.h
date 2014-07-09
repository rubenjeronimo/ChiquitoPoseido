//
//  ImagePull.h
//  ChiquitoSounds
//
//  Created by Ruben Jeronimo Fernandez on 09/07/14.
//  Copyright (c) 2014 IronHack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImagePull : NSObject

@property (nonatomic,strong) NSMutableArray *images;
@property (nonatomic,strong) UIImageView *imagenFondo;


-(UIImage *)nextImage;
-(NSString *)nextImageName;

-(void)addImageNamed:(NSString *)imageName;

-(NSArray *) imageNames;

-(id)init;
-(id)initWithFileName:(NSString *)fileName;

@end
