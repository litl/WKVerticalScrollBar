# WKVerticalScrollBar
A traditional-style scrollbar for iOS that integrates with existing UIScrollView or UIScrollView subclasses.

`WKScrollBar` draws a persistent scrollbar handle on top of a UIScrollView.  When tapped and dragged, `WKScrollBar` will scroll proportionately to its position on the screen.  This comes in handy with apps which present long lists of items (`UITextView`, `UITableView`, `AQGridView`, etc), as it makes it easy to navigate to any point in a list.

## Installing
### CocoaPods
Installing via [cocoapods](http://cocoapods.org) is the preferred method of using `WKVerticalScrollBar`.  Download the [spec file](https://github.com/CocoaPods/Specs/pull/262) locally, and add the following line to your `Podfile`:

    dependency 'WKVerticalScrollBar', '0.1.0', podspec => 'WKVerticalScrollBar.podspec'
    
### Manually
Copy both `WKVerticalScrollBar.h` and `WKVerticalScrollBar.m` into your project.  Make sure you've linked your project with `QuartzCore.framework`.

## Usage
`WKVerticalScrollBar` is meant to integrate quickly with projects using `UIScrollView` or `UIScrollView` subclasses like  `AQGridView`.  Getting started is easy:

1. Create a `WKVerticalScrollBar` instance either in IB or in your `-init` method.
2. Add the `WKVerticalScrollBar` to the parent `UIView`, making sure that it is the frontmost `UIView` either by adding it last, or via `-bringSubviewToFront:`.
3. Size the `WKVerticalScrollBar` so that it takes up the same area as the `UIScrollView` that it will manage.
4. Tell `WKVerticalScrollBar` which `UIScrollView` it will manage via `-setScrollView:`.

## Appearance
Modifying the look and feel of `WKScrollBar` can be done via the following methods:

* `-setHandleColor:forState:`

    Sets a color for `UIControlStateNormal` and `UIControlStateSelected` to control the normal and selected (finger down) colors of the handle.
    
    Defaults: `UIControlStateNormal`: 40% black, `UIControlStateSelected`: 60% black

* `-setHandleWidth:`

    Sets the width of the handle in the normal state.
    
    Default: 5pt.
    
* `-setHandleSelectedWidth:`

    Sets the width of the handle when selected.  This allows you to grow the handle when the user's finger is over the handle.
    
    Default: 15pt.
    
* `-setHandleHitArea:`

    Sets the width of the hit area for the handle.  This will allow your control to have a slightly larger hit area than what is visually presented.  Apple's iOS Human Interface Guidelines suggest that this be 44pt.
    
    Default: 44pt.
    
* `-setHandleMinimumHeight:`

    Sets the minimum height of the handle.
    
    The height of the handle is calculated based upon the ratio of the `contentOffset` and the `frame`.  If the `contentOffset` is too large, the handle may be too small to touch comfortably.  Use this parameter to ensure that a minimum handle size is preserved.

## Contributing
Anyone who would like to contribute to the project is more than welcome.
Basically, there's just a few steps to getting started:

1. Fork this repo
2. Make your changes
3. Add yourself to the AUTHORS file and submit a pull request!

## Copyright and License
WKVerticalScrollBar is Copyright (c) 2012 litl, LLC and licensed under the MIT license. See the LICENSE file for full details.
