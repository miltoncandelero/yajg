package;

import lime.ui.FileDialog;
import openfl.display.PNGEncoderOptions;
import openfl.utils.ByteArray;
import openfl.utils.Assets;
import openfl.net.FileFilter;
import openfl.events.MouseEvent;
import openfl.net.FileReference;
import openfl.display.JPEGEncoderOptions;
import openfl.display.BitmapData;
import openfl.events.Event;
import openfl.text.TextFormatAlign;
import openfl.text.TextFormat;
import openfl.text.TextFieldType;
import openfl.text.TextField;
import openfl.display.Bitmap;
import openfl.display.Sprite;

class Glitcher extends Sprite {
	static inline var RESULT_MAX_WIDHT:Float = 400;
	static inline var RESULT_MAX_HEIGHT:Float = 300;

	var resultShow:Bitmap = new Bitmap();
	var originalBitmap:BitmapData = Assets.getBitmapData("assets/demo.png");
	var btnOpen:Sprite = new Sprite();
	var lblOpen:TextLabel = new TextLabel(false, false);
	var btnDownload:Sprite = new Sprite();
	var lblDownload:TextLabel = new TextLabel(false, false);
	var lblTimes:TextLabel = new TextLabel(false, false);
	var lblSeed:TextLabel = new TextLabel(false, false);
	var boxTimes:TextField = new TextField();
	var boxSeed:TextField = new TextField();
	var lblTitle:TextLabel = new TextLabel(true, true);
	var format:TextFormat = new TextFormat("04b03", 24, 0, "", "", TextFormatAlign.CENTER);
	var format16:TextFormat = new TextFormat("04b03", 16, 0, "", "", TextFormatAlign.LEFT);
	var opening:Bool = false;
	var fr:FileReference = new FileReference();
	var ui:Sprite = new Sprite();

	public function new() {
		super();
		btnOpen.graphics.lineStyle(2, 0);
		btnOpen.graphics.drawRect(0, 0, 170, 30);
		lblOpen.width = 170;
		lblOpen.height = 24;
		lblOpen.y = 3;
		lblOpen.defaultTextFormat = format;
		lblOpen.text = "OPEN IMAGE";
		btnOpen.addChild(lblOpen);
		btnOpen.addEventListener(MouseEvent.CLICK, open_click);
		ui.addChild(btnOpen);

		lblTimes.y = 45;
		lblTimes.width = 170;
		lblTimes.height = 24;
		lblTimes.defaultTextFormat = format;
		lblTimes.text = "Glitch Level";
		ui.addChild(lblTimes);
		boxTimes.y = 75;
		boxTimes.width = 170;
		boxTimes.height = 24;
		boxTimes.defaultTextFormat = format;
		boxTimes.text = "20";
		boxTimes.maxChars = 9;
		boxTimes.restrict = "0-9";
		boxTimes.type = TextFieldType.INPUT;
		boxTimes.border = true;
		boxTimes.addEventListener(Event.CHANGE, process);
		ui.addChild(boxTimes);

		lblSeed.y = 105;
		lblSeed.width = 170;
		lblSeed.height = 24;
		lblSeed.defaultTextFormat = format;
		lblSeed.text = "Random Seed";
		ui.addChild(lblSeed);
		boxSeed.y = 135;
		boxSeed.width = 170;
		boxSeed.height = 24;
		boxSeed.defaultTextFormat = format;
		boxSeed.text = Std.random(999999999);
		boxSeed.type = TextFieldType.INPUT;
		boxSeed.border = true;
		boxSeed.maxChars = 9;
		boxSeed.restrict = "0-9";
		boxSeed.addEventListener(Event.CHANGE, process);
		ui.addChild(boxSeed);

		btnDownload.y = 180;
		btnDownload.graphics.lineStyle(2, 0);
		btnDownload.graphics.drawRect(0, 0, 170, 30);
		lblDownload.width = 170;
		lblDownload.height = 24;
		lblDownload.y = 3;
		lblDownload.defaultTextFormat = format;
		lblDownload.text = "SAVE GLITCH";
		btnDownload.addChild(lblDownload);
		btnDownload.addEventListener(MouseEvent.CLICK, download_click);
		ui.addChild(btnDownload);

		ui.x = 10;
		ui.y = RESULT_MAX_HEIGHT - 220;
		ui.graphics.lineStyle(2, 0);
		ui.graphics.drawRect(-5, -5, 180, 220);
		addChild(ui);

		lblTitle.y = 3;
		lblTitle.x = 10;
		lblTitle.defaultTextFormat = format16;
		lblTitle.text = "Yet\nAnother\nJpg\nGlitcher";
		addChild(lblTitle);

		makeLogo();

		resultShow.x = 200;
		addChild(resultShow);

		fr.addEventListener(Event.SELECT, startLoad);
		fr.addEventListener(Event.COMPLETE, loadComplete);

		graphics.beginFill(0, 0);
		graphics.drawRect(0, 0, resultShow.x + RESULT_MAX_WIDHT, RESULT_MAX_HEIGHT);
		process();
	}

