nuwe-charts
===========

A dynamic chart library for easily creating the Nuwe Score dial chart and History Bar Chart

![nuwe ios app v2 with nutrition_app dial 1](https://cloud.githubusercontent.com/assets/3216491/4875327/3ecdaadc-6292-11e4-8f19-024d4f8ba048.png)
![nuwe ios app v2 with nutrition_app dials horizontal view](https://cloud.githubusercontent.com/assets/3216491/4875328/3eced380-6292-11e4-9240-189321894901.png)


Installation
=============

Download the project

Add the NuweScore.Framework to your project

Make sure to include the Framework in "Link Binary With Libraries"


Setup StoryBoard
================

Add a UIView element to your storyboard.

Set its Custom Class to

- NUDialChart - This will generate the dynamically sized circular dial chart you see in the Nuwe & Nutribu Apps.
- NUBarChart - This will generate the historical bar chart you see in the Nuwe & Nutribu apps.

Setup Your View Controller
==========================

Import the NuWeScoreChart library:

```
#import <NuweScoreChart/NuweScoreFramework.h>
```

Initialise it:

For Dial:
```
[TopDialChart1 setupWithCount:4 TotalValue:100];
[TopDialChart1 setChartDataSource:self];
[TopDialChart1 setChartDelegate:self];
[TopDialChart1 reloadDialWithAnimation:YES];
```

For Bar Chart:
```
[LandBarChart setupWithFrame:LandBarChart.frame];
LandBarChart.barDataSource = self;
LandBarChart.barDelegate = self;
```

DataSource & Delegates
=======================

For Dial:

```
@protocol NUDialChartDataSource <NSObject>
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
- (UIColor* ) dialChart:(NUDialChart*) dialChart textColorOfCircleAtIndex:(int) 
_index;
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
```
```
@protocol NUDialChartDelegate <NSObject>
- (void) touchNuDialChart:(NUDialChart*) chart;
@end
```

For Bar Chart:

```
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
```
```
@protocol NUBarChartDelegate <NSObject>
- (void) touchNUBar:(NUBarChart*) barChart index:(int) _index;
@end
```

License:
To be determined

Thanks To:

kevinzhow for the wonderful simple [PNChart Lib](https://github.com/kevinzhow/PNChart)
