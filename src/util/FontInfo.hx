package util;
import openfl.Assets;
import openfl.system.Capabilities;
import openfl.text.Font;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

/**
 * ...
 * @author jefvel
 */
class FontInfo
{
	private static var font:Font;

	private static var defaultTextFormat:TextFormat;
	private static var defaultFontSize:Int = 18;
	private static var fontsLoaded:Bool = false;
	
	public function new() 
	{
	}
	
	public static function loadFonts() {
		if (!fontsLoaded) {
			font = Assets.getFont("fonts/Archive.ttf");

			defaultTextFormat = createTextFormat(defaultFontSize, TextFormatAlign.LEFT);
			
			fontsLoaded = true;
		}
	}

	private static function createTextFormat(size, align) {
		var dpi = Capabilities.screenDPI;
		if (dpi > 300) {
			defaultFontSize *= 3;
		} else if (dpi > 200) {
			defaultFontSize *= 2;
		}
		
		var fontname = "Verdana";
		
		if (font != null) {
			fontname = font.fontName;
		}
		
		var textFormat = new TextFormat(fontname, size, 0x05001A);
		textFormat.align = align;
		textFormat.bold = false;

		return textFormat;
	}
	
	public static function getTextFormat() {
		if (!fontsLoaded) {
			loadFonts();
		}
		
		return defaultTextFormat;
	}

	public static function getCustomTextFormat(size:Int, align:TextFormatAlign) {
		if (!fontsLoaded) {
			loadFonts();
		}
		return createTextFormat(size, align);
	}
}