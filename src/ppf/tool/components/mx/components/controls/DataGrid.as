package ppf.tool.components.mx.components.controls
{
	import ppf.tool.components.DataGridUtil;
	import ppf.tool.components.IDataGridColumnSortField;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.controls.DataGrid;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.controls.listClasses.IListItemRenderer;
	import mx.core.EventPriority;
	import mx.core.mx_internal;
	import mx.events.DataGridEvent;
	import mx.events.FlexEvent;

	use namespace mx_internal;
	/**
	 * 自定义DataGrid
	 * 自定义过滤行背景颜色函数 rowColorFunction 返回过滤的行的颜色
	 * 自定义绘制列背景颜色 columnBackgroundFunction 直接实现绘制方法
	 * 自定义过滤选中项函数 disabledFunction true：选中
	 * 优化横向滚动条的速度
	 * @author wangke
	 *
	 */
	public class DataGrid extends mx.controls.DataGrid
	{
		[Bindable]
		/**
		 * 操作的数据源 
		 * @return 
		 * 
		 */		
		public var opDataProvider:Array;
		/**
		 * 锁定排序的列 从0开始计算
		 */		
		public var lockedSortCount:int=-1;
		/**
		 * 最大显示数据行数 
		 */
		public var showMaxRowCount:Number = 7;
		
		/**
		 * 显示最小的数据行数
		 */		
		public var showMinRowCount:Number = 1;
		
		public function DataGrid()
		{
			super();
		}
		
		/**
		 * 根据数据自动适应行高 true：自动 false：默认
		 * @return 
		 * 
		 */
		public function get autoRowHeight():Boolean
		{
			return _autoRowHeight;
		}
		
		public function set autoRowHeight(value:Boolean):void
		{
			_autoRowHeight = value;
		}
		
		/**
		 * 行背景颜色	myRowColorFunction(item:Object, color:uint):uint
		 * @param f 自定义行背景颜色过滤函数
		 *
		 */
		public function set rowColorFunction(f:Function):void
		{
			this._rowColorFunction = f;
		}
		
		/**
		 * 列背景颜色
		 * myColumnGradient(column:DataGridColumn,columnIndex:int,columnShape:Shape,x:Number,y:Number,width:Number,height:Number):void
		 * 随便设置 "列" 的backgroundColor背景色，会调用此函数重绘该 "列" 背景
		 * @param f 自定义列背景绘制函数
		 *
		 */
		public function set columnBackgroundFunction(f:Function):void
		{
			this._columnBackgroundFunction = f;
		}
		
		/**
		 * 列背景颜色透明度
		 * @param value 透明度值
		 *
		 */		 
		public function set columnBackgroundAlpha(value:Number):void
		{
			_columnBackgroundAlpha = value;
		}
		
		/**
		 * 项目是否禁止选中 true：不能选中 
		 * myDisabledFunction(data:Object):Boolean
		 * @param f
		 *
		 */
		public function set disabledFunction(f:Function):void
		{
			this._disabledFunction = f;
		}
		
		/**
		 *  when the horizontal scrollbar is changed it will eventually set horizontalScrollPosition
		 *  This value can be set programmatically as well.
		 */
		//		override public function set horizontalScrollPosition(value:Number):void
		//		{
		//			// remember the setting of this flag.  We will tweak it in order to keep DataGrid from
		//			// doing its default horizontal scroll which essentially refreshes every renderer
		//			var lastItemsSizeChanged:Boolean = itemsSizeChanged;
		//			
		//			// remember the current number of visible columns.  This can get changed by DataGrid
		//			// as it recomputes the visible columns when horizontally scrolled.
		//			lastNumberOfColumns = visibleColumns.length;
		//			
		//			// reset the flag for whether we use our new technique
		//			canUseScrollH = false;
		//			
		//			// call the base class.  If we can use our technique we'll trip that flag
		//			super.horizontalScrollPosition = value;
		//			
		//			// if the flag got tripped run our new technique
		//			if (canUseScrollH)
		//				scrollLeftOrRight();
		//			
		//			// reset the flag
		//			itemsSizeChanged = lastItemsSizeChanged;
		//			
		//		}
		
		/**
		 * 获取鼠标所在的行索引 
		 * @return 行索引
		 * 
		 */		
		public function getDGMouseIndex():Number
		{
			var findex:Number = Math.floor(this.contentMouseY / this.rowHeight) - 1 + this.verticalScrollPosition;
			if (findex<0 || findex>=this.verticalScrollPosition+this.rowCount-1) 
			{
				return -1;
			} 
			else
			{
				return findex;
			}
		}
		
		/**
		 * 获取鼠标所在的行索引 (优化代码)
		 * @return 行索引
		 * 
		 */	
		public function getMouseIndex():Number{
			var findex:Number = Math.floor((this.mouseY - this.headerHeight) / this.rowHeight) + this.verticalScrollPosition;
			if (findex<0 || findex>=this.verticalScrollPosition+this.rowCount-1) 
			{
				return -1;
			} 
			else
			{
				return findex;
			}
		}
		
		/**
		 * 用于鼠标右键列表点击处理
		 * @return 
		 * 
		 */	
		public function get highlightItemRenderer_k():IListItemRenderer
		{
			return highlightItemRenderer;
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			percentWidth=100;
			percentHeight=100;
			
			this.addEventListener(DataGridEvent.HEADER_RELEASE,onHeaderRelease,false,EventPriority.DEFAULT_HANDLER,true);
			this.addEventListener(FlexEvent.CREATION_COMPLETE,_onCreateComplete,false,0,true);
			this.addEventListener(DataGridEvent.ITEM_EDIT_BEGINNING,onItemEditBeginning,false,0,true);
		}
		
		protected function onCreateComplete():void
		{
			
		}
		
		private function onItemEditBeginning(event:DataGridEvent):void
		{
			DataGridUtil.onEditBeginning(event);
		}
		
		private function _onCreateComplete(event:FlexEvent):void
		{
			this.removeEventListener(FlexEvent.CREATION_COMPLETE,_onCreateComplete);
			
			//行的该行中渲染器顶部之间的像素数目
			setStyle("paddingBottom",0);
			setStyle("paddingTop",0);
			
			onCreateComplete();
		}
		
		// override this method.  If it gets called that means we can use the new technique
		//		override protected function scrollHorizontally(pos:int, deltaPos:int, scrollUp:Boolean):void
		//		{
		//			// just remember the args for later;
		//			this.pos = pos;
		//			this.deltaPos = deltaPos;
		//			this.scrollUp = scrollUp;
		//			if (deltaPos < visibleColumns.length)
		//			{
		//				canUseScrollH = true;
		//				
		//				// need this to prevent DG from asking for a full refresh
		//				itemsSizeChanged = true;
		//			}
		//		}
		
		/**
		 * 行背景颜色
		 *
		 */
		override protected function drawRowBackground(s:Sprite,rowIndex:int,y:Number,height:Number,color:uint,dataIndex:int):void
		{
			if(null != _rowColorFunction && dataIndex < this.dataProvider.length )
			{
				var item:Object = this.dataProvider.getItemAt(dataIndex);
				color = this._rowColorFunction.call(this, item, color);
			}
			
			super.drawRowBackground(s, rowIndex, y, height, color, dataIndex);
		}
		
		/**
		 * 重绘列背景
		 * 例子：
		 * var m:Matrix = new Matrix();
		 * m.createGradientBox(width,height,0,x,0);
		 * columnShape.graphics.clear();
		 * columnShape.graphics.beginGradientFill(GradientType.LINEAR,[0xFFFF00,0xFF0000],[1,1],[0,255],m);
		 * columnShape.graphics.drawRect(x,y,width,height);
		 * columnShape.graphics.endFill();
		 *
		 */		
		override protected function drawColumnBackground(s:Sprite, columnIndex:int, color:uint, column:DataGridColumn):void
		{
			super.drawColumnBackground(s,columnIndex,color,column);
			
			var background:Shape = Shape(s.getChildByName(columnIndex.toString()));
			if( background ) 
			{
				background.alpha = _columnBackgroundAlpha;
			}
			
			if(_columnBackgroundFunction != null ) 
			{
				var columnShape:Shape = Shape(s.getChildByName("lines"+columnIndex.toString()));
				if( columnShape == null ) 
				{
					columnShape = new Shape();
					columnShape.name = "lines"+columnIndex;
					s.addChild(columnShape);
				}
				var lastRow:Object = rowInfo[listItems.length - 1];
				var xx:Number = listItems[0][columnIndex].x;
				var yy:Number = rowInfo[0].y;
				var ww:Number = listItems[0][columnIndex].width;
				//				if (this.headerHeight > 0)
				//					yy += rowInfo[0].height;
				
				// Height is usually as tall is the items in the row, but not if
				// it would extend below the bottom of listContent
				var hh:Number = Math.min(lastRow.y + lastRow.height,
					listContent.height - yy);
				
				_columnBackgroundFunction(column,columnIndex,columnShape,xx,yy,ww,hh );
			}
		}
		
		/**
		 * 项目禁止选中处理函数
		 */
		override protected function  drawItem(item:IListItemRenderer,selected:Boolean=false,highlighted:Boolean=false,caret:Boolean=false, transition:Boolean=false):void 
		{ 
			if(null != _disabledFunction && _disabledFunction(item.data)) 
			{ 
				item.enabled = false; 
				selected = false; 
				highlighted = false; 
			} 
			super.drawItem(item, selected, highlighted, caret, transition); 
		} 
		
		/**
		 * 项目禁止选中处理函数
		 */
		override protected function mouseEventToItemRenderer(event:MouseEvent):IListItemRenderer
		{
			var listItem:IListItemRenderer = super.mouseEventToItemRenderer(event);
			if (listItem)
			{
				if (listItem.data)
				{
					if (null != _disabledFunction && _disabledFunction(listItem.data))
					{
						return null;
					}
				}
			}
			return listItem;
		}
         
		/**
		 * 项目禁止选中处理函数 设置垂直选择方向
		 */
		override protected function moveSelectionVertically(code:uint, shiftKey:Boolean,ctrlKey:Boolean):void
		{
			if (code == Keyboard.DOWN)
				selectionUpward = false;
			else
				selectionUpward = true;
			super.moveSelectionVertically(code, shiftKey, ctrlKey);
		}
		
		/**
		 * 禁止选中的键盘处理函数
		 *
		 */
		override protected function finishKeySelection():void
		{
			super.finishKeySelection();
			
			var i:int;
			var uid:String;
			var rowCount:int = listItems.length;
			var partialRow:int = (rowInfo[rowCount-1].y + rowInfo[rowCount-1].height >
				listContent.height) ? 1 : 0;
			
			var listItem:IListItemRenderer;
			listItem = listItems[caretIndex - verticalScrollPosition][0];
			if (listItem)
			{
				if (listItem.data)
				{
					if (null != _disabledFunction && _disabledFunction(listItem.data))
					{
						// find another visible item that is enabled
						// assumes there is one that is fully visible
						rowCount = rowCount - partialRow;
						var idx:int = caretIndex - verticalScrollPosition;
						if (selectionUpward)
						{
							// look up;
							for (i = idx - 1; i >= 0; i--)
							{
								listItem = listItems[i][0];
								if (null != _disabledFunction && !_disabledFunction(listItem.data))
								{
									selectedIndex = i - verticalScrollPosition;
									return;
								}
							}
							for (i = idx + 1; i < rowCount; i++)
							{
								listItem = listItems[i][0];
								if (null != _disabledFunction && !_disabledFunction(listItem.data))
								{
									selectedIndex = i - verticalScrollPosition;
									return;
								}
							}
						}
						else
						{
							// look down;
							for (i = idx + 1; i < rowCount; i++)
							{
								listItem = listItems[i][0];
								if (listItem)
								{
									if (null != _disabledFunction && !_disabledFunction(listItem.data))
									{
										selectedIndex = i - verticalScrollPosition;
										return;
									}
								}
							}
							for (i = idx - 1; i >= 0; i--)
							{
								listItem = listItems[i][0];
								if (null != _disabledFunction && !_disabledFunction(listItem.data))
								{
									selectedIndex = i - verticalScrollPosition;
									return;
								}
							}
						}
					}
				}
			}
		}
		
		/**
		 * 当数据发生更改时，处理从数据提供程序中调度的 CollectionEvent。根据需要，更新渲染器、所选索引和滚动条。
		 * @param event
		 * 
		 */		
		override protected function collectionChangeHandler(event:Event) : void
		{
			super.collectionChangeHandler(event);
			
			if (_autoRowHeight)
			{
				if  (null == dataProvider)
					return;
				
				var dataLen:Number = dataProvider.length;
				var tmpHeight:Number;
				//有数据，切数据行数小于最大显示的数据行数
				if (dataLen != 0 && dataLen <= showMaxRowCount)
				{
					tmpHeight = dataLen*this.rowHeight+(showHeaders?25:0);
					
					this.height = tmpHeight;
					this.rowCount = dataLen;
				}
					//有数据，切数据行数大于最大显示的数据行数
				else if (dataLen != 0 && dataLen > showMaxRowCount)
				{
					tmpHeight = showMaxRowCount*this.rowHeight+(showHeaders?25:0);
					this.height = tmpHeight;
					this.rowCount = showMaxRowCount;
				}
					//没有数据，显示最小显示的数据行数
				else if (dataLen == 0)
				{
					this.height = showMinRowCount*rowHeight+(showHeaders?25:0);
					this.rowCount = showMinRowCount;
					//必须判断设置，否则rowHeight会被修改
					if (isNaN(this.explicitRowHeight))
						this.explicitRowHeight = this.rowHeight;
				}
			}
		}
		
		/**
		 * 表头点击的排序处理 优先级等于DataGrid但是后注册所以后执行
		 * @param event
		 * 
		 */		
		private function onHeaderRelease(event:DataGridEvent):void
		{
			var loclColumn:DataGridColumn;
			
			if (-1 != lockedSortCount)
				loclColumn = columns[lockedSortCount];
			
			if (null != dataProvider && dataProvider is ArrayCollection)
			{
				var c:DataGridColumn = columns[event.columnIndex];
				
				if (c is IDataGridColumnSortField && null != (dataProvider as ArrayCollection).sort)
				{
					var fields:Array = (dataProvider as ArrayCollection).sort.fields;
					
					var sfArr:Array = (c as IDataGridColumnSortField).sortField;
					
					//当前点击的列不是锁定排序的列
					if (null != loclColumn && lockedSortCount != event.columnIndex)
					{
						if (loclColumn is IDataGridColumnSortField)
						{
							sfArr = sfArr.concat((loclColumn as IDataGridColumnSortField).sortField);
						}
						else
							sfArr.push(new SortField(loclColumn.dataField,false,loclColumn.sortDescending));
					}
					
					if (null != sfArr)
					{
						for each (var sf:SortField in sfArr)
						{
							sf.descending = c.sortDescending;
						}
						(dataProvider as ArrayCollection).sort.fields = fields.concat(sfArr);
						/**
						 * 不使用refresh();直接改变source的排序
						 * 在ListCollectionView里面localIndex用于视图经过排序或过滤后，localIndex 属性会在排序或过滤后（已排序、已缩减）的视图中包含按排序顺序显示的项目的数组。
						 * 每次refresh都会先进入populateLocalIndex获取source即list的copy，再internalRefresh进行过滤然后再排序，所以sort=null直接禁止排序需要改变source的原因
						 * */
						(dataProvider as ArrayCollection).sort.sort((dataProvider as ArrayCollection).source);
					}
					//取消默认排序点击表头和添加修改都不再排序了
					(dataProvider as ArrayCollection).sort = null;
					(dataProvider as ArrayCollection).refresh();
					//用于更改排序的升降序
					c.sortDescending = !c.sortDescending;
				}
			}
		}
		
		private var desc:Boolean

		/**
		 *  remember the number of columns in case it changes
		 */
		//		private var lastNumberOfColumns:int;
		
		/**
		 *  a flag as to whether we can use the optimized scrolling
		 */
		//		private var canUseScrollH:Boolean;
		// remember the parameters to scrollHorizontally to be used in our new technique
		//		private var pos:int;
		//		private var deltaPos:int;
		//		private var scrollUp:Boolean;
		
		//行背景颜色自定义行数
		private var _rowColorFunction:Function;
		//列背景颜色自定义行数
		private var _columnBackgroundFunction:Function;
		//透明度
		private var _columnBackgroundAlpha:Number = 1;
		//item禁止选中自定义函数
		private var _disabledFunction:Function;
		
		//是否向上选择 true：向上	false：向下
		private var selectionUpward:Boolean;
		
		//根据数据自动适应行高
		private var _autoRowHeight:Boolean = false;
		
		/**
		 *  The new technique does roughly what we do vertically.  We shift the renderers on screen and in the
		 *  listItems array and only make the new renderers.
		 *  Because we can't get internal access to the header, we fully refresh it, but that's only one row
		 *  of renderers.  There's significant gains to be made by not fully refreshing the every row of columns
		 *
		 *  Key thing to note here is that visibleColumns has been updated, but the renderer array has not
		 *  That's why we don't do this in scrollHorizontally as the visibleColumns hasn't been updated yet
		 *  But because of that, sometimes we have to measure old renderers, and sometimes we measure the columns
		 */
		//		private function scrollLeftOrRight():void
		//		{
		//			// trace("scrollHorizontally " + pos);
		//			var i:int;
		//			var j:int;
		//			
		//			var numCols:int;
		//			var uid:String;
		//			
		//			var curX:Number;
		//			
		//			var rowCount:int = rowInfo.length;
		//			var columnCount:int = listItems[0].length;
		//			var cursorPos:CursorBookmark;
		//			
		//			var moveBlockDistance:Number = 0;
		//			
		//			var c:DataGridColumn;
		//			var item:IListItemRenderer;
		//			var itemSize:Point;
		//			var data:Object;
		//			
		//			var xx:Number;
		//			var yy:Number;
		//			
		//			if (scrollUp) // actually, rows move left
		//			{
		//				// determine how many columns we're discarding
		//				var discardCols:int = deltaPos;
		//				
		//				// measure how far we have to move by measuring the width of the columns we
		//				// are discarding
		//				
		//				moveBlockDistance = sumColumnWidths(discardCols, true);
		//				// trace("moveBlockDistance = " + moveBlockDistance);
		//				
		//				//  shift rows leftward and toss the ones going away
		//				for (i = 0; i < rowCount; i++)
		//				{
		//					numCols = listItems[i].length;
		//					
		//					// move the positions of the row, the item renderers for the row,
		//					// and the indicators for the row
		//					moveRowHorizontally(i, discardCols, -moveBlockDistance, numCols);
		//					// move the renderers within the array of rows
		//					shiftColumns(i, discardCols, numCols);
		//					truncateRowArray(i);
		//				}
		//				
		//				// generate replacement columns
		//				cursorPos = iterator.bookmark;
		//				
		//				var firstNewColumn:int = lastNumberOfColumns - deltaPos;
		//				curX = listItems[0][firstNewColumn - 1].x + listItems[0][firstNewColumn - 1].width;
		//				
		//				//添加渲染器循环当前可见的数据源行数
		//				var len:Number = this.dataProvider.length <rowCount ==true? this.dataProvider.length:rowCount;
		//				for (i = 0; i < len; i++)
		//				{
		//					data = iterator.current;
		//					iterator.moveNext();
		//					uid = itemToUID(data);
		//					
		//					xx = curX;
		//					yy = rowInfo[i].y;
		//					for (j = firstNewColumn; j < visibleColumns.length; j++)
		//					{
		//						c = visibleColumns[j];
		//						item = setupColumnItemRenderer(c, listContent, i, j, data, uid);
		//						itemSize = layoutColumnItemRenderer(c, item, xx, yy);
		//						xx += itemSize.x;
		//					}
		//					// toss excess columns
		//					if (listItems[i].length > visibleColumns.length)
		//					{
		//						addToFreeItemRenderers(listItems[i].pop());
		//					}
		//				}
		//				
		//				iterator.seek(cursorPos, 0);           
		//			}
		//			else
		//			{
		//				numCols = listItems[0].length;
		//				
		//				moveBlockDistance = sumColumnWidths(deltaPos, false);
		//				
		//				// shift the renderers and slots in array
		//				for (i = 0; i < rowCount; i++)
		//				{
		//					numCols = listItems[i].length;
		//					
		//					moveRowHorizontally(i, 0, moveBlockDistance, numCols);
		//					// we add placeholders at the front for new renderers
		//					addColumnPlaceHolders(i, deltaPos);
		//					
		//				}
		//				
		//				cursorPos = iterator.bookmark;
		//				
		//				for (i = 0; i < rowCount; i++)
		//				{
		//					data = iterator.current;
		//					iterator.moveNext();
		//					uid = itemToUID(data);
		//					
		//					xx = 0;
		//					yy = rowInfo[i].y;
		//					for (j = 0; j < deltaPos; j++)
		//					{
		//						c = visibleColumns[j];
		//						item = setupColumnItemRenderer(c, listContent, i, j, data, uid);
		//						itemSize = layoutColumnItemRenderer(c, item, xx, yy);
		//						xx += itemSize.x;
		//					}
		//					// toss excess columns
		//					if (listItems[i].length > visibleColumns.length)
		//					{
		//						addToFreeItemRenderers(listItems[i].pop());
		//					}
		//				}
		//				
		//				iterator.seek(cursorPos, 0);           
		//			}
		//			
		//			// force update the header
		//			header.headerItemsChanged = true;
		//			header.visibleColumns = visibleColumns;
		//			header.invalidateDisplayList();
		//			header.validateNow();
		//			
		//			// draw column lines and backgrounds
		//			drawLinesAndColumnBackgrounds();
		//		}        
		//		
		//		// if moving left, add up old renderers
		//		// if moving right, add up new columns
		//		private function sumColumnWidths(num:int, left:Boolean):Number
		//		{
		//			var i:int;
		//			var value:Number = 0;
		//			if (left)
		//			{
		//				for (i = 0; i < num; i++)
		//				{
		//					value += listItems[0][i].width;
		//				}
		//			}
		//			else
		//				for (i = 0; i < num; i++)
		//				{
		//					value += visibleColumns[i].width;
		//				}
		//			
		//			return value;
		//		}
		//		
		//		// shift position of renderers on screen
		//		private function moveRowHorizontally(rowIndex:int, start:int, distance:Number, end:int):void
		//		{
		//			for (;start < end; start++)
		//			{
		//				if (listItems[rowIndex][start])
		//					listItems[rowIndex][start].x += distance;
		//			}
		//		}
		//		
		//		// shift renderer assignments in listItems array
		//		private function shiftColumns(rowIndex:int, shift:int, numCols:int):void
		//		{
		//			var item:IListItemRenderer;
		//			
		//			for (var i:int = 0; i < shift; i++)
		//			{
		//				item = listItems[rowIndex].shift();
		//				if (item)
		//					addToFreeItemRenderers(item);
		//			}
		//		}
		//		
		//		// add places in front of row for new columns
		//		private function addColumnPlaceHolders(rowIndex:int, count:int):void
		//		{
		//			for (var i:int = 0; i < count; i++)
		//			{
		//				listItems[rowIndex].unshift(null);
		//			}
		//		}
		//		
		//		// remove excess columns
		//		private function truncateRowArray(rowIndex:int):void
		//		{
		//			while (listItems[rowIndex].length > visibleColumns.length)
		//			{
		//				var item:IListItemRenderer;
		//				{
		//					item = listItems[rowIndex].pop();
		//					addToFreeItemRenderers(item);
		//				}
		//			}
		//		}
	}
}