package com.egoant
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import com.egoant.DefenderTurret;
	
	public class Defender extends Sprite
	{
		
		public var moveSpeed:Number;
		private var velX:Number;
		private var velY:Number;
		
		private const txOffset:Number = 48;
		private const tyOffset:Number = 16;
		
		private var myTurret:DefenderTurret;
		private var sParent:SongRunner;
		
		public function Defender(moveSpeed:Number,sParent:SongRunner):void 
		{
			this.sParent = sParent;
			this.moveSpeed = moveSpeed;			
			velX = 0;
			velY = 0;
			
			myTurret = new DefenderTurret();
			myTurret.x = txOffset;
			myTurret.y = tyOffset;
			addChild(myTurret);
			
		}
		
		public function Update():void 
		{
			this.x += velX;
			this.y += velY;
			myTurret.Update(this.mouseX - txOffset, this.mouseY - tyOffset);
		}
		
		public function SetVelX(nvx:Number):void
		{
			velX = nvx;
		}
		
		public function SetVelY(nvy:Number):void
		{
			velY = nvy;
		}
		
		public function Kill()
		{
			sParent.Explode();
			this.visible = false;
		}
		
		public function get turretAngleRad():Number {
			return myTurret.rad;
		}
		
		public function get turretAngle():Number {
			return myTurret.angle;
		}
		
	}
	
}