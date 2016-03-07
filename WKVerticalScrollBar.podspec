Pod::Spec.new do |s|
  s.name         = 'WKVerticalScrollBar'
  s.version      = '0.3.2'
  s.license      = 'MIT'
  s.platform     = :ios

  s.summary      = 'A traditional-style scrollbar for iOS that integrates with existing UIScrollView or UIScrollView subclasses.'
  s.homepage     = 'https://github.com/litl/WKVerticalScrollBar'
  s.author       = { 'Brad Taylor' => 'btaylor@litl.com' }
  s.source       = { :git => 'https://github.com/litl/WKVerticalScrollBar.git' }

  s.source_files = 'WKVerticalScrollBar/WKVerticalScrollBar.{h,m}'
  s.requires_arc = false
  
  s.frameworks   = 'QuartzCore'
end
