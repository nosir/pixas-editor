package command 
{
	import base.DOM;
	import base.Param;
	import events.RightMenuCommandEvent;
	import flash.events.ContextMenuEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import utils.CustomEventDispatcher;
	
	/**
	 * @author max
	 */
	public class RightMenuCommand extends CustomEventDispatcher 
	{
		
		public function RightMenuCommand() 
		{
			super(RightMenuCommandEvent);
		}
		
		public function init():void
		{
			var cm:ContextMenu = new ContextMenu();
			cm.hideBuiltInItems();
			var item1:ContextMenuItem = new ContextMenuItem("Zoom +");
			var item2:ContextMenuItem = new ContextMenuItem("Zoom - ");
			var item3:ContextMenuItem = new ContextMenuItem("Zoom 100%");
			var item4:ContextMenuItem = new ContextMenuItem(Param.VERSION);
			var item5:ContextMenuItem = new ContextMenuItem("Send Feedback");
			item4.separatorBefore = true;
			item5.separatorBefore = true;
			item4.enabled = false;
            cm.customItems.push(item1,item2,item3,item5,item4);
            item1.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, __onItemZoomOutSelect);
            item2.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, __onItemZoomInSelect);
            item3.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, __onItemZoomResetSelect);
            item5.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, __onItemFeedbackSelect);
			DOM.timeline.contextMenu = cm;
		}
		
		private function __onItemFeedbackSelect(e:ContextMenuEvent):void
		{
			navigateToURL(new URLRequest(Param.FEEDBACK_ADDRESS), "_blank");
		}
		private function __onItemZoomOutSelect(e:ContextMenuEvent):void
		{
			popEvent(RightMenuCommandEvent.ZOOM, 1);
		}
		private function __onItemZoomInSelect(e:ContextMenuEvent):void
		{
			popEvent(RightMenuCommandEvent.ZOOM, -1);
		}
		private function __onItemZoomResetSelect(e:ContextMenuEvent):void
		{
			popEvent(RightMenuCommandEvent.ZOOM, -1000);
		}
	}

}