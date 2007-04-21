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

package es.guasax.parser
{
	import es.guasax.container.GuasaxContainer;
	import es.guasax.util.GuasaxUtil;
	import es.guasax.vo.ActionVO;
	import es.guasax.vo.ComponentVO;
	import es.guasax.vo.GuasaxConfigurationVO;
	
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.xml.XMLDocument;
	import flash.xml.XMLNode;
	import flash.utils.describeType;
	
	/**
	 * 
	 */
	public class XMLConfParser
	{
		// Singleton 
		private static var instance    : XMLConfParser;
      
        private const PREINTERCEPTORS  : String = "preinterceptors";
        private const INTERCEPTOR      : String = "interceptor";
        private const POSTINTERCEPTORS : String = "postinterceptors";
      
       // ------------------------------------------------------------------------------------
        public static function getInstance() : XMLConfParser 
        {
      	   if ( instance == null )
      	   {
      		 instance = new XMLConfParser();
       	   }
           return instance;
        }
      
        //Constructor should be private 
        public function XMLConfParser() 
        {	
           if ( instance != null )
           {
         	  throw new Error( "Only one XMLConfParser instance should be instantiated" );	
           }
        }	
        // ---------------------------------------------
        /**
        *  Return a  GuasaxConfigurationVO with all components
        * @param xmlfile XMLNode element for framework configuration  
        * @return return a guasaxConfigurationVO object
        */
		  public function parseConfFile(xmlfile:XMLNode):GuasaxConfigurationVO {
         	
        	var myXMLDocument:XMLDocument = new XMLDocument(); 
	        myXMLDocument.ignoreWhite = true; 
    	    myXMLDocument.parseXML(xmlfile.toString()); 
        	
        	var guasaxConfigurationVO : GuasaxConfigurationVO = new GuasaxConfigurationVO();
			var components            : Dictionary = new Dictionary();
			
			var root:XMLNode =  myXMLDocument.firstChild;
			
			var version     : String = root.attributes.version;
			var description : String = root.attributes.description;
			
			var componentVO : ComponentVO;
			for each (var component:XMLNode in root.childNodes) {
				componentVO    = new ComponentVO();
			    var id       :String = String(component.attributes.id);
			    var className:String = String(component.attributes.className);
			    //var enabledComp:Boolean = Boolean(component.attributes.enabled);
			    componentVO.setId(id);
			    componentVO.setClassName(className);
			    if(component.attributes.enabled == "false"){
			    	componentVO.setEnabled(false);
			    }else{ // cualquier otra cosa true
			    	componentVO.setEnabled(true);
			    }
			    //Meter las instacias de estas clases en el actionComponentVO.instanceBO
			    var refClass:Class = getDefinitionByName(className) as Class;
  			    componentVO.setInstanceBO(new refClass()); 
  			    
  			    /* ahora poarseamos los children del compoenete que son las actions*/
  			    var actionVO : ActionVO;
  			    for each (var action:XMLNode in component.childNodes) {
  			    	actionVO = new ActionVO();
  			    	actionVO.setActionId(action.attributes.id)
					// --- consultamos si tenemos el atributo method o el delegate  			    	
  			    	if(action.attributes.method != undefined){
	  			    	actionVO.setMethodName(action.attributes.method);
	  			    }
   			    	if(action.attributes.delegate != undefined){
	  			    	actionVO.setDelegateActionId(action.attributes.delegate);
	  			    }
  			    	
  			    	// miramos si este metodo de la action de este objecto , tiene parametros, y lo marcamos
  			    	var hasParameters:Boolean = hasParametersThisMethod(componentVO.getInstanceBO(),actionVO.getMethodName());
  			    	actionVO.setHasParameters(hasParameters);
  			    	
  			    	var arrayRoles : Array = GuasaxUtil.stringToArray(action.attributes.roles,",");
  			    	// si el campo roles no esta definido , ponemos "*"
  			    	if(arrayRoles == null){
  			    		arrayRoles = ["*"]; // habilitado para todos los roles 
  			    	}
  			    	actionVO.setRoles(arrayRoles);
  			    	// verificamos si la action esta enabled o no
  			    	if(action.attributes.enabled == "false"){
	  			    	actionVO.setEnabled(false); // 
	  			    }else{
	  			    	actionVO.setEnabled(true); // como no se ha declarado el atributo enabled, la dejamos habilitada
	  			    }
  			    	// verificamos la existencia de interceptors
  			    	for each (var interceptor:XMLNode in action.childNodes) {
  			    		if(interceptor.localName == PREINTERCEPTORS){
  			    			for each (var preAction:XMLNode in interceptor.childNodes) {
  			    				actionVO.getPreActionsDictionary()[preAction.attributes.id] = preAction.attributes.id;
  			    			}
  			    		}else if(interceptor.localName == INTERCEPTOR){
  			    			for each (var interAction:XMLNode in interceptor.childNodes) {
  			    				actionVO.getInterActionsDictionary()[interAction.attributes.id] = interAction.attributes.id;
  			    			}
  			    		}else if(interceptor.localName == POSTINTERCEPTORS){
  			    			for each (var postAction:XMLNode in interceptor.childNodes) {
  			    				actionVO.getPostActionsDictionary()[postAction.attributes.id] = postAction.attributes.id;
  			    			}
  			    		}
  			    	}
  			    	// asociamos a la accion su componente 
  			    	actionVO.setComponentVO(componentVO);
  			    	componentVO.getActionsDictionary()[action.attributes.id] = actionVO;
  			    }
			    // Lo metemos  a la lista de componentes 
				components[id] = componentVO;
			}
			// -------------------------------------------------------------------------------
			guasaxConfigurationVO.setComponents(components);
			guasaxConfigurationVO.setDescription(description);
			guasaxConfigurationVO.setVersion(version);
			
			return guasaxConfigurationVO;     	
        }	
	
	
	
	 	/**
	     * @param object     Objecto en el que vamos a mirar si un metodo tiene parametros.
	     * @param methodName Nombre del metodo en el que vamos a mirar si tiene parametros
	     * @return  
	     */
	     private function hasParametersThisMethod(object:Object, methodName:String):Boolean{
				var classInfo:XML = describeType(object);
				// List the object's methods.
				for each (var m:XML in classInfo.method) {
					if(methodName == m.@name){
						var hasParam:Boolean = false;
						for each (var p:XML in m.parameter) {
							hasParam = true;
							break;
						}
						break;
					}
				}	 
				return hasParam;    	
	     }
		
	}
}