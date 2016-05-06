//
//  JSGraphAxis.h
//  TrainSmart
//
//  Created by Jordan Stone on 8/2/13.
//  Copyright (c) 2013 Shotdrum Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JSGraphView;

typedef NS_ENUM(NSUInteger, JSGraphAxisType) {
    JSGraphAxisTypeXAxis,
    JSGraphAxisTypeYAxis
};

@interface JSGraphAxis : UIView

@property (nonatomic) JSGraphAxisType axisType;
@property (nonatomic, weak) JSGraphView *graphView;
@property (nonatomic, strong) UILabel *axisTitleLabel;
@property (nonatomic, strong) NSString *axisTitle;
@property (nonatomic, strong) NSArray *intervalTitles;
@property (nonatomic) NSInteger minimumValue;
@property (nonatomic) NSInteger maximumValue;
@property (nonatomic) NSInteger numberOfIntervals;

@end
