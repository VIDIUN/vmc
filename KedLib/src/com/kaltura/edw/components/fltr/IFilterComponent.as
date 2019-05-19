package com.vidiun.edw.components.fltr
{
	import com.vidiun.edw.components.fltr.indicators.IndicatorVo;
	
	import flash.events.IEventDispatcher;

	
	/**
	 * A part of the visual filter that manipulates data of a given VidiunFilter attribute 
	 * @author Atar
	 * 
	 */
	public interface IFilterComponent extends IEventDispatcher {
		
		/**
		 * Name of the <code>VidiunFilter</code> attribute this component handles  
		 */		
		function set attribute(value:String):void;
		function get attribute():String;
		
		
		/**
		 * Value for the relevant attribute on <code>VidiunFilter</code>.   
		 */		
		function set filter(value:Object):void;
		function get filter():Object;
		
		
		/**
		 * remove partial filter. <br>
		 * the IFilterComponent implementation should know how to remove the indicated 
		 * item, because it created the indicatorVo in the first place  
		 * @param item	the item that specifies the partial filter to remove
		 */
		function removeItem(item:IndicatorVo):void;
		
	}
}