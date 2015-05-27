#CLImageViewer.podspec
Pod::Spec.new do |s|
  s.name         = "CLImageViewer"
  s.version      = "1.0.0"
  s.summary      = "A light weight, easy to use and cool image viewer for iOS."

  s.homepage     = "https://github.com/Cloudist/CLImageViewer"
  s.license      = 'MIT'
  s.author       = { "esrever10" => "caochen@cloudist.cc" }
  s.platform     = :ios, "7.0"
  s.ios.deployment_target = "7.0"
  s.source       = { :git => "https://github.com/Cloudist/CLImageViewer.git", :tag => "1.0.0"}
  s.source_files  = 'CLImageViewer/*.{m,h},CLImageViewer/SDWebImage/*.{m,h}'
  s.requires_arc = true
  s.framework = 'ImageIO', 'UIKit'
end

