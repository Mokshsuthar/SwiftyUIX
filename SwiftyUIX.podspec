Pod::Spec.new do |spec|
  spec.name         = "SwiftyUIX"
  spec.version      = "1.2.3"
  spec.summary      = "SwiftyUIX is a library providing useful extensions and custom views to simplify iOS development."
  spec.description  = <<-DESC
    SwiftyUIX is a comprehensive library offering practical extensions and custom views for streamlined development on iOS and macOS.
  DESC
  spec.homepage     = "https://github.com/Mokshsuthar/SwiftyUIX"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "Moksh" => "suthermukesh@gmail.com" }
  spec.social_media_url = "https://www.linkedin.com/in/moksh-suthar-5253841b5/"
  spec.ios.deployment_target = "13.0"
  spec.osx.deployment_target = "12.0"
  spec.swift_version = "4.2"
  spec.source       = { :git => "https://github.com/Mokshsuthar/SwiftyUIX.git", :tag => "#{spec.version}" }
  spec.source_files = "SwiftyUIX/**/*.swift"
end
