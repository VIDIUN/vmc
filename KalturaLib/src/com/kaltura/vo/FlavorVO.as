package com.vidiun.vo {
	import com.adobe.cairngorm.vo.IValueObject;
	import com.vidiun.utils.ObjectUtil;
	
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import mx.utils.ObjectProxy;

	[Bindable]
	/**
	 * wrapper for VidiunFlavorParams 
	 */	
	public class FlavorVO extends ObjectProxy implements IValueObject {
		public static const SELECTED_CHANGED_EVENT:String = "flavorSelectedChanged";

		private var _selected:Boolean = false;
		
		/**
		 * the VidiunFlavorParams this vo represents 
		 */
		public var vFlavor:VidiunFlavorParams = new VidiunFlavorParams();
		

		/**
		 * should the line in the conversion settings table
		 * representing this item be editable
		 * */
		public var editable:Boolean = true;


		public function get selected():Boolean {
			return _selected;
		}


		public function set selected(selected:Boolean):void {
			_selected = selected;
			dispatchEvent(new Event(SELECTED_CHANGED_EVENT));
		}


		public function clone():FlavorVO {
			var newFlavor:FlavorVO = new FlavorVO();
			newFlavor.selected = this.selected;
			newFlavor.editable = this.editable;
			// need to make vFlavor the same type as current!!
			var vFlavorClassName:String = getQualifiedClassName(this.vFlavor);
			var vFlavorClass:Class = getDefinitionByName(vFlavorClassName) as Class; 
			newFlavor.vFlavor = (new vFlavorClass()) as VidiunFlavorParams;
			var ar:Array = ObjectUtil.getObjectAllKeys(this.vFlavor);
			for (var i:int = 0; i < ar.length; i++) {
				newFlavor.vFlavor[ar[i]] = vFlavor[ar[i]];
			}

			return newFlavor;
		}

	}
}