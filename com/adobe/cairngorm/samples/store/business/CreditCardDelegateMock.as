package com.adobe.cairngorm.samples.store.business
{
	import mx.rpc.IResponder;
	
	public class CreditCardDelegateMock extends BaseBusinessDelegateMock
	{
		public function CreditCardDelegateMock(responder : IResponder){
			super(responder);
		}
		
	   public function validateCreditCard( cardholderName : String, cardNumber : String ) : void
	   {  
	   		setResults(true); //we just want it to work :)
	   }
	  				
	}
}