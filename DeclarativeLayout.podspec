Pod::Spec.new do |s|
  s.name             = 'DeclarativeLayout'
  s.version          = '0.5.0'
  s.summary          = 'A declarative, expressive and efficient way to lay out your views.'

  s.description      = <<-DESC
* Declarative - Tell the framework what the layout of your views should be and let the framework intelligently add/modify/remove constraints and views for you.
* Expressive - Let your code visually express the hierarchy of your views.
* Fast - The example below, running on an iPhone X will update the layout in under 3 milliseconds.
* Flexible - Write the same constraints you already do, using whatever autolayout constraint DSL you prefer.
* Small - Small and readable Swift 4 codebase.
                       DESC

  s.homepage         = 'https://github.com/HotCocoaTouch/DeclarativeLayout'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'HotCocoaTouch' => 'srscottrobbins@gmail.com' }
  s.source           = { :git => 'https://github.com/hotcocoatouch/DeclarativeLayout.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  s.source_files = 'DeclarativeLayout/Classes/**/*'
  s.frameworks = 'UIKit'
end
