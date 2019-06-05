package com.vidiun.vmc.modules.content.view.interfaces
{
	import com.vidiun.vo.VidiunBaseSyndicationFeed;
	
	/**
	 * This interface declares the methods necessary for an external syndication feed. 
	 */	
	public interface IExternalSyndicationFeed
	{
		function get syndication():VidiunBaseSyndicationFeed
		function set syndication(syndication:VidiunBaseSyndicationFeed):void
		
		function validate():Boolean
	}
}