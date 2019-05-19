/*
This file is part of the Vidiun Collaborative Media Suite which allows users 
to do with audio, video, and animation what Wiki platfroms allow them to do with 
text.

Copyright (C) 2006-2008  Vidiun Inc.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

@ignore
*/
package com.vidiun.controls.vobjecthadles.managers
{
	import com.vidiun.controls.vobjecthadles.VObjectHandles;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	public class HandleDisplayManager
	{	
		public static var handleDisplayManager : HandleDisplayManager;
		
		private var _selectedVObject : VObjectHandles;
		private var _selectedVObjectHandleMap : Object = {};
		private var _refCount : int = 0;
		
		public function deSelectAll() : void
		{
			if(_selectedVObject != null)
			{
				_selectedVObject.deselect();
				_selectedVObject = null;
			}
		}
		
		public function setSelected( vObjectHandles : VObjectHandles ): void
		{
			if( vObjectHandles == _selectedVObject)
				return;
				
			setChildAsFirst( vObjectHandles );
			
			if( _selectedVObject != null )
				_selectedVObject.deselect();
			
			_selectedVObject = vObjectHandles;
			_selectedVObject.select();
		}
		
		public function getSelectedVObject() : VObjectHandles
		{
			return _selectedVObject;
		}
		
		public function setHId(  vObjectHandles : VObjectHandles ) : void
		{	
			if(_selectedVObject != null)
				_selectedVObject.deselect();
				
			vObjectHandles.hid = _refCount++;
	
			_selectedVObject = vObjectHandles;
			_selectedVObjectHandleMap[ vObjectHandles.hid ] = vObjectHandles;
			_selectedVObject.select();	
		}
		
		public function setUnselectableToAll() : void
		{
			deSelectAll();
			for each( var voh : VObjectHandles in _selectedVObjectHandleMap)
			{
				voh.selectable = false;
			}
		}
		
		public function setSelectableToAll() : void
		{
			for each( var voh : VObjectHandles in _selectedVObjectHandleMap)
			{
				voh.selectable = true;
			}
		}
		
		private function setChildAsFirst( obj : DisplayObject) : void
		{
			var theParent : DisplayObjectContainer = obj.parent as DisplayObjectContainer;
			theParent.addChildAt( obj , theParent.numChildren - 1);					
		}
		
		// singleton: constructor only allows one HandleDisplayManager
		public function HandleDisplayManager()
		{
			if ( HandleDisplayManager.handleDisplayManager != null )
				throw new Error( "Only one HandleDisplayManager instance should be instantiated" );	
		}
		
		// singleton: always returns the one existing static instance to itself
		public static function getInstance() : HandleDisplayManager 
		{
			if ( handleDisplayManager == null )
				handleDisplayManager = new HandleDisplayManager();
				
			return handleDisplayManager;
		}
	}
}