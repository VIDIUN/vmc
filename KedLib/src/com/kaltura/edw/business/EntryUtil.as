package com.vidiun.edw.business {
	import com.vidiun.analytics.GoogleAnalyticsConsts;
	import com.vidiun.analytics.GoogleAnalyticsTracker;
	import com.vidiun.analytics.VAnalyticsTracker;
	import com.vidiun.analytics.VAnalyticsTrackerConsts;
	import com.vidiun.edw.model.datapacks.ContextDataPack;
	import com.vidiun.edw.vo.FlavorAssetWithParamsVO;
	import com.vidiun.vmvc.model.IDataPackRepository;
	import com.vidiun.types.VidiunStatsVmcEventType;
	import com.vidiun.utils.ObjectUtil;
	import com.vidiun.utils.SoManager;
	import com.vidiun.vo.VidiunBaseEntry;
	import com.vidiun.vo.VidiunFlavorAsset;
	import com.vidiun.vo.VidiunLiveStreamBitrate;
	import com.vidiun.vo.VidiunLiveStreamEntry;
	import com.vidiun.vo.VidiunMediaEntry;
	import com.vidiun.vo.VidiunPlayableEntry;
	
	import mx.collections.ArrayCollection;

	/**
	 * This class will hold functions related to vidiun entries
	 * @author Michal
	 *
	 */
	public class EntryUtil {

		/**
		 * Update the given entry on the listableVO list, if it contains an entry with the same id
		 *
		 */
		public static function updateSelectedEntryInList(entryToUpdate:VidiunBaseEntry, entries:ArrayCollection):void {
			for each (var entry:VidiunBaseEntry in entries) {
				if (entry.id == entryToUpdate.id) {

					var atts:Array = ObjectUtil.getObjectAllKeys(entryToUpdate);
					var att:String;
					for (var i:int = 0; i < atts.length; i++) {
						att = atts[i];
						if (entry[att] != entryToUpdate[att]) {
							entry[att] = entryToUpdate[att];
						}
					}
					break;
				}
			}
		}


		/**
		 * In order not to override data that was inserted by the user, update only status & replacement fiedls that
		 * might have changed
		 * */
		public static function updateChangebleFieldsOnly(newEntry:VidiunBaseEntry, oldEntry:VidiunBaseEntry):void {
			oldEntry.status = newEntry.status;
			oldEntry.replacedEntryId = newEntry.replacedEntryId;
			oldEntry.replacingEntryId = newEntry.replacingEntryId;
			oldEntry.replacementStatus = newEntry.replacementStatus;
			(oldEntry as VidiunPlayableEntry).duration = (newEntry as VidiunPlayableEntry).duration;
			(oldEntry as VidiunPlayableEntry).msDuration = (newEntry as VidiunPlayableEntry).msDuration;
		}


		/**
		 * open preview and embed window for the given entry according to the data on the given model
		 * */
		public static function openPreview(selectedEntry:VidiunBaseEntry, model:IDataPackRepository, previewOnly:Boolean):void {
			//TODO eliminate, use the function triggered in WindowsManager.as

			var context:ContextDataPack = model.getDataPack(ContextDataPack) as ContextDataPack;
			if (context.openPlayerFunc) {
				var bitrates:Array;
				if (selectedEntry is VidiunLiveStreamEntry) {
					bitrates = [];
					var o:Object;
					for each (var br:VidiunLiveStreamBitrate in selectedEntry.bitrates) {
						o = new Object();
						o.bitrate = br.bitrate;
						o.width = br.width;
						o.height = br.height;
						bitrates.push(o);
					}
				}
				var duration:int = 0;
				if (selectedEntry is VidiunMediaEntry) {
					duration = (selectedEntry as VidiunMediaEntry).duration;
				}
				VedJSGate.doPreviewEmbed(context.openPlayerFunc, selectedEntry.id, selectedEntry.name, selectedEntry.description, 
					previewOnly, false, null, bitrates, duration, selectedEntry.thumbnailUrl, selectedEntry.createdAt);
			}
			GoogleAnalyticsTracker.getInstance().sendToGA(GoogleAnalyticsConsts.CONTENT_OPEN_PREVIEW_AND_EMBED, GoogleAnalyticsConsts.CONTENT);
			VAnalyticsTracker.getInstance().sendEvent(VAnalyticsTrackerConsts.CONTENT, VidiunStatsVmcEventType.CONTENT_OPEN_PREVIEW_AND_EMBED, "content>Open Preview and Embed");

			//First time funnel
			if (!SoManager.getInstance().checkOrFlush(GoogleAnalyticsConsts.CONTENT_FIRST_TIME_PLAYER_EMBED))
				GoogleAnalyticsTracker.getInstance().sendToGA(GoogleAnalyticsConsts.CONTENT_FIRST_TIME_PLAYER_EMBED, GoogleAnalyticsConsts.CONTENT);
		}


		/**
		 * extract flavor assets from the given list
		 * @param flavorParamsAndAssetsByEntryId
		 * */
		private static function allFlavorAssets(flavorParamsAndAssetsByEntryId:ArrayCollection):Array {
			var fa:VidiunFlavorAsset;
			var result:Array = new Array();
			for each (var vawp:FlavorAssetWithParamsVO in flavorParamsAndAssetsByEntryId) {
				fa = vawp.vidiunFlavorAssetWithParams.flavorAsset;
				if (fa) {
					result.push(fa);
				}
			}
			return result;
		}
	}
}
