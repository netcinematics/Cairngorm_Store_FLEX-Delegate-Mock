package com.adobe.cairngorm.samples.store.business
{
	import mx.rpc.events.FaultEvent;
	import mx.rpc.IResponder;
	import flash.events.Event;
	import mx.rpc.events.ResultEvent;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	/**
	 *  This class is a base class for all business delegate mockups
	 *  extend this class to get asynchronous respond.
	 *  You must call the super(responder) in your business delegate constructor
	 *  You can set the latency time by call this.Latency=<milliseconds>
	 *  To activate your mockup you will need to change the relevant command and
	 *  call the xxxDelegateMock.
	 */
	public class BaseBusinessDelegateMock
	{
		public function BaseBusinessDelegateMock(responder : IResponder){
			this.responder = responder;
		}
		
		protected function setResults(results:Object):void{
			this.results = results;
			if(latency>0){
				this.timer = new Timer(latency);
				timer.addEventListener("timer",invokeResponder);			
				timer.start();
			}else{
				invokeResponder(null);
			}
		}
		
		protected function set Latency(time:Number):void{
			this.latency = time;
		}
		
		private function invokeResponder(evt:TimerEvent):void{
			
			try
			{
				if(evt!=null) timer.stop();
				var ev:ResultEvent = new ResultEvent("MockUp",false,true,results);
				responder.result(ev);
			}catch(er:Error){
				responder.fault(new FaultEvent("MockUp"));
			}			
		}
		
		private var responder : IResponder;
		//using a timer to simulate the latency during the client-server roundtrip
		private var timer:Timer;
		//the latency value can be set by the specific Business Delegates
		private var latency:Number = 0;  //the default value is no latency
		//holding the results in a global is a little awkward...
		private var results:Object;
	}
}