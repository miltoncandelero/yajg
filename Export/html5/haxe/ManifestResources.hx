package;


import lime.utils.AssetLibrary;
import lime.utils.AssetManifest;
import lime.utils.Assets;

#if sys
import sys.FileSystem;
#end

@:access(lime.utils.Assets)


@:keep @:dox(hide) class ManifestResources {


	public static var preloadLibraries:Array<AssetLibrary>;
	public static var preloadLibraryNames:Array<String>;
	public static var rootPath:String;


	public static function init (config:Dynamic):Void {

		preloadLibraries = new Array ();
		preloadLibraryNames = new Array ();

		rootPath = null;

		if (config != null && Reflect.hasField (config, "rootPath")) {

			rootPath = Reflect.field (config, "rootPath");

		}

		if (rootPath == null) {

			#if (ios || tvos || emscripten)
			rootPath = "assets/";
			#elseif console
			rootPath = lime.system.System.applicationDirectory;
			#elseif (sys && windows && !cs)
			rootPath = FileSystem.absolutePath (haxe.io.Path.directory (#if (haxe_ver >= 3.3) Sys.programPath () #else Sys.executablePath () #end)) + "/";
			#else
			rootPath = "";
			#end

		}

		Assets.defaultRootPath = rootPath;

		#if (openfl && !flash && !display)
		openfl.text.Font.registerFont (__ASSET__OPENFL__assets_04_ttf);
		
		#end

		var data, manifest, library;

		#if kha

		null
		library = AssetLibrary.fromManifest (manifest);
		Assets.registerLibrary ("null", library);

		if (library != null) preloadLibraries.push (library);
		else preloadLibraryNames.push ("null");

		#else

		data = '{"name":null,"assets":"aoy4:sizei19492y4:typey4:FONTy9:classNamey22:__ASSET__assets_04_ttfy2:idy15:assets%2F04.TTFy7:preloadtgoy4:pathy17:assets%2Fdemo.pngR0i1114351R1y5:IMAGER5R9R7tgoR8y17:assets%2Flogo.jpgR0i83261R1R10R5R11R7tgh","rootPath":null,"version":2,"libraryArgs":[],"libraryType":null}';
		manifest = AssetManifest.parse (data, rootPath);
		library = AssetLibrary.fromManifest (manifest);
		Assets.registerLibrary ("default", library);
		

		library = Assets.getLibrary ("default");
		if (library != null) preloadLibraries.push (library);
		else preloadLibraryNames.push ("default");
		

		#end

	}


}


#if kha

null

#else

#if !display
#if flash

@:keep @:bind #if display private #end class __ASSET__assets_04_ttf extends null { }
@:keep @:bind #if display private #end class __ASSET__assets_demo_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_logo_jpg extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__manifest_default_json extends null { }


#elseif (desktop || cpp)

@:keep @:font("Export/html5/obj/webfont/04.TTF") #if display private #end class __ASSET__assets_04_ttf extends lime.text.Font {}
@:keep @:image("Assets/demo.png") #if display private #end class __ASSET__assets_demo_png extends lime.graphics.Image {}
@:keep @:image("Assets/logo.jpg") #if display private #end class __ASSET__assets_logo_jpg extends lime.graphics.Image {}
@:keep @:file("") #if display private #end class __ASSET__manifest_default_json extends haxe.io.Bytes {}



#else

@:keep @:expose('__ASSET__assets_04_ttf') #if display private #end class __ASSET__assets_04_ttf extends lime.text.Font { public function new () { #if !html5 __fontPath = "assets/04"; #else ascender = 750; descender = -250; height = 1000; numGlyphs = 99; underlinePosition = -143; underlineThickness = 20; unitsPerEM = 1000; #end name = "04b03"; super (); }}


#end

#if (openfl && !flash)

#if html5
@:keep @:expose('__ASSET__OPENFL__assets_04_ttf') #if display private #end class __ASSET__OPENFL__assets_04_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__assets_04_ttf ()); super (); }}

#else
@:keep @:expose('__ASSET__OPENFL__assets_04_ttf') #if display private #end class __ASSET__OPENFL__assets_04_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__assets_04_ttf ()); super (); }}

#end

#end
#end

#end
