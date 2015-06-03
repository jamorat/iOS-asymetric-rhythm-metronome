//  ViewController.m
//  Variable Metrognome / Asymmetric Rhythm
/*
## License
To the extent possible under law, we, Brian Sleeper (musician) and Jack Amoratis (iOS Developer), have waived all copyright and related or neighboring rights to this source code. This work is published from: United States. No warranty is expressed or implied, nor is any fitness for a particular purpose implied. Use at your own risk.
 */

#import "MetronomeViewController.h"
#import "MyCollectionViewCell.h"
#import "NSString+FontAwesome.h"
#import "UIImage+FontAwesome.h"
@implementation MetronomeViewController
@synthesize ball2, xCoord, yCoord, startPoint;
- (IBAction)junSlider:(UISlider *)sender {
    //_junjun.backgroundColor = [UIColor colorWithRed:sender.value*1.0 green:150.0 blue:150.0 alpha:1.0];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [ball2 setClipsToBounds:true];
    //Populate with a rhythm on startup
    _beatsArray = [NSMutableArray arrayWithObjects: @1, @1, @2,@1, @1, @2, nil];
    [_beatsUICollectionView reloadData];
    
    _helpQuestionMarkLabel.layer.cornerRadius = 2;
    _helpQuestionMarkLabel.layer.masksToBounds = YES;
    
    //Set up a few UI items
    //[_editButton setTitle:@"Edit" forState:UIControlStateNormal];
    _plusButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_bpmSlideController setValue:320 animated:YES];
    [self setBpm]; //based on slider value
    
    //Load tone
    NSURL *toneURL = [[NSBundle mainBundle] URLForResource:@"tone" withExtension:@"aiff"];
    AudioServicesCreateSystemSoundID(CFBridgingRetain(toneURL), &toneSound);

    ball2.hidden = true;
    
    
    
    _longpressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressHandler:)];
    _longpressGesture.minimumPressDuration = .3;
    [_longpressGesture setDelegate:self];
    [_beatsUICollectionView addGestureRecognizer:_longpressGesture];
    
    _tapPressGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPressHandler:)];
    [_tapPressGesture setDelegate:self];
    [self.view addGestureRecognizer:_tapPressGesture];
    
    _tapTempoNumberGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTempoNumberHandler:)];
    [_tapTempoNumberGesture setDelegate:self];
    [_numbersView addGestureRecognizer:_tapTempoNumberGesture];
    [self numberHideTimerStart];
    [_bpmSlideController setThumbImage:[UIImage imageNamed:@"sliderThumbImage.png"] forState:UIControlStateNormal];
    
    //_ball2Label.backgroundColor = [UIColor clearColor];
    _ball2Label.font = [UIFont fontWithName:@"MusiSync" size:55];
    _playButton.tintColor = [UIColor whiteColor];
    [_playButton setTitle:[NSString stringWithFormat:@"\f034"] forState:normal];
    _playButton.tintColor = [UIColor whiteColor];
    _playButton.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:55];
    _playButton.titleLabel.shadowOffset = CGSizeMake(0, -1);
    [_playButton setTitle:[NSString fontAwesomeIconStringForEnum:FAPlay] forState:UIControlStateNormal];
    _thumbTab.layer.cornerRadius = 2;
    _thumbTab.layer.masksToBounds = YES;
    
}

-(void)viewDidAppear:(BOOL)animated{
    [self setBpm];
}

// U S E R   I N T E R A C T I O N
- (IBAction)pushedGoButton:(id)sender { [self toggleTimer:NO]; }
- (IBAction)bpmSlideControllerAction:(UISlider *)sender { [self setBpm]; }


