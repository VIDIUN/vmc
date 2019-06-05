package com.vidiun.edw.vo
{
	import com.vidiun.edw.model.MetadataDataObject;
	import com.vidiun.vo.VidiunMetadata;

	[Bindable]
	/**
	 * This value object holds any information relevant to metadata data 
	 * @author Michal
	 * 
	 */	
	public class CustomMetadataDataVO
	{
		/**
		 * dynamic object, represents metadata values
		 * */
		public var metadataDataObject:MetadataDataObject = new MetadataDataObject();
		
		public var finalViewMxml:XML;
		
		public var metadata:VidiunMetadata;
		
	}
}