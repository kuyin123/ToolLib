package ppf.tool.components.mx.components.controls
{
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	import mx.controls.TextArea;
	import mx.core.UITextField;
	import mx.events.FlexEvent;
	import mx.events.ResizeEvent;
	import mx.events.ScrollEvent;

	[Style(name="underLineThickness", type="Number", format="Length", inherit="no")]
	
	/**
	 * 带行号和下划线的 TextArea<br/>
	 * drawUnderLines<br/>
	 * stepByStep 是否逐行显示行号 true：是，false：全部行都显示<br/>
	 * @author wangke
	 *
	 */
	public class TextArea extends mx.controls.TextArea
	{
		/**
		 * 是否逐行显示行号 true：是，false：全部行都显示 
		 * @return 
		 * @default false
		 * 
		 */		
		public function get stepByStep():Boolean
		{
			return _stepByStep;
		}
		public function set stepByStep(value:Boolean):void
		{
			_stepByStep=value;
		}

		/**
		 * 显示下划线 
		 * @return
		 * @default true
		 * 
		 */		
		public function get drawUnderLines():Boolean
		{
			return _drawUnderLines;
		}
		/**
		 * @private
		 */
		public function set drawUnderLines(value:Boolean):void
		{
			_drawUnderLines=value;
			if (!value)
			{
				if (underLineBox)
				{
					underLineBox.graphics.clear();
				}
			}
		}

		public function TextArea()
		{
			super();
			
			this.addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler, false, 0, true);
			this.addEventListener(ScrollEvent.SCROLL, textChangedHandler, false, 0, true);
			this.addEventListener(ResizeEvent.RESIZE, textChangedHandler, false, 0, true);
			this.addEventListener(Event.CHANGE, textChangedHandler, false, 0, true);
		}
		
		override protected function createChildren():void
		{
			createLineNumberField(-1);
			super.createChildren();
			underLineBox=new Shape();
			this.addChild(underLineBox);
		}

		/**
		 * 画线
		 * 
		 */		
		private function drawUnderLine():void
		{
			if (lineNumberField)
			{
				if (this.textField.numLines < totalLines)
				{
					lengthOfLineNumber=int(String(this.verticalScrollPosition + this.lineNumberField.numLines).length);
				}
				else
				{
					if (lengthOfLineNumber < int(String(this.verticalScrollPosition + this.lineNumberField.numLines).length))
					{
						lengthOfLineNumber=int(String(this.verticalScrollPosition + this.lineNumberField.numLines).length);
					}
				}

				totalLines=this.textField.numLines;
				if (_oneNumberWidth <= 0)
				{
					_oneNumberWidth=this.lineNumberField.textWidth / lengthOfLineNumber;
					_lineNumberFieldWidth=this.lineNumberField.textWidth + 7;
				}
				else
				{
					_lineNumberFieldWidth=(_oneNumberWidth * lengthOfLineNumber) + 7;
				}

				lineNumberField.width=_lineNumberFieldWidth;
				lineNumberField.validateNow();
				setStyle("paddingLeft", _lineNumberFieldWidth);
				var i:Number;
				// starts line drawing.
				if (_drawUnderLines)
				{
					var lineThickness:Number=getStyle("underLineThickness");
					if (!lineThickness)
					{
						lineThickness=1;
					}
					underLineBox.graphics.clear();
					underLineBox.graphics.lineStyle(lineThickness, 1, 0.5);
					if (_stepByStep)
					{
						if ((this.height / _heightOfOneLine) > this.textField.numLines)
						{
							for (i=1; i <= this.textField.numLines; i++)
							{
								underLineBox.graphics.moveTo(_lineNumberFieldWidth, i * _heightOfOneLine);
								underLineBox.graphics.lineTo(unscaledWidth - 18, i * _heightOfOneLine);
							}
						}
						else
						{
							for (i=_heightOfOneLine; i < this.height; i+=_heightOfOneLine)
							{
								underLineBox.graphics.moveTo(_lineNumberFieldWidth, i);
								underLineBox.graphics.lineTo(unscaledWidth - 18, i);
							}
						}
					}
					else
					{
						for (i=_heightOfOneLine; i < this.height; i+=_heightOfOneLine)
						{
							underLineBox.graphics.moveTo(_lineNumberFieldWidth, i);
							underLineBox.graphics.lineTo(unscaledWidth - 18, i);
						}
					}
				}
				else
				{
					//do nothing.
				}
			}
		}

		/**
		 * 显示行号 
		 */		
		private function createLineNumber():void
		{
			numberOfLines=(this.verticalScrollPosition < 1) ? 1 : int(this.verticalScrollPosition + 1);
			var lineNumber:String="";
			var i:Number;
			if (_stepByStep)
			{
				if ((this.height / _heightOfOneLine) > this.textField.numLines)
				{
					for (i=0; i < this.textField.numLines; i++)
					{
						if (i != 0)
						{
							lineNumber+="\n";
						}
						lineNumber+=numberOfLines + "";
						numberOfLines++;
					}
				}
				else
				{
					for (i=_heightOfOneLine; i < this.height; i+=_heightOfOneLine)
					{
						if (i != _heightOfOneLine)
						{
							lineNumber+="\n";
						}
						lineNumber+=numberOfLines + "";
						numberOfLines++;
					}
				}
			}
			else
			{
				for (i=_heightOfOneLine; i < this.height; i+=_heightOfOneLine)
				{
					if (i != _heightOfOneLine)
					{
						lineNumber+="\n";
					}
					lineNumber+=numberOfLines + "";
					numberOfLines++;
				}
			}
			lineNumberField.text=lineNumber;
			drawUnderLine();
		}

		/**
		 *  @private
		 *  Adds UITextField as a child.
		 *
		 *  @param childIndex The index of where to add the child.
		 *  If -1, the text field is appended to the end of the list.
		 */
		private function createLineNumberField(childIndex:int):void
		{

			if (!lineNumberField)
			{
				lineNumberField=new UITextField();
				lineNumberField.autoSize="left";
				lineNumberField.enabled=enabled;
				lineNumberField.ignorePadding=false;
				lineNumberField.multiline=true;
				lineNumberField.selectable=false;
				lineNumberField.tabEnabled=false;
				lineNumberField.type=TextFieldType.DYNAMIC;
				lineNumberField.width=_lineNumberFieldWidth;
				var tf:TextFormat=new TextFormat();
				tf.align=TextFormatAlign.LEFT;
				lineNumberField.setTextFormat(tf);

				if (childIndex == -1)
					addChild(DisplayObject(lineNumberField));
				else
					addChildAt(DisplayObject(lineNumberField), childIndex);
			}
		}

		/**
		 * @private
		 *
		 */
		private function creationCompleteHandler(event:FlexEvent):void
		{
			_heightOfOneLine=this.textHeight;
			createLineNumber();
		}

		/**
		 * @private
		 *
		 * TextArea's change event.
		 */
		private function textChangedHandler(event:Event):void
		{
			createLineNumber();
		}

		private var underLineBox:Shape;
		private var totalLines:int;
		private var lengthOfLineNumber:int
		private var lineNumberField:UITextField;
		private var numberOfLines:int;
		private var _heightOfOneLine:Number;
		private var _lineNumberFieldWidth:Number;
		private var _oneNumberWidth:Number=-1;

		/**
		 * @private
		 */
		private var _stepByStep:Boolean=false;
		
		/**
		 * @private
		 */
		private var _drawUnderLines:Boolean=true;
	}
}