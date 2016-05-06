//
//  JSGraphPoint.m
//  TrainSmart
//
//  Created by Jordan Stone on 8/2/13.
//  Copyright (c) 2013 Shotdrum Studios. All rights reserved.
//

#import "JSGraphPoint.h"

@implementation JSGraphPoint

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [self.backgroundImage drawInRect:rect];
}

- (void)setBackgroundImage:(UIImage *)backgroundImage {
    if (_backgroundImage == backgroundImage) {
        return;
    }

    _backgroundImage = backgroundImage;

    [self setNeedsDisplay];
}

@end
