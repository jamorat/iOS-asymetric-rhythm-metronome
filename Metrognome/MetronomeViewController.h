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
@property (strong, nonatomic) IBOutlet UILabel *quarterNote;
@property (strong, nonatomic) IBOutlet UILabel *halfNote;
@property (strong, nonatomic) IBOutlet UILabel *dottedHalfNote;

@property (strong, nonatomic) IBOutlet UIButton *goButton;
- (IBAction)pushedGoButton:(id)sender;
@property (retain) NSMutableArray *timeItems;

@property (nonatomic, assign) int currentBpm;
@property (strong,nonatomic) NSTimer *bpmTimer;
@property (strong,nonatomic) NSTimer *firstLoadTimer;
- (IBAction)bpmSlideControllerAction:(UISlider *)sender;
- (void)metroAct;
@property (strong, nonatomic) IBOutlet UIImageView *draggableNoteIcon;
- (IBAction)addItem:(UIButton *)sender;
- (IBAction)deleteLastItem:(UIButton *)sender;
- (IBAction)loadPattern:(UIButton *)sender;
- (IBAction)savePattern:(UIButton *)sender;
@property (nonatomic, assign) CGRect newFrame;
@property (strong, nonatomic) IBOutlet UIButton *rotateTheTableButton;
@property (strong, nonatomic) IBOutlet UITableView *notesTableView;
@property (strong, nonatomic) IBOutlet UIButton *plusButton;
@property (strong, nonatomic) IBOutlet UIButton *clearButton;
@property (strong, nonatomic) IBOutlet UIButton *editButton;
- (IBAction)editButtonPush:(id)sender;

//Set slider step
@property (strong, nonatomic) IBOutlet UISlider *bpmSlideController;

//@property (nonatomic, retain) IBOutlet UISlider* questionSlider;
@property (nonatomic) int lastQuestionStep;
@property (nonatomic) int stepValue;
@end


