//
//  PNCircleChart.h
//  PNChartDemo
//
//  Created by kevinzhow on 13-11-30.
//  Copyright (c) 2013年 kevinzhow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNColor.h"
#import "UICountingLabel.h"

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@interface PNCircleChart : UIView

-(void)strokeChart;
-(void)toggleChart:(BOOL) isBig Hidden:(BOOL) hide;
- (id)initWithFrame:(CGRect)frame andTotal:(NSNumber *)total andCurrent:(NSNumber *)current andClockwise:(BOOL)clockwise hiddenLabel:(BOOL) hidden;

@property(nonatomic, assign) BOOL hiddenLabel;
@property (nonatomic, assign) BOOL isFrame;
@property (nonatomic, strong) UIColor *strokeColor;
@property (nonatomic, strong) UIColor *labelColor;
@property (nonatomic, strong) NSNumber * total;
@property (nonatomic, strong) NSNumber * current;
@property (nonatomic, strong) NSNumber * lineWidth;
@property (nonatomic, assign) float  labelFontSize;
@property (nonatomic) BOOL clockwise;
@property (nonatomic) BOOL editable;

@property(nonatomic,strong) CAShapeLayer * circleBG;
@property(nonatomic,strong) CAShapeLayer * circle;
@property(nonatomic,strong) CAShapeLayer * circleBorder;

@property (nonatomic,strong) UICountingLabel *gradeLabel;
// for control chart
- (id)initWithFrame:(CGRect)frame andStart:(CGFloat)rStart andEnd:(CGFloat)rEnd andCurrent:(CGFloat)rCurrent andClockwise:(BOOL)clockwise hiddenLabel:(BOOL) hidden;

@property (nonatomic, assign) CGFloat rStart;
@property (nonatomic, assign) CGFloat rEnd;

@end
