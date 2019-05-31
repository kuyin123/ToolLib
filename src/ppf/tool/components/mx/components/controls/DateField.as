package ppf.tool.components.mx.components.controls
{
	import mx.controls.DateField;
	
	public class DateField extends mx.controls.DateField
	{
		public function DateField()
		{
			super();
		}
		override protected function createChildren():void
		{
			
			super.createChildren();
			
			yearNavigationEnabled = true;
			this.showToday = false;
			formatString = "YYYY-MM-DD";
			textInput.setStyle("borderStyle","none");
		}
	}
}