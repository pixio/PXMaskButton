//
//  PXMaskView.m
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

#import "PXMaskButton.h"

#import <QuartzCore/QuartzCore.h>

#import <UIImageUtilities/UIImage+Tinted.h>

#define Padding -6.0f

@implementation PXMaskButton
{
    BOOL _oldSelected;
    
    CAGradientLayer * _colorLayer;
    CALayer * _maskLayer;
    CGFloat _savedBorderWidth;
}

+ (void)load
{
    [[PXMaskButton appearance] setFont:[UIFont systemFontOfSize:[UIFont systemFontSize]]];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _useGradient = TRUE;
        
        _colorLayer = [[CAGradientLayer alloc] init];
        [_colorLayer setFrame:CGRectMake(0, 0, 10, 10)];
        [[self layer] addSublayer:_colorLayer];
        
        _maskLayer = [[CALayer alloc] init];
        [_maskLayer setFrame:CGRectMake(0, 0, 10, 10)];
        [_maskLayer setDelegate:self];
        [_colorLayer setMask:_maskLayer];
        
        _fontSize = 12.0f;
    }
    return self;
}

- (void)layoutSublayersOfLayer:(CALayer *)layer
{
    if (layer == [self layer]) {
        [super layoutSublayersOfLayer:layer];
        [_maskLayer setFrame:[self bounds]];
        [_colorLayer setFrame:[self bounds]];
    }
}

- (void)displayLayer:(CALayer *)layer
{
    if (layer != _maskLayer) {
        [super displayLayer:layer];
        return;
    }
    
    // draw image and text
    // find size of image
    CGSize imageSize = [_icon size];
    
    // find size of rendered text
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSDictionary * attributes = @{
                                  NSFontAttributeName : [[self font] fontWithSize:_fontSize],
                                  NSForegroundColorAttributeName : [UIColor whiteColor],
                                  NSParagraphStyleAttributeName : paragraphStyle,
                                  };
    CGSize textSize = [_text boundingRectWithSize:[[self layer] bounds].size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    // align them in a centered fashion
    CGRect r = self.bounds;
    
    CGRect imageRect;
    imageRect.size = imageSize;
    imageRect.origin.x = (r.size.width / 2) - (imageSize.width / 2);
    imageRect.origin.y = (r.size.height / 2) - ((imageSize.height + textSize.height + Padding) / 2);
    
    CGRect textRect;
    textRect.size = textSize;
    textRect.origin.x = (r.size.width / 2) - (textSize.width / 2);
    textRect.origin.y = (_icon ? imageRect.origin.y + imageSize.height + Padding : (r.size.height / 2) - (textSize.height / 2));
    
    // make da image
    CGFloat scale = [[UIScreen mainScreen] scale];
    // get width and height as integers, since we'll be using them as
    // array subscripts, etc, and this'll save a whole lot of casting
    int width = r.size.width * scale;
    int height = r.size.height * scale;
    
    // Create a suitable RGB+alpha bitmap context in BGRA colour space
    CGColorSpaceRef colourSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *memoryPool = (unsigned char *)calloc(width * height * 4, 1);
    CGContextRef context = CGBitmapContextCreate(memoryPool, width, height, 8, width * 4, colourSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colourSpace);
    
    if (!context) {
        return;
    }
    
    CGContextScaleCTM(context, scale, -scale);
    CGContextTranslateCTM(context, 0, -r.size.height);
    
    UIGraphicsPushContext(context);

    if (_icon != nil)
    {
        imageRect = CGRectInset(imageRect, _insetAmount.width, _insetAmount.height);
    }
    [_icon drawInRect:CGRectIntegral(imageRect)];
    [_text drawInRect:CGRectIntegral(textRect) withAttributes:attributes];
    
    UIGraphicsPopContext();
    
    if ([self isSelected]) {
        // run through every pixel, a scan line at a time...
        for(int y = 0; y < height; y++)
        {
            // get a pointer to the start of this scan line
            unsigned char *linePointer = &memoryPool[y * width * 4];
            
            // step through the pixels one by one...
            for(int x = 0; x < width; x++)
            {
                linePointer[3] = 255 - linePointer[3];
                linePointer += 4;
            }
        }
    }
    
    // get a CG image from the context, wrap that into a
    // UIImage
    CGImageRef cgImage = CGBitmapContextCreateImage(context);
    
    // drawer
    [layer setContents:(__bridge id)cgImage];
    
    // clean up
    CGImageRelease(cgImage);
    CGContextRelease(context);
    free(memoryPool);
}

- (void)setTintColor:(UIColor *)tintColor
{
    _tintColor = tintColor;
    
    [self makeGradient];
}

- (void)makeGradient
{
    CGFloat hue, saturation, brightness, alpha;
    UIColor* color = (_tintColor ?: [UIColor lightGrayColor]);
    if ([color getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha] != TRUE)
    {
        // Assume it's a grayscale color
        CGFloat* components = (CGFloat*)CGColorGetComponents([color CGColor]);
        hue = 0.0f;
        saturation = 0.0f;
        brightness = components[0];
        alpha = components[1];
    }
    if (_useGradient) {
        [_colorLayer setColors:@[(id)[[UIColor colorWithHue:hue saturation:saturation brightness:brightness * 1.0 alpha:alpha] CGColor],
                                 (id)[[UIColor colorWithHue:hue saturation:saturation brightness:(brightness * [self isSelected]) ? 0.8 : 1.0 alpha:alpha] CGColor]]];
    } else {
        [_colorLayer setColors:@[(id)[[UIColor colorWithHue:hue saturation:saturation brightness:brightness * 1.0 alpha:alpha] CGColor],
                                 (id)[[UIColor colorWithHue:hue saturation:saturation brightness:brightness * 1.0 alpha:alpha] CGColor]]];
    }
    [_colorLayer setLocations:nil];
}

- (void)setIcon:(UIImage *)icon
{
    _icon = [icon tintedFlatImageUsingColor:[UIColor whiteColor]];
    
    [_maskLayer setNeedsDisplay];
}

- (void)setText:(NSString *)text
{
    _text = text;
    
    [_maskLayer setNeedsDisplay];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    [[self layer] setBorderWidth:[self isSelected] ? 0 : _borderWidth];
    [_maskLayer setNeedsDisplay];
    [self makeGradient];
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    _borderWidth = borderWidth;
    [[self layer] setBorderWidth:[self isSelected] ? 0 : _borderWidth];
}

- (void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
    [[self layer] setBorderColor:[_borderColor CGColor]];
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius = cornerRadius;
    [[self layer] setCornerRadius:_cornerRadius];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    _oldSelected = [self isSelected]; // save in case of cancel
    
    //  Immediately animate change
    [self touchesMoved:touches withEvent:event];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // ~isSelected if finger on, not if finger off.
    if (CGRectContainsPoint([self bounds], [[touches anyObject] locationInView:self])) {
        [self setSelected:!_oldSelected];
    } else {
        [self setSelected:_oldSelected];
    }
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // send final touch
    if (_toggles && CGRectContainsPoint([self bounds], [[touches anyObject] locationInView:self])) {
        // only toggle state if the user said to
        [self setSelected:!_oldSelected];
    } else {
        [self setSelected:_oldSelected];
    }
    [self sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    // reset back to original value and send no event (unless continuous, then reset)
    [self setSelected:_oldSelected];
    [self sendActionsForControlEvents:UIControlEventTouchUpOutside];
}

@end
