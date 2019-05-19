package com.vidiun.edw.business
{
	import com.vidiun.utils.ObjectUtil;
	import com.vidiun.vo.VidiunBaseEntry;
	import com.vidiun.vo.VidiunLiveStreamAdminEntry;
	import com.vidiun.vo.VidiunLiveStreamEntry;
	import com.vidiun.vo.VidiunMediaEntry;
	import com.vidiun.vo.VidiunMixEntry;
	import com.vidiun.vo.VidiunPlayableEntry;
	import com.vidiun.vo.VidiunPlaylist;
	
	public class Cloner
	{
		public function Cloner()
		{
		}
		
		/**
		 * clone according to entry type
		 * */
		public static function cloneByEntryType(entry:VidiunBaseEntry):VidiunBaseEntry {
			var copy:VidiunBaseEntry;
			
			if (entry is VidiunPlaylist) {
				copy = cloneVidiunPlaylist(entry as VidiunPlaylist);
			}
			else if (entry is VidiunMixEntry) {
				copy = cloneVidiunMixEntry(entry as VidiunMixEntry);
			}
			else if (entry is VidiunLiveStreamEntry || entry is VidiunLiveStreamAdminEntry) {
				copy = cloneVidiunStreamAdminEntry(entry as VidiunLiveStreamEntry);
			}
			else if (entry is VidiunMediaEntry) {
				copy = cloneVidiunMediaEntry(entry as VidiunMediaEntry);
			}
			return copy;
		}
		
		
		/**
		 * Return a new VidiunBaseEntry object with same attributes as source attributes
		 */
		public static function cloneVidiunBaseEntry(source:VidiunBaseEntry):VidiunBaseEntry
		{
			var be:VidiunBaseEntry = new VidiunBaseEntry();
			var atts:Array = ObjectUtil.getObjectAllKeys(source);
			for (var i:int = 0; i< atts.length; i++) {
				be[atts[i]] = source[atts[i]];
			} 
			
			return be;
		}
		
		/**
		 * Return a new VidiunPlayableEntry object with same attributes as source attributes
		 */
		public static function cloneVidiunPlayableEntry(source:VidiunPlayableEntry):VidiunPlayableEntry
		{
			var vpe:VidiunPlayableEntry = new VidiunPlayableEntry();
			var atts:Array = ObjectUtil.getObjectAllKeys(source);
			for (var i:int = 0; i< atts.length; i++) {
				vpe[atts[i]] = source[atts[i]];
			} 
			return vpe;
		}
		
		
		/**
		 * Return a new VidiunMediaEntry object with same attributes as source attributes
		 */
		public static function cloneVidiunMediaEntry(source:VidiunMediaEntry):VidiunMediaEntry
		{
			var me:VidiunMediaEntry = new VidiunMediaEntry();
			var atts:Array = ObjectUtil.getObjectAllKeys(source);
			for (var i:int = 0; i< atts.length; i++) {
				me[atts[i]] = source[atts[i]];
			} 
			return me;
		}

		/**
		 * Return a new VidiunPlaylist object with same attributes as source attributes
		 */
		public static function cloneVidiunPlaylist(source:VidiunPlaylist):VidiunPlaylist
		{
			var pl:VidiunPlaylist = new VidiunPlaylist();
			var atts:Array = ObjectUtil.getObjectAllKeys(source);
			for (var i:int = 0; i< atts.length; i++) {
				pl[atts[i]] = source[atts[i]];
			} 
			return pl;
		}
		/**
		 * Return a new VidiunMixEntry object with same attributes as source attributes
		 */
		public static function cloneVidiunMixEntry(source:VidiunMixEntry):VidiunMixEntry
		{
			var mix:VidiunMixEntry = new VidiunMixEntry();
			
			var atts:Array = ObjectUtil.getObjectAllKeys(source);
			for (var i:int = 0; i< atts.length; i++) {
				mix[atts[i]] = source[atts[i]];
			} 
			
			return mix;
		}
		
		public static function cloneVidiunStreamAdminEntry(source:VidiunLiveStreamEntry):VidiunLiveStreamEntry
		{
			var vlsae:VidiunLiveStreamEntry = new VidiunLiveStreamEntry();
			var atts:Array = ObjectUtil.getObjectAllKeys(source);
			for (var i:int = 0; i< atts.length; i++) {
				vlsae[atts[i]] = source[atts[i]];
			} 
			
			return vlsae
		}
	}
}