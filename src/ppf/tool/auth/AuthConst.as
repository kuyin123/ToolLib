package ppf.tool.auth
{
	/**
	 * 权限常量 
	 * @author wangke
	 * 
	 */	
	public class AuthConst
	{
		[Bindable]
		/**
		 * 是否是超级管理员
		 */	
		public static var isSuperAdmin:Boolean = false;
		[Bindable]
		/**
		 *是否为管理员 
		 */		
		public static var isAdmin:Boolean=false;
		
		/**
		 * 管理员 level
		 */		
		static public const ADMIN:int = 1;
		/**
		 * debug用户 所有可见 level
		 */		
		static public const DEBUG:int = 0;
		
		
		//id
		/**
		 * 管理员 ID
		 */ 
		static public const ENG_ADMIN:int = 1;
		/**
		 * 工程服务 ID
		 */ 
		static public const ENG_MAINTAIN:int = 2;
		/**
		 * 工程调试 ID 
		 */ 
		static public const ENG_DEBUG:int = 3;
		/**
		 * 高级 ID
		 */ 
		static public const ENG_ADVANCE:int = 4;
		/**
		 * 浏览 ID
		 */ 
		static public const ENG_GENERAL:int = 5;
		
		
		
		/**
		 * 仅访问
		 */		
		static public const AUTH_ACCESS:int = 0;
		/**
		 * 仅管理
		 */		
		static public const AUTH_MANAGE:int = 1;
		/**
		 * 访问&&管理都有
		 */		
		static public const AUTH_ALL:int = 2;
		
		/**
		 * debug调试信息 权限
		 */	
		public static  var isDebug :Boolean = false;
		public function AuthConst()
		{
			throw new Error("AuthConst类只是一个静态方法类!"); 
		}
	}
}

