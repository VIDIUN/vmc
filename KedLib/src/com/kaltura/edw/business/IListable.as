package com.vidiun.edw.business
{
	import com.vidiun.controls.Paging;
	
	public interface IListable
	{
		function get filterVo():Object;
		function get pagingComponent():Paging;
	}
}