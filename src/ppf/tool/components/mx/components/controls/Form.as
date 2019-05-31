package ppf.tool.components.mx.components.controls
{
	import mx.containers.BoxDirection;
	import mx.containers.Form;
	import mx.core.mx_internal;
	
	use namespace mx_internal;
	
	/**
	 * 可以设置 Form下FormItem的布局方向</br>
	 * layoutDirection BoxDirection.VERTICAL（horizontal）、BoxDirection.HORIZONTAL（vertical）
	 * @author wangke
	 * 
	 */	
	public class Form extends mx.containers.Form
	{
		/**
		 * 设置 
		 * @param value
		 * 
		 */		
		[Inspectable(category="General", enumeration="vertical,horizontal")]
		public function set layoutObjectDirection(value:String):void
		{
			mx_internal::layoutObject.direction = value;
		}
		
		public function Form()
		{
			super();
		}
	}
}