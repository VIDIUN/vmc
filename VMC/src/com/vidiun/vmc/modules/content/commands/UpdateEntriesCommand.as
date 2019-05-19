package com.vidiun.vmc.modules.content.commands {
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.commands.MultiRequest;
	import com.vidiun.commands.baseEntry.BaseEntryUpdate;
	import com.vidiun.commands.playlist.PlaylistUpdate;
	import com.vidiun.edw.business.EntryUtil;
	import com.vidiun.edw.control.events.SearchEvent;
	import com.vidiun.errors.VidiunError;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmc.modules.content.commands.VidiunCommand;
	import com.vidiun.vmc.modules.content.events.CategoryEvent;
	import com.vidiun.vmc.modules.content.events.EntriesEvent;
	import com.vidiun.vmc.modules.content.events.VMCSearchEvent;
	import com.vidiun.vmc.modules.content.events.WindowEvent;
	import com.vidiun.types.VidiunEntryStatus;
	import com.vidiun.vo.VidiunBaseEntry;
	import com.vidiun.vo.VidiunMixEntry;
	import com.vidiun.vo.VidiunPlaylist;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.resources.ResourceManager;

	/**
	 * This class is the Cairngorm command for updating multiple entries, or playlist.
	 * */
	public class UpdateEntriesCommand extends VidiunCommand {

		/**
		 * the updated entries.
		 * */
		private var _entries:ArrayCollection;

		/**
		 * are the entries being updated playlist entries
		 * */
		private var _isPlaylist:Boolean;


		override public function execute(event:CairngormEvent):void {
			var e:EntriesEvent = event as EntriesEvent;
			_entries = e.entries;
			if (e.entries.length > 50) {
				Alert.show(ResourceManager.getInstance().getString('cms', 'updateLotsOfEntriesMsg', [_entries.length]),
					ResourceManager.getInstance().getString('cms', 'updateLotsOfEntriesTitle'),
					Alert.YES | Alert.NO, null, responesFnc);
			}
			// for small update
			else {
				_model.increaseLoadCounter();
				var mr:MultiRequest = new MultiRequest();
				for (var i:uint = 0; i < e.entries.length; i++) {
					var keepId:String = (e.entries[i] as VidiunBaseEntry).id;

					// only send conversionProfileId if the entry is in no_content status
					if (e.entries[i].status != VidiunEntryStatus.NO_CONTENT) {
						e.entries[i].conversionProfileId = int.MIN_VALUE;
					}
					
					//handle playlist items
					if (e.entries[i] is VidiunPlaylist) {
						_isPlaylist = true;
						var plE:VidiunPlaylist = e.entries[i] as VidiunPlaylist;
						plE.setUpdatedFieldsOnly(true);
						var updatePlEntry:PlaylistUpdate = new PlaylistUpdate(keepId, plE);
						mr.addAction(updatePlEntry);
					}
					else {
						var be:VidiunBaseEntry = e.entries[i] as VidiunBaseEntry;
						be.setUpdatedFieldsOnly(true);
						if (be is VidiunMixEntry)
							(be as VidiunMixEntry).dataContent = null;
						// don't send categories - we use categoryEntry service to update them in EntryData panel
						be.categories = null;
						be.categoriesIds = null;
						
						var updateEntry1:BaseEntryUpdate = new BaseEntryUpdate(keepId, be);
						mr.addAction(updateEntry1);
					}
				}

				mr.addEventListener(VidiunEvent.COMPLETE, result);
				mr.addEventListener(VidiunEvent.FAILED, fault);
				_model.context.vc.post(mr);
				
			}
		}


		/**
		 * alert window closed
		 * */
		private function responesFnc(event:CloseEvent):void {
			if (event.detail == Alert.YES) {
				// update:
				var numOfGroups:int = Math.floor(_entries.length / 50);
				var lastGroupSize:int = _entries.length % 50;
				if (lastGroupSize != 0) {
					numOfGroups++;
				}

				var groupSize:int;
				var mr:MultiRequest;
				for (var groupIndex:int = 0; groupIndex < numOfGroups; groupIndex++) {
					mr = new MultiRequest();
					mr.addEventListener(VidiunEvent.COMPLETE, result);
					mr.addEventListener(VidiunEvent.FAILED, fault);
					mr.queued = false;

					groupSize = (groupIndex < (numOfGroups - 1)) ? 50 : lastGroupSize;
					for (var entryIndexInGroup:int = 0; entryIndexInGroup < groupSize; entryIndexInGroup++) {
						var index:int = ((groupIndex * 50) + entryIndexInGroup);
						var keepId:String = (_entries[index] as VidiunBaseEntry).id;
						var be:VidiunBaseEntry = _entries[index] as VidiunBaseEntry;
						be.setUpdatedFieldsOnly(true);
						// only send conversionProfileId if the entry is in no_content status
						if (be.status != VidiunEntryStatus.NO_CONTENT) {
							be.conversionProfileId = int.MIN_VALUE;
						}
						// don't send categories - we use categoryEntry service to update them in EntryData panel
						be.categories = null;
						be.categoriesIds = null;
						
						var updateEntry:BaseEntryUpdate = new BaseEntryUpdate(keepId, be);
						mr.addAction(updateEntry);
					}
					_model.increaseLoadCounter();
					_model.context.vc.post(mr);
				}
			}
			else {
				// announce no update:
				Alert.show(ResourceManager.getInstance().getString('cms', 'noUpdateMadeMsg'),
					ResourceManager.getInstance().getString('cms', 'noUpdateMadeTitle'));
			}
		}


		/**
		 * load success handler
		 * */
		override public function result(data:Object):void {
			super.result(data);
			var searchEvent:VMCSearchEvent;
			if (!checkError(data)) {
				if (_isPlaylist) {
					// refresh playlists list
					searchEvent = new VMCSearchEvent(VMCSearchEvent.SEARCH_PLAYLIST, _model.listableVo);
					searchEvent.dispatch();
					var cgEvent:WindowEvent = new WindowEvent(WindowEvent.CLOSE);
					cgEvent.dispatch();
				}
				else {
					for each (var entry:VidiunBaseEntry in data.data) {
						EntryUtil.updateSelectedEntryInList(entry, _model.listableVo.arrayCollection); 
					}
				}
			}
			else {
				// reload data to reset changes that weren't made
				if (_isPlaylist) {
					searchEvent = new VMCSearchEvent(VMCSearchEvent.SEARCH_PLAYLIST, _model.listableVo);
					searchEvent.dispatch();
				}
				else {
					searchEvent = new VMCSearchEvent(VMCSearchEvent.DO_SEARCH_ENTRIES, _model.listableVo);
					searchEvent.dispatch();
				}
			}
			_model.decreaseLoadCounter();
		}

	}
}