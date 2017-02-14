//
//  PXMaskView.h
//
//  Created by Daniel Blakemore on 4/14/14.
//
//  Copyright (c) 2015 Pixio
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import <UIKit/UIKit.h>

/**
 *  A view containing an image and some text which is rendered either in a solid color over a transparent background or as transparent over a solid background.
 */
@interface PXMaskButton : UIControl

/**
 * The base color for the gradient and the drawing.
 */
@property (nonatomic, nullable) UIColor * tintColor UI_APPEARANCE_SELECTOR;

/**
 * The image used as a mask for the gradient (or just drawn as a white image).
 */
@property (nonatomic, nullable) UIImage * icon;

/**
 * The text drawn/masked below the image.
 */
@property (nonatomic, nullable) NSString * text;

/**
 *  The font for the button title.
 * 
 *  This font overrides the class-level default font.
 */
@property (nonatomic, nullable) UIFont * font UI_APPEARANCE_SELECTOR;

/**
 * The size of font to use.
 *
 * Setting this font does NOT mean you must set the instance-level font as well.
 */
@property (nonatomic) CGFloat fontSize UI_APPEARANCE_SELECTOR;

/**
 * Width of border.
 */
@property (nonatomic) CGFloat borderWidth UI_APPEARANCE_SELECTOR;

/**
 *  Amount to inset the icon within the space it would draw (i.e. does not affect the text).
 */
@property (nonatomic) CGSize insetAmount;

/**
 *  The spacing to be used between the button and the text.
 */
@property (nonatomic) CGFloat contentSpacing;

/**
 *  How much empty space to leave around the content of the button.
 */
@property (nonatomic) UIEdgeInsets edgeInsets;

/**
 *  The corner radius applied to the entire view including the gradient background.
 */
@property (nonatomic) CGFloat cornerRadius UI_APPEARANCE_SELECTOR;

/**
 * The color of the border drawn when the view is unselected.
 */
@property (nonatomic, nullable) UIColor * borderColor UI_APPEARANCE_SELECTOR;

/**
 * Whether to use a gradient when the background is filled. Default is TRUE.
 */
@property (nonatomic) BOOL useGradient UI_APPEARANCE_SELECTOR;

/**
 *  Whether or not to toggle state or just highlight only when presses are down. Default value is FALSE.
 */
@property (nonatomic) BOOL toggles;

@end
