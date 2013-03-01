package com.egoant
{
	import flash.display.Sprite;
	
	public class DefenderTurret extends Sprite
	{
	
		private var _angle:Number;
		private var _rad:Number;
		private const ang2rad:Number = Math.PI / 180;
		private const rad2ang:Number = 180 / Math.PI
		
		public function DefenderTurret():void 
		{
			_angle = 0;
		}
		
		public function Update(mx:Number, my:Number):void 
		{
			_rad = Math.atan2(-mx, my);
			_angle = Math.max( -45, Math.min(45, (360 * _rad / (2 * Math.PI)) + 90));
			if (_angle < 0) {
				_angle = 360 + _angle;
			}
			this.rotation = _angle;
		}
		
		public function get angle():Number
		{
			return _angle;
		}
		
		public function get rad():Number
		{
			return _angle * ang2rad;
		}
		
	}
	
}