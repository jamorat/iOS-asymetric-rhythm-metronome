//  ViewController.m
//  Variable Metrognome / Asymmetric Rhythm
/*
Created by Brian Sleeper and Jack Amoratis on 5/17/14.
We think this is awesome source code, but in all humility, there's nothing proprietary going on here. An NSTimer, some sounds being played, some decimals being converted into fractions. That pretty much represents the functionality of this asymmetric rhythm tool. All you need to do is wire this code to a UITableView along with some buttons, a slider, and a few labels, and you will have your own working asymmetric rhythm app. If you want to make use of this code, then feel free to fork it, or just cut and paste it into your project.
 - Jack Amoratis and Brian Sleeper
## License
To the extent possible under law, we (Brian Sleeper and Jack Amoratis) have waived all copyright and related or neighboring rights to this source code. This work is published from: United States. No warranty is expressed or implied, nor is any fitness for a particular purpose implied. Use at your own risk.
 */

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
@property (nonatomic, assign) int whichSound;
@end

@implementation MetronomeViewController

MetronomeAppDelegate *metronomeAppDelegate;

-(void)viewDidDisappear:(BOOL)animated{ [self startStopTimer:YES]; }

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSURL *toneURL = [[NSBundle mainBundle] URLForResource:@"tone" withExtension:@"aiff"];
    AudioServicesCreateSystemSoundID(CFBridgingRetain(toneURL), &toneSound);
    _plusButton.titleLabel.font = [UIFont systemFontOfSize:20];
    _timeItems = [NSMutableArray arrayWithObjects: @1, @1, @2, nil];
    [_timingList reloadData];
    [_editButton setTitle:@"Edit" forState:UIControlStateNormal];
    _bpmSlideController.value = 320;
    [self updateSlider];
}

- (NSUInteger)supportedInterfaceOrientations { return  UIInterfaceOrientationMaskAll; }

-(BOOL)shouldAutorotate{ return YES; }

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{ return TRUE; }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [self startStopTimer:NO];
    NSLog(@"%@",@"Show alert low memory");
}

- (IBAction)pushedGoButton:(id)sender { [self startStopTimer:NO]; }

- (void) startStopTimer:(BOOL)shouldStop{
    if ([[_goButton currentTitle] isEqualToString:@"Start"] && shouldStop != YES) {
        [_goButton setTitle:@"Stop" forState:UIControlStateNormal];
        [_goButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self metroAct];
        NSLog(@"Started");
    }else{
        [_goButton setTitle:@"Start" forState:UIControlStateNormal];
        [_goButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [_bpmTimer invalidate];
        NSLog(@"Stopped");
    }
}

- (void)metroAct
{
    if ([_timeItems count] < 1) {
        [self startStopTimer:YES];
    }
    
    //will crash if stop while last item on the list is highlighted
    //at that point the counter is above the count of time items - 1
    if (_counter > [_timeItems count]-1){
        _counter = 0;
    }
    
    _whichSound = [[_timeItems objectAtIndex:_counter] intValue];
    [_timingList scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_counter inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    //CURRENT CELL NOTE VALUE
    if (_whichSound == 0){ _currentItemMSTop = 60/_eighthNoteMS;}
    else if(_whichSound == 1){ _currentItemMSTop = 60/_quarterNoteMS; }
    else if(_whichSound == 2){ _currentItemMSTop = 60/_halfNoteMS;}
    else if(_whichSound == 3){ _currentItemMSTop = 60/_dottedHalfNoteMS; }
    
    _bpmTimer = [NSTimer scheduledTimerWithTimeInterval:(_currentItemMSTop) target:self selector:@selector(soundPlayMethod) userInfo:nil repeats:NO];
}

- (void)soundPlayMethod{
    AudioServicesPlaySystemSound(toneSound);
    if (_counter > ([_timeItems count]-1)){
        _counter = 0;
    }
    [_timingList reloadData];
    [self metroAct];
    _counter++;
}

- (IBAction)bpmSlideControllerAction:(UISlider *)sender { [self updateSlider]; }

-(void)updateSlider{
    _bpmSlideController.value = roundf((_bpmSlideController.value) / 1.0f);
    
    _eighthNoteMS = (float)_bpmSlideController.value;
    _quarterNoteMS = (float)_bpmSlideController.value/2;
    _halfNoteMS = (float)_bpmSlideController.value/3;
    _dottedHalfNoteMS = (float)_bpmSlideController.value/4;
    
    _bpmDisplay.text = [self getBpmString:_eighthNoteMS];
    _quarterNote.text = [self getBpmString:_quarterNoteMS];
    _halfNote.text = [self getBpmString:_halfNoteMS];
    _dottedHalfNote.text = [self getBpmString:_dottedHalfNoteMS];
}

- (NSString *)getBpmString:(float)param{
    //First get main display number
    int roundedBPM = floor(param);
    
    //Then get fraction ending, if any
    int whichFraction = 100 * (param-floor(param));
    if (whichFraction == 0){
        return [NSString stringWithFormat:@"%d",roundedBPM ];
    } else if(whichFraction == 25) {
        return [NSString stringWithFormat:@"%d ¼",roundedBPM];
    } else if (whichFraction == 33) {
        return [NSString stringWithFormat:@"%d ⅓",roundedBPM];
    } else if (whichFraction == 50) {
        return [NSString stringWithFormat:@"%d ½",roundedBPM];
    } else if (whichFraction == 66) {
        return [NSString stringWithFormat:@"%d ⅔",roundedBPM];
    } else {
        return @"Error";
    }
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{ return _timeItems.count; }

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath { return 80; }

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{ return YES; }

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{ }

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * ident = @"aCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:nil];
    if (cell ==nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
        int txt = [[_timeItems objectAtIndex:indexPath.row] intValue];
        NSLog(@"Current txt: %i row: %li",txt, (long)indexPath.row);
        cell.textLabel.font = [UIFont fontWithName:@"MusiSync" size:70];
        if (txt == 0) {
            cell.textLabel.text = @"  e";
        }else if (txt == 1) {
            cell.textLabel.text = @"  q";
        }else if (txt == 2) {
            cell.textLabel.text = @"  j";
        }else if (txt == 3) {
            cell.textLabel.text = @"  h";
        }
        
        if (indexPath.row == _counter-1){
            [cell setBackgroundColor:[UIColor orangeColor]];
            [cell setHighlighted:YES];
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //handles taps on the cells to change value
    int itemValue = [[_timeItems objectAtIndex:indexPath.row] intValue] + 1;
    if (itemValue > 3) { itemValue = 0; }
    [_timeItems replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithInteger:itemValue]];
    [_timingList reloadData];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete){
        if (indexPath.row < [_timeItems count]){
            //First remove this object from the source
            [_timeItems removeObjectAtIndex:indexPath.row];
            
            //Then remove the associated cell from the Table View
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        }
    }
}

- (IBAction)addItem:(UIButton *)sender {
    [_timeItems addObject:@1];
    [_timingList reloadData];
    [_timingList scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_timeItems count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    [_timingList flashScrollIndicators];
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

- (IBAction)clearButtonPressed:(UIButton *)sender {
    _timeItems = [NSMutableArray arrayWithObjects: @"0", nil];
    [_timingList reloadData];
    [self startStopTimer:YES];
}
@end
