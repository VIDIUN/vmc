package com.vidiun.vmc.modules.content.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.commands.user.UserNotifyBan;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmc.modules.content.events.UserEvent;
	
	import mx.controls.Alert;
	import mx.resources.ResourceManager;
	import mx.rpc.IResponder;

	public class BanUserCommand extends VidiunCommand implements ICommand, IResponder
	{

		override public function execute(event:CairngormEvent):void
		{
			_model.increaseLoadCounter();
			var e : UserEvent = event as UserEvent;
			var useerBanNotify:UserNotifyBan = new UserNotifyBan(e.userVo.puserId)
			useerBanNotify.addEventListener(VidiunEvent.COMPLETE, result);
			useerBanNotify.addEventListener(VidiunEvent.FAILED, fault);
			_model.context.vc.post(useerBanNotify);
		}
		
		override public function result(data:Object):void
		{
			super.result(data);
			_model.decreaseLoadCounter();
			Alert.show( ResourceManager.getInstance().getString('cms','userBanned') );
		}
	}
}