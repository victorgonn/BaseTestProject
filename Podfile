# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

def ui_pods
  pod 'AloeStackView'
  pod 'SnapKit', '~> 5.0.0'
end

def base_pods
  pod 'SwiftLint', '~> 0.35.0'
  pod 'Alamofire', '~> 5.0.0-rc.2'
  pod 'PromisesSwift'
  pod 'AlamofireNetworkActivityLogger', '~> 3.0'
  ui_pods
end

target 'BaseTestProject' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  base_pods

  target 'BaseTestProjectTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'BaseTestProjectUITests' do
    # Pods for testing
  end

end
