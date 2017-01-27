Pod::Spec.new do |s|

# 1
s.platform = :ios
s.ios.deployment_target = '9.0'
s.name         = "Vuukle"
s.summary      = "Vuukle.com"

# 2
s.version      = "1.0.36"

# 3
s.license      = { :type => "MIT", :file => "LICENSE" }

# 4
s.author       = { "Vuukle.com" => "fedir@vuukle.com" }

# 5
s.homepage     = "https://github.com/vuukle/vuukle_iOS_SDK"

# 6
s.source       = { :git => "https://github.com/vuukle/vuukle_iOS_SDK", :tag => "#{s.version}" }

# 7
s.framework    = "UIKit"
s.dependency 'Alamofire'
s.dependency 'AlamofireImage'

# 8
s.source_files  = "Vuukle/**/*.{swift}"

# 9
s.resources     = "Vuukle/**/*.{png,jpeg,jpg,html,storyboard,xib}"

end
