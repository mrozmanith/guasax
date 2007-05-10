package es.guasax.samples.calculator.view
{
    import flash.events.Event;
    import es.guasax.samples.calculator.vo.OperationVO;
   
    
    public class CalculadoraEvent extends flash.events.Event 
    {

        public var operationVO : OperationVO; 

        public function CalculadoraEvent(_operationVO:OperationVO) 
        {
            super("calculator");
            operationVO = _operationVO;
        }

    }
}