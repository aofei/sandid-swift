Pod::Spec.new do |s|
  s.name     = 'SandID'
  s.version  = '1.0.0'
  s.license  = { :type => 'Unlicense', :file => 'LICENSE' }
  s.homepage = 'https://github.com/aofei/sandid-swift'
  s.author   = { 'Aofei Sheng' => 'aofei@aofeisheng.com' }
  s.summary  = 'Every grain of sand on earth has its own ID.'
  s.source   = { :git => 'https://github.com/aofeisheng/sandid-swift.git', :tag => 'v' + s.version.to_s }

  s.ios.deployment_target = '8.0'
  s.watchos.deployment_target = '2.0'
  s.tvos.deployment_target = '9.0'
  s.osx.deployment_target = '10.6'

  s.source_files = 'SandID/**/*'
  s.swift_version = '4.0'
end
