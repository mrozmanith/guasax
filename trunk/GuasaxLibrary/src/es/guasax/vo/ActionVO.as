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
	import flash.net.ObjectEncoding;
	
	public class ActionVO
	{
		public var actionId   : String; //ID for the action
		public var methodName : String; //Method's name in Business Object 
		
		public var delegateComponentId : String; // Id del componente en el que delegamos esta accion
		public var delegateActionId    : String; // Id de la action del delegateComponentId en el que delegamos esta accion.
		
 		public var viewObjectArray : Array;   // Array of views 
		public var viewMethodName  : String;  // Method's name of view which has been called after 
		public var hasParameters   : Boolean; // that variable say us if the method to execute has parameters
		
		// Return object for action execution
		public var executionResult: Object;
		
		// View params for view method
		public var viewParams: Array;
		
		// Si es true, entonces el container espera a tener la respuesta del metodo remoto para invocar a 
		// la actualizacion de la vista , si tiene que llevar esta llamada a cabo
		public var executeViewUpdateAfterRemoteService  : Boolean;					  		     	    	
							  		     	    
		// nombre de las acciones y de los metodos almacenados en los diccionarios con el formato [actionName] = methodName;
		public var preActionsDictionary   : Dictionary = new Dictionary();
		public var interActionsDictionary : Dictionary = new Dictionary();
		public var postActionsDictionary  : Dictionary = new Dictionary();
		
		// referencia a el compoenente que aloja esta accion con su instance obj.
		public var componentVO: ComponentVO;
		
		// indica si la accion esta habilitado o inhabilitado
		[Bindable]
		public var enabled    : Boolean = true; // por defecto habilitado
		
		public var roles      : Array; 

		// --- GETTER and SETTER ----
		public function setActionId(actionId:String):void{
			this.actionId = actionId;
		}
		public function getActionId():String{
			return this.actionId;
		}
		// -------------------
		public function setMethodName(methodName:String):void{
			this.methodName = methodName;
		}
		public function getMethodName():String{
			return this.methodName;
		}
		// -------------------------------------
		public function setDelegateActionId(delegateActionId:String):void{
			this.delegateActionId = delegateActionId;
		}
		public function getDelegateActionId():String{
			return this.delegateActionId;
		}		
		// -------------------
		public function setPreActionsDictionary(preActionsDictionary:Dictionary):void{
			this.preActionsDictionary = preActionsDictionary;
		}
		public function getPreActionsDictionary():Dictionary{
			return this.preActionsDictionary;
		}	
		// -------------------
		public function setInterActionsDictionary(interActionsDictionary:Dictionary):void{
			this.interActionsDictionary = interActionsDictionary;
		}
		public function getInterActionsDictionary():Dictionary{
			return this.interActionsDictionary;
		}	
		// -------------------
		public function setPostActionsDictionary(postActionsDictionary:Dictionary):void{
			this.postActionsDictionary = postActionsDictionary;
		}
		public function getPostActionsDictionary():Dictionary{
			return this.postActionsDictionary;
		}	
		// -------------------
		public function setComponentVO(componentVO:ComponentVO):void{
			this.componentVO = componentVO;
		}
		public function getComponentVO():ComponentVO{
			return this.componentVO;
		}						
		// ---------------------
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
// ------------------------------

		public function setViewObjectArray(viewObjectArray:Array):void{
			this.viewObjectArray = viewObjectArray;
		}
		public function getViewObjectArray():Array{
			return this.viewObjectArray;
		}	
					
// ------------------------------
		public function setViewMethodName(viewMethodName:String):void{
			this.viewMethodName = viewMethodName;
		}
		public function getViewMethodName():String{
			return this.viewMethodName;
		}					
// ------------------------------
		public function setExecuteViewUpdateAfterRemoteService(executeViewUpdateAfterRemoteService:Boolean):void{
			this.executeViewUpdateAfterRemoteService = executeViewUpdateAfterRemoteService;
		}
		public function isExecuteViewUpdateAfterRemoteService():Boolean{
			return this.executeViewUpdateAfterRemoteService;
		}					
		
// ------------------------------
		public function setExecutionResult(executionResult:Object):void{
			this.executionResult = executionResult;
		}
		public function getExecutionResult():Object{
			return this.executionResult;
		}	
// ------------------------------
		public function setHasParameters(hasParameters:Boolean):void{
			this.hasParameters = hasParameters;
		}
		public function isParameters():Boolean{
			return this.hasParameters;
		}					
// ------------------------------
		public function setViewParams(viewParams:Array):void{
			this.viewParams = viewParams;
		}
		public function getViewParams():Array{
			return this.viewParams;
		}	
	}
}