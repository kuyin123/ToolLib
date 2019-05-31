package ppf.tool.components
{
	/**
	 * 文本输入限制字符接口 
	 * @author wangke
	 * 
	 */	
	public interface IRestrict
	{
		function get minChars():int;
		function set minChars(value:int):void;
		
		function get maxChars():int;
		function set maxChars(value:int):void;
		
		function get restrict():String;
		function set restrict(value:String):void;
		
		function get fractionalDigits():Number;
		function set fractionalDigits(value:Number):void;
	}
}