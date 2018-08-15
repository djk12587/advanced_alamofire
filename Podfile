source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '11.2'
inhibit_all_warnings!
use_frameworks!

target :advanced_alamofire do
	pod 'OHHTTPStubs/Swift', '6.1.0'
  pod 'Alamofire', '4.6.0'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '4.0'
        end
    end
end
