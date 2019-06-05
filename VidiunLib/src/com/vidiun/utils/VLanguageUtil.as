package com.vidiun.utils {
	import com.vidiun.dataStructures.HashMap;
	import com.vidiun.types.VidiunLanguage;
	
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceBundle;
	import mx.resources.ResourceManager;

	/**
	 * Singleton class
	 * This util class handles all issues related to Languages UI - including the locales for all countries
	 */
	public class VLanguageUtil {
		[ResourceBundle("languages")]
		private static var rb:ResourceBundle;

		/**
		 * Singleton instance
		 */
		private static var _instance:VLanguageUtil = null;

		/**
		 * language.code => language Object
		 * language.value => language Object
		 * (for easy access)
		 */
		private var _languagesMap:HashMap = new HashMap();

		/**
		 * {label: localized language name, code: upper-case language code, value:VidiunLanguage.<code>}
		 */
		private var _languagesArr:ArrayCollection = new ArrayCollection();


		/**
		 * C'tor
		 */
		public function VLanguageUtil(enforcer:Enforcer) {
			initLanguagesArr();
			initlanguagesMap();
		}


		public static function get instance():VLanguageUtil {
			if (_instance == null) {
				_instance = new VLanguageUtil(new Enforcer());
			}

			return _instance;
		}


		/***
		 * Get the list of all languages
		 */
		public function get languagesArr():ArrayCollection {
			return _languagesArr;
		}


		/**
		 * This function is used to get the language object
		 * The object is with fields : code, label and index
		 * code - language code
		 * label - language label in the active locale
		 * index - the index of the language in the languages array collection
		 * @param code - language code
		 * @return langauge object
		 */
		public function getLanguageByCode(code:String):Object {
			var lang:Object = _languagesMap.getValue(code.toUpperCase());
			return lang;
		}


		private function initLanguagesArr():void {
			var rm:IResourceManager = ResourceManager.getInstance();
			var tmp:Array = [
				{label: rm.getString('languages', 'AA'), code: "AA", value:VidiunLanguage.AA},
				{label: rm.getString('languages', 'AB'), code: "AB", value:VidiunLanguage.AB},
				{label: rm.getString('languages', 'AF'), code: "AF", value:VidiunLanguage.AF},
				{label: rm.getString('languages', 'AM'), code: "AM", value:VidiunLanguage.AM},
				{label: rm.getString('languages', 'AR'), code: "AR", value:VidiunLanguage.AR},
				{label: rm.getString('languages', 'AS'), code: "AS", value:VidiunLanguage.AS_},
				{label: rm.getString('languages', 'AY'), code: "AY", value:VidiunLanguage.AY},
				{label: rm.getString('languages', 'AZ'), code: "AZ", value:VidiunLanguage.AZ},
				{label: rm.getString('languages', 'BA'), code: "BA", value:VidiunLanguage.BA},
				{label: rm.getString('languages', 'BE'), code: "BE", value:VidiunLanguage.BE},
				{label: rm.getString('languages', 'BG'), code: "BG", value:VidiunLanguage.BG},
				{label: rm.getString('languages', 'BH'), code: "BH", value:VidiunLanguage.BH},
				{label: rm.getString('languages', 'BI'), code: "BI", value:VidiunLanguage.BI},
				{label: rm.getString('languages', 'BN'), code: "BN", value:VidiunLanguage.BN},
				{label: rm.getString('languages', 'BO'), code: "BO", value:VidiunLanguage.BO},
				{label: rm.getString('languages', 'BR'), code: "BR", value:VidiunLanguage.BR},
				{label: rm.getString('languages', 'CA'), code: "CA", value:VidiunLanguage.CA},
				{label: rm.getString('languages', 'CO'), code: "CO", value:VidiunLanguage.CO},
				{label: rm.getString('languages', 'CS'), code: "CS", value:VidiunLanguage.CS},
				{label: rm.getString('languages', 'CY'), code: "CY", value:VidiunLanguage.CY},
				{label: rm.getString('languages', 'DA'), code: "DA", value:VidiunLanguage.DA},
				{label: rm.getString('languages', 'DE'), code: "DE", value:VidiunLanguage.DE},
				{label: rm.getString('languages', 'DZ'), code: "DZ", value:VidiunLanguage.DZ},
				{label: rm.getString('languages', 'EL'), code: "EL", value:VidiunLanguage.EL},
//				{label: rm.getString('languages', 'EN'), code: "EN", value:VidiunLanguage.EN},
				{label: rm.getString('languages', 'EN_GB'), code: "EN_GB", value:VidiunLanguage.EN_GB},
				{label: rm.getString('languages', 'EN_US'), code: "EN_US", value:VidiunLanguage.EN_US},
				{label: rm.getString('languages', 'EO'), code: "EO", value:VidiunLanguage.EO},
				{label: rm.getString('languages', 'ES'), code: "ES", value:VidiunLanguage.ES},
				{label: rm.getString('languages', 'ET'), code: "ET", value:VidiunLanguage.ET},
				{label: rm.getString('languages', 'EU'), code: "EU", value:VidiunLanguage.EU},
				{label: rm.getString('languages', 'FA'), code: "FA", value:VidiunLanguage.FA},
				{label: rm.getString('languages', 'FI'), code: "FI", value:VidiunLanguage.FI},
				{label: rm.getString('languages', 'FJ'), code: "FJ", value:VidiunLanguage.FJ},
				{label: rm.getString('languages', 'FO'), code: "FO", value:VidiunLanguage.FO},
				{label: rm.getString('languages', 'FR'), code: "FR", value:VidiunLanguage.FR},
				{label: rm.getString('languages', 'FY'), code: "FY", value:VidiunLanguage.FY},
				{label: rm.getString('languages', 'GA'), code: "GA", value:VidiunLanguage.GA},
				{label: rm.getString('languages', 'GD'), code: "GD", value:VidiunLanguage.GD},
				{label: rm.getString('languages', 'GL'), code: "GL", value:VidiunLanguage.GL},
				{label: rm.getString('languages', 'GN'), code: "GN", value:VidiunLanguage.GN},
				{label: rm.getString('languages', 'GU'), code: "GU", value:VidiunLanguage.GU},
				{label: rm.getString('languages', 'HA'), code: "HA", value:VidiunLanguage.HA},
				{label: rm.getString('languages', 'HI'), code: "HI", value:VidiunLanguage.HI},
				{label: rm.getString('languages', 'HR'), code: "HR", value:VidiunLanguage.HR},
				{label: rm.getString('languages', 'HU'), code: "HU", value:VidiunLanguage.HU},
				{label: rm.getString('languages', 'HY'), code: "HY", value:VidiunLanguage.HY},
				{label: rm.getString('languages', 'IA'), code: "IA", value:VidiunLanguage.IA},
				{label: rm.getString('languages', 'IE'), code: "IE", value:VidiunLanguage.IE},
				{label: rm.getString('languages', 'IK'), code: "IK", value:VidiunLanguage.IK},
				{label: rm.getString('languages', 'IN'), code: "IN", value:VidiunLanguage.IN},
				{label: rm.getString('languages', 'IS'), code: "IS", value:VidiunLanguage.IS},
				{label: rm.getString('languages', 'IT'), code: "IT", value:VidiunLanguage.IT},
				{label: rm.getString('languages', 'IW'), code: "IW", value:VidiunLanguage.IW},
				{label: rm.getString('languages', 'JA'), code: "JA", value:VidiunLanguage.JA},
				{label: rm.getString('languages', 'JI'), code: "JI", value:VidiunLanguage.JI},
				{label: rm.getString('languages', 'JW'), code: "JW", value:VidiunLanguage.JV},
				{label: rm.getString('languages', 'KA'), code: "KA", value:VidiunLanguage.KA},
				{label: rm.getString('languages', 'KK'), code: "KK", value:VidiunLanguage.KK},
				{label: rm.getString('languages', 'KL'), code: "KL", value:VidiunLanguage.KL},
				{label: rm.getString('languages', 'KM'), code: "KM", value:VidiunLanguage.KM},
				{label: rm.getString('languages', 'KN'), code: "KN", value:VidiunLanguage.KN},
				{label: rm.getString('languages', 'KO'), code: "KO", value:VidiunLanguage.KO},
				{label: rm.getString('languages', 'KS'), code: "KS", value:VidiunLanguage.KS},
				{label: rm.getString('languages', 'KU'), code: "KU", value:VidiunLanguage.KU},
				{label: rm.getString('languages', 'KY'), code: "KY", value:VidiunLanguage.KY},
				{label: rm.getString('languages', 'LA'), code: "LA", value:VidiunLanguage.LA},
				{label: rm.getString('languages', 'LN'), code: "LN", value:VidiunLanguage.LN},
				{label: rm.getString('languages', 'LO'), code: "LO", value:VidiunLanguage.LO},
				{label: rm.getString('languages', 'LT'), code: "LT", value:VidiunLanguage.LT},
				{label: rm.getString('languages', 'LV'), code: "LV", value:VidiunLanguage.LV},
				{label: rm.getString('languages', 'MG'), code: "MG", value:VidiunLanguage.MG},
				{label: rm.getString('languages', 'MI'), code: "MI", value:VidiunLanguage.MI},
				{label: rm.getString('languages', 'MK'), code: "MK", value:VidiunLanguage.MK},
				{label: rm.getString('languages', 'ML'), code: "ML", value:VidiunLanguage.ML},
				{label: rm.getString('languages', 'MN'), code: "MN", value:VidiunLanguage.MN},
				{label: rm.getString('languages', 'MU'), code: "MU", value:VidiunLanguage.MU},
				{label: rm.getString('languages', 'MO'), code: "MO", value:VidiunLanguage.MO},
				{label: rm.getString('languages', 'MR'), code: "MR", value:VidiunLanguage.MR},
				{label: rm.getString('languages', 'MS'), code: "MS", value:VidiunLanguage.MS},
				{label: rm.getString('languages', 'MT'), code: "MT", value:VidiunLanguage.MT},
				{label: rm.getString('languages', 'MY'), code: "MY", value:VidiunLanguage.MY},
				{label: rm.getString('languages', 'NA'), code: "NA", value:VidiunLanguage.NA},
				{label: rm.getString('languages', 'NE'), code: "NE", value:VidiunLanguage.NE},
				{label: rm.getString('languages', 'NL'), code: "NL", value:VidiunLanguage.NL},
				{label: rm.getString('languages', 'NO'), code: "NO", value:VidiunLanguage.NO},
				{label: rm.getString('languages', 'OC'), code: "OC", value:VidiunLanguage.OC},
				{label: rm.getString('languages', 'OM'), code: "OM", value:VidiunLanguage.OM},
				{label: rm.getString('languages', 'OR'), code: "OR", value:VidiunLanguage.OR_},
				{label: rm.getString('languages', 'PA'), code: "PA", value:VidiunLanguage.PA},
				{label: rm.getString('languages', 'PL'), code: "PL", value:VidiunLanguage.PL},
				{label: rm.getString('languages', 'PS'), code: "PS", value:VidiunLanguage.PS},
				{label: rm.getString('languages', 'PT'), code: "PT", value:VidiunLanguage.PT},
				{label: rm.getString('languages', 'QU'), code: "QU", value:VidiunLanguage.QU},
				{label: rm.getString('languages', 'RM'), code: "RM", value:VidiunLanguage.RM},
				{label: rm.getString('languages', 'RN'), code: "RN", value:VidiunLanguage.RN},
				{label: rm.getString('languages', 'RO'), code: "RO", value:VidiunLanguage.RO},
				{label: rm.getString('languages', 'RU'), code: "RU", value:VidiunLanguage.RU},
				{label: rm.getString('languages', 'RW'), code: "RW", value:VidiunLanguage.RW},
				{label: rm.getString('languages', 'SA'), code: "SA", value:VidiunLanguage.SA},
				{label: rm.getString('languages', 'SD'), code: "SD", value:VidiunLanguage.SD},
				{label: rm.getString('languages', 'SG'), code: "SG", value:VidiunLanguage.SG},
				{label: rm.getString('languages', 'SH'), code: "SH", value:VidiunLanguage.SH},
				{label: rm.getString('languages', 'SI'), code: "SI", value:VidiunLanguage.SI},
				{label: rm.getString('languages', 'SK'), code: "SK", value:VidiunLanguage.SK},
				{label: rm.getString('languages', 'SL'), code: "SL", value:VidiunLanguage.SL},
				{label: rm.getString('languages', 'SM'), code: "SM", value:VidiunLanguage.SM},
				{label: rm.getString('languages', 'SN'), code: "SN", value:VidiunLanguage.SN},
				{label: rm.getString('languages', 'SO'), code: "SO", value:VidiunLanguage.SO},
				{label: rm.getString('languages', 'SQ'), code: "SQ", value:VidiunLanguage.SQ},
				{label: rm.getString('languages', 'SR'), code: "SR", value:VidiunLanguage.SR},
				{label: rm.getString('languages', 'SS'), code: "SS", value:VidiunLanguage.SS},
				{label: rm.getString('languages', 'ST'), code: "ST", value:VidiunLanguage.ST},
				{label: rm.getString('languages', 'SU'), code: "SU", value:VidiunLanguage.SU},
				{label: rm.getString('languages', 'SV'), code: "SV", value:VidiunLanguage.SV},
				{label: rm.getString('languages', 'SW'), code: "SW", value:VidiunLanguage.SW},
				{label: rm.getString('languages', 'TA'), code: "TA", value:VidiunLanguage.TA},
				{label: rm.getString('languages', 'TE'), code: "TE", value:VidiunLanguage.TE},
				{label: rm.getString('languages', 'TG'), code: "TG", value:VidiunLanguage.TG},
				{label: rm.getString('languages', 'TH'), code: "TH", value:VidiunLanguage.TH},
				{label: rm.getString('languages', 'TI'), code: "TI", value:VidiunLanguage.TI},
				{label: rm.getString('languages', 'TK'), code: "TK", value:VidiunLanguage.TK},
				{label: rm.getString('languages', 'TL'), code: "TL", value:VidiunLanguage.TL},
				{label: rm.getString('languages', 'TN'), code: "TN", value:VidiunLanguage.TN},
				{label: rm.getString('languages', 'TO'), code: "TO", value:VidiunLanguage.TO},
				{label: rm.getString('languages', 'TR'), code: "TR", value:VidiunLanguage.TR},
				{label: rm.getString('languages', 'TS'), code: "TS", value:VidiunLanguage.TS},
				{label: rm.getString('languages', 'TT'), code: "TT", value:VidiunLanguage.TT},
				{label: rm.getString('languages', 'TW'), code: "TW", value:VidiunLanguage.TW},
				{label: rm.getString('languages', 'UK'), code: "UK", value:VidiunLanguage.UK},
				{label: rm.getString('languages', 'UR'), code: "UR", value:VidiunLanguage.UR},
				{label: rm.getString('languages', 'UZ'), code: "UZ", value:VidiunLanguage.UZ},
				{label: rm.getString('languages', 'VI'), code: "VI", value:VidiunLanguage.VI},
				{label: rm.getString('languages', 'VO'), code: "VO", value:VidiunLanguage.VO},
				{label: rm.getString('languages', 'WO'), code: "WO", value:VidiunLanguage.WO},
				{label: rm.getString('languages', 'XH'), code: "XH", value:VidiunLanguage.XH},
				{label: rm.getString('languages', 'YO'), code: "YO", value:VidiunLanguage.YO},
				{label: rm.getString('languages', 'ZH'), code: "ZH", value:VidiunLanguage.ZH},
				{label: rm.getString('languages', 'ZU'), code: "ZU", value:VidiunLanguage.ZU}
			];
			tmp.sortOn('label');
			// put english first
			tmp.unshift({label: rm.getString('languages', 'EN'), code: "EN", value:VidiunLanguage.EN});
			_languagesArr = new ArrayCollection(tmp);
		}


		/**
		 * for each language, keep in hashmap both by name (VidiunLanguage) and code 
		 */
		private function initlanguagesMap():void {
			var index:int = 0;
			for each (var lang:Object in _languagesArr) {
				lang.index = index;
				_languagesMap.put(lang.code, lang);
				_languagesMap.put(lang.value.toUpperCase(), lang);
				index++;
			}
		}


//		public static const GV : String = 'Gaelic (Manx)';
//		public static const HE : String = 'Hebrew';
//		public static const ID : String = 'Indonesian';
//		public static const IU : String = 'Inuktitut';
//		public static const LI : String = 'Limburgish ( Limburger)';
//		public static const UG : String = 'Uighur';
//		public static const YI : String = 'Yiddish';


	}
}

class Enforcer {

}
