//
//  MetronomeViewController.m
//  Metrognome
//
//  Created by R on 5/17/14.
//  Copyright (c) 2014 R. All rights reserved.
//
#import "MetronomeAppDelegate.h"
#import "MetronomeViewController.h"
# undef M_PI_2
# define M_PI_2     1.57079632679489661923

@interface MetronomeViewController ()
@property (nonatomic, retain) IBOutlet UITableView *timingList;
@property (nonatomic, assign) int counter;
@property float currentItemMSTop;

@property float quarterNoteMS;
@property float eighthNoteMS;
@property float halfNoteMS;
@property float dottedHalfNoteMS;
@property (nonatomic, assign) int itemCounter;

@property (nonatomic) NSMutableArray *noteIcons;
@end

@implementation MetronomeViewController

MetronomeAppDelegate *metronomeAppDelegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    //_clearButton.titleLabel.font = [UIFont systemFontOfSize:20];
    _plusButton.titleLabel.font = [UIFont systemFontOfSize:20];
    //[_clearButton.setValue:UIFont fontWithName:@"Menu Regular" size:20.0];
    
    _timeItems = [NSMutableArray arrayWithObjects: @"1", @"2", @"3", @"3", nil];
    _noteIcons = [NSMutableArray arrayWithObjects:@"eighth-note.png",@"quarter-note.png",@"half-note.png",@"dotted-half-note.png",nil];
    [_timingList reloadData];
    NSLog(@"%@",_noteIcons[2]);
    NSLog(@"before: %lu ----",(unsigned long)[_timeItems count]);
    
    NSLog(@"after: %lu ----",(unsigned long)[_timeItems count]);
    
    //CGPoint oldCenter=_timingList.center;
    
    //_timingList.center=oldCenter;
    
    
    [_draggableNoteIcon setHidden:YES];
    [_draggableNoteIcon setHighlightedImage: [UIImage imageNamed: @"dotted-half-note.png"]];
    _draggableNoteIcon.highlighted=YES;
    NSLog(@"this be highted %u", _draggableNoteIcon.isHighlighted);// return YES
    _draggableNoteIcon.highlighted=NO;
    NSLog(@"this be highlighted %u", _draggableNoteIcon.isHighlighted);// return NO
    
    UIPanGestureRecognizer *redGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [_draggableNoteIcon addGestureRecognizer:redGesture];
    [self updateSlider];
    //[_rotateTheTableButton sendActionsForControlEvents: UIControlEventTouchUpInside];
    
    //[_notesTableView sendActionsForControlEvents: UIControlEventTouchUpInside];
    //CGPoint oldCenter=_timingList.center;
    //_timingList.transform=CGAffineTransformMakeRotation(-M_PI_2);
    //_timingList.center=oldCenter;
    
    CGRect tableFrame = _timingList.frame;
    tableFrame.size.height = 50;
    tableFrame.size.width = 50;
    
    self.stepValue = 1.0f;
    
    // Set the initial value to prevent any weird inconsistencies.
    self.lastQuestionStep = (self.bpmSlideController.value) / self.stepValue;
   
    [self.editButton setTitle:@"Edit" forState:UIControlStateNormal];
    
}



-(BOOL)shouldAutorotate{
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return TRUE;
}

