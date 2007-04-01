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
	import flash.utils.Dictionary;
	
	public class GuasaxConfigurationVO
	{
		// version del framework
		private var version     : String;
		// descripcion de la version
		private var description : String;
		// conjunto de componentes 
		private var components  : Dictionary;
		
		// ---------- GETTER and SETTER ---------------
		public function setVersion(version:String):void{
			this.version = version;
		}
		public function getVersion():String{
			return this.version;
		}					
		// --------------------------------------------
		public function setDescription(description:String):void{
			this.description = description;
		}
		public function getDescription():String{
			return this.description;
		}					
		// --------------------------------------------
		public function setComponents(components:Dictionary):void{
			this.components = components;
		}
		public function getComponents():Dictionary{
			return this.components;
		}					
	}
}