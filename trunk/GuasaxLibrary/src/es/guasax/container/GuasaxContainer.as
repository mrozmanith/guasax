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


package es.guasax.container
{
	import es.guasax.vo.GuasaxConfigurationVO;
	import es.guasax.vo.ResponseActionVO;
	
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import es.guasax.vo.ComponentVO;
	import es.guasax.vo.ActionVO;
	import es.guasax.services.ServiceLocator;
	import es.guasax.parser.XMLConfParser;
	import flash.xml.XMLNode;
	
	import es.guasax.messages.GuasaxError;
	import es.guasax.messages.GuasaxMessageCodes;
	import flash.utils.describeType;
	import es.guasax.util.GuasaxUtil;
	import mx.utils.ObjectUtil;
	import flash.net.registerClassAlias;
	import flash.utils.getQualifiedClassName;
	
	public class GuasaxContainer
	{
		  // singleton instance	
		  private static var instance       : GuasaxContainer;
		  
		  // configuration object
		  private var guasaxConfigurationVO : GuasaxConfigurationVO = new GuasaxConfigurationVO();
		  
		  // fichero principal con la configuracion 
		  public var xmlMainFilePath:String;
		  
		  // Current action 
		  private var currentActionVO       : ActionVO;		  
		  
		  // Rol for current user 
		  private var userRoles              : String; // default 
		  
		  /********************************************************************************************/
		  /********************************* final constants ***************************************/
		  public static const SUPER_ADMIN  : String = "SUPER_ADMIN";
		  
	      public static function getInstance() : GuasaxContainer 
	      {
	      	if ( instance == null )
	      	{
  			 	registerClassAlias("es.guasax.vo.ComponentVO", ComponentVO);
			 	registerClassAlias("es.guasax.vo.ActionVO", ActionVO);
			 	registerClassAlias("flash.utils.Dictionary",Dictionary);

	      		instance = new GuasaxContainer();
	      	}
	      	return instance;
	      }
	      
	      //Constructor should be private
	      public function GuasaxContainer() 
	      {	
	         if ( instance != null )
	         {
	         	throw new GuasaxError(
               			GuasaxMessageCodes.SINGLETON_EXCEPTION, "GuasaxContainer" );
	         }
	      }
     //*******************************************************************************************				
     // Public Methods
     //*******************************************************************************************				
		/**
		 * Parser for the configuration file 
		 * @param xmlfilepath String with XML file path 
		 */
		 public function parseConfFile(xmlMainFilePath:String,callBackLoadComplete:Function):void {
		 	 instance.xmlMainFilePath = xmlMainFilePath;
			 XMLConfParser.getInstance().parseConfFile(xmlMainFilePath,callBackLoadComplete);	
		 }
		 /**
		 * 
		 */ 
		 public function registerClasses(classArray:Array):void{
		 	for each (var className:Class in classArray) {
		 		registerClassAlias(getQualifiedClassName(new className()),className);
		 	}
		 }
		 /**
		 * Creamos un componente a partir de identificador del mismo en el XML Conf. 
		 */
		 public function createComponent(componentId:String,id:String): ComponentVO {
		 	
		 	/*XMLConfParser.getInstance().createComponent(componentType,name);
		 	var newComponentVO:ComponentVO = GuasaxContainer.getInstance().findComponent(name);
		 	*/
		 	//registerClassAlias("es.guasax.vo.ComponentVO", ComponentVO);
		 	//registerClassAlias("es.guasax.vo.ActionVO", ActionVO);
		 	//registerClassAlias("flash.utils.Dictionary",Dictionary);
		 	// TODO - Verificar que no existe un componente con este name, si existe lanzar exception
		    var newComponentVO:ComponentVO = ObjectUtil.copy(instance.findComponent(componentId)) as ComponentVO;
		    newComponentVO.id = id;		    
		    instance.guasaxConfigurationVO.getComponents()[id] = newComponentVO;
		 	return newComponentVO;
		 }
		
		 /**
		 * Execute an action without view redirection
		 * @param actionName Name of the action 
		 * @param params Array of params
		 * @return response object with information about action execution 
		 */
		 public function  executeAction(actionName :String, 
					  		     	    params     :Array,
					  		     	    componentId:String = null): ResponseActionVO {
			var response:ResponseActionVO = new ResponseActionVO();
			// 0.- find the action, para un componente, la buscamos en ese componenteId
			instance.currentActionVO = findAction(actionName,componentId);
			
			// ---------------------------------------------------------------------------
			instance.currentActionVO.setExecuteViewUpdateAfterRemoteService(false);
			instance.currentActionVO.setViewObjectArray(null);
			instance.currentActionVO.setViewMethodName(null);
			instance.currentActionVO.setViewParams(null);			
			// ---------------------------------------------------------------------------
			
	        // 1.- Execute pre actions , the action, and finally post actions
	        var result:Object = executeActionAndInterceptors(instance.currentActionVO , params)
	        
        	response.setResult(result);
	    	response.setViewHandler(null); // don't user in this version
    		response.setError(null);  // don't use in this version
        	
	        return response;
	     }
		 /**
 		 * Execute the action, when it has finished ,container call viewMethodName method for the views array
 		 * @param actionName 	  Action`s name defined in xml file
 		 * @param params          Array of params 
 		 * @param viewObjectArray Array of views for update after method execution
 		 * @param viewMethodName  Method's name of the view 
 		 * @param viewParams      Array of view method params 
 		 * @return Object responseActionVO with result os execution
		 */
		 public function  executeActionWithView(actionName      : String,                  
							  		     	    params          : Array,
							  		     	    viewObjectArray : Array,
							  		     	    viewMethodName  : String,
							  		     	    viewParams      : Array): ResponseActionVO {
			// 0.- To find the action
			instance.currentActionVO = findAction(actionName);
			// ---- Eliminmamos el flag de After por si en la petición anterior lo hemos pedido ----
			instance.currentActionVO.setExecuteViewUpdateAfterRemoteService(false);
			
	        // 1.- Execute pre actions , the action, and finally post actions
	        var actionResult:Object = executeActionAndInterceptors(instance.currentActionVO , params)
	        
	        //2.- Pasamos el control a la vista llamando al metodo que nos han pasado
	        executeViewUpdate(viewObjectArray,viewMethodName,viewParams);
	        
	        //3.- Creamos el response para añadir el resultado
	        var response:ResponseActionVO = new ResponseActionVO();
        	
	        response.setResult(actionResult);
    	    response.setViewHandler(null);
        	response.setError(null);
        	
	        return response;
	     }
	     
		/**
		 * @param actionName 	  Action`s name defined in xml file
 		 * @param params          Array of params 
 		 * @param viewObjectArray Array of views for update after method execution
 		 * @param viewMethodName  Method's name of the view 
 		 * @param viewParams      Array of view method params 
 		 * @return Object responseActionVO with result os execution		 
 		 * */
		 public function  executeActionWithViewAfterService(actionName      : String,                  
										  		     	    params          : Array,
										  		     	    viewObjectArray : Array,
										  		     	    viewMethodName  : String,
										  		     	    viewParams      : Array): ResponseActionVO {

			// 0.- localizamos la actionVO
			instance.currentActionVO = findAction(actionName);
			
	        // 1.1.- seteamos ahora los views en la currentActionVO, ya que si existe se ha seteado, 
			// en el metodo executeActionAndInterceptors.
			instance.currentActionVO.setExecuteViewUpdateAfterRemoteService(true);
			instance.currentActionVO.setViewObjectArray(viewObjectArray);
			instance.currentActionVO.setViewMethodName(viewMethodName);
			// seteamos los parametros que se pasaran a la vista en la accion, para cuando finalice el service 
			// remoto poder pasarselos.
			instance.currentActionVO.setViewParams(viewParams);

	        // 1.- Ejecutamos las pre actions , la action, y las post actions
	        var result:Object = executeActionAndInterceptors(instance.currentActionVO , params)
	        
	        //2.- Creamos el response para añadir el resultado
	        var response:ResponseActionVO = new ResponseActionVO();
        	
	        response.setResult(result);
    	    response.setViewHandler(null);
        	response.setError(null);
        	
	        return response;
	     }	     

		/**
		* Continua con la ejecucion de la vista.
		* TODO - Tal vez lo mas simple y apropiado seria no pasar a los metodos de la vista , ningun parametros
		* para que estos consulten del ModelLocator lo que necesiten , y centralicemos el uso de parametros, a 
		* través del ModelLocator. 
  	    * De esta manera se pueden reutilizar mucho mas los metodos de updateView, al no estar marcados por 
  	    * la recepción de unos determinados parametros.
		*/
		public function executeViewUpdate(viewObjectArray:Array,viewMethodName:String,viewParams:Array):void{
			for each (var viewObject:Object in viewObjectArray) {
				//var viewParams : Array = [params];
				var classInfo:XML = describeType(viewObject);
				// Listamos los metodos de la clase.
				for each (var m:XML in classInfo.method) {
					if(viewMethodName == m.@name){
						var withoutParam:Boolean = true;
						for each (var p:XML in m.parameter) {
							withoutParam = false;
							break;
						}
						// Si el metodo de la vista recibe parametros , se los pasamos, 
						// si no recibe , lo invocamos sin parametros.
						if(withoutParam == true){
							viewObject[viewMethodName].apply(viewObject,null);
						}else{
							viewObject[viewMethodName].apply(viewObject,viewParams);
						}
						break;
					}
				}
			}
		}	    		
	     
	     
		 /**
	     * Looking for  action 
	     */
	     public function findAction(actionId:String,componentId:String = null):ActionVO{
	     	var actionVO:ActionVO = null;
	     	// Si hemos pasado un nombre de componente concreto, devolvemos la action de ese, ya que tendrá las
	     	// acciones delegadas a los metodos concretos de los BO(Ej:NoticiasBO, ProductosBO, etc...)
			if(componentId != null){
				var comp:ComponentVO = guasaxConfigurationVO.getComponents()[componentId];
				actionVO = comp.getActionsDictionary()[actionId];
				return actionVO;
			}
			// Si no pasamos componentId(deprecated), busamos la actionId entre los diferentes componentes
			for each (var component:ComponentVO in guasaxConfigurationVO.getComponents()){
	        	if(component.getActionsDictionary()[actionId] != null){
	        		actionVO = component.getActionsDictionary()[actionId];
	        		break;
	        	}
        	}	  
        	// verificamos si hemos encontrado la action
	        if(actionVO == null){
	        	throw new GuasaxError(GuasaxMessageCodes.ACTION_NOT_FOUND_EXCEPTION, "["+actionId+"]" );
	        }        	   	
        	return actionVO;
	     }
	     
	     /**
	     * Looking for  component
	     */
	     public function findComponent(componentId:String):ComponentVO{
        	return guasaxConfigurationVO.getComponents()[componentId];
	     }	     
	     
		 /**
	     * Habilita o deshabilita un component para ser ejecutado.
	     * Si un componente esta deshabilitado las acciones de este no se ejecutarán
	     * @param componentName Name of the component
	     * @param value       true or false value for enabled property of component 
	     */
	     public function setEnabledComponent(componentName:String,value:Boolean):void{
	     	var componentVO : ComponentVO =  findComponent(componentName);
	     	if(componentVO == null){
	     		throw new GuasaxError(
               		GuasaxMessageCodes.COMPONENT_NOT_FOUND_EXCEPTION, "["+componentName+"]" );
	     	}
	     	componentVO.setEnabled(value);
	     }	   
	     /** 
	     * 
		 * @param component ID for the component
	     */ 
		 public function isEnabledComponent(componentName:String):Boolean{
	     	var componentVO : ComponentVO =  findComponent(componentName);
	     	if(componentVO == null){
	     		throw new GuasaxError(
               		GuasaxMessageCodes.COMPONENT_NOT_FOUND_EXCEPTION, "["+componentName+"]" );
	     	}
	     	return componentVO.isEnabled(); 
	     }	  	      
		 /**
	     * Habilita o deshabilita una action para ser ejecutada.
		 * @param actionId    ID for the action
	     * @param value       true or false value for enabled property of action	     
	     * */
	     public function setEnabledAction(actionId:String,value:Boolean):void{
	     	var actionVO : ActionVO =  findAction(actionId);
	     	if(actionVO == null){
	     		throw new GuasaxError(
               		GuasaxMessageCodes.ACTION_NOT_FOUND_EXCEPTION, "["+actionId+"]" );
	     	}
	     	actionVO.setEnabled(value);
	     }
	     /** 
	     * asking for enabled property of an action
	     * @param actionId ID for the action 
	     */
	     public function isEnabledAction(actionId:String):Boolean{
	     	var actionVO : ActionVO =  findAction(actionId);
	     	if(actionVO == null){
	     		throw new GuasaxError(
               		GuasaxMessageCodes.ACTION_NOT_FOUND_EXCEPTION, "["+actionId+"]" );
	     	}
	     	return actionVO.isEnabled(); 
	     }	     
	     /****************************************************************************/
	     /****** PRIVATE METHODS ****************************************/
	     /****************************************************************************/
	     
	     /**
	     * Ejecutamos la accion que han psado, mas sus preactions and postactions  
	     */
	     private function  executeActionAndInterceptors(actionVO:ActionVO,params:Array): Object {
			var flag   : Boolean = false;
	        var result : Object;					

			//0.- miramos si la accion esta delegada y si es asñi reasignamos la acccionVO a la delegada
			if(actionVO.getDelegateActionId() != null){
				actionVO = findAction(actionVO.delegateActionId,actionVO.delegateComponentId);
			}
	        // 1.- comprobamos que el componente y la action estan habilitados
	        // si la action existe , miramos si esta habilitado su componente y esta action
	        if(!actionVO.getComponentVO().isEnabled()){
	        	throw new GuasaxError(GuasaxMessageCodes.COMPONENT_NOT_ENABLED_EXCEPTION, "["+actionVO.getComponentVO().getType()+"]" );
	        }
	        if(!actionVO.isEnabled()){
	        	throw new GuasaxError(GuasaxMessageCodes.ACTION_NOT_ENABLED_EXCEPTION, "["+actionVO.getActionId()+"]" );
	        }
	        
	        
			 // 1.1.- verificamos si tenenmos el role necesario para ejecutar la action
	        var actionRolesArray : Array = actionVO.getRoles();
	        var userRolesArray   : Array = GuasaxUtil.stringToArray(userRoles,",");
	        // miramos si alguno de los roles del usuario está en los de la acción, 
	        // Nota: Si la accion no tiene roles definidos LA puede ejecutar todo el mundo.
	        if(actionRolesArray != null){ //verificamos si el usuario contiene el rol de la action
	            //Alert.show("actinoroles:"+actionRoles);
	        	var match:Boolean = false;
				for each(var actionrol:String in actionRolesArray){
					for each(var userrol:String in userRolesArray){					
						if(actionrol == userrol){
							match = true;
							//Alert.show("El usuario contiene el rol necesario");
							break;
						}
					}
				}	 
				if(!match){
					//Alert.show("El usuario NO contiene el rol necesario");
					throw new GuasaxError(GuasaxMessageCodes.USER_ROLE_NOT_LEVEL_EXCEPTION, "["+userRoles+"]" );					
				}       	
	        }	        
	        
	        /*
	        if(roles.indexOf(userRole) == -1 && roles.indexOf("*")==-1){
	        	throw new GuasaxError(GuasaxMessageCodes.USER_ROLE_NOT_LEVEL_EXCEPTION, "["+userRole+"]" );
	        }
	        */
	        
	        
    		// 2.- Seteamos la accion que vamos a ejecutar en el  framework, para poder desde cualquier parte 
    		// de nuestro programa poder acceder a la action actual, incluso desde el codigo de los interceptors, 
    		// por ejemplo un log Interceptor, para poder poner el nombre de la clase y metodo interceptado.
    		instance.currentActionVO = actionVO;
    		
    		// ----------------------------------------------------------------------------
    		// 3.- revisamos si tenemos preinterceptors
    		// ----------------------------------------------------------------------------
    		executePreActionsForAction(actionVO,params);
    		// ----------------------------------------------------------------------------
    		// 4.- ejecutamos, si tiene, interceptor esta action.
    		// ----------------------------------------------------------------------------
    		var interParams:Array = null;
    		for each(var interActionId:String in actionVO.getInterActionsDictionary()){
    			//4.1.- findAction para el interceptor a traves del actionId.
    			var interActionVO:ActionVO = findAction(interActionId);
    			//4.2.- coger ese actionVO e invocar a su method, y recogemos los parametros modificados.
    			//un interceptor debe coger los parametros que recibe y devolver los mismos en forma de Array modificados.
    			if(interActionVO.isParameters() == true){
    				interParams = interActionVO.getComponentVO().getInstanceBO()[interActionVO.getMethodName()].apply(interActionVO.getComponentVO().getInstanceBO(),params);	
    			}else{
    				interParams = interActionVO.getComponentVO().getInstanceBO()[interActionVO.getMethodName()].apply(interActionVO.getComponentVO().getInstanceBO(),null);	
    			}
    		}
    		
    		
    		// ----------------------------------------------------------------------------
    		// 5.- ejecutamos la action principal
    		// ----------------------------------------------------------------------------
    		if(interParams != null){
    			// 5.1.- ejecutamos la accion con los parametros interceptados y modificados
    			if(actionVO.isParameters() == true){
    				result = actionVO.getComponentVO().getInstanceBO()[actionVO.getMethodName()].apply(actionVO.getComponentVO().getInstanceBO(),interParams);	
    			}else {
    				result = actionVO.getComponentVO().getInstanceBO()[actionVO.getMethodName()].apply(actionVO.getComponentVO().getInstanceBO(),null);	
    			}
    		}else{
    			// 5.2.- ejecutamos la accion con los parametros originales
    			if(actionVO.isParameters() == true){
	    			result = actionVO.getComponentVO().getInstanceBO()[actionVO.getMethodName()].apply(actionVO.getComponentVO().getInstanceBO(),params);	
	    		}else {
	    			result = actionVO.getComponentVO().getInstanceBO()[actionVO.getMethodName()].apply(actionVO.getComponentVO().getInstanceBO(),null);	
	    		}
    		}
    		
    		// ----------------------------------------------------------------------------
    		// 6.- revisamos si tenemos postinterceptors
    		// ----------------------------------------------------------------------------
    		executePostActionsForAction(actionVO, params);
    		
        	return result;				  		     	    	
		 }
	     
		 /**
	     * Ejecutamos los pre interceptors de la action que pasamos 
	     */
	     private function executePreActionsForAction(actionVO:ActionVO,params:Array):void{
	     	for each(var preActionId:String in actionVO.getPreActionsDictionary()){
    			//1.- findAction a traves del action.
    			var preActionVO:ActionVO = findAction(preActionId);
    			//2.- coger ese actionVO e invocar a su 
    			//preActionVO.getComponentVO().getInstanceBO()[preActionVO.getMethodName()].apply(preActionVO.getComponentVO().getInstanceBO(),params);	
    			// Nota: en este caso los post interceptors no pueden tener parametros, tienen que trabajar sobre los 
    			// datos del ModelLocator o ser independientes
    			if(preActionVO.isParameters() == true){
	    			preActionVO.getComponentVO().getInstanceBO()[preActionVO.getMethodName()].apply(preActionVO.getComponentVO().getInstanceBO(),params);	
	    		}else{
	    			preActionVO.getComponentVO().getInstanceBO()[preActionVO.getMethodName()].apply(preActionVO.getComponentVO().getInstanceBO(),null);	
	    		}
    		}
	     }	     
	     
	     /**
	     * Ejecutamos los post interceptors de al action que pasamos
	     * @param actionVO action de la que vamos a ejecutar los psot interceptors
	     * @param params   paramtros que pasamos a la action 
	     */
	     private function executePostActionsForAction(actionVO:ActionVO,params:Array):void{
	     	for each(var postActionId:String in actionVO.getPostActionsDictionary()){
    			//6.1.- findAction a traves del action.
    			var postActionVO:ActionVO = findAction(postActionId);
    			//6.2.- coger ese actionVO e invocar a su postinterceptors 
    			//postActionVO.getComponentVO().getInstanceBO()[postActionVO.getMethodName()].apply(postActionVO.getComponentVO().getInstanceBO(),params);	
    			// Nota: en este caso los post interceptors no pueden tener parametros, tienen que trabajar sobre los 
    			// datos del ModelLocator o ser independientes
				if(postActionVO.isParameters() == true){    			
    				postActionVO.getComponentVO().getInstanceBO()[postActionVO.getMethodName()].apply(postActionVO.getComponentVO().getInstanceBO(),params);	
			    }else{
			    	postActionVO.getComponentVO().getInstanceBO()[postActionVO.getMethodName()].apply(postActionVO.getComponentVO().getInstanceBO(),null);	
			    }
    		}
	     }	     
	     
	     /********************************************************************************************/
	     /*********************  SETTER y GETTER ***************************************/
	     /********************************************************************************************/
	
		/**
		 * Obtenemos la action actula que se esta ejecutando en el container 
		 */
		 public function getCurrentActionVO(): ActionVO{
			return instance.currentActionVO;
		 }
	     /**
		 * Seteamos la configuracion en el container 	     
		 */
	     public function setGuasaxConfigurationVO(guasaxConfigurationVO: GuasaxConfigurationVO):void {
	     	instance.guasaxConfigurationVO = guasaxConfigurationVO;
	     }
	     /**
		 * Obtenensmo una referencia a la configuracion en el container 	     
		 */
	     public function getGuasaxConfigurationVO():GuasaxConfigurationVO {
	     	return instance.guasaxConfigurationVO;
	     }
	     //------------------------------------------------------------
	     public function setUserRoles(userRoles: String):void {
	     	instance.userRoles = userRoles;
	     }
	     public function getUserRoles():String {
	     	return instance.userRoles;
	     }
	     
	     	
	}
}