package com.vidiun.vmc.modules.content.commands {
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.analytics.GoogleAnalyticsConsts;
	import com.vidiun.analytics.GoogleAnalyticsTracker;
	import com.vidiun.edw.business.VedJSGate;
	import com.vidiun.edw.model.types.APIErrorCode;
	import com.vidiun.errors.VidiunError;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmc.modules.content.model.CmsModelLocator;
	
	import mx.controls.Alert;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	import mx.rpc.IResponder;

	public class VidiunCommand implements ICommand, IResponder {
		protected var _model:CmsModelLocator = CmsModelLocator.getInstance();


		/**
		 * @inheritDocs
		 */
		public function fault(info:Object):void {
			_model.decreaseLoadCounter();
			var er:VidiunError = (info as VidiunEvent).error;
			if (!er) return;
			if (er.errorCode == "CONNECTION_TIMEOUT") {
				GoogleAnalyticsTracker.getInstance().sendToGA(GoogleAnalyticsConsts.CLIENT_CONNECTION_TIMEOUT, GoogleAnalyticsConsts.CONTENT);
			}
			else if (er.errorCode == "POST_TIMEOUT") {
				GoogleAnalyticsTracker.getInstance().sendToGA(GoogleAnalyticsConsts.CLIENT_POST_TIMEOUT, GoogleAnalyticsConsts.CONTENT);
			}
			else if (er.errorCode == APIErrorCode.INVALID_VS) {
				VedJSGate.expired();
			}
			else if (er.errorCode == APIErrorCode.SERVICE_FORBIDDEN) {
				// added the support of non closable window
				Alert.show(ResourceManager.getInstance().getString('common','forbiddenError',[er.errorMsg]), 
					ResourceManager.getInstance().getString('common', 'forbiden_error_title'), Alert.OK, null, logout);
				//de-activate the HTML tabs
//				ExternalInterface.call("vmc.utils.activateHeader", false);
			}
			else {
				Alert.show(getMessageFromError(er.errorCode, er.errorMsg), ResourceManager.getInstance().getString('cms', 'error'));
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
				return;
			}
			
		}
		
		/**
		 * displays any erorr in the response 
		 * @param resultData
		 * @param header	optional header for error message
		 * @return true if error was encountered, false otherwise
		 */		
		protected function checkError(resultData:Object, header:String = ''):Boolean {
			if (!header) {
				header = ResourceManager.getInstance().getString('cms', 'error');
			}
			// look for error
			var str:String = '';
			var er:VidiunError = (resultData as VidiunEvent).error;
			if (er) {
				str = getMessageFromError(er.errorCode, er.errorMsg);
				Alert.show(str, header);
				return true;
			} 
			else {
				if (resultData.data is Array && resultData.data.length) {
					// this was a multirequest, we need to check its contents.
					for (var i:int = 0; i<resultData.data.length; i++) {
						var o:Object = resultData.data[i];
						if (o.error) {
							// in MR errors aren't created
							str = getMessageFromError(o.error.code, o.error.message); 
							Alert.show(str, header);
							return true;
						}
					}
				}
			}
			return false;
		}
		
		/**
		 * try to get a localised error message  
		 * @param erCode
		 * @param erMsg
		 * @return localised error message or given error message. 
		 * 
		 */
		protected function getMessageFromError(erCode:String, erMsg:String):String {
			var rm:IResourceManager = ResourceManager.getInstance();
			var str:String = rm.getString('cms', erCode);
			if (!str) {
				str = erMsg;
			}
			return str;
		}


		/**
		 * @inheritDocs
		 */
		public function execute(event:CairngormEvent):void {
			throw new Error("execute() must be implemented");
		}


		/**
		 * get localized error text (from cms bundle) if any, or server error. 
		 * @param er	the error to parse
		 * @return 		possible localised error message
		 */
		protected function getErrorText(er:VidiunError):String {
			var str:String = ResourceManager.getInstance().getString('cms', er.errorCode);
			if (!str) {
				str = er.errorMsg;
			} 
			return str;
		}
	}
}