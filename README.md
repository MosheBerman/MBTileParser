**Look Ma, no low-level code!**

MBTileParser began as a small library that allows you to parse TMX files and then display them  using pure UIKit. (You don't need to learn OpenGL and you don't have to use a game engine. ) Now, MBTileParser is more of a game engine, in that it supports loading TMX files, cocos2d spritesheets created with TexturePacker, and more. 

**Some Miscellaneous Details**

 - Loaded sprites can be displayed onscreen.
 - Movable sprites support movement with completion blocks.  
 - A delegate protocol allows sprites to check if they're allowed to move to a given location.
 - Completion blocks fire even if movement fails. 
 - Extensible controls allow for things like movement of characters onscreen
 
**A word on the TMX format**

The TMX file format is used by Tiled, a tool which helps you make world maps for games. (You can download Tiled [here](http://mapeditor.org)). The TMX format is explained in detail on the [tiled GitHub repository wiki](https://github.com/bjorn/tiled/wiki/TMX-Map-Format).

**License**

You may use MBTileParser in games distributed/sold on the App Store. Otherwise, you may not resell the engine itself, either alone or as part of a larger library. Attribution somewhere in final products is required. Be nice.

Have fun, because game engines are.
