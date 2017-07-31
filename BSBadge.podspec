Pod::Spec.new do |s|
  s.name         = "BSBadge"
  s.version      = "1.1"
  s.summary      = "A can drag red-bubble control."
  s.description  = <<-DESC
                      BSBadge is a can drag red-bubble control.
                   DESC

  s.homepage     = "https://github.com/hssdx/BSBadgeDemo"
  s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author       = { "hssdx" => "hssdx@qq.com" }
  s.platform     = :ios, '8.0'
  s.source       = { :git => "https://github.com/hssdx/BSBadgeDemo.git", :tag => s.version }

  s.source_files = 'BSBadge.h','BSBadge/*.{h,m,c}', 'BSBadge/**/*.{h,m,c}', 'BSBadge/**/**/*.{h,m,c}'
  s.public_header_files = 'BSBadge.h','BSBadge/*.{h}',  'BSBadge/**/*.h'

  s.framework  = "UIKit"
  # s.frameworks = 'c', 'c++', "UIKit", "AnotherFramework"

  s.library   = "c++"
  s.libraries = "iconv", "xml2"

  # s.public_header_files = "BSBadge.h", "BSBadge/*.h"

  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"


  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

end
