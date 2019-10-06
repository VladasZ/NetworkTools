Pod::Spec.new do |s|
s.name           = 'NetworkTools'
s.version        = '0.5.21'
s.summary        = "Network tools kit to make your life easier."
s.homepage       = "https://github.com/VladasZ/NetworkTools"
s.author         = { 'Vladas Zakrevskis' => '146100@gmail.com' }
s.source         = { :git => 'https://github.com/VladasZ/NetworkTools.git', :tag => s.version }
s.ios.deployment_target = '9.0'
s.osx.deployment_target = '10.10'
s.tvos.deployment_target = '9.0'
s.watchos.deployment_target = '2.0'
s.source_files   = 'Sources/**/*.swift'
s.license        = 'MIT'
s.dependency 'SwiftyTools'

end
