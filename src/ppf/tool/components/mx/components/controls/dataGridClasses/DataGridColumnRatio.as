package ppf.tool.components.mx.components.controls.dataGridClasses
{
	import ppf.tool.components.mx.components.renderers.DataGridColumnRatioItemEditor;
	
	import mx.core.ClassFactory;
	
	/**
	 * 用于显示比率的列
	 * </br>其中输入的比率数据必须为数字
	 * </br>可通过设置restrict来显示输入的类型
	 * </br>默认的LabelFunction
	 * @author taonengcheng
	 * 
	 */	
	public class DataGridColumnRatio extends DataGridColumnLabel
	{
		public function DataGridColumnRatio(columnName:String=null)
		{
			super(columnName);
			init();
		}
		
		public function set leftField(value:String):void
		{
			if(lf!=value)
			{
				lf=value;
				refreshEditor();
			}
		}
		
		public function get leftField():String
		{
			return lf;
		}
		
		public function set rightField(value:String):void
		{
			if(rf!=value)
			{
				rf=value;
				refreshEditor();
			}
		}
		
		public function get rightField():String
		{
			return rf;
		}
		
		private function refreshEditor():void
		{
			if(myFactory==null)
			{
				myFactory=new ClassFactory(DataGridColumnRatioItemEditor);
			}
			myFactory.properties={leftField:lf,rightField:rf};//,restrict:""
			itemEditor=myFactory;
		}
		
		private function init():void
		{
			labelFunction=defaultLabelFunc;
		}
		
		private function defaultLabelFunc(item:Object, column:DataGridColumn):String
		{
			if(item==null)
				return "";
			lbl="";
			if(item.hasOwnProperty(lf))
			{
				lbl=item[lf].toString();
			}
			lbl+=":";
			
			if(item.hasOwnProperty(rf))
			{
				lbl+=item[rf].toString();
			}
			
			if(lbl==":")
				return "";
			return lbl;
		}
		
		private var lf:String;
		private var rf:String;
		private  var myFactory:ClassFactory;
		private var lbl:String;
	}
}