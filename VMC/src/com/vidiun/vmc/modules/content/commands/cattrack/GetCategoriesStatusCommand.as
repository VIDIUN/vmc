package com.vidiun.vmc.modules.content.commands.cattrack
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.commands.partner.PartnerListFeatureStatus;
	import com.vidiun.edw.business.VedJSGate;
	import com.vidiun.edw.model.types.APIErrorCode;
	import com.vidiun.errors.VidiunError;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmc.modules.content.commands.VidiunCommand;
	import com.vidiun.types.VidiunFeatureStatusType;
	import com.vidiun.vo.VidiunFeatureStatus;
	import com.vidiun.vo.VidiunFeatureStatusListResponse;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	
	import mx.controls.Alert;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	
	public class GetCategoriesStatusCommand extends VidiunCommand {
		
		
		override public function execute(event:CairngormEvent):void {
			var mr:PartnerListFeatureStatus = new PartnerListFeatureStatus();
			mr.useTimeout = false; // if a TO is encountered, it lowers the loadCounter below 0.
			mr.addEventListener(VidiunEvent.COMPLETE, result);
			mr.addEventListener(VidiunEvent.FAILED, fault);
			_model.context.vc.post(mr);
			
		}
		
		override public function result(data:Object):void {
			var isErr:Boolean = checkError(data);
			if (!isErr) {
				var dsp:EventDispatcher = new EventDispatcher();
				var vfslr:VidiunFeatureStatusListResponse = data.data as VidiunFeatureStatusListResponse;
				var lockFlagFound:Boolean;
				var updateFlagFound:Boolean;
				var updateEntsFlagFound:Boolean;
				for each (var vfs:VidiunFeatureStatus in vfslr.objects) {
					switch (vfs.type) {
						case VidiunFeatureStatusType.LOCK_CATEGORY:
							lockFlagFound = true;
							updateFlagFound = true;
							break;
						case VidiunFeatureStatusType.CATEGORY:
							updateFlagFound = true;
							break;
					}
				}
				
				// lock flag
				if (lockFlagFound) {
					_model.filterModel.setCatLockFlag(true);
				}
				else  {
					_model.filterModel.setCatLockFlag(false);
				}
				
				// update flag
				if (updateFlagFound) {
					_model.filterModel.setCatUpdateFlag(true);
				}
				else {
					_model.filterModel.setCatUpdateFlag(false);
				}
				
				
			}
		}
		
		override public function fault(info:Object):void {
			if (!info || !(info is VidiunEvent)) return;
			
			var er:VidiunError = (info as VidiunEvent).error;
			if (!er) return;
			
			trace("GetCategoriesStatusCommand.fault:", er.errorCode);
			if (er.errorCode == APIErrorCode.INVALID_VS) {
				VedJSGate.expired();
			}
			else if (er.errorCode == APIErrorCode.SERVICE_FORBIDDEN) {
				VedJSGate.expired();
			}
			else if (er.errorMsg) {
				// only show error messages if they are "real errors" 
				// (for some reason, sometimes this call fails, in this  
				// case we get a flash error which we don't want to show)
				if (er.errorCode != IOErrorEvent.IO_ERROR) {
					var alert:Alert = Alert.show(er.errorMsg, ResourceManager.getInstance().getString('cms', 'error'));
				}
			}
		}
	}
}