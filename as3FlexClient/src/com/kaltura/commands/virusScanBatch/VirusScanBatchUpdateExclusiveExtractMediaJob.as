package com.kaltura.commands.virusScanBatch
{
	import com.kaltura.vo.KalturaExclusiveLockKey;
	import com.kaltura.vo.KalturaBatchJob;
	import com.kaltura.delegates.virusScanBatch.VirusScanBatchUpdateExclusiveExtractMediaJobDelegate;
	import com.kaltura.net.KalturaCall;

	public class VirusScanBatchUpdateExclusiveExtractMediaJob extends KalturaCall
	{
		public var filterFields : String;
		public function VirusScanBatchUpdateExclusiveExtractMediaJob( id : int,lockKey : KalturaExclusiveLockKey,job : KalturaBatchJob )
		{
			service= 'virusscan_virusscanbatch';
			action= 'updateExclusiveExtractMediaJob';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push( 'id' );
			valueArr.push( id );
 			keyValArr = kalturaObject2Arrays(lockKey,'lockKey');
			keyArr = keyArr.concat( keyValArr[0] );
			valueArr = valueArr.concat( keyValArr[1] );
 			keyValArr = kalturaObject2Arrays(job,'job');
			keyArr = keyArr.concat( keyValArr[0] );
			valueArr = valueArr.concat( keyValArr[1] );
			applySchema( keyArr , valueArr );
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields',filterFields);
			delegate = new VirusScanBatchUpdateExclusiveExtractMediaJobDelegate( this , config );
		}
	}
}
