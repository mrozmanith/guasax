/*
Copyright (c) 2006. Adobe Systems Incorporated.
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

  * Redistributions of source code must retain the above copyright notice,
    this list of conditions and the following disclaimer.
  * Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions and the following disclaimer in the documentation
    and/or other materials provided with the distribution.
  * Neither the name of Adobe Systems Incorporated nor the names of its
    contributors may be used to endorse or promote products derived from this
    software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.
*/


package es.guasax.services
{
   import es.guasax.container.GuasaxContainer;
   import es.guasax.messages.GuasaxError;
   import es.guasax.messages.GuasaxMessageCodes;
   import es.guasax.util.GuasaxUtil;
   import es.guasax.vo.ActionVO;
   
   import flash.net.registerClassAlias;
   import flash.utils.describeType;
   import flash.utils.setTimeout;
   
   import mx.controls.Alert;
   import mx.rpc.AbstractInvoker;
   import mx.rpc.AbstractService;
   import mx.rpc.http.HTTPService;
   import mx.rpc.remoting.Operation;
   import mx.rpc.remoting.RemoteObject;
   import mx.rpc.soap.WebService;
   import mx.rpc.AsyncToken;
   
   public class ServiceLocator implements IServiceLocator
   {   
      private static var instance : ServiceLocator;
      
// --------------------------------------------------------------------      
      private var services      : Array;
      private var httpServices  : Array;
      private var messageAgents : Array;
      private var dataServices  : Array;
      
      /**
       * Return the ServiceLocator instance.
       * @return the instance.
       */
      public static function getInstance() : ServiceLocator 
      {
         if ( instance == null )
         {
            instance = new ServiceLocator();
         }
            
         return instance;
      }
         
      // Constructor should be private but current AS3.0 does not allow it
      public function ServiceLocator() 
      {   
         if ( instance != null )
         {
            throw new GuasaxError(
               GuasaxMessageCodes.SINGLETON_EXCEPTION, "ServiceLocator" );
         }
         instance = this;
      }
      
 	 /**
	  * Ejecuta el metodo (methodName) servicio remoto(serviceName) con los params.
	  * Se setean las dos funciones de handler que se pasan para poder invocarlas en cuanto nos lleve la 
	  * respuesta de este metodo que invocamos desde aqui, se pasa tambien el objectResult, 
	  * objeto del cual se invocan las funciones resultFunc y faultFunc, en la modo de ejecucion
	  * afterService
	  */
      public function executeService(serviceName: String,
      								 methodName : String,
      								 params     : Array, 
      								 resultFunc : Function, 
      								 faultFunc  : Function,
      								 objectResult : Object ):void{
      	 // obtenemos el servicio por el nombre 								
      	 var service : Object = getService(serviceName);
      	 
      	 /************************************************************************************/
      	 /** Si el servicio es de tipo HTTPService **/
      	 
      	 if(service is HTTPService){
			 service.cancel();
			
			 // preparamos un responseCallBack para almacenar esta ejecucion de operacion remota
	      	 var responseCallBackHTTPService : ResponseCallBack = new ResponseCallBack();
	      	 
	      	 responseCallBackHTTPService.setActionVO(GuasaxContainer.getInstance().getCurrentActionVO());
	      	 responseCallBackHTTPService.currentResultFuncion = resultFunc;
	      	 responseCallBackHTTPService.currentFaultFuncion  = faultFunc;
	      	 responseCallBackHTTPService.objectResult         = objectResult;			
			
			(HTTPService(service)).resultFormat = "e4x";
			var token:AsyncToken = (HTTPService(service)).send(params);
			token.resultHandler  = responseCallBackHTTPService.onResult;
			token.faultHandler   = responseCallBackHTTPService.onFault;
			
      	 // Si el servicio es de tipo WebService 
      	 }else if(service is WebService){
	      	 service.loadWSDL();
 			 var operationWS : mx.rpc.soap.Operation = mx.rpc.soap.Operation(service[methodName]);
	      	 if(params != null){
	      	 	operationWS.arguments = params;
	      	 }	    
	      	 operationWS.resultFormat =  "e4x"; 
	      	 	 
	      	 // preparamos un responseCallBack para almacenar esta ejecucion de operacion remota
	      	 var responseCallBackWS : ResponseCallBack = new ResponseCallBack();
	      	 
	      	 responseCallBackWS.setActionVO(GuasaxContainer.getInstance().getCurrentActionVO());
	      	 responseCallBackWS.currentResultFuncion = resultFunc;
	      	 responseCallBackWS.currentFaultFuncion  = faultFunc;
	      	 responseCallBackWS.objectResult         = objectResult;
	      	 
	      	 // Ejecutamos la operacion 
	      	 var callObjectWS : Object  = operationWS.send();  

			 callObjectWS.resultHandler = responseCallBackWS.onResult;
			 callObjectWS.faultHandler  = responseCallBackWS.onFault;   
      	 	
      	 // Si el servicio es de tipo WebService 
      	 }else if(service is RemoteObject){
			 var operation : Operation = mx.rpc.remoting.Operation(service[methodName]);
	      	 if(params != null){
	      	 	operation.arguments = params;
	      	 }
	      	 
	      	 // preparamos un responseCallBack para almacenar esta ejecucion de operacion remota
	      	 var responseCallBack : ResponseCallBack = new ResponseCallBack();
	      	 
	      	 responseCallBack.setActionVO(GuasaxContainer.getInstance().getCurrentActionVO());
	      	 responseCallBack.currentResultFuncion = resultFunc;
	      	 responseCallBack.currentFaultFuncion  = faultFunc;
	      	 responseCallBack.objectResult         = objectResult;
	      	 
	      	 // Ejecutamos la operacion 
	      	 var callObject : Object = operation.send();      	 
			 callObject.resultHandler = responseCallBack.onResult;
			 callObject.faultHandler  = responseCallBack.onFault;      	 	
      	 }
      }
      
      /**
       * Returns the service defined for the id, to allow services to be looked up
       * using the ServiceLocator by a canonical name.
       *
       * <p>If no service exists for the service name, an Error will be thrown.</p>
       * @param The id of the service to be returned. This is the id defined in the
       * concrete service locator implementation.
       */
      public function getService( serviceId : String ) : Object
      {
          var service: Object =  getServiceForId( serviceId ) ;
          return service;
      }      

      /**
       * Return the RemoteObject for the given service id.
       * @param serviceId the service id.
       * @return the RemoteObject.
       */
      public function getRemoteObject( serviceId : String ) : RemoteObject
      {
         return RemoteObject( getServiceForId( serviceId ) );
      }
      
      /**
       * Return the HTTPService for the given service id.
       * @param serviceId the service id.
       * @return the RemoteObject.
       */
      public function getHTTPService( serviceId : String ) : HTTPService
      {
         return HTTPService( getServiceForId( serviceId ) );
      }
      
      /**
       * Return the WebService for the given service id.
       * @param serviceId the service id.
       * @return the RemoteObject.
       */
      public function getWebService( serviceId : String ) : WebService
      {
         return WebService( getServiceForId( serviceId ) );
      }
      
      /**
       * Set the credentials for all registered services. Note that services
       * that use a proxy or a third-party adapter to a remote endpoint will
       * need to setRemoteCredentials instead.
       * @param username the username to set.
       * @param password the password to set.
       */
      public function setCredentials( username : String, password : String ) : void 
      {
         setServiceCredentials( username, password );
         setHTTPServiceCredentials( username, password );
      }
      
      /**
       * Logs the user out of all registered services.
       */
      public function logout() : void
      {
          logoutFromServices();
          logoutFromHTTPServices();
      }
      
      /**
       * Return the service with the given id.
       * @param serviceId the id of the service to return.
       * @return the service.
       */
      private function getServiceForId( serviceId : String ) : Object
      {
         if ( this[ serviceId ] == null )
         {
            throw new GuasaxError(
               GuasaxMessageCodes.NO_SERVICE_FOUND_EXCEPTION, serviceId );
               
         }
         
         return this[ serviceId ];
      }
      
      /**
       * Set the user's credentials on all registered services.
       * @param username the username to set.
       * @param password the password to set.
       */
      private function setServiceCredentials(
         username : String,
         password : String ) : void
      {
         var list : Array = getServices();
         
         for ( var i : uint = 0; i < list.length; i++ )
         {
            var service : AbstractService = list[ i ];
            setCredentialsOnService( service, username, password );
         }
      }
      
      /**
       * Set the user's credentials on all registered HTTP services.
       * @param username the username to set.
       * @param password the password to set.
       */
      private function setHTTPServiceCredentials(
         username : String,
         password : String ) : void
      {
         var list : Array = getHTTPServices();
         
         for ( var i : uint = 0; i < list.length; i++ )
         {
            var service : HTTPService = list[ i ];
            setCredentialsOnHTTPService( service, username, password );
         }
      }
      
      /**
       * Logs the user out of all registered services.
       */
      private function logoutFromServices() : void
      {
          var list : Array = getServices();
         
         for ( var i : uint = 0; i < list.length; i++ )
         {
            var service : AbstractService = list[ i ];
            service.logout();
         }
      }
      
      /**
       * Logs the user out of all registered HTTP services.
       */
      private function logoutFromHTTPServices() : void
      {
          var list : Array = getHTTPServices();
         
         for ( var i : uint = 0; i < list.length; i++ )
         {
            var service : HTTPService = list[ i ];
            service.logout();
         }
      }
      
      /**
       * Sets the credentials on a service. Logout is called first to clear
       * any existing credentials.
       * @param service the service.
       * @param username the username to set.
       * @param password the password to set.
       */
      private function setCredentialsOnService(
          service : AbstractService,
          username : String,
          password : String ) : void
      {
          service.logout();
          service.setCredentials( username, password );
      }
      
      /**
       * Sets the credentials on an HTTP service. Logout is called first to
       * clear any existing credentials.
       * @param service the service.
       * @param username the username to set.
       * @param password the password to set.
       */
      private function setCredentialsOnHTTPService(
          service : HTTPService,
          username : String,
          password : String ) : void
      {
          service.logout();
          service.setCredentials( username, password );
      }
      
      /**
       * Return the configured services.
       * @return the services.
       */
      private function getServices() : Array
      {         
         if ( services == null )
         {
            services = new Array();
            
            var accessors : XMLList = getAccessors();
         
            for ( var i : uint = 0; i < accessors.length(); i++ )
            {
               var name : String = accessors[ i ];
               var obj : Object = this[ name ];
               if ( obj is AbstractService )
               {
                  services.push( obj );
               }
            }
         }
         
         return services;
      }
      
      /**
       * Return the configured HTTP services.
       * @return the HTTP services.
       */
      private function getHTTPServices() : Array
      {         
         if ( httpServices == null )
         {
            httpServices = new Array();
            
            var accessors : XMLList = getAccessors();
         
            for ( var i : uint = 0; i < accessors.length(); i++ )
            {
               var name : String = accessors[ i ];
               var obj : Object = this[ name ];
               if ( obj is HTTPService )
               {
                  httpServices.push( obj );
               }
            }
         }
         
         return httpServices;
      }
      
      /**
       * Return all the accessors on this object.
       * @return this object's accessors.
       */
      private function getAccessors() : XMLList
      {
         var description : XML = describeType( this );
         var accessors : XMLList =
            description.accessor.( @access == "readwrite" ).@name;
            
         return accessors;
      }
   }
}