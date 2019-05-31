package ppf.tool.components.mx.components.controls
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.PixelSnapping;
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	import mx.controls.Image;
	import mx.events.FlexEvent;
	
	import cmodule.as3_jpeg_wrapper.CLibInit;
	
	import ppf.base.frame.AlertUtil;
	import ppf.base.math.Base64Util;
	import ppf.base.resources.LocaleConst;
	import ppf.base.resources.LocaleManager;
	
	public class Image extends mx.controls.Image
	{
		/**
		 * Image加载时的宽
		 */
		public var imgOldWidth:Number=0;
		/**
		 * Image加载时的高
		 */
		public var imgOldHeight:Number=0;

		public function get imageStr():String
		{
			return _imageStr;
		}

		public function set imageStr(value:String):void
		{
			if (null != this.source || _imageStr != value)
			{
				_imageStr = value;
				
				if (null == value || ""== value)
				{
					this.source = value;
					return;
				}
				
				var b:ByteArray = Base64Util.decodeToByteArray(value);
				this.source = b;
//				this.load(b);
			}
		}

		public function set byteArray(value:ByteArray):void
		{
			_loader.loadBytes(value);
		}

		/**
		 * Image的URL
		 * @return
		 *
		 */		

		[Bindable]
		public function get imgUrl():String
		{
			return _imgUrl; 
		}
		public function set imgUrl(value:String):void
		{ 
			if (value && value.length>0)
			{
				var url:String = value;
				
				_imgUrl = value; 
				
				load(url); 
			}
		}
		
//		override public function load(url:Object = null):void
//		{
//			if (null == url)
//				return;
//			
//			super.load(url);
//			
//			if (_pro && this.contains(_pro))
//				this.removeChild(_pro);
//			
//			_pro = new ProgressBar;
//			this.addChild(_pro);
//			_pro.source = this;
//			_pro.minimum = 0;
//			_pro.maximum = 100;
//			
//			this.setStyle("horizontalAlign","center");
//			this.setStyle("verticalAlign","middle");
//		}

		public function Image()
		{
			super();
			
			//一个标志，指示是否保持加载内容的高宽比。
			maintainAspectRatio=false;
			focusEnabled = false;
			//一个标志，指示是缩放内容以适应控件大小还是调整控件大小使其适应内容大小。
			scaleContent=true;
			
			this.addEventListener(Event.COMPLETE,onComplete,false,0,true);
			
			this.addEventListener(FlexEvent.CREATION_COMPLETE,onCreationComplete,false,0,true);
		}
		
		/**
		 * 初始化
		 * @private
		 * @param e
		 *
		 */
		protected function onComplete(event:Event):void
		{
//			if (_pro && this.contains(_pro))
//				this.removeChild(_pro);
			
//			this.setStyle("horizontalAlign","left");
//			this.setStyle("verticalAlign","top");
			
			if (content)
			{
				imgOldHeight = content.height;
				imgOldWidth = content.width;
			}
		}
		
		protected function loaderComplete(event:Event):void
		{
			try
			{
				trace("loaderComplete");
				var bitmapData:BitmapData = event.currentTarget.content.bitmapData as BitmapData;
				if (bitmapData.width*bitmapData.height < 16777215)
				{
					var newBitmapData:BitmapData = new BitmapData(bitmapData.width,bitmapData.height);
					newBitmapData.draw(bitmapData,null,null,null,null,true);
					
					imgOldWidth = newBitmapData.width;
					imgOldHeight = newBitmapData.height;
					var b:ByteArray = newBitmapData.getPixels(newBitmapData.rect);
					b.position = 0;
					var out:ByteArray = as3_jpeg_wrapper.write_jpeg_file(b,imgOldWidth,imgOldHeight, 3, 2, 100);	
					imageStr = Base64Util.encodeByteArray(out);
				}
				else
					AlertUtil.show(LocaleManager.getInstance().getString(LocaleConst.LIB,'LIB_TIP_054'),LocaleManager.getInstance().getString(LocaleConst.LIB,'LIB_TIP_016'));
			}
			catch(err:Error)
			{
				trace("Image::loaderComplete"+err.message);
			}
		}
		
		private function onCreationComplete(event:FlexEvent):void
		{
			this.removeEventListener(FlexEvent.CREATION_COMPLETE,onCreationComplete);
			
			var loader:cmodule.as3_jpeg_wrapper.CLibInit = new cmodule.as3_jpeg_wrapper.CLibInit;
			as3_jpeg_wrapper = loader.init();
			_loader.contentLoaderInfo.addEventListener (Event.COMPLETE,loaderComplete, false,0,true);
		}
		
		/**
		 *  Image的URL
		 */		
		private var _imgUrl:String="";
		
		private var _imageStr:String;
		
		private var as3_jpeg_wrapper: Object;
		
		private var _loader:Loader = new Loader;
	}
}