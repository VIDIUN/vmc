package com.vidiun.vmc.utils
{
	import mx.utils.Base64Decoder;
	/**
	 * @depracated
	 * This class matches the old VS (v1) and will explode if given VS v2 
	 * @author atar.shadmi
	 */
	public class VSUtil {
		
		
		/**
		 * get the user id from the given vs 
		 * @param vs	vs to decode
		 * @return user id from given VS.
		 */		
		public static function getUserId(vs:String):String {
			var dec:Base64Decoder = new Base64Decoder();
			dec.decode(vs);
			var str:String = dec.toByteArray().toString();
			return str.split(';')[5];
		}
	}
}