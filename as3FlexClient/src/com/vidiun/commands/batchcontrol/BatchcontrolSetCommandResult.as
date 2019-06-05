// ===================================================================================================
//                           _  __     _ _
//                          | |/ /__ _| | |_ _  _ _ _ __ _
//                          | ' </ _` | |  _| || | '_/ _` |
//                          |_|\_\__,_|_|\__|\_,_|_| \__,_|
//
// This file is part of the Vidiun Collaborative Media Suite which allows users
// to do with audio, video, and animation what Wiki platfroms allow them to do with
// text.
//
// Copyright (C) 2006-2017  Vidiun Inc.
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as
// published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
//
// @ignore
// ===================================================================================================
package com.vidiun.commands.batchcontrol
{
	import com.vidiun.delegates.batchcontrol.BatchcontrolSetCommandResultDelegate;
	import com.vidiun.net.VidiunCall;

	/**
	* batch setCommandResult action saves the results of a command as recieved from a remote scheduler
	**/
	public class BatchcontrolSetCommandResult extends VidiunCall
	{
		public var filterFields : String;
		
		/**
		* @param commandId int
		* @param status int
		* @param errorDescription String
		**/
		public function BatchcontrolSetCommandResult( commandId : int,status : int,errorDescription : String = null )
		{
			service= 'batchcontrol';
			action= 'setCommandResult';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('commandId');
			valueArr.push(commandId);
			keyArr.push('status');
			valueArr.push(status);
			keyArr.push('errorDescription');
			valueArr.push(errorDescription);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new BatchcontrolSetCommandResultDelegate( this , config );
		}
	}
}