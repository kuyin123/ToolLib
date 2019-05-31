package ppf.tool.components.mx.components.controls
{
	import flash.display.Graphics;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.ui.Keyboard;
	
	import mx.containers.Box;
	import mx.core.ScrollPolicy;
	import mx.events.CalendarLayoutChangeEvent;
	import mx.events.IndexChangedEvent;
	import mx.managers.PopUpManager;
	
	import spark.formatters.DateTimeFormatter;
	
	import ppf.base.resources.LocaleConst;
	import ppf.base.resources.LocaleManager;
	
	/**
	 * 时间空间日历及日期的同时显示输入</br>
	 * dateTime获取时间</br>
	 * isShowSecond 是否显示秒数 </br>
	 * maxDate、minDate</br>
	 * @author wangke
	 * 
	 */	
	public class DateTimeInput extends Box
	{
		static public const DATE_TIME_CHANGE:String="DateTimeChange";
		/**
		 * 是否显示秒数 
		 */		
		public var isShowSecond:Boolean = true;
		/**
		 *显示的时间是否显示最前端的0,默认为false
		 * </br>例如9月，如果 isZeroPadding==true,则表示为"09"，否则表示为"9"
		 */		
		public var isZeroPadding:Boolean=false;
		
		/**
		 * 是否可编辑时、分、秒
		 */ 
 		public var isEditHmsAble:Boolean = true;
		
		[Embed(source="assets/calendar.png")]
		private static var IconCalendar:Class;
		
		public function DateTimeInput()
		{
			super();
			
//			this.setStyle("borderColor","0xAAB3B3");
//			this.setStyle("backgroundColor", "0xFFFFFF");
			this.setStyle("borderStyle","solid");
//			this.setStyle("borderThickness","1");
//			this.setStyle("shadowDirection", "center");
//			this.setStyle("shadowDistance", "2");
			horizontalScrollPolicy=ScrollPolicy.OFF;
			maxDate = new Date();
			_htdc.monthNames = [
				LocaleManager.getInstance().getString(LocaleConst.LIB,'LIB_TIME_001'),
				LocaleManager.getInstance().getString(LocaleConst.LIB,'LIB_TIME_002'),
				LocaleManager.getInstance().getString(LocaleConst.LIB,'LIB_TIME_003'),
				LocaleManager.getInstance().getString(LocaleConst.LIB,'LIB_TIME_004'),
				LocaleManager.getInstance().getString(LocaleConst.LIB,'LIB_TIME_005'),
				LocaleManager.getInstance().getString(LocaleConst.LIB,'LIB_TIME_006'),
				LocaleManager.getInstance().getString(LocaleConst.LIB,'LIB_TIME_007'),
				LocaleManager.getInstance().getString(LocaleConst.LIB,'LIB_TIME_008'),
				LocaleManager.getInstance().getString(LocaleConst.LIB,'LIB_TIME_009'),
				LocaleManager.getInstance().getString(LocaleConst.LIB,'LIB_TIME_010'),
				LocaleManager.getInstance().getString(LocaleConst.LIB,'LIB_TIME_011'),
				LocaleManager.getInstance().getString(LocaleConst.LIB,'LIB_TIME_012')];
			_htdc.dayNames = [
				LocaleManager.getInstance().getString(LocaleConst.LIB,'LIB_TIME_013'),
				LocaleManager.getInstance().getString(LocaleConst.LIB,'LIB_TIME_014'),
				LocaleManager.getInstance().getString(LocaleConst.LIB,'LIB_TIME_015'),
				LocaleManager.getInstance().getString(LocaleConst.LIB,'LIB_TIME_016'),
				LocaleManager.getInstance().getString(LocaleConst.LIB,'LIB_TIME_017'),
				LocaleManager.getInstance().getString(LocaleConst.LIB,'LIB_TIME_018'),
				LocaleManager.getInstance().getString(LocaleConst.LIB,'LIB_TIME_019')];
		}
		
		public function set maxDate(value:Date):void
		{
			//始终设置为当前时间最大的
			value.hours = 23;
			value.minutes = 59;
			value.seconds = 59;
			_maxDate = value;
			
			//判断selectableRange防止重绘
			var rangeEnd:Date = _htdc.selectableRange.rangeEnd as Date;
			if (_maxDate.fullYear > rangeEnd.fullYear || 
				(_maxDate.fullYear == rangeEnd.fullYear && _maxDate.month > rangeEnd.month)||
				(_maxDate.fullYear == rangeEnd.fullYear &&  _maxDate.month == rangeEnd.month && _maxDate.date > rangeEnd.date))
			{
				setSelectableRange();
			}
			
		}
		
		public function get maxDate():Date
		{
			return _maxDate;
		}
		
		public function set minDate(value:Date):void
		{
			_minDate = value;
			
			var rangeStart:Date = _htdc.selectableRange.rangeStart as Date;
			if (_minDate.fullYear < rangeStart.fullYear || 
				(_minDate.fullYear == rangeStart.fullYear && _minDate.month < rangeStart.month)||
				(_minDate.fullYear == rangeStart.fullYear &&  _minDate.month == rangeStart.month && _minDate.date < rangeStart.date))
			{
				setSelectableRange();
			}
		}
		public function get minDate():Date
		{
			return _minDate;
		}
		
		
		/**
		 * 获取时间
		 */
		[Bindable]
		public function get dateTime():Date
		{
			//			onChanngeDisplayDate();
			return new Date(_date);
		}
		public function set dateTime(value:Date):void
		{
			if(isShowHS){
				var dataStr:String = dateFormatter(value);
				dataStr = dataStr + " 00:00:00";
				_date = new Date(Date.parse(dataStr.replace(/\-/g,"/")));
			}else{
				_date = value;
			}
			
			invalidateProperties();
			bProperChanged=true;
		}
		
		public function setEnabled(value:Boolean):void
		{
			if (isShowSecond)
				_dateTime.enabled = value;
			else
				_dateTimeNos.enabled = value;
		}
		
		override public function invalidateProperties():void
		{
			super.invalidateProperties();
			bProperChanged=true;
		}
		
		/**
		 * @private
		 * 
		 */		
		override protected function createChildren() : void
		{
			super.createChildren();
			
			if (isShowSecond)
				_dateTime = new FLDateTimeInput;
			else
				_dateTimeNos = new FLDateTimeInputNoS;
			
			_htdc.isShowSecond = isShowSecond;
			
			/*this.setStyle("borderColor","0xAAB3B3");
			this.setStyle("backgroundColor", "0xFFFFFF");
			this.setStyle("borderStyle","solid");
			this.setStyle("borderThickness","1");
			this.setStyle("shadowDirection", "center");
			this.setStyle("shadowDistance", "2");*/
			
			this.minHeight = 23;
			if (isShowSecond)
				this.minWidth = this.maxWidth = 173;
			else
				this.minWidth = this.maxWidth = 150;
			
			if (isShowSecond)
				this.addChild(_dateTime);
			else
				this.addChild(_dateTimeNos);
			
			this.mouseChildren = true;
			this.mouseEnabled = false;
			this.mouseFocusEnabled = false;
			this.focusEnabled = false;
			this.tabChildren = true;
			this.tabEnabled = false;
			
			var simpleBtn:SimpleButton;
			if (isShowSecond)
			{
				_dateTime.mouseChildren = true;
				_dateTime.mouseEnabled = false;
				_dateTime.focusEnabled = false;
				_dateTime.tabChildren = true;
				_dateTime.tabEnabled = false;
				
				simpleBtn = _dateTime.btnChangeDate as SimpleButton;
			}
			else
			{
				_dateTimeNos.mouseChildren = true;
				_dateTimeNos.mouseEnabled = false;
				_dateTimeNos.focusEnabled = false;
				_dateTimeNos.tabChildren = true;
				_dateTimeNos.tabEnabled = false;
				
				simpleBtn = _dateTimeNos.btnChangeDate as SimpleButton;
			}

			if(simpleBtn != null)
				simpleBtn.upState = simpleBtn.overState = simpleBtn.downState = simpleBtn.hitTestState =new IconCalendar();
			
			yearText.type = TextFieldType.INPUT;
			monthText.type = TextFieldType.INPUT;
			dayText.type = TextFieldType.INPUT;
			
			if(!isEditHmsAble){
				hourText.type = TextFieldType.DYNAMIC;
				minuteText.type = TextFieldType.DYNAMIC;
 			}else{
				hourText.type = TextFieldType.INPUT;
				minuteText.type = TextFieldType.INPUT;
			}
 			
			if (isShowSecond){
				if(isEditHmsAble)
					secondText.type = TextFieldType.INPUT;
				else
					secondText.type = TextFieldType.DYNAMIC;
			}
				
			
			/*yearText.alwaysShowSelection = true;
			monthText.alwaysShowSelection = true;
			dayText.alwaysShowSelection = true;*/
			/*hourText.multiline = false;
			minuteText.multiline = false;
			secondText.multiline = false;
			_htdc.visible = false;*/
			
			yearText.tabIndex = 1;
			monthText.tabIndex = 2;
			dayText.tabIndex = 3;
			hourText.tabIndex = 4;
			minuteText.tabIndex = 5;
			if (isShowSecond)
				secondText.tabIndex = 6;
			else
				secondText.width=0;
			//this.setFocus();
			
			addListener();
		
			//初始化设置显示的日期时间
			checkTime(_date);
			onChanngeDisplayDate(null);
		}
		
		override protected function updateDisplayList(unscaledWidth:Number,unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			if(width == 0 || height == 0)
				return;
			var sp:Sprite = _dateTime ? _dateTime : _dateTimeNos;
			if(sp == null)
				return;
			var g:Graphics = sp.graphics;
			g.clear();
			g.lineStyle(1,0x8697b7);
			g.beginFill(0xffffff);
			g.drawRect(-1,-1,width,height + 1);
			g.endFill();
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			if(bProperChanged)
			{
				bProperChanged=false;
				checkTime(_date);
			}
		}
		//-------------------------------------------------
		
		protected function get second():Number
		{			return Number(secondText.text);		}
		protected function set second(value:Number):void
		{
			if (!isNaN(value))
				secondText.text = String(int(value));
			if(isZeroPadding)
			{
				zeroPadding(secondText);
			}
		}
		
		protected function get minute():Number
		{			return Number(minuteText.text);		}
		protected function set minute(value:Number):void
		{
			if (!isNaN(value))
				minuteText.text = String(int(value));
			if(isZeroPadding)
			{
				zeroPadding(minuteText);
			}
		}
		
		protected function get hour():Number
		{			return Number(hourText.text);		}
		protected function set hour(value:Number):void
		{
			if (!isNaN(value))
				hourText.text = String(int(value));
			if(isZeroPadding)
			{
				zeroPadding(hourText);
			}
		}
		
		protected function get day():Number
		{
			return Number(dayText.text);
		}
		
		protected function set day(value:Number):void
		{
			if (!isNaN(value))
				dayText.text = String(int(value));
			if(isZeroPadding)
			{
				zeroPadding(dayText);
			}
		}
		
		protected function get month():Number
		{			return (Number(monthText.text)-1);		}
		protected function set month(value:Number):void
		{
			if (!isNaN(value))
				monthText.text = String(int(value)+1);
			if(isZeroPadding)
			{
				zeroPadding(monthText);
			}
		}
		
		protected function get year():Number
		{			return Number(yearText.text);		}
		protected function set year(value:Number):void
		{
			if (!isNaN(value))
				yearText.text = String(int(value));
			if(isZeroPadding)
			{
				zeroPadding(yearText);
			}
		}
		
		//--------------------------------------------------------
		
		protected function get yearText():TextField
		{			
			if (!isShowSecond)
				return _dateTimeNos.txtYear as TextField
			return _dateTime.txtYear as TextField;
		}
		protected function set yearText(value:TextField):void
		{	
			if (!isShowSecond)
				_dateTimeNos.txtYear = value;		
			_dateTime.txtYear = value;		
		}
		
		protected function get monthText():TextField
		{			
			if (!isShowSecond)
				return _dateTimeNos.txtMonth as TextField;		
			return _dateTime.txtMonth as TextField;		
		}
		protected function set monthText(value:TextField):void
		{			
			if (!isShowSecond)
				_dateTimeNos.txtMonth = value;		
			_dateTime.txtMonth = value;		
		}
		
		protected function get dayText():TextField
		{			
			if (!isShowSecond)
				return _dateTimeNos.txtDay as TextField;	
			return _dateTime.txtDay as TextField;	
		}
		protected function set dayText(value:TextField):void
		{			
			if (!isShowSecond)
				_dateTimeNos.txtDay = value;	
			_dateTime.txtDay = value;	
		}
		
		protected function get hourText():TextField
		{			
			if (!isShowSecond)
				return _dateTimeNos.txtHour as TextField;		
			return _dateTime.txtHour as TextField;		
		}
		protected function set hourText(value:TextField):void
		{			
			if (!isShowSecond)
				_dateTimeNos.txtHour = value;		
			_dateTime.txtHour = value;		
		}
		
		protected function get minuteText():TextField
		{			
			if (!isShowSecond)
				return _dateTimeNos.txtMinute as TextField;		
			return _dateTime.txtMinute as TextField;		
		}
		protected function set minuteText(value:TextField):void
		{			
			if (!isShowSecond)
				_dateTimeNos.txtMinute = value;		
			_dateTime.txtMinute = value;		
		}
		
		protected function get secondText():TextField
		{		
			if (!isShowSecond)
				return _second;
			return _dateTime.txtSecond as TextField;
		}
		protected function set secondText(value:TextField):void
		{	
			if (!isShowSecond)
				_second = value;
			_dateTime.txtSecond = value;		
		}
		
		private function onChanngeDisplayDate(e:Event = null):void
		{
			try
			{
				if (null == _date)
					return;
				//				_date.fullYear = year;
				//				_date.month = month;
				//				_date.date = day;
				//				_date.hours = hour;
				//				_date.minutes = minute;
				//				_date.seconds = second;
				var tmpDate:Date = new Date(year,month,day,hour,minute,second,_date.milliseconds);
//				tmpDate.fullYear = year;
//				tmpDate.month = month;
//				tmpDate.date = day;
//				tmpDate.hours = hour;
//				tmpDate.minutes = minute;
//				tmpDate.seconds = second;
				_date = tmpDate;
				this.dispatchEvent(new Event(DATE_TIME_CHANGE));
			}
			catch (err:Error)
			{
				trace("onChanngeDisplayDate >> error!");
			}
		}
		
		private function setDisplayDate():void
		{
			year = _date.getFullYear();
			month = _date.getMonth();
			day = _date.getDate();
			hour = _date.getHours();
			minute = _date.getMinutes();
			second = _date.getSeconds();
		}
		
		
		
		private function addListener():void
		{
			//按键输入框切换事件监听
			yearText.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, false, 0, true);
			monthText.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, false, 0, true);
			dayText.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, false, 0, true);
			hourText.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, false, 0, true);
			minuteText.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, false, 0, true);
			if (isShowSecond)
				secondText.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, false, 0, true);
			
			yearText.addEventListener(FocusEvent.FOCUS_OUT, dateCheck, false, 0, true);
			monthText.addEventListener(FocusEvent.FOCUS_OUT, dateCheck, false, 0, true);
			dayText.addEventListener(FocusEvent.FOCUS_OUT, dateCheck, false, 0, true);
			hourText.addEventListener(FocusEvent.FOCUS_OUT, dateCheck, false, 0, true);
			minuteText.addEventListener(FocusEvent.FOCUS_OUT, dateCheck, false, 0, true);
			if (isShowSecond)
				secondText.addEventListener(FocusEvent.FOCUS_OUT, dateCheck, false, 0, true);
			
			yearText.addEventListener(FocusEvent.FOCUS_IN, setTextFieldFocus, false, 0, true);
			monthText.addEventListener(FocusEvent.FOCUS_IN, setTextFieldFocus, false, 0, true);
			dayText.addEventListener(FocusEvent.FOCUS_IN, setTextFieldFocus, false, 0, true);
			hourText.addEventListener(FocusEvent.FOCUS_IN, setTextFieldFocus, false, 0, true);
			minuteText.addEventListener(FocusEvent.FOCUS_IN, setTextFieldFocus, false, 0, true);
			if (isShowSecond)
				secondText.addEventListener(FocusEvent.FOCUS_IN, setTextFieldFocus, false, 0, true);
			
			_htdc.addEventListener(CalendarLayoutChangeEvent.CHANGE, onChooserChanged, false, 0, true);
			_htdc.addEventListener(Event.CLOSE, onChooserClosed, false, 0, true);
