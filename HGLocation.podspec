Pod::Spec.new do |s|
  s.name             = 'HGLocation'
  s.version          = '0.0.1'
  s.summary          = 'A short description of HGLocation.'
  s.homepage         = 'https://github.com/MartinChristopher/HGLocation'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.authors          = { "MartinChristopher" => "519483040@qq.com" }
  s.source           = { :git => 'https://github.com/MartinChristopher/HGLocation.git', :tag => s.version.to_s }
  
  s.requires_arc = true
  s.swift_version = '5.0'
  s.ios.deployment_target = '11.0'
  
  s.source_files = 'Sources/**/*.{swift}'
  # s.resources = "Sources/**/*.{bundle,strings,xcassets}"
  # s.vendored_frameworks = [
  #   'Sources/xx/xx.xcframework'
  # ]
  
  # s.dependency "RxSwift"
  # s.dependency "RxCocoa"
  # s.dependency "NSObject+Rx"
end
