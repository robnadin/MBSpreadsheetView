Pod::Spec.new do |s|
  s.name         = "MBSpreadsheetView"
  s.version      = "0.0.5"
  s.summary      = "A light weight, easy-to-use spreadsheet-like view."
  s.homepage     = "https://github.com/robnadin/MBSpreadsheetView"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Jeff Lacey" => "jeff.lacey@mutualmobile.com", "Rob Nadin" => "robnadin@gmail.com" }
  s.source       = { :git => "https://github.com/robnadin/MBSpreadsheetView.git", :tag => "#{s.version}" }
  s.platform     = :ios, '6.0'
  s.requires_arc = true
  s.source_files = 'MMSpreadsheetView/*.{h,m}', 'MBSpreadsheetView/*.{h,m}'
  s.framework    = 'QuartzCore'
end
