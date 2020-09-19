# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'
use_frameworks!
inhibit_all_warnings!

def app_pods
  # Architect
  pod 'MVVM-Swift'
  # Tool to enforce Swift style and conventions
  pod 'SwiftLint'
  # UI
  pod 'SVProgressHUD'
  # Utils
  pod 'SwifterSwift'
  pod 'IQKeyboardManagerSwift'
  # Data
  pod 'ObjectMapper'
  pod 'RealmSwift', '5.3.0'
  # Network
  pod 'Alamofire', '4.9.1'
end

target 'Youtube' do
  use_frameworks!
  app_pods

  target 'YoutubeTests' do
    inherit! :search_paths
  end
end

# Check pods for support swift version
post_install do |installer|
    installer.pods_project.targets.each do |target|
        if ['Alamofire', 'ObjectMapper'].include? "#{target}"
            # Setting #{target}'s SWIFT_VERSION to 4.2\n
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '4.2'
            end
            else
            # Setting #{target}'s SWIFT_VERSION to default is 5.0
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '5.0'
            end
        end
    end
end
