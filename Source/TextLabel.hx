package;

import openfl.text.TextField;
import openfl.text.TextFieldType;
import openfl.text.TextFieldAutoSize;

class TextLabel extends TextField {
	public function new(mline:Bool = false, asize:Bool = true) {
		super();
		selectable = false;
		type = TextFieldType.DYNAMIC;
		multiline = mline;
		autoSize = asize ? TextFieldAutoSize.LEFT : TextFieldAutoSize.NONE;
		wordWrap = true;
		__removeAllListeners();
	}
}
