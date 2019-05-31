package ppf.tool.components.mx.components.controls
{
	import ppf.tool.components.ErrorTipManager;
	import ppf.tool.components.IInput;
	import ppf.tool.text.RestrictUtil;
	
	import flash.events.Event;
	import flash.events.TextEvent;
	
	import mx.controls.TextInput;
	import mx.utils.StringUtil;
	
	/**
	 * editable 设置文本框为是否“不可修改”状态，可复制内容，建议使用该属性替换enabled<br/>
	 * labelText 文本后面增加显示文本，例如作为单位显示<br/>
	 * allowNegative 是否允许输入负数 true：负数 false不允许<br/>
	 * fractionalDigits 小数点后的出现的数字位数<br/>
	 * minNum 允许输入的最小的数字<br/>
	 * maxNum 允许输入的最大数字<br/>
	 * isTrim 是否禁止字符串的开头和末尾的所有空格字符 true：是 fasle：否<br/>
	 * minChars 最少输入字符数<br/>
	 * maxChars 最大输入字符数<br/>
	 * restrict 输入字符集
	 * @see com.grusen.utils.RestrictUtil<br/>
	 * @author wangke
	 */	
	public class TextInput extends mx.controls.TextInput implements IInput
	{
		/**
		 * 是否允许输入负数 true：负数 false不允许：
		 * @default true
		 */
		public function set allowNegative(value:Boolean):void
		{
			if (_allowNegative != value)
			{
				_allowNegative = value;
				_isNum = true;
				invalidateProperties();    
			}
		}
		
		/**
		 * 小数点后的出现的数字位数
		 * @return 
		 */		
		public function get fractionalDigits():Number
		{
			return _fractionalDigits;
		}
		[Bindable]
		public function set fractionalDigits(value:Number):void
		{
			if (_fractionalDigits != value)
			{
				_fractionalDigits = value;
				_isNum = true;
				_toolTipChange = true;
				invalidateProperties();    
			}
		}

		[Bindable]
		public function get minNum():Number
		{
			return _minNum;
		}
		public function set minNum(value:Number):void
		{
			if (_minNum != value)
			{
				_minNum = value;
				_toolTipChange = true;
				invalidateProperties();
			}
		}
		[Bindable]
		public function get maxNum():Number
		{
			return _maxNum;	
		}
		public function set maxNum(value:Number):void
		{
			if (_maxNum != value)
			{
				_maxNum = value;
				_toolTipChange = true;
				invalidateProperties();
			}
		}
		
		public function get validReg():RegExp
		{
			return _validReg;	
		}
		public function set validReg(value:RegExp):void
		{
			_validReg = value;	
		}
		
		[Bindable]
		public var _value:String;
		
		
		[Bindable]
		public function get minChars():int
		{
			return _minChars;
		}
		public function set minChars(value:int):void
		{
			if (_minChars != value)
			{
				_minChars = value;
				_toolTipChange = true;
				invalidateProperties();
			}
		}
		/**
		 * override 增加[Bindable]消除警告
		 */		
		[Bindable]
		override public function get maxChars():int
		{
			return super.maxChars;
		}
		override public function set maxChars(value:int):void
		{
			if (super.maxChars != value)
			{
				super.maxChars = value;
				_toolTipChange = true;
				invalidateProperties();
			}
		}
		
		override public function set restrict(value:String):void
		{
			if (super.restrict != value)
			{
				super.restrict = value;
				if (value == RestrictUtil.INT_REG  ||
					value == RestrictUtil.FLOAT_REG)
				{
					_toolTipChange = true;
					_isNum = true;
					invalidateProperties();
				}
				
				if(value == RestrictUtil.FLOAT_REG || value==RestrictUtil.POSITIVE_FLOAT){
					if(_fractionalDigits <=0)
						_fractionalDigits = 2;
				}
			}
		}
		
		override protected function commitProperties():void
		{
			toolTip = RestrictUtil.getTextInputToolTip(this);
			super.commitProperties();
			
			if (_isEditChange)
			{
				if (!editable)
				{
					textField.background = true;
					textField.backgroundColor = 0xDEDEDE;
				}
				else
					textField.background = false;
				
				_isEditChange = false;
			}
			
			if (_toolTipChange)
			{
				toolTip = RestrictUtil.getTextInputToolTip(this);
				_toolTipChange = false;
			}
			
			if (_isNum)
			{
				updateRegex();
				_isNum = false;
			}
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			this.addEventListener(TextEvent.TEXT_INPUT,onTextChange,false,0,true);
		}
		/**
		 * 使用DataGrid的属性字段
		 */		
		public var dataField:String = "";
		
		/**
		 * 是否禁止字符串的开头和末尾的所有空格字符 true：是 fasle：否
		 */		
		public var isTrim:Boolean = false;
		
		public function TextInput()
		{
			super();
			super.maxChars = 25;
			super.restrict = RestrictUtil.FILENAME_REG;
			this.addEventListener(Event.CHANGE,onChange,false,0,true);
			this.addEventListener(Event.SCROLL, textField_scrollHandler,false,0,true);
			toolTip = RestrictUtil.getTextInputToolTip(this);
		}
		protected function textField_scrollHandler(e:Event):void
		{
			this.callLater(setScrollPosition);
		}
		
		protected function setScrollPosition():void
		{
			horizontalScrollPosition = 0;
		}
		
		/**
		 * 文本显示的字符 
		 * @param v 字符 
		 * 
		 */
		public function set Value(v:String):void
		{
			_value=v;
			this.text=v;
		}
		
		/**
		 * 设置文本框为是否“不可修改”状态，可复制内容，建议使用该属性替换enabled
		 * @private
		 * 
		 */	    
		override public function set editable(value:Boolean):void
		{
			if (super.editable != value)
			{
				super.editable = value;
				
				_isEditChange = true;
			}
		}
		
		/**
		 * 通过用户输入更改 TextInput 控件中的文本时调度事件处理函数 
		 * @param event
		 * 
		 */		
		protected function onChange(event:Event):void
		{
			var value:Number = Number(text);
			
			if (!isNaN(value))
			{
				if (value > _maxNum)
					this.text = _maxNum.toString();
				else if (value < _minNum)
					this.text = _minNum.toString();
			}
			
			//删除字符串的开头和末尾的所有空格字符
			if (isTrim)
				this.text = StringUtil.trim(this.text);
			
			_value=String(this.text);
			
			if (dataField != "")
				data[dataField] = event.currentTarget.text;
			
			//隐藏验证的错误提示
			ErrorTipManager.hideErrorTip(this,true);
		}
		
		private function onTextChange(event:TextEvent):void
		{
			if (_reg)
			{
				//允许输入的字符(用于检测)
				var textToBe:String="";
				var firstIndex:int;
				var endIndex:int;
				//从左往右选中和从右往左selectionAnchorPosition和selectionAnchorPosition 数值相反
				if (selectionActivePosition < selectionAnchorPosition)
				{
					firstIndex = selectionActivePosition;
					endIndex = selectionAnchorPosition;
				}
				else
				{
					firstIndex = selectionAnchorPosition;
					endIndex = selectionActivePosition;
				}
				//截取开始字符
				if (firstIndex > 0)
				{
					textToBe += text.substr(0, firstIndex)
				}
				//加入输入字符
				textToBe += event.text;
				//截取结束字符
				if (endIndex > 0)
				{
					textToBe += text.substr(endIndex, text.length - endIndex);
				}
				//检测是否有效
				var match:Object=_reg.exec(textToBe);
				if (!match || match[0] != textToBe)
				{
					// The textToBe didn't match the expression... stop the event
					event.preventDefault();
				}
				//special condition checking to prevent multiple dots
				var firstDotIndex:int=textToBe.indexOf(".");
				if (firstDotIndex != -1)
				{
					var lastDotIndex:int=textToBe.lastIndexOf(".");
					if (lastDotIndex != -1 && lastDotIndex != firstDotIndex)
						event.preventDefault();
				}
			}
		}
		
		/**
		 * 符号+小数的完整正则"^\\-\\d{0,8}\\.?(?<!-.)\\d{0,3}|^\\d{1,8}\\.?\\d{0,3}$" 
		 * 
		 */		
		private function updateRegex():void
		{
			var regStr:String = "\\d{1,"+(maxChars-_fractionalDigits).toString()+"}";
			if (_allowNegative)
			{
				//负号至多有一个
				regStr	="^\\-\\d{0,"+(maxChars-_fractionalDigits).toString()+"}"+getRegStrFD(true)+"|^"+regStr+getRegStrFD(false);
			}
			else
			{
				regStr	= "^" + regStr + getRegStrFD(false);
			}
			regStr+="$";
			
			_reg = new RegExp(regStr);
		}
		
		/**
		 * 获取小数点位数正则字符 
		 * @param b
		 * @return 
		 * 
		 */		
		private function getRegStrFD(b:Boolean):String
		{
			var str:String = "";
			if (_fractionalDigits > 0)
			{
				str =  "\\.?"+(b?"(?<!-.)":"")+"\\d{0," + _fractionalDigits.toString() + "}";
			}
			return str;
		}
		private var _allowNegative:Boolean = true;
		
		//regex pattern
		private var _reg:RegExp;
		
		private var _minChars:int = 0;
		
		private var _minNum:Number = Number.NaN;
		private var _maxNum:Number = Number.NaN;
		private var _validReg:RegExp;
		private var _fractionalDigits:Number = 0;
		private var _isEditChange:Boolean = false;
		/**
		 * 数字几位数，处理小数点 
		 */		
		private var _maxCharsNum:int;
		/**
		 * 是否处理小数 
		 */		
		private var _isNum:Boolean = false;
		/**
		 * 更新tip 
		 */		
		private var _toolTipChange:Boolean = false;
	}
}