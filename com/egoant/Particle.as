package com.egoant
{
	import flash.display.Sprite;
	
	public class Particle extends Sprite
	{
		
		private var alive:Boolean;
		private var vx:Number;
		private var vy:Number;
		private var life:Number;

		
		public function Particle():void 
		{

		}
		
		public function init(nx:Number,ny:Number,vx:Number,vy:Number,life:Number):void
		{
			alive = true;
			this.x = nx;
			this.y = ny;
			this.vx = vx;
			this.vy = vy;
			this.life = life;
			this.visible = true;
		}
		
		public function Alive():Boolean
		{
			return alive;
		}
		
		public function Kill():void
		{
			this.alive = false;
			this.visible = false;
		}
		
		public function Update():void
		{
			if (Alive())
			{
				this.x += vx;
				this.y += vy;
				this.alpha = Math.min(1, (life/100));
				life--;
							
				if (life <= 0 || this.x - this.width < 0 || this.y - this.height < 0)
				{
					Kill();
				}
			}
		}
		
	}
	
	
}