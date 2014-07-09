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



@interface ViewController () <AVAudioPlayerDelegate>
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
    
	// Do any additional setup after loading the view, typically from a nib.
    
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
