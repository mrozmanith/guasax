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
 
package es.guasax.util
{
	import mx.utils.StringUtil;
	import flash.utils.ByteArray;
	
	public class GuasaxUtil
	{
		public static function stringToArray(str:String, delim:String):Array{
			var roles : Array = null;
			if(str != null){
				str = StringUtil.trimArrayElements(str,delim); //("admin, user, manager" , ",")
				roles = str.split(',');
			}
			return roles;
		}
		/**
         * Creates a deep copy of a specified object to a new memory address
         *
         * @param   The reference object in which is to be cloned
         * @return  A clone of the original object
         */
        public static function clone(referenceObject:*):*
        {
            var clone:ByteArray = new ByteArray();
            clone.writeObject(referenceObject);
            clone.position = 0;

            return clone.readObject();
        }		
	}
}