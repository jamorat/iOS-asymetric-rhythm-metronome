//
//  MetronomeViewController.m
//  Metrognome
//
//  Created by R on 5/17/14.
//  Copyright (c) 2014 R. All rights reserved.
//

#import "MetronomeViewController.h"
# undef M_PI_2
# define M_PI_2     1.57079632679489661923

@interface MetronomeViewController ()
@property (strong, nonatomic) IBOutlet UITableView *timingList;
@property NSMutableArray *timeItems;
@property (nonatomic, assign) int counter;
@end

@implementation MetronomeViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _timeItems = [NSMutableArray arrayWithObjects: @"1", @"2", @"3", @"3", @"0", @"1", @"1", @"2", @"3", @"0", @"1", @"1", @"1", nil];
    
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
    NSURL *soundURL = [[NSBundle mainBundle] URLForResource:@"singleClick" withExtension:@"aiff"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL, &sound1);
    
    
    
    NSURL *soundURL1 = [[NSBundle mainBundle] URLForResource:@"snap" withExtension:@"aiff"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL1, &sound2);
    
    
    
    NSURL *soundURL2 = [[NSBundle mainBundle] URLForResource:@"low-click" withExtension:@"aiff"];

    AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL2, &sound3);
    
     [self enableTimer];
     
}




- (IBAction)bpmSlideControllerAction:(UISlider *)sender {
    self.bpmDisplay.text = [NSString stringWithFormat:@"%i",(int)self.bpmSlideController.value];
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
    NSLog([NSString stringWithFormat:@"%d",_counter]);
    
}




-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    CGRect newFrame = self.timingList.frame;
    newFrame.size.height = 200;
    newFrame.size.width = 200;
    newFrame.origin.y = 0;
    newFrame.origin.x = 0;
    
}

- (IBAction)stopTimer:(id)sender {
    CGRect newFrame = self.timingList.frame;
    
    newFrame.size.height = 200;
    newFrame.size.width = 200;
    newFrame.origin.y = 0;
    newFrame.origin.x = 0;
    self.timingList.frame = newFrame;
    //[_bpmTimer invalidate];
    //_bpmTimer = nil;
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
            cell.imageView.image = [UIImage imageNamed:@"list-pause.png"];
        }else if ([txt isEqualToString: @"1"]) {
            cell.imageView.image = [UIImage imageNamed:@"list-accent.png"];
        }else if ([txt isEqualToString: @"2"]) {
            cell.imageView.image = [UIImage imageNamed:@"list-strike-1.png"];
        }else if ([txt isEqualToString: @"3"]) {
            cell.imageView.image = [UIImage imageNamed:@"list-strike-2.png"];
        }else if ([txt isEqualToString: @"4"]) {
            cell.imageView.image = [UIImage imageNamed:@"list-quiet-accent.png"];
        }
        
        
        
        
        
        //[[cell textLabel] setText:txt];
        [[cell imageView] setHidden:NO];
        
        //if (indexPath.row ==2) {
        //    cell.imageView.image = [UIImage imageNamed:@"Spaceship.png"];
        //}
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([[_timeItems objectAtIndex:indexPath.row] isEqualToString:@"0"]) {
        [_timeItems replaceObjectAtIndex:indexPath.row withObject:[NSString stringWithFormat:@"1"]];
        cell.imageView.image = [UIImage imageNamed:@"list-accent.png"];
    } else if ([[_timeItems objectAtIndex:indexPath.row] isEqualToString:@"1"]) {
        [_timeItems replaceObjectAtIndex:indexPath.row withObject:[NSString stringWithFormat:@"2"]];
        cell.imageView.image = [UIImage imageNamed:@"list-strike-1.png"];
    } else if ([[_timeItems objectAtIndex:indexPath.row] isEqualToString:@"2"]) {
        [_timeItems replaceObjectAtIndex:indexPath.row withObject:[NSString stringWithFormat:@"3"]];
        cell.imageView.image = [UIImage imageNamed:@"list-strike-2.png"];
    } else if ([[_timeItems objectAtIndex:indexPath.row] isEqualToString:@"3"]) {
        [_timeItems replaceObjectAtIndex:indexPath.row withObject:[NSString stringWithFormat:@"0"]];
        cell.imageView.image = [UIImage imageNamed:@"list-pause.png"];
    }
    NSLog(@"%@",[_timeItems objectAtIndex:indexPath.row]);
    
    
    //[_timingList reloadData];
}
@end
