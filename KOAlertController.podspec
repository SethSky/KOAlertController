Pod::Spec.new do |s|
  s.name = 'KOAlertController'
  s.version = '1.0.3'
  s.license = 'MIT'
  s.summary = 'KOAlertController is an custom alert controller library written in Swift'
  s.homepage = 'https://github.com/SethSky/KOAlertController'
  s.authors = { 'Oleksandr Khymych' => 'seth@khymych.com' }
  s.source = { :git => 'https://github.com/SethSky/KOAlertController.git', :tag => s.version }
  spec.swift_version = '5.0'

  s.ios.deployment_target = '9.0'

  s.source_files = 'Source/*.swift'
end
