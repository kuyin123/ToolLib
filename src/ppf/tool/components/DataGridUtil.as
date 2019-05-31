package ppf.tool.components
{
	import flash.events.EventDispatcher;
	
	import mx.controls.DataGrid;
	import mx.controls.dataGridClasses.DataGridItemRenderer;
	import mx.events.DataGridEvent;
	import mx.managers.IFocusManagerComponent;
	
	import ppf.base.frame.docview.interfaces.IValidator;
	import ppf.tool.components.mx.components.controls.dataGridClasses.DataGridColumn;
	import ppf.tool.components.mx.components.controls.dataGridClasses.DataGridColumnLabel;
	import ppf.tool.components.mx.components.renderers.DataGridItemRenderer;
	import ppf.tool.components.mx.validators.Validator;
	import ppf.tool.components.spark.components.controls.datagridClasses.GridColumnLabel;
	
	import spark.events.GridItemEditorEvent;

	public final class DataGridUtil extends EventDispatcher
	{
		/**
		 * 无效的背景颜色 0xDDDDDD
		 */		
		static public const BACKCOLOR_INVALID:uint = 0xDDDDDD;
		/**
		 * 无效的背景颜色 0xFFFFFF
		 */		
		static public const BACKCOLOR_WHITE:uint = 0xFFFFFF;
		/**
		 * 无效的字体颜色 0x949494
		 */		
		static public const COLOR:uint = 0x949494;
		/**
		 * 有效的字体颜色 0x333333
		 */		
		static public const VAILDCOLOR:uint = 0x333333;
		/**
		 * spark的DataGrid处理开始编辑前的处理函数（gridItemEditorSessionStarting 事件）<br/>
		 * 使用直接gridItemEditorSessionStarting="{DataGridUtil.onGridItemEditorStarting(event)}"
		 * @param event
		 * 
		 */		
		static public function onGridItemEditorStarting(event:GridItemEditorEvent):void
		{
			if (event.column is GridColumnLabel)
			{
				var column:GridColumnLabel = event.column as GridColumnLabel;
				if (null != column.enableFunc)
				{
					var b:Boolean = column.enableFunc(event.column.grid.dataProvider[event.rowIndex],event.column);
					if (!b)
						event.preventDefault();
				}
			}
		}
		
		static public function invalidBackColorFunc(item:Object,column:DataGridColumn):uint
		{
			return BACKCOLOR_INVALID;
		}
		
		/**
		 * mx的DataGridColumnValidLabel的backColorFunc 
		 * @param item
		 * @return 
		 * 
		 */		
		static public function alwaysInValidFucn(item:Object):Boolean
		{
			return false;
		}
		
		/**
		 * mx的dg开始编辑前的处理函数,如果背景为灰就不进入编辑状态 
		 * @param event
		 * 
		 */		
		static public function onEditBeginning(event:DataGridEvent):void
		{
//			if (event.itemRenderer != null && (event.itemRenderer is DataGridItemRenderer) && 
//				(event.itemRenderer as DataGridItemRenderer).background && 
//				(event.itemRenderer as DataGridItemRenderer).backgroundColor == BACKCOLOR)
//				event.preventDefault();
			
			if (null != event.itemRenderer && event.itemRenderer is ppf.tool.components.mx.components.renderers.DataGridItemRenderer)
			{
				var render:ppf.tool.components.mx.components.renderers.DataGridItemRenderer = event.itemRenderer as ppf.tool.components.mx.components.renderers.DataGridItemRenderer;
				
				var column:DataGridColumnLabel = render.colum as DataGridColumnLabel;
				if (null != column && column.editable)
				{
					if (null != column.enableFunc)
					{
						var b:Boolean = column.enableFunc(render.data,column);
						if (!b)
							event.preventDefault();
					}
				}
			}
		}
		
		/**
		 * dg结束编辑后的处理函数,如果验证错误不退出编辑状态  
		 * @param event
		 * 
		 */		
		static public function onEditEnd(event:DataGridEvent):void
		{
			if (event.currentTarget.itemEditorInstance is IValidator)
			{
				var fCell:Array = [event.columnIndex,event.rowIndex,event.currentTarget];
				
				var dg:DataGrid = event.currentTarget as DataGrid;
				
				ValidUtil.registerValidators([_valid]);
				
				_valid.source = event.currentTarget.itemEditorInstance;
				_valid.property = "text";
				_valid.required = false;//不验证空值
				_valid.valieIValidator(event.currentTarget.itemEditorInstance);
				_valid.setEditErr();
				var val:* = _valid.validate();
				if (val.type == "invalid")
				{
					event.preventDefault();
					event.stopImmediatePropagation();
					dg.callLater(maintainEdit,fCell);
					
					if (event.currentTarget.itemEditorInstance && 
						event.currentTarget.itemEditorInstance is IFocusManagerComponent)
					{
						dg.callLater(IFocusManagerComponent(event.currentTarget.itemEditorInstance).setFocus);
					}
				
				}                                  
				else                              
				{                                 
					dg.callLater(maintainFocus,fCell);
				}
			}
			else
			{
				trace("DataGridUtil::onEditEnd event.currentTarget.itemEditorInstance is not IValidator");
			}
		}
		
		
		public function DataGridUtil()
		{
			throw new Error("DataGridUtil类只是一个静态方法类!");  
		}
		
		//输入编辑框有错则始终显示在该单元格
		static private function maintainEdit(colIndex:int,rowIndex:int,dg:DataGrid):void
		{
			var editCell:Object = {columnIndex:colIndex, rowIndex: rowIndex};
			if (dg.editedItemPosition == null)
			{
				dg.editedItemPosition = editCell;
				validateCurrentEditor(dg);
			}
		}
		/**
		 * 验证当前的编辑项 
		 * @param dg
		 * 
		 */		
		static private function validateCurrentEditor(dg:DataGrid):void
		{
			if (dg.itemEditorInstance != null)
			{
				_valid.source = dg.itemEditorInstance;  				
				_valid.validate();
			}
		}
		/**
		 * 保持编辑项输入的焦点 
		 * @param colIndex
		 * @param rowIndex
		 * @param dg
		 * 
		 */		
		static private function maintainFocus(colIndex:int,rowIndex:int,dg:DataGrid):void
		{
			dg.editedItemPosition = null;
			ValidUtil.unregisterValidators([_valid]);
		}
			
		//编辑完成的验证
		static private var _valid:Validator = new Validator;
	}
}