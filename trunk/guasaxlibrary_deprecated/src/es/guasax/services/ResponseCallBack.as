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
 
package es.guasax.services
{
	import es.guasax.vo.ActionVO;
	import flash.utils.setTimeout;
	import es.guasax.container.GuasaxContainer;
	import mx.controls.Alert;
	
	public class ResponseCallBack
	{
		private var actionVO : ActionVO;
		
		public var currentResultFuncion : Function;
		public var currentFaultFuncion : Function;
		public var objectResult : Object;
		/**
		 * 
		 */
		public function onResult( event : * = null ) : void {
			currentResultFuncion.apply(objectResult, [event]);
			// comprobamos si tenemos que lanzar el updateView desde aqui,al ser una accion que 
			// ha sido ejecutada indicando que la vista se ejecute despues de que llegue la respuesta del servicio			
			if(actionVO.isExecuteViewUpdateAfterRemoteService()){
				GuasaxContainer.getInstance().executeViewUpdate(actionVO.getViewObjectArray(),			
																actionVO.getViewMethodName(),
																actionVO.getViewParams());
			}
		}
		/**
		 * 
		 */
		public function onFault( event : * = null ) : void {
			currentFaultFuncion.apply(objectResult, [event]);
			// comprobamos si tenemos que lanzar el updateView desde aqui,al ser una accion que 
			// ha sido ejecutada indicando que la vista se ejecute despues de que llegue la respuesta del servicio		
			if(actionVO.isExecuteViewUpdateAfterRemoteService()){
				GuasaxContainer.getInstance().executeViewUpdate(actionVO.getViewObjectArray(),			
																actionVO.getViewMethodName(),
																actionVO.getViewParams());
			}			
			
		} 		
		
		// -----------------------------------
		public function setActionVO(actionVO:ActionVO):void{
			this.actionVO = actionVO;
		}
	}
}