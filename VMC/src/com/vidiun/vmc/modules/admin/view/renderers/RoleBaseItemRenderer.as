package com.vidiun.vmc.modules.admin.view.renderers
{
	import com.vidiun.vo.VidiunUserRole;
	
	import mx.containers.HBox;
	
	public class RoleBaseItemRenderer extends HBox
	{
		public static const TAG_ADMIN:String = 'partner_admin';
		
		public function RoleBaseItemRenderer()
		{
			super();
			this.setStyle("paddingLeft", "6");
			this.setStyle("verticalAlign", "middle");
		}
		
		public function setDefaultContainer():void
		{
			if(data)
			{
				var tagsArray:Array = (data as VidiunUserRole).tags.split(',');
				for each (var tag:String in tagsArray) {
					if (tag==TAG_ADMIN) {
						this.setStyle("backgroundColor", "#FFFDEF");
						return;
					}
				}
				
				this.setStyle("backgroundColor", null);
			}
				
		}
		
		override public function validateNow():void
		{
			super.validateNow();
			setDefaultContainer();
		}
	}
}