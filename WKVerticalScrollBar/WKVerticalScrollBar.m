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

#import "WKVerticalScrollBar.h"

#define CLAMP(x, low, high)  (((x) > (high)) ? (high) : (((x) < (low)) ? (low) : (x)))

@implementation WKVerticalScrollBar

@synthesize handleWidth = _handleWidth;
@synthesize handleHitWidth = _handleHitWidth;
@synthesize handleSelectedWidth = _handleSelectedWidth;

@synthesize handleMinimumHeight = _handleMinimumHeight;

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        _handleWidth = 5.0f;
        _handleSelectedWidth = 15.0f;
        _handleHitWidth = 44.0f;
        _handleMinimumHeight = 70.0f;
        
        handleHitArea = CGRectZero;
        
        normalColor = [[UIColor colorWithWhite:0.6f alpha:1.0f] retain];
        selectedColor = [[UIColor colorWithWhite:0.4f alpha:1.0f] retain];

        handle = [[CALayer alloc] init];
        [handle setAnchorPoint:CGPointMake(1.0f, 0.0f)];
        [handle setFrame:CGRectMake(0, 0, _handleWidth, 0)];
        [handle setBackgroundColor:[normalColor CGColor]];
        [[self layer] addSublayer:handle];
    }
    return self;
}

- (void)dealloc
{
    [handle release];
    
    [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
    [_scrollView removeObserver:self forKeyPath:@"contentSize"];
    [_scrollView release];
    
    [_handleAccessoryView release];
    
    [normalColor release];
    [selectedColor release];

    [super dealloc];
}

- (UIScrollView *)scrollView
{
    return _scrollView;
}

- (void)setScrollView:(UIScrollView *)scrollView;
{
    [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
    [_scrollView removeObserver:self forKeyPath:@"contentSize"];

    [_scrollView release];
    _scrollView = [scrollView retain];
    
    [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [_scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    [_scrollView setShowsVerticalScrollIndicator:NO];
    
    [self setNeedsLayout];
}

- (UIView *)handleAccessoryView
{
    return _handleAccessoryView;
}

- (void)setHandleAccessoryView:(UIView *)handleAccessoryView
{
    [_handleAccessoryView removeFromSuperview];
    [_handleAccessoryView release];
    _handleAccessoryView = [handleAccessoryView retain];
    
    [_handleAccessoryView setAlpha:0.0f];
    [self addSubview:_handleAccessoryView];
    [self setNeedsLayout];
}

- (void)setHandleColor:(UIColor *)color forState:(UIControlState)state
{
    if (state == UIControlStateNormal) {
        [normalColor release];
        normalColor = [color retain];
    } else if (state == UIControlStateSelected) {
        [selectedColor release];
        selectedColor = [color retain];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];

    CGRect bounds = [self bounds];
    CGFloat contentHeight = [_scrollView contentSize].height;
    CGFloat frameHeight = [_scrollView frame].size.height;
    
    // Calculate the current scroll value (0, 1) inclusive.
    // Note that contentOffset.y only goes from (0, contentHeight - frameHeight)
    CGFloat scrollValue = [_scrollView contentOffset].y / (contentHeight - frameHeight);
    
    // Set handleHeight proportionally to how much content is being currently viewed
    CGFloat handleHeight = CLAMP((frameHeight / contentHeight) * bounds.size.height,
                                 _handleMinimumHeight, bounds.size.height);
    
    // Not only move the handle, but also shift where the position maps on to the handle,
    // so that the handle doesn't go off screen when the scrollValue approaches 1.
    CGFloat handleY = CLAMP((scrollValue * bounds.size.height) - (scrollValue * handleHeight),
                            0, bounds.size.height - handleHeight);

    CGFloat previousWidth = [handle bounds].size.width ?: _handleWidth;
    [handle setPosition:CGPointMake(bounds.size.width, handleY)];
    [handle setBounds:CGRectMake(0, 0, previousWidth, handleHeight)];
    
    // Center the accessory view to the left of the handle
    CGRect accessoryFrame = [_handleAccessoryView frame];
    [_handleAccessoryView setCenter:CGPointMake(bounds.size.width - _handleHitWidth - (accessoryFrame.size.width / 2),
                                                handleY + (handleHeight / 2))];
    
    handleHitArea = CGRectMake(bounds.size.width - _handleHitWidth, handleY,
                               _handleHitWidth, handleHeight);
    
    [CATransaction commit];
}

- (void)growHandle
{
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.3f];

    [handle setBounds:CGRectMake(0, 0, _handleSelectedWidth, [handle bounds].size.height)];
    [handle setBackgroundColor:[selectedColor CGColor]];
    
    [CATransaction commit];
    
    [UIView animateWithDuration:0.3f animations:^{
        [_handleAccessoryView setAlpha:1.0f];
    }];
}

- (void)shrinkHandle
{    
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.3f];
    
    [handle setBounds:CGRectMake(0, 0, _handleWidth, [handle bounds].size.height)];
    [handle setBackgroundColor:[normalColor CGColor]];
    
    [CATransaction commit];
    
    [UIView animateWithDuration:0.3f animations:^{
        [_handleAccessoryView setAlpha:0.0f];
    }];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    return CGRectContainsPoint(handleHitArea, point);
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    lastTouchPoint = [touch locationInView:self];

    // When the user initiates a drag, make the handle grow so it's easier to see
    handleDragged = YES;
    [self growHandle];

    [self setNeedsLayout];

    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{    
    CGPoint point = [touch locationInView:self];

    CGSize contentSize = [_scrollView contentSize];
    CGPoint contentOffset = [_scrollView contentOffset];
    CGFloat frameHeight = [_scrollView frame].size.height;
    CGFloat deltaY = ((point.y - lastTouchPoint.y) / [self bounds].size.height)
                     * [_scrollView contentSize].height;
    
    [_scrollView setContentOffset:CGPointMake(contentOffset.x,  CLAMP(contentOffset.y + deltaY,
                                                                      0, contentSize.height - frameHeight))
                         animated:NO];
    lastTouchPoint = point;

    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    lastTouchPoint = CGPointZero;
    
    // When user drag is finished, return handle to previous size
    handleDragged = NO;
    [self shrinkHandle];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (object != _scrollView) {
        return;
    }

    [self setNeedsLayout];
}

@end
