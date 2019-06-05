package com.vidiun.edw.components.fltr.indicators
{
	import com.vidiun.edw.components.fltr.IFilterComponent;
	
	import mx.controls.Button;

	public class IndicatorVo {
		
		/**
		 * label to show on the box 
		 */
		public var label:String;
		
		/**
		 * box tooltip 
		 */
		public var tooltip:String;
		
		
		/**
		 * the field on the VidiunFilter this indicator refers to 
		 */
		public var attribute:String;
		
		
		/**
		 * a value that will allow the origin panel to identify
		 * the exact filter value, 
		 * i.e. for attribute mediaTypeIn, VidiunMediaType.VIDEO 
		 */		
		public var value:*;
		
		
	}
}