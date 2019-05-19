package com.vidiun.vmc.modules.content.commands
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.edw.model.types.WindowsStates;
	import com.vidiun.vmvc.model.VMvCModel;

	public class CloseWindowCommand extends VidiunCommand
	{
		
		override public function execute(event:CairngormEvent):void
		{
			
			switch (_model.windowState) {
				case WindowsStates.REPLACEMENT_ENTRY_DETAILS_WINDOW:
					// in this case we still have another drilldown open
					VMvCModel.removeModel();
					_model.windowState = WindowsStates.ENTRY_DETAILS_WINDOW_CLOSED_ONE;
					break;
				
				case WindowsStates.ENTRY_DETAILS_WINDOW_SA:
					VMvCModel.removeModel();
					_model.windowState = WindowsStates.NONE;
					break;
				
				default:
					if(_model.windowState == WindowsStates.NONE ) {
						_model.windowState = ""; //refresh the close state (in order to close window number 2)
					}
					_model.windowState = WindowsStates.NONE;	
			}
			
			
			
			//in this case we still have another drilldown open
//			if (_model.windowState == WindowsStates.REPLACEMENT_ENTRY_DETAILS_WINDOW) {
//				VMvCModel.removeModel();
//				_model.windowState = WindowsStates.ENTRY_DETAILS_WINDOW_CLOSED_ONE;
//			}
//			else {
//				if(_model.windowState == WindowsStates.NONE ) {
//					_model.windowState = ""; //refrash the close state (in order to close window number 2)
//				}
//				_model.windowState = WindowsStates.NONE;
//			}
		}
	}
}