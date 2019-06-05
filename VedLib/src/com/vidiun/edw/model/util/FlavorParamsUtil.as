package com.vidiun.edw.model.util
{
	import com.vidiun.vo.VidiunFlavorParams;
	import com.vidiun.utils.ObjectUtil;
	import com.vidiun.core.VClassFactory;
	import flash.xml.XMLDocument;
	import mx.rpc.xml.SimpleXMLEncoder;
	import flash.xml.XMLNode;

	public class FlavorParamsUtil
	{
		/**
		 * validate the given object is VidiunFlavorParams.
		 * Otherwise, create new VFP and populate attributes with given object values.
		 * @param object
		 * @return 
		 */
		public static function makeFlavorParams(object:Object):VidiunFlavorParams {
			var result:VidiunFlavorParams;
			if (object is VidiunFlavorParams) {
				result = object as VidiunFlavorParams;
			}
			else {
				result = new VClassFactory(VidiunFlavorParams).newInstanceFromXML( XMLList(objectToXML(object)));
				result.originalObjectType = object.objectType; 
			}
			return result;
		}
		
		public static function makeManyFlavorParams(array:Array):Array {
			var result:Array = [];
			for each (var o:Object in array) {
				result.push(makeFlavorParams(o));
			}
			return result;
		}
		
		/**
		 * This function will convert a given object to an XML 
		 * @param obj
		 * @return 
		 */		
		public static function objectToXML(obj:Object):XML {
			var qName:QName = new QName("root");
			var xmlDocument:XMLDocument = new XMLDocument();
			var simpleXMLEncoder:SimpleXMLEncoder = new SimpleXMLEncoder(xmlDocument);
			var xmlNode:XMLNode = simpleXMLEncoder.encodeValue(obj, qName, xmlDocument);
			var xml:XML = new XML(xmlDocument.toString());
			return xml;
		}
	}
}