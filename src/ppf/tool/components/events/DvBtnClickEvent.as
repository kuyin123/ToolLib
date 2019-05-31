package ppf.tool.components.events
{
	import flash.events.Event;
	
	public final class DvBtnClickEvent extends Event
	{
		public static const DV_BTN_CLICK_EVENT:String="DvBtnClickEvent";
		
		public var buttonObject:Object;
		public var selected:Boolean;
		
		public function DvBtnClickEvent(type:String,buttonObject:Object,selected:Boolean)
		{
			super(type, bubbles, cancelable);
			
			this.buttonObject=buttonObject;
			this.selected=selected;
		}
		
		override public function clone():Event 
		{
			return new DvBtnClickEvent(type, buttonObject,selected);
		}
	}
}