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
package com.adobe.cairngorm.samples.store.command
{
	import mx.rpc.IResponder;
	import com.adobe.cairngorm.commands.SequenceCommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.view.ViewHelper;
	import com.adobe.cairngorm.view.ViewLocator;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.controls.Alert;
	
	import com.adobe.cairngorm.samples.store.business.CreditCardDelegate;
	import com.adobe.cairngorm.samples.store.control.ShopController;
	import com.adobe.cairngorm.samples.store.event.PurchaseCompleteEvent;
	import com.adobe.cairngorm.samples.store.event.ValidateCreditCardEvent;
	import com.adobe.cairngorm.samples.store.model.ShopModelLocator;
	import com.adobe.cairngorm.samples.store.business.CreditCardDelegateMock;
	
	
	/**
	 * @version $Revision: $
	 */
	public class ValidateCreditCardCommand extends SequenceCommand implements IResponder
	{
	 	public function ValidateCreditCardCommand()
   	{
   	}
	   
		public override function execute( event : CairngormEvent ) : void
   	{
		//var delegate : CreditCardDelegate = new CreditCardDelegate( this );	   
		var delegate : CreditCardDelegateMock = new CreditCardDelegateMock( this );	   
   		var cardEvent : ValidateCreditCardEvent = ValidateCreditCardEvent( event );
	   
      	var cardholderName : String = cardEvent.cardholderName;
      	var cardNumber : String = cardEvent.cardNumber;
	   
      	delegate.validateCreditCard( cardholderName, cardNumber );
   	}	  
	
   	public function result( event : Object ) : void
   	{      	
      	var validationPassed : Boolean = ( event.result == true );
         ShopModelLocator.getInstance().creditCardInvalid = false;
      	if ( validationPassed )
      	{      		
	        	executeNextCommand();
      	}
      	else
      	{        	
   	     	ShopModelLocator.getInstance().creditCardInvalid = true;
      	}
		}
	   
	 
	
   	public function fault( event : Object ) : void
   	{
   	}
	
		   
   	public override function executeNextCommand() : void
		{
	   		
	   	// Create the "next" event.
			var purchaseEvent : PurchaseCompleteEvent = new PurchaseCompleteEvent();
	      			
      	purchaseEvent.generalInformation = ShopModelLocator.getInstance().generalInfo;
      		
      	purchaseEvent.paymentInformation = ShopModelLocator.getInstance().paymentInfo;

      	purchaseEvent.shoppingCart = ShopModelLocator.getInstance().shoppingCart;
      	
      	// Dispatch the event.
      	nextEvent = purchaseEvent;
      	
      	super.executeNextCommand();
			
			// Clear the event.
			nextEvent = null;
		}
	}
}