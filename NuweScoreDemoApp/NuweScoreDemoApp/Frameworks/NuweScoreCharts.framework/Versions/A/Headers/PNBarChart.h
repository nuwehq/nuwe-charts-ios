//
//  PNBarChart.h
//  PNChartDemo
//
//  Created by kevin on 11/7/13.
//  Copyright (c) 2013年 kevinzhow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNBar.h"

#define chartMargin     1
#define xLabelMargin    5
#define yLabelMargin    5
#define yLabelHeight    5

@protocol PNBarChartDelegate <NSObject>

- (void) onClickBarWithIndex:(int) _index;

@end

@interface PNBarChart : UIView <PNBarDelegate>

/**
 * This method will call and stroke the line in animation
 */

-(void)strokeChart;

@property (strong, nonatomic) NSArray * xLabels;

@property (strong, nonatomic) NSArray * yLabels;

@property (strong, nonatomic) NSArray * yValues;

@property (nonatomic) CGFloat xLabelWidth;

@property (nonatomic) int yValueMax;

@property (nonatomic, strong) UIColor * strokeColor;

@property (nonatomic, strong) NSArray * strokeColors;

@property (nonatomic, strong) UIColor * barBackgroundColor;

@property (nonatomic) BOOL showLabel;

@property (nonatomic, assign) id<PNBarChartDelegate> pDelegate;

@end
