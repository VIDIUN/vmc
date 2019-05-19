package com.vidiun.vmc.modules.content.commands.cat
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.commands.MultiRequest;
	import com.vidiun.commands.category.CategoryUpdate;
	import com.vidiun.errors.VidiunError;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmc.business.CategoryUtils;
	import com.vidiun.vmc.modules.content.commands.VidiunCommand;
	import com.vidiun.vo.VidiunCategory;
	
	import mx.controls.Alert;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;

	public class UpdateSubCategoriesCommand extends VidiunCommand {
		
		override public function execute(event:CairngormEvent):void {
			_model.increaseLoadCounter();
			
			var ar:Array = event.data as Array;
			var mr:MultiRequest = new MultiRequest();
			var catUpdate:CategoryUpdate;
			for (var i:int = 0; i<ar.length; i++) {
				ar[i].setUpdatedFieldsOnly(true);
				CategoryUtils.resetUnupdateableFields(ar[i] as VidiunCategory);
				catUpdate = new CategoryUpdate(ar[i].id, ar[i]);
				mr.addAction(catUpdate);
			}
			
			mr.addEventListener(VidiunEvent.COMPLETE, result);
			mr.addEventListener(VidiunEvent.FAILED, fault);
			_model.context.vc.post(mr);
		}
		
		
		override public function result(data:Object):void {
			_model.decreaseLoadCounter();
			super.result(data);
			var rm:IResourceManager = ResourceManager.getInstance();
			
			// check for errors
			var er:VidiunError = (data as VidiunEvent).error;
			if (er) { 
				Alert.show(getErrorText(er), rm.getString('cms', 'error'));
				return;
			}
			else {
				// look iside MR
				for each (var o:Object in data.data) {
					er = o as VidiunError;
					if (er) {
						Alert.show(getErrorText(er), rm.getString('cms', 'error'));
					}
					else if (o.error) {
						// in MR errors aren't created
						var str:String = rm.getString('cms', o.error.code);
						if (!str) {
							str = o.error.message;
						} 
						Alert.show(str, rm.getString('cms', 'error'));
					}
				}	
			}
			
			
		}
	}
}