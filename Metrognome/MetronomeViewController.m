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
    _timeItems = [NSMutableArray arrayWithObjects: @"1", @"1", @"2", @"3", @"0", @"1", @"1", @"2", @"3", @"0", @"1", @"1", @"1", nil];
    NSLog(@"%f",([[UIScreen mainScreen] bounds].size.height - 100));
    CGRect newFrame = self.timingList.frame;
    newFrame.size.height = 300.0;
    newFrame.size.width = 300.0;
    newFrame.origin.y = 400;
    newFrame.origin.x = 400;
    
    NSLog(@"pooofff %f fffooop",newFrame.origin.y);
    
    //CGPoint oldCenter=self.timingList.center;
    
    //CGAffineTransform transformer = CGAffineTransformMakeRotation(-M_PI_2);
    //self.timingList.center=oldCenter;
    self.timingList.frame = newFrame;
    self.timingList.transform=CGAffineTransformMakeRotation(-M_PI_2);
}

-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:)    name:UIDeviceOrientationDidChangeNotification  object:nil];
    
    // _timingList.transform=CGAffineTransformMakeRotation(-M_PI_2);
    
    //CGRect newFrame = self.timingList.frame;
    //newFrame.origin.x = 200;
    //self.timingList.frame = newFrame;
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

- (void)orientationChanged:(NSNotification *)notification{
    [self adjustViewsForOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    NSLog(@"rotated");
}

- (void) adjustViewsForOrientation:(UIInterfaceOrientation) orientation {
    NSLog(@"%d", orientation);
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        //load the portrait view
        //NSLog(@"portrait");
    }
    else if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight)
    {
        //load the landscape view
        //NSLog(@"landscape");
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (IBAction)bpmSlideControllerAction:(UISlider *)sender {
    self.bpmDisplay.text = [NSString stringWithFormat:@"%i",(int)self.bpmSlideController.value];
    
    //correct original: float demical = (60/self.bpmSlideController.value);
    
    //float demical = (60/self.bpmSlideController.value);
    //also works w decimals: self.bpmDisplay.text = [NSString stringWithFormat:@"%f",demical];
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

- (IBAction)stopTimer:(id)sender {
    [_bpmTimer invalidate];
    _bpmTimer = nil;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    //CGPoint oldCenter=tableView.center;
    //_timingList.transform=CGAffineTransformMakeRotation(-M_PI_2);
    //tableView.center=oldCenter;
    
    //_timingList.transform=CGAffineTransformMakeRotation(-M_PI_2);
    
    return self.timeItems.count;
    
    //self.timingList.transform=CGAffineTransformMakeRotation(-M_PI_2);
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * ident = @"aCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:nil];
    if (cell ==nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
        NSString * txt = [self.timeItems objectAtIndex:indexPath.row];
        [[cell textLabel] setText:txt];
        [[cell imageView] setHidden:NO];
        if (indexPath.row ==2) {
            cell.imageView.image = [UIImage imageNamed:@"Spaceship.png"];
        }
        //cell.imageView.image = [UIImage imageNamed:@"Spaceship.png"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[_timeItems objectAtIndex:indexPath.row] isEqualToString:@"1"]) {
        [_timeItems replaceObjectAtIndex:indexPath.row withObject:[NSString stringWithFormat:@"2"]];
        
        
    }else if ([[_timeItems objectAtIndex:indexPath.row] isEqualToString:@"on"]) {
        [_timeItems replaceObjectAtIndex:indexPath.row withObject:[NSString stringWithFormat:@"accent1"]];
    }else if ([[_timeItems objectAtIndex:indexPath.row] isEqualToString:@"accent1"]) {
        [_timeItems replaceObjectAtIndex:indexPath.row withObject:[NSString stringWithFormat:@"accent2"]];
    }else if ([[_timeItems objectAtIndex:indexPath.row] isEqualToString:@"accent2"]) {
       [_timeItems replaceObjectAtIndex:indexPath.row withObject:[NSString stringWithFormat:@"off"]];
    }
    NSLog(@"%@",[_timeItems objectAtIndex:indexPath.row]);
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:@"knob-icon.png"];
    //[_timingList reloadData];
}
@end
