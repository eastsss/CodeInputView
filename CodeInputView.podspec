Pod::Spec.new do |s|
  s.name             = 'CodeInputView'
  s.version          = '0.2.0'
  s.summary          = 'Simple control for entering codes like the ones used to verify phone numbers'
  s.homepage         = 'https://github.com/eastsss/CodeInputView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'eastsss' => 'anatox91@yandex.ru' }
  s.source           = { :git => 'https://github.com/eastsss/CodeInputView.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.framework = "UIKit"
  s.source_files = "CodeInputView/CodeInputView.swift"
end
