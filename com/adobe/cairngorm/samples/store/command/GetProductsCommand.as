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
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.samples.store.business.ProductDelegate;
	import com.adobe.cairngorm.samples.store.model.ShopModelLocator;
	import com.adobe.cairngorm.samples.store.util.Comparator;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.events.FaultEvent;
	import mx.controls.Alert;
	import mx.collections.ICollectionView;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.utils.ArrayUtil;
	import com.adobe.cairngorm.samples.store.business.ProductDelegateMock;
	
	/**
	 * @version	$Revision: $
	 */
	public class GetProductsCommand implements ICommand, IResponder
	{
	  	public function GetProductsCommand()
		{	 
		}
	
		public function execute( event : CairngormEvent ): void
		{
			if( ShopModelLocator.getInstance().products == null )
			{
			    //removed in favor of a mockup delegate
			    //var delegate : ProductDelegate = new ProductDelegate( this );
			    var delegate : ProductDelegateMock = new ProductDelegateMock( this );
			    delegate.getProducts();
			}
			else
			{
				Alert.show( "Products already retrieved!" );
				return;
			}
		}
	
		public function result( event : Object ) : void
		{				

			var products : ICollectionView = ICollectionView( event.result );
			var model : ShopModelLocator = ShopModelLocator.getInstance();
			
			// sort the data
			var sort :Sort = new Sort();
		   sort.fields = [ new SortField( "name", true ) ];
		   products.sort = sort;
		   products.refresh();
	   
	   	// set the products on the model
			model.selectedItem = products[ 0 ];
			model.products = products;
			model.workflowState = ShopModelLocator.VIEWING_PRODUCTS_IN_THUMBNAILS;
		}
	
		public function fault( event : Object ) : void
		{
			var faultEvent : FaultEvent = FaultEvent( event );
			Alert.show( "Products could not be retrieved!" );
		}
	}

}