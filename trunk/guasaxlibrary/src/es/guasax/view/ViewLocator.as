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

package es.guasax.view
{
   import flash.utils.Dictionary;
   import es.guasax.messages.GuasaxError;
   import es.guasax.messages.GuasaxMessageCodes;
   import mx.core.IFlexDisplayObject;
   /**
    * 
    */
   public class ViewLocator
   {
      private static var viewLocator : ViewLocator;
      private        var viewObjects : Dictionary;      
      
      /**
       * Singleton
       */
      public static function getInstance() : ViewLocator
      {
         if ( viewLocator == null ){
            viewLocator = new ViewLocator();
         }
         return viewLocator;
      }

      /**
       *
       */
      public function ViewLocator()
      {
         if ( ViewLocator.viewLocator != null )
         {
            throw new GuasaxError(GuasaxMessageCodes.SINGLETON_EXCEPTION, "ViewLocator");
         }
         viewObjects = new Dictionary();      
      }

      /**
       * Register views objects by name 
       * @param viewName   Name for the view object
       * @param viewObject View object for register 
       */
      public function register( viewName : String, viewObject : Object ) : void
      {
         if ( viewObjects[ viewName ] != undefined  )
         {
            throw new GuasaxError(
               GuasaxMessageCodes.VIEW_ALREADY_REGISTERED_EXCEPTION, viewName );
         }
   
         viewObjects[ viewName ] = viewObject;
      }
      
      /**
       * Unregisters a viewObject using name.
       *
       * @param viewName The canonical name for the view to be removed
       */
      public function unregister( viewName : String ) : void
      {
         if ( viewObjects[ viewName ] == undefined  )
         {
            throw new GuasaxError(
               GuasaxMessageCodes.VIEW_NOT_FOUND_EXCEPTION, viewName );
         }
         delete viewObjects[ viewName ];
      }
      
      /**
       * Return the view object by name
       * @param viewName Name for the view to be returned
       */
      public function getViewObject( viewName : String ) : Object
      {
         if ( viewObjects[ viewName ] == undefined )
         {
            throw new GuasaxError(
               GuasaxMessageCodes.VIEW_NOT_FOUND_EXCEPTION, viewName );
         }
         
         return viewObjects[ viewName ];
      }
   }
}