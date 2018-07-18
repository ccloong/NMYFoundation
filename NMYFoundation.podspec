Pod::Spec.new do |s|
  s.name             = 'NMYFoundation'
  s.version          = '0.1.0'
  s.summary          = 'Private pod of foundation components'

  s.description      = <<-DESC
The foundation components including networking(based on AFNetworking) module etc.(for now).
                       DESC

  s.homepage         = 'https://github.com/ccloong/NMYFoundation'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'mayue' => 'nathan.my@gmail.com' }
  s.source           = { :git => 'git@github.com:ccloong/NMYFoundation.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.subspec 'Networking' do |sp|
    sp.source_files = 'NMYFoundation/Classes/Networking/*.{h,m}'
    sp.dependency = 'AFNetworking'
    sp.dependency = 'YYModel'
  end

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
end
