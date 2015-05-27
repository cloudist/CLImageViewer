#CLImageViewer.podspec
Pod::Spec.new do |s|
  s.name         = "CLImageViewer"
  s.version      = "1.0.1"
  s.summary      = "A light weight, easy to use and cool image viewer for iOS."

  s.homepage     = "https://github.com/Cloudist/CLImageViewer"
  s.license      = 'MIT'
  s.author       = { "esrever10" => "caochen@cloudist.cc" }
  s.platform     = :ios, "7.0"
  s.ios.deployment_target = "7.0"
  s.source       = { :git => "https://github.com/Cloudist/CLImageViewer.git", :tag => "1.0.1"}
  s.source_files  = 'CLImageViewer/*.{m,h}'
  s.requires_arc = true
  s.dependency 'SDWebImage', '~> 3.7.2'
end

