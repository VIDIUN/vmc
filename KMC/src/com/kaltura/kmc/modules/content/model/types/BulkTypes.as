package com.vidiun.vmc.modules.content.model.types
{
	import com.vidiun.types.VidiunBatchJobStatus;
	
	import mx.resources.ResourceManager;
	
	public class BulkTypes
	{

		public static function getTypeName(  bulkType : uint ) : String
		{
			switch(bulkType)
			{
				case VidiunBatchJobStatus.PENDING: return ResourceManager.getInstance().getString( 'cms' , 'verifyingFile' ); break;
				case VidiunBatchJobStatus.QUEUED: return   ResourceManager.getInstance().getString( 'cms' , 'verifyingQforI' ); break;
				case VidiunBatchJobStatus.PROCESSING: return ResourceManager.getInstance().getString( 'cms' , 'processing' ); break;
				case VidiunBatchJobStatus.FINISHED: return ResourceManager.getInstance().getString( 'cms' , 'finished' ); break; 
				case VidiunBatchJobStatus.ABORTED: return ResourceManager.getInstance().getString( 'cms' , 'aborted' ); break; 
				case VidiunBatchJobStatus.FAILED: return ResourceManager.getInstance().getString( 'cms' , 'failed' ); break; 
				case VidiunBatchJobStatus.ALMOST_DONE: return ResourceManager.getInstance().getString( 'cms' , 'almostDone' ); break; 
				case VidiunBatchJobStatus.FATAL: return ResourceManager.getInstance().getString( 'cms' , 'fatal' ); break; 
				case VidiunBatchJobStatus.RETRY: return ResourceManager.getInstance().getString( 'cms' , 'retry' ); break; 
				case VidiunBatchJobStatus.DONT_PROCESS: return ResourceManager.getInstance().getString( 'cms' , 'dontProcess' ); break; 
				case VidiunBatchJobStatus.FINISHED_PARTIALLY: return ResourceManager.getInstance().getString( 'cms' , 'finishedWErr' ); break; 
			}
			return "";
		}

	}
}
