package com.vidiun.vmc.modules.content.vo {
	import com.adobe.cairngorm.vo.IValueObject;
	import com.vidiun.vo.VidiunBaseSyndicationFeed;
	import com.vidiun.vo.VidiunGoogleVideoSyndicationFeed;
	import com.vidiun.vo.VidiunITunesSyndicationFeed;
	import com.vidiun.vo.VidiunTubeMogulSyndicationFeed;
	import com.vidiun.vo.VidiunYahooSyndicationFeed;

	import flash.events.Event;

	[Bindable]
	/**
	 * External syndication data
	 */
	public class ExternalSyndicationVO implements IValueObject {
		/**
		 * defines the value of the type property for the externalSyndicationSelectedChanged event.
		 */
		public static const SELECTED_CHANGED_EVENT:String = "externalSyndicationSelectedChanged";

		/**
		 * feed id 
		 */		
		public var id:String;

		/**
		 * feed object 
		 */		
		public var vSyndicationFeed:VidiunBaseSyndicationFeed;

		/**
		 * used to mark selections in ExternalSyndicationTable 
		 */		
		public var tableSelected:Boolean;


		/**
		 * Clone this vo
		 * @return a clone.
		 */
		public function clone():ExternalSyndicationVO {
			var clonedVo:ExternalSyndicationVO = new ExternalSyndicationVO();

			clonedVo.tableSelected = this.tableSelected;
			clonedVo.vSyndicationFeed = cloneVFeeder(this.vSyndicationFeed);

			return clonedVo;
		}


		/**
		 * clone a google feed
		 * @param feed	the feed to be cloned
		 * @return a clone
		 */
		private function cloneGoogleFeed(feed:VidiunGoogleVideoSyndicationFeed):VidiunGoogleVideoSyndicationFeed {
			var gglFeed:VidiunGoogleVideoSyndicationFeed = new VidiunGoogleVideoSyndicationFeed();
			gglFeed.allowEmbed = feed.allowEmbed;
			gglFeed.createdAt = feed.createdAt;
			gglFeed.id = feed.id;
			gglFeed.landingPage = feed.landingPage;
			gglFeed.name = feed.name;
			gglFeed.partnerId = feed.partnerId;
			gglFeed.playerSkin = feed.playerSkin;
			gglFeed.playlistId = feed.playlistId;
			gglFeed.status = feed.status;
			gglFeed.type = feed.type;
			return gglFeed;
		}


		/**
		 * clone a ITunes feed
		 * @param feed	the feed to be cloned
		 * @return a clone
		 */
		private function cloneITunesFeed(feed:VidiunITunesSyndicationFeed):VidiunITunesSyndicationFeed {
			var itFeed:VidiunITunesSyndicationFeed = new VidiunITunesSyndicationFeed();
			itFeed.allowEmbed = feed.allowEmbed;
			itFeed.author = feed.author;
			itFeed.createdAt = feed.createdAt;
			itFeed.description = feed.description;
			itFeed.id = feed.id;
			itFeed.landingPage = feed.landingPage;
			itFeed.language = feed.language;
			itFeed.name = feed.name;
			itFeed.partnerId = feed.partnerId;
			itFeed.playerSkin = feed.playerSkin;
			itFeed.playlistId = feed.playlistId;
			itFeed.podcastImage = feed.podcastImage;
			itFeed.status = feed.status;
			itFeed.subTitle = feed.subTitle;
			itFeed.summary = feed.summary;
			itFeed.type = feed.type;
			return itFeed;
		}

		/**
		 * clone a Yahoo feed
		 * @param feed	the feed to be cloned
		 * @return a clone
		 */
		private function cloneYahooFeed(feed:VidiunYahooSyndicationFeed):VidiunYahooSyndicationFeed {
			var yFeed:VidiunYahooSyndicationFeed = new VidiunYahooSyndicationFeed();
			yFeed.allowEmbed = feed.allowEmbed;
			yFeed.createdAt = feed.createdAt;
			yFeed.id = feed.id;
			yFeed.landingPage = feed.landingPage;
			yFeed.name = feed.name;
			yFeed.partnerId = feed.partnerId;
			yFeed.playerSkin = feed.playerSkin;
			yFeed.playlistId = feed.playlistId;
			yFeed.status = feed.status;
			yFeed.type = feed.type;
			return yFeed;
		}

		/**
		 * clone a Yahoo feed
		 * @param feed	the feed to be cloned
		 * @return a clone
		 */
		private function cloneTubeMogulFeed(feed:VidiunTubeMogulSyndicationFeed):VidiunTubeMogulSyndicationFeed {
			var tmFeed:VidiunTubeMogulSyndicationFeed = new VidiunTubeMogulSyndicationFeed();
			tmFeed.allowEmbed = feed.allowEmbed;
			tmFeed.createdAt = feed.createdAt;
			tmFeed.id = feed.id;
			tmFeed.landingPage = feed.landingPage;
			tmFeed.name = feed.name;
			tmFeed.partnerId = feed.partnerId;
			tmFeed.playerSkin = feed.playerSkin;
			tmFeed.playlistId = feed.playlistId;
			tmFeed.status = feed.status;
			tmFeed.type = feed.type;
			return tmFeed;
		}


		private function cloneVFeeder(synFeeder:VidiunBaseSyndicationFeed):VidiunBaseSyndicationFeed {
			var clonedSynFeeder:VidiunBaseSyndicationFeed;

			if (synFeeder is VidiunGoogleVideoSyndicationFeed) {
				clonedSynFeeder = cloneGoogleFeed(synFeeder as VidiunGoogleVideoSyndicationFeed);
			}
			else if (synFeeder is VidiunITunesSyndicationFeed) {
				clonedSynFeeder = cloneITunesFeed(synFeeder as VidiunITunesSyndicationFeed);

			}
			else if (synFeeder is VidiunYahooSyndicationFeed) {
				clonedSynFeeder = cloneYahooFeed(synFeeder as VidiunYahooSyndicationFeed);
			}
			else if (synFeeder is VidiunTubeMogulSyndicationFeed) {
				clonedSynFeeder = cloneTubeMogulFeed(synFeeder as VidiunTubeMogulSyndicationFeed);
			}

			return clonedSynFeeder;
		}


	}
}