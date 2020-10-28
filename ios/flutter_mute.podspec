#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_mute.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_mute'
  s.version          = '0.0.1'
  s.summary          = 'Detect device is muted or not.'
  s.homepage         = 'https://github.com/Alezhka/flutter_mute'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Aleksei Sturov' => 'alezhk@gmail.com' }
  s.source           = { :git => 'https://github.com/Alezhka/flutter_mute.git' }
  
  s.source_files = 'Classes/**/*'
  s.resources = 'Assets/*.aiff'
  s.dependency 'Flutter'
  s.platform = :ios, '10.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  s.frameworks = 'Foundation', 'AudioToolbox'
end
