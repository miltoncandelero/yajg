package;

import openfl.display.JPEGEncoderOptions;
import openfl.events.Event;
import openfl.net.FileReference;
import openfl.events.MouseEvent;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.Assets;

class Main extends Sprite {
	var glitcher:Glitcher = new Glitcher();

	public function new() {
		super();

		addChild(glitcher);
		stage.addEventListener(Event.RESIZE, onResize);
	}

	public function onResize(_) {
		glitcher.resize();
	}
}
