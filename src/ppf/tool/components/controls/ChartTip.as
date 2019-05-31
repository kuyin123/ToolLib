package ppf.tool.components.controls
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;
	
	import mx.collections.ArrayCollection;
	import mx.controls.listClasses.ListBase;
	import mx.core.IVisualElementContainer;
	import mx.core.UIComponent;
	import mx.core.UITextField;
	
	import ppf.base.graphics.ChartCanvas;
	import ppf.base.graphics.ChartColor;
	import ppf.base.graphics.ChartRect;
	import ppf.tool.components.views.ChartTip;
	

	dynamic public class ChartTip extends ppf.tool.components.views.ChartTip
	{
		static public const EVENT_CLOSED:String = "tip_closed";
		
		/**
		 * tip的类 
		 */		
		public var classPath:String="";
		
		public var isTop:Boolean = false;
		/**
		 * tip是否已关闭 true：已关闭 false：未关闭 
		 */		
		public var isClose:Boolean = false;

		/**
		 * 显示tip箭头点的标志 true：显示 false：不显示 
		 * @return 
		 * 
		 */		
		public function get isShowArrowPoint():Boolean
		{
			return _isShowArrowPoint;
		}
		public function set isShowArrowPoint(value:Boolean):void
		{
			_isShowArrowPoint = value;
		}

		public function get isMouseOn():Boolean
		{
			setMouseOut();
			return _isMouseOn;
		}

		public function get arrow_dh():int
		{
			return _arrow_dh;
		}

		public function set arrow_dh(value:int):void
		{
			_arrow_dh = value;
		}

		public function get arrow_dw():int
		{
			return _arrow_dw;
		}

		public function set arrow_dw(value:int):void
		{
			_arrow_dw = value;
		}
		/**
		 * 数据坐标点
		 * @return 
		 * 
		 */
		public function get arrowPoint():Point
		{
			return _arrowPoint;
		}

		public function set arrowPoint(value:Point):void
		{	
			if (_unit_name != "*")
				_chartCanvas.currentAxis = _unit_name;	
			var arrowWorldPoint:Point;
			
			if (_isShowArrowPoint)
			{
				arrowWorldPoint = _chartCanvas.localToWorld(new Point(0, _chartCanvas.height * 0.5));
				_arrowPoint = new Point(value.x, arrowWorldPoint.y);
				_arrowLocal = _chartCanvas.worldToLocal(_arrowPoint);
				_vector = new Point(0, this.height * 0.5);
			}
			else
			{
				_arrowPoint = new Point(value.x, value.y);
				_arrowLocal = _chartCanvas.worldToLocal(_arrowPoint);
				_vector = new Point(0, 0);
			}
			_chartCanvas.currentAxis = "*";
			
			_setStyle();
		}
		
		public function get unit_name():String
		{
			return _unit_name;
		}

		public function set unit_name(value:String):void
		{
			_unit_name = value;
		}

		/**
		 * tip显示的数据 
		 * @return 
		 * 
		 */
		public function get tipData():Object
		{
			return _tipData;
		}
		
		public function set tipData(value:Object):void
		{
			_tipData = value;
			
			_currDisplayObject = formatMSG(value);
			box.removeAllChildren();
			box.addChild(_currDisplayObject);
		}
		
		//============构造函数============
		public function ChartTip(c:ChartCanvas)
		{                        
			super();
			_chartCanvas = c;
			minWidth = 100;
			_chartCanvas.addEventListener(ChartCanvas.EVENT_MATRIX_CHANGED, onMatrixChanged, false, 0,true);
		}
		
		/**
		 * 坐标轴改变，刷新tip的数据坐标点
		 * 
		 */		
		public function updateArrowPoint():void
		{
			if (_isShowArrowPoint)
			{
				if (_unit_name != "*")
					_chartCanvas.currentAxis = _unit_name;
				
				_arrowPoint = _chartCanvas.localToWorld(new Point(_arrowLocal.x, _arrowLocal.y));
				_chartCanvas.currentAxis = null;
			}
			setArrowLocation();
		}
		
		/**
		 * 将组件移动到其父项内的指定位置。
		 * @param x 组件在其父项内的左侧位置。
		 * @param y 组件在其父项内的顶部位置。 
		 * 
		 */		
		override public function move(x:Number, y:Number):void
		{
			super.move(x,y);
			
			if (_unit_name != "*")
				_chartCanvas.currentAxis = _unit_name;
			
			if (_isShowArrowPoint)
			{
				var tmpP:Point = _chartCanvas.localToWorld(new Point(x, y + this.height * 0.5));
				
				_vector = new Point(x - _arrowLocal.x, - this.height * 0.5);
				_arrowPoint = new Point(_arrowPoint.x, tmpP.y);
				_arrowLocal = _chartCanvas.worldToLocal(_arrowPoint);
			}
			_chartCanvas.currentAxis = null;
			
			if (!isMatrixChanged)
			{
				_setStyle();
			}
			isMatrixChanged = false;
		}
		
		protected var _frontSprite:Sprite = new Sprite;
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
		{
			_setStyle();
			super.updateDisplayList(unscaledWidth, unscaledHeight);
		}
		
		override protected function createChildren() : void
		{
			super.createChildren();
			this.addEventListener(MouseEvent.MOUSE_OVER, onBoxTitleMouse);
			this.addEventListener(MouseEvent.MOUSE_OUT, onBoxTitleMouse);
			this.addEventListener(MouseEvent.ROLL_OUT, onBoxTitleMouse, false, 0, true);
			
			if (isShowCloseBtn)
				_chartCanvas.frontDrawers.addChild(_frontSprite);
		}
		protected function onMatrixChanged(event:Event):void
		{
			isMatrixChanged = true;
			_setStyle();
		}
		
		override protected function btn_Close_clickHandler(event:MouseEvent):void
		{
			if (isShowCloseBtn)
				_chartCanvas.frontDrawers.removeChild(_frontSprite);
			
			var tmpParent:UIComponent = this.parent as UIComponent;
			if (tmpParent && tmpParent.contains(this))
			{
//				FLEX_TARGET_VERSION::flex4
//				{
					(tmpParent as IVisualElementContainer).removeElement(this);
//				}
//				FLEX_TARGET_VERSION::flex3
//				{
//					tmpParent.removeChild(this);
//				}
				isClose = true;
			}
			
			event.stopImmediatePropagation();
			
			this.dispatchEvent(new Event(EVENT_CLOSED));
		}
		protected function setMouseOut():void
		{
			if (stage)
			{
				if (_isDown || _isMove)
					return;
				if (hitTestPoint(stage.mouseX, stage.mouseY, true))
					return;
			}
			this.removeEventListener(MouseEvent.MOUSE_DOWN, onBoxTitleMouse);
			_isMouseOn = false;
		}
		
		/**
		 *  
		 * 设置外观
		 */		
		private function _setStyle():void
		{
			setLocation();	
			
			if (this.x != _arrowLocal.x + _vector.x || this.y != _arrowLocal.y + _vector.y)
			{
				this.x = _arrowLocal.x + _vector.x;
				this.y = _arrowLocal.y + _vector.y;
			}
			
			if (_isShowArrowPoint)
			{
				setArrowLocation();
			}
			
		}
		
		private function setArrowLocation():void
		{
			if(stage != null)
			{
				//本方法只有当本实例位于舞台的显示列表中时才起作用 
				var arArrow:Array=_calcArrowLocation();
				graphics.clear();
				
				if (isShowCloseBtn)
					drawColumnLine();
				
				this.graphics.lineStyle(2,0x000000);
				
				//画外框
				graphics.beginFill(0xFFFFFF,1);
				graphics.drawRoundRect(0, 0, width, height, 5, 5);
				graphics.endFill();
				
				this.graphics.lineStyle(0,0x000000);
				//三角
				graphics.beginFill(0xFFFFFF,1);
				graphics.moveTo(arArrow[0], arArrow[1]);
				graphics.lineTo(arArrow[2], arArrow[3]);
				graphics.lineTo(arArrow[4], arArrow[5]);
				graphics.endFill();
				
				if (_isShowArrowPoint)
				{
					graphics.beginFill(0xFFFFFF,1);
					graphics.drawCircle(arArrow[4], arArrow[5], 3);
					graphics.endFill();
				}
			}
		}
		
		/**
		 * 画当前光标所在的竖线
		 * 
		 */		
		private function drawColumnLine():void
		{
			_frontSprite.graphics.clear();
			
			var r:ChartRect = _chartCanvas.extent;
			var p0 : Point = new Point (_arrowPoint.x, r.top);
			var p1 : Point = new Point (_arrowPoint.x, r.bottom);
			p0 = _chartCanvas.worldToLocal(p0);
			p1 = _chartCanvas.worldToLocal(p1);
			_frontSprite.graphics.lineStyle(0, ChartColor.tipLine);
			_frontSprite.graphics.moveTo(p0.x, p0.y);
			_frontSprite.graphics.lineTo(p1.x, p1.y);
			
			if (!(_tipData is Array))
				return;
			for each (var item:Object in _tipData as Array)
			{
				var wordP:Point = new Point(item.x,item.y);
				_chartCanvas.currentAxis = item.unitName;
				var locP:Point = _chartCanvas.worldToLocal(wordP);
				_chartCanvas.currentAxis = null;
				
				_frontSprite.graphics.lineStyle(2, ChartColor.tipLine);
				_frontSprite.graphics.beginFill(ChartColor.tipLine);
				_frontSprite.graphics.drawCircle (locP.x, locP.y, 3);
				_frontSprite.graphics.endFill();
			}
		}
		
		/**
		 * 计算箭头的位置 
		 * @return 
		 * 
		 */		
		private function _calcArrowLocation():Array
		{
			if (_unit_name != "*")
				_chartCanvas.currentAxis = _unit_name;
			var tmpPoint:Point = this.globalToLocal(_chartCanvas.worldToGlobal(_arrowPoint));
			_chartCanvas.currentAxis = null;
			var arPoint:Array=[0,0,0,0,0,0];
			var ARROW_DW:int = arrow_dw;
			var ARROW_DH:int = arrow_dh;
			
			if (null!=stage)
			{
				arPoint = [];                                
				var nArea:int=_getArrowArea();
				
				switch(nArea)
				{
					case 5:
						arPoint.push(unscaledWidth*0.5 + 2*ARROW_DW);                                                        
						arPoint.push(unscaledHeight*0.5);
						arPoint.push(unscaledWidth*0.5 - 2*ARROW_DW);
						arPoint.push(unscaledHeight*0.5);
						arPoint.push(tmpPoint.x);
						if (this.y > _chartCanvas.height * 0.5)
						{
//						Y用本地坐标
//						arPoint.push(tmpPoint.y);
							arPoint.push(this.height * 0.5 - this.height);
						}
						else
						{
//						Y用本地坐标
//						arPoint.push(tmpPoint.y);
							arPoint.push(this.height * 0.5 + this.height);
						}
					case 2:                                                
					case 8:
						arPoint.push(unscaledWidth * 0.5 + 2*ARROW_DW);                                                        
						arPoint.push(unscaledHeight * 0.5);
						arPoint.push(unscaledWidth * 0.5 - 2*ARROW_DW);
						arPoint.push(unscaledHeight * 0.5);
						arPoint.push(tmpPoint.x);
//						Y用本地坐标
//						arPoint.push(tmpPoint.y);
						arPoint.push(this.height * 0.5);
						break;
					case 1:                        
					case 9:        
						arPoint.push(unscaledWidth * 0.5 + 2*ARROW_DW);
						arPoint.push(unscaledHeight * 0.5 - 2*ARROW_DH);
						arPoint.push(unscaledWidth * 0.5 - 2*ARROW_DW);
						arPoint.push(unscaledHeight * 0.5 + 2*ARROW_DH);
						arPoint.push(tmpPoint.x);
//						Y用本地坐标
//						arPoint.push(tmpPoint.y);
						arPoint.push(this.height * 0.5);
						break;
					case 6:                        
					case 4:                        
						arPoint.push(unscaledWidth * 0.5);
						arPoint.push(unscaledHeight * 0.5 - 2*ARROW_DH);
						arPoint.push(unscaledWidth * 0.5);
						arPoint.push(unscaledHeight * 0.5 + 2*ARROW_DH);
						arPoint.push(tmpPoint.x);
//						Y用本地坐标
//						arPoint.push(tmpPoint.y);
						arPoint.push(this.height * 0.5);
						break;
					case 7:
					case 3:
						arPoint.push(unscaledWidth * 0.5 - 2 *ARROW_DW);                                                        
						arPoint.push(unscaledHeight * 0.5 - 2 *ARROW_DH);
						arPoint.push(unscaledWidth * 0.5 + 2 *ARROW_DW);
						arPoint.push(unscaledHeight * 0.5 + 2 *ARROW_DH);
						arPoint.push(tmpPoint.x);
//						Y用本地坐标
//						arPoint.push(tmpPoint.y);
						arPoint.push(this.height * 0.5);
						break;
				}                                                   
				return arPoint;
			}                        
			return arPoint;
		}  
		
		private function setLocation():void
		{
			var loc:int = getLocation();
			if (loc == 0 || this.unscaledWidth == 0 || this.unscaledHeight == 0)
				return;
			
			switch (loc)
			{
				case 1:
					_vector = new Point(2 * _arrow_dw, 2 * _arrow_dh);
					break;
				case 5:
				case 2:
					_vector = new Point(- this.unscaledWidth * 0.5, 2 * _arrow_dh);
					break;
				case 3:
					_vector = new Point(- this.unscaledWidth - 2 * _arrow_dw, 2 * _arrow_dh);
					break;
				case 4:
					_vector = new Point(2 * _arrow_dw, - this.unscaledHeight * 0.5);
					break;
				case 6:
					_vector = new Point(- this.unscaledWidth - _arrow_dw, - this.unscaledHeight * 0.5);
					break;
				case 7:
					_vector = new Point(2 * _arrow_dw, - this.unscaledHeight - 2 * _arrow_dh);
					break;
				case 8:
					_vector = new Point(- this.unscaledWidth * 0.5, - this.unscaledHeight - 2 * _arrow_dh);
					break;
				case 9:
					_vector = new Point(- this.unscaledWidth - 2 * _arrow_dw, - this.unscaledHeight - 2 *  _arrow_dh);
					break;
			}
		}
		
		/**
		 * 对舞台划分为9个区域，并返回当前所在的区域<br/>
		-------------<br/>
		| 1 | 2 | 3 |<br/>
		-------------<br/>
		| 4 | 5 | 6 |<br/>
		-------------<br/>
		| 7 | 8 | 9 |<br/>
		-------------<br/>
		*/
		private function getLocation():int
		{
			if (_vector.x != 0 && _vector.y != 0)
				return 0;
			if (_unit_name != "*")
				_chartCanvas.currentAxis = _unit_name;
			
			var pntLocation:Point;
			
			pntLocation = new Point(_arrowLocal.x + _vector.x, _arrowLocal.y + _vector.y);
				
			_chartCanvas.currentAxis = null;
			if(pntLocation.x < _chartCanvas.width / 3)
			{
				if(pntLocation.y < _chartCanvas.height / 3)
					return 1;
				else if(pntLocation.y> (_chartCanvas.height / 3) * 2)
					return 7;
				else
					return 4;
			}
			else if(pntLocation.x > (_chartCanvas.width / 3) * 2)
			{
				if(pntLocation.y < _chartCanvas.height / 3)
					return 3;
				else if(pntLocation.y > (_chartCanvas.height / 3) * 2)
					return 9;
				else
					return 6;
			}
			else
			{
				if(pntLocation.y < _chartCanvas.height / 3)
					return 2;
				else if(pntLocation.y > (_chartCanvas.height / 3) * 2)
					return 8;
				else
					return 5;
			}
			return 0;
			
		}
		
		/**
		 * 对本对象周围划分为8个区域，并返回当前箭头点所在的区域<br/>
		 * --------------------<br/>
		 * |  1  |   2  |  3  |<br/>
		 * --------------------<br/>
		 * |  4  | this |  6  |<br/>
		 * --------------------<br/>
		 * |  7  |   8  |  9  |<br/>
		 * --------------------<br/>
		 *
		 */
		private function _getArrowArea():int
		{
			var thisPoint:Point = new Point(x,y);
			if (_unit_name != "*")
				_chartCanvas.currentAxis = _unit_name;
			_chartCanvas.currentAxis = null;
			
			if (_arrowLocal.x < thisPoint.x)
			{
				if (_arrowLocal.y < thisPoint.y)
				{
					return 1;
				}
				else if (_arrowLocal.y > thisPoint.y + unscaledHeight)
				{
					return 7;
				}
				else
				{
					return 4;
				}
			}
			else if (_arrowLocal.x > thisPoint.x + unscaledWidth)
			{
				if (_arrowLocal.y < thisPoint.y)
				{
					return 3;
				}
				else if (_arrowLocal.y > thisPoint.y + unscaledHeight)
				{
					return 9;
				}
				else
				{
					return 6;
				}
			}
			else
			{
				if (_arrowLocal.y < thisPoint.y)
				{
					return 2;
				}
				else if (_arrowLocal.y > thisPoint.y + unscaledHeight)
				{
					return 8;
				}
				else
				{
					return 5;
				}
			}
			return 0;
			
		}
		
		/**
		 * 当加入舞台的显示列表的时候需要设置样式 
		 * @param e
		 * 
		 */		
		private function onBoxTitleMouse(e:MouseEvent):void
		{         
			e.stopImmediatePropagation();
			
			switch (e.type)
			{	
				case MouseEvent.MOUSE_OVER:
					_isMouseOn = true;
					this.addEventListener(MouseEvent.MOUSE_DOWN, onBoxTitleMouse);
					break;
				case MouseEvent.MOUSE_DOWN:
					if (e.currentTarget != this)
						break;
					if (_isDown)
						break;
					_isDown = true;
					this.addEventListener(MouseEvent.MOUSE_MOVE, onBoxTitleMouse);
					this.addEventListener(MouseEvent.MOUSE_UP, onBoxTitleMouse);
					stage.addEventListener(MouseEvent.ROLL_OUT, onBoxTitleMouse, false, 0, true);
					stage.addEventListener(MouseEvent.MOUSE_UP, onBoxTitleMouse, false, 0, true);
					break;
				case MouseEvent.MOUSE_MOVE:
					if (e.currentTarget != this)
						break;
					if (_isMove)
						break;
					_isMove = true;
					var cvsGlPoint:Point = _chartCanvas.localToGlobal(new Point(0,0));
					var tmpPoint:Point = this.parent.globalToLocal(cvsGlPoint);
					this.startDrag(false, new Rectangle(
						tmpPoint.x + _chartCanvas.clipLeft + _chartCanvas.borderWidth, 
						tmpPoint.y + _chartCanvas.clipTop + _chartCanvas.borderWidth, 
						_chartCanvas.width - _chartCanvas.clipRight - this.width - _chartCanvas.clipLeft - _chartCanvas.borderWidth * 2, 
						_chartCanvas.height - _chartCanvas.clipBottom - this.height - _chartCanvas.clipTop - _chartCanvas.borderWidth * 2));
					this.addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
					break;
				case MouseEvent.MOUSE_OUT:
					if (e.currentTarget != this)
						break;
					setMouseOut();
					break;
				case MouseEvent.ROLL_OUT:
					setMouseOut();
					if (_isDown && e.currentTarget == this)
						break;
				case MouseEvent.MOUSE_UP:
					if (!_isDown)
						break;
					_isDown = false;
					_isMove = false;
					setMouseOut();
					this.stopDrag();
					this.removeEventListener(Event.ENTER_FRAME, onEnterFrame, false);
					this.removeEventListener(MouseEvent.MOUSE_MOVE, onBoxTitleMouse);
					this.removeEventListener(MouseEvent.MOUSE_UP, onBoxTitleMouse);
					stage.removeEventListener(MouseEvent.ROLL_OUT, onBoxTitleMouse);
					stage.removeEventListener(MouseEvent.MOUSE_UP, onBoxTitleMouse);
					break;
			}
			
			if (_isShowArrowPoint)
			{
				setArrowLocation();
			}
			e.updateAfterEvent();
		}
		
		private function onEnterFrame(event:Event):void
		{
			arrowPointMove();
		}
		
		private function arrowPointMove():void
		{
			if (_isShowArrowPoint)
			{
				if (_unit_name != "*")
					_chartCanvas.currentAxis = _unit_name;
				
				var tmpP:Point = _chartCanvas.localToWorld(new Point(this.x, this.y + this.height * 0.5));
				_arrowPoint = new Point(_arrowPoint.x, tmpP.y);
				_arrowLocal = _chartCanvas.worldToLocal(_arrowPoint);
				_chartCanvas.currentAxis = null;
				if (!isMatrixChanged)
				{
					setArrowLocation();
				}
				isMatrixChanged = false;
			}
		}
		
		/**
		 * 根据数据源格式化不同显示tip 
		 * @param msg 显示的数据
		 * @return 显示的对象
		 * 
		 */		
		private function formatMSG(msg:Object):DisplayObject
		{
			if (msg is Array || msg is ArrayCollection)
			{
				var instance:UIComponent;
				if (null != _currDisplayObject && _currDisplayObject)
				{
					instance = _currDisplayObject as UIComponent;
				}
				else
				{
					var ClassReference:Class = getDefinitionByName(classPath) as Class;
					instance = new ClassReference();
				}
				
				if (instance is ListBase)
					(instance as ListBase).dataProvider = msg;
				
				return instance;
			}
			else if (msg is String || msg is Object)
			{
				var tf:UITextField;
				if (null != _currDisplayObject && _currDisplayObject is UITextField)
				{					
					tf = _currDisplayObject as UITextField;
				}
				else
				{
					tf = new UITextField;
				}
				
				tf.text = msg.toString();
				
				return tf;
			}
			return null;
		}
		
		private var _arrow_dw:int=6;
		private var _arrow_dh:int=6;
		
		private var isMatrixChanged:Boolean = false;
		
		private var _isDown:Boolean = false;
		private var _isMove:Boolean = false;
		
		private var _isMouseOn:Boolean = false;
		
		/**
		 * tip显示的数据  
		 */		
		private var _tipData:Object = null;
		
		/**
		 * 当前显示的tip对象 
		 */		
		private var _currDisplayObject:DisplayObject = null;
		
		/**
		 * TIP对象边框滤镜
		 */		
		private var _thisfilters:DropShadowFilter=new DropShadowFilter(3, 90, 0x333333, 0.5, 4, 4, 1);
		
		/**
		 * 数据坐标点 
		 */		
		private var _arrowPoint:Point;
		/**
		 * 本地坐标点 
		 */		
		private var _arrowLocal:Point;
		private var _thisPoint:Point;
		/**
		 *  tip本地坐标
		 */		
		private var _vector:Point;
		private var _chartCanvas:ChartCanvas;
		/**
		 * 显示tip箭头点的标志 true：显示 false：不显示  
		 */		
		private var _isShowArrowPoint:Boolean = true;
		
		private var _unit_name:String = "*";
	}
	
}