package ppf.tool.components.events
{
	import flash.events.Event;
	
	public final class DragItemEvent extends Event
	{
		 public static const DRAGITEMDATACHANGE:String = "dragItemDataChange";

		public function DragItemEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}