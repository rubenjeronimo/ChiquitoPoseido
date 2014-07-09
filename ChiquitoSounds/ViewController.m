//
//  ViewController.m
//  ChiquitoSounds
//
//  Created by Ruben Jeronimo Fernandez on 09/07/14.
//  Copyright (c) 2014 IronHack. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolBox/AudioToolBox.h>
#import <MobileCoreServices/MobileCoreServices.h>


@interface ViewController () <AVAudioPlayerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic,strong) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UIImageView *imagenFondo;
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic,strong) NSArray *images;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self timer];
    
    [self apagar];
    
    self.player.delegate =self;
    
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
    
        UISwipeGestureRecognizer *left = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(useCameraRoll:)];
        [left setDirection:UISwipeGestureRecognizerDirectionLeft];
        [self.view addGestureRecognizer:left];
        
        UISwipeGestureRecognizer *right = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(useCamera:)];
        [right setDirection:UISwipeGestureRecognizerDirectionRight];
        [self.view addGestureRecognizer:right];
    }
	
    
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

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [self bombillaOFF];
}








-(void)apagar{
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(callaChiquito)];
    doubleTapRecognizer.numberOfTapsRequired=2;
    [self.view addGestureRecognizer:doubleTapRecognizer];
    
}

-(NSArray *)images{
    if (!_images) {
        NSString *filePath = [[NSBundle mainBundle]pathForResource:@"ImagenesChiquito" ofType:@"plist"];
        _images = [[NSArray alloc]initWithContentsOfFile:filePath];
    }
    return _images;
}

-(BOOL)canBecomeFirstResponder{
    return YES;
}

-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    if (motion==UIEventSubtypeMotionShake) {
        int x= arc4random() % self.images.count;
        NSLog(@"🐻");
        NSString *imag = [self.images objectAtIndex:x];
        self.imagenFondo.image = [UIImage imageNamed:imag];
    }
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

-(void)bombillaON{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType: AVMediaTypeVideo];
    [device lockForConfiguration:nil];
    [device setTorchMode: AVCaptureTorchModeOn];
    [device unlockForConfiguration];
}

-(void)bombillaOFF{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType: AVMediaTypeVideo];
    [device lockForConfiguration:nil];
    [device setTorchMode: AVCaptureTorchModeOff];
    [device unlockForConfiguration];
}

-(void)cantaChiquito{
    NSLog(@"chiquito");
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Trigo"ofType:@"wav"];
    NSError *err = nil;
    NSData *soundData = [[NSData alloc] initWithContentsOfFile:filePath options:NSDataReadingMapped error:&err];
    
    AVAudioPlayer *p = [[AVAudioPlayer alloc] initWithData:soundData error:&err];
    self.player = p;
    self.player.numberOfLoops = 0;
    [self.player play];
    [self bombillaON];
    AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
    
    
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

@end