	function open_click(_) {
		fr.browse([new FileFilter("", "image/*", "")]);
	}

	function download_click(_) {
		var b:ByteArray = new ByteArray();
		b = resultShow.bitmapData.encode(resultShow.bitmapData.rect, new PNGEncoderOptions(true), b);
		new FileDialog().save(b, "png", "glitch.png", null, "image/*");
	}

	function startLoad(_) {
		if (opening)
			return;
		opening = true;
		fr.load();
	}

	function loadComplete(_) {
		opening = false;
		BitmapData.loadFromBytes(fr.data).onComplete(function(bdata) {
			originalBitmap = bdata;
			process();
		});
	}

	function process(_ = null) {
		var seed:Int = (Std.parseInt(boxSeed.text));
		var times:Int = (Std.parseInt(boxTimes.text));

		if (seed == null)
			seed = 0;
		if (times == null)
			times = 0;

		var data = originalBitmap.encode(originalBitmap.rect, new JPEGEncoderOptions(100));
		var byte:Int;
		var _headerSize = 417;
		data.position = 0;

		while (data.bytesAvailable != 0) {
			byte = data.readUnsignedByte();

			if (byte == 0xFF) {
				byte = data.readUnsignedByte();

				if (byte == 0xDA) {
					_headerSize = (data.position + data.readShort());
					break;
				}

				data.position = data.position - 1;
			}
		}
		trace(_headerSize);
		var length:Int = Std.int(data.length - _headerSize - 2);
		var random = new PCG32();
		random.seed(seed);
		for (i in 0...times) {
			data.position = _headerSize + random.random(length);
			data.writeByte(0);
		}

		BitmapData.loadFromBytes(data).onComplete(function(jpg) {
			resultShow.bitmapData = jpg;
			fixBitmapSize();
		});
	}

	function makeLogo() {
		var seed:Int = (Std.parseInt(boxSeed.text));
		var times:Int = (Std.parseInt(boxTimes.text));

		if (seed == null)
			seed = 0;
		if (times == null)
			times = 0;

		var data = Assets.getBitmapData("assets/logo.jpg").encode(Assets.getBitmapData("assets/logo.jpg").rect, new JPEGEncoderOptions(100));
		var byte:Int;
		var _headerSize = 417;
		data.position = 0;

		while (data.bytesAvailable != 0) {
			byte = data.readUnsignedByte();

			if (byte == 0xFF) {
				byte = data.readUnsignedByte();

				if (byte == 0xDA) {
					_headerSize = (data.position + data.readShort());
					break;
				}

				data.position = data.position - 1;
			}
		}
		trace(_headerSize);
		var length:Int = Std.int(data.length - _headerSize - 2);
		var random = new PCG32();
		random.seed(seed);
		for (i in 0...times) {
			data.position = _headerSize + random.random(length);
			data.writeByte(0);
		}

		BitmapData.loadFromBytes(data).onComplete(function(jpg) {
			var logo:Bitmap = new Bitmap(jpg);
			logo.scaleX = logo.scaleY = 0.3;
			logo.y = 1.5;
			logo.x = 90;
			addChild(logo);
		});
	}

	function fixBitmapSize() {
		resultShow.scaleX = resultShow.scaleY = 1;
		resultShow.scaleX = resultShow.scaleY = Math.min(RESULT_MAX_WIDHT / resultShow.width, RESULT_MAX_HEIGHT / resultShow.height);
	}

	public function resize() {
		scaleX = scaleY = 1;
		scaleX = scaleY = Math.min(stage.stageWidth / width, stage.stageHeight / height);
	}
}
