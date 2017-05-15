Pod::Spec.new do |s|

  s.name          = "AliCloudFeedback"
  s.version       = "3.0.1"
  s.summary       = "阿里云意见反馈基础版Framework."
  s.description   = "阿里云意见反馈基础版Framework. YWFeedbackFMWK"
  s.license       = { :type => 'Copyright', :text => "Alibaba-INC copyright" }
  s.author        = { "ElonChan" => "elonchan.cyl@alibaba-inc.com" }
  s.homepage      = "https://www.aliyun.com"
  s.source       = { :http => "framework_url" }
  s.ios.deployment_target = '7.0'
  s.requires_arc  = true
  s.frameworks = [
  "CoreTelephony", "SystemConfiguration", "CoreMotion"
  ]
  s.library = "z"

  s.vendored_frameworks = ["feedback/YWFeedbackFMWK.framework", "feedback/UTMini.framework", "feedback/YWFeedbackBundle.bundle", "feedback/BCConnectorBundle.framework", "feedback/BCConnectorBundle.framework", "feedback/BCHybridWebViewFMWK.framework"]

  s.dependency "AlicloudUtils"

end
