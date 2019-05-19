package com.vidiun.analytics
{
//	import com.adobe.crypto.MD5;
	import com.vidiun.VidiunClient;
	import com.vidiun.commands.stats.StatsVmcCollect;
	import com.vidiun.vo.VidiunStatsVmcEvent;
	
	import flash.net.URLRequestMethod;
	
	public class VAnalyticsTracker
	{
		private static var _instance:VAnalyticsTracker;
		private var _vc:VidiunClient;
	//	private var _sessionId:String;   - No need for it, the server will use the VS of the user.
		private var _clientVersion:String;
		private var _swfName:String;
		private var _userId:String;
		
		public function VAnalyticsTracker(enforcer:Enforcer){}
		
		public static function getInstance():VAnalyticsTracker
		{
			if(_instance == null)
			{
				_instance = new VAnalyticsTracker(new Enforcer());
			}
			
			return _instance;
		}
        
        public function init(vc:VidiunClient, swfName:String, clientVersion:String, userId:String):void
        {
        	_vc = vc;
 //       	_sessionId = MD5.hash(_vc.vs);
        	_clientVersion = clientVersion;
        	_userId = userId;
        	_swfName = swfName;
        }
        
        public function sendEvent(moduleName:String , eventCode:int, eventPath:String, entryId:String=null, uiconfId:int=int.MIN_VALUE, widgetId:String=null):void
        {
			// if not intialised, don't log.
			if (!_vc) return;
        	var analyticsEvent:VidiunStatsVmcEvent = new VidiunStatsVmcEvent();
        	analyticsEvent.vmcEventType = eventCode;
        	analyticsEvent.vmcEventActionPath = eventPath;
//        	analyticsEvent.sessionId = _sessionId;
        	analyticsEvent.partnerId = int(_vc.partnerId);
        	analyticsEvent.clientVer = "1.0:" + moduleName + ":" + _clientVersion;
        	analyticsEvent.userId = _userId;
        	analyticsEvent.eventTimestamp = (new Date().time)/1000;
        	analyticsEvent.uiconfId = uiconfId; // when manipulating uiconfs
        	analyticsEvent.entryId = entryId;  // when manipulating entries
 //       	analyticsEvent.userIp  - server side, no need to send
        	analyticsEvent.widgetId = widgetId;// when manipulating widgets (relevant for the embed code)
        	
        	
        	var statsVmcCall:StatsVmcCollect = new StatsVmcCollect(analyticsEvent);
        	statsVmcCall.method = URLRequestMethod.GET;
			statsVmcCall.queued = false;
        	_vc.post(statsVmcCall);
        }
        
       
	}
}
	
class Enforcer
{

}