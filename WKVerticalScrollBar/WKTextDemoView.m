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

#import "WKTextDemoView.h"

@implementation WKTextDemoView

@synthesize verticalPadding = _verticalPadding;

@synthesize textLabel = _textLabel;
@synthesize scrollView = _scrollView;
@synthesize verticalScrollBar = _verticalScrollBar;
@synthesize accessoryView = _accessoryView;

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        _verticalPadding = 50.0f;
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        [_scrollView setBackgroundColor:[UIColor colorWithRed:0xE4 / 255.0f
                                                        green:0xE2 / 255.0f
                                                         blue:0xDD / 255.0f
                                                        alpha:1.0f]];
        [_scrollView addObserver:self
                      forKeyPath:@"contentOffset"
                         options:NSKeyValueObservingOptionNew
                         context:nil];
        [self addSubview:_scrollView];
        
        _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_textLabel setBackgroundColor:[UIColor clearColor]];
        [_textLabel setFont:[UIFont fontWithName:@"Baskerville" size:18.0f]];
        [_textLabel setNumberOfLines:0];
        [_textLabel setLineBreakMode:UILineBreakModeWordWrap];
        [_scrollView addSubview:_textLabel];

        // NOTE: Make sure vertical scroll bar is on top of the scroll view
        _verticalScrollBar = [[WKVerticalScrollBar alloc] initWithFrame:CGRectZero];
        [_verticalScrollBar setScrollView:_scrollView];
        [self addSubview:_verticalScrollBar];
        
        _accessoryView = [[WKAccessoryView alloc] initWithFrame:CGRectMake(0, 0, 65, 30)];
        [_accessoryView setForegroundColor:[UIColor colorWithWhite:0.2f alpha:1.0f]];
        [_verticalScrollBar setHandleAccessoryView:_accessoryView];
    }
    return self;
}

- (void)dealloc
{
    [_textLabel release];
    [_scrollView release];
    [_verticalScrollBar release];

    [super dealloc];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect bounds = [self bounds];

    CGFloat columnWidth = bounds.size.width * 0.8f;
    CGSize textSize = [[_textLabel text] sizeWithFont:[_textLabel font]
                                   constrainedToSize:CGSizeMake(columnWidth, FLT_MAX)];

    [_scrollView setContentSize:CGSizeMake(bounds.size.width, textSize.height + (_verticalPadding * 2))];
    
    // Center the label in the screen
    [_textLabel setFrame:CGRectMake((bounds.size.width / 2) - (columnWidth / 2), _verticalPadding,
                                    columnWidth, textSize.height)];

    [_scrollView setFrame:CGRectMake(0, 0, bounds.size.width, bounds.size.height)];
    [_verticalScrollBar setFrame:CGRectMake(0, 0, bounds.size.width, bounds.size.height)];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (![keyPath isEqualToString:@"contentOffset"]) {
        return;
    }
    
    CGFloat contentOffsetY = [_scrollView contentOffset].y;
    CGFloat contentHeight = [_scrollView contentSize].height;
    CGFloat frameHeight = [_scrollView frame].size.height;
    
    CGFloat percent = (contentOffsetY / (contentHeight - frameHeight)) * 100;
    [[_accessoryView textLabel] setText:[NSString stringWithFormat:@"%i%%", (int)percent]];
}

@end
