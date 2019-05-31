package ppf.tool.components
{
	import mx.core.IUIComponent;
	import mx.styles.ISimpleStyleClient;
	
	public interface IDragItem extends IUIComponent,ISimpleStyleClient
	{
		function get type():String;

		/**
		 *  使用接受的拖动数据初始化
		 * @param item
		 */
		function loadByItem(item:Object):void;


		/**
		 * 拖动对象自身的属性，存放绘制的图形、颜色设置、关联关系等
		 * @param xml
		 */		
		function loadByXML(xml:XML):Boolean;
		function saveToXML(xml:XML):void;
		
		/**
		 * 附属数据，拖动对象所夹带的其他对象
		 * @param value
		 */
		function set data(value:Object):void;
		function get data():Object;
		
		/**
		 * 是否是设置状态
		 */
		function get isEdit():Boolean;
		/**
		 * @private
		 */
		function set isEdit(value:Boolean):void;
		
		/**
		 * 当前对象是否被选中
		 * @return
		 *
		 */		
		function get isSelected():Boolean;
		function set isSelected(value:Boolean):void;
	}
}