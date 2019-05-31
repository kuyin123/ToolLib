package ppf.tool.components.events
{
	import flash.events.Event;
	
	public class EventExtend extends Event
	{
		/**
		 *  
		 */		
		public var ids:Object;
		
		/**
		 * 发生的事件类型
		 */		
		public var kind:String;
		
		public function EventExtend(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}