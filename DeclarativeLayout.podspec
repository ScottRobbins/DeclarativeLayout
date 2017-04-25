Pod::Spec.new do |s|
  s.name             = 'DeclarativeLayout'
  s.version          = '0.1.0'
  s.summary          = 'A short description of DeclarativeLayout.'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/HotCocoaTouch/DeclarativeLayout'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'HotCocoaTouch' => 'srscottrobbins@gmail.com' }
  s.source           = { :git => 'https://github.com/hotcocoatouch/DeclarativeLayout.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  s.source_files = 'DeclarativeLayout/Classes/**/*'
  s.frameworks = 'UIKit'
end
