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

@ignore
*/

 
package es.guasax.services
{
	/**
	 * IServiceLocator is the interface for service locators which 
	 * allow service to be located and securitycredentials to be managed.
	 * 
	 */
  /*
   import mx.messaging.Consumer;
   import mx.messaging.MessageAgent;
   import mx.messaging.Producer;
   */
   
   import mx.rpc.AbstractService;
   import mx.rpc.http.HTTPService;
   import mx.rpc.remoting.RemoteObject;
   import mx.rpc.soap.WebService;
   
   public interface IServiceLocator
   {
		/**
		 * Return the RemoteObject for the given service id.
		 * @param serviceId the service id.
		 * @return the RemoteObject.
		 */
      function getRemoteObject( serviceId : String ) : RemoteObject;
      
		/**
		 * Return the HTTPService for the given service id.
		 * @param serviceId the service id.
		 * @return the RemoteObject.
		 */
      function getHTTPService( serviceId : String ) : HTTPService;
      
		/**
		 * Return the WebService for the given service id.
		 * @param serviceId the service id.
		 * @return the RemoteObject.
		 */
      function getWebService( destinationId : String ) : WebService;
      
		/**
		 * Return the message Consumer for the given service id.
		 * @param serviceId the service id.
		 * @return the RemoteObject.
		 */
     // function getConsumer( destinationId : String ) : Consumer;
      
		/**
		 * Return the message Produce for the given service id.
		 * @param serviceId the service id.
		 * @return the RemoteObject.
		 */
     // function getProducer( destinationId : String ) : Producer;
      
		/**
		 * Set the credentials for all registered services. Note that services
		 * that use a proxy or a third-party adapter to a remote endpoint will
		 * need to setRemoteCredentials instead.
		 * @param username the username to set.
		 * @param password the password to set.
		 */
      function setCredentials( username : String,   password : String ) : void;
      
		/**
		 * Logs the user out of all registered services.
		 */
      function logout() : void;
   }
}