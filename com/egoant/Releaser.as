package com.egoant
{
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	import com.egoant.PointDot;
	import com.egoant.Particles;
	
	public class Releaser extends MovieClip
	{
		
		private var releaseInterval:Timer;
		private var releaseSpeed:Number;
		private var sParent:MovieClip;
		private var healthPower:Particles;
		private var myStage:Stage;

		public function Releaser(sParent:MovieClip, myStage:Stage):void
		{
			this.myStage = myStage;
			this.sParent = sParent;
			this.x = 500;
			releaseSpeed = 250;
			releaseInterval = new Timer(releaseSpeed);
			releaseInterval.addEventListener(TimerEvent.TIMER, spawn);
			releaseInterval.start();
			sParent.addChild(this);
			healthPower = new Particles(sParent, 100);
		}
		
		public function SetLevel(setY:Number):void
		{
			this.y = setY;
		}
		
		private function spawn(evt:TimerEvent):void
		{
			//var nDot:PointDot = new PointDot(this.x, this.y, sParent);
			healthPower.AddParticle(this.x, this.y, -3, 0.2, 100);
		}
		
		public function Update():void
		{
			healthPower.Update();
		}
		
		
	}
}