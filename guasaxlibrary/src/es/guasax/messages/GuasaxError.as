/**
 * Copyright (c) 2007 Guasax Contributors.  See:
 *    http://code.google.com/p/guasax/wiki/ProjectContributors
 *
 * This file is part of Guasax.
 *
 * Guasax is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation; either version 2.1 of the License, or
 * (at your option) any later version.
 *
 * Guasax is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with Guasax; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 * 
 */
 
/**
 * Original idea from Cairngorm. 
 */
package es.guasax.messages
{
	import mx.utils.StringUtil;
	import mx.resources.ResourceBundle;
	
	public class GuasaxError extends Error
	{
		[ResourceBundle("GuasaxMessages")] 
	 	private static var rb : ResourceBundle;
		
		public function GuasaxError( errorCode : String, ... rest )
		{
			super( formatMessage( errorCode, rest.toString() ) );
		}
		
		private function formatMessage( errorCode : String, ... rest ) : String
		{
			var message : String =
				StringUtil.substitute(
					resourceBundle.getString( errorCode ), rest );
			
			return StringUtil.substitute(
				"{0}: {1}",
				errorCode,
				message);
		}
		/**
		 * 
		 */
		protected function get resourceBundle() : ResourceBundle
		{
			return rb;
		}
	}
}