//			_htdc.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE,onChooserFocusChanged,false,0,true);
			_htdc.addEventListener(MouseEvent.MOUSE_DOWN,onChooserMouseDown,false,0,true);
			_htdc.addEventListener(MouseEvent.MOUSE_OVER,onChooserMouseOver,false,0,true);
			if (isShowSecond)
				_dateTime.btnChangeDate.addEventListener(MouseEvent.CLICK, onBtnChangeDateClick, false, 0, true);
			else
				_dateTimeNos.btnChangeDate.addEventListener(MouseEvent.CLICK, onBtnChangeDateClick, false, 0, true);
			this.addEventListener(Event.ADDED_TO_STAGE, onAddtoStage, false, 0, true);
			
			addEventListener(IndexChangedEvent.CHANGE, onIndexChange,false,0,true);
		}
		
		private function onAddtoStage(e:Event):void
		{
			stage.focus = yearText;
			stage.addEventListener(MouseEvent.MOUSE_DOWN,onChooserFocusChanged,false,0,true);
		}
		
		private function setTextFieldFocus(event:FocusEvent):void
		{
			var field:TextField = event.target as TextField;
			if (null == field)
				return;
			if(isZeroPadding)
			{
				field.setSelection(0, field.text.length);
				textRepairZero(field, true);				
			}
			//field.selectedText = field.text;
//			trace ("begin> " + field.selectionBeginIndex + ",end> " + field.selectionEndIndex);
//			trace ("SelectAll> " + field.selectedText +","+ isSelectAll(field));
		}
		
		private function dateCheck(event:FocusEvent):void
		{
			var preDate:Date=new Date(_date);
			if(_date)
			{
				var tmpDate:Date = new Date(year,month,day,hour,minute,second,_date.milliseconds);
				_date=tmpDate;
			}
//			onChanngeDisplayDate(null);
			checkTime(_date);
			if(_date&&preDate&&_date.time!=preDate.time)
				this.dispatchEvent(new Event(DATE_TIME_CHANGE));
		}
		
		private function onKeyDown(event:KeyboardEvent):void
		{
			var currTextfield:TextField = event.target as TextField;
			var isSelAll:Boolean = isSelectAll(currTextfield);
			
			var nextTextField:TextField;
			switch (event.keyCode)
			{
				case Keyboard.RIGHT :
					if (currTextfield == secondText)
						break;
					textRepairZero(currTextfield, true);
					
					if(isSelAll || currTextfield.selectionEndIndex == currTextfield.length)
					{
						switch (currTextfield)
						{
							case yearText:
								nextTextField = monthText;
								break;
							case monthText:
								nextTextField = dayText;
								break;
							case dayText:
								nextTextField = hourText;
								break;
							case hourText:
								nextTextField = minuteText;
								break;
							case minuteText:
								nextTextField = secondText;
								break;
						}
						if (null != nextTextField)
						{
							stage.focus = nextTextField;
							callLater(setTextFieldIndex,[nextTextField]);
						}
					}
					break;
				case Keyboard.LEFT:
					if (currTextfield == yearText)
						break;
					textRepairZero(currTextfield, true);
					
					if(isSelAll || (currTextfield.selectionBeginIndex == 0 && currTextfield.selectionEndIndex == 0))
					{
						switch (currTextfield)
						{
							case secondText:
								nextTextField = minuteText;
								break;
							case minuteText:
								nextTextField = hourText;
								break;
							case hourText:
								nextTextField = dayText;
								break;
							case dayText:
								nextTextField = monthText;
								break;
							case monthText:
								nextTextField = yearText;
								break;
						}
						if (null != nextTextField)
						{
							stage.focus = nextTextField;
							callLater(setTextFieldIndex,[nextTextField,false]);
						}
					}
					break;
				case Keyboard.UP:
					var tmpNum:Number = Number(currTextfield.text);
					if (!isNaN(tmpNum))
					{
						currTextfield.text = String(tmpNum + 1);
					}
					textRepairZero(currTextfield, true);
					break;
				case Keyboard.DOWN:
					var tmpNum2:Number = Number(currTextfield.text);
					if (!isNaN(tmpNum2) && tmpNum2 > 0)
					{
						currTextfield.text = String(tmpNum2 - 1);
					}
					textRepairZero(currTextfield, true);
					break;
				case Keyboard.TAB:
					break;
				default:
					if (event.altKey || event.shiftKey || event.ctrlKey)
						return;
					this.callLater(textRepairZero,[currTextfield]);
					stage.focus = currTextfield;
					this.callLater(focusNextTextField,[currTextfield]);
					break;
			}
		}
		
		/**
		 * 设置输入框的选中状态
		 * @param tf 输入框
		 * @param isLeft 是否光标在左侧
		 * 
		 */		
		private function setTextFieldIndex(tf:TextField,isLeft:Boolean = true):void
		{
			if (isLeft)
				tf.setSelection(0, 0);
			else
				tf.setSelection(tf.length+1, tf.length+1);
			
			//tf.setSelection(0, tf.length+1);
//			trace ("begin  " + tf.selectionBeginIndex + ",end  " + tf.selectionEndIndex);
		}
		
		/**
		 * 校验各字段的值，并设为有效值
		 * @param tf 字段
		 * @param isDone 是否一次完整操作，还是操作过程的一个片段，
		 * 	比如：输入年份，输入四个数字为一次完整的操作，每输入一个数字为一个片段
		 * 	true：一次完整的操作
		 * 	false：一个输入的片段（默认值）
		 * 
		 */		
		private function textRepairZero(tf:TextField,isDone:Boolean = false):void
		{
			var tmpNum:Number = Number(tf.text);
			var tmpDate:Date = new Date;
			var tmpYear:Number = tmpDate.getFullYear();
			var date:Date = _date;
			
			var preDate:Date=new Date(_date.time);
			
			if (isNaN(tmpNum))
			{
				tf.text = "";
				tmpNum = -1;
			}
			
			switch (tf)
			{
				case secondText:
					if (tmpNum > 59)
						tmpNum = 59;
					if (tmpNum < 0)
						tmpNum = 0;
					date.seconds = tmpNum;
					break;
				case minuteText:
					if (tmpNum > 59)
						tmpNum = 59;
					if (tmpNum < 0)
						tmpNum = 0;
					date.minutes = tmpNum;
					break;
				case hourText:
					if (tmpNum > 23)
						tmpNum = 23;
					if (tmpNum < 0)
						tmpNum = 0;
					date.hours = tmpNum;
					break;
				case dayText:
					tmpNum = setDay();
					date.date = tmpNum;
					break;
				case monthText:
					if (tmpNum > 12)
						tmpNum = 12;
					if (tmpNum < 1)
						tmpNum = 1;
					date.date=setDay();
					date.month = tmpNum - 1;
					break;
				case yearText:
					if (isDone || yearText.length == 4)
					{
						if (tmpNum > tmpYear)
							tmpNum = tmpYear;
						if (tmpNum < 1970)
							tmpNum = 1970;
						date.date=setDay();
						date.fullYear = tmpNum;
					}
					break;
			}
			
			if (yearText.length == 4 && 
				monthText.length == 2 && 
				dayText.length == 2 && 
				hourText.length == 2 && 
				minuteText.length == 2 && 
				secondText.length == 2)
			{
				checkTime(date);
			}
			else if (tmpNum != -1)
			{
				tf.text = String(tmpNum);
			}
			if(preDate.time!=date.time)
				onChanngeDisplayDate();
			return;
		}
		
		private function zeroPadding(tf:TextField):void
		{
			while (tf.length < tf.maxChars)
				tf.text = "0" + tf.text;
		}
		
		private function checkTime(date:Date):void
		{
		
		
//			//大于最大时间
//			if (_maxDate && date.time > _maxDate.time)
//			{
//				year = _maxDate.fullYear;
//				month = _maxDate.month;
//				day = _maxDate.date;
//				hour = _maxDate.hours;
//				minute = _maxDate.minutes;
//				second = _maxDate.seconds;
//			}
//			//小于最小时间
//			else if (_minDate && date.time < _minDate.time)
//			{
//				year = _minDate.fullYear;
//				month = _minDate.month;
//				day = _minDate.date;
//				hour = _minDate.hours;
//				minute = _minDate.minutes;
//				second = _minDate.seconds;
//			}
//			else 
			{
		
				year = date.fullYear;
				month = date.month;
				day = date.date;
				hour = date.hours;
				minute = date.minutes;
				second = date.seconds;
			}
		}
		
		/**
		 * 设置“日”的内容，设置完年、月、日都要调用本函数校验
		 * @return 
		 * 
		 */		
		private function setDay():Number
		{
			var tmpMonth:Number = Number(monthText.text);
			var tmpDay:Number = Number(dayText.text);
			
			if (tmpMonth == 2) //二月份的校验
			{
				//闰年
				if (isRunNian && tmpDay > 29)
					tmpDay = 29;
				else if (!isRunNian && tmpDay > 28)
					tmpDay = 28;
			}
			else if (isBigMonth && tmpDay > 31) // 大月份的校验
				tmpDay = 31;
			else if (!isBigMonth && tmpDay > 30) // 小月份的校验
				tmpDay = 30;
			
			
			if (tmpDay < 1 || isNaN(tmpDay)) // 小于1的校验和非法字符校验
				tmpDay = 1;
			
//			day = tmpDay;
			return tmpDay;
		}
		
		/**
		 * 是否大月份
		 * @return 
		 * 
		 */		
		private function get isBigMonth():Boolean
		{
			var tmpMonth:Number = Number(monthText.text);
			
			return ((tmpMonth <= 7) && (tmpMonth % 2 != 0)) || 
				((tmpMonth >= 8) && (tmpMonth % 2 == 0)) ? true : false;
		}
		/**
		 * 是否是闰年
		 * @return 
		 * 
		 */		
		private function get isRunNian():Boolean
		{
			var year:Number = Number(yearText.text);
			return ((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0) ? true : false;
		}
		
		/**
		 * 设置下一个焦点框
		 * @param tf 当前输入框
		 * 
		 */		
		private function focusNextTextField(tf:TextField):void
		{
			var tmpTextfield:TextField;
			if (tf.length == tf.maxChars)
			{
				switch (tf)
				{
					case yearText:
						tmpTextfield = monthText;
						break;
					case monthText:
						tmpTextfield = dayText;
						break;
					case dayText:
						tmpTextfield = hourText;
						break;
					case hourText:
						tmpTextfield = minuteText;
						break;
					case minuteText:
						tmpTextfield = secondText;
						break;
				}
				if (tmpTextfield)
				{
					setTextFieldIndex(tmpTextfield);
					tmpTextfield.selectionBeginIndex == 0;
					tmpTextfield.selectionEndIndex == tmpTextfield.text.length;
//					trace ("begin: " + tmpTextfield.selectionBeginIndex + ",end: " + tmpTextfield.selectionEndIndex);
				}
			}
		}
		
		/**
		 * 判断当前输入框是否全部选中
		 * @param obj
		 * @return 
		 * 
		 */		
		private function isSelectAll(obj:TextField):Boolean
		{
			if (obj.selectionBeginIndex == 0 && obj.selectionEndIndex == obj.text.length)
				return true
			return false;
		} 
		private function onChooserChanged(e:CalendarLayoutChangeEvent):void
		{
//			dateTime = _htdc.selectedDate;
			var selDate:Date=_htdc.getSelectedDate();
			if(selDate.time!=dateTime.time){
				dateTime =selDate;
				dispatchEvent(new Event(DATE_TIME_CHANGE));
			}else{
				dateTime =selDate;
			}
			this.maxDate = new Date;
//			onBtnChangeDateClick(null);
		}
		private function onChooserClosed(e:Event):void
		{
			//dateTime = _htdc.selectedDate;
			PopUpManager.removePopUp(_htdc);
			_htdc.visible = false;
			dispatchEvent(new Event(DATE_TIME_CHANGE));
		}
		
		private function onChooserMouseDown(event:MouseEvent):void
		{
			isIn=true;
		}
		
		private function onChooserMouseOver(event:MouseEvent):void
		{
			if(event.localX<0||event.localX>_htdc.width||event.localY<0||event.localY>_htdc.height)
			{
				isIn=false;
			}
		}
		
		private function onChooserFocusChanged(event:MouseEvent):void
		{
			if(stage)
			{
				
				if(_htdc.visible)
				{
					if(!isIn)
					{
						PopUpManager.removePopUp(_htdc);
						_htdc.visible = false;
					}
					else
					{
						if(!this.hitTestPoint(event.stageX,event.stageY,false)&&!_htdc.hitTestPoint(event.stageX,event.stageY,false))
						{
							PopUpManager.removePopUp(_htdc);
							_htdc.visible = false;
						}
					}
				}
			}
			else  //this被关闭
			{
				if(_htdc.visible)
				{
					PopUpManager.removePopUp(_htdc);
					_htdc.visible = false;
				}
			}
		}
		
		private function onBtnChangeDateClick(e:Event):void
		{
			if (!_htdc.visible)
			{
				var tmpDate:Date = new Date;
				var rangeEnd:Date = new Date(tmpDate.fullYear,tmpDate.month,tmpDate.date);
				_htdc.selectableRange = {rangeStart : new Date(1970, 0, 1), rangeEnd : rangeEnd};
				
				_htdc.isEditHmsAble = isEditHmsAble;
 				
				PopUpManager.addPopUp(_htdc,this);
				_htdc.selectedDate = dateTime;
				var p:Point = this.localToGlobal(new Point(0,0));
				if(p.x+_htdc.width>this.stage.stageWidth)
				{
					_htdc.x =p.x-(_htdc.width-width);
				}
				else
				{
					_htdc.x = p.x;
				}
				if (p.y + this.height + _htdc.height < this.stage.stageHeight)
					_htdc.y = p.y + this.height;
				else
					_htdc.y = p.y - _htdc.height;
				_htdc.visible = true;
			}
			else
			{
				_htdc.displayCloseEvent();
			}
			if (null != e)
			e.stopImmediatePropagation();
		}
		
		/**
		 * 设置当前选中的背景色时DateChooser钟的CalendarLayout的是根据 selectableRange计算判断，
		 * 但是计算判断不需要时分秒
		 * 
		 */		
		private function setSelectableRange():void
		{
			var rangeStart:Date = _htdc.selectableRange.rangeStart as Date;
			rangeStart = new Date(rangeStart.fullYear,_minDate.month,_minDate.date);
			var rangeEnd:Date = new Date(_maxDate.fullYear,_maxDate.month,_maxDate.date);
			_htdc.selectableRange = {rangeStart : rangeStart, rangeEnd : rangeEnd};
		}
		
		public function dateFormatter(date:Date,formate:String = null):String{
			var formatter:DateTimeFormatter = new DateTimeFormatter();
			
			formatter.dateTimePattern = formate || "yyyy-MM-dd";
			return formatter.format(date);
		}
		
		/**
		 * 防止时间冒泡，抛出异常 
		 * @param event
		 * 
		 */		
		private function onIndexChange(event:Event):void
		{
			event.stopImmediatePropagation();
		}
		
		private var _htdc:DateChooser = new DateChooser;
		
		
		private var _maxDate:Date;
		private var _minDate:Date = new Date(0);
		private var _dateTime:FLDateTimeInput;
		private var _dateTimeNos:FLDateTimeInputNoS;
		private var _date:Date = new Date;
		
		private var _second:TextField = new TextField;
		private var isIn:Boolean=false;  //检测_htdc的按钮是否按下
		
		private var bProperChanged:Boolean=false;
		public var isShowHS:Boolean = false;
//		private var allowZeroPadding:Boolean=false;
	}
}