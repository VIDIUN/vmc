package com.vidiun.edw.components.fltr.panels
{
	import com.vidiun.edw.components.fltr.IAdvancedSearchFilterComponent;
	import com.vidiun.edw.components.fltr.indicators.IndicatorVo;
	import com.vidiun.types.VidiunSearchOperatorType;
	import com.vidiun.vo.VidiunMetadataSearchItem;
	import com.vidiun.vo.VidiunSearchCondition;
	import com.vidiun.vo.MetadataFieldVO;
	
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Button;
	import mx.controls.CheckBox;
	
	public class MetadataFilter extends AdditionalFilter implements IAdvancedSearchFilterComponent {
		
		private var _initialFilter:VidiunMetadataSearchItem;
		
		
		override public function set filter(value:Object):void {
			if (!value) {
				_buttons[0].selected = true;
				for (var i:int = 1; i<_buttons.length; i++) {
					_buttons[i].selected = false;
				}
			}
			
			if (_buttons) {
				_buttons[0].selected = false;
				// scan the fields (filter.items)
				for each (var field:VidiunSearchCondition in value.items) {
					// for each field, find a matching button and select it
					for each (var cb:CheckBox in _buttons) {
						if (cb.data == field.value) {
							cb.selected = true;
							break;
						}
					}
				}
				//TODO if all buttons are selected..
			}
			else {
				// keep the value for later
				_initialFilter = value as VidiunMetadataSearchItem;
			}
		}
		
		/**
		 * filter is VidiunMetadataSearchItem whose items are VidiunSearchCondition 
		 */
		override public function get filter():Object {
			if (_buttons) {
				var fieldValueSearchCondition:VidiunSearchCondition;
				var fieldVidiunMetadataSearchItem:VidiunMetadataSearchItem = new VidiunMetadataSearchItem();
				fieldVidiunMetadataSearchItem.type = VidiunSearchOperatorType.SEARCH_OR;
				fieldVidiunMetadataSearchItem.metadataProfileId = parseInt((parent as MetadataProfileFilter).id); // value set by EntriesFilter
				fieldVidiunMetadataSearchItem.items = new Array();
				for (var i:int = 1; i < _buttons.length; i++) {
					if (_buttons[i].selected) {
						fieldValueSearchCondition = new VidiunSearchCondition();
						fieldValueSearchCondition.field = (data as MetadataFieldVO).xpath;
						fieldValueSearchCondition.value = _buttons[i].data;
						fieldVidiunMetadataSearchItem.items.push(fieldValueSearchCondition);
					}
				}
				
				if (fieldVidiunMetadataSearchItem.items.length > 0) {
					return fieldVidiunMetadataSearchItem;
				}
			}
			// if no buttons or no selected buttons, return null
			return null;
		}
		
		override public function set dataProvider(value:ArrayCollection):void {
			super.dataProvider = value;
			if (_initialFilter) {
				filter = _initialFilter;
			}
			if (_mainButtonTitle) {
				friendlyName = _mainButtonTitle;
			}
		}
		
		/**
		 * override removeItem() because data is not an object, it is just a string
		 * (don't use dataUniqueIdentifier)
		 * @param item	indicator vo representing the value to remove from the filter
		 */		
		override public function removeItem(item:IndicatorVo):void {
			// item.value is button.data
			// find correct button, set "selected", dispatch change
			// basically - dispatch a "click" from the matching button
			for each (var btn:Button in _buttons) {
				if (btn.data) {
					if (btn.data == item.value) {
						btn.dispatchEvent(new MouseEvent(MouseEvent.CLICK, true));
					}
					else if (btn.data && item.value && btn.data == item.value) {
						btn.dispatchEvent(new MouseEvent(MouseEvent.CLICK, true));
					}
				}
				else {
					// if no data, we use label
					if (btn.label == item.value) {
						btn.dispatchEvent(new MouseEvent(MouseEvent.CLICK, true));
					}
				}
			}
			
		} 
	
	}
}