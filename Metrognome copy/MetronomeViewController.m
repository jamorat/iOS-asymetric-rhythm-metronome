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
@property (strong, nonatomic) IBOutlet UITableView *timingList;
@property (nonatomic, assign) int counter;
@property (nonatomic) NSMutableArray *noteIcons;
@end

@implementation MetronomeViewController

MetronomeAppDelegate *metronomeAppDelegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    _noteIcons = [NSMutableArray arrayWithObjects:@"eighth-note.png",@"quarter-note.png",@"half-note.png",@"dotted-half-note.png",nil];
    NSLog(_noteIcons[2]);
    NSLog(@"before: %d ----",[_timeItems count]);
    _timeItems = [NSMutableArray arrayWithObjects: @"1", @"2", @"3", @"3", @"0", @"1", @"1", @"2", @"3", @"0", @"1", @"1", @"1", nil];
    NSLog(@"after: %d ----",[_timeItems count]);
    
    CGPoint oldCenter=_timingList.center;
    _timingList.transform=CGAffineTransformMakeRotation(-M_PI_2);
    _timingList.center=oldCenter;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)  interfaceOrientation duration:(NSTimeInterval)duration
{
    if (interfaceOrientation == 1 || interfaceOrientation == 2) {
    //portrait
    CGRect newFrame = self.timingList.frame;
        newFrame.size.height = 60;
        newFrame.size.width = [[UIScreen mainScreen] bounds].size.width;
        newFrame.origin.y = ([[UIScreen mainScreen] bounds].size.height-60);
        newFrame.origin.x = 0;
        self.timingList.frame = newFrame;
    }else if (interfaceOrientation == 3 || interfaceOrientation == 4) {
        CGRect newFrame = self.timingList.frame;
        newFrame.size.height = 60;
        newFrame.size.width = [[UIScreen mainScreen] bounds].size.height;
        newFrame.origin.y = ([[UIScreen mainScreen] bounds].size.width-60);
        newFrame.origin.x = 0;
        self.timingList.frame = newFrame;
    }
    NSLog(@"%d", interfaceOrientation);
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
        
        NSURL *soundURL = [[NSBundle mainBundle] URLForResource:@"singleClick" withExtension:@"aiff"];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL, &sound1);
        
        NSURL *soundURL1 = [[NSBundle mainBundle] URLForResource:@"snap" withExtension:@"aiff"];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL1, &sound2);
        
        NSURL *soundURL2 = [[NSBundle mainBundle] URLForResource:@"low-click" withExtension:@"aiff"];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL2, &sound3);
        
        [self enableTimer];
    }else{
        NSLog(@"stopped");
        [sender setTitle:@"Start" forState:UIControlStateNormal];
        [sender setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [_bpmTimer invalidate];
        _bpmTimer = nil;
    }
}

- (IBAction)bpmSlideControllerAction:(UISlider *)sender {
    self.bpmDisplay.text = [NSString stringWithFormat:@"%i",(int)self.bpmSlideController.value];
    self.quarterNote.text = [NSString stringWithFormat:@"%i",(int)self.bpmSlideController.value/2];
    self.halfNote.text = [NSString stringWithFormat:@"%i",(int)self.bpmSlideController.value/3];
    self.dottedHalfNote.text = [NSString stringWithFormat:@"%i",(int)self.bpmSlideController.value/4];
}




- (void)enableTimer
{
    //self.bpmDisplay.text = [NSString stringWithFormat:@"%f",self.bpmSlideController.value];
    //float demical = (60/self.bpmSlideController.value);
    _bpmTimer = [NSTimer scheduledTimerWithTimeInterval:(60/self.bpmSlideController.value)
                                 target:self selector:@selector(metroAct) userInfo:nil
                                repeats:YES];
}

- (void)metroAct
{
    NSString *whichSound = [_timeItems objectAtIndex:_counter];
    [self.timingList scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_counter inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    if ([whichSound isEqualToString:@"0"]){
        //Do nothing
    }else if([whichSound isEqualToString:@"1"]){
        AudioServicesPlaySystemSound(sound1);
    }else if([whichSound isEqualToString:@"2"]){
        AudioServicesPlaySystemSound(sound2);
    }else if([whichSound isEqualToString:@"3"]){
        AudioServicesPlaySystemSound(sound3);
    }
     
    _counter++;
    NSLog([NSString stringWithFormat:@"%d",_counter]);
    if (_counter > ([_timeItems count]-1)){
        _counter = 1;
    }
    NSLog([NSString stringWithFormat:@"%d just before reload",_counter]);
    [_timingList reloadData];
}




-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    CGRect newFrame = self.timingList.frame;
    newFrame.size.height = 200;
    newFrame.size.width = 200;
    newFrame.origin.y = 0;
    newFrame.origin.x = 0;
    
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.timeItems.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * ident = @"aCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:nil];
    if (cell ==nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
        NSString * txt = [self.timeItems objectAtIndex:indexPath.row];
        
        
        if ([txt isEqualToString: @"0"]) {
            cell.imageView.image = [UIImage imageNamed:_noteIcons[0]];
        }else if ([txt isEqualToString: @"1"]) {
            cell.imageView.image = [UIImage imageNamed:_noteIcons[1]];
        }else if ([txt isEqualToString: @"2"]) {
            cell.imageView.image = [UIImage imageNamed:_noteIcons[2]];
        }else if ([txt isEqualToString: @"3"]) {
            cell.imageView.image = [UIImage imageNamed:_noteIcons[3]];
        }else if ([txt isEqualToString: @"4"]) {
            cell.imageView.image = [UIImage imageNamed:_noteIcons[3]];
        }
        
        if (indexPath.row == _counter-1){
            [cell setBackgroundColor:[UIColor orangeColor]];
            NSLog(@"sss %d", indexPath.row);
        }
        [[cell imageView] setHidden:NO];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    
    
    //[_timingList reloadData];
}
@end
