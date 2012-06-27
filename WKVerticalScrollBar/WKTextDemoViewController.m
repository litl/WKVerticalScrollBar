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

#import "WKTextDemoViewController.h"
#import "WKVerticalScrollBar.h"

@implementation WKTextDemoViewController

- (void)dealloc
{
    [demoView release];
    
    [super dealloc];
}

- (void)loadView
{
    demoView = [[WKTextDemoView alloc] initWithFrame:CGRectZero];
    [self setView:demoView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSString *fullPath = [[NSBundle mainBundle] pathForResource:@"fillerati" ofType:@"txt"];
    NSString *text = [NSString stringWithContentsOfFile:fullPath
                                               encoding:NSUTF8StringEncoding
                                                  error:nil];
    
    [[demoView textLabel] setText:text];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
