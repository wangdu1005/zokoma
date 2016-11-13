# Uncomment this line to define a global platform for your project
# platform :ios, '8.0'
# Uncomment this line if you're using Swift
use_frameworks!

target 'Zokoma' do
    pod 'Firebase'
    pod 'Firebase/Core'
    pod 'Firebase/Database'
    pod 'Firebase/Storage'
    pod 'ParseFacebookUtilsV4'
    pod 'Parse'
    pod 'GoogleTagManager', '~> 5.0'
    pod 'Google/Analytics'
    post_install do |installer|
        `find Pods -regex 'Pods/Parse.*\\.h' -print0 | xargs -0 sed -i '' 's/\\(<\\)Parse\\/\\(.*\\)\\(>\\)/\\"\\2\\"/'`
    end

end

target 'ZokomaTests' do

end

target 'ZokomaUITests' do

end



