package
{
	import flash.display.Sprite;
	import flash.utils.setTimeout;
	import flash.utils.clearTimeout;
	import mx.effects.Tween;
	import mx.effects.easing.Linear;
	import mx.events.TweenEvent;

	public class MixerElement extends Sprite
	{
		private var curr:int
		private var id:uint
		public  var tw:Tween
		
		public function MixerElement(w:uint, h:uint, c:uint)
		{
			super();
			this.graphics.beginFill(c, 1);
			this.graphics.drawRect(0,0,w,h);
			this.graphics.endFill();
			tw = new Tween(this, 0, -1)
		}
		
		public function upTo(value:int):void
		{
			if(value < this.y)
			{
				this.y = value;
				tw.pause()
				tw = new Tween(this, this.y, -1, 1000, 1)
				tw.addEventListener(TweenEvent.TWEEN_UPDATE, onUpdate);
				tw.addEventListener(TweenEvent.TWEEN_END, onEnd);
				//tw.setTweenHandlers(this.onUpdate, this.onEnd)
			}
		}
		

		public function onUpdate(val:TweenEvent):void
		{
			this.y = Number(val.value)
		}
		
		public function onEnd(val:TweenEvent):void
		{
		}
		
		public function onTweenUpdate(val:Object):void
		{
			
		}
		
		public function onTweenEnd(val:Object):void
		{
			
		}		
	}
}