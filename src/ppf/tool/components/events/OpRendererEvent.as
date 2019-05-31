package ppf.tool.components.events
{
	import flash.events.Event;
	
	public class OpRendererEvent extends EventExtend
	{
		public static const ADD:String = "add";
		public static const EDIT:String = "edit";
		public static const REMOVE:String = "ext_remove";
		public static const DEL:String = "del";
		public static const FLUCTUATION_SET:String = "fluctuation_set"
		public static const NOTE:String = "note";
		
		/**
		 * 机组偏差学习/设置
		 */ 		
		public static const EDIT_DEVIATION:String = "editdeviation";
		
        /**
		 * 机组参数设置
		 */ 		
		public static const EDIT_PARAMETER:String = "editparameter";
		/**
		 * 修改机组转速级别
		 */ 
		public static const EDIT_SPEED_LEVEL_SETTING:String = "editspeedlevel";
		
		/**
		 *打开并导入历史校正 
		 */		
		public static const HISIMPORT:String = "hisimport";
		/**
		 *删除历史校正 
		 */		
		public static const HISDELETE:String = "hisdelete";
		/**
		 *Runout设置 
		 */		
		public static const SET:String = "set";
		/**
		 * 初始化设置
		 * */
		public static const INITSET:String = "initset";
		//*组织结构图上移组织命令*//
		public static const MOVEUP:String = "moveup";
		public static const MOVEDOWN:String = "movedown";
		/**
		 * 导出报表 
		 */		
		public static const TEST_EXPORT:String = "TEST_EXPORT";
		/**
		 * 删除记录 
		 */		
		public static const TEST_DEL:String = "TEST_DEL";
		/**
		 * 基本信息 
		 */		
		public static const TEST_BASEINFO:String = "TEST_BASEINFO";
		/**
		 * 使用配置 
		 */		
		public static const TEST_USECONFIG:String = "TEST_USECONFIG";
		/**
		 *使用 
		 */		
		public static const USE:String = "USE";
		
		public static const USER_EDIT_ORG:String = "user_edit_org";
		
		public static const USER_RULE_EDIT:String = "user_rule_edit";
		
		public static const USER_RULE_DEL:String = "user_rule_del";
		
		public static const TURN_ON:String = "turnon";
		public static const TURN_OFF:String = "turnoff";
		
		
		
		public function OpRendererEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}