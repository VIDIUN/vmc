package com.vidiun.edw.vo
{
	import com.vidiun.utils.ObjectUtil;
	import com.vidiun.vo.VidiunCategory;
	
	import mx.collections.ArrayCollection;
	
	dynamic public class CategoryVO
	{
		public var id:Number;
		
		[Bindable]
		public var name:String;
		
		public var category:VidiunCategory;
		
		
		[Bindable]
		/**
		 * is this category available for selection in the tree. 
		 */		
		public var enabled:Boolean = true;
		
		
		[ArrayElementType("com.vidiun.edw.vo.CategoryVO")]
		public var children:ArrayCollection;
		
		
		public function CategoryVO(id:Number, name:String, category:VidiunCategory)
		{
			this.id = id;
			this.name = name;
			this.category = category;
			
			if (category && category.directSubCategoriesCount > 0) {
				children = new ArrayCollection();
			}
		}
		
		public function clone():CategoryVO {
			var clonedVo:CategoryVO = new CategoryVO(id, name, new VidiunCategory());
			ObjectUtil.copyObject(this.category, clonedVo.category);
			return clonedVo;
		}

	}
}