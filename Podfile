# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

target 'idtp' do
    # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
    use_frameworks!
    
    # Pods for idtp
    
    # Comment this line if you're not using Swift and don't want to use dynamic frameworks
    use_frameworks!
    
    # Pods for idtp
    # pod 'MapsAPI'
    pod 'YandexMapKit'
    pod 'Firebase/Core'
    pod 'Firebase/Messaging'
    #pod 'GoogleMaps'
    #pod 'GooglePlaces'
    pod 'SVProgressHUD'
    #pod "Keychain"
    pod 'SwiftyJSON'
    #pod 'SwiftyJSON', :git => 'https://github.com/acegreen/SwiftyJSON.git', :branch => 'swift3'
    pod 'SimpleImageViewer', :git => 'https://github.com/aFrogleap/SimpleImageViewer.git'
    
    
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
