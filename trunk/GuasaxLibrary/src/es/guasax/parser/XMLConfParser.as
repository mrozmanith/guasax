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
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import mx.messaging.channels.DirectHTTPChannel;
	
	/**
	 * 
	 */
	public class XMLConfParser
	{
		// Singleton 
		private static var instance    : XMLConfParser;
      
      	// constants for name of the elements in xml conf file
        private const PREINTERCEPTORS  : String = "preinterceptors";
        private const INTERCEPTOR      : String = "interceptor";
        private const POSTINTERCEPTORS : String = "postinterceptors";
											          
        private const GLOBAL_INTERCEPTORS : String = "global-interceptors";
        private const COMPONENT           : String = "component";
        private const INCLUDE             : String = "include";

        private const ACTION              : String = "action";
        private const PROPERTY            : String = "property";
      
        private var guasaxConfigurationVO : GuasaxConfigurationVO = GuasaxContainer.getInstance().getGuasaxConfigurationVO();
        
        private var globalPreInterActions  : Dictionary = new Dictionary();
        private var globalPostInterActions : Dictionary = new Dictionary();
        
        // loader para el fichero principal 
		private var myLoader        : URLLoader;
		
		// loader para  los diferentes ficheros include
		//private var myLoaderInclude : URLLoader;
		private var myLoadersInclude : Dictionary = new Dictionary();
		
		
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
        /**
        * In this method we load the xml configuration file.
	    * @param xmlpath Path to the xml configuration file  
        */
     	 public function parseConfFile(xmlpath:String,callBackLoadComplete:Function):void {
			instance.myLoader = new URLLoader();
			instance.myLoader.addEventListener(Event.COMPLETE,instance.loadGuasaxConfFromXML);
			instance.myLoader.addEventListener(Event.COMPLETE,callBackLoadComplete);
			instance.myLoader.load(new URLRequest(xmlpath));
        }	


        /**
        * In this method we load the xml configuration file.
	    * @param xmlpath Path to the xml configuration file  
        */
     	 public function parseIncludeConfFile(xmlpath:String):void {
			instance.myLoadersInclude[xmlpath] = new URLLoader();
			//instance.myLoadersInclude[xmlpath].addEventListener(Event.COMPLETE,instance.loadGuasaxConfFromXMLInclude);
			instance.myLoadersInclude[xmlpath].addEventListener(Event.COMPLETE,instance.loadGuasaxConfFromXML);
			instance.myLoadersInclude[xmlpath].load(new URLRequest(xmlpath));
        }	
        
                   
		/**
		 * When myLoader.load finish , this method is invoked. In this method we start parsing the guasax
		 * configuration
		 */
		private function loadGuasaxConfFromXML(event:Event):void{
			var loader:URLLoader = URLLoader(event.currentTarget);
			var myXML:XML        = new XML(loader.data);
			
			//var myXML:XML = new XML(instance.myLoader.data);
			
        	var myXMLDocument:XMLDocument = new XMLDocument(); 
	        myXMLDocument.ignoreWhite = true; 	        
    	    myXMLDocument.parseXML(myXML.toString()); 
    	    
    	    // accedemos al element root del documento
			var root:XMLNode =  myXMLDocument.firstChild;
			
			// reading the version and description 	
			if(root.attributes.description != undefined){		
				instance.guasaxConfigurationVO.setDescription(root.attributes.description);
			}
			if(root.attributes.version != undefined) {
				instance.guasaxConfigurationVO.setVersion(root.attributes.version);			
			}
			
			// Leemos los componentes propios o resto de ficheros con mas componentes 
			for each (var mainnode:XMLNode in root.childNodes) {				
				// If none type is include, then we parse this node like another guasax-conf.xml file
				// Ej: <include file="login-component.xml"/>
				if(mainnode.nodeName == GLOBAL_INTERCEPTORS){	
					instance.parseGlobalInterceptors(mainnode);
					
				}else if(mainnode.nodeName == INCLUDE){	
					//instance.parseConfFile(mainnode.attributes.file,new Function());	
					instance.parseIncludeConfFile(mainnode.attributes.file);	
								
				}else if(mainnode.nodeName == COMPONENT){	
					instance.parseComponent(mainnode);
					
				}
			}
		}
		
		/**
		 * When myLoader.load finish , this method is invoked. In this method we start parsing the guasax
		 * configuration
		 */
		 /*
		private function loadGuasaxConfFromXMLInclude(event:Event):void{
			var loader:URLLoader = URLLoader(event.currentTarget);
			var myXML:XML = new XML(loader.data);
			
			
        	var myXMLDocument:XMLDocument = new XMLDocument(); 
	        myXMLDocument.ignoreWhite = true; 	        
    	    myXMLDocument.parseXML(myXML.toString()); 
    	    
    	    // accedemos al element root del documento
			var root:XMLNode =  myXMLDocument.firstChild;
			
			// Leemos los componentes propios o resto de ficheros con mas componentes 
			for each (var mainnode:XMLNode in root.childNodes) {				
				// If none type is include, then we parse this node like another guasax-conf.xml file
				// Ej: <include file="login-component.xml"/>
				if(mainnode.nodeName == GLOBAL_INTERCEPTORS){	
					instance.parseGlobalInterceptors(mainnode);
					
				}else if(mainnode.nodeName == INCLUDE){	
					//instance.parseConfFile(mainnode.attributes.file,new Function());	
					instance.parseIncludeConfFile(mainnode.attributes.file);	
								
				}else if(mainnode.nodeName == COMPONENT){	
					instance.parseComponent(mainnode);
					
				}
			}
		}		
		*/

		/**
		 * 
		 * @param mainnode Component Node
		 */
		 private function parseComponent(mainnode:XMLNode):void{
			var componentVO:ComponentVO    = new ComponentVO();
		    var id       :String = String(mainnode.attributes.id);
		    var className:String = String(mainnode.attributes.className);
		    //var enabledComp:Boolean = Boolean(mainnode.attributes.enabled);
		    componentVO.setId(id);
		    componentVO.setClassName(className);
		    if(mainnode.attributes.enabled == "false"){
		    	componentVO.setEnabled(false);
		    }else{ // cualquier otra cosa true
		    	componentVO.setEnabled(true);
		    }
		    //Meter las instacias de estas clases en el actionComponentVO.instanceBO
		    var refClass:Class = getDefinitionByName(className) as Class;
  		    componentVO.setInstanceBO(new refClass()); 
  		    
  		    /* ahora poarseamos los children del compoenete que son las actions y las properties*/
  		    
  		    for each (var actionOrPropertyNode:XMLNode in mainnode.childNodes) {
  		    	// If node type is Action
  		    	if(actionOrPropertyNode.nodeName == ACTION){
  		    		instance.parseAction(actionOrPropertyNode,componentVO);
  			    // if node type is property 
  		    	}else if(actionOrPropertyNode.nodeName == PROPERTY){
  		    		instance.parseProperty(actionOrPropertyNode,componentVO);
  		    	}	  			    	
  		    }
	    	// Lo metemos  a la lista de componentes 
			instance.guasaxConfigurationVO.getComponents()[id] = componentVO;
		 	
		 }
			
		/**
		 * Parseamos el nodo de propiedad de componente 
		 */
		private function parseProperty(propertyNode:XMLNode,componentVO:ComponentVO):void {
			if(propertyNode.attributes.key != undefined && propertyNode.attributes.value != undefined){
	  			componentVO.getProperties()[propertyNode.attributes.key] = propertyNode.attributes.value;
	  	    }
		}
		/**
		 * parseamos la action de nodo, dentro de este componentVO
		 */
		private function parseAction(actionNode:XMLNode,componentVO:ComponentVO):void {
      		var actionVO : ActionVO;
  	    	actionVO = new ActionVO();
  	    	actionVO.setActionId(actionNode.attributes.id)
			// --- consultamos si tenemos el atributo method o el delegate  
			// Si esta el method es que es una action normal, si esta el delegate es que es una accion delegada en otra action.			    	
			// son excluyentes
  	    	if(actionNode.attributes.method != undefined){
  		    	actionVO.setMethodName(actionNode.attributes.method);		  			   	
  		    }else if(actionNode.attributes.delegate != undefined){
  		    	actionVO.setDelegateActionId(actionNode.attributes.delegate);
  		    }
  	    	
  	    	// miramos si este metodo de la action de este objecto , tiene parametros, y lo marcamos
  	    	var hasParameters:Boolean = hasParametersThisMethod(componentVO.getInstanceBO(),actionVO.getMethodName());
  	    	actionVO.setHasParameters(hasParameters);
  	    	
  	    	var arrayRoles : Array = GuasaxUtil.stringToArray(actionNode.attributes.roles,",");
  	    	// si el campo roles no esta definido , ponemos "*"
  	    	if(arrayRoles == null){
  	    		arrayRoles = ["*"]; // habilitado para todos los roles 
  	    	}
  	    	actionVO.setRoles(arrayRoles);
  	    	// verificamos si la action esta enabled o no
  	    	if(actionNode.attributes.enabled == "false"){
  		    	actionVO.setEnabled(false); // 
  		    }else{
  		    	actionVO.setEnabled(true); // como no se ha declarado el atributo enabled, la dejamos habilitada
  		    }
  	    	// verificamos la existencia de interceptors
  	    	for each (var interceptor:XMLNode in actionNode.childNodes) {
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
  	    	// -----------------------------------------------------------------
  	    	// Asociamos los preinterceptors y postinterceptors globales  a esta action de este componente
  	    	
  	    	for each (var preGlobalInterAction:String in instance.globalPreInterActions) {
  	    		actionVO.getPreActionsDictionary()[preGlobalInterAction] = preGlobalInterAction;
  	    	}
  	    	for each (var postGlobalInterAction:String in instance.globalPostInterActions) {
  	    		actionVO.getPostActionsDictionary()[postGlobalInterAction] = postGlobalInterAction;
  	    	}
  	    	
  	    	//----------------------------------------------------------------------
  	    	// set the action to the component
  	    	actionVO.setComponentVO(componentVO);
  	    	componentVO.getActionsDictionary()[actionNode.attributes.id] = actionVO;
		}

		/**
		 * If node type is "include", then we parse this node like guasax-conf.xml file
		 * Ej: <include file="login-component.xml"/>
		 */
		private function parseGlobalInterceptors(mainnode:XMLNode):void {
			for each (var inter:XMLNode in mainnode.childNodes) {
  		    	// Si el nodo que estamos leyendo es de tipo "action" or "property"
  		    	if(inter.nodeName == PREINTERCEPTORS){
					// recorremos las acciones que hacen de preinterceptors	  			    	
  	    			for each (var preInterAction:XMLNode in inter.childNodes) {
  	    				instance.globalPreInterActions[preInterAction] = preInterAction.attributes.id;
  	    			}
  		    	}else if(inter.nodeName == POSTINTERCEPTORS){
					// recorremos las acciones que hacen de POST interceptor	  			    	
  	    			for each (var postInterAction:XMLNode in inter.childNodes) {
  	    				instance.globalPostInterActions[postInterAction] = postInterAction.attributes.id;
  	    			}
  		    	}
  			}
			
		}
	
	
	 	/**
	     * @param object     Objecto en el que vamos a mirar si un metodo tiene parametros.
	     * @param methodName Nombre del metodo en el que vamos a mirar si tiene parametros
	     * @return  true if there are parameters and false if no there are parameters
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