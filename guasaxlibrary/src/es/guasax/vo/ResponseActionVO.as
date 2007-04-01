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
 
package es.guasax.vo
{
	import mx.core.IFlexDisplayObject;
	
	public class ResponseActionVO
	{
		// manejador de la vista que se ha pasado para llevar a cabo la operacion
		private var viewHandler : Object; //Podria ser tab un IFlexDisplayObject, tal vez, verificar
		// resultado de la operacion
		private var result	   : Object;
		// si se produce un error 
		private var error       : Error;
		// ---------- GETTER and SETTER ---------------
		public function setViewHandler(viewHandler:Object):void{
			this.viewHandler = viewHandler;
		}
		public function getViewHandler():Object{
			return this.viewHandler;
		}			
		// --------------------------------------------
		public function setResult(result:Object):void{
			this.result = result;
		}
		public function getResult():Object{
			return this.result;
		}			
		// --------------------------------------------
		public function setError(error:Error):void{
			this.error = error;
		}
		public function getError():Error{
			return this.error;
		}			
	}
}