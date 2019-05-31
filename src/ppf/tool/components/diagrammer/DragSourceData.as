package ppf.tool.components.diagrammer
{
	import flash.geom.Point;
	
	import mx.core.UIComponent;

	/**
	 * 拖动对象的数据 
	 * @author KK
	 * 
	 */	
	public final class DragSourceData
	{
		/**
		 * 拖动对象的数据
		 */
		public function get data():Object
		{
			return _data;
		}
		
		/**
		 * @private
		 */
		public function set data(value:Object):void
		{
			_data = value;
		}
		
		/**
		 * 拖动对象的坐标
		 */
		public function get locPoint():Point
		{
			return _locPoint;
		}
		
		/**
		 * @private
		 */
		public function set locPoint(value:Point):void
		{
			_locPoint = value;
		}
		
		/**
		 * 拖动的对象
		 */
		public function get dragUI():UIComponent
		{
			return _dragUI;
		}
		
		/**
		 * @private
		 */
		public function set dragUI(value:UIComponent):void
		{
			_dragUI = value;
		}
		
		
		public function DragSourceData()
		{
		}
		
		private var _dragUI:UIComponent;
		private var _locPoint:Point;
		private var _data:Object;
	}
}