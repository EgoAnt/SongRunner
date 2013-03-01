package com.egoant
{
	import flash.display.Sprite;
	import com.egoant.Defender;
	
	public class TerrainSegment extends Sprite
	{
		
		private var movespeed:Number;
		private var alive:Boolean;
		private var defender:Defender;
		
		public function TerrainSegment(movespeed:Number, defender:Defender):void 
		{
			this.defender = defender;
			this.movespeed = movespeed;
			alive = false;
		}
		
		public function init(leftY:Number, rightY:Number, segmentwidth:Number, linecolor:uint, fillcolour:uint, xPos:Number):void
		{
			alive = true;
			this.visible = true;
			this.x = xPos;
			this.graphics.clear();
			this.graphics.lineStyle(0.05, linecolor, 1);
			this.graphics.beginFill(fillcolour, 1);
			this.graphics.moveTo(0, 0);
			this.graphics.lineTo(0, leftY);
			this.graphics.lineTo(segmentwidth, rightY);
			this.graphics.lineTo(segmentwidth, 0);
			this.graphics.lineTo(0, 0);
			this.graphics.endFill();
		}
		
		public function Kill():void
		{
			alive = false;
			this.visible = false;
		}
		
		public function Alive():Boolean
		{
			return alive;
		}
		
		public function Update():void 
		{
			if (alive)
			{
				this.x = Math.floor(this.x - movespeed);
				if (this.x < 0 - this.width)
				{
					Kill();
				}
				if (this.hitTestObject(defender))
				{
					defender.Kill();
				}
			}
		}
		
	}
	
}