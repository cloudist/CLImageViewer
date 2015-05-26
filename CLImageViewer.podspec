#CLImageViewer.podspec
Pod::Spec.new do |s|
  s.name         = "CLImageViewer"
  s.version      = "0.0.1"
  s.summary      = "a light weight and easy to use images viewer."

  s.homepage     = "https://github.com/esrever10/CLImageViewer"
  s.license      = 'MIT'
  s.author       = { "ello" => "caochen@cloudist.cc" }
  s.platform     = :ios, "7.0"
  s.ios.deployment_target = "7.0"
  s.source       = { :git => "https://github.com/esrever10/CLImageViewer", :tag => s.version}
  s.source_files  = 'CLImageViewer/CLImageViewer/*.{h,m}'
  s.requires_arc = true
end
