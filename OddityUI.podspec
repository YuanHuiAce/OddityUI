Pod::Spec.new do |s|
  s.name = 'OddityUI'
  s.summary          = "奇点资讯 数据获取方式信息 [- OddityModal -]"
  s.homepage         = "https://github.com/melvitax/AFDateHelper"
  s.author           = { "WenZheng Jing" => "200739491@qq.com" }
  s.ios.deployment_target = '8.0'
  s.version = '1.0.0'
  s.source = { :git => 'https://github.com/AimobierCocoaPods/OddityModal.git', :tag => s.version }
  s.license = 'MIT'
  s.source_files = 'Classes/**/*.swift'


  s.resource_bundles = { "OdditBundle" => "Classes/**/*.{xcassets,storyboard,html,js,css}" }

  s.dependency 'JMGTemplateEngine'
  s.dependency 'PINRemoteImage'
  s.dependency 'MJRefresh'
  s.dependency 'OddityModal'
  s.dependency 'SnapKit'
  s.dependency 'XLPagerTabStrip'
end
