#
# Be sure to run `pod lib lint lame.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'lame'
  s.version          = '1.2.0'
  s.summary          = 'Lame 3.100'

  s.description      = <<-DESC
  LAME is a high quality MPEG Audio Layer III (MP3) encoder licensed under the LGPL.
                       DESC

  s.homepage         = 'https://github.com/pro100andrey/lame'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Andrey Ivanov' => 'this.andrey@gmail.com' }
  s.source           = { :git => 'https://github.com/pro100andrey/lame.git', :tag => s.version.to_s }

  s.ios.deployment_target = '12.0'
  s.tvos.deployment_target = '12.0'
  s.osx.deployment_target = '10.14'
  

  s.vendored_frameworks = 'lame.xcframework'
  s.resource_bundles = { 'apple_privacy' => ['PrivacyInfo.xcprivacy'] }

end
