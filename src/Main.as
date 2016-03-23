package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.LocalConnection;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.system.Security;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.ui.ContextMenu;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.utils.ByteArray;
	
	
	public class Main extends Sprite
	{
		[Embed(source = "FBbd10.png")]
		private var theClass:Class;
		[Embed(source = "1.png")]
		private var theClass1:Class;
		public function Main()
		{
			var s:String;
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
			var label:TextField = new TextField();
			var s:String = "1";
			label.defaultTextFormat = new TextFormat("", 
				
				16, 0xffff00, true, null, null, null, null, null, null, null, null, 
				
				3);
			label.autoSize = TextFieldAutoSize.LEFT;
			label.height = 21;
			var color:uint = 16776960
			
			var ss:String = "<font color='#" + 	
				color.toString(16) + "'>" + s+ "</font>";
			label.htmlText = ss;
			//			this.addChild(label);
			
			var infoLabel:Sprite = new Sprite();
			var bitmapData:BitmapData = new BitmapData( 
				
				label.width, label.height, true, 0x0 );
			infoLabel.graphics.clear();
			infoLabel.graphics.beginBitmapFill( 
				
				bitmapData );
			infoLabel.graphics.drawRect( 0, 0, 
				
				label.width, label.height );
			infoLabel.graphics.endFill();
			//			
			
			infoLabel.mouseChildren = false;
			//			
			
			infoLabel.mouseEnabled = false;
			
			addChild(infoLabel);
			
			var ctx:ContextMenu = new ContextMenu();
			ctx.hideBuiltInItems();
			this.contextMenu = ctx;
			
			
			_urls = new URLStream();
			_data = new ByteArray();
			_loader = new Loader();
			
			_urls.addEventListener
				
				(Event.COMPLETE,onComplete);
			_urls.addEventListener
				
				(ProgressEvent.PROGRESS,onPro);
			_loader.y = 50;
			//			this.addChild
			
			(_loader);
//			_loader.load(new URLRequest("1.png"));
			
			_mouse = new theClass();
			//			Mouse.hide();
			
			addEventListener
			
			(Event.ENTER_FRAME,onEnterFrame);		
			_loader.contentLoaderInfo.addEventListener
				
				(Event.COMPLETE,onComplete1);
			onComplete1();
			
			
		}
		private var _newB:BitmapData;
		protected function onComplete1(event:Event=null):void
		{
			var s:DisplayObject = new theClass1();
			_newB = new BitmapData(s.width,s.height,true,0xffffff);
			_newB.draw(s);
			var bitmap:Bitmap = new Bitmap(_newB);
			_spr = new Sprite();
			addChild(_spr);
			_spr.addChild(bitmap)
			_spr.buttonMode = true
			_spr.addEventListener
				
				(MouseEvent.ROLL_OUT,onMouseOut);
			_spr.addEventListener
				
				(MouseEvent.ROLL_OVER,onMouseOver);
			_spr.y = 100;
			//			_loader.unload();
		}
		private var _spr:Sprite;
		private var _mouseIn:Boolean=false;
		protected function onMouseOut(event:Event):void
		{
			_mousePoints.push({x:stage.mouseX,y:stage.mouseY});
			
			CalculatePoint();
			drawSprite();
			_mouseIn = false;
			
			_mousePoints.length = 0;
		}
		private const LEFT:int = 0;
		private const UP:int = 1;
		private const RIGHT:int = 2;
		private const DOWN:int = 3;
		private var _dirStart:int;
		private var _dirEnd:int;
		private function CalculatePoint():void
		{
//			var sp:Point = new Point(_mousePoints[1].x-_mousePoints[0].x,
//				_mousePoints[1].y-_mousePoints[0].y);
//			
//			var n:int = _mousePoints.length-1;
//			var ep:Point = new Point(_mousePoints[n].x-_mousePoints[n-1].x,
//				_mousePoints[n].y-_mousePoints[n-1].y);
			
			
			
			var p:Point = linePoint(new Point(_mousePoints[0].x,_mousePoints[0].y),
				new Point(_mousePoints[1].x,_mousePoints[1].y),true);
			_mousePoints.unshift({x:p.x,y:p.y});
			
			var n:int = _mousePoints.length-1;
			p = linePoint(new Point(_mousePoints[n].x,_mousePoints[n-1].y),
				new Point(_mousePoints[n].x,_mousePoints[n-1].y));
			
			_mousePoints.push({x:p.x,y:p.y});
		}
		private function linePoint(p1:Point,p2:Point,flag:Boolean=false):Point
		{
			var sp:Point = new Point(p2.x-p1.x,
				p2.y-p1.y);
			var aa:Object = p1;
			var bb:Object = p2;
			var ps:Point;
			var pe:Point;
			var a1:Number ;
			var a2:Number ;
			var dir:int ;
			if(sp.x >= 0 && sp.y>= 0)
			{
				if(sp.x == 0)
				{//上
					dir = UP;
					ps = new Point(_spr.x,_spr.y);
					pe = new Point(_spr.x+_spr.width,_spr.y);
				}else if(sp.y == 0)
				{//左
					dir = LEFT;
					ps = new Point(_spr.x,_spr.y);
					pe = new Point(_spr.x,_spr.y+_spr.height);
				}
				else
				{
					a1 = Math.abs((aa.x-_spr.x)/(aa.y - _spr.y));
					a2 = Math.abs(sp.x/sp.y);
					
					if(a1 > a2)
					{//左
						dir = LEFT;
						ps = new Point(_spr.x,_spr.y);
						pe = new Point(_spr.x,_spr.y+_spr.height);
					}
					else
					{//上
						dir = UP;
						ps = new Point(_spr.x,_spr.y);
						pe = new Point(_spr.x+_spr.width,_spr.y);
					}
				}
				
			}
			else if(sp.x <= 0 && sp.y >= 0)
			{
				if(sp.x == 0)
				{//上
					dir = UP;
					ps = new Point(_spr.x,_spr.y);
					pe = new Point(_spr.x+_spr.width,_spr.y);
				}else if(sp.y == 0)
				{//右
					dir = RIGHT;
					ps = new Point(_spr.x+_spr.width,_spr.y);
					pe = new Point(_spr.x+_spr.width,_spr.y+_spr.height);
				}
				else
				{
					a1 = Math.abs((aa.x-_spr.x)/(aa.y - _spr.y));
					a2 = Math.abs(sp.x/sp.y);
					
					if(a1 > a2)
					{//右
						dir = RIGHT;
						ps = new Point(_spr.x+_spr.width,_spr.y);
						pe = new Point(_spr.x+_spr.width,_spr.y+_spr.height);
					}
					else
					{//上
						dir = UP;
						ps = new Point(_spr.x,_spr.y);
						pe = new Point(_spr.x+_spr.width,_spr.y);
					}
				}
			}else if(sp.x >= 0 && sp.y < 0)
			{
				if(sp.x == 0)
				{//下
					dir = DOWN;
					ps = new Point(_spr.x,_spr.y+_spr.height);
					pe = new Point(_spr.x+_spr.width,_spr.y+_spr.height);
				}else if(sp.y == 0)
				{//左
					dir = LEFT;
					ps = new Point(_spr.x,_spr.y);
					pe = new Point(_spr.x,_spr.y+_spr.height);
				}
				else
				{
					a1 = Math.abs((aa.x-_spr.x)/(aa.y - _spr.y));
					a2 = Math.abs(sp.x/sp.y);
					
					if(a1 < a2)
					{//左
						dir = LEFT;
						ps = new Point(_spr.x,_spr.y);
						pe = new Point(_spr.x,_spr.y+_spr.height);
					}
					else
					{//下
						dir = DOWN;
						ps = new Point(_spr.x,_spr.y+_spr.height);
						pe = new Point(_spr.x+_spr.width,_spr.y+_spr.height);
					}
				}
				
			}
			else if(sp.x <= 0 && sp.y < 0)
			{
				if(sp.x == 0)
				{//下
					dir = DOWN;
					ps = new Point(_spr.x,_spr.y+_spr.height);
					pe = new Point(_spr.x+_spr.width,_spr.y+_spr.height);
				}else if(sp.y == 0)
				{//右
					dir = RIGHT;
					ps = new Point(_spr.x+_spr.width,_spr.y);
					pe = new Point(_spr.x+_spr.width,_spr.y+_spr.height);
				}
				else
				{
					a1 = Math.abs((aa.x-_spr.x)/(aa.y - _spr.y));
					a2 = Math.abs(sp.x/sp.y);
					
					if(a1 < a2)
					{//右
						dir = RIGHT;
						ps = new Point(_spr.x+_spr.width,_spr.y);
						pe = new Point(_spr.x+_spr.width,_spr.y+_spr.height);
					}
					else
					{//下
						dir = DOWN;
						ps = new Point(_spr.x,_spr.y+_spr.height);
						pe = new Point(_spr.x+_spr.width,_spr.y+_spr.height);
					}
				}
			}
			if(flag)
				_dirStart = dir;
			else
				_dirEnd = dir;
			var p:Point = getCrossPoint(new Point(_mousePoints[0].x,_mousePoints[0].y),
				ps,
				pe,
				new Point(_mousePoints[1].x,_mousePoints[1].y));
			return p;
		}
		//判断第一个点 与 第四个点所连直线 与 第2个点和第3个点 所连直线的交点 是否在 第2个和第3个点的线段上
		private function getCrossPoint(point1:Point, point2:Point, point3:Point, point4:Point):Point
		{
			var pD_x:Number = point1.x
			var pD_y:Number = point1.y
			var pA_x:Number = point2.x
			var pA_y:Number = point2.y
			
			var pC_x:Number = point3.x
			var pC_y:Number = point3.y
			var pB_x:Number = point4.x
			var pB_y:Number = point4.y
			
			var k_y:Number = (pB_x * pC_y * pD_y - pD_x * pB_y * pC_y - pA_y * pB_x * pD_y + pD_x * pB_y * pA_y + pC_x * pA_y * pD_y - pA_x * pC_y * pD_y - pC_x * pB_y * pA_y + pA_x * pB_y * pC_y) /
				(pD_y * pC_x - pA_x * pD_y - pB_y * pC_x + pA_x * pB_y + pB_x * pC_y - pD_x * pC_y - pA_y * pB_x + pA_y * pD_x);
			
			var k_x:Number = (pD_y * (pC_x - pA_x) * (pB_x - pD_x) - pA_y * (pC_x - pA_x) * (pB_x - pD_x) + pA_x * (pC_y - pA_y) * (pB_x - pD_x) + pD_x * (pD_y - pB_y) * (pC_x - pA_x)) /
				((pC_y - pA_y) * (pB_x - pD_x) + (pD_y - pB_y) * (pC_x - pA_x));
			
			trace(k_x+","+k_y)
			return new Point(k_x ,k_y);
		}
		protected function onMouseMove(event:Event):void
		{
			
		}
		
		protected function onMouseOver(event:Event):void
		{
			_mousePoints = [];
			
			_mousePoints.push({x:stage.mouseX,y:stage.mouseY});
			_mouseIn = true;	
		}
		private var _mouse:DisplayObject;
		private var _lastPoint:Point = new Point();
		private var bmp:BitmapData;
		protected function onEnterFrame(event:Event):void
		{
			if(!stage) return;
			var px:int = stage.mouseX;
			var py:int = stage.mouseY;
			_mouse.x = px;
			_mouse.y = py;
			if(px != _lastPoint.x || py != _lastPoint.y)
			{
				
				if(!bmp)
				{
					bmp = new BitmapData
						
						(_mouse.width,_mouse.height,true,0xffffff);
					bmp.draw(_mouse);
					//	addChild(_mouse);
				}
				var arr:Array = agvDis
					
					(px,py,_lastPoint);
				var b1:int;
				for each(var p:Point in arr)
				{
					var ls:mouseSprite;
					if(++_cur > _max-1)
					{
						_cur = 0;
						ls = _mouseSprites
							
							[_max-1]
					}
					else
						ls = _mouseSprites
							
							[_cur-1];
					if(ls)
						b1 = ls.frame+1;
					else
						b1 = 2;
					var bitmap:mouseSprite = 
						
						_mouseSprites[_cur] ;
					if(bitmap==null)
					{
						_mouseSprites[_cur] = 
							
							new mouseSprite(bmp,b1);
						//	this.addChildAt(_mouseSprites[_cur],this.numChildren-1);
					}
					else
					{
						bitmap.bitmapData = 
							
							null;
						bitmap.bitmapData = 
							
							bmp;
						bitmap.ResetFrame
							
							(b1);
					}
					if(bitmap)
					{
						bitmap.x = p.x ;
						bitmap.y = p.y ;
					}
				}
				
			}
			_lastPoint.x = px;
			_lastPoint.y = py;
			for each(var b:mouseSprite in _mouseSprites)
			{
				if(b.bitmapData)
				{
					b.subFrame();
				}
			}
			
			if(_mouseIn)
			{
				_mousePoints.push({x:px,y:py});
			}
		}
		public function cutPoly(sourceBitmapData:BitmapData, maskShape:Shape,bounds:Rectangle):BitmapData {
			var sourceBitmapContainer:Sprite = new Sprite();
			var sourceBitmap:Bitmap = new Bitmap(sourceBitmapData);
			sourceBitmapContainer.addChild(sourceBitmap);
			sourceBitmapContainer.addChild(maskShape);
			maskShape.x = bounds.x;
			maskShape.y = bounds.y;
			
			sourceBitmap.blendMode = BlendMode.LAYER;
			maskShape.blendMode = BlendMode.ERASE;
//			sourceBitmap.mask = maskShape;
			var finalBitmapData:BitmapData = new BitmapData(bounds.width, bounds.height, true, 0x00ffffff);
			finalBitmapData.draw(sourceBitmapContainer);
			
			var newbmd:Bitmap = new Bitmap(finalBitmapData);
			addChild(newbmd);
			newbmd.x += 10;
			maskShape.blendMode = BlendMode.LAYER;
			sourceBitmap.mask = maskShape;
			finalBitmapData = new BitmapData(bounds.width, bounds.height, true, 0x00ffffff);
			finalBitmapData.draw(sourceBitmapContainer);
			newbmd = new Bitmap(finalBitmapData);
			addChild(newbmd);
			newbmd.x -=10;
			return finalBitmapData;
		}
		private function drawSprite():void
		{
//			var bmp:Bitmap = _loader.content as Bitmap
			var shape:Shape = new Shape();
			shape.graphics.lineStyle(1, 0x00ff00, 1);
			shape.graphics.beginFill(0xff0000);
			var p1:Object;
			var p2:Object;
			if((_dirStart == UP && _dirEnd == LEFT) ||( _dirStart == LEFT && _dirEnd == UP))
			{
				p1 = {x:_spr.x,y:_spr.y};
			}
			else if((_dirStart == UP && _dirEnd == RIGHT) ||( _dirStart == RIGHT && _dirEnd == UP))
			{
				p1 = {x:_spr.x+_spr.width,y:_spr.y};
			}
			else if((_dirStart == DOWN && _dirEnd == LEFT) ||( _dirStart == LEFT && _dirEnd == DOWN))
			{
				p1 = {x:_spr.x,y:_spr.y+_spr.height};
			}
			else if((_dirStart == DOWN && _dirEnd == RIGHT) ||( _dirStart == RIGHT && _dirEnd == DOWN))
			{
				p1 = {x:_spr.x+_spr.width,y:_spr.y+_spr.height};
			}
			if(Math.abs(_dirEnd - _dirStart) == 2)
			{
				if(_dirStart == UP)
				{
					p1 = {x:_spr.x,y:_spr.y};
					p2 = {x:_spr.x,y:_spr.y+_spr.height};
				}
				else if(_dirStart == DOWN)
				{
					p2 = {x:_spr.x,y:_spr.y};
					p1 = {x:_spr.x,y:_spr.y+_spr.height};
				}
				else if(_dirStart == LEFT)
				{
					p1 = {x:_spr.x,y:_spr.y};
					p2 = {x:_spr.x+_spr.width,y:_spr.y};
				}
				else if(_dirStart == RIGHT)
				{
					p2 = {x:_spr.x,y:_spr.y};
					p1 = {x:_spr.x+_spr.width,y:_spr.y};
				}
			}
			if(_dirEnd == _dirStart)
				p1 =  {x:_mousePoints[0].x,y:_mousePoints[0].y};
			
			if(p1)
				shape.graphics.moveTo(p1.x,p1.y);
			
			for(var i:int=0;i<_mousePoints.length;++i)
			{
				var obj:Object = _mousePoints[i-1];
				obj = _mousePoints[i];
				shape.graphics.lineTo(obj.x,obj.y);
//				shape.graphics.moveTo(obj.x,obj.y);
			}
			if(p2)
			shape.graphics.lineTo( p2.x,p2.y);
			if(p1)
				shape.graphics.lineTo( p1.x,p1.y);

			shape.graphics.endFill();
//			addChild(shape);
			
			var bd:BitmapData = cutPoly(_newB,shape,new Rectangle(-_spr.x,-_spr.y,_newB.width,_newB.height));
//			var newbmd:Bitmap = new Bitmap(bd);
//			addChild(newbmd);
			_spr.visible = false;
		}
		private var _mousePoints:Array ;
		
		private function agvDis(x1:int,y1:int,p1:Point):Array
		{
			var x2:int = -p1.x + x1;
			var y2:int = -p1.y + y1;
			var dis:int = Math.sqrt(x2*x2+y2*y2);
			var a:int = dis/50+1;
			var arr:Array = new Array();
			for(var i:int=0;i<a;++i)
			{
				var ax:int = x2/a *i;
				var ay:int = y2/a *i
				arr.push(new Point(p1.x+ax,p1.y+ay));
			}
			return arr;
		}
		private var _mouseSprites:Array = [];
		private var _max:int = 10;
		private var _cur:int = 0;
		
		protected function onComplete(event:Event):void
		{
			_urls.close();
			_urls.removeEventListener
				
				(Event.COMPLETE,onComplete);
			_urls.removeEventListener
				
				(ProgressEvent.PROGRESS,onPro);
		}
		
		protected function onPro(event:ProgressEvent):void
		{
			var old:int = _data.length;
			_urls.readBytes(_data,_data.length);
			if(old < _data.length) 
			{
				_loader.loadBytes(_data);
			}
		}
		public function setColor(color:int):void
		{
			var shape:Shape = new Shape();
			shape.graphics.beginFill( color );
			shape.graphics.drawCircle( 100, 100, 40 );
			this.addChild(shape);
		}
		private var _data:ByteArray;
		private var _urls:URLStream;
		private var _loader:Loader;
	}
}
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;

class mouseSprite extends Bitmap
{
	public function mouseSprite(bmd:BitmapData,frame:int)
	{
		super(bmd);
		_frame = frame;
	}
	public function get frame():int
	{
		if(_frame==0)
			return 2;
		else return _frame;
	}
	private var _frame:int;
	public function ResetFrame(frame:int):void
	{
		_frame = frame;
	}
	public function subFrame():void
	{
		_frame--;
		if(_frame <=0)
		{
			this.bitmapData = null;
		}
	}
}
class sphere extends Sprite
{
	public function sphere()
	{
		
	}
}