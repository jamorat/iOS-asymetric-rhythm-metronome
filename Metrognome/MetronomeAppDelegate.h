//
//  MetronomeAppDelegate.h
//  Metrognome
//
//  Created by R on 5/17/14.
//  Copyright (c) 2014 R. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MetronomeAppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property(atomic,retain) NSMutableArray *sharedArray;
@property(strong,nonatomic) NSMutableArray *timeItems;
//@property (strong, nonatomic) NSString *global_string;
@end
