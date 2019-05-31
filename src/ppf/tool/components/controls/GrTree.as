package ppf.tool.components.controls
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import mx.collections.CursorBookmark;
	import mx.collections.ICollectionView;
	import mx.controls.Tree;
	
	import ppf.base.frame.CommandManager;
	import ppf.base.frame.ICommandManager;
	import ppf.base.resources.AssetsUtil;
	import ppf.tool.components.RightClickManager;
	
	public class GrTree extends Tree
	{
		public var cmdManager:ICommandManager;
		/**
		 * 打开Tree节点函数，被 有打开节点功能的函数调用
		 * @param item	要打开的节点
		 *
		 */
		public function OpenItems(item:Object):void
		{
			if (dataDescriptor.isBranch(item))
			{
				expandItem(item,!isItemOpen(item),false,true);
			}
		}
		
		public function GrTree()
		{
			super();
			
			this.dragEnabled = true;
			this.dragMoveEnabled = false;
			this.allowMultipleSelection = false;
			this.cacheAsBitmap = true;
			this.cacheHeuristic = true;
			this.cachePolicy = "on";
			iconFunction = tree_iconFunc;
			labelFunction = tree_labelFunc;
			cmdManager = CommandManager.getInstance();
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			addEventListener(KeyboardEvent.KEY_UP, tree_keyUp,false,0,true);
			this.addEventListener(RightClickManager.RIGHT_CLICK, rightClickHandler,false,0,true);
		}
		
		
		protected function getRightMenuData():Array
		{
			return null;
		}
		
		private function tree_iconFunc(item:Object):Class
		{
			if (null == item)
				return null;
			
			var tmpIcon:Class = AssetsUtil.stringToIcon(item.iconStr);
			return tmpIcon;
		}
		
		/**
		 * 计算子项个数
		 * @param item	节点
		 * @return 格式化后的字符串
		 *
		 */
		private function tree_labelFunc(item:Object):String
		{
			var children:ICollectionView;
			var suffix:String="";
			if (dataDescriptor.isBranch(item))
			{
				children=dataDescriptor.getChildren(item);
				
				if (null != children)
					suffix=" (" + children.length + ")";
			}
			
			return item[labelField] + suffix;
		}
		/**
		 * //TODO: 在控件上单击右键菜单事件的处理函数，生成右键菜单的项目
		 * @param event 右键事件
		 *
		 */
		protected function rightClickHandler(event:Event):void
		{
			//选中列表组件的鼠标位置点所在的项目
			RightClickManager.selectMenuAtItem(event);
			
			//如鼠标位置点不在项目上，则选中列表的第一项
			if (this.selectedIndex < 0)
				this.selectedIndex=0;
			
			if (null != selectedItem)
			{
				//菜单数据
				var menuData:Array = getRightMenuData();
				
				// RightClickManager.showMenu(this, menuData, cmdManager.onClickToolBar);
				//cmdManager.setArguments(cmdManager.mainFrame,selectedItem);
				
				RightClickManager.showMenu(cmdManager, this, menuData, [selectedItem]);
			}
		}
		/**
		 * Tree菜单键盘事件，应被实例类根据应用的不同需重构本函数
		 * @param evt	键盘事件源
		 *
		 */
		private function tree_keyUp(evt:KeyboardEvent):void
		{
			if (evt.charCode == Keyboard.ENTER)
			{
				var item:Object = Tree(evt.currentTarget).selectedItem;
				if (item != null)
				{
					OpenItems(item);
				}
			}
		}
		
		override protected function configureScrollBars():void
		{
			var rowCount:int = listItems.length;
			if (rowCount == 0) return;
			
			// ignore nonvisible rows off the top
			var yy:Number;
			var i:int;
			var n:int = listItems.length;
			// if there is more than one row and it is a partial row we dont count it
			while (rowCount > 1 && rowInfo[n - 1].y + rowInfo[n-1].height > listContent.height - listContent.bottomOffset)
			{
				rowCount--;
				n--;
			}
			
			// offset, when added to rowCount, is the index of the dataProvider
			// item for that row.  IOW, row 10 in listItems is showing dataProvider
			// item 10 + verticalScrollPosition - lockedRowCount - 1;
			var offset:int = verticalScrollPosition - lockedRowCount - 1;
			// don't count filler rows at the bottom either.
			var fillerRows:int = 0;
			// don't count filler rows at the bottom either.
			while (rowCount && listItems[rowCount - 1].length == 0)
			{
				if (collection && rowCount + offset >= collection.length)
				{
					rowCount--;
					++fillerRows;
				}
				else
					break;
			}
			
			// we have to scroll up.  We can't have filler rows unless the scrollPosition is 0
			// We don't do the adjustment if a data effect is running, because that prevents
			// a smooth effect. Effectively, we pin the scroll position while the effect is
			// running.
			if (verticalScrollPosition > 0 && fillerRows > 0 && !runningDataEffect)
			{
				trace("verticalScrollPosition->" + verticalScrollPosition);
//				var bookmark:CursorBookmark = iterator.bookmark;
//				var rowIndex:int = bookmark.getViewIndex();
//				if (verticalScrollPosition != rowIndex - lockedRowCount)
//				{
//					// we got totally out of sync, probably because a filter
//					// removed or added rows
//					super.verticalScrollPosition = Math.max(rowIndex - lockedRowCount, 0);
//				}
//				
//				if (adjustVerticalScrollPositionDownward(Math.max(rowCount, 1)))
//					return;
			}
			
			if (listContent.topOffset)
			{
				yy = Math.abs(listContent.topOffset);
				i = 0;
				while (rowInfo[i].y + rowInfo[i].height <= yy)
				{
					rowCount--;
					i++;
					if (i == rowCount)
						break;
				}
			}
			
			var colCount:int = listItems[0].length;
			var oldHorizontalScrollBar:Object = horizontalScrollBar;
			var oldVerticalScrollBar:Object = verticalScrollBar;
			var roundedWidth:int = Math.round(unscaledWidth);
			var length:int = collection ? collection.length - lockedRowCount: 0;
			var numRows:int = rowCount - lockedRowCount;
			
			setScrollBarProperties((isNaN(maxHorizontalScrollPosition)) ?
				Math.round(listContent.width) :
				Math.round(maxHorizontalScrollPosition + roundedWidth),
				roundedWidth, length, numRows);
			maxVerticalScrollPosition = Math.max(length - numRows, 0);
			
		}
		
	}
}