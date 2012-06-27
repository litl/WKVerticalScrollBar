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
@synthesize handleHighlightWidth = _handleHighlightWidth;

@synthesize handleMinimumHeight = _handleMinimumHeight;

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        _handleWidth = 5.0f;
        _handleHighlightWidth = 15.0f;
        _handleHitWidth = 44.0f;
        _handleMinimumHeight = 70.0f;
        
        handleHitArea = CGRectZero;
        
        normalColor = [[UIColor colorWithWhite:0.6f alpha:1.0f] retain];
        highlightedColor = [[UIColor colorWithWhite:0.4f alpha:1.0f] retain];

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
    
    [normalColor release];
    [highlightedColor release];

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

- (void)setHandleColor:(UIColor *)color forState:(UIControlState)state
{
    if (state == UIControlStateNormal) {
        [normalColor release];
        normalColor = [color retain];
    } else if (state == UIControlStateHighlighted) {
        [highlightedColor release];
        highlightedColor = [color retain];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGRect bounds = [self bounds];
  
    CGFloat contentHeight = [_scrollView contentSize].height;
    CGFloat contentOffsetY = [_scrollView contentOffset].y;
    CGFloat frameHeight = [_scrollView frame].size.height;
    
    CGFloat handleHeight = CLAMP((frameHeight / contentHeight) * bounds.size.height,
                                 _handleMinimumHeight, bounds.size.height);
    CGFloat handleY = CLAMP((contentOffsetY / contentHeight) * bounds.size.height,
                            0, bounds.size.height - handleHeight);
    
    // Preserve whatever width is currently set (by grow/shrinkHandle)
    CGFloat oldWidth = [handle bounds].size.width ?: _handleWidth;
    
    [handle setPosition:CGPointMake(bounds.size.width, handleY)];
    [handle setBounds:CGRectMake(0, 0, oldWidth, handleHeight)];
    
    handleHitArea = CGRectMake(bounds.size.width - _handleHitWidth, handleY,
                               _handleHitWidth, handleHeight);
}

- (void)growHandle
{
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.3f];

    [handle setBounds:CGRectMake(0, 0, _handleHighlightWidth, [handle bounds].size.height)];
    [handle setBackgroundColor:[highlightedColor CGColor]];
    
    [CATransaction commit];
}

- (void)shrinkHandle
{    
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.3f];
    
    [handle setBounds:CGRectMake(0, 0, _handleWidth, [handle bounds].size.height)];
    [handle setBackgroundColor:[normalColor CGColor]];
    
    [CATransaction commit];
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
    CGFloat deltaY = ((point.y - lastTouchPoint.y) / [self bounds].size.height)
                     * [_scrollView contentSize].height;
    
    [_scrollView setContentOffset:CGPointMake(contentOffset.x,
                                              CLAMP(contentOffset.y + deltaY, 0, contentSize.height))
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
