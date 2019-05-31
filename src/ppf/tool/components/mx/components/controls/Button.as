package ppf.tool.components.mx.components.controls
{
	import mx.controls.Button;
	import mx.core.mx_internal;
	
	import ppf.base.frame.docview.FilterUtil;
	
	use namespace mx_internal;
	
	/**
	 * enabled = false 时使得icon的图标变灰 
	 * @author KK
	 * 
	 */	
	public final class Button extends mx.controls.Button
	{
		public function Button()
		{
			super();
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			
			if (null != currentIcon)
				currentIcon.filters = enabled ? null : [FilterUtil.cinerationColorMatrix,FilterUtil.rilievoColorMatrix];
			
		}
	}
}