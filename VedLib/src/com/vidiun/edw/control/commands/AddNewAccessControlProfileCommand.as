package com.vidiun.edw.control.commands
{
	import com.vidiun.commands.accessControl.AccessControlAdd;
	import com.vidiun.edw.control.events.AccessControlEvent;
	import com.vidiun.edw.model.datapacks.ContextDataPack;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmvc.control.VMvCEvent;
	import com.vidiun.vo.AccessControlProfileVO;
	
	import mx.controls.Alert;
	import mx.resources.ResourceManager;
	
	public class AddNewAccessControlProfileCommand extends VedCommand
	{
		override public function execute(event:VMvCEvent):void
		{
			_dispatcher = event.dispatcher;
			var accessControl:AccessControlProfileVO = event.data;
			var addNewAccessControl:AccessControlAdd = new AccessControlAdd(accessControl.profile);
		 	addNewAccessControl.addEventListener(VidiunEvent.COMPLETE, result);
			addNewAccessControl.addEventListener(VidiunEvent.FAILED, fault);
			var context:ContextDataPack = _model.getDataPack(ContextDataPack) as ContextDataPack;
			context.vc.post(addNewAccessControl);
		}
		
		override public function result(data:Object):void
		{
			super.result(data);
			if(data.success)
			{
				Alert.show(ResourceManager.getInstance().getString('cms', 'addNewAccessControlDoneMsg'));
				var getAllProfilesEvent:AccessControlEvent = new AccessControlEvent(AccessControlEvent.LIST_ACCESS_CONTROLS_PROFILES);
				_dispatcher.dispatch(getAllProfilesEvent);
			}
			else
			{
				Alert.show(data.error, ResourceManager.getInstance().getString('cms', 'error'));
			}
		}
		
//		override public function fault(event:Object):void
//		{
//			_model.decreaseLoadCounter();
//			Alert.show(event.error.errorMsg, ResourceManager.getInstance().getString('cms', 'error'));
//		}
		

	}
}