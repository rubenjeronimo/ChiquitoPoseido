//
//  ViewController.m
//  ChiquitoSounds
//
//  Created by Ruben Jeronimo Fernandez on 09/07/14.
//  Copyright (c) 2014 IronHack. All rights reserved.
//

#import "ViewController.h"

#import "DeviceHardwareHelper.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "ImagePull.h"
#import "SoundEffect.h"

@interface ViewController () <UINavigationControllerDelegate,UIImagePickerControllerDelegate,SoundEffectDelegate>
@property (nonatomic,strong) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UIImageView *imagenFondo;
@property (nonatomic,strong) NSArray *images;
@property (nonatomic,strong) ImagePull *pool;
@property (nonatomic,strong) SoundEffect *effect;
@property (nonatomic,strong) IBOutlet DeviceHardwareHelper *deviceHelper;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.pool = [[ImagePull alloc]initWithFileName:@"ImagenesChiquito"];
    self.effect = [[SoundEffect alloc]init];
    __weak typeof (self) weakSelf = self;
    [self.deviceHelper onProximityEventApproachDoThis:^{
        [weakSelf.effect play:@"Muelas"];
    
    }];
    [self.deviceHelper onProximityEventLeavingDoThis:^{
        [self.effect play:@"Trigo"];
    }];
    
    [self timer];
    
    [self apagar];
    
    self.effect.delegate = self;
    self.motionManager = [[CMMotionManager alloc] init];
    if (self.motionManager.accelerometerAvailable) {

    self.motionManager.accelerometerUpdateInterval = .2;
    self.motionManager.gyroUpdateInterval = .2;
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
                                             withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
                                                 if (fabs (accelerometerData.acceleration.z>0.9 && accelerometerData.acceleration.x<0.1 && accelerometerData.acceleration.y<0.1)) {
                                                     [self callaChiquito];
                                                 }else if (fabs(accelerometerData.acceleration.y>0.9 && accelerometerData.acceleration.x<0.1 && accelerometerData.acceleration.z<0.1)){
                                                     [self cantaChiquito];
                                                 }
                                             }];
    }
    UISwipeGestureRecognizer *left = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(useCameraRoll:)];
    [left setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.imagenFondo addGestureRecognizer:left];
    
    UISwipeGestureRecognizer *right = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(useCamera:)];
    [right setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.imagenFondo addGestureRecognizer:right];
}


- (void) useCamera:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker =
        [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType =
        UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker
                           animated:YES completion:nil];
//        _newMedia = YES;
    }
}
//# Choose a photo from photoroll

- (void) useCameraRoll:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        UIImagePickerController *imagePicker =
        [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType =
        UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker
                           animated:YES completion:nil];
//        _newMedia = NO;
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        
        _imagenFondo.image = image;
   
    }
   
}

-(void)apagar{
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(callaChiquito)];
    doubleTapRecognizer.numberOfTapsRequired=2;
    [self.view addGestureRecognizer:doubleTapRecognizer];
    
}

-(BOOL)canBecomeFirstResponder{
    return YES;
}



-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

-(void) viewWillDisappear:(BOOL)animated{
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}

-(NSTimer *)timer{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:3.0
                                                  target:self
                                                selector:@selector(cantaChiquito)
                                                userInfo:nil
                                                 repeats:YES];
    }
    return _timer;
}



-(void)cantaChiquito{
    NSLog(@"chiquito");
    [self.effect play:@"Trigo"];
    [DeviceHardwareHelper vibrate];
    [DeviceHardwareHelper torchOn];
}

-(void) callaChiquito{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    if (motion==UIEventSubtypeMotionShake) {
        NSLog(@"🐻");
        UIImage *img = [self.pool nextImage];
        self.imagenFondo.image = img;
    }
}

-(void) soundEffectDidFinishPlaying:(SoundEffect *)soundEffect{
    NSLog(@"giggigigi");
}

@end
