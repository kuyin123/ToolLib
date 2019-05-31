package ppf.tool.components
{
	import flash.events.IEventDispatcher;
	
	/**
	 * 刷新图标和提示
	 * @author wangke
	 * 
	 */	
	public interface IListData extends IEventDispatcher
	{
		function updateIcon():void;
		function updateToolTip(isRealTime:Boolean=true):void;
		
		function updateFilterStr():void;
	}
}