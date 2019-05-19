package com.vidiun.edw.vo
{
	import com.vidiun.vo.VidiunConversionProfile;
	
	import mx.collections.ArrayCollection;

	[Bindable]
	/**
	 * Couples <code>VidiunConversionProfile</code> with its 
	 * <code>VidiunConversionProfileAssetParams</code>.
	 * @author Atar
	 */
	public class ConversionProfileWithFlavorParamsVo {
		
		/**
		 * Conversion Profile 
		 */
		public var profile:VidiunConversionProfile;
		
		[ArrayElementType("com.vidiun.vo.VidiunConversionProfileAssetParams")]
		/**
		 * all flavor params objects whos ids are associated with this profile.
		 * <code>VidiunConversionProfileAssetParams</code> objects 
		 */		
		public var flavors:ArrayCollection;
		
		public function ConversionProfileWithFlavorParamsVo(){
			flavors = new ArrayCollection();
		}
		
	}
}