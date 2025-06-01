Pod::Spec.new do |s|
  s.name             = 'YoutubeKit'
  s.version          = '0.11.0'
  s.summary          = 'YoutubeKit is a video player for easily create a Youtube app.'

  s.description      = <<-DESC
YoutubeKit is a video player that fully supports Youtube IFrame API and YoutubeDataAPI for easily create a Youtube app.
DESC

  s.homepage         = 'https://github.com/rinov/YoutubeKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'rinov' => 'rinov@rinov.jp' }
  s.social_media_url = 'https://twitter.com/rinov0321'
  s.swift_version = "6.0"
  s.ios.deployment_target = '13.0'

  s.source_files = 'YoutubeKit/**/*.swift'
  s.resources = 'YoutubeKit/Resources/*.*'
  s.resource_bundles = {"YoutubeKit" => ["YoutubeKit/PrivacyInfo.xcprivacy"]}
  s.source           = { :git => 'https://github.com/rinov/YoutubeKit.git', :tag => s.version.to_s }
 end
