//
//  ImagePull.m
//  ChiquitoSounds
//
//  Created by Ruben Jeronimo Fernandez on 09/07/14.
//  Copyright (c) 2014 IronHack. All rights reserved.
//

#import "ImagePull.h"

@implementation ImagePull

-(UIImage *)nextImage{
    NSUInteger x = [self nextIndex];
    UIImage *img = [UIImage imageNamed:self.images[x]];
    return img;
}

-(NSUInteger)nextIndex{
    return arc4random() % self.images.count;
}

-(NSString *)nextImageName{
    NSUInteger x= [self nextIndex];
    return self.images[x];
}

-(void)addImageNamed:(NSString *)imageName{
    [self.images addObject:imageName];
}

-(NSArray *) imageNames{
    return [self.images copy];
}

-(id)init{
    self = [super init];
    if (self) {
        _images = [[NSMutableArray alloc]init];
    }
    return self;
}

-(id)initWithFileName:(NSString *)fileName{
    self = [super init];
    if (self) {
        NSString *filePath = [[NSBundle mainBundle]pathForResource:@"ImagenesChiquito" ofType:@"plist"];
        _images = [[NSMutableArray alloc]initWithContentsOfFile:filePath];
        
    }
    return self;
}



//-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
//    if (motion==UIEventSubtypeMotionShake) {
//        int x= arc4random() % self.images.count;
//        NSLog(@"🐻");
//        NSString *imag = [self.images objectAtIndex:x];
//        self.imagenFondo.image = [UIImage imageNamed:imag];
//    }
//}

//-(NSArray *)images{
//    if (!_images) {
//        self.filePath = [[NSBundle mainBundle]pathForResource:@"ImagenesChiquito" ofType:@"plist"];
//        _images = [[NSArray alloc]initWithContentsOfFile:self.filePath];
//    }
//    return _images;
//}
@end
