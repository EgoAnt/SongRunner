package
{
	import com.egoant.Particle;
	import com.egoant.Projectile;
	import flash.automation.AutomationAction;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import com.egoant.Releaser;
	import com.egoant.Terrain;
	import com.egoant.Defender;
	
	public class SongRunner extends MovieClip
	{
		var url:String;
		var request:URLRequest;
		var s:Sound;
		var song:SoundChannel;
		var ba:ByteArray;
		var time:Timer;
		var compute:Timer;
		
		var playerShip:Defender;
		
		private const pointVariance:Number = 500;
		private const pointTop:Number = 10;
		private const levelAdjust:Number = 1.25;
		private const sinAdjust:Number = 0.5;
		
		private var terrainBottom:Terrain;
		private var terrainTop:Terrain;
		private var sinwave:Array;
		private var sinpoint:Number;
		private var bkgLevels:Array;
		private var projectiles:Array;
		private var blams:Array;
		private var reds:Array;
		private var blues:Array;
		private var difficulty:Number;
		
		private var score:Number = 0;
		
		private var energy:Number = 50;
		private var maxenergy:Number = 100;
		private var barDmg:Sprite;
		private var barLife:Sprite;
		
		private var songChoices:Array = new Array('DST-4Tran.mp3','DST-AngryMod.mp3','DST-CreepAlong.mp3','DST-Darko.mp3');
		private var songNames:Array = new Array('4Tran by DST','AngryMod by DST','CreepAlong by DST','Darko by DST');
		private var gameHolder:MovieClip;
		private var menuHolder:MovieClip;
		private var endHolder:MovieClip;
		private var redCycle:Number;
		private var blueCycle:Number;
		private var redSpawn:Number;
		private var blueSpawn:Number;
		private var scoreDisplay:MovieClip;
		private var endTimer:Timer;
		private var endStuff:MovieClip;
		
		public function SongRunner():void 
		{
			
			difficulty = 0;
			
			projectiles = new Array();
			bkgLevels = new Array();
			blams = new Array();
			reds = new Array();
			blues = new Array();
			
			redCycle = 20;
			blueCycle = 200;
			
			redSpawn = 0;
			blueSpawn = 0;
			
			gameHolder = new MovieClip();
			menuHolder = new MovieClip();
			endHolder = new MovieClip();
			
			endStuff = new EndScreenStuff();
			endStuff.x = 90;
			endStuff.y = 65;
			endStuff.PlayAgainButton.addEventListener(MouseEvent.CLICK, showMainScreen);
			endHolder.addChild(endStuff);
			
			for (var sng:Number = 0; sng < songChoices.length; sng++) {
				var sslct:MovieClip = new SongSelector();
				sslct.name = 'songNumber' + sng;
				sslct.x = 40 + (20 * sng);
				sslct.y = 50 + (50 * sng);
				sslct.SongTitle.text = songNames[sng];
				sslct.addEventListener(MouseEvent.CLICK, songClickHander);
				menuHolder.addChild(sslct);
			}
			
			gameHolder.graphics.lineStyle(0, 0, 0);
			gameHolder.graphics.beginFill(0x000000);
			gameHolder.graphics.drawRect(0, 0, 550, 300);
			gameHolder.graphics.endFill();
			
			gameHolder.visible = false;
			menuHolder.visible = true;
			endHolder.visible = false;
			
			this.addChild(gameHolder);
			this.addChild(menuHolder);
			this.addChild(endHolder);
			
			var segmentWidth:Number = stage.stageWidth / 64;
			
			for (var bl:Number = 0; bl < 64; bl++) {
				var lvClip:MovieClip = new MovieClip();
				lvClip.x = bl * segmentWidth;
				lvClip.y = stage.stageHeight;
				lvClip.graphics.lineStyle(0,0,0);
				lvClip.graphics.beginFill(0x005959);
				lvClip.graphics.drawRect(0, 0, segmentWidth, 0 - (stage.stageHeight / 2));
				lvClip.graphics.endFill();
				bkgLevels.push(lvClip);
				gameHolder.addChild(lvClip);
			}
			
			playerShip = new Defender(4,this);
			playerShip.x = 30;
			playerShip.y = 150;
			gameHolder.addChild(playerShip);
			
			terrainBottom = new Terrain(gameHolder, stage, "bottom", 200, 10, playerShip);
			terrainBottom.x = 0;
			terrainBottom.y = stage.stageHeight;
			
			terrainTop = new Terrain(gameHolder, stage, "top", 90, 15, playerShip);
			terrainTop.x = 0;
			terrainTop.y = 0;
			
			compute = new Timer(40);
			compute.addEventListener(TimerEvent.TIMER, computeHandler);
			
			time = new Timer(20);
			time.addEventListener(TimerEvent.TIMER, timerHandler);
			
			gameHolder.addChild(terrainBottom);
			gameHolder.addChild(terrainTop);
			
			barDmg = new Damage();
			barDmg.x = 550;
			barDmg.y = 300;
			barDmg.scaleX = 0.5;
			gameHolder.addChild(barDmg);
			
			barLife = new Health();
			barLife.x = 0;
			barLife.y = 300;
			barLife.scaleX = 0.5;
			gameHolder.addChild(barLife);
			
			scoreDisplay = new ScoreHolder();
			scoreDisplay.x = 0;
			scoreDisplay.y = 6;
			gameHolder.addChild(scoreDisplay);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, OnKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, OnKeyUp);
			gameHolder.addEventListener(MouseEvent.CLICK, captureClick);
			
			endTimer = new Timer(3000, 1);
			endTimer.addEventListener(TimerEvent.TIMER, showEndScreen);
			
			//startLevel(rnd(0, 3));
			
		}
		
		private function showEndScreen(e:TimerEvent):void 
		{
			energy = 50;
			endTimer.stop();
			endStuff.EndScore.text = score;
			
			gameHolder.visible = false;
			menuHolder.visible = false;
			endHolder.visible = true;
			song.stop();
			
			time.stop();
			compute.stop();
			s.close();
			
			playerShip.visible = true;
			for each (var p:Projectile in projectiles) {
				gameHolder.removeChild(p);
			}
			projectiles = new Array();
			
			for each (var blu:Sprite in blues) {
				gameHolder.removeChild(blu);
			}
			blues = new Array();
			
			for each (var red:Sprite in reds) {
				gameHolder.removeChild(red);
			}
			reds = new Array();
			
			score = 0;
			
		}
		
		private function showMainScreen(e:MouseEvent):void 
		{
			gameHolder.visible = false;
			menuHolder.visible = true;
			endHolder.visible = false;
		}
		
		private function songClickHander(e:MouseEvent):void 
		{
			var caller:String = MovieClip(e.currentTarget).name;
			var lv:Number = Number(caller.replace('songNumber', ''));
			startLevel(lv);
		}
		
		private function startLevel(songNumber:Number) {
			url = "Music/" + songChoices[songNumber];
			request = new URLRequest(url);
			s = new Sound();
			ba = new ByteArray();
			
			sinpoint = 0;
			sinwave = new Array();
			for (var sw:int = 0; sw < 360; sw++)
			{
				sinwave.push(Math.sin(sw) * sinAdjust);
			}
			
			s.addEventListener(Event.COMPLETE, completeHandler);
			s.load(request);
		}
		
		private function rnd(min:Number, max:Number) {
			return Math.floor(Math.random() * (max - min)) + min;
		}
		
		public function Explode() {
			energy = 0;
			var blamCount:Number = Math.floor(Math.random() * 20) + 6;
			if(playerShip.visible){
				for (var e:Number = 0; e < blamCount; e++) {
					var b:Particle = new Particle();
					b.init(playerShip.x, playerShip.y, rnd( -5, 5), rnd( -5, 5), 40);
					b.addChild(new RedBlaster());
					this.addChild(b);
					blams.push(b);
				}
			}
			endTimer.start();
		}
		
		private function captureClick(e:MouseEvent):void 
		{
			
			if(playerShip.visible){
				var vxyAngle:Number = playerShip.turretAngleRad;
				
				if (vxyAngle < 0) {
					vxyAngle = 360 + vxyAngle;
				}
				
				var scX:Number = Math.cos(vxyAngle);
				var scY:Number = Math.sin(vxyAngle);
				
				var projectileSpeed:Number = 10;
				var vx:Number = projectileSpeed * scX;
				var vy:Number = projectileSpeed * scY;
				
				trace('Angle: ' + vxyAngle);
				
				var projectile:Sprite = new Projectile(vx,vy);
				projectile.x = playerShip.x + 48;
				projectile.y = playerShip.y + 15;
				projectile.rotation = playerShip.turretAngle;
				projectiles.push(projectile);
				gameHolder.addChild(projectile);
				
				energy--;
			}
			
		}
		
		private function OnKeyDown(evt:KeyboardEvent):void
		{
			//trace("key" + evt.keyCode);
			if(evt.keyCode == Keyboard.RIGHT || evt.keyCode == 68)
			{
				playerShip.SetVelX(playerShip.moveSpeed);
			}
			else if(evt.keyCode == Keyboard.LEFT || evt.keyCode == 65)
			{
				playerShip.SetVelX(-playerShip.moveSpeed);
			}
			else if(evt.keyCode == Keyboard.UP || evt.keyCode == 87)
			{
				playerShip.SetVelY(-playerShip.moveSpeed);
			}
			else if(evt.keyCode == Keyboard.DOWN || evt.keyCode == 83)
			{
				playerShip.SetVelY(playerShip.moveSpeed);
			}
		}
		
		private function OnKeyUp(evt:KeyboardEvent):void
		{
			if(evt.keyCode == Keyboard.RIGHT || evt.keyCode == 68)
			{
				playerShip.SetVelX(0);
			}
			else if(evt.keyCode == Keyboard.LEFT || evt.keyCode == 65)
			{
				playerShip.SetVelX(0);
			}
			else if(evt.keyCode == Keyboard.UP || evt.keyCode == 87)
			{
				playerShip.SetVelY(0);
			}
			else if(evt.keyCode == Keyboard.DOWN || evt.keyCode == 83)
			{
				playerShip.SetVelY(0);
			}
		}
		
		function completeHandler(event:Event):void {
			
			playerShip.x = 30;
			playerShip.y = 150;
			playerShip.visible = true;
			
			song = s.play(0, 100);
			time.start();
			compute.start();
			gameHolder.visible = true;
			menuHolder.visible = false;
			endHolder.visible = false;
		}
		
		function soundCompleteHandler(event:Event):void {
			time.stop();
		}
		
		function computeHandler(evt:TimerEvent):void
		{
			var w:uint = 4;
			var avgLevel:Number = 0;
			var avgDiv:Number = 0;
			var iMin:Number = 0;
			var iMax:Number = 250;
			var i:int;	
			
			var cspec:Array = new Array();
			
			for (i = 0; i < 64; i++) {
				bkgLevels[i].height = (ba.readFloat() * 300) + 30;
			}
			
			for (i=0; i<256; i+=w) {
				cspec.push(ba.readFloat() * levelAdjust);
			}
			
			sinpoint += 0.1;
			if (sinpoint >= 360)
			{
				sinpoint = 0;
			}
			
			var pt:int = Math.floor(sinpoint);
			
			var terrainLevel1:Number = avg(cspec.slice(10, 30)) + sinwave[pt];
			var terrainLevel2:Number = avg(cspec.slice(30, 100)) - sinwave[pt];
			
			terrainBottom.SetLevel(terrainLevel1);
			terrainTop.SetLevel(terrainLevel2);
		}
		
		function avg(inVals:Array):Number
		{
			var i:Number = 0;
			var avgNum:Number = 0;
			var outNum:Number = 0;
			
			for each(var v:Number in inVals)
			{
				i++;
				avgNum += v;
			}
			if (i > 0)
			{
				outNum = avgNum / i;
			}
			return outNum;
		}
		
		private function setHealthBars():void 
		{
			var healthPct:Number = energy / maxenergy;
			barDmg.scaleX = 1 - healthPct;
			barLife.scaleX = healthPct;
		}
		
		function timerHandler(event:TimerEvent):void {
			
			
			if (energy <= 0) {
				playerShip.Kill();
			}else {
				score++;
			}
			setHealthBars();
			SoundMixer.computeSpectrum(ba, true);
			
			terrainBottom.Update();
			terrainTop.Update();
			playerShip.Update();
			
			redSpawn++;
			blueSpawn++;
			
			if (redSpawn > redCycle) {
				difficulty += 0.25;
				redSpawn = rnd(0,difficulty);
				var red:Sprite = new RedBlaster();
				red.x = 560;
				red.y = rnd(50, 250);
				gameHolder.addChild(red);
				reds.push(red);
			}
			
			if (blueSpawn > blueCycle) {
				blueSpawn = 0;
				var blue:Sprite = new EnergyStar();
				blue.x = 560;
				blue.y = rnd(50, 250);
				gameHolder.addChild(blue);
				blues.push(blue);
			}
			
			var rnew:Array = new Array();
			for each (var rd:Sprite in reds) 
			{
				for each(var shot:Projectile in projectiles) {
					if (shot.hitTestObject(rd)) {
						rd.visible = false;
						score += 100;
					}
				}
				rd.x -= 6;
				if (rd.x < 400 && rd.x > -12) {
					if (rd.hitTestObject(playerShip)) {
						rd.visible = false;
						energy -= 10;
					}
				}else if (rd.x < -12) {
					rd.visible = false;
				}
				
				if (rd.visible) {
					rnew.push(rd);
				}
			}
			reds = rnew;
			
			var bnew:Array = new Array();
			for each (var blu:Sprite in blues) 
			{
				blu.x -= 8;
				if (blu.x < 400 && blu.x > -12) {
					if (blu.hitTestObject(playerShip)) {
						blu.visible = false;
						energy = Math.min(100, energy + 30);
						score += 500;
					}
				}else if (blu.x < -12) {
					blu.visible = false;
				}
				
				if (blu.visible) {
					bnew.push(blu);
				}
			}
			blues = bnew;
			
			
			for each (var b:Particle in blams) {
				b.Update();
			}
			
			var pjs:Array = new Array();
			for each (var p:Projectile in projectiles) {
				if (p.x > 560) {
					gameHolder.removeChild(p);
				}else {
					pjs.push(p);
					p.Update();
				}
			}
			projectiles = pjs;
			
			scoreDisplay.MyScore.text = score;
			
		}
	
	}
	
	
}