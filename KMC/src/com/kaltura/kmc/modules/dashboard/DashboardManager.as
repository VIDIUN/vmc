package com.vidiun.vmc.modules.dashboard {
	import com.vidiun.VidiunClient;
	import com.vidiun.commands.partner.PartnerGetInfo;
	import com.vidiun.commands.partner.PartnerGetStatistics;
	import com.vidiun.commands.partner.PartnerGetUsage;
	import com.vidiun.commands.report.ReportGetGraphs;
	import com.vidiun.dataStructures.HashMap;
	import com.vidiun.edw.business.permissions.PermissionManager;
	import com.vidiun.edw.model.types.APIErrorCode;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmc.business.JSGate;
	import com.vidiun.vmc.events.VmcNavigationEvent;
	import com.vidiun.vmc.modules.VmcModule;
	import com.vidiun.types.VidiunReportType;
	import com.vidiun.vo.VidiunPartner;
	import com.vidiun.vo.VidiunPartnerStatistics;
	import com.vidiun.vo.VidiunPartnerUsage;
	import com.vidiun.vo.VidiunReportGraph;
	import com.vidiun.vo.VidiunReportInputFilter;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.StaticText;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.formatters.DateFormatter;
	import mx.managers.PopUpManager;
	import mx.resources.ResourceManager;

	/**
	 * A singlton class - this class manages the behavior of the controlers and uses as cashe for the server's data
	 * In the first phase of the dashboard this class does it all, later on we will split it to
	 */
	public class DashboardManager extends EventDispatcher {
		public const VIDIUN_OFFSET:Number = 21600; //(6 hours * 60 min * 60 sec = 21600)

		///it is set to 30 DAYS just to get some data
		public const SECONDES_IN_30_DAYS:Number = 30 * 24 * 60 * 60; // 7d x 24h x 60m x 60s

		public const TODAY_DATE:Date = new Date();
		public const DATE_30_DAYS_AGO:Date = new Date(new Date().time - (SECONDES_IN_30_DAYS * 1000));

		/** single instanse for this class **/
		private static var _instance:DashboardManager;

		/** vidiun client object - for contacting the server **/
		private var _vc:VidiunClient; //vidiun client that make all vidiun API calls
		public var app:VmcModule;
		
		[Bindable]
		public var showGraphs : Boolean = true;

		/** map for the graphs data **/
		private var dimMap:HashMap = new HashMap();

		/** the selected graph data in a format of ArrayCollection {(X1,Y1), ... , (Xn,Yn)}  **/
		[Bindable]
		private var _selectedDim:ArrayCollection = new ArrayCollection();

		[Bindable]
		public var totalBWSoFar:String = '0';
		[Bindable]
		public var totalPercentSoFar:String = '0';
		[Bindable]
		public var totalUsage:String = '0';
		[Bindable]
		public var hostingGB:String = '0';
		[Bindable]
		public var partnerPackage:String = '0';
		
		[Bindable]
		/**
		 * publisher name for welcome message
		 * */
		public var publisherName:String;


		public function get vc():VidiunClient {
			return _vc;
		}


		public function set vc(vC:VidiunClient):void {
			_vc = vC;
		}


		/**
		 * Singlton pattern call for this class instance
		 *
		 */
		public static function get instance():DashboardManager {
			if (_instance == null) {
				_instance = new DashboardManager(new Enforcer());
			}

			return _instance;
		}


		/**
		 * Constracture - for a singlton - enforcer class can't be reached outside this class
		 *
		 */
		public function DashboardManager(enforcer:Enforcer, target:IEventDispatcher = null) {
			super(target);
		}


		[Bindable]
		public function get selectedDim():ArrayCollection {
			return _selectedDim;
		}


		public function set selectedDim(selectedDim:ArrayCollection):void {
			_selectedDim = selectedDim;
		}


		/**
		 * Data Calling from the servers
		 *
		 */
		public function getData():void {
			if (showGraphs)
			{
				getGraphData();
			}
			getUsageData();
			getPartnerData();
		}
		
		
		private function getPartnerData():void {
			var getPartnerInfo:PartnerGetInfo = new PartnerGetInfo();
			getPartnerInfo.addEventListener(VidiunEvent.COMPLETE, onPartnerInfo);
			getPartnerInfo.addEventListener(VidiunEvent.FAILED, fault);
			vc.post(getPartnerInfo);	
		}

		
		private function onPartnerInfo(ve:VidiunEvent):void {
			publisherName = (ve.data as VidiunPartner).name;
		}
		

		/**
		 * Calling for the Account usage data from the server
		 *
		 *
		 */
		private function getUsageData():void {
			var now:Date = new Date();
			new VidiunPartnerUsage();
			var partnerGetStatistics:PartnerGetStatistics = new PartnerGetStatistics();
			partnerGetStatistics.addEventListener(VidiunEvent.COMPLETE, onPartnerStatistics);
			partnerGetStatistics.addEventListener(VidiunEvent.FAILED, fault);
			vc.post(partnerGetStatistics);	
		}
		
		protected function onPartnerStatistics(result:Object):void
		{
			var statistics:VidiunPartnerStatistics = result.data as VidiunPartnerStatistics;
			totalBWSoFar = statistics.bandwidth.toFixed(2);
			totalPercentSoFar = statistics.usagePercent.toFixed();
			hostingGB = statistics.hosting.toFixed(2);
			partnerPackage = statistics.packageBandwidthAndStorage.toFixed();
			totalUsage = statistics.usage.toString();
		}


		/**
		 * In case the usage data call has errors
		 */
		private function onSrvFlt(fault:Object):void {
			Alert.show(ResourceManager.getInstance().getString('vdashboard', 'usageErrorMsg') + ":\n" + fault.error.errorMsg, ResourceManager.getInstance().getString('vdashboard', 'error'));
		}

		
		private static var dateFormatter:DateFormatter; 
		private static function initDateFormatter():void {
			dateFormatter = new DateFormatter();
			dateFormatter.formatString = "YYYYMMDD"; 
		}
		
		
		/**
		 * Calling for the graph's data from the server
		 */
		private function getGraphData():void {
			var vrif:VidiunReportInputFilter = new VidiunReportInputFilter();
			if (!dateFormatter) initDateFormatter();
			
			var today:Date = new Date();
			
			// use new filters (YYYYMMDD). send local date.
			vrif.toDay = dateFormatter.format(today);
			var ONE_DAY:int = 1000 * 60 * 60 * 24;
			vrif.fromDay = dateFormatter.format(new Date(today.time - 30*ONE_DAY));
			vrif.timeZoneOffset = today.timezoneOffset;

			var reportGetGraphs:ReportGetGraphs = new ReportGetGraphs(VidiunReportType.TOP_CONTENT, vrif, 'sum_time_viewed'); //  sum_time_viewed count_plays

			reportGetGraphs.addEventListener(VidiunEvent.COMPLETE, result);
			reportGetGraphs.addEventListener(VidiunEvent.FAILED, fault);
			vc.post(reportGetGraphs);
		}


		/**
		 * The result for the graph's data. Preparing the data as need for the graphs.
		 * Saving it in a map, for easy navigation between the graphs.
		 *
		 */
		private function result(result:Object):void {
			var vrpArr:Array = result.data as Array;

			for (var i:int = 0; i < vrpArr.length; i++) {
				var vrp:VidiunReportGraph = VidiunReportGraph(vrpArr[i]);
				var pointsArr:Array = vrp.data.split(";");
				var graphPoints:ArrayCollection = new ArrayCollection();

				for (var j:int = 0; j < pointsArr.length; j++) {
					if (pointsArr[j]) {
						var xYArr:Array = pointsArr[j].split(",");
						var year:String = String(xYArr[0]).substring(0, 4);
						var month:String = String(xYArr[0]).substring(4, 6);
						var date:String = String(xYArr[0]).substring(6, 8);
						var newDate:Date = new Date(Number(year), Number(month) - 1, Number(date));
						var timestamp:Number = newDate.time;
						graphPoints.addItem({x: timestamp, y: xYArr[1]});
					}
				}

				dimMap.put(vrp.id, graphPoints);
			}

			// set the first AC as the default for the graph
			selectedDim = dimMap.getValue('count_plays');
		}


		public function updateSelectedDim(dimCode:String):void {
			selectedDim = dimMap.getValue(dimCode) != null ? dimMap.getValue(dimCode) : new ArrayCollection();
		}


		/**
		 * In case of fault when calling the graph's data
		 * @param info
		 *
		 */
		private function fault(info:Object):void {
			if ((info as VidiunEvent).error) {
				if (info.error.errorCode == APIErrorCode.INVALID_VS) {
					JSGate.expired();
				}
				else if (info.error.errorCode == APIErrorCode.SERVICE_FORBIDDEN) {
					// added the support of non closable window
					
					Alert.show(ResourceManager.getInstance().getString('common', 'forbiddenError'), 
						ResourceManager.getInstance().getString('vdashboard', 'error'), Alert.OK, null, logout);
					//de-activate the HTML tabs
//					ExternalInterface.call("vmc.utils.activateHeader", false);
				}
				else if((info as VidiunEvent).error.errorMsg) {
					Alert.show((info as VidiunEvent).error.errorMsg, ResourceManager.getInstance().getString('vdashboard', 'error'));
				}
			}
		}

		protected function logout(e:Object):void {
			JSGate.expired();
		}


		/**
		 * launch the links by clicking on the linkbuttons in the dashboard application
		 * 
		 * @param linkCode
		 * @param pageNum
		 * 
		 */
		public function launchOuterLink(linkCode:String, pageNum:String=null):void
		{
			var linkStr:String = ResourceManager.getInstance().getString('vdashboard', linkCode);
			linkStr += pageNum ? ('#page=' + pageNum) : '';
			var urlr:URLRequest = new URLRequest(linkStr);
			navigateToURL(urlr, "_blank");
		}

		/**
		 * open a new page with the given url
		 * @param url 	address to open
		 */
		public function launchExactOuterLink(url:String):void {
			var urlr:URLRequest = new URLRequest(url);
			navigateToURL(urlr, "_blank");
		}


		/**
		 * Loading a outer module by calling JS function and the html wrapper of this SWF application
		 */
		public function loadVMCModule(moduleName:String, subModule:String = ''):void {
			dispatchEvent(new VmcNavigationEvent(VmcNavigationEvent.NAVIGATE, moduleName, subModule));
		}

	}
}

class Enforcer {

}