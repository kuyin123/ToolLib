package ppf.tool.components.controls
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.engine.DigitCase;
	import flashx.textLayout.formats.TextAlign;
	import ppf.tool.components.controls.LLabel
		
		import mx.core.UIComponent;
	
	import ppf.base.frame.ChartEvent;
	import ppf.base.frame.ChartView;
	import ppf.base.frame.IChartProvider;
	import ppf.base.graphics.ChartCanvas;
	import ppf.base.graphics.IOpSelection;
	import ppf.base.graphics.axis.AxisBase;
	import ppf.base.graphics.axis.AxisTestZ;
	import ppf.base.graphics.axis.AxisX;
	import ppf.base.graphics.axis.AxisXFocus;
	import ppf.base.graphics.axis.AxisY;
	import ppf.base.graphics.axis.AxisZ;
	import ppf.base.graphics.axis.AxisZFocus;
	import ppf.base.graphics.operation.OpSelection;
	import ppf.base.log.Logger;
	import ppf.tool.components.TextFieldUtil;
	
	import spark.components.Button;
	import spark.components.Group;
	import spark.components.HGroup;
	import spark.components.Label;
	import spark.primitives.Graphic;
	
	/**
	 * 统一坐标轴
	 * <br/>1、X/Y轴单位显示字符 xUnit、yUnit
	 * <br/>2、顶部左右显示字符 labeTopL、labeTopR
	 * <br/>3、小数位数 xPrecision、yPrecision
	 * <br/>4、chartCanvas左上右上显示showLR("Y","X");
	 * <br/>5、左下设置按钮showBtnSetting();
	 * <br/>6、清除光标clearOp()
	 * </br></br>默认设置(added by taonengcheng)：</br>
	 * percentWidth=100;</br>
	 * percentHeight=100;</br>
	 * 
	 * @author wangke
	 */	
	public class AxisView extends ChartView
	{
		static public const SETTINGBTN_CLICK_HANDLE:String="settingBtnClick";
		
		public var topBar:Group;
		
		/**
		 * X轴是否显示
		 */
		public function get isXvisible():Boolean
		{
			return _isXvisible;
		}
		
		/**
		 * @private
		 */
		public function set isXvisible(value:Boolean):void
		{
			_isXvisible = value;
		}
		
		/**
		 *是否平移 
		 * @param bool
		 * 
		 */		
		public function set isTranslen(bool:Boolean):void
		{
			_isTranslen=bool;
		}
		/**
		 *旋转角度 
		 * @param value
		 * 
		 */		
		public function set rotateAngle(value:Number):void
		{
			_rotateangle=value;
		}
		/**
		 * 设置顶部左字符 
		 * @param str_L
		 * @param str_R
		 * @return 
		 * 
		 */		
		public function set labeTopL(str:String):void
		{
			if(null==str)
				return;
			createTF_Top_L();
			if (_tf_top_l.text != str)
			{
				if ("" == _tf_top_l.text)
					invalidateDisplayList();
				_tf_top_l.text = str;
				_tf_top_l.toolTip=str;
			}
		}
		/**
		 * 设置顶部右字符  
		 * @param str_R
		 * @return 
		 * 
		 */		
		public function set labeTopR(str:String):void
		{
			if(null==str)
				return;
			createTF_Top_R();
			if (_tf_top_r.text != str)
			{
				if ("" == _tf_top_r.text)
					invalidateDisplayList();
				_tf_top_r.text = str;
				_tf_top_r.toolTip=str;
			}
		}
		/**
		 * 设置顶部中间字符  
		 * @param str_R
		 * @return 
		 * 
		 */		
		public function set labeTopCenter(str:String):void
		{
			if(null==str)
				return;
			createTF_Top_Center();
			if (_tf_top_center.text != str)
			{
				if ("" == _tf_top_center.text)
					invalidateDisplayList();
				_tf_top_center.text = str;
				_tf_top_center.toolTip=str;
				//				_tf_top_center.setTextFormat(TextFieldUtil.CreateFormatCenter(true));
			}
		}
		/**
		 * 每两个刻度文字之间允许有sub_step条刻度线
		 * @param substep
		 * 
		 */		
		public function set XSubStepNumber(substep:int):void
		{
			_xsub_step=substep;
		}
		
		public function set Xsub_Step(substep:int):void
		{
			_xsub_step=substep;
		}
		
		//		/**
		//		 *是否是波形频谱图 
		//		 */	
		//		public function set scaleNumUchanged(isbool:Boolean):void
		//		{
		//			_scaleNumUchanged=isbool;
		//		}
		/**
		 * 显示ChartCanvas左上角与右上角字符
		 * @param str_l
		 * @param str_r
		 * 
		 */		
		public function showLR(str_l:String="Y",str_r:String="X"):void
		{
			if (null == _tf_l && null == _tf_r)
			{
				_shape_LR = new Shape;
				this.addChild(_shape_LR);
				
				_tf_l = TextFieldUtil.TextFieldCenter();
				_tf_l.text = str_l;
				_tf_l.textColor = TEXT_COLOR;
				_tf_l.setTextFormat(TextFieldUtil.CreateFormatCenter());
				_tf_l.backgroundColor=BG_COLOR;
				_tf_l.background=true;
				this.addChild(_tf_l);
				
				_tf_r = TextFieldUtil.TextFieldCenter();
				_tf_r.text = str_r;
				_tf_r.textColor = TEXT_COLOR;
				_tf_r.setTextFormat(TextFieldUtil.CreateFormatCenter());
				_tf_r.backgroundColor=BG_COLOR;
				_tf_r.background=true;
				this.addChild(_tf_r);
				
				moveTF_LR();
			}
		}
		
		public function showBtnSetting():void
		{
			if (null == _btn_setting)
			{
				_btn_setting = new Button;
				_btn_setting.width = 20;
				_btn_setting.height = 20;
				this.addChild(_btn_setting);
				
				moveBtn_Setting();
				_btn_setting.addEventListener(MouseEvent.CLICK,_btn_settting_clickHandler);		
			}
		}
		
		private function _btn_settting_clickHandler(event:MouseEvent):void{
			var p:Point=localToGlobal(new Point(_btn_setting.x,_btn_setting.y));
			this.dispatchEvent(new MouseEvent(SETTINGBTN_CLICK_HANDLE,true,false,p.x,p.y));
		}
		/**
		 * 设置X的单位 
		 * @param unit 单位名
		 * 
		 */		
		public function set xUnit(str:String):void
		{
			createAxisX();
			_axisX.unitName = str;
			_axisX.updateAxis();
		}
		/**
		 * 设置Y的单位  
		 * @param str
		 * 
		 */		
		public function set yUnit(str:String):void
		{
			if(null==str)
				return;
			createTF_UnitNameY();
			if (_unitNameY.text != str)
			{
				if ("" == _unitNameY.text)
					invalidateDisplayList();
				_unitNameY.text = str;
				_unitNameY.setTextFormat(TextFieldUtil.CreateFormatRight(true));
				createAxisY();
				_axisY.axisName = str;
			}
		}
		
		public function set zUnit(str:String):void
		{
			_axisZ.unitName = str;
			_axisZ.updateAxis();
		}
		
		public function set spUnit(str:String):void
		{
			if(null==str)
				return;
			createTF_UnitNameSp();
			_unitName_Sp.text=str;
			_unitName_Sp.setTextFormat(TextFieldUtil.CreateFormatRight(true));
			createAxisSp();
			_axisSpeed.axisName=str;
			_axisSpeed.unitName=str;
		}
		//		/**
		//		 * 设置X的小数点位数 
		//		 * @param precision
		//		 * 
		//		 */		
		//		public function set xPrecision(precision:Number):void
		//		{
		//			_axisX.precision_Num = precision;
		//		}
		//		/**
		//		 * 设置Y的小数点位数 
		//		 * @param precision
		//		 * 
		//		 */	
		//		public function set yPrecision(precision:Number):void
		//		{
		//			createAxisY();
		//			_axisY.precision_Num = precision;
		//		}
		
		/**
		 * 设置Z的小数点位数
		 */ 
		//		public function set zPrecision(precision:Number):void
		//		{
		//			_axisZ.precision_Num=precision;
		//		}
		
		public function get axisXFocus():AxisXFocus
		{
			return _axisXFocus;
		}
		
		public function get axisZFocus():AxisZFocus
		{
			return _axisZFocus;
		}
		/**
		 * 光标 
		 */
		public function get opSelection():IOpSelection
		{
			return _opSelection;
		}
		public function set opSelection(value:IOpSelection):void
		{
			_opSelection = value;
		}
		
		public function get chartCanvas():ChartCanvas
		{
			if (null == _chartCanvas)
				_chartCanvas = new ChartCanvas;
			return _chartCanvas;
		}
		
		/**
		 * Y轴 
		 */
		public function get axisY():AxisBase
		{
			return _axisY;
		}
		
		public function set axisY(value:AxisBase):void
		{
			_axisY=value;
		}
		
		/**
		 * X轴 
		 */
		public function get axisX():AxisX
		{
			return _axisX;
		}
		
		/**
		 * Z轴
		 */ 
		public function get axisZ():AxisTestZ
		{
			return _axisZ;
		}
		/**
		 * 
		 */
		public function get axisSpeed():AxisZ
		{
			return _axisSpeed;
		}
		
		/**
		 * 设置Z轴是否可见
		 */
		public function set isZvisible(isvisible:Boolean):void
		{
			_isZvisible=isvisible;
			if(_axisZ!=null)
			{
				_axisZ.visible=isvisible;
			}
		}
		
		/**
		 * 
		 */
		public function get isZvisible():Boolean
		{
			return _isZvisible;
		}
		
		/**
		 * 
		 */
		public function set isSpVisible(isvisible:Boolean):void
		{
			_isSpVisible=isvisible;
			if(axisSpeed!=null)
				axisSpeed.visible=_isSpVisible;
		}
		public function get isSpVisible():Boolean
		{
			return _isSpVisible;
		}
		
		public function get useXFocus():Boolean
		{
			return _useXFocus;
		}
		
		public function set useXFocus(value:Boolean):void
		{
			_useXFocus = value;
		}
		/**
		 *ChartCanvas是否为正方形 
		 * 默认值为false
		 */		
		public function set isSquare(value:Boolean):void{
			_isSquare=value;
		}
		/**
		 *ChartCanvas是否为正方形 
		 */	
		public function get isSquare():Boolean
		{
			return _isSquare;
		}
		
		public function get whGap():Number
		{
			return _whGap;
		}
		/**
		 * 清除光标 
		 * 
		 */		
		public function clearOp():void
		{
			if (_opSelection)
				_opSelection.setSelPos(Number.NEGATIVE_INFINITY);
		}
		
		/**
		 * 释放资源 
		 */	
		override public function dispose():void
		{
			super.dispose();
			if (null != _btn_setting)
				_btn_setting.removeEventListener(MouseEvent.CLICK,_btn_settting_clickHandler);
			if (null != _opSelection)
				_opSelection.removeEventListener(OpSelection.EVENT_SELECT_CHANGED,onUpdateSelect);
			
			_tf_top_l = null;
			_tf_top_r = null;
			_tf_top_center = null;
			_unitName_Sp = null;
			_axisX = null;
			_axisY = null;
			_axisZ = null;
			_axisSpeed = null;
			_chartCanvas = null;
			_opSelection = null;
			_axisXFocus = null;
			_axisZFocus = null;
			_tf_l = null;
			_tf_r = null;
			_shape_LR = null;
			_btn_setting = null;
			_hitAreaSprite = null;
		}
		
		public function AxisView(value:IChartProvider = null)
		{
			super(value);
		}
		
		override protected function createChildren():void
		{
			// init Canvas
			if (null == _chartCanvas)
				_chartCanvas = new ChartCanvas;
			_chartCanvas.percentWidth = 100;
			_chartCanvas.percentHeight = 100;
			this.addChildAt(_chartCanvas,0);
			_chartCanvas.enableZoom = true;
			_chartCanvas.enableZoomY = false;
			
			// init UnitNameY
			createTF_UnitNameY();
			this.addChild(_unitNameY);
			
			// init Top
			createTF_Top_L();
			this.addChild(_tf_top_l);
			createTF_Top_R();
			this.addChild(_tf_top_r);
			createTF_Top_Center();
			this.addChild(_tf_top_center);
			
			if (null != topBar)
				this.addChild(topBar);
			
			// init Axis
			createAxisX();
			addChild(_axisX);
			_axisX.visible = _isXvisible;
			_axisX.chartBox = _chartCanvas;
			
			createAxisY();
			if(_axisY){
				this.addChild(_axisY);
				_axisY.chartBox = _chartCanvas;
			}
			
			if(isZvisible)
			{
				createAxisZ();
				this.addChild(_axisZ);
				_axisZ.chartBox = _chartCanvas;
			}
			
			// init 单位 转速
			if(isSpVisible)
			{
				createAxisSp();
				createTF_UnitNameSp();
				this.addChild(_axisSpeed);
				this.addChild(_unitName_Sp);
				_axisSpeed.chartBox=_chartCanvas;
			}
			
			// init 光标
			if (null == _opSelection)
				_opSelection = new OpSelection(_chartCanvas,true);
			else
			{// 可能外部创建了自由的Selection
				_opSelection.parentCanvas = _chartCanvas;
				_opSelection.useKeyboard = true;
			}
			_chartCanvas.frontDrawers.addChild(_opSelection as DisplayObject);
			_opSelection.addEventListener(OpSelection.EVENT_SELECT_CHANGED,onUpdateSelect, false, 0, true);
			
			// X刻度的光标
			if(_useXFocus)
				createaxisXFocus();
			
			// Z刻度的光标
			if(isZvisible)
				createaxisZFocus();
			
			//加入点击区域
			_hitAreaSprite = new Sprite;
			_hitAreaSprite.visible = false;
			this.addChild(_hitAreaSprite);
			this.hitArea = _hitAreaSprite;
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			if (null == _hitAreaSprite)
			{
				Logger.debug("AxisView2::updateDisplayList _hitAreaSprite is null createChildren has error");
				return;
			}
			if(_isTranslen)
				_translen =chartCanvas.height*Math.tan(10*Math.PI/180);
			else
				_translen=0;
			_unitNameY.y = BORDE_GAP;//设置y轴单位的位置
			//			_unitName_Sp.y=BORDE_GAP;//设置转速的单位的位置
			
			if (_axisY && _axisY.width > 10)
				WIDTH = _axisY.width;
			if (_axisX.height > 10)
				HEIGHT = _axisX.height;
			
			_axisY.x = BORDE_GAP+_translen;
			
			_unitNameY.x = WIDTH - _unitNameY.textWidth + BORDE_GAP+_translen;
			
			var maxHeight:Number;
			if (null != topBar)
			{// 如果有顶部条，则不显示设置的文字了
				maxHeight = Math.max(_unitNameY.textHeight, topBar.height);
				if(isSpVisible && null != _unitName_Sp)
					maxHeight = Math.max(maxHeight,_unitName_Sp.textHeight);
				_axisY.y = _unitNameY.y + maxHeight + GAP;
			}
			else	if ("" != _unitNameY.text ||"" != _tf_top_l.text ||"" != _tf_top_r.text ||"" != _tf_top_center.text || (null != _unitName_Sp && "" != _unitName_Sp.text && isSpVisible))
			{// 如果设置了文字
				maxHeight = Math.max(_unitNameY.textHeight,_tf_top_l.height);
				if(isSpVisible && null != _unitName_Sp)
					maxHeight = Math.max(maxHeight,_unitName_Sp.textHeight);
				_axisY.y = _unitNameY.y + maxHeight + GAP;
			}
			else
				_axisY.y = BORDE_GAP;
			
			_tf_top_l.x = _axisY.x + WIDTH + GAP;
			_tf_top_l.y = _unitNameY.y-GAP+2
			_chartCanvas.x = _tf_top_l.x;
			_chartCanvas.y = _axisY.y;
			
			if ("" != _unitNameY.text ||"" != _tf_top_l.text ||"" != _tf_top_r.text || "" != _tf_top_center.text || (null != _unitName_Sp && "" != _unitName_Sp.text && isSpVisible))
				_chartCanvas.height = unscaledHeight - _axisX.height - maxHeight - 2*BORDE_GAP;
			else
				_chartCanvas.height = unscaledHeight - _axisX.height - 2*BORDE_GAP;
			
			if (!_isXvisible)
				_chartCanvas.height += _axisX.height;
			
			if(_isZvisible&&!_isSpVisible)
			{
				_chartCanvas.width = unscaledWidth - WIDTH - 2*BORDE_GAP-_axisZ.width;
			}
			else if(_isSpVisible&&!_isZvisible)
			{
				_chartCanvas.width=unscaledWidth - WIDTH - 2*BORDE_GAP;
			}
			else if(_isSpVisible&&_isZvisible)
			{
				_chartCanvas.width = unscaledWidth - WIDTH - GAP - 2*BORDE_GAP;
			}
			else
			{
				_chartCanvas.width = unscaledWidth - WIDTH - 2*BORDE_GAP - _translen;
			}
			
			if (null != topBar)
			{
				topBar.x = _axisY.x + WIDTH + GAP;
				topBar.y = _unitNameY.y;
				topBar.height = _unitNameY.textHeight;
				topBar.width = _chartCanvas.width;
			}
			
			/*加入的代码*/
			if(_isSquare)
			{
				if(_chartCanvas.width<_chartCanvas.height)
					_chartCanvas.height=_chartCanvas.width;
				else
					_chartCanvas.width=_chartCanvas.height;
			}
			
			_axisX.x = BORDE_GAP + WIDTH + GAP;//_axisY.width;//_chartCanvas.x;
			_axisX.y = _chartCanvas.y + _chartCanvas.height;
			if(_isSpVisible)
				_axisX.width = unscaledWidth - _axisX.x - _translen - _axisSpeed.width - BORDE_GAP;
			else
				_axisX.width = _chartCanvas.width;
			
			_chartCanvas.x = _axisX.x;//计算canvas的水平位置
			_axisY.height = _chartCanvas.height;
			
			if(_isZvisible&&!_isSpVisible)
			{
				//				_axisZ.height= 150;//设置Z轴的高度
				//				_axisZ.x=_chartCanvas.x+_chartCanvas.width - _translen+20;
				_axisZ.x=_chartCanvas.x+_chartCanvas.width + _translen + 20;
				_axisZ.y=_chartCanvas.height-_axisZ.height+_chartCanvas.y;
				_axisZ.height=_chartCanvas.height*0.3;
			}
			if(_isSpVisible)
			{
				//				_axisSpeed.x=_chartCanvas.x+_chartCanvas.width+GAP + _translen - BORDE_GAP;
				_axisSpeed.x=_axisX.x+_axisX.width + _translen;
				_axisSpeed.y=_chartCanvas.y;
				_axisSpeed.height=_chartCanvas.height;
			}
			if(_isZvisible&&_isSpVisible)
			{
				_axisZ.height= _chartCanvas.height*0.3;//设置Z轴的高度
				//				_axisZ.x=_chartCanvas.x+_chartCanvas.width+_axisSpeed.width+Math.abs( _axisZ.height*Math.tan(_rotateangle));
				//				_axisZ.x=_chartCanvas.x+_chartCanvas.width+Math.abs( _axisZ.height*Math.tan(_rotateangle));
				_axisZ.x = _axisX.x + _axisX.width + Math.abs( _axisZ.height*Math.tan(_rotateangle)) + _axisSpeed.width + GAP;
				_axisZ.y=_chartCanvas.height-_axisZ.height+_chartCanvas.y;
			}
			
			//设置chartCanvas上方的字符（左 中 右 Label）
			_tf_top_r.y = _tf_top_l.y+5
			_tf_top_center.y = _tf_top_l.y+5
			var lblWidth:Number;
			if(_tf_top_center.text=="")
			{
				lblWidth=(_chartCanvas.width-GAP)/2;
				_tf_top_r.x = _chartCanvas.x+lblWidth-GAP;
				_tf_top_center.width=0;
			}
			else
			{
				lblWidth=(_chartCanvas.width-2*GAP)/3;
				_tf_top_r.x = _chartCanvas.x +2*lblWidth-2*GAP;
				_tf_top_center.x = _chartCanvas.x+lblWidth-GAP;
				_tf_top_center.width=lblWidth;
			}
			_tf_top_l.width=lblWidth;
			_tf_top_r.width=lblWidth;
			
			_whGap=getWHGap();
			if(isSpVisible && null!=_unitName_Sp)
			{
				_unitName_Sp.visible = true;
				_unitName_Sp.x=_axisSpeed.x;//设置转速单位的位置
				_unitNameY.y = BORDE_GAP;//设置y轴单位的位置
			}
			else if(null!=_unitName_Sp)
				_unitName_Sp.visible = false;
			
			if (null != _btn_setting)
			{
				moveBtn_Setting();
			}
			
			if (null != _tf_l && null != _tf_r && null !=_tf_top_center)
			{
				moveTF_LR();
			}
			if (isSquare)
			{
				var tx:Number,ty:Number;
				ty = (unscaledHeight - axisX.y-axisX.height-2*BORDE_GAP)*0.5;
				if(_isZvisible)
				{
					tx = (unscaledWidth - axisZ.x-axisZ.width-2*BORDE_GAP)*0.5;
				}
				else if (_isSpVisible)
				{
					tx = (unscaledWidth - axisSpeed.x-axisSpeed.width-2*BORDE_GAP)*0.5;
				}
				else
				{
					tx = (unscaledWidth - chartCanvas.x-chartCanvas.width-2*BORDE_GAP)*0.5;
				}
				moveObj(_unitNameY,tx,ty);
				moveObj(_tf_l,tx,ty);
				moveObj(_tf_r,tx,ty);
				moveObj(_tf_top_l,tx,ty);
				moveObj(_tf_top_r,tx,ty);
				moveObj(_tf_top_center,tx,ty);
				moveObj(axisX,tx,ty);
				moveObj(axisY,tx,ty);
				moveObj(chartCanvas,tx,ty);
				moveObj(_btn_setting,tx,ty);
				
				if(_isSpVisible)
					moveObj(axisSpeed,tx,ty);
				if(_isZvisible)
					moveObj(axisZ,tx,ty);
				
			}
			drawBackground(unscaledWidth,unscaledHeight);
			
		}
		private function moveObj(obj:DisplayObject,x:Number,y:Number):void
		{
			if (null != obj)
			{
				obj.x += x;
				obj.y += y;
			}
		}
		
		private function drawBackground(w:Number,h:Number):void
		{
			var g:Graphics = _hitAreaSprite.graphics;
			g.clear();
			g.beginFill(0xFFFFFF, 0);
			g.drawRect(0, 0, w, h);
			g.endFill();
		}
		
		private function moveBtn_Setting():void
		{
			if (null != _axisX)
			{
				_btn_setting.x = BORDE_GAP;
				_btn_setting.y = _axisX.y + GAP;
			}
		}
		
		/**
		 * 移动chartCanvas左上和右上角字符坐标 
		 * 
		 */		
		private function moveTF_LR():void
		{
			if (null != _chartCanvas)
			{
				_tf_l.x = _chartCanvas.x+_chartCanvas.borderWidth;
				_tf_l.y = _chartCanvas.y+_chartCanvas.borderWidth;
				//_tf_l.graphics
				_tf_r.x = _chartCanvas.x + _chartCanvas.width - _tf_r.width-_chartCanvas.borderWidth;
				_tf_r.y = _chartCanvas.y+_chartCanvas.borderWidth;
				//				if(_tf_top_center)
				//				{
				//					_tf_top_center.x = _chartCanvas.x + _chartCanvas.width/2 - _tf_top_center.width/2 - _chartCanvas.borderWidth;
				//					_tf_top_center.y = _chartCanvas.y + _chartCanvas.borderWidth;
				//				}
			}
		}
		
		private function onUpdateSelect(event:Event):void
		{
			dispatchEvent(new ChartEvent(ChartEvent.POINT_CHANGED,true));
		}
		
		private function createTF_UnitNameY():void
		{
			if (null == _unitNameY)
			{
				_unitNameY = TextFieldUtil.TextFieldRight(true);
				_unitNameY.width = WIDTH;
				_unitNameY.height = HEIGHT;
			}
		}
		private function createTF_UnitNameSp():void
		{
			if(null==_unitName_Sp)
			{
				_unitName_Sp=TextFieldUtil.TextFieldRight();
				_unitName_Sp.width=WIDTH;
				_unitName_Sp.height=HEIGHT;
			}
		}
		private function createTF_Top_L():void
		{
			if (null == _tf_top_l)
			{
				_tf_top_l=new LLabel;
				_tf_top_l.height = 18;
				
				//				_tf_top_l.maxDisplayedLines=1;
				_tf_top_l.setStyle('verticalAlign','middle');
				_tf_top_l.setStyle("fontWeight","bold");
			}
		}
		private function createTF_Top_R():void
		{
			if (null == _tf_top_r)
			{
				_tf_top_r=new Label;
				_tf_top_r.height = 15;
				_tf_top_r.maxDisplayedLines=1;
				_tf_top_r.setStyle("textAlign",TextAlign.RIGHT);
				_tf_top_r.setStyle('verticalAlign','middle');
				//				_tf_top_r.setStyle("fontWeight","bold");
				_tf_top_r.setStyle("paddingRight",1);
			}
		}
		private function createTF_Top_Center():void
		{
			if(null == _tf_top_center)
			{
				_tf_top_center=new Label;
				_tf_top_center.height = 13;
				_tf_top_center.maxDisplayedLines=1;
				_tf_top_center.setStyle("textAlign",TextAlign.CENTER);
				//				_tf_top_center.setStyle("fontWeight","bold");
			}
		}
		
		protected function createAxisX():void
		{
			if (null == _axisX)
			{
				_axisX = new AxisX;
				_axisX.subStepNumber=_xsub_step;
				_axisX.height = HEIGHT;
				_axisX.percentWidth= 100;
			}
		}
		
		protected function createAxisY():void
		{
			if (null == _axisY)
			{
				_axisY = new AxisY;
				_axisY.width = WIDTH;
				_axisY.minWidth = WIDTH;
				_axisY.percentHeight = 100;
			}
		}
		
		private function createAxisZ():void
		{
			if(null==_axisZ)
			{
				_axisZ = new AxisTestZ;
				_axisZ.width = WIDTHZ;
				_axisZ.height = 100;
				//				_axisZ.enableOperator=false;
			}
		}
		private function createAxisSp():void
		{
			if(null==_axisSpeed)
			{
				_axisSpeed = new AxisZ;
				_axisSpeed.width = WIDTH;
				_axisSpeed.percentHeight = 100;
				_axisSpeed.isSpeed=true;
				_axisSpeed.bUseBitmap=true;
			}
		}
		
		private function createaxisXFocus():void
		{
			if (null == _axisXFocus && null != _opSelection)
			{
				//X刻度上的选中游标对象
				_axisXFocus = new AxisXFocus(_opSelection);
				_axisX.addElement(_axisXFocus);
				//				_axisX.isShowTime = false;
				_axisX.isShowMillisecond = false;
			}
			else
				Logger.debug("AxisView2::createaxisXFocus opSelection is null");
		}
		
		private function createaxisZFocus():void
		{
			if(null==_axisZFocus&&null!=_opSelection)
			{
				//Z刻度上的刻度游标
				_axisZFocus = new AxisZFocus(_opSelection,_chartCanvas,_axisZ);
				_axisZ.addElement(_axisZFocus);
				_axisZ.isShowTime = false;
				_axisZ.isShowMillisecond = false;
			}
		}
		
		private function getWHGap():Number
		{
			var w:Number=_chartCanvas.x-_axisY.x+chartCanvas.width+2*BORDE_GAP+_translen;
			var h:Number=_axisX.y-_chartCanvas.y+_axisX.height;
			if ("" != _unitNameY.text ||"" != _tf_top_l.text ||"" != _tf_top_r.text)
			{
				var maxHeight:Number = Math.max(_unitNameY.textHeight,_tf_top_l.height);
				maxHeight = Math.max(maxHeight,_tf_top_r.height);
				h=h+ maxHeight +GAP+2*BORDE_GAP;
			}
			else
			{
				h=h+ 2*BORDE_GAP;
			}
			
			if(isZvisible||isSpVisible)
			{
				w=w+WIDTH;
			}
			return w-h;	
		}
		/*背景色*/
		private const BG_COLOR:uint=0xEBEBEB;
		/*文本颜色*/
		private const TEXT_COLOR:uint=0xFF0000;
		/**
		 * Y轴单位 
		 */		
		private var _unitNameY:TextField;
		/**
		 * 顶部 左边显示字符 
		 */		
		private var _tf_top_l:LLabel;
		/**
		 * 顶部右边显示字符
		 */		
		private var _tf_top_r:Label;
		/**
		 *顶部中间字符 
		 */		
		private var _tf_top_center:Label;
		/**
		 * 设置速度轴的单位
		 */ 
		private var _unitName_Sp:TextField;
		/**
		 * X轴 
		 */
		protected var _axisX:AxisX;
		/**
		 * Y轴 
		 */
		protected var _axisY:AxisBase;
		/**
		 * Z轴
		 */ 
		private var _axisZ:AxisTestZ;
		/**
		 * 转速轴
		 */ 
		private var _axisSpeed:AxisZ;//AxisSpeed;
		
		private var _chartCanvas:ChartCanvas;
		
		/**
		 * 光标 
		 */
		private var _opSelection:IOpSelection;
		/**
		 * X轴显示标注
		 */ 
		private var _axisXFocus:AxisXFocus;
		/**
		 * Z轴显示标注
		 */ 
		private var _axisZFocus:AxisZFocus;
		/**
		 * chartCanvas左上显示 
		 */		
		private var _tf_l:TextField;
		/**
		 * chartCanvas 右上显示 
		 */		
		private var _tf_r:TextField;
		/**
		 *  
		 */		
		private var _shape_LR:Shape;
		
		/**
		 * 左下设置按钮 
		 */		
		private var _btn_setting:Button;
		/**
		 * X轴是否显示
		 */
		private var _isXvisible:Boolean=true;
		/**
		 * Z轴是否显示
		 */
		private var _isZvisible:Boolean=false;
		/**
		 * 转速轴是否显示
		 */ 
		private var _isSpVisible:Boolean=false;
		
		private var  _hitAreaSprite:Sprite;
		/**
		 * 旋转之后平移量
		 */ 
		private var _translen:Number = 0;
		/**
		 * 是否平移
		 */ 
		private var _isTranslen:Boolean = false;
		/**
		 *ChartCanvas是否显示为正方形 
		 */		
		private var _isSquare:Boolean=false;
		
		private var _whGap:Number=0;
		/**
		 * 旋转角度
		 */
		private var _rotateangle:Number=0;
		/**
		 *每两个刻度文字之间允许有sub_step条刻度线 
		 */		
		private var _xsub_step:int = 5;
		/**
		 * 是否固定刻度数 
		 */		
		private var _scaleNumUchanged:Boolean=false;
		
		private var _useXFocus:Boolean=true;
		
		/**
		 * 边框间隙 
		 */		
		protected const BORDE_GAP:Number = 10;
		/**
		 * 统一间隙 
		 */		
		protected const GAP:Number = 3;
		
		protected var WIDTH:Number = 40;
		
		protected var WIDTHZ:Number = 70;
		protected var HEIGHT:Number = 25;
	}
}