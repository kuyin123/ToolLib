package ppf.tool.components.mx.components.controls
{
	import flash.display.BlendMode;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import mx.core.UIComponent;
	
	public class LoadingIndecator extends UIComponent
	{
		public function LoadingIndecator()
		{
			super();
			width = 2* len;
			height = 2* len;
			
			graphics.clear();
//			alpha = 0.5;
			blendMode = BlendMode.DARKEN;
//			cacheAsBitmap = true;
//			opaqueBackground = null;
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			sprite = new Sprite();
			addChild(sprite);
			sprite.x = len;
			sprite.y = len;
			
			var _mask:Shape = new Shape;
			addChild(_mask);
			sprite.mask = _mask;
			var g:Graphics = _mask.graphics;
			g.beginFill(0xff0000);
			g.drawRect(0,0,2* len,2 * len);
			g.endFill();
			
			start();
			
			g = sprite.graphics;
			g.beginFill(0xffffff);
			g.drawRect(-len,-len,2*len,2*len);
			g.endFill();
			
			var circle:Shape;
			var angle:Number;
			var radius:Number = len - 2 * dot;
			for(var i:int = 0; i< 8; i++)
			{
				circle = newCircle(colors[i]);
				sprite.addChild(circle);
				angle = i * quaterPI;
				circle.x = radius * Math.sin(angle);
				circle.y = radius * Math.cos(angle);
			}
		}
		
		public function start():void
		{
			if(!isRendering)
			{
				addEventListener(Event.ENTER_FRAME,enterFrame,false,0,true);
				isRendering = true;
			}
		}
		
		public function stop():void
		{
			if(isRendering)
			{
				removeEventListener(Event.ENTER_FRAME,enterFrame);
				isRendering = false;
			}
		}
		
		private function enterFrame(event:Event):void
		{
			renderCnt ++;
			if(renderCnt == 2)
				renderCnt = 0;
			else
				return;
			cnt ++;
			var circle:Shape;
			var angle:int;
			if(sprite)
			{
				for (var i:int = 0;i < sprite.numChildren;i++)
				{
					circle = sprite.getChildAt(i) as Shape;
					renderCircle(i,cnt);
				}
			}
		
		}
		
		private function renderCircle(i:int,cursor:int):void
		{
			var shape:Shape = sprite.getChildAt(i) as Shape;
			var g :Graphics = shape.graphics;
			var index:int = i + cnt;
			var color:uint = getColor(index % 8);
			g.clear();
			g.beginFill(color);
			g.drawCircle(0,0,3);
			g.endFill();
		}
		
		private function getColor(cursor:int):uint
		{
			if(cursor > 7)
			{
				return colors[cursor - 7];
			}
			else
			{
				return colors[cursor];
			}
		}
		
		private function newCircle(color:uint):Shape
		{
			var circle:Shape = new Shape();
			var g:Graphics = circle.graphics;
			g.clear();
			g.beginFill(color);
			g.drawCircle(0,0,dot);
			g.endFill();
			
			return circle;
		}
		
		private var sprite:Sprite;
		private var quaterPI:Number = Math.PI / 4;
		
		private var colors:Array = [0xf0f0f0,0x909090,0x808080,0x707070
			,0x606060,0x505050,0x404040,0x202020];
		
		private var currentAngle:int = 0;
		private var cnt:int = 0;
		public var len:int = 13; //图形框高度/宽度的一般
		public var dot:int = 2;  //点的半径
		
		private var renderCnt:int = 0;
		
		private var isRendering:Boolean = false;
		
	}
}