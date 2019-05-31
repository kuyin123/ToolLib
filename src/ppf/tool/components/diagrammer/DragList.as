package ppf.tool.components.diagrammer
{
	import mx.core.ClassFactory;
	
	import ppf.base.frame.docview.interfaces.IDragInitiator;
	import ppf.tool.components.spark.components.renderers.ListItemImageRenderer;
	
	import spark.components.List;
	
	public class DragList extends List implements IDragInitiator
	{
		public function DragList()
		{
			super();
		}
		
		public function get source():String
		{
			return "out";
		}
		public function get dataForFormat():String
		{
			return "itemsByIndex";
		}
		
	/*	override public function addDragData(dragSource:DragSource):void
		{
			dragSource.addHandler(copySelectedItemsForDragDrop, "itemsByIndex");
		}*/
		
		public function get dataField():String
		{
			return "data";
		}
		
		public function getDragType(item:Object):String
		{
			return "com.grusen.diagrammer.Link";
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			this.dragEnabled = true;
			
			var myFactory:ClassFactory = new ClassFactory(ListItemImageRenderer);
			this.itemRenderer = myFactory;	
		}
	}
}