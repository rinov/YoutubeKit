Pod::Spec.new do |s|
  s.name             = 'YoutubeKit'
  s.version          = '0.1.2'
  s.summary          = 'YoutubeKit is a video player for easily create a Youtube app.'

  s.description      = <<-DESC
YoutubeKit is a video player that fully supports Youtube IFrame API and YoutubeDataAPI for easily create a Youtube app.
                       DESC

  s.homepage         = 'https://github.com/rinov/YoutubeKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'rinov' => 'rinov@rinov.jp' }
  s.source           = { :git => 'https://github.com/rinov/YoutubeKit.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/rinov0321'

  s.ios.deployment_target = '9.0'

  s.source_files = 'YoutubeKit/**/*'
  s.resources    = 'YoutubeKit/player.html'

 end
