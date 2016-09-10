Pod::Spec.new do |s|

# 1
s.platform = :ios
s.ios.deployment_target = '9.0'
s.name         = "Vuukle"
s.summary      = "A short description of Vuukle."

# 2
s.version      = "1.2.0"

# 3
s.license      = { :type => "MIT", :file => "LICENSE" }

# 4
s.author       = { "Vuukle.com" => "fedir@vuukle.com" }

# 5
s.homepage     = "https://github.com/Demkovskyi/VuukleComment"

# 6
s.source       = { :git => "https://github.com/Demkovskyi/VuukleComment.git", :tag => "#{s.version}"}

# 7
s.framework    = "UIKit"
s.framework    = "Social"
s.dependency 'Alamofire', '~> 3.4'
s.dependency 'AlamofireImage', '~> 2.0'

# 8
s.source_files  = "Vuukle/**/*.{swift}"

# 9
s.resources     = "Vuukle/**/*.{png,jpeg,jpg,html,storyboard,xib}"

end