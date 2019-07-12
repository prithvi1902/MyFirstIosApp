# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

target 'MyFirstApp' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  plugin 'cocoapods-keys', {
    :project => "MyFirstApp",
    :target => "MyFirstApp",
    :keys => [
    "MarvelApiKey",
    "MarvelPrivateKey"
    ]}
pod 'SteviaLayout'
pod 'SwiftLint'
pod 'Kingfisher'
pod 'CryptoSwift'
pod 'ws'
  # Pods for MyFirstApp

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '4.2'
    end
  end
end
