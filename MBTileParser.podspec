Pod::Spec.new do |s|

  s.name         = "MBTileParser"
  s.version      = "1.0.0"
  s.summary      = "A UIKit based game engine for iOS."
  s.description  = <<-DESC
	Look Ma, a game engine! Running on UIKit! MBTileParser is a small game engine that supports loading TMX files and TexturePacker files directly into UIKit.
                   DESC
  s.homepage     = "https://github.com/MosheBerman/MBTileParser"
  s.screenshots  = "https://github.com/MosheBerman/MBTileParser/blob/master/screenshots/walking.png", "https://github.com/MosheBerman/MBTileParser/blob/master/screenshots/with-dialog.png"
  s.author       = { "Moshe Berman" => "moshberm@gmail.com" }
  s.license 	 = 'MIT'
  s.platform     = :ios, '6.0'
  s.source       = { :git => "https://github.com/MosheBerman/MBTileParser.git", :tag => "1.0.0"} 
  s.source_files  = 'Classes', 'TileParser/MBGameEngine/**/*.{h,m}'
  s.requires_arc = true
end
