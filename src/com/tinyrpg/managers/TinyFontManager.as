﻿package com.tinyrpg.managers {	import com.tinyrpg.utils.TinyLogManager;	import flash.display.DisplayObjectContainer;	import flash.text.AntiAliasType;	import flash.text.StyleSheet;	import flash.text.TextField;	/**	 * @author cwise	 */	public class TinyFontManager {		public static var styleSheet : StyleSheet;		public static function initWithCSS(css : String) : void {			styleSheet = new StyleSheet();			styleSheet.parseCSS(css);		}		/**		 * returns a string formatted for use as htmlText.		 * @param text (String) - the text you want to format.		 * @param styleClass (String) the name of the stylesheet class to use for formatting.		 * @param align (String) html text alignment - valid values are 'left' (default), 'right' or 'center'		 * @param inline (Boolean) whether or not to use inline formatting with a span tag instead of a paragraph tag (default)		 */		public static function returnHtmlText(text : String, styleClass : String, align : String = "left", inline : Boolean = false) : String {			if(inline) {				return String('<span class="' + styleClass + '">' + text + '</span>');			} else {				return String('<p align="' + align + '" class="' + styleClass + '">' + text + '</p>');			}		}		/**		 * sets the htmlText property of a given TextField and truncates to make the text field 		 * either fit within a desired width or a desired number of lines. 		 * if maxLines is specified (ie, the default of -1), the targetWidth param is ignored.		 * if neither is specified, the default value for targetWidth is used (100).		 * @param tf (TextField) - the TextField (duh)		 * @param text (String) - the text to go into the text field		 * @param styleClass (String) the name of the stylesheet class to use for formatting.		 * @param align (String) html text alignment - valid values are 'left' (default), 'right' or 'center'		 * @param inline (Boolean) whether or not to use inline formatting with a span tag instead of a paragraph tag (default)		 * @param targetWidth (Number) the desired maximum width of the TextField.		 * @param maxLines (int) the maximum number of lines of the TextField. If this is not supplied, it will only truncate to fit within the desired width. If this is supplied, targetWidth is ignored.		 */		public static function setAndTruncateHtmlText(tf : TextField, text : String, styleClass : String, align : String = "left", inline : Boolean = false, targetWidth : Number = 100,maxLines : int = -1) : void {			var _text : String = text;			var i : int = _text.length - 1;			tf.htmlText = returnHtmlText(text, styleClass, align, inline);			if(maxLines == -1) {				while(tf.width > targetWidth) {					i--;					_text = text.substr(0, i) + "...";					tf.htmlText = returnHtmlText(_text, styleClass, align, inline);				}			} else {				if(tf.numLines > maxLines) {					i = -1;					var k : int = 0;					//lets start by truncating the text to be only one line longer than desired...					while(k <= Math.min(maxLines, tf.numLines)) {						i += tf.getLineLength(k);//						trace('k = '+k);//						trace('i+='+tf.getLineLength(k));						k++;					}					//now chop off one letter at a time until it's short enough.					while(tf.numLines > maxLines+1) {						i--;						_text = text.substr(0, i) + "...";						tf.htmlText = returnHtmlText(_text, styleClass, align, inline);					}				}			}			TinyLogManager.log('autoTruncateHtmlText: removed ' + String(text.length - _text.length) + ' characters', tf, 0);		}		/**		 * sets custom anti-aliasing for text fields.		 * @param tf (TextField) the text field		 * @param thickness (Number) thickness, from -400 to 400. default is 100 (optimized for optima at smaller point sizes).		 * @param sharpness (Number) sharpness, from -400 to 400. default is 0 (optimized for optima at smaller point sizes).		 */		public static function setCustomAntiAlias(tf : TextField,thickness : Number = 100,sharpness : Number = -100) : void {			tf.antiAliasType = AntiAliasType.ADVANCED;			tf.thickness = thickness;			tf.sharpness = sharpness;		}		/**		 * returns a new TextField object with the given properties, preset to embed fonts and use the FontManager's styleSheet. params are self-explanatory.		 */		public static function returnTextField(autoSize : String = "left",selectable : Boolean = false,multiline : Boolean = false,wordWrap : Boolean = false, setCustomAA:Boolean = false) : TextField {			var newTF : TextField = new TextField();			newTF.styleSheet = styleSheet;			newTF.embedFonts = true;			newTF.autoSize = autoSize;			newTF.selectable = selectable;			newTF.multiline = multiline;			newTF.wordWrap = wordWrap;			if (setCustomAA) {				setCustomAntiAlias(newTF,0,0);			}			return newTF;		}		/**		 * returns a new TextField object with the given properties, use the FontManager's styleSheet. params are self-explanatory.		 */		public static function prepTextField(tf:TextField, autoSize : String = "left",selectable : Boolean = false,multiline : Boolean = false,wordWrap : Boolean = false, setCustomAA:Boolean = false) : void {			tf.styleSheet = styleSheet;			tf.autoSize = autoSize;			tf.selectable = selectable;			tf.multiline = multiline;			tf.wordWrap = wordWrap;			if(setCustomAA){			setCustomAntiAlias(tf,0,0);			}		}		/**		 * returns a new TextField object with the given properties, preset to embed fonts and use the FontManager's styleSheet. params are self-explanatory.		 */		public static function replaceTextField(tf:TextField, autoSize : String = "left",selectable : Boolean = false,multiline : Boolean = false,wordWrap : Boolean = false, setCustomAA:Boolean = false) : TextField {			var newTF : TextField = new TextField();			newTF.styleSheet = styleSheet;			newTF.embedFonts = true;			newTF.autoSize = autoSize;			newTF.selectable = selectable;			newTF.multiline = multiline;			newTF.wordWrap = wordWrap;			if(setCustomAA){			setCustomAntiAlias(newTF,0,0);			}			newTF.x = tf.x;			newTF.y = tf.y;			newTF.width = tf.width;			newTF.height = tf.height;			var tfParent:DisplayObjectContainer = tf.parent;//			trace('\n\n---\n\ntfParent = '+tfParent);//			trace('width:'+tf.width);//			trace('height:'+tf.height);//			trace('tfParent.getChildIndex(tf) = '+tfParent.getChildIndex(tf));			tfParent.addChildAt(newTF,tfParent.getChildIndex(tf));			tfParent.removeChild(tf);//			trace('newTF.parent = '+newTF.parent+'\n\n---\n\n');			//WOOT			newTF.name = tf.name;			return newTF;		}	}}