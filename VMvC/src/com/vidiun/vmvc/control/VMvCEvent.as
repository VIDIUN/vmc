/*

   Copyright (c) 2006. Adobe Systems Incorporated.
   All rights reserved.

   Redistribution and use in source and binary forms, with or without
   modification, are permitted provided that the following conditions are met:

 * Redistributions of source code must retain the above copyright notice,
   this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.
 * Neither the name of Adobe Systems Incorporated nor the names of its
   contributors may be used to endorse or promote products derived from this
   software without specific prior written permission.

   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
   AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
   IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
   ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
   LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
   CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
   SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
   INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
   CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
   ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
   POSSIBILITY OF SUCH DAMAGE.

   @ignore
 */

package com.vidiun.vmvc.control {
	import flash.events.Event;

	/**
	 * The VMvCEvent class is used to differentiate VMvC events
	 * from events raised by the underlying Flex framework (or
	 * similar). It is mandatory for VMvC event dispatching.
	 */
	public class VMvCEvent extends Event {
		
		/**
		 * the object who triggered event dispatching. <br>
		 * it is the object's responsibility to set this value
		 * */
		public var source:*;
		
		/**
		 * function on the <code>source</code> object to 
		 * trigger after command's successful completion
		 * */
		public var onComplete:Function;

		/**
		 * function on the <code>source</code> object to 
		 * trigger after command's failed completion
		 * */
		public var onFail:Function;
		
		
		/**
		 * The controller used to dispatch this event.
		 * The value is updated when a controller dispatches the event
		 * and is meant for use if a command needs to trigger another command.
		 * */
		public var dispatcher:VMvCController;


		/**
		 * The data property can be used to hold information to be passed with the event
		 * in cases where the developer does not want to extend the CairngormEvent class.
		 * However, it is recommended that specific classes are created for each type
		 * of event to be dispatched.
		 */
		public var data:*;


		/**
		 * Constructor, takes the event name (type) and data object (defaults to null)
		 * and also defaults the standard Flex event properties bubbles and cancelable
		 * to true and false respectively.
		 */
		public function VMvCEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
		}

//      /**
//       * Dispatch this event via the Cairngorm event dispatcher.
//       */
//      public function dispatch() : Boolean
//      {
////         return CairngormEventDispatcher.getInstance().dispatchEvent( this );
//		  return false;
//      }
	}
}