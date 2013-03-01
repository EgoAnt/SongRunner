package com.egoant
{
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import com.egoant.Defender;
	
	import com.egoant.TerrainSegment;
	
	public class Terrain extends Sprite
	{
		
		private var sParent:MovieClip;
		private var myStage:Stage;
		private var alignment:String;
		private var maxheight:Number;
		private var segmentlength:int;
		private var pLevel:Number;
		private var cLevel:Number;
		
		private var segments:Array;
		private var maxsegments:Number;
		private var lastsegment:TerrainSegment;
		private var defender:Defender;
		
		public function Terrain(sParent:MovieClip, myStage:Stage, alignment:String, maxheight:Number, segmentlength:Number, defender:Defender):void
		{
			this.defender = defender;
			this.myStage = myStage;
			this.sParent = sParent;
			this.alignment = alignment;
			this.maxheight = maxheight;
			this.segmentlength = segmentlength;
			
			segments = new Array();
			
			lastsegment = null;
			maxsegments = Math.ceil(myStage.stageWidth / segmentlength) + 1;

			AddSegment(defender);
			
			cLevel = 0;
			pLevel = 0;
			
			this.x = myStage.stageWidth;
			if (this.alignment == "top")
			{
				this.y = 0;
			}else {
				this.y = myStage.stageHeight;
			}
			
		}
		
		public function SetLevel(newlevel:Number):void
		{
			cLevel = Math.max(0.2,newlevel);
		}
		
		public function Update():void
		{
			
			for each (var ts:TerrainSegment in segments)
			{
				if (ts.Alive())
				{
					ts.Update();
				}
			}
			if (lastsegment)
			{
				if (lastsegment.x + lastsegment.width < stage.stageWidth + lastsegment.width)
				{
					 AddSegment(defender);
				}
			}
			
		}
		
		public function AddSegment(defender:Defender):void
		{
			var leftLevel:Number = pLevel * maxheight;
			var rightLevel:Number = cLevel * maxheight;
			
			if (this.alignment == "bottom")
			{
				leftLevel = -leftLevel;
				rightLevel = -rightLevel;
			}
			
			var segmentColour:uint = 0xffffff * leftLevel;
			
			if (segments.length < maxsegments)
			{
				
				var nSegment:TerrainSegment = new TerrainSegment(10,defender);
				if (lastsegment)
				{
					nSegment.init(leftLevel, rightLevel, segmentlength, segmentColour, segmentColour, lastsegment.x + lastsegment.width);
				}else {
					nSegment.init(leftLevel, rightLevel, segmentlength, segmentColour, segmentColour, myStage.stageWidth);
				}
				
				addChild(nSegment);
				segments.push(nSegment);
				lastsegment = nSegment;
				pLevel = cLevel;
			}else {
				//Try to find a dead particle
				for each (var ts:TerrainSegment in segments)
				{
					if (!ts.Alive())
					{
						ts.init(leftLevel, rightLevel, segmentlength, segmentColour, segmentColour, lastsegment.x + lastsegment.width);
						lastsegment = ts;
						pLevel = cLevel;
						break;
					}
				}
			}
		}
		
	}
	
}