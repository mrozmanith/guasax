package es.guasax.samples.calculator.model
{
	import es.guasax.samples.calculator.vo.OperationVO;
	
	
	public class ModelLocator
	{
      private static var modelLocator : ModelLocator;
      
      public static function getInstance() : ModelLocator 
      {
      	if ( modelLocator == null )
      	{
      		modelLocator = new ModelLocator();
      	}
      	return modelLocator;
      }
      
      //Constructor should be private 
      public function ModelLocator() 
      {	
      	if(modelLocator != null){
         	throw new Error( "Only one ModelLocator instance should be instantiated" );	
        }
      }		
      // ---------------------------------------------------------------
      // ------------------ model variables  ---------------------------
      // ---------------------------------------------------------------
      [Bindable]
  	  public var operationVO  :OperationVO;
  	  
  	  
  		  
	}
}