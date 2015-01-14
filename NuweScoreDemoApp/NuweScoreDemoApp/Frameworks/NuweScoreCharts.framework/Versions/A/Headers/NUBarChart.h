//
//  NUBarChart.h
//  NuweScoreFramework
//
//  Created by Dev Mac on 10/19/14.
//  Copyright (c) 2014 Dimitar Plamenov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNBarChart.h"


@class NUBarChart;

@protocol NUBarChartDataSource <NSObject>

/* Get a array for Y values
 @param : NUBarChart
 @return : NSArray of values
 */
- (NSArray *) valuesOfYWithBarChart:(NUBarChart*) barChart;

/* Get a array of bar colors - It's only active color.
 @param : NUBarChart
 @return : NSArray of values
 */
- (NSArray *) barColorsWithBarChart:(NUBarChart*) barChart;

/* Get max value of Y values
 @param : NUBarChart
 @return : max value
 */
- (int) maxYValueWithBarChart:(NUBarChart*) barChart;


@end

@protocol NUBarChartDelegate <NSObject>

- (void) touchNUBar:(NUBarChart*) barChart index:(int) _index;

@end

@interface NUBarChart : UIView <PNBarChartDelegate>
{
    PNBarChart * barChart;
}

@property (nonatomic) id<NUBarChartDataSource> barDataSource;
@property (nonatomic) id<NUBarChartDelegate> barDelegate;

- (void) reloadDialWithAnimation:(BOOL) animation;
- (void) setupWithFrame:(CGRect) frame;

@end
