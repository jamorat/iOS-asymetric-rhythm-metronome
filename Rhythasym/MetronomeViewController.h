//
//  MetronomeViewController.h
//  Metrognome
//
//  Created by Brian Sleeper and Jack Amoratis on 5/17/14.
//  Copyright (c) 2015 R. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>



SystemSoundID toneSound;
@interface MetronomeViewController : UIViewController< UICollectionViewDataSource, UICollectionViewDelegate,UIGestureRecognizerDelegate >{
    UIImageView *ball;
    UIView *ball2;
    UILabel *xCoord;
    UILabel *yCoord;
    CGPoint startpoint;
}
@property (strong, nonatomic) IBOutlet UIView *junjun;

@property (strong, nonatomic) IBOutlet UIView *thumbTab;
@property (strong, nonatomic) IBOutlet UIButton *thumbTabButton;

@property (strong, nonatomic) IBOutlet UILabel *thumbButtonLabel;

- (IBAction)helpButtonPressed:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UILabel *helpText1;
@property (strong, nonatomic) IBOutlet UILabel *helpText2;
@property (strong, nonatomic) IBOutlet UILabel *helpText3;
@property (strong, nonatomic) IBOutlet UILabel *helpText4;
@property (strong, nonatomic) IBOutlet UILabel *helpText5;

@property (strong, nonatomic) IBOutlet UILabel *helpQuestionMarkLabel;


@property(nonatomic,retain) UILongPressGestureRecognizer *longpressGesture;
@property(nonatomic, retain) UITapGestureRecognizer * tapPressGesture;
@property(nonatomic, retain) UITapGestureRecognizer * tapTempoNumberGesture;
@property(nonatomic,retain) IBOutlet UIImageView *ball;
@property (strong, nonatomic) IBOutlet UIView *ball2;
@property (strong, nonatomic) IBOutlet UILabel *ball2Label;
- (IBAction)playButton:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *playButton;
@property (nonatomic, assign) int start_note_number;
@property(nonatomic,retain) IBOutlet UILabel *xCoord;
@property(nonatomic,retain) IBOutlet UILabel *yCoord;
@property CGPoint startPoint;
@property (nonatomic,retain) IBOutlet UIView *dragView;

@property (strong, nonatomic) IBOutlet UILabel *eighthLabel;
@property (strong, nonatomic) IBOutlet UILabel *quarterLabel;
@property (strong, nonatomic) IBOutlet UILabel *halfLabel;
@property (strong, nonatomic) IBOutlet UILabel *dottedHalfLabel;
@property (strong, nonatomic) IBOutlet UIButton *goButton;
- (IBAction)pushedGoButton:(id)sender;
@property (retain) NSMutableArray *beatsArray;
@property (nonatomic, assign) int currentBpm;
@property (strong,nonatomic) NSTimer *bpmTimer;
@property (strong,nonatomic) NSTimer *firstLoadTimer;
@property (strong,nonatomic) NSTimer *numberGaugeTimer;
@property (strong, nonatomic) IBOutlet UISlider *bpmSlideController;
- (IBAction)bpmSlideControllerAction:(UISlider *)sender;
@property (nonatomic,strong) IBOutlet UICollectionView *beatsUICollectionView;
@property (nonatomic, strong) IBOutlet UIView * numbersView;

@property (nonatomic, assign) int xPo;
@property (nonatomic, assign) NSInteger start_cell;
@property (nonatomic, assign) NSInteger activeCell;
@property (nonatomic, assign) NSInteger previousCell;

@property (nonatomic, assign) BOOL longFlag;
- (void)metroAct;
- (IBAction)addItem:(UIButton *)sender;
@property (nonatomic, assign) CGRect newFrame;
@property (strong, nonatomic) IBOutlet UIButton *plusButton;
@property (strong, nonatomic) IBOutlet UIButton *clearButton;
@property (strong, nonatomic) IBOutlet UIButton *editButton;
- (IBAction)editButtonPush:(id)sender;

- (IBAction)clearButtonPressed:(UIButton *)sender;
@property (nonatomic) int lastQuestionStep;
@property (nonatomic) int stepValue;
@property (nonatomic, assign) int currentBeat;
@property (nonatomic, assign) int beatType;
@property float quarterMilisec;
@property float eighthMilisec;
@property float halfMilisec;
@property float dottedHalfMilisec;
@property float timerInterval;
@property (strong, nonatomic) IBOutlet UIView *whole_note_line;
@property (strong, nonatomic) IBOutlet UIView *half_note_line;
@property (strong, nonatomic) IBOutlet UIView *quarter_note_line;
@property (strong, nonatomic) IBOutlet UIView *dotted_half_note_line;

- (IBAction)thumbTabButtonPressed:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *thumbTabNumberLabel;
@property (strong, nonatomic) IBOutlet UILabel *thumbTabCountLabel;

@end


