package ppf.tool.components.events
{
	public class DataGridColumnEvent extends EventExtend
	{
		public static const COLOR_CLICK:String = "colorClick";
		public static const CHECKBOX_CLICK:String = "checkBoxClick";
		public static const CHECKBOX_HEAD_CLICK_BEGIN:String = "checkBoxHeadClickBegin";
		public static const CHECKBOX_HEAD_CLICK_END:String = "checkBoxHeadClickEnd";
		
		public static const COMBOBOX_CLICK:String = "comboBoxClick";
		public static const COMBOBOX_HEAD_CLICK:String = "comboBoxHeadClick";
		
		public function DataGridColumnEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}