//
//  MetronomeViewController.h
//  Metrognome
//
//  Created by R on 5/17/14.
//  Copyright (c) 2014 R. All rights reserved.
//

#import <UIKit/UIKit.h>
// need this include file and the AudioToolbox framework
#import <AudioToolbox/AudioToolbox.h>

// also need an instance variable like so:
SystemSoundID sound1;
SystemSoundID sound2;
SystemSoundID sound3;



@interface MetronomeViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UILabel *bpmDisplay;
@property (strong, nonatomic) IBOutlet UIButton *goButton;
- (IBAction)pushedGoButton:(id)sender;
@property (strong, nonatomic) IBOutlet UISlider *bpmSlideController;
- (IBAction)bpmSlideControllerAction:(UISlider *)sender;

- (void *)enableTimer;
- (void *)metroAct;
@property (nonatomic, assign) int currentBpm;
- (IBAction)stopTimer:(id)sender;
@property (strong,nonatomic) NSTimer *bpmTimer;
@end


