package ppf.tool.components.mx.components.controls
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.controls.LinkButton;
	import mx.events.FlexEvent;
	
	import ppf.base.resources.AssetsUtil;

	public class ClearTextInput extends PromptingTextInput
	{
		public function ClearTextInput()
		{
			super();
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			if (null == clearButton)
			{
				clearButton = new mx.controls.LinkButton;
				clearButton.addEventListener(MouseEvent.CLICK, clearButtonClicked);
				clearButton.width = 15;
				clearButton.height = 15;
				clearButton.visible  = false;
				this.addChild(clearButton);
				clearButton.setStyle("icon",AssetsUtil.stringToIcon("clear"));
			}
		}
		
		override protected function onChange(event:Event):void
		{
			super.onChange(event);
			
			if (textEmpty)
				clearButton.visible = false;
			else
				clearButton.visible = true;
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			
			if (null != clearButton)
			{
				clearButton.x = this.width - clearButton.width-3;
				clearButton.y = (this.height - clearButton.height)*0.5;
			}
			
		}
		
		protected var clearButton:mx.controls.LinkButton;
		
		private function clearButtonClicked(event:MouseEvent):void 
		{
			if (text.length > 0) 
			{
				text = "";
				textEmpty = true;
				clearButton.visible = false;
			}
		}
	}
}