package com.egoant
{
	
	import com.egoant.Particle;
	import flash.display.MovieClip;
	
	public class Particles
	{
		
		private var maxParticles:Number;
		private var pTracker:Array;
		private var sParent:MovieClip;
		
		public function Particles(sParent:MovieClip, maxParticles:Number):void 
		{
			this.maxParticles = maxParticles;
			this.sParent = sParent;
			pTracker = new Array();
		}
		
		public function AddParticle(nx:Number,ny:Number,vx:Number,vy:Number,life:Number):Boolean
		{
			var isAdded:Boolean = false;
			if (pTracker.length < maxParticles)
			{
				var nParticle:Particle = new Particle();
				nParticle.init(nx, ny, vx, vy, life);
				sParent.addChild(nParticle);
				pTracker.push(nParticle);
				isAdded = true;
			}else {
				//Try to find a dead particle
				for each (var p:Particle in pTracker)
				{
					if (!p.Alive())
					{
						p.init(nx, ny, vx, vy, life);
						isAdded = true;
						break;
					}
				}
			}
			return isAdded;
		}
		
		public function Update():void 
		{
			for each (var p:Particle in pTracker)
			{
				p.Update();
			}
		}
		
		
	}
	
	
	
}