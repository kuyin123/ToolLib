package ppf.tool.components
{
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import mx.utils.URLUtil;

	public final class URLUtil
	{
		/**
		 * Web 浏览器新窗口中打开 URL 
		 * <br/>增加部分浏览器阻止Flash弹窗的判断
		 * @param url  http:// 或 https:// 开头的任何 URL 
		 * @param window "_self" 指定当前窗口中的当前帧。 "_blank" 指定一个新窗口。 "_parent" 指定当前帧的父级。 "_top" 指定当前窗口中的顶级帧。 
		 * 
		 */		
		static public function navigateToURLBlank(url:String="http://www.grusen.com/",window:String="_blank"):void
		{
			var req:URLRequest = new URLRequest(url);
			
			if (!ExternalInterface.available)
			{
				navigateToURL(req, window);
			}
			else 
			{
				var strUserAgent:String = String(ExternalInterface.call("function() {return navigator.userAgent;}")).toLowerCase();
				if (strUserAgent.indexOf("firefox") != -1 || (strUserAgent.indexOf("msie") != -1 && uint(strUserAgent.substr(strUserAgent.indexOf("msie") + 5, 3)) >= 7)) {
					ExternalInterface.call("window.open", req.url, window);
				} 
				else 
				{
					navigateToURL(req, window);
				}
			}
		}
		/**
		 * 获取地址栏的服务器地址 http://www.xxx.com:8080
		 * @return 
		 * 
		 */		
		static public function getFullURL():String
		{
			var url:String = "";
			
			if (ExternalInterface.available)
			{
				url = ExternalInterface.call(_javascript);
				url = mx.utils.URLUtil.getFullURL(url,url);
				var lastIndex:int = url.indexOf("/",7);/*如果地址为http://www.xxx.com:8080/index.html进行截取*/
				if (-1 != lastIndex && url.length > lastIndex)
					url = url.substr(0,lastIndex);
			}
			
			return url;
		}
		
		
		public function URLUtil()
		{
			throw new Error("URLUtil类只是一个静态方法类!");  
		}
		
		/**
		 * 获取 
		 */		
		static private const _javascript:XML = 
			<script>
			<![CDATA[
				function()
				{
					return document.location.href;
				}
				]]>
			</script>;
	}
}