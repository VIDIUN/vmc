package com.vidiun.vmc.modules.content.commands.cat
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.commands.MultiRequest;
	import com.vidiun.commands.categoryUser.CategoryUserList;
	import com.vidiun.commands.user.UserGet;
	import com.vidiun.commands.user.UserList;
	import com.vidiun.errors.VidiunError;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmc.modules.content.commands.VidiunCommand;
	import com.vidiun.vmc.modules.content.events.CategoryEvent;
	import com.vidiun.vo.VidiunCategoryUser;
	import com.vidiun.vo.VidiunCategoryUserFilter;
	import com.vidiun.vo.VidiunCategoryUserListResponse;
	import com.vidiun.vo.VidiunFilterPager;
	import com.vidiun.vo.VidiunUser;
	import com.vidiun.vo.VidiunUserFilter;
	import com.vidiun.vo.VidiunUserListResponse;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;

	public class ListCategoryUsersCommand extends VidiunCommand {
		
		
		
		/**
		 * the last filter used for list action 
		 * @internal
		 * the inherit users from parent action ends in listing users, and requires the last used filter.
		 */		
		private static var lastFilter:VidiunCategoryUserFilter;
		
		
		private const CHUNK_SIZE:int = 20;
		
		private var _totalCategoryUsers:int;
		private var _categoryUsers:Array;
		
		private var _users:Array;
		private var _lastCatUsrIndex:int;
		
		
		override public function execute(event:CairngormEvent):void {
			if (event.type == CategoryEvent.RESET_CATEGORY_USER_LIST) {
				_model.categoriesModel.categoryUsers = null;
				_model.categoriesModel.totalCategoryUsers = 0;
				return;
			}
			
			
			_model.increaseLoadCounter();
			var f:VidiunCategoryUserFilter;
			var p:VidiunFilterPager;
			
			if (event.data is Array) {
				f = event.data[0];
				p = event.data[1];
			}
			
			if (f) {
				// remember given filter
				lastFilter = f;
			}
			else if (lastFilter) {
				// use saved filter
				f = lastFilter;
			}
			
			var getUsrs:CategoryUserList = new CategoryUserList(f, p);
			getUsrs.addEventListener(VidiunEvent.COMPLETE, getUsers);
			getUsrs.addEventListener(VidiunEvent.FAILED, fault);
			_model.context.vc.post(getUsrs);	   
		}
		
		
		private function getUsers(data:VidiunEvent):void {
			super.result(data);
			if (!checkError(data)) {
				var resp:VidiunCategoryUserListResponse = data.data as VidiunCategoryUserListResponse; 
				_categoryUsers = resp.objects;
				_totalCategoryUsers = resp.totalCount;
				
				_users = [];
				
				
				var mr:MultiRequest = new MultiRequest();
				var ug:UserGet;
				for each (var vcu:VidiunCategoryUser in _categoryUsers) {
					ug = new UserGet(vcu.userId);
					mr.addAction(ug);
				}
				mr.addEventListener(VidiunEvent.COMPLETE, getUsersResult);
				mr.addEventListener(VidiunEvent.FAILED, fault);
				
				_model.increaseLoadCounter();
				_model.context.vc.post(mr);
				
			}
			_model.decreaseLoadCounter();
		}
		
		
		private function getUsersResult(e:VidiunEvent):void {
			_model.decreaseLoadCounter();
			for each (var o:Object in e.data) {
				if (o is VidiunUser) {
					_users.push(o);
				}
			}
			
			// match to categoryUsers
			addNameToCategoryUsers();
		}
		
		
		
		/**
		 * get the next chunk of VidiunUser objects 
		 */		
		private function getUsersChunk():void {
			var ids:String = '';
			var i:int;
			for (i = 0; i < CHUNK_SIZE; i++) {
				if (_lastCatUsrIndex + i < _categoryUsers.length) {
					ids += (_categoryUsers[_lastCatUsrIndex + i] as VidiunCategoryUser).userId + ",";  
				}
				else {
					break;
				}
			} 
			_lastCatUsrIndex = _lastCatUsrIndex + i;
			
			var f:VidiunUserFilter = new VidiunUserFilter();
			f.idIn = ids;
			
			// CHUNK_SIZE is less than the default pager, so no need to add one.
			var getUsrs:UserList = new UserList(f);
			getUsrs.addEventListener(VidiunEvent.COMPLETE, getUsersChunkResult);
			getUsrs.addEventListener(VidiunEvent.FAILED, fault);
			
			_model.increaseLoadCounter();
			_model.context.vc.post(getUsrs);
		}
		
		
		/**
		 * accunulate received result and trigger next load if needed 
		 * @param data	users data from server
		 */		
		private function getUsersChunkResult(data:VidiunEvent):void {
			super.result(data);
			if (!checkError(data)) {
				_users = _users.concat((data.data as VidiunUserListResponse).objects);
				if (_lastCatUsrIndex < _categoryUsers.length) {
					// there are more users to load
					getUsersChunk();
				}
				else {
					// match to categoryUsers
					addNameToCategoryUsers();
				}
			}
			_model.decreaseLoadCounter();	
		}
		
		private function addNameToCategoryUsers():void {
			var usr:VidiunUser;
			for each (var cu:VidiunCategoryUser in _categoryUsers) {
				for (var i:int = 0; i<_users.length; i++) {
					usr = _users[i] as VidiunUser;
					if (cu.userId == usr.id) {
						cu.userName = usr.screenName;
						_users.splice(i, 1);
						break;
					}
				}
			}
			_model.categoriesModel.categoryUsers = new ArrayCollection(_categoryUsers);
			_model.categoriesModel.totalCategoryUsers = _totalCategoryUsers;
		}
		
	}
}