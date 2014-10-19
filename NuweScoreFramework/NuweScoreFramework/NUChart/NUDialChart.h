//
//  NUDialChart.h
//  NuweScoreFramework
//
//  Created by Dev Mac on 10/17/14.
//  Copyright (c) 2014 Dimitar Plamenov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNCircleChart.h"
#import "UICountingLabel.h"
#import "XMCircleTypeView.h"

@class NUDialChart;

///////////////////  NUDailChart Datasource  /////////////////////
@protocol NUDialChartDataSource <NSObject>

/* Get number of dials
 @param : No params
 @return : Total number of dials
 */
// - (int) numberOfCirclesInDial:(NUDialChart*) dialChart;

/* Get total value of dial
 @param : No params
 @return : Total value of the dial
 */
// - (int) totalValueOfDial:(NUDialChart*) dialChart;

/* Get current value of specific dial by index
 @param : Index of specific dial
 @return : Current value of the dial
 */
- (NSNumber*) dialChart:(NUDialChart*) dialChart valueOfCircleAtIndex:(int) _index;

/* Get a color of specific dial by index
 @param : Index of specific dial
 @return : Color of the dial
 */
- (UIColor* ) dialChart:(NUDialChart*) dialChart colorOfCircleAtIndex:(int) _index;

/* Get a text of specific dial by index
 @param : Index of specific dial
 @return : Text of the dial
 */ // It's for just Nutribu
- (NSString* ) dialChart:(NUDialChart*) dialChart textOfCircleAtIndex:(int) _index;

/* Get a text color of specific dial by index
 @param : Index of specific dial
 @return : Text of the dial
 */ // It's for just Nutribu
- (UIColor* ) dialChart:(NUDialChart*) dialChart textColorOfCircleAtIndex:(int) _index;

/* Show center label and text
 @param : No params
 @return : Is show center label?
 */
- (BOOL) isShowCenterLabelInDial:(NUDialChart*) dialChart;

/* Show only border of dial
 @param : Index of specific dial
 @return : Is only frame of dial?
 */
- (BOOL) dialChart:(NUDialChart*) dialChart defaultCircleAtIndex:(int) _index;

/* Get current nuscore
 @param : No params
 @return : NU score
 */
- (int) nuscoreInDialChart:(NUDialChart*) dialChart;

/* Get a color of center label's text color
 @param : Index of specific dial
 @return : Color of the dial
 */
- (UIColor*) centerTextColorInDialChart:(NUDialChart*) dialChart;

/* Get a color of center label's background color
 @param : Index of specific dial
 @return : Color of the dial
 */
- (UIColor*) centerBackgroundColorInDialChart:(NUDialChart*) dialChart;


@end



////////////////////// NUDialChart Delegates   ///////////////////////////
@protocol NUDialChartDelegate <NSObject>

- (void) touchNuDialChart:(NUDialChart*) chart;

@end



//////////////////// Dynamic Nuwe Dial Chart  ////////////////////////////
@interface NUDialChart : UIView
{
    UILabel * labelTotalValue;
    NSMutableArray * arrayCircles;
    NSMutableArray * arrayTextViews;
    
    int totalValue;
    int circleCount;
}

@property (nonatomic) UICountingLabel * LabelCenterCurrent;

@property (nonatomic, assign) id<NUDialChartDataSource> chartDataSource;
@property (nonatomic, assign) id<NUDialChartDelegate> chartDelegate;

- (void) setupWithCount:(int) _count TotalValue:(int) _total;
- (void) setupWithCount:(int) _count TotalValue:(int) _total Frame:(CGRect) _frame;
- (void) reloadDialWithAnimation:(BOOL) animation;

@end
