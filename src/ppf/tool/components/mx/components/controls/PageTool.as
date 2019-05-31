package ppf.tool.components.mx.components.controls
{
	import ppf.tool.text.RestrictUtil;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import flash.utils.getDefinitionByName;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ICollectionView;
	import mx.collections.IList;
	import mx.collections.ListCollectionView;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.collections.XMLListCollection;
	import mx.containers.HBox;
	import mx.controls.AdvancedDataGrid;
	import mx.controls.DataGrid;
	import mx.controls.Label;
	import mx.controls.Spacer;
	import mx.controls.advancedDataGridClasses.AdvancedDataGridBase;
	import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.ScrollPolicy;
	import mx.events.AdvancedDataGridEvent;
	import mx.events.CollectionEvent;
	import mx.events.DataGridEvent;
	
	/**
	 * 分页控件，指定targetUI </br>
	 * PerPage 1页显示行数
	 * @author wangke
	 * 
	 */	
	public class PageTool extends HBox
	{
		public static const EVENT_PAGE_CHANGE:String = "Event_Page_Change";
		
		/**
		 * 设置每页显示数据条数，默认10条
		 * @param value
		 * 
		 */	
		public function get perPage():Number
		{
			return _perPage;
		}
		[Bindable]
		public function set perPage(value:Number):void
		{
			if(isNaN(value)||value == 0)
			{
				value=10;
			}
			_perPage=value;
		}

		public function get dataProvider():Object
		{
			return _collection;
		}
		/**
		 * 设置数据源 
		 * @param value
		 * 
		 */		
		public function set dataProvider(value:Object):void
		{
			_currIndex = 0;
			if (value is Array)
			{
				_collection = new ArrayCollection(value as Array);
			}
			else if (value is ICollectionView)
			{
				_collection = ICollectionView(value);
			}
			else if (value is IList)
			{
				_collection = new ListCollectionView(IList(value));
			}
			else if (value is XMLList)
			{
				_collection = new XMLListCollection(value as XMLList);
			}
			else if (value is XML)
			{
				var xl:XMLList = new XMLList();
				xl += value;
				_collection = new XMLListCollection(xl);
			}
			else
			{
				var tmp:Array = [];
				if (value != null)
					tmp.push(value);
				_collection = new ArrayCollection(tmp);
			}
			
			if(_targetUI)
				BeginControll();
			
//			this.enabled = _collection.length == 0?false:true;
		}
		
		/**
		 * 设置控制的组件  
		 * @param value
		 * 
		 */		
		public function set targetUI(value:Object):void
		{
			_targetUI = value
			
			if(_collection)
			{
				BeginControll();
			}
			else if(_targetUI.dataProvider)
			{
				_collection=_targetUI.dataProvider;
			}
			else
			{
				trace("控制器对象，以及控制器都没有设置数据源，监听控制器对象数据源更改事件！");
				_targetUI.addEventListener(CollectionEvent.COLLECTION_CHANGE,onDataChange);
			}
		}
		
		/**
		 * 开始控制，当手动更改数据源时，必须启动此方法 
		 * 
		 */		
		public function BeginControll():void
		{
			if(!_targetUI||!_collection)
			{
				throw new Error("没有设置控制器对象！");
				return;
			}
			if(_targetUI.hasEventListener(CollectionEvent.COLLECTION_CHANGE))
			{
				_targetUI.removeEventListener(CollectionEvent.COLLECTION_CHANGE,onDataChange);
			}
			_totalCounts=_collection.length;
			_totalPages=Math.ceil(_totalCounts/_perPage);
			
//			if(_targetUI is mx.controls.DataGrid)
//			{
//				_targetUI.addEventListener(DataGridEvent.HEADER_RELEASE,onDGHeaderRelease);
//			}
			//added by thegod
//			if(_targetUI is AdvancedDataGridBase)
//			{
//				_targetUI.addEventListener(AdvancedDataGridEvent.SORT,onADGHeaderSort);
//			}
			RefershData();
		}
		
		public function PageTool()
		{
			super();
		}
		
		protected function onFirstClick(event:MouseEvent):void
		{
			dispatchPageChangeEvent();
			_currIndex = 0;
			RefershData();
			
		}
		protected function onPreviousClick(event:MouseEvent):void
		{
			dispatchPageChangeEvent();
			goto(-1);
		}
		protected function onNextClick(event:MouseEvent):void
		{
			dispatchPageChangeEvent();
			goto(1);
		}
		protected function onLastClick(event:MouseEvent):void
		{
			dispatchPageChangeEvent();
			_currIndex = _totalPages-1;
			RefershData();
		}
		
		protected function onKeyBoardEvent(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.ENTER)
			{
				var num:Number = Number(_pageNum.text);
				if (num == 0)
				{
					_currIndex = 0;
				}
				else if (num<_totalPages)
				{
					_currIndex = num-1;
				}
				else
				{
					_currIndex = _totalPages-1;
					_pageNum.text = _totalPages.toString();
				}
				dispatchPageChangeEvent();
				RefershData();
				event.stopImmediatePropagation();
			}
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			this.horizontalScrollPolicy = ScrollPolicy.OFF;
			this.verticalScrollPolicy = ScrollPolicy.OFF;
//			this.enabled = false;
			this.setStyle("horizontalGap",0);
			this.minHeight = 30;
//			this.maxWidth = 250;
			
//			var spacer:Spacer = new Spacer;
//			this.addChild(spacer);
//			spacer.percentWidth = 100;
			
			if (null == _btnFirst)
			{
				_btnFirst = new LinkButton;
				this.addChild(_btnFirst);
				_btnFirst.toolTip = "第一页";
				_btnFirst.label = "|<";
				_btnFirst.maxWidth = 33;
				_btnFirst.minWidth = 33;
				_btnFirst.enabled = false;
				_btnFirst.setStyle("icon",firstIcon);
				_btnFirst.addEventListener(MouseEvent.CLICK,onFirstClick,false,0,true);
			}
			
			if (null == _btnPrevious)
			{
				_btnPrevious = new LinkButton;
				this.addChild(_btnPrevious);
				_btnPrevious.toolTip = "上一页";
				_btnPrevious.label = "<";
				_btnPrevious.maxWidth = 25;
				_btnPrevious.minWidth = 25;
				_btnPrevious.enabled = false;
				_btnPrevious.setStyle("icon",previousIcon);
				_btnPrevious.addEventListener(MouseEvent.CLICK,onPreviousClick,false,0,true);
			}
			var di:Label = new Label;
			this.addChild(di);
			di.text = "第";
			di.setStyle("fontSize",12);
			
			if (null == _pageNum)
			{
				_pageNum = new TextInput;
				this.addChild(_pageNum);
				_pageNum.text = "0";
				_pageNum.width = 33;
				_pageNum.restrict = RestrictUtil.POSITIVE_INT_REG;
				_pageNum.maxChars = 3;
				_pageNum.maxWidth = 33;
				_pageNum.addEventListener(KeyboardEvent.KEY_DOWN,onKeyBoardEvent,false,0,true);
			}
			
			if (null == _total)
			{
				_total = new Label;
				this.addChild(_total);
				_total.text = "页/共0页";
				_total.setStyle("fontSize",12);
			}

			if (null == _btnNext)
			{
				_btnNext = new LinkButton;
				this.addChild(_btnNext);
				_btnNext.toolTip = "下一页";
				_btnNext.label=">";
				_btnNext.maxWidth = 25;
				_btnNext.minWidth = 25;
				_btnNext.enabled = false;
				_btnNext.setStyle("icon",nextIcon);
				_btnNext.addEventListener(MouseEvent.CLICK,onNextClick,false,0,true);
			}
			
			if (null == _btnLast)
			{
				_btnLast = new LinkButton;
				this.addChild(_btnLast);
				_btnLast.toolTip = "最后页";
				_btnLast.label = ">|";
				_btnLast.maxWidth = 33;
				_btnLast.minWidth = 33;
				_btnLast.enabled = false;
				_btnLast.setStyle("icon",lastIcon);
				_btnLast.addEventListener(MouseEvent.CLICK,onLastClick,false,0,true);
			}
		}
		
		private function onDataChange(event:CollectionEvent):void
		{
			trace("触发控制器对象数据源更改事件！");
			targetUI=_targetUI;
		}
		
		private function goto(value:Number):void
		{
			_currIndex+=value;
			RefershData();
		}
		
		
//		public function onDGHeaderRelease(event:DataGridEvent):void
//		{
//			var column:DataGridColumn = DataGridColumn(event.currentTarget.columns[event.columnIndex]);
//			(event.currentTarget as mx.controls.DataGrid).callLater(onCallLaterDG, [column]);
//		}
//		
//		private function onCallLaterDG(column:DataGridColumn):void 
//		{
//			sortDataSourceItem(column.dataField);
//		}
//		
//		private function sortDataSourceItem(target:Object):void
//		{
//			descending=!descending;
//			sort.fields=[new SortField(target.toString(),true,descending,true)];
//			_collection.sort=sort;
//			_collection.refresh();
//			RefershData();
//		}
		
		
//		private function onADGHeaderSort(event:AdvancedDataGridEvent):void
//		{
//			var column:AdvancedDataGridColumn = AdvancedDataGridColumn(event.currentTarget.columns[event.columnIndex]);
//			
//			AdvancedDataGrid(event.currentTarget).callLater(onCallLaterAdv, [column,event.multiColumnSort]);
//		}
		
//		private function onCallLaterAdv(column:AdvancedDataGridColumn,multiColumnSort:Boolean):void 
//		{
//			sortAdvancedDataSourceItem(column.dataField, multiColumnSort);
//		}

//		private function sortAdvancedDataSourceItem(target:Object, isMulti:Boolean):void
//		{
//			//只要点的是排序光标，isMulti都等于true，就算只有一个字段更改direction。
//			if(!isMulti)
//			{
//				sortFields.removeAll();
//				sortFields.addItem(new SortField(target.toString(),true,false,true));
//			}
//			else
//			{
//				//add new sort column or change direction
//				existsField(target.toString());
//			}
//			
//			sort.fields=sortFields.toArray();
//			
//			_collection.sort=sort;
//			_collection.refresh();
//			RefershData();
//		}
		
		private function existsField(fieldName:String):Boolean
		{
			if(sortFields == null)
			{
				sortFields = new ArrayCollection();
			}
			for(var i:int=0;i<sortFields.length;i++)
			{
				var sortField:SortField = sortFields.getItemAt(i) as SortField;
				if(sortField.name == fieldName)
				{
					//系统已经自动替换了sortFields里面的升序降序，因此什么都不用做
					return true;
				}
			}
			sortFields.addItem(new SortField(fieldName,true,false,true));
			return false;
		}
		
		private function RefershData():void
		{
			filterFunction();
			
//			if(sort.fields)
//				_currData.sort=sort;
			
			_targetUI.dataProvider=_currData;
			_currData.refresh();
			
//			_pageInfo.text="第 "+(_currIndex+1)+" 页/共 "+_totalPages+" 页";
			_total.text = " 页/共 "+_totalPages+" 页";
			
			_pageNum.text = (_currIndex+1).toString();
			
			_btnNext.enabled=_currIndex>=_totalPages-1?false:true;
			
			_btnPrevious.enabled=_currIndex<=0?false:true;
			
			_btnFirst.enabled = _currIndex==0?false:true;
			_btnLast.enabled = _totalPages==0?false:(_currIndex==(_totalPages-1)?false:true);
		}
		private function filterFunction():void
		{
			_currData = new ArrayCollection();
			var start:int=_currIndex*_perPage;
			var end:int=_perPage*(_currIndex+1);
			
			if(end>=_collection.length)
				end=_collection.length;
			for(var index:int=start;index<end;index++)
			{
				_currData.addItem(_collection[index]);
			}
			/**使用Array数据源时
			 * 可以将本方法内以上代码修改为
			 * _currDS=_collection.slice(_currIndex*_perPage,_perPage*(_currIndex+1));
			 * **/
		}
		
		/**
		 * 发送页面改变事件 
		 * 
		 */		
		private function dispatchPageChangeEvent():void
		{
			var event:Event = new Event(EVENT_PAGE_CHANGE);
			this.dispatchEvent(event);
		}
		
		[Embed(source='/assets/first.png')]
		private var firstIcon:Class;
		
		[Embed(source='/assets/last.png')]
		private var lastIcon:Class;

		[Embed(source='/assets/next.png')]
		private var nextIcon:Class;

		[Embed(source='/assets/previous.png')]
		private var previousIcon:Class;

		
		private var _targetUI:Object;
		
		private var _btnFirst:LinkButton;
		private var _btnNext:LinkButton;
		private var _btnPrevious:LinkButton;
		private var _btnLast:LinkButton;
		
		private var _pageNum:TextInput;
		
		private var _total:Label;
		
		private var _collection:ICollectionView;
		
		private var _currData:ArrayCollection;
		
		private var _currIndex:int=0;
		private var _totalPages:Number;
		private var _totalCounts:Number;
		private var _perPage:Number = 10;;
		
		private var descending:Boolean = false;
		
		private var sortFields:ArrayCollection = new ArrayCollection();
		private var sort:Sort = new Sort();
	}
}