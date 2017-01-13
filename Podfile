source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

target “KWDropdownMenu” do
    pod 'SnapKit', '~> 0.22.0'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
           config.build_settings['SWIFT_VERSION'] = '2.3' # or '3.0'
     end
    end
end
