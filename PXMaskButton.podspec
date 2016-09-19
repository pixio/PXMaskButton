Pod::Spec.new do |s|
  s.name             = "PXMaskButton"
  s.version          = "0.2.0"
  s.summary          = "A button with an image and a title that are masked to allow transparency."
  s.description      = <<-DESC
                       When the button is selected/pressed, you can see through the text/icon which is cut out of a color (or gradient). In the default state the button has an outline and a draws the image and title in color (or gradient).
                       DESC
  s.homepage         = "https://github.com/pixio/PXMaskButton"
  s.license          = 'MIT'
  s.author           = { "Daniel Blakemore" => "DanBlakemore@gmail.com" }
  s.source = {
   :git => "https://github.com/pixio/PXMaskButton.git",
   :tag => s.version.to_s
  }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'QuartzCore'
  s.dependency 'UIImageUtilities'
end
