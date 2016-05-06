//
//  JSGraphView.m
//  TrainSmart
//
//  Created by Jordan Stone on 8/2/13.
//  Copyright (c) 2013 Shotdrum Studios. All rights reserved.
//

#import "JSGraphView.h"

#define kAxisInset 30.0

@implementation JSGraphView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Create an X Axis and a Y Axis
    JSGraphAxis *xAxis = [[JSGraphAxis alloc] initWithFrame:CGRectMake(self.bounds.origin.x + kAxisInset, self.bounds.size.height - kAxisInset, self.bounds.size.width - (kAxisInset * 2), 2)];
    [xAxis setAxisType:JSGraphAxisTypeXAxis];
    [xAxis setGraphView:self];
    [xAxis setMaximumValue:[self.dataSource maximumValueForAxis:xAxis]];
    [xAxis setMinimumValue:[self.dataSource minimumValueForAxis:xAxis]];

    [self addSubview:xAxis];

    JSGraphAxis *yAxis = [[JSGraphAxis alloc] initWithFrame:CGRectMake(self.bounds.origin.x + kAxisInset, self.bounds.origin.y + kAxisInset, 2, self.bounds.size.height - (kAxisInset * 2))];
    [yAxis setAxisType:JSGraphAxisTypeYAxis];
    [yAxis setGraphView:self];
    [yAxis setMaximumValue:[self.dataSource maximumValueForAxis:yAxis]];
    [yAxis setMinimumValue:[self.dataSource minimumValueForAxis:yAxis]];

    [self addSubview:yAxis];

    [self setupAxisTitleForXAxis:xAxis yAxis:yAxis];

    [self setupAxisIntervalsForAxis:xAxis];
    [self setupAxisIntervalsForAxis:yAxis];

    CGContextRef context = UIGraphicsGetCurrentContext();

    [self setupGraphPointsForXAxis:xAxis yAxis:yAxis inContext:context];
}


- (NSString *)titleForAxis:(JSGraphAxis *)axis {
    return nil;
}

- (void)setupAxisTitleForXAxis:(JSGraphAxis *)xAxis yAxis:(JSGraphAxis *)yAxis {
    if ([self.dataSource respondsToSelector:@selector(titleForAxis:)]) {
        // Move up the Y of the X Axis but a bit
        CGRect xFrame = xAxis.frame;
        xFrame.origin.y -= 50.0;
        xFrame.size.height += 70.0;

        [xAxis setFrame:xFrame];

        // Adjust the yAxis
        CGRect yFrame = yAxis.frame;
        yFrame.size.height -= 50.0;

        [yAxis setFrame:yFrame];

        // Size the axis label
        NSString *title = [self.dataSource titleForAxis:xAxis];

        [xAxis setAxisTitle:title];
    }
}

- (void)setupAxisIntervalsForAxis:(JSGraphAxis *)axis {
    NSInteger numberOfIntervals = [self.dataSource numberOfIntervalsForAxis:axis];

    if (numberOfIntervals > 0) {
        NSMutableArray *titlesArray = [NSMutableArray array];
        for (int i = 0; i < numberOfIntervals; i++) {
            NSString *intervalTitle = [self.dataSource titleForInterval:i onAxis:axis];

            [titlesArray addObject:intervalTitle];
        }

        [axis setIntervalTitles:titlesArray];
    }
}

- (void)setupGraphPointsForXAxis:(JSGraphAxis *)xAxis yAxis:(JSGraphAxis *)yAxis inContext:(CGContextRef)context {
    NSInteger numberOfPoints = [self.dataSource numberOfPointsInGraphView:self];

    if (numberOfPoints > 0) {
        //min: 5, max: 47. Height of the axis is known: 220pts. Difference = 42. 42/220 gives UIView points per JSGraphPoint. So, if the user passes in 37 as the y value, 37 / .2 = 185
        for (int i=0; i < numberOfPoints; i++) {
            // X coordinate conversion
            NSInteger xDifference = xAxis.maximumValue - xAxis.minimumValue;
            CGFloat xPointsPerInterval = xDifference / xAxis.frame.size.width;

            // Y coordinate conversion
            NSInteger yDifference = yAxis.maximumValue - yAxis.minimumValue;
            CGFloat yPointsPerInterval = yDifference / yAxis.frame.size.height;

            JSGraphPoint *point = [self.dataSource graphView:self pointForPointAtIndex:i];
            [point setFrame:CGRectMake((([point.xAxisValue floatValue] / xPointsPerInterval) + kAxisInset) - (CGRectGetWidth(point.frame) / 2),
                                       (yAxis.frame.size.height - ([point.yAxisValue floatValue] / yPointsPerInterval) + (kAxisInset)) - (CGRectGetHeight(point.frame) / 2),
                                       point.frame.size.width,
                                       point.frame.size.height)];

            UIControl *pointControl = [[UIControl alloc] initWithFrame:point.bounds];
            [pointControl addTarget:self action:@selector(pointTapped:) forControlEvents:UIControlEventTouchUpInside];
            [point addSubview:pointControl];

            NSLog(@"%@", NSStringFromCGRect(point.frame));

            [point setTag:i];

            [self addSubview:point];

            if (i == 0) {
                CGContextMoveToPoint(context, point.center.x, point.center.y);
            }
            else {
                CGContextAddLineToPoint(context, point.center.x, point.center.y);
            }
        }

        CGContextSetLineWidth(context, 2.0);
        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextDrawPath(context, kCGPathStroke);
    }
}

- (void)pointTapped:(UIControl *)pointControl {
    JSGraphPoint *graphPoint = (JSGraphPoint *)pointControl.superview;
    self.selectedGraphPoint = graphPoint;

    if ([self.delegate respondsToSelector:@selector(graphView:didSelectGraphPoint:atIndex:)]) {
        [self.delegate graphView:self didSelectGraphPoint:graphPoint atIndex:graphPoint.tag];
    }
}

@end
