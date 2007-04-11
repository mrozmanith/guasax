package es.guasax.samples.calculator.exceptions
{
	public class CalculatorError extends Error
	{
		public function CalculatorError(message:String, errorID:int){
			super(message, errorID);
		}
	}
}