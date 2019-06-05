package com.vidiun.autocomplete.controllers
{
	import com.hillelcoren.components.AutoComplete;
	import com.hillelcoren.utils.StringUtils;
	import com.vidiun.VidiunClient;
	import com.vidiun.autocomplete.controllers.base.VACControllerBase;
	import com.vidiun.commands.user.UserGet;
	import com.vidiun.commands.user.UserList;
	import com.vidiun.errors.VidiunError;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.net.VidiunCall;
	import com.vidiun.vo.VidiunFilterPager;
	import com.vidiun.vo.VidiunUser;
	import com.vidiun.vo.VidiunUserFilter;
	import com.vidiun.vo.VidiunUserListResponse;
	
	import flash.events.Event;
	
	import mx.binding.utils.BindingUtils;
	
	public class VACUsersController extends VACControllerBase
	{
		public function VACUsersController(autoComp:AutoComplete, client:VidiunClient)
		{
			super(autoComp, client);
			
			autoComp.labelField = "id";
			autoComp.dropDownLabelFunction = userLabelFunction;
			autoComp.autoSelectFunction = userSelectFunction;
			autoComp.setStyle("unregisteredSelectedItemStyleName", "unregisteredSelectionBox"); 
			BindingUtils.bindSetter(onIdentifierSet, autoComp, "selectedItemIdentifier");
			autoComp.addEventListener(Event.CHANGE, onSelectionChanged, false, int.MAX_VALUE);
		}
		
		private function userSelectFunction(user:VidiunUser, text:String):Boolean{
			return user.id == text;
		}
		
		private function onSelectionChanged(event:Event):void
		{
			for (var index:uint = 0; index < _autoComp.selectedItems.length; index++){
				var item:Object = _autoComp.selectedItems.getItemAt(index);
				if (item is String){
					var userItem:VidiunUser = new VidiunUser();
					userItem.id = item as String;
					_autoComp.selectedItems.setItemAt(userItem, index);
				}
			}
		}
		
		private function onIdentifierSet(ident:Object):void
		{
			var userId:String = ident as String;
			if (userId != null){
				var getUser:UserGet = new UserGet(userId);
				getUser.addEventListener(VidiunEvent.COMPLETE, getUserSuccess);
				getUser.addEventListener(VidiunEvent.FAILED, fault);
				getUser.queued = false;
				
				_client.post(getUser);
			} else {
				_autoComp.selectedItem = null;
			}
		}
		
		private function getUserSuccess(data:Object):void
		{
			if (data.data is VidiunError){
				fault(data as VidiunEvent);
			} else {
				var user:VidiunUser = data.data as VidiunUser;
				if (_autoComp.selectedItems != null){
					_autoComp.selectedItems.addItem(user);
				} else {
					_autoComp.selectedItem = user;
				}
			}
		}
		
		override protected function createCallHook():VidiunCall{
			var filter:VidiunUserFilter = new VidiunUserFilter();
			filter.idOrScreenNameStartsWith = _autoComp.searchText;
			
			var pager:VidiunFilterPager = new VidiunFilterPager();
			pager.pageIndex = 0;
			pager.pageSize = 30;
			
			var listUsers:UserList = new UserList(filter, pager);
			
			return listUsers;
		}
		
		override protected function fetchElements(data:Object):Array{
			return (data.data as VidiunUserListResponse).objects;
		}
		
		private function userLabelFunction(item:Object):String{
			var user:VidiunUser = item as VidiunUser;
			
			var labelText:String;
			if (user.screenName != null && user.screenName != ""){
				labelText = user.screenName + " (" + user.id + ")";
			} else {
				labelText = user.id;
			}
			
			var searchStr:String = _autoComp.searchText;
			
			// there are problems using ">"s and "<"s in HTML
			labelText = labelText.replace( "<", "&lt;" ).replace( ">", "&gt;" );				
			
			var returnStr:String = StringUtils.highlightMatch( labelText, searchStr );
			
			var isDisabled:Boolean = false;
			var currUser:VidiunUser = item as VidiunUser;
			var vu:VidiunUser;
			for each (vu in _autoComp.disabledItems.source){
				if (vu.id == currUser.id){
					isDisabled = true;
					break;
				}
			}
			
			var isSelected:Boolean = false;
			for each (vu in _autoComp.selectedItems.source){
				if (vu.id == currUser.id){
					isSelected = true;
					break;
				}
			}
			
			if (isSelected || isDisabled)
			{
				returnStr = "<font color='" + Consts.COLOR_TEXT_DISABLED + "'>" + returnStr + "</font>";
			}
			
			return returnStr;
		}
	}
}