package com.vidiun.edw.control.commands.flavor
{
	import com.vidiun.edw.control.commands.VedCommand;
	import com.vidiun.edw.view.window.flavors.DRMDetails;
	import com.vidiun.edw.vo.FlavorAssetWithParamsVO;
	import com.vidiun.vmvc.control.VMvCEvent;
	
	import flash.display.DisplayObject;
	
	import mx.core.Application;
	import mx.managers.PopUpManager;

	public class ViewWVAssetDetails extends VedCommand
	{
		override public function execute(event:VMvCEvent):void
		{		
			var win:DRMDetails = new DRMDetails();
			win.flavorAssetWithParams = event.data as FlavorAssetWithParamsVO;
			PopUpManager.addPopUp(win, (Application.application as DisplayObject), true);
			PopUpManager.centerPopUp(win);
		}
	}
}