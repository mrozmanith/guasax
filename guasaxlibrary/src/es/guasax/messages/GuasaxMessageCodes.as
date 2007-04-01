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
 * Original idea from Cairngorm, thanks a lot of. 
 */
package es.guasax.messages
{
	/**
	 * All messages/error codes must match the regular expression:
	 *
	 * C\d{4}[EWI]
	 *
	 * 1. The application prefix e.g. 'C'.
	 * 
	 * 2. A four-digit error code that must be unique.
	 * 
	 * 3. A single character severity indicator
	 *    (E: error, W: warning, I: informational).
	 */
	public class GuasaxMessageCodes
	{
	   public static const SINGLETON_EXCEPTION 			          : String = "G0001E";
	   public static const NO_SERVICE_FOUND_EXCEPTION 			  : String = "G0002E";
	   
	   public static const ACTION_ALREADY_REGISTERED_EXCEPTION 	  : String = "G0003E";
	   public static const ACTION_NOT_FOUND_EXCEPTION 			  : String = "G0004E";

	   public static const COMPONENT_ALREADY_REGISTERED_EXCEPTION : String = "G0005E";
	   public static const COMPONENT_NOT_FOUND_EXCEPTION 		  : String = "G0006E";
	   
	   public static const VIEW_ALREADY_REGISTERED_EXCEPTION      : String = "G0007E";
	   public static const VIEW_NOT_FOUND_EXCEPTION 			  : String = "G0008E";		
	   
	   public static const COMPONENT_NOT_ENABLED_EXCEPTION 	      : String = "G0009E";		
	   public static const ACTION_NOT_ENABLED_EXCEPTION 		  : String = "G0010E";		
	   
	   public static const USER_ROLE_NOT_DEFINED_EXCEPTION 		  : String = "G0011E";		
	   public static const USER_ROLE_NOT_LEVEL_EXCEPTION 		  : String = "G0012E";		
	   
	}
}