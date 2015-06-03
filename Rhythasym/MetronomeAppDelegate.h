//
//  MetronomeAppDelegate.h
//  Metrognome
//
//  Created by Brian Sleeper and Jack Amoratis on 5/17/14.
//  Copyright (c) 2015 R. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface MetronomeAppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property(atomic,retain) NSMutableArray *sharedArray;
@property(strong,nonatomic) NSMutableArray *timeItems;

@end
