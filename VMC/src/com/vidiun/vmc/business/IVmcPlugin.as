package com.vidiun.vmc.business
{
	import com.vidiun.VidiunClient;

	public interface IVmcPlugin {
		
		function set client(value:VidiunClient):void;
		function get client():VidiunClient;
		
		function set flashvars(value:Object):void;
		function get flashvars():Object;
		
	}
}