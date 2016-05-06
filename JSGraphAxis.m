//
//  JSGraphAxis.m
//  TrainSmart
//
//  Created by Jordan Stone on 8/2/13.
//  Copyright (c) 2013 Shotdrum Studios. All rights reserved.
//

#import "JSGraphAxis.h"

@implementation JSGraphAxis

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _axisTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)setAxisType:(JSGraphAxisType)axisType {
    if (_axisType == axisType) {
        return;
    }

    _axisType = axisType;

    [self setNeedsDisplay];
}

- (void)setAxisTitle:(NSString *)axisTitle {
    if (axisTitle == _axisTitle) {
        return;
    }

    _axisTitle = axisTitle;

    [self setNeedsDisplay];
}

- (void)setIntervalTitles:(NSArray *)intervalTitles {
    if ([_intervalTitles isEqualToArray:intervalTitles]) {
        return;
    }

    _intervalTitles = intervalTitles;

    [self setNeedsDisplay];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();

    // The actual axis
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);

    if (self.axisType == JSGraphAxisTypeXAxis) {
        CGContextFillRect(context, CGRectMake(0, 0, rect.size.width, 2));
    }
    else {
        CGContextFillRect(context, CGRectMake(0, 0, 2, rect.size.height));
    }

    // Check for a title
    if (self.axisTitle) {
        CGRect axisTitleRect = CGRectMake(CGRectGetMidX(rect) - 25, rect.size.height - 35, 50, 50);

        [self.axisTitle drawInRect:axisTitleRect withFont:[UIFont systemFontOfSize:12.0] lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];
    }

    // Check for interval titles
    if ([self.intervalTitles count] > 0) {
        NSInteger counter = 0;
        for (NSString *title in self.intervalTitles) {

            NSInteger difference = self.maximumValue - self.minimumValue;
            CGFloat pointsPerInterval = difference / rect.size.width;

            CGRect titleRect = CGRectMake((counter * 7) / pointsPerInterval, 5, 15, 25);
            [title drawInRect:titleRect withFont:[UIFont systemFontOfSize:10.0] lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];

            counter++;
        }
    }
}


@end
