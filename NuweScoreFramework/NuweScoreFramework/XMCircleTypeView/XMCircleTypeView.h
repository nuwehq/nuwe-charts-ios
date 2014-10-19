//
//  XMCircleTypeView.h
//  XMCircleType
//
//  Created by Michael Teeuw on 07-01-14.
//  Copyright (c) 2014 Michael Teeuw. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    XMCircleTypeVerticalAlignOutside,
    XMCircleTypeVerticalAlignCenter,
    XMCircleTypeVerticalAlignInside
} XMCircleTypeVerticalAlignment;


@interface XMCircleTypeView : UIView

/**
 *  Set the text to display in the XMCircleTypeView
 */
@property (strong, nonatomic) NSString *text;

/**
 *  Set the Text Attributes for the text.
 *  Refer to the Text Attributes documentation for more info.
 */
@property (strong, nonatomic) NSDictionary *textAttributes;

/**
 *  Align the text left, right or center reletive to the baseAngle.
 */
@property (nonatomic) NSTextAlignment textAlignment;

/**
 *  Align the text inside, outside or centered on the circle.
 */
@property (nonatomic) XMCircleTypeVerticalAlignment verticalTextAlignment;

/**
 *  Set the radius of the circle. 
 *  When no radius is set, the maximum radius is calculated and used.
 */
@property (nonatomic) float radius;

/**
 *  Set the base angle. See textAlignment property for more information.
 */
@property (nonatomic) float baseAngle;

/**
 *  Adjust the spacing of the characters. 
 *  1 = default spacing, 0.5 = half spacing, 2 = double spacing, etc ...
 */
@property (nonatomic) float characterSpacing;

/**
 *  Show some visual guidelines.
 */
@property (nonatomic) BOOL visualDebug;

/**
 *  Disable the kerning cache.
 */
@property (nonatomic) BOOL disableKerningCache;

/**
 *  Clear the kerning cache. 
 *  Note that this is automaticlly done when the app gives a memory warning.
 */
- (void)clearKerningCache;

/**
 *  Convenience function for quickly changing the textColor
 *  without the need of creating an NSDictionary *textAttributes
 */
- (void) setColor:(UIColor *)color;

@end
