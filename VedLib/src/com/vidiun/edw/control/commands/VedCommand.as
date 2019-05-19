package com.vidiun.edw.control.commands
{
	import com.vidiun.VidiunClient;
	import com.vidiun.edw.business.VedJSGate;
	import com.vidiun.edw.model.datapacks.ContextDataPack;
	import com.vidiun.edw.model.types.APIErrorCode;
	import com.vidiun.errors.VidiunError;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmvc.commands.ICommand;
	import com.vidiun.vmvc.control.VMvCController;
	import com.vidiun.vmvc.control.VMvCEvent;
	import com.vidiun.vmvc.model.VMvCModel;
	
	import mx.controls.Alert;
	import mx.resources.ResourceManager;
	import mx.rpc.IResponder;

	public class VedCommand implements ICommand, IResponder {
		/**
		 * allows saving a reference to the controller on which the event who
		 * triggered the command was dispatched, to allow dispatching future events.
		 * saving the reference is the developer's responsibility
		 * */
		protected var _dispatcher:VMvCController;
		
		/**
		 * application data model
		 * */
		protected var _model:VMvCModel = VMvCModel.getInstance();
		
		/**
		 * VidiunClient for making server calls
		 */		
		protected var _client:VidiunClient = (_model.getDataPack(ContextDataPack) as ContextDataPack).vc;
		
		/**
		 * @inheritDocs
		 */
		public function fault(info:Object):void {
			_model.decreaseLoadCounter();
			var er:VidiunError = (info as VidiunEvent).error;
			if (!er) return;
			if (er.errorCode == APIErrorCode.INVALID_VS) {
				VedJSGate.expired();
			}
			else if (er.errorCode == APIErrorCode.SERVICE_FORBIDDEN) {
				// added the support of non closable window
				Alert.show(ResourceManager.getInstance().getString('common','forbiddenError',[er.errorMsg]), 
					ResourceManager.getInstance().getString('common', 'forbiden_error_title'), Alert.OK, null, logout);
			}
			else {
				Alert.show(getErrorText(er), ResourceManager.getInstance().getString('drilldown', 'error'));
			}
		}
		
		protected function logout(e:Object):void {
			VedJSGate.expired();
		}
		
		
		/**
		 * default implementation for result.
		 * check if call response is data or error, respond to error.
		 * when overriding this method you should always call
		 * <code>super.result(data)</code> first.
		 * @param data data returned from server.
		 *
		 */
		public function result(data:Object):void {
			var er:VidiunError = (data as VidiunEvent).error;
			if (er && er.errorCode == APIErrorCode.INVALID_VS) {
				// redirect to login, or whatever JS does with invalid VS.
				VedJSGate.expired();
			}
		}
		
		/**
		 * display any errors that are encountered in the result
		 * @param data VidiunEvent
		 * @return true if errors are found
		 * 
		 */		
		protected function checkErrors(data:Object):Boolean {
			var isError:Boolean;
			var str:String;
			if (data.data is VidiunError) {
				str = ResourceManager.getInstance().getString('drilldown', (data.data as VidiunError).errorCode);
				if (!str) {
					str = (data.data as VidiunError).errorMsg;
				} 
				Alert.show(str, ResourceManager.getInstance().getString('drilldown', 'error'));
			}
			else if (data.data && data.data is Array) {
				// this was a multirequest, we need to check its contents.
				for (var i:int = 0; i<data.data.length; i++) {
					var o:Object = data.data[i];
					if (o.error) {
						isError = true;
						// in MR errors aren't created
						str = ResourceManager.getInstance().getString('drilldown', o.error.code);
						if (!str) {
							str = o.error.message;
						} 
						Alert.show(str, ResourceManager.getInstance().getString('drilldown', 'error'));
					}
				}
			}
			return isError;
		}
		
		
		/**
		 * get localized error text (from drilldown bundle) if any, or server error. 
		 * @param er	the error to parse
		 * @return 		possible localised error message
		 */
		protected function getErrorText(er:VidiunError):String {
			var str:String = ResourceManager.getInstance().getString('drilldown', er.errorCode);
			if (!str) {
				str = er.errorMsg;
			} 
			return str;
		}
		
		/**
		 * @inheritDocs
		 */
		public function execute(event:VMvCEvent):void {
			throw new Error("execute() must be implemented");
		}
	}
}