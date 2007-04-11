package es.guasax.samples.calculator.bo
{
	import mx.controls.Alert;
	import es.guasax.samples.calculator.model.ModelLocator;
	import es.guasax.samples.calculator.exceptions.CalculatorError;
	import flash.utils.setTimeout;
	import es.guasax.container.GuasaxContainer;
	import es.guasax.samples.calculator.vo.OperationVO;
	import conf.Constants;
	
	public class CalculatorBO 
	{
		public var model:ModelLocator = ModelLocator.getInstance();

		public function calculate(operationVO:OperationVO):OperationVO {
			try{
				var resultado: Number;
				if(operationVO.operador == "+"){
					resultado = operationVO.operando1 + operationVO.operando2;
				}else if(operationVO.operador == "-"){				
					resultado = operationVO.operando1 - operationVO.operando2;
				}else if(operationVO.operador == "*"){
					resultado = operationVO.operando1 * operationVO.operando2;
				}else if(operationVO.operador == "/"){
					resultado = operationVO.operando1 / operationVO.operando2;
				} 
				
				operationVO.result = resultado;
				model.operationVO = operationVO;
			}catch(error:CalculatorError){
				Alert.show("Se ha producido un error:"+error.message);
			}
			return operationVO;
		}
	}
}