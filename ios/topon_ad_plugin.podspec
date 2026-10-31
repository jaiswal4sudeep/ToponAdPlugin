#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint topon_ad_plugin.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'topon_ad_plugin'
  s.version          = '0.0.14'
  s.summary          = 'A Flutter plugin for integrating TopOn Ads.'
  s.description      = <<-DESC
A Flutter plugin for integrating TopOn Ads using Method Channels. Supports interstitial, rewarded, banner, native, and splash ads.
                       DESC
  s.homepage         = 'https://github.com/jaiswal4sudeep/ToponAdPlugin'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Sudeep' => 'sudeep@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'AnyThinkiOS'
  s.platform = :ios, '13.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386',
    'OTHER_LDFLAGS' => '-ObjC'
  }
  s.static_framework = true
end
