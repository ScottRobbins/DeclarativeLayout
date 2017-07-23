Pod::Spec.new do |s|
  s.name             = 'DeclarativeLayout'
  s.version          = '0.1.0'
  s.summary          = 'This library is a wrapper around UIKit/Autolayout that allows you to declaratively define the layout of your views'

  s.description      = <<-DESC
This library is a wrapper around UIKit/Autolayout that allows you to declaratively define the layout of your views. Redefine the layout of your views and the library will handle adding/removing subviews as well as activating and deactivating constraints as needed.
                       DESC

  s.homepage         = 'https://github.com/HotCocoaTouch/DeclarativeLayout'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'HotCocoaTouch' => 'srscottrobbins@gmail.com' }
  s.source           = { :git => 'https://github.com/hotcocoatouch/DeclarativeLayout.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  s.source_files = 'DeclarativeLayout/Classes/**/*'
  s.frameworks = 'UIKit'
end
