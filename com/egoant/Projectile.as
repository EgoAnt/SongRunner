package com.egoant
{
	import flash.display.Sprite;
	
	public class Projectile extends Sprite
	{
		
		private var vx:Number;
		private var vy:Number;
		
		public function Projectile(velocityX:Number,velocityY:Number) {
			vx = velocityX;
			vy = velocityY;
			this.addChild(new PointDot());
		}
		
		public function Update() {
			this.x += vx;
			this.y += vy;
		}
	}
}
		