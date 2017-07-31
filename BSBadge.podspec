#
#  Be sure to run `pod spec lint BSBadge.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "BSBadge"
  s.version      = "1.1"
  s.summary      = "'BSBadge' is a can drag red-bubble control."
  s.description  = <<-DESC
                   DESC

  s.homepage     = "https://github.com/hssdx/BSBadgeDemo"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"

  # s.license      = "MIT (example)"
  s.license      = { :type => "MIT", :file => "FILE_LICENSE" }

  s.author             = { "hssdx" => "hssdx@qq.com" }
  # Or just: s.author    = "hssdx"
  # s.authors            = { "hssdx" => "hssdx@qq.com" }
  # s.social_media_url   = "http://twitter.com/xiongxunquan"

  # s.platform     = :ios
  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/hssdx/BSBadgeDemo.git", :tag => "#{s.version}" }

  s.source_files  = "BSBadge.h", "BSBadge/*.{h,m}"
  # s.exclude_files = "Classes/Exclude"

  s.public_header_files = "BSBadge.h", "BSBadge/*.h"

  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"

  s.framework  = "UIKit"
  # s.frameworks = "UIKit", "AnotherFramework"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

end
