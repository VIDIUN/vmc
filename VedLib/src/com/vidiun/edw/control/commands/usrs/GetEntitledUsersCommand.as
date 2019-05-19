package com.vidiun.edw.control.commands.usrs
{
	import com.vidiun.commands.MultiRequest;
	import com.vidiun.commands.user.UserGet;
	import com.vidiun.edw.control.commands.VedCommand;
	import com.vidiun.edw.control.events.UsersEvent;
	import com.vidiun.edw.model.datapacks.EntryDataPack;
	import com.vidiun.errors.VidiunError;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmvc.control.VMvCEvent;
	
	import mx.controls.Alert;
	import mx.resources.ResourceManager;
	
	public class GetEntitledUsersCommand extends VedCommand {
		
		private var _type:String;
		
		override public function execute(event:VMvCEvent):void {
			_type = event.type;
			_model.increaseLoadCounter();
			
			var mr:MultiRequest = new MultiRequest();
			var ids:Array = event.data.split(",");
			var getUser:UserGet 
			
			for (var i:int = 0; i<ids.length; i++) {
				getUser = new UserGet(ids[i]);
				mr.addAction(getUser);
					
			}
			
			mr.addEventListener(VidiunEvent.COMPLETE, result);
			mr.addEventListener(VidiunEvent.FAILED, fault);
			
			_client.post(mr);
		}
		
		
		override public function result(data:Object):void {
			super.result(data);
			if (data.data && data.data is Array) {
				var isError:Boolean = checkErrors(data);
				if (!isError) {
					var edp:EntryDataPack = _model.getDataPack(EntryDataPack) as EntryDataPack;
					switch (_type) {
						case UsersEvent.GET_ENTRY_EDITORS:
							edp.entryEditors = data.data as Array;
							break;
						
						case UsersEvent.GET_ENTRY_PUBLISHERS:
							edp.entryPublishers = data.data as Array;
							break;
					}
				}
			}
			_model.decreaseLoadCounter();
		}
	}
}