package org.conferance.client 
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import mx.containers.Canvas;
	import mx.containers.Panel;
	import mx.controls.Alert;
	import mx.controls.Image;
	import mx.controls.Label;
	import mx.controls.VideoDisplay;
	import mx.core.DragSource;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	import mx.events.ResizeEvent;
	import mx.managers.DragManager;
	
	import org.conferance.container.ContainerArea;
	  
	public class Client
	{
		private var _netConnection:NetConnection;
		private var _toStreamName:String;
		private var _netStream:NetStream;
		private var _video:Video;
		private var _width:int;
		private var _height:int;
		private var _x:int;
		private var _y:int;
		private var _lblUserName:Label;
		private var _container:Canvas;
		private var _topContainer:Canvas;
		private var _closeImage:Image;
		private var _conferanceClass:Conferance;
		private var _videoDisp:VideoDisplay; ;
		private var _controlPanel:Canvas;
		private var _micOnOffImage:Image;
		private var _camOnOffImage:Image;
		private var _exitImage:Image;
		public var xOff:Number;
		public var yOff:Number;
		private var _micStatu:Boolean = true;
		private var _camStatu:Boolean = true;
		private var _containerArea:ContainerArea;
		public function Client(netConnection:NetConnection,toStreamName:String,
							   width:int,height:int,x:int,y:int,conferanceClass:Conferance,containerArea:ContainerArea)
		{
			_netConnection = netConnection;
			_toStreamName = toStreamName;
			_width = width;
			_height = height+20;
			_x = x;
			_y = y+20;  
			_conferanceClass = conferanceClass;
			_containerArea = containerArea;
			init(); 
		}
		private function playStream():void{ 
			_netStream = new NetStream(_netConnection);
			_netStream.play(_toStreamName);
			_video = new Video();
			_video.width = _width;
			_video.height = _height; 
			_video.attachNetStream(_netStream); 
			_videoDisp.addChildAt(_video,0);
			_videoDisp.addEventListener(ResizeEvent.RESIZE,function():void{
				_video.width = _videoDisp.width;
				_video.height = _videoDisp.height;
				_controlPanel.y = _videoDisp.height - 20;
			});
			_netStream.receiveAudio(true);
		}
		public function getVideoObject():VideoDisplay{ return _videoDisp; } 
		private function init():void{ 
			_videoDisp = new VideoDisplay();
			_videoDisp.width = _width;
			_videoDisp.height = _height;  
			
			_controlPanel = new Canvas();
			_controlPanel.x = 0;
			_controlPanel.y = _videoDisp.height - 20;
			_controlPanel.depth = 1000;
			_controlPanel.width = 150;
			_controlPanel.height = 20;
			_videoDisp.addChild(_controlPanel);
			
			_micOnOffImage = new Image();
			_micOnOffImage.left = 0;
			_micOnOffImage.y = 0;
			_micOnOffImage.source = "assets/micon.png";
			_micOnOffImage.addEventListener(MouseEvent.CLICK,function():void{ 
				if(_micStatu) {
					_netStream.receiveAudio(false); 
					_micStatu = false;
					_micOnOffImage.source = "assets/micoff.png";
				}else {
					_netStream.receiveAudio(true); 
					_micStatu = true;
					_micOnOffImage.source = "assets/micon.png";
				}
			});
			_controlPanel.addChild(_micOnOffImage);
			
			_camOnOffImage = new Image();
			_camOnOffImage.left = 20;
			_camOnOffImage.y = 0;
			_camOnOffImage.source = "assets/webcam.png";
			_camOnOffImage.addEventListener(MouseEvent.CLICK,function():void{
				if(_camStatu) {
					_netStream.receiveVideo(false); 
					_camStatu = false;
					_camOnOffImage.source = "assets/webcamoff.png";
				}else {
					_netStream.receiveVideo(true); 
					_camStatu = true;
					_camOnOffImage.source = "assets/webcam.png";
				}
			});
			_controlPanel.addChildAt(_camOnOffImage,1);
			
			_exitImage = new Image();
			_exitImage.left = 40;
			_exitImage.y = 0;
			_exitImage.source = "assets/webcam.png";
			_exitImage.addEventListener(MouseEvent.CLICK,function():void{
				 
			});
			_controlPanel.addChildAt(_exitImage,1);
				
			playStream();
		}
		public function getStreamName():String{
			return _toStreamName;
		}
		public function getVideo():Video{
			return _video;
		}
	}
}
 