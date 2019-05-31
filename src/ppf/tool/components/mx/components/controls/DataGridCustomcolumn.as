package ppf.tool.components.mx.components.controls
{
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	import mx.controls.LinkButton;
	import mx.controls.Menu;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.controls.dataGridClasses.DataGridHeader;
	import mx.core.ScrollPolicy;
	import mx.core.mx_internal;
	import mx.events.FlexEvent;
	import mx.events.MenuEvent;
	
	import ppf.base.frame.docview.mx.skins.ButtonSkin;

	use namespace mx_internal;

	public class DataGridCustomcolumn extends ppf.tool.components.mx.components.controls.DataGrid
	{
		public function set isCustomColumnButtonShow(value:Boolean):void
		{
			_isCustomColumnButtonShow = value;
			
			this.verticalScrollPolicy = ScrollPolicy.ON;
		}
		public function get isCustomColumnButtonShow():Boolean
		{
			return _isCustomColumnButtonShow;
		}
		
		public function set customColumnsArr(value:Array):void
		{
			_customColummsMenu = Menu.createMenu(this,value,true);
			_customColummsMenu.labelField = "label";
			_customColummsMenu.addEventListener("itemClick", menuHandler);
			for each (var item:Object in value)
			{
				setColumnVisible(item);
			}
		}
		
		public function DataGridCustomcolumn()
		{
			super();
		}
	
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			
			updateCustomColumnBtn(unscaledWidth,unscaledHeight);
		}
		
		override protected function onCreateComplete():void
		{
			if (null != _customColumnBtn)
				_customColumnBtn.setStyle("skin",ButtonSkin);
			horizontalScrollPolicy = ScrollPolicy.AUTO;
		}
		
		private function updateCustomColumnBtn(unscaledWidth:Number, unscaledHeight:Number):void
		{
			if (isCustomColumnButtonShow)
			{
				if (null == _customColumnBtn)
				{
					_customColumnBtn = new mx.controls.LinkButton;
					
					_customColumnBtn.addEventListener(MouseEvent.CLICK, onClickHandler, false, 99999);
					_customColumnBtn.addEventListener(MouseEvent.MOUSE_UP, onMouseHandler);
					_customColumnBtn.addEventListener(MouseEvent.MOUSE_DOWN, onMouseHandler);
					_customColumnBtn.addEventListener(FlexEvent.CREATION_COMPLETE, onBtnComplete);
					addChild(_customColumnBtn);
					_customColumnBtn.width = verticalScrollBar.width;
					_customColumnBtn.maxWidth = _customColumnBtn.width;
					_customColumnBtn.height = header.height;
					_customColumnBtn.maxHeight = _customColumnBtn.height;
					_customColumnBtn.y = 1;
					
				}
			
				verticalScrollBar.move(verticalScrollBar.x, viewMetrics.top + header.height);
				verticalScrollBar.setActualSize(verticalScrollBar.width,unscaledHeight - viewMetrics.top - viewMetrics.bottom - header.height);
				_customColumnBtn.x = verticalScrollBar.x + verticalScrollBar.width * 0.5 - _customColumnBtn.width * 0.5;
				var hcx:Number = viewMetrics.left + Math.min(DataGridHeader(header).leftOffset, 0);
				var ww:Number = Math.max(0, DataGridHeader(header).rightOffset) - hcx - borderMetrics.right;
				var hh:Number = header.getExplicitOrMeasuredHeight();
				
				if (null != horizontalScrollBar && horizontalScrollBar.visible)
				{
					if (horizontalScrollPosition == horizontalScrollBar.maxScrollPosition)
					{
						header.setActualSize(unscaledWidth + ww-verticalScrollBar.width, hh);
						headerMask.width += verticalScrollBar.getExplicitOrMeasuredWidth();
					}
					else
					{
						header.setActualSize(unscaledWidth + ww, hh);
					}
					
				}
				else
				{
					headerMask.width += verticalScrollBar.getExplicitOrMeasuredWidth();
				}
				
				//添加最右端使用分隔符
				if (!DataGridHeader(header).needRightSeparator)
				{
					header.invalidateDisplayList();
					DataGridHeader(header).needRightSeparator = true;
				}
			}
		}
		
		private function onClickHandler(event:MouseEvent):void
		{
			//event.preventDefault();
//			event.stopPropagation();
//			event.stopImmediatePropagation();
			if (null != _customColummsMenu)
			{
				_customColummsMenu.show((event.stageX + _customColumnBtn.width), (event.stageY + _customColumnBtn.height));
				
				_customColummsMenu.x = event.stageX - _customColummsMenu.columnWidth;
				event.stopPropagation();
				event.stopImmediatePropagation();
			}
		}
		
		private function onMouseHandler(event:MouseEvent):void
		{
			event.preventDefault();
			event.stopPropagation();
			event.stopImmediatePropagation();
		}
		
		private function onBtnComplete(event:FlexEvent=null):void
		{
			_customColumnBtn.width=_customColumnBtn.getExplicitOrMeasuredWidth();
			_customColumnBtn.height=_customColumnBtn.getExplicitOrMeasuredHeight();
		}
		
		private function menuHandler(event:MenuEvent):void
		{
			setColumnVisible(event.item);
			event.stopPropagation();
			event.stopImmediatePropagation();
		}
		
		private function setColumnVisible(item:Object):void
		{
			for each (var column:DataGridColumn in columns)
			{
				if (item.dataField == column.dataField)
				{
					column.visible = item.toggled;
				}
			}
		}
		private var _customColummsMenu:Menu;
		
		private var _customColumnBtn:mx.controls.LinkButton;
		
		private var _isCustomColumnButtonShow:Boolean = false;
	}
}