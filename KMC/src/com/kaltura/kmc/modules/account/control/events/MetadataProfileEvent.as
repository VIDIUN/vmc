package com.vidiun.vmc.modules.account.control.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.vo.VMCMetadataProfileVO;
	
	/**
	 * this class represents events related to metadataProfile
	 * @author Michal
	 * 
	 */
	public class MetadataProfileEvent extends CairngormEvent {
		
		public static const LIST : String = "account_listMetadataProfile";
		public static const ADD : String = "account_addMetadataProfile";
		public static const UPDATE : String = "account_updateMetadataProfile";
		public static const SELECT : String = "account_selectMetadataProfile";
		public static const DELETE : String = "account_deleteMetadataProfile";
		
		public var profile:VMCMetadataProfileVO;
		public var profilesArray:Array;
		
		public function MetadataProfileEvent( type:String,
											  profile:VMCMetadataProfileVO = null,
											  profilesArray:Array = null,
											  bubbles:Boolean=false, 
											  cancelable:Boolean=false)
		{
			this.profile = profile;
			this.profilesArray = profilesArray;
			super(type, bubbles, cancelable);
		}	
	}
}