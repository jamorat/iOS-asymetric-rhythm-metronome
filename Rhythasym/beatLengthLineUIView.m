//
//  beatLengthLineUIView.m
//  Rhythasym
//
//  Created by R on 5/17/15.
//  Copyright (c) 2015 JackAmoratis. All rights reserved.
//

#import "beatLengthLineUIView.h"

@implementation beatLengthLineUIView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if(self = [super initWithCoder:aDecoder]) {
        self.layer.cornerRadius = 2;
        self.layer.masksToBounds = YES;
    }
    
    return self;
}



@end

