package {
	import flash.display.*;
	import flash.errors.*
	import flash.events.*;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.media.Sound;
	import flash.media.SoundMixer;
	import flash.text.*
	import flash.media.SoundChannel;
	import flash.filters.GradientGlowFilter

	import flash.filters.GlowFilter;
	import mx.core.UIComponent;

	[SWF( backgroundColor='0x003366', frameRate='40', width='350', height='200')]
	public class sound_mixer1 extends Sprite
	{
		private var sound:Sound;
		private var isLoaded:Boolean
		private var isLoading:Boolean
		private var frame:int;
		private var mixer:Sprite
		private var play_btn:SimpleButton
		private var stop_btn:SimpleButton
		private var sndChannel:SoundChannel
		private var pos:int;
		private var song:TextField;
		private var mmc:Sprite
		
		public function sound_mixer1()
		{
			super();
			
			var songfmt:TextFormat = new TextFormat();
			songfmt.font = "Verdana";
			songfmt.size = 9;
			songfmt.bold = false;
			songfmt.color = 0xFFFFFF;
			
			var fmt:TextFormat = new TextFormat();
			fmt.font = "Verdana";
			fmt.size = 9;
			fmt.bold = false;
			fmt.color = 0xFFFFFF;
			
			song = new TextField();
			song.x = 30
			song.y = 110
			song.autoSize = "left";
			song.selectable = false
			song.multiline = true;
			song.defaultTextFormat = songfmt;
			
			mmc = new Sprite();

			// play button
			play_btn = new SimpleButton();
			var play_txt:TextField = new TextField();
			play_txt.text = "» play"
			play_txt.x = 25
			play_txt.y = 10
			play_txt.autoSize = "left"
			play_txt.setTextFormat(fmt);
			
			var upSprite:Sprite = new Sprite();
			upSprite.addChild(play_txt);
			play_btn.upState = upSprite;
			play_btn.downState = upSprite;
			play_btn.overState = upSprite;
			play_btn.useHandCursor = true;
			play_btn.hitTestState = upSprite;
			play_btn.name = "playButton";
			
			// stop button
			stop_btn = new SimpleButton();				
			var stop_txt:TextField = new TextField();
			stop_txt.text = "» stop"
			stop_txt.x = 25
			stop_txt.y = 22
			stop_txt.autoSize = "left"
			stop_txt.setTextFormat(fmt);						
			
			var upSprite1:Sprite = new Sprite();
			upSprite1.addChild(stop_txt);
			stop_btn.upState = upSprite1;
			stop_btn.downState = upSprite1;
			stop_btn.overState = upSprite1;
			stop_btn.useHandCursor = true;
			stop_btn.hitTestState = upSprite1;
			stop_btn.name = "stopButton";
			
			// mixer
			mixer = new Sprite();
			
			// sound
			sound = new Sound();
			sound.addEventListener(Event.ID3, onID3);
			sound.addEventListener(Event.COMPLETE, onComplete);
			sound.addEventListener(ProgressEvent.PROGRESS, onProgess);
			
			// events
			play_btn.addEventListener(MouseEvent.CLICK, onClick);
			stop_btn.addEventListener(MouseEvent.CLICK, onClick);
		
			do_properties();	
			do_layout();
		}
		
		private function do_layout():void
		{
			this.addChild(play_btn);
			this.addChild(stop_btn);
			this.addChild(mixer)
			this.addChild(song);
			this.addChild(mmc)
		}
		
		private function do_properties():void
		{
			var bgk:Sprite = new Sprite();
			var xx:uint;
			var a:uint
			var me:MixerElement
			bgk.graphics.lineStyle(.1, 0xFFFFFF, .1);
			bgk.name = "bgk";
			for(var i:uint = 2; i < 26; i++)
			{
				xx = i*5
				for(a = 0; a < 60; a+=2)
				{
					bgk.graphics.moveTo(xx, -a);
					bgk.graphics.lineTo(xx+4, -a);
				}
				me = new MixerElement(4, 1, 0xFFFFFF);
				me.name = "element_"+i.toString()
				me.x = xx
				me.y = -1
				bgk.addChild(me);
			}
			xx = 131
			for(a = 0; a < 60; a+=2)
			{
				bgk.graphics.moveTo(xx, -a);
				bgk.graphics.lineTo(xx+8, -a);
			}
			xx = 140
			for(a = 0; a < 60; a+=2)
			{
				bgk.graphics.moveTo(xx, -a);
				bgk.graphics.lineTo(xx+8, -a);
			}			
			mixer.addChild(bgk)
			mixer.x = 20
			mixer.y = 100		
			
			mmc.x = 250
			mmc.y = 70
		}
		
		private function onClick(evt:MouseEvent):void
		{
			if(evt.target == play_btn)
			{
				if(!isLoaded && !isLoading)
				{
					try {
						//sound.load(new URLRequest("http://localhost:9000/sound_mixer/bin/song.mp3"));
						sound.load(new URLRequest("http://www.sephiroth.it/_temp/flex/sound_mixer2/bin/song.mp3"));
						isLoading = true;
					} catch(e:Error)
					{
						log(e)
					}
				} else {
					if(!isLoading)
					{
						sndChannel = sound.play(pos);
					}
				}
			} else {
				if(!isLoading)
				{
					pos = sndChannel.position;
					sndChannel.stop()
				}
			}
		}
		
		
		private function log(msg:Object):void
		{
		}
		
		
		private function getSongID3():String
		{
			var duration:String = sound_mixer1.calcLength(sound.length)
			return sound.id3.artist + "\n" + sound.id3.track + ". " + sound.id3.songName + " ("+duration+")"+ "\n" + sound.id3.album
		}
		
		private function onID3(evt:Event):void
		{
		}
		
		static public function calcLength(p:Number):String
		{
			var minutes:uint = ((p/1000)/60)%60
			var seconds:uint = (p/1000)-(minutes*60)
			var str_seconds:String = seconds.toString()
			if(str_seconds.length == 1)
			{
				str_seconds = "0"+str_seconds
			}
			return minutes.toString() + ":" + str_seconds;
		}
		
		private function onComplete(evt:Event):void
		{
			isLoading = false
			isLoaded = true;			
			frame = 0;
			sndChannel = sound.play();
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onProgess(evt:ProgressEvent):void
		{
			var perc:uint = Math.round((evt.bytesLoaded/evt.bytesTotal)*100)
			song.text = "loading... " + perc.toString() + "%"
		}
		
		private function onEnterFrame(evt:Event):void
		{
			frame += 1
			var bgk:Sprite = Sprite(mixer.getChildByName("bgk"))
			var element:MixerElement
			var byte:ByteArray = new ByteArray();
			var byte2:ByteArray = new ByteArray();
			var single:Number = 0;
			var single2:Number = 0;
			var first:Boolean = false
			var xx:Number
			var yy:Number
			var sx:int
			var sy:int
			try {
				SoundMixer.computeSpectrum(byte, true, 0);
				SoundMixer.computeSpectrum(byte2, false, 0);

				mixer.graphics.clear();
				mmc.graphics.clear();
				
				mixer.graphics.beginFill(0xFFFFFF, .1);
				mmc.graphics.lineStyle(1, 0xFFFFFF, 1);
				
				for(var i:uint = 0; i < 256; i++)
				{
					single += byte.readFloat()*4;
					if(i%10==0 && i > 0 && i != 10)
					{
						for(var a:uint = 0; a < single; a++)
						{
							mixer.graphics.beginFill(0xFFFFFF, a/8);
							mixer.graphics.drawRect(i/2, -(a*2), 4, .5);
						}
						single = 0;
						element = MixerElement(bgk.getChildByName("element_"+(i/10).toString()))
						element.upTo(-((a*2)+2));
					}
					if(i == 10)
					{
						single = 0
					}
					
					single2 = byte2.readFloat()*10;
					xx = (sndChannel.leftPeak*20+single2) * Math.cos(i/20)
					yy = (sndChannel.leftPeak*20+single2) * Math.sin(i/20)
					if(first==false){
						mmc.graphics.moveTo(xx,yy);
						sx = xx
						sy= yy
						first = true;
					} else {
						mmc.graphics.lineTo(xx,yy);
					}
				}

				 var v:Number = sndChannel.leftPeak*20
				 var colors:Array = [0xFFFFFF, 0xFFFFFF-v, 0x000000+(sndChannel.leftPeak*0xFFFFFF), 0x336699+v, 0xFFFFFF];
				 var alphas:Array = [0, .5, 1, .5, 0];
				 var ratios:Array = [0, 32, 64, 128, 255];
				 var myGGF:GradientGlowFilter = new GradientGlowFilter(0, 0, colors, alphas, ratios, v, v, 1, 1, "full", false);
				 mmc.filters = [myGGF, new GlowFilter(0xFFFFFF, 1, 10, 10, .1, 1)]

				
				for(var a:uint = 0; a < sndChannel.leftPeak*30; a++)
				{
					mixer.graphics.beginFill(0xFFFF00, a/20);
					mixer.graphics.drawRect(131, -(a*2), 8, .5);
				}
				for(var a:uint = 0; a < sndChannel.rightPeak*30; a++)
				{
					mixer.graphics.beginFill(0xFFFF00, a/20);
					mixer.graphics.drawRect(140, -(a*2), 8, .5);
				}				
				mixer.graphics.endFill();
				
				song.text = getSongID3() + "\n" + sound_mixer1.calcLength(sndChannel.position) + " / " + sound_mixer1.calcLength(sound.length)
				
			} catch(e:Error)
			{
				log(e);
			}
		}
		
	}
}