- (NSUInteger)supportedInterfaceOrientations {
    return  UIInterfaceOrientationMaskAll;
}
-(void)handlePanGesture:(UIPanGestureRecognizer*) gesture{
    NSLog(@"gesture");
    [_timingList scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:11 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    if(UIGestureRecognizerStateChanged == gesture.state){
        //Use translation point
        CGPoint translation = [gesture translationInView:gesture.view];
        gesture.view.center = CGPointMake(gesture.view.center.x + translation.x, gesture.view.center.y + translation.y);
    
        
        //Clear translation
        [gesture setTranslation:CGPointZero inView:gesture.view];
    }
}

-(void)viewWillAppear:(BOOL)animated{
   
    }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)pushedGoButton:(id)sender {
    
        if ([[sender currentTitle] isEqualToString:@"Start"]) {
            NSLog(@"started");
            [sender setTitle:@"Stop" forState:UIControlStateNormal];
            [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        
        /*
        NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"crystal_ball" ofType:@"mp3"];
            
        NSURL *soundURL = [NSURL fileURLWithPath:soundPath];
        
        AudioServicesCreateSystemSoundID(CFBridgingRetain(soundURL), &sound3);
           */
            
        NSURL *soundURL = [[NSBundle mainBundle] URLForResource:@"singleClick" withExtension:@"aiff"];
        //AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL, &sound1);
        AudioServicesCreateSystemSoundID(CFBridgingRetain(soundURL), &sound1);
            
        NSURL *soundURL1 = [[NSBundle mainBundle] URLForResource:@"snap" withExtension:@"aiff"];
        //AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL1, &sound2);
        AudioServicesCreateSystemSoundID(CFBridgingRetain(soundURL1), &sound2);
        
        NSURL *soundURL2 = [[NSBundle mainBundle] URLForResource:@"low-click" withExtension:@"aiff"];
        //AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL2, &sound3);
        AudioServicesCreateSystemSoundID(CFBridgingRetain(soundURL2), &sound3);
            [self metroAct];
            
    }else{
        NSLog(@"stopped");
        [sender setTitle:@"Start" forState:UIControlStateNormal];
        [sender setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [_bpmTimer invalidate];
        _bpmTimer = nil;
    }
}

- (void)metroAct
{
    //get time of current cell
    NSString *whichSound = [_timeItems objectAtIndex:_counter];
    [_timingList scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_counter inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    //CURRENT CELL NOTE VALUE
    if ([whichSound isEqualToString:@"0"]){
        _currentItemMSTop = 60/_quarterNoteMS;
    }else if([whichSound isEqualToString:@"1"]){
        _currentItemMSTop = 60/_eighthNoteMS;
    }else if([whichSound isEqualToString:@"2"]){
        _currentItemMSTop = 60/_halfNoteMS;
    }else if([whichSound isEqualToString:@"3"]){
        _currentItemMSTop = 60/_dottedHalfNoteMS;
    }
    //NSLog(@"Here we go %f",_currentItemMSTop);
    
    //set timer for that time
    _bpmTimer = [NSTimer scheduledTimerWithTimeInterval:(_currentItemMSTop)
                                                 target:self selector:@selector(soundPlayMethod) userInfo:nil
                                                repeats:NO];
    //-----soundPlayMethod on timer trigger-----//
        //play sound
        //go to next cell
        //call this method again
}

- (void)soundPlayMethod{
    AudioServicesPlaySystemSound(sound2);
    NSLog(@"%i",_counter);
    if (_counter > ([_timeItems count]-1)){
        _counter = 0;
    }
    NSLog(@"%i just before reload",_counter);
    [_timingList reloadData];
    [self metroAct];
    _counter++;
}

- (IBAction)bpmSlideControllerAction:(UISlider *)sender {
    [self updateSlider];
}

-(void)updateSlider{
    float newStep = roundf((self.bpmSlideController.value) / self.stepValue);
    
    
    // Convert "steps" back to the context of the sliders values.
    self.bpmSlideController.value = newStep * self.stepValue;
    
    _eighthNoteMS = (float)self.bpmSlideController.value;
    _quarterNoteMS = (float)self.bpmSlideController.value/2;
    _halfNoteMS = (float)self.bpmSlideController.value/3;
    _dottedHalfNoteMS = (float)self.bpmSlideController.value/4;
    
    //self.bpmDisplay.text = [NSString stringWithFormat:@"%f %@",_eighthNoteMS,[self fractionEnding:_eighthNoteMS]];
    //NSString *ff = [self fractionEnding:_eighthNoteMS];
    //self.bpmDisplay.text = @"¼";//[NSString stringWithFormat:@"%C",0x00bd];
    self.bpmDisplay.text = [NSString stringWithFormat:@"%d %@",[self intFromFloat:_eighthNoteMS],[self fractionEnding:_eighthNoteMS]];
    
    self.quarterNote.text = [NSString stringWithFormat:@"%d %@",[self intFromFloat:_quarterNoteMS],[self fractionEnding:_quarterNoteMS]];
    self.halfNote.text = [NSString stringWithFormat:@"%d %@",[self intFromFloat:_halfNoteMS], [self fractionEnding:_halfNoteMS]];
    NSLog([self fractionEnding:_halfNoteMS]);
    
    self.dottedHalfNote.text = [NSString stringWithFormat:@"%d %@",[self intFromFloat:_dottedHalfNoteMS], [self fractionEnding:_dottedHalfNoteMS]];
    //NSLog([self generateFormattedNumber:_dottedHalfNoteMS]);
    //NSLog(@" Eighth floor: %f",floor(_halfNoteMS));
}

//label.text = [NSString stringWithFormat:@"%C",0x00bd];
- (NSString *)fractionEnding:(float)param{
    //return @"¼";
    NSString *whichFraction = [self generateFormattedNumber:param];
    if ([whichFraction isEqualToString:@"0"] || [whichFraction isEqualToString:@"00"]) {
        return @"";
    } else if([whichFraction isEqualToString:@"25"]) {
        return @"¼";
    } else if ([whichFraction isEqualToString:@"33"]) {
        return @"⅓";
    } else if ([whichFraction isEqualToString:@"50"]) {
        return @"½";
    } else if ([whichFraction isEqualToString:@"66" ]) {
        return @"⅔";
    } else {
        return @"";
    }
}

- (NSString *)generateFormattedNumber:(float)param{
    int newnew = 100 * (param-floor(param));
    NSLog(@"floareeeeeeee: %d", newnew);
    return [NSString stringWithFormat:@"%d", newnew];
}

- (int)intFromFloat:(float)param{
    int newnew = floor(param);
    //NSLog(@"floareeeeeeee: %d", newnew);
    return newnew;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.timeItems.count;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * ident = @"aCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:nil];
    if (cell ==nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
        NSString * txt = [self.timeItems objectAtIndex:indexPath.row];
        NSLog(@"Current txt is %@",txt);
        
        if ([txt isEqualToString: @"0"]) {
            cell.imageView.image = [UIImage imageNamed:_noteIcons[0]];
        }else if ([txt isEqualToString: @"1"]) {
            cell.imageView.image = [UIImage imageNamed:_noteIcons[1]];
        }else if ([txt isEqualToString: @"2"]) {
            cell.imageView.image = [UIImage imageNamed:_noteIcons[2]];
        }else if ([txt isEqualToString: @"3"]) {
            cell.imageView.image = [UIImage imageNamed:_noteIcons[3]];
            cell.imageView.highlightedImage = [UIImage imageNamed:@"anc.png"];
        }
        
        if (indexPath.row == _counter-1){
            [cell setBackgroundColor:[UIColor orangeColor]];
            [cell setHighlighted:YES];
            NSLog(@"sss %ld", (long)indexPath.row);
        }
        [[cell imageView] setHidden:NO];
        //[self setUITableFrame];
        NSLog(@"last thing");
    }
    [self setUITableFrame];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //handles taps on the cells to change value
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([[_timeItems objectAtIndex:indexPath.row] isEqualToString:@"0"]) {
        [_timeItems replaceObjectAtIndex:indexPath.row withObject:[NSString stringWithFormat:@"1"]];
        cell.imageView.image = [UIImage imageNamed:_noteIcons[0]];
    } else if ([[_timeItems objectAtIndex:indexPath.row] isEqualToString:@"1"]) {
        [_timeItems replaceObjectAtIndex:indexPath.row withObject:[NSString stringWithFormat:@"2"]];
        cell.imageView.image = [UIImage imageNamed:_noteIcons[1]];
    } else if ([[_timeItems objectAtIndex:indexPath.row] isEqualToString:@"2"]) {
        [_timeItems replaceObjectAtIndex:indexPath.row withObject:[NSString stringWithFormat:@"3"]];
        cell.imageView.image = [UIImage imageNamed:_noteIcons[2]];
    } else if ([[_timeItems objectAtIndex:indexPath.row] isEqualToString:@"3"]) {
        [_timeItems replaceObjectAtIndex:indexPath.row withObject:[NSString stringWithFormat:@"0"]];
        cell.imageView.image = [UIImage imageNamed:_noteIcons[3]];
    }
    NSLog(@"%@",[_timeItems objectAtIndex:indexPath.row]);
    
    [_timingList reloadData];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete){
        
        if (indexPath.row < [_timeItems count]){
            
            /* First remove this object from the source */
            [_timeItems removeObjectAtIndex:indexPath.row];
            
            /* Then remove the associated cell from the Table View */
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationLeft];
            
        }
    }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)  interfaceOrientation duration:(NSTimeInterval)duration
{
    NSLog(@"%ld", interfaceOrientation);
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    [self setUITableFrame];
}

-(void)setUITableFrame{
    
}

- (IBAction)addItem:(UIButton *)sender {
    [_timeItems addObject:@"1"];
    [_timingList reloadData];
    [_timingList scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_timeItems count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    [_timingList flashScrollIndicators];
}

- (IBAction)deleteLastItem:(UIButton *)sender {
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"snap" ofType:@"aiff"]; NSURL *soundURL = [NSURL fileURLWithPath:soundPath]; AudioServicesCreateSystemSoundID(CFBridgingRetain(soundURL), &sound1);
    AudioServicesPlaySystemSound(sound1);
    //CGPoint oldCenter=_timingList.center;
    //_timingList.transform=CGAffineTransformMakeRotation(-M_PI_2);
    //_timingList.center=oldCenter;
    /*
    if ([_timeItems count] > 1){
        [_timeItems removeObjectAtIndex:[_timeItems count]-2];
        [_timingList reloadData];
        [_timingList scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_timeItems count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        [_timingList flashScrollIndicators];
    }
     */
    NSLog(@"pushed");
}



- (IBAction)loadPattern:(UIButton *)sender {
}

- (IBAction)savePattern:(UIButton *)sender {
}


- (IBAction)editButtonPush:(id)sender {

    if ([[sender currentTitle] isEqualToString:@"Edit"]){
        [sender setTitle:@"Done" forState:UIControlStateNormal];
        _timingList.editing=YES;
    } else {
        [sender setTitle:@"Edit" forState:UIControlStateNormal];
        _timingList.editing=NO;
    }
}
@end
