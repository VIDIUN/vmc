package com.vidiun.edw.model.util
{
	import com.vidiun.vo.VidiunBaseEntry;
	
	import flash.events.Event;
	
	import mx.binding.utils.BindingUtils;
	import mx.events.PropertyChangeEvent;
	
	public class CompositeVBaseEntry extends VidiunBaseEntry
	{
		
		private var _entries:Vector.<VidiunBaseEntry>;
		
		public function CompositeVBaseEntry(entries:Vector.<VidiunBaseEntry>)
		{
			super();
			_entries = entries;
			
			addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, onPropertyChanged);
		}
		
		protected function onPropertyChanged(event:PropertyChangeEvent):void
		{
			var propName:String = event.property as String;
			setBoundValue(propName, event.newValue);
		}
		
		private function setBoundValue(prop:String, value:Object):void{
			for each(var entry:VidiunBaseEntry in _entries){
				entry[prop] = value;
			}
		}
	}
}