// T I M E R
- (void) toggleTimer:(BOOL)shouldStop{
    if ([[_goButton currentTitle] isEqualToString:@"Start"] && shouldStop != YES && [_beatsArray count] > 0) {
        [_goButton setTitle:@"Stop" forState:UIControlStateNormal];
        [_goButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_playButton setTitle:[NSString fontAwesomeIconStringForEnum:FAStop] forState:UIControlStateNormal];
        [self metroAct];
    }else{
        //_currentBeat = 0;
        [_goButton setTitle:@"Start" forState:UIControlStateNormal];
        [_goButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_bpmTimer invalidate];
        [_playButton setTitle:[NSString fontAwesomeIconStringForEnum:FAPlay] forState:UIControlStateNormal];
        _thumbTabCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)[_beatsArray count]];
     }
}

- (void)timerFire{
    AudioServicesPlaySystemSound(toneSound);
    if (_currentBeat > ([_beatsArray count]-1)){ _currentBeat = 0; }
    [_beatsUICollectionView reloadData];
    //[_beatsUICollectionView reloadData];
    [self metroAct];
    _currentBeat++;
}

- (void)metroAct
{
    if ([_beatsArray count] < 1) { [self toggleTimer:YES]; }
    
    //will crash if currentBeat is above the count of beatsArray - 1
    if (_currentBeat > [_beatsArray count]-1){ _currentBeat = 0; }
    
    _beatType = [[_beatsArray objectAtIndex:_currentBeat] intValue];
    [_beatsUICollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_currentBeat inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally  animated:YES];
    _thumbTabCountLabel.text = [NSString stringWithFormat:@"%i/%lu", _currentBeat+1,(unsigned long)[_beatsArray count]];

    //CURRENT CELL NOTE VALUE
    if (_beatType == 0){ _timerInterval = 60/_eighthMilisec; }
    else if(_beatType == 1){ _timerInterval = 60/_quarterMilisec; }
    else if(_beatType == 2){ _timerInterval = 60/_halfMilisec; }
    else if(_beatType == 3){ _timerInterval = 60/_dottedHalfMilisec; }
    
    _bpmTimer = [NSTimer scheduledTimerWithTimeInterval:(_timerInterval) target:self selector:@selector(timerFire) userInfo:nil repeats:NO];
    
}

-(void)numberHideTimerStart{
    _numberGaugeTimer = [NSTimer scheduledTimerWithTimeInterval:(5.0) target:self selector:@selector(sliderHide) userInfo:nil repeats:NO];}

-(void)sliderHide{
    if (_bpmSlideController.hidden == true){
        //_bpmSlideController.hidden = false;
    }else{
        //_bpmSlideController.hidden = true;
    }
}

-(void)setBpm{
    _bpmSlideController.value = roundf((_bpmSlideController.value) / 1.0f);
    
    _eighthMilisec = (float)_bpmSlideController.value;
    _quarterMilisec = (float)_bpmSlideController.value/2;
    _halfMilisec = (float)_bpmSlideController.value/3;
    _dottedHalfMilisec = (float)_bpmSlideController.value/4;
    
    _eighthLabel.text = [self getBpmString:_eighthMilisec];
    _quarterLabel.text = [self getBpmString:_quarterMilisec];
    _dottedHalfLabel.text = [self getBpmString:_halfMilisec];
    _halfLabel.text = [self getBpmString:_dottedHalfMilisec];
    
    //_whole_note_line.frame.size.width = CG 50;
    [_whole_note_line setFrame:CGRectMake(_whole_note_line.frame.origin.x, _whole_note_line.frame.origin.y, 72 - (_eighthMilisec/10), _whole_note_line.frame.size.height)];
    [_half_note_line setFrame:CGRectMake(_half_note_line.frame.origin.x, _half_note_line.frame.origin.y, 36 - (_quarterMilisec/10), _half_note_line.frame.size.height)];
    [_quarter_note_line setFrame:CGRectMake(_quarter_note_line.frame.origin.x, _quarter_note_line.frame.origin.y, 24 - (_halfMilisec/10), _quarter_note_line.frame.size.height)];
    [_dotted_half_note_line setFrame:CGRectMake(_dotted_half_note_line.frame.origin.x, _dotted_half_note_line.frame.origin.y, 18 - (_dottedHalfMilisec/10), _dotted_half_note_line.frame.size.height)];
    
    
}

- (NSString *)getBpmString:(float)param{
    int roundedBpm = floor(param); //bpm number rounded down
    int whichFraction = 100 * (param-floor(param)); //remainder
    if (whichFraction == 0){
        return [NSString stringWithFormat:@"%d",roundedBpm ];
    } else if(whichFraction == 25) {
        return [NSString stringWithFormat:@"%d ¼",roundedBpm];
    } else if (whichFraction == 33) {
        return [NSString stringWithFormat:@"%d ⅓",roundedBpm];
    } else if (whichFraction == 50) {
        return [NSString stringWithFormat:@"%d ½",roundedBpm];
    } else if (whichFraction == 66) {
        return [NSString stringWithFormat:@"%d ⅔",roundedBpm];
    } else {
        return [NSString stringWithFormat:@"%d",roundedBpm ];
    }
}


// A D D    E D I T    C L E A R    I N F O
- (IBAction)addItem:(UIButton *)sender {
    [_beatsArray addObject:@1];
    [_beatsUICollectionView reloadData];
    [_beatsUICollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:[_beatsArray count]-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
    [_beatsUICollectionView  flashScrollIndicators];
}

-(void)itemAdd{
    [_beatsArray addObject:@1];
    [_beatsUICollectionView reloadData];
    [_beatsUICollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:[_beatsArray count]-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
    [_beatsUICollectionView  flashScrollIndicators];
    _thumbTabCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)[_beatsArray count]];
}

- (IBAction)editButtonPush:(id)sender {
    /*
    if ([[sender currentTitle] isEqualToString:@"Edit"]){
        [sender setTitle:@"Done" forState:UIControlStateNormal];
        _beatsTable.editing=YES;
    } else {
        [sender setTitle:@"Edit" forState:UIControlStateNormal];
        _beatsTable.editing=NO;
    }
     */
}

- (IBAction)clearButtonPressed:(UIButton *)sender {
    [self toggleTimer:YES];
    _beatsArray = [NSMutableArray arrayWithObjects: @"0", nil];
    [_beatsUICollectionView reloadData];
    //[_beatsUICollectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _beatsArray.count;
}



// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
        if(indexPath.row == _start_cell){
            NSLog(@"Current row: %li Current cell:%li",(long)indexPath.row,(long)_start_cell);
           }
    
    MyCollectionViewCell *myCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyCell"
                                    forIndexPath:indexPath];
    
    UILabel *titleLabel = (UILabel *)[myCell viewWithTag:100];
    titleLabel.text = @"root";
    titleLabel.textColor = [UIColor whiteColor];
    myCell.layer.cornerRadius = 2;
    myCell.layer.masksToBounds = YES;
    int txt = [[_beatsArray objectAtIndex:indexPath.row] intValue];
    //NSLog(@"Current txt: %i row: %li",txt, (long)indexPath.row);
    titleLabel.font = [UIFont fontWithName:@"MusiSync" size:55];
    
    if (txt == 0) {
        titleLabel.text = @"e";
    }else if (txt == 1) {
        titleLabel.text = @"q";
    }else if (txt == 2) {
        titleLabel.text = @"j";
    }else if (txt == 3) {
        titleLabel.text = @"h";
    }else if (txt == 99) {
        titleLabel.text = @" ";
    }
    
    if (_activeCell == indexPath.row && _activeCell != 0) {
        myCell.backgroundColor = [UIColor clearColor];
    }
    
    
    if (_start_cell == indexPath.row && _activeCell != 0) {
         //myCell.backgroundColor = [UIColor blueColor];
    }
    
    
    
    if (indexPath.row == _currentBeat-1){
        NSLog(@"%ld",(long)indexPath.row);
        [myCell setBackgroundColor:[UIColor whiteColor]];
        [myCell setHighlighted:YES];
        titleLabel.textColor = [UIColor colorWithRed:120/255.0 green:19/255.0 blue:230/255.0 alpha:1.0 ];
    }else{
        [myCell setBackgroundColor:[UIColor clearColor]];
    }
    
    UIButton *cellButton = (UIButton *)[myCell viewWithTag:101];
    [cellButton addTarget:self action:@selector(collectionViewCellButtonPressed:withEvent:) forControlEvents:UIControlEventTouchDragExit];
    [cellButton addTarget:self action:@selector(collectionViewCellButtonDragDone:withEvent:) forControlEvents:UIControlEventTouchUpOutside];
    [cellButton addTarget:self action:@selector(collectionViewCellButtonTouchDown:withEvent:) forControlEvents:UIControlEventTouchDown];
    [cellButton addTarget:self action:@selector(collectionViewCellButtonTouchUpOutside:withEvent:) forControlEvents:UIControlEventTouchUpOutside];
    [cellButton addTarget:self action:@selector(collectionViewCellButtonTouchUpInside:withEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    return myCell;
}


-(void)setBlankFlagInBeatArray{
    
    if (_activeCell == 0){
        //return;
    }
    
    if (_activeCell == _previousCell){
        return;
    }else{
        _previousCell = _activeCell;
        [self removeAllBlankFlagsFromBeatsArray];
    }
    NSLog(@"iN hErE active cell: %li",_activeCell);
    NSLog(@"ddd");
    [_beatsArray insertObject:[NSNumber numberWithInteger:99] atIndex:_activeCell];
}

-(void)removeAllBlankFlagsFromBeatsArray{
   int a;
    for (a=0;a<[_beatsArray count];a++){
        if ([_beatsArray[a] isEqualToNumber:[NSNumber numberWithInt: 99]]){
            [_beatsArray removeObjectAtIndex:a];
            return;
        }
    }
}

-(NSInteger)numberOfSectionsInCollectionView:
(UICollectionView *)collectionView
{
    return 1;
}


- (void)tapPressHandler:(UITapGestureRecognizer *)gestureRecognizer {
    NSLog(@"tappa");
    [self toggleTimer:NO]; //starts metronome
}


- (void)longPressHandler:(UILongPressGestureRecognizer *)gestureRecognizer {
    
    //get pin point
    CGPoint location = [gestureRecognizer locationInView:_beatsUICollectionView];
    
    
    //Get current index based on pin point
    NSIndexPath *indexPath = [_beatsUICollectionView indexPathForItemAtPoint:location];
    
    //Put index number of current item into _activeCell
    _activeCell = indexPath.row;
    NSLog(@"longPressHandler: %li",(long)_activeCell);
    
    
    //get pin point (again?)
    startPoint = [gestureRecognizer locationInView:self.view];
    xCoord.text = [NSString stringWithFormat:@"x = %f",startPoint.x];
    yCoord.text = [NSString stringWithFormat:@"y = %f", startPoint.y];
    NSLog(@"---- ac%li bac %lu",(long)_start_cell, (unsigned long)[_beatsArray count]-1);
    
    
    
    //set flag to show long press
    if (_longFlag == false){
        _longFlag = true;
            [_beatsArray removeObjectAtIndex:_start_cell ];
        //ball2.hidden = false;
    }
    
    
        //place view at point
        ball2.center = CGPointMake(startPoint.x+15,startPoint.y-30);
    
    
    //this condition stops going outside from defaulting to 0
    //which affects the first array item
    startPoint = [gestureRecognizer locationInView:self.view];
    xCoord.text = [NSString stringWithFormat:@"x = %f",startPoint.x];
    yCoord.text = [NSString stringWithFormat:@"y = %f", startPoint.y];
    location = [gestureRecognizer locationInView:_beatsUICollectionView];
    if ( [_beatsUICollectionView pointInside:location withEvent:nil] &&
        startPoint.x <= ([_beatsArray count] + 1) * 46 ) {
        [self setBlankFlagInBeatArray];
        [_beatsUICollectionView reloadData];
    }else{
        NSLog(@"f");
    }
    
    
    
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        //if IS the start, then...
        ball2.hidden = false;
    }
    else
    {
        //if NOT the start, then...
        //THIS IS WHEN BUTTON RELEASED
        
        if (gestureRecognizer.state == UIGestureRecognizerStateCancelled
            || gestureRecognizer.state == UIGestureRecognizerStateFailed
            || gestureRecognizer.state == UIGestureRecognizerStateEnded)
        {
            _longFlag = false;
            
            if ( [_beatsUICollectionView pointInside:location withEvent:nil] ) {
                // Point lies inside the bounds
                
                //[_beatsArray removeObjectAtIndex:_start_cell ];
                
                [self removeAllBlankFlagsFromBeatsArray];
                [_beatsArray insertObject:[NSNumber numberWithInt: _start_note_number] atIndex:_activeCell];
                //[_beatsArray removeObjectAtIndex:_start_cell + 1];
                NSLog(@"ended");
                ball2.hidden = true;
                
                [_beatsUICollectionView reloadData];
            }else{
                NSLog(@"ended outside");
                [self toggleTimer:YES];
                CGRect frame = ball2.frame;
                frame.size.height = 66;
                ball2.frame = frame;
                ball2.backgroundColor = [UIColor redColor];
                
                ball2.layer.borderColor = [UIColor colorWithWhite:1.0f alpha:1.0f].CGColor;
                ball2.layer.borderWidth = 1.0f;
                [UIView animateWithDuration:.5
                                 animations:^{
                                     CGRect frame = ball2.frame;
                                     // adjust size of frame to desired value
                                     frame.size.height = 0;
                                     ball2.frame = frame; // set frame on your view to the adjusted size
                                 }
                                 completion:^(BOOL finished){
                                     ball2.backgroundColor = [UIColor blueColor];
                                     CGRect frame = ball2.frame;
                                     // adjust size of frame to desired value
                                     frame.size.height = 66;
                                     ball2.frame = frame;
                                     ball2.backgroundColor = [UIColor orangeColor];
                                     ball2.layer.borderWidth = 0.0f;
                                     ball2.hidden = true;
                                     [self removeAllBlankFlagsFromBeatsArray];
                                     _thumbTabCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)[_beatsArray count]];
                                     [_beatsUICollectionView reloadData];
                                 }];
            }
            
        }
    }
}

- (void)tapTempoNumberHandler:(UITapGestureRecognizer *)gestureRecognizer {
    [self sliderHide];
    //[self numberHideTimerStart];
    NSLog(@"tapp numbahs");
}

-(IBAction)collectionViewCellButtonPressed:(id *)sender withEvent: (UIEvent *) event{
    startPoint = [[[event allTouches] anyObject] locationInView:self.view];
    _xPo = startPoint.x;
    NSLog(@"here press---");
}

-(IBAction)collectionViewCellButtonTouchDown:(id *)sender withEvent: (UIEvent *) event {
    //_currentBeat = 0;
    startpoint = [[[event allTouches] anyObject] locationInView:_beatsUICollectionView];
    NSIndexPath *indexPath = [_beatsUICollectionView indexPathForItemAtPoint:startpoint];
    _ball2Label.font = [UIFont fontWithName:@"MusiSync" size:55];
    NSLog(@"WWW: %li", (long)indexPath.row);
    
    int txt = [[_beatsArray objectAtIndex:indexPath.row] intValue];
    //int txt = 0;
    if (txt == 0) {
        _ball2Label.text = @"e";
    }else if (txt == 1) {
        _ball2Label.text = @"q";
    }else if (txt == 2) {
        _ball2Label.text = @"j";
    }else if (txt == 3) {
        _ball2Label.text = @"h";
    }else if (txt == 99) {
        _ball2Label.text = @" ";
    }
    
    _start_cell = indexPath.row;
    _start_note_number = txt;
    //[_beatsArray removeObjectAtIndex:_start_cell ];
    startPoint = [[[event allTouches] anyObject] locationInView:self.view];
    xCoord.text = [NSString stringWithFormat:@"x = %f",startPoint.x];
    yCoord.text = [NSString stringWithFormat:@"y = %f", startPoint.y];
    //ball2.hidden = false;
    ball2.backgroundColor = [UIColor clearColor];
    ball2.center = CGPointMake(_xPo,startPoint.y);
    /*
    if (txt == 0) {
        [_beatsArray replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithInt:1]];
    }else if (txt == 1) {
        [_beatsArray replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithInt:2]];
    }else if (txt == 2) {
        [_beatsArray replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithInt:3]];
    }else if (txt == 3) {
        [_beatsArray replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithInt:0]];
    }
    [_beatsUICollectionView reloadData];
    */
    
    NSLog(@"wwwwwwwwww");
    
    
    
    
    
}

-(IBAction)collectionViewCellButtonDragDone:(id *)sender withEvent: (UIEvent *) event {
    ball2.hidden = true;
    [_beatsUICollectionView reloadData];
}

-(IBAction)collectionViewCellButtonTouchUpOutside:(id *)sender withEvent: (UIEvent *) event {
    ball2.hidden = true;
    [_beatsUICollectionView reloadData];
}

-(IBAction)collectionViewCellButtonTouchUpInside:(id *)sender withEvent: (UIEvent *) event {
    NSIndexPath *indexPath = [_beatsUICollectionView indexPathForItemAtPoint:startpoint];
    int txt = [[_beatsArray objectAtIndex:indexPath.row] intValue];
    
    if (txt == 0) {
        [_beatsArray replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithInt:1]];
    }else if (txt == 1) {
        [_beatsArray replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithInt:2]];
    }else if (txt == 2) {
        [_beatsArray replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithInt:3]];
    }else if (txt == 3) {
        [_beatsArray replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithInt:0]];
    }
    [_beatsUICollectionView reloadData];
    NSLog(@"touch up inside");
}

//S E T U P
- (NSUInteger)supportedInterfaceOrientations { return  UIInterfaceOrientationMaskAll; }
-(BOOL)shouldAutorotate{ return YES; }
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{ return TRUE; }
-(void)viewDidDisappear:(BOOL)animated{ [self toggleTimer:YES]; }
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [self toggleTimer:NO];
    NSLog(@"%@",@"Show alert low memory");
}

- (IBAction)playButton:(UIButton *)sender {
    [self toggleTimer:NO];
}

- (IBAction)thumbTabButtonPressed:(id)sender {
    [self itemAdd];
}
- (IBAction)helpButtonPressed:(UIButton *)sender {
        if (_helpText1.hidden == false){
            _helpText1.hidden = true;
            _helpText2.hidden = true;
            _helpText3.hidden = true;
            _helpText4.hidden = true;
            _helpText5.hidden = true;
            _helpQuestionMarkLabel.backgroundColor = [UIColor clearColor];
            _helpQuestionMarkLabel.textColor = [UIColor whiteColor];
        }else{
            _helpText1.hidden = false;
            _helpText2.hidden = false;
            _helpText3.hidden = false;
            _helpText4.hidden = false;
            _helpText5.hidden = false;
            _helpQuestionMarkLabel.backgroundColor = [UIColor whiteColor];
            _helpQuestionMarkLabel.textColor = [UIColor colorWithRed:99/255.0 green:0/255.0 blue:223/255.0 alpha:1.0];
        }
}

@end
