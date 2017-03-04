Pod::Spec.new do |s|

# 1
s.platform = :ios
s.ios.deployment_target = '9.0'
s.name      = "Vuukle"
s.summary   = "Vuukle.com"

# 2
s.version = "2.0.5"

# 3
s.license = { :type => "MIT", :file => "LICENSE" }

# 4
s.author = { "Vuukle.com" => "fedir@vuukle.com" }

# 5
s.homepage = "https://github.com/vuukle/vuukle_iOS_SDK.git"

# 6
s.source = { :git => "https://github.com/vuukle/vuukle_iOS_SDK.git", :tag => "#{s.version}" }

# 7
s.ios.frameworks = 'UIKit', 'Foundation'
s.dependency 'Alamofire', '>= 4.3.0'
s.dependency 'AlamofireImage', '>= 3.2.0'
s.dependency 'MBProgressHUD', '>= 1.0.0'
s.dependency 'NSDate+TimeAgo', '>= 1.0.6'

# 8
s.source_files  = "Vuukle/**/*.{h}"

# 9
s.resources = "Vuukle/**/*.{framework,html}"

end
