//
//  JSGraphView.h
//  TrainSmart
//
//  Created by Jordan Stone on 8/2/13.
//  Copyright (c) 2013 Shotdrum Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSGraphAxis.h"
#import "JSGraphPoint.h"

@class JSGraphPoint;
@class JSGraphAxis;
@class JSGraphView;

@protocol JSGraphViewDelegate <NSObject>

@optional;
- (void)graphView:(JSGraphView *)graphView didSelectGraphPoint:(JSGraphPoint *)graphPoint atIndex:(NSInteger)index;

@end

@protocol JSGraphViewDataSource <NSObject>

@required
- (NSInteger)minimumValueForAxis:(JSGraphAxis *)axis;
- (NSInteger)maximumValueForAxis:(JSGraphAxis *)axis;
- (NSUInteger)numberOfIntervalsForAxis:(JSGraphAxis *)axis;
- (NSInteger)numberOfPointsInGraphView:(JSGraphView *)graphView;
- (JSGraphPoint *)graphView:(JSGraphView *)graphView pointForPointAtIndex:(NSInteger)index;

@optional
- (NSString *)titleForAxis:(JSGraphAxis *)axis;
- (NSString *)titleForInterval:(NSInteger)intervalIndex onAxis:(JSGraphAxis *)axis;

@end

@interface JSGraphView : UIView

@property (nonatomic, weak) id<JSGraphViewDelegate> delegate;
@property (nonatomic, weak) id<JSGraphViewDataSource> dataSource;
@property (nonatomic, strong) JSGraphPoint *selectedGraphPoint;

- (NSString *)titleForAxis:(JSGraphAxis *)axis;

@end
