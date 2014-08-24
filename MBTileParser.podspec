Pod::Spec.new do |s|

  s.name         = "MBTileParser"
  s.version      = "2.0.0"
  s.summary      = "A UIKit based game engine for iOS."
  s.description  = <<-DESC
	Look Ma, a game engine! Running on UIKit! MBTileParser is a small game engine that supports loading TMX files and TexturePacker files directly into UIKit.
                   DESC
  s.homepage     = "https://github.com/MosheBerman/MBTileParser"
  s.screenshots  = "https://raw.githubusercontent.com/MosheBerman/MBTileParser/master/screenshots/walking.png", "https://raw.githubusercontent.com/MosheBerman/MBTileParser/master/screenshots/with-dialog.png"
  s.author       = { "Moshe Berman" => "moshberm@gmail.com" }
  s.license 	 = 'MIT'
  s.platform     = :ios, '7.0'
  s.source       = { :git => "https://github.com/MosheBerman/MBTileParser.git", :tag => "2.0.0"} 
  s.source_files  = 'Classes', 'TileParser/MBGameEngine/**/*.{h,m}'
  s.requires_arc = true
end
