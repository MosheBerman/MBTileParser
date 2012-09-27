**Look Ma, a game engine! Running on UIKit!**

MBTileParser began as a small library that allows you to parse TMX files and then display them  using pure UIKit. (You don't need to learn OpenGL and you don't have to use a game engine. ) Now, MBTileParser is more of a game engine, in that it supports loading TMX files, cocos2d spritesheets created with TexturePacker, and more.   

**What it can do:**

MBTileParser can do four things right now. Load maps, load sprites, display dialog, and take input via virtual controls.

 - **Load maps:** MBTileParser is actually the name of a class in the engine. You can load TMX files. Use the `MBMapViewController` class for this.
 - **Load sprites:** You can load sprites using `MBSpriteView`. `MBMovableSpriteView` supports movement too.
 - **Display Dialog:** Load and parse dialog trees, using `MBDialogTree`. (Support for actions is unimplemented, but basic display of text works.)
 - **Take Input:** Create custom virtual game controls, using the `MBJoystick` and `MBControllerButton` classes. You can also use the included layout.

**Technical Requirements:**

MBTileParser requires Xcode 4.5 because it uses a new feature called subscripting. You can [hack it](http://petersteinberger.com/blog/2012/using-subscripting-with-Xcode-4_4-and-iOS-4_3) to run in Xcode 4.4, but I'm not supporting this. The hack will be unnessecary in the near future anyway. Seriously, upgrade Xcode to the latest version.

**A word on the TMX format, Tiled, and TexturePacker:**

The TMX file format is used by Tiled, a tool which helps you make world maps for games. (You can download Tiled [here](http://mapeditor.org)). The TMX format is explained in detail on the [tiled GitHub repository wiki](https://github.com/bjorn/tiled/wiki/TMX-Map-Format). The developer of TexturePacker, Andreas Löw, was kind enough to give me a license a while back. Thanks Andreas! You can [get TexturePacker from his website](http://www.codeandweb.com/texturepacker).

**License:**

The artwork is copyrighted by [Allan Simpson](http://www.allansimpson.com). He has created it for a project we are working on. You may not use it for anything except to play with the game engine on your own machine(s). Sorry, it's not mine to let you give out.  
You may use the code in `MBTileParser` in games distributed/sold on the App Store. Otherwise, you may not resell the engine itself, either alone or as part of a larger library. Attribution somewhere in final products is required. Be nice. 


Have fun, because game engines are.
