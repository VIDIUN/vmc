package com.vidiun.utils
{
	/**
	 * A class that contains Vidiun specific functions
	 *
	 */
	public class VUtils
	{
		public static function hostFromCode(hostCode:String):String
		{
			/*if( URLUtil.isHttpURL(hostCode) ||  URLUtil.isHttpsURL(hostCode))
				return hostCode.substr( 7 );*/
				
			var hostUrl:String;
			switch (hostCode)
			{
				case "0":
					hostUrl = "viddev.vidiun.com";
				break;
				// default server is www.vidiun.com
				case null:
				case "1":
					hostUrl = "www.vidiun.com";
				break;

				case "2":
					hostUrl = "localhost";
				break;

				case "3":
					hostUrl = "sandbox.vidiun.com";
				break;

				default: // a url
					hostUrl = hostCode;
				break;
			}
			return hostUrl;
		}
		
		
		public static function logicalAnd(exp1:Boolean, exp2:Boolean):Boolean {
			return exp1 && exp2;
		}
		
		public static function logicalOr(exp1:Boolean, exp2:Boolean):Boolean {
			return exp1 || exp2;
		}
	}
}