//
// WKVerticalScrollBar
// http://github.com/litl/WKVerticalScrollBar
//
// Copyright (C) 2012 litl, LLC
// Copyright (C) 2012 WKVerticalScrollBar authors
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to
// deal in the Software without restriction, including without limitation the
// rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
// sell copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
// IN THE SOFTWARE.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface WKVerticalScrollBar : UIControl {
@protected
    CALayer *handle;
    BOOL handleDragged;
    CGRect handleHitArea;
    
    UIColor *normalColor;
    UIColor *selectedColor;
    
    CGFloat _handleCornerRadius;
    CGFloat _handleSelectedCornerRadius;

    CGPoint lastTouchPoint;
    
    UIScrollView *_scrollView;
    UIView *_handleAccessoryView;
}

@property (nonatomic, readwrite) CGFloat handleWidth;
@property (nonatomic, readwrite) CGFloat handleHitWidth;
@property (nonatomic, readwrite) CGFloat handleSelectedWidth;

@property (nonatomic, readwrite) CGFloat handleCornerRadius;
@property (nonatomic, readwrite) CGFloat handleSelectedCornerRadius;

@property (nonatomic, readwrite) CGFloat handleMinimumHeight;

@property (nonatomic, readwrite, retain) UIScrollView *scrollView;
@property (nonatomic, readwrite, retain) UIView *handleAccessoryView;

- (void)setHandleColor:(UIColor *)color forState:(UIControlState)state;

@end
