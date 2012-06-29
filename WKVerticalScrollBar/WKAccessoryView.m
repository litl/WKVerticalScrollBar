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

#import "WKAccessoryView.h"

@implementation WKAccessoryView

@synthesize arrowWidth = _arrowWidth;
@synthesize foregroundColor = _foregroundColor;

@synthesize labelEdgeInsets = _labelEdgeInsets;

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        [self setOpaque:NO];
        
        _arrowWidth = 10;
        _foregroundColor = [UIColor blackColor];
        _labelEdgeInsets = UIEdgeInsetsMake(4, 6, 4, 6);

        _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_textLabel setBackgroundColor:[UIColor clearColor]];
        [_textLabel setTextColor:[UIColor whiteColor]];
        [_textLabel setMinimumFontSize:8.0f];
        [self addSubview:_textLabel];
    }
    return self;
}

- (void)dealloc
{
    [_textLabel release];
    
    [super dealloc];
}

- (UILabel *)textLabel
{
    return _textLabel;
}

- (void)setTextLabel:(UILabel *)textLabel
{
    [_textLabel release];
    _textLabel = [textLabel retain];
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect bounds = [self bounds];
    
    [_textLabel setFrame:UIEdgeInsetsInsetRect(bounds, _labelEdgeInsets)];
}

- (void)drawRect:(CGRect)rect
{
    CGRect bounds = [self bounds];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // +-----------+
    // |            \
    // |            /
    // +-----------+
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, bounds.size.width - _arrowWidth, 0);
    CGPathAddLineToPoint(path, NULL, bounds.size.width, bounds.size.height / 2);
    CGPathAddLineToPoint(path, NULL, bounds.size.width - _arrowWidth, bounds.size.height);
    CGPathAddLineToPoint(path, NULL, 0, bounds.size.height);
    CGPathCloseSubpath(path);
    
    CGContextAddPath(context, path);
    CGContextSetFillColorWithColor(context, [[self foregroundColor] CGColor]);
    CGContextFillPath(context);
    
    CGPathRelease(path);
}

@end
