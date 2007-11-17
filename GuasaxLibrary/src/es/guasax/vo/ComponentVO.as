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
	import es.guasax.messages.GuasaxMessageCodes;
	import es.guasax.messages.GuasaxError;
	
	public class ComponentVO
	{
		// identificador del tipo de compoenente 
		public var type       : String;
		// identificador de "este" compoenente particular
		public var id         : String;
		// clase de negocio (BO) del componente
		public var className  : String;		
		
		// Instancia en obj  del componente
		public var instanceBO : Object;
		// diccionario de acciones (ActionVO) de este compoenente 
		public var actionsDictionary : Dictionary = new Dictionary();
		// indica si el componente esta habilitado o inhabilitado, todo el componente independientemente de cada accion
		[Bindable]
		public var enabled    : Boolean = true;
		
		public var roles      : Array; 
		
		// Propiedades que se cargan en el componente en en fichero de descripción del mismo.
		// Ej: <property key="NUMERO_INTENTOS" value="3"/>	
		public var properties : Dictionary = new Dictionary();
		
		//
		// Lista de objetos vista de este componente.
		//
		public var views      : Dictionary = new Dictionary();
	
		
		// -------- GETTER and SETTER ---------------
		public function setType(type:String):void{
			this.type = type;
		}
		public function getType():String{
			return this.type;
		}	
		// ----------------------------------------
		public function setId(id:String):void{
			this.id = id;
		}
		public function getId():String{
			return this.id;
		}	
		// ----------------------------------------
		public function setClassName(className:String):void{
			this.className = className;
		}
		public function getClassName():String{
			return this.className;
		}					
		// ----------------------------------------
		public function setInstanceBO(instanceBO:Object):void{
			this.instanceBO = instanceBO;
		}
		public function getInstanceBO():Object{
			return this.instanceBO;
		}					
		// ----------------------------------------
		public function setActionsDictionary(actionsDictionary:Dictionary):void{
			this.actionsDictionary = actionsDictionary;
		}
		public function getActionsDictionary():Dictionary{
			return this.actionsDictionary;
		}					
		// ------------------------------
		public function setEnabled(enabled:Boolean):void{
			this.enabled = enabled;
		}
		public function isEnabled():Boolean{
			return this.enabled;
		}		
		// ------------------------------
		public function setRoles(roles:Array):void{
			this.roles = roles;
		}
		public function getRoles():Array{
			return this.roles;
		}	
// ----------------------------------------
		public function setProperties(properties:Dictionary):void{
			this.properties = properties;
		}
		public function getProperties():Dictionary{
			return this.properties;
		}		
// ----------------------------------------
		public function getProperty( key:String) : Object {
			return  this.properties[key];			
		}						
		public function addProperty( key:String, value:Object) : void {
			this.properties[key] = value;			
		}						
// ----------------------------------------
		public function getViews( ) : Dictionary {
			return  this.views;			
		}						
		public function setViews( views:Dictionary) : void {
			this.views = views;			
		}						
// ----------------------------------------
// TODO - Comprobar que no existe una vista con este nombre en este componente
		public function addView(view:Object, key:String ) : void {
			if ( this.views[key] != null ) {
	            throw new GuasaxError(GuasaxMessageCodes.VIEW_ALREADY_REGISTERED_EXCEPTION, key );
        	}
			this.views[key] = view;			
		}						
					

	}
}