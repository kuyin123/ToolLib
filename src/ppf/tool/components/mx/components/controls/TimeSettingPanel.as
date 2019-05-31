package ppf.tool.components.mx.components.controls
{
	import ppf.tool.math.DateUtil;
	import ppf.tool.components.mx.components.views.TimeSettingPanel;
	
	import mx.events.ListEvent;
	
	public class TimeSettingPanel extends ppf.tool.components.mx.components.views.TimeSettingPanel
	{
		public function TimeSettingPanel()
		{
			super();
		}
		
		/**
		 * 改变日期类型
		 * @param e
		 */
		override public function onChangeDateype(event:ListEvent):void
		{
			//结束时间
			var curDate:Date = new Date();
			//开始时间
			var beginDate:Date;
			
			//0:前一天 1:前一周 2:前一月 3:前一年 4:自定义"]);
			switch (dateType_List.selectedIndex)
			{
				case 0:
				{
					beginDate = DateUtil.subDays(curDate,int(t_dateType.text));
//					beginDateTime.enabled = false;
//					endDateTime.enabled = false;
					beginDateTime.setEnabled(false);
					endDateTime.setEnabled(false);
//					t_dateType.enabled = true;
					break;
				}
				case 1:
				{
					beginDate = DateUtil.subWeeks(curDate,int(t_dateType.text));
//					beginDateTime.enabled = false;
//					endDateTime.enabled = false;
					beginDateTime.setEnabled(false);
					endDateTime.setEnabled(false);
//					t_dateType.enabled = true;
					break;
				}
				case 2:
				{
					beginDate = DateUtil.subMonth(curDate,int(t_dateType.text));
//					beginDateTime.enabled = false;
//					endDateTime.enabled = false;
					beginDateTime.setEnabled(false);
					endDateTime.setEnabled(false);
//					t_dateType.enabled = true;
					break;
				}
				case 3:
				{
					beginDate = DateUtil.subyear(curDate,int(t_dateType.text));
//					beginDateTime.enabled = false;
//					endDateTime.enabled = false;
					beginDateTime.setEnabled(false);
					endDateTime.setEnabled(false);
//					t_dateType.enabled = true;
					break;
				}
				case 4:
				{
					beginDate = beginDateTime.dateTime;
					curDate = endDateTime.dateTime;
//					beginDateTime.enabled = true;
//					endDateTime.enabled = true;
					//拖动框架下，拖动后，设置enabled造成未知错误，整个系统鼠标事件无效=。=
					beginDateTime.setEnabled(true);
					endDateTime.setEnabled(true);
//					t_dateType.enabled = false;
					break;
				}
				default:
				{
					break;
				}
			}
			beginDateTime.dateTime = beginDate;
			
			//如果当前结束时间大于最大时间限制，则结束时间为当前时间
			if (endDateTime.dateTime.time > endDateTime.maxDate.time)
				endDateTime.dateTime = curDate;
		}
	}
}