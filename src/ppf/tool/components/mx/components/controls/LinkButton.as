package ppf.tool.components.mx.components.controls
{
	import ppf.base.resources.AssetsUtil;
	import ppf.base.frame.docview.FilterUtil;
	
	import mx.controls.LinkButton;
	import mx.core.mx_internal;
	
	use namespace mx_internal;
	
	/**
	 * LinkButton 的enabled = false 时使得icon的图标变灰 
	 * @author KK
	 * 
	 */	
	public class LinkButton extends mx.controls.LinkButton
	{
		public var item:Object;
		/**
		 * 切换显示按钮的图标和toolTip
		 * @param item
		 * 
		 */		
		public function toggledBtn(isToggle:Boolean):void
		{
			if (isToggle)
			{
				toolTip = item.labelToggle;
				setStyle("icon",AssetsUtil.stringToIcon(item.iconToggle));
			}
			else
			{
				toolTip = item.label;
				setStyle("icon",AssetsUtil.stringToIcon(item.icon));
			}
		}
		/**
		 * 权限id 
		 */		
		public var actionID:int=-1;
		/**
		 * 切换状态的权限id 
		 */		
		public var actionTooggleID:int=-1;
		/**
		 * 构造函数
		 * @private 
		 */		
		public function LinkButton()
		{
			super();
			this.mouseChildren = false;
		}

		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			
			if (null != currentIcon)
				currentIcon.filters = enabled ? null : [FilterUtil.cinerationColorMatrix,FilterUtil.rilievoColorMatrix];
			
		}
	}
}