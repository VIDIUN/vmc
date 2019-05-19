package com.vidiun.vmc.dropFolder.tests
{
	import com.vidiun.edw.control.events.DropFolderFileEvent;
	import com.vidiun.edw.control.commands.dropFolder.ListDropFoldersFilesCommand;
	import com.vidiun.types.VidiunDropFolderFileStatus;
	import com.vidiun.vo.VidiunDropFolderFile;
	import com.vidiun.vo.VidiunDropFolderFileListResponse;
	
	import flexunit.framework.Assert;
	
	public class TestDropFolderFilesList extends ListDropFoldersFilesCommand
	{	
		
		[ResourceBundle("cms")]
		
		
//		[Before]
//		public function setUp():void
//		{
//		}
//		
//		[After]
//		public function tearDown():void
//		{
//		}
//		
//		[BeforeClass]
//		public static function setUpBeforeClass():void
//		{
//		}
//		
//		[AfterClass]
//		public static function tearDownAfterClass():void
//		{
//		}
		
		/**
		 * create a dummy list reponse where some files have no parsed slug 
		 */
		protected function createDummy2():VidiunDropFolderFileListResponse {
			var response:VidiunDropFolderFileListResponse = new VidiunDropFolderFileListResponse();
			response.objects = new Array();
			var dff:VidiunDropFolderFile = new VidiunDropFolderFile();
			dff.createdAt = 105348965;
			dff.dropFolderId = 6;
			dff.fileName = "file_1";
			dff.fileSize = 3145728.1111111111111111111111111;
			dff.status = VidiunDropFolderFileStatus.NO_MATCH; 
			dff.parsedSlug = "atar";
			response.objects.push(dff);
			
			dff = new VidiunDropFolderFile();
			dff.createdAt = 115348665;
			dff.dropFolderId = 6;
			dff.fileName = "file_2";
			dff.fileSize = 3145728*2;
			dff.status = VidiunDropFolderFileStatus.NO_MATCH;
			dff.parsedSlug = "";
			response.objects.push(dff);
			
			dff = new VidiunDropFolderFile();
			dff.createdAt = 125348565;
			dff.dropFolderId = 6;
			dff.fileName = "file_3";
			dff.fileSize = 3145728*6;
			dff.status = VidiunDropFolderFileStatus.NO_MATCH;
			dff.parsedSlug = "";
			response.objects.push(dff);
			dff = new VidiunDropFolderFile();
			dff.createdAt = 135348565;
			dff.dropFolderId = 6;
			dff.fileName = "file_4";
			dff.fileSize = 3145728/4;
			dff.status = VidiunDropFolderFileStatus.NO_MATCH;
			dff.parsedSlug = "atar";
			response.objects.push(dff);
			
			return response;
		}
		
		/**
		 * create a dummy list reponse 
		 */
		protected function createDummy():VidiunDropFolderFileListResponse {
			var response:VidiunDropFolderFileListResponse = new VidiunDropFolderFileListResponse();
			response.objects = new Array();
			
			var dff:VidiunDropFolderFile = new VidiunDropFolderFile();
			dff.createdAt = 105348965;
			dff.dropFolderId = 6;
			dff.fileName = "file_1";
			dff.fileSize = 3145728.1111111111111111111111111;
			dff.status = VidiunDropFolderFileStatus.PENDING; 
			dff.parsedSlug = "atar";
			response.objects.push(dff);
			
			dff = new VidiunDropFolderFile();
			dff.createdAt = 115348665;
			dff.dropFolderId = 6;
			dff.fileName = "file_2";
			dff.fileSize = 3145728*2;
			dff.status = VidiunDropFolderFileStatus.PENDING;
			dff.parsedSlug = "atar";
			response.objects.push(dff);
			
			
			dff = new VidiunDropFolderFile();
			dff.createdAt = 125348565;
			dff.dropFolderId = 6;
			dff.fileName = "file_3";
			dff.fileSize = 3145728*6;
			dff.status = VidiunDropFolderFileStatus.PENDING;
			dff.parsedSlug = "atarsh";
			response.objects.push(dff);
			
			dff = new VidiunDropFolderFile();
			dff.createdAt = 135348565;
			dff.dropFolderId = 6;
			dff.fileName = "file_4";
			dff.fileSize = 3145728/4;
			dff.status = VidiunDropFolderFileStatus.PENDING;
			dff.parsedSlug = "atarsh";
			response.objects.push(dff);
			
			return response;
		}
		
		[Test]
		/**
		 * expected to create the files list grouped by parsedSlug, 
		 * where files with no parsedSlug should go under one group
		 */
		public function testSlugResponseNoParsed():void
		{
			_eventType = DropFolderFileEvent.LIST_BY_SELECTED_FOLDER_HIERCH;
			var response:VidiunDropFolderFileListResponse = createDummy2();
			var list:Array = handleDropFolderFileList(response);
			var defaultName:String = '';//ResourceManager.getInstance().getString('cms', 'parseFailed');
			
			// this if is because we don't know the objects' order in the list.
			if (list[1].parsedSlug == "atar") {
				Assert.assertObjectEquals(response.objects[0], list[1].files[0]);
				Assert.assertObjectEquals(response.objects[1], list[1].files[1]);
				Assert.assertEquals("atar", list[1].parsedSlug);
				Assert.assertEquals(105348965, list[1].createdAt);
				
				Assert.assertObjectEquals(response.objects[2], list[0].files[0]);
				Assert.assertObjectEquals(response.objects[3], list[0].files[1]);
				Assert.assertEquals(defaultName, list[0].parsedSlug);
				Assert.assertEquals(115348665, list[0].createdAt);
			}
			else {
				Assert.assertObjectEquals(response.objects[0], list[0].files[0]);
				Assert.assertObjectEquals(response.objects[1], list[0].files[1]);
				Assert.assertEquals("atar", list[0].parsedSlug);
				Assert.assertEquals(105348965, list[0].createdAt);
				
				Assert.assertObjectEquals(response.objects[2], list[1].files[0]);
				Assert.assertObjectEquals(response.objects[3], list[1].files[1]);
				Assert.assertEquals(defaultName, list[1].parsedSlug);
				Assert.assertEquals(115348665, list[1].createdAt);
				
			}
			
			Assert.assertEquals(2, list.length);
		}
		
		
		[Test]
		/**
		 * expected to create the files list grouped by parsedSlug
		 */
		public function testHandleSlugResponse():void
		{
			_eventType = DropFolderFileEvent.LIST_BY_SELECTED_FOLDER_HIERCH;
			var response:VidiunDropFolderFileListResponse = createDummy();
			var list:Array = handleDropFolderFileList(response);
			
			// this if is because we don't know the objects' order in the list.
			if (list[1].parsedSlug == "atar") {
				Assert.assertObjectEquals(response.objects[0], list[1].files[0]);
				Assert.assertObjectEquals(response.objects[1], list[1].files[1]);
				Assert.assertEquals("atar", list[1].parsedSlug);
				Assert.assertEquals(105348965, list[1].createdAt);
				
				Assert.assertObjectEquals(response.objects[2], list[0].files[0]);
				Assert.assertObjectEquals(response.objects[3], list[0].files[1]);
				Assert.assertEquals("atarsh", list[0].parsedSlug);
				Assert.assertEquals(125348565, list[0].createdAt);
			}
			else {
				Assert.assertObjectEquals(response.objects[0], list[0].files[0]);
				Assert.assertObjectEquals(response.objects[1], list[0].files[1]);
				Assert.assertEquals("atar", list[0].parsedSlug);
				Assert.assertEquals(105348965, list[0].createdAt);
				
				Assert.assertObjectEquals(response.objects[2], list[1].files[0]);
				Assert.assertObjectEquals(response.objects[3], list[1].files[1]);
				Assert.assertEquals("atarsh", list[1].parsedSlug);
				Assert.assertEquals(125348565, list[1].createdAt);
				
			}
			
			Assert.assertEquals(2, list.length);
		}
		
		
		[Test]
		/**
		 * expected to create the files list in a flat structure 
		 */
		public function testHandleSimpleResponse():void
		{
			_eventType = DropFolderFileEvent.LIST_BY_SELECTED_FOLDER_FLAT;
			var response:VidiunDropFolderFileListResponse = createDummy();
			var list:Array = handleDropFolderFileList(response) ;
			
			for (var i:int = 0; i<response.objects.length; i++) {
				Assert.assertObjectEquals(list[i], response.objects[i]);
			}
		}
		
	}
}