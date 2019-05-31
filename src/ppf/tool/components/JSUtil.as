package ppf.tool.components
{
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Point;
	import flash.system.Capabilities;
	
	import mx.core.FlexGlobals;

	/**
	 * js 工具类 
	 * @author wangke
	 * 
	 */	
	public final class JSUtil
	{
		/**
		 * 支持firefox、Chrome的滚轮 
		 * 
		 */		
		static public function mouseWheel():void
		{
			if (!INITIALIZED)
				init();
			
			var playType:String = flash.system.Capabilities.playerType;
			if(playType=="ActiveX")
			{//IE 浏览器
				
			}
			else if(playType=="PlugIn")
			{
				ExternalInterface.addCallback("handleWheel", handleWheel);
			}
		}
		
		/**
		 * 改变浏览器标题 
		 * @param str
		 * 
		 */		
		static public function setTitle(str:String):void
		{
			if (!INITIALIZED)
				init();
			
			ExternalInterface.call("setTitle",str);
		}
		
		/**
		 * 重载页面 
		 * 
		 */		
		static public function reload():void
		{
			if (!INITIALIZED)
				init();
			ExternalInterface.call("reload");
		}
		
		/**
		 * 自动焦点 
		 * 
		 */		
		static public function setFocus():void
		{
			if (!INITIALIZED)
				init();
			
			ExternalInterface.call("eval", "document.getElementById('" + ExternalInterface.objectID + "').focus()");
		}
		public function JSUtil()
		{
			throw new Error("JSUtil类只是一个静态方法类!");  
		}
		
		private static function init():void
		{
			ExternalInterface.call(FUNCTION_RELOAD);
			
			ExternalInterface.call(FUNCTION_TITLE);
			
			ExternalInterface.call(_handleWheel, ExternalInterface.objectID);
			
			INITIALIZED=true;
		}
		
		private static const FUNCTION_RELOAD:String = 
			"document.insertScript = function ()" +
			"{ " +
			"if (document.reload==null)" +
			"{" +
			"reload = function ()" +
			"{" +
			"	document.location.reload();" +
			"}" +
			"}" +
			"}";
		
		private static const FUNCTION_TITLE:String = 
			"document.insertScript = function ()" +
			"{ " +
			"if (document.setTitle==null)" +
			"{" +
			"setTitle = function (str)" +
			"{" +
			"	document.title = str;" +
			"}" +
			"}" +
			"}";
		
		static private const _handleWheel:XML = 
			<script>
			<![CDATA[
			function(flashObjectId)
			{				
				if(!(document.attachEvent))
				{
					window.addEventListener("DOMMouseScroll", handleWheel, false);
					window.onmousewheel = handleWheel;
				}
				
				function handleWheel(event) 
				{
					var app = window.document[flashObjectId];
					if (app)
					{
						var o ;
						var delta;
						if (event.wheelDelta)
						{
							delta = event.wheelDelta;
						}
						else
						{
							delta = -event.detail;
						}
						o = {x: event.screenX, y: event.screenY,
						delta: delta,
						ctrlKey: event.ctrlKey, altKey: event.altKey,
						shiftKey: event.shiftKey}
			
						app.handleWheel(o);
					}
				}
			}
			]]>
			</script>;
		
		private static function handleWheel(event:Object): void
		{
			var obj:InteractiveObject = null;
			var app:DisplayObjectContainer = FlexGlobals.topLevelApplication as DisplayObjectContainer;
			var tmpGlbPoint:Point = new Point(app.mouseX, app.mouseY);
			var objects:Array = app.getObjectsUnderPoint(tmpGlbPoint);
			for (var i:int = objects.length - 1; i >= 0; i--) 
			{
				if (objects[i] is InteractiveObject) 
				{
					obj = objects[i] as InteractiveObject;
					break;
				} 
				else 
				{
					if (objects[i] is Shape && (objects[i] as Shape).parent)
					{
						obj = (objects[i] as Shape).parent;
						break;
					}
				}
			}
			if (obj)
			{
				var tmpP:Point = obj.globalToLocal(tmpGlbPoint);
				var mEvent:MouseEvent = new MouseEvent(MouseEvent.MOUSE_WHEEL, true, false,
					tmpP.x, tmpP.y, obj,
					event.ctrlKey, event.altKey, event.shiftKey,
					false, Number(event.delta/20));
				obj.dispatchEvent(mEvent);
			}
		}
		
		private static var INITIALIZED:Boolean=false;
	}
}