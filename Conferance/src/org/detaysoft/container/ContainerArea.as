package org.detaysoft.container
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.containers.Canvas;
	import mx.containers.Panel;
	import mx.controls.VideoDisplay;
	import mx.core.DragSource;
	import mx.events.DragEvent;
	import mx.events.FlexEvent;
	import mx.managers.DragManager;
	import mx.managers.ISystemManager;
	
	import org.detaysoft.client.Client;
	import org.detaysoft.panel.DragPanel;
	import org.detaysoft.panel.RubberBandComp;

	public class ContainerArea
	{
		private var _canvas:Canvas;
		private var _canvasWidth:int = 900;
		private var _canvasHeight:int = 500;
		private var _xOff:Number;
		private var _yOff:Number;
		public var rubberBandComp:RubberBandComp;
		protected var resizingPanel:Panel; 
		protected var initX:Number;
		protected var initY:Number; 
		private var _sysManager:ISystemManager;
		public static const RESIZE_CLICK:String = "resizeClick";
		private var _clients:ArrayCollection = new ArrayCollection();
		public function ContainerArea(obj:ISystemManager,stage:Stage)
		{
			stage.addEventListener(RESIZE_CLICK, resizeHandler);
			_sysManager = obj;
			init(); 
		}
		private function init():void{
			createContainerArea();
		} 
		private function createContainerArea():void{
			_canvas = new Canvas();  
			_canvas.width = _canvasWidth;
			_canvas.height = _canvasHeight; 
			_canvas.setStyle("borderStyle","solid");
			_canvas.setStyle("backgroundColor","#DDDDDD");
			
			_canvas.addEventListener(DragEvent.DRAG_ENTER,function(event:DragEvent):void{
				DragManager.acceptDragDrop(Canvas(event.target));
			});
			_canvas.addEventListener(DragEvent.DRAG_DROP,function(event:DragEvent):void{
				var tempX:int = event.currentTarget.mouseX - _xOff;
				event.dragInitiator.x = tempX; 
				var tempY:int = event.currentTarget.mouseY - _yOff;
				event.dragInitiator.y = tempY; 
				_canvas.setChildIndex(Panel(event.dragInitiator), _canvas.numChildren-1);		
			});
		 
			rubberBandComp = new RubberBandComp();
			rubberBandComp.x = 0;
			rubberBandComp.y = 0;
			rubberBandComp.width = 150;
			rubberBandComp.height = 150;
			rubberBandComp.visible = false;
			/*rubberBandComp.setStyle("borderStyle","solid");
			rubberBandComp.setStyle("backgroundColor","#DDDDDD");*/
			_canvas.addChild(rubberBandComp);
		}
		public function getContainer():Canvas{
			return _canvas;
		}
		
		public function createPanel(client:Client):void{ 
			var panel:DragPanel = new DragPanel();
			panel.title = client.getStreamName();
			panel.height = 205;
			panel.width = 155;
			panel.addElementAt(client.getVideoObject(),0);
			panel.addEventListener(FlexEvent.CREATION_COMPLETE,myPanelCCHandler);
			_canvas.addChild(panel);
			_clients.addItem({toStreamName:client.getStreamName(),pane:panel}); 
		} 
		protected function resizeHandler(event:MouseEvent):void
		{
			resizingPanel = Panel(event.target);
			initX = event.localX;
			initY = event.localY;
			
			rubberBandComp.x = event.target.x;
			rubberBandComp.y = event.target.y;
			rubberBandComp.height = event.target.height;
			rubberBandComp.width = event.target.width;
			
			_canvas.setChildIndex(rubberBandComp, _canvas.numChildren-1);
			rubberBandComp.visible=true;
			
			_sysManager.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler, true);
			_sysManager.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, true);
		}
		private function myPanelCCHandler(event:Event):void 
		{
			event.currentTarget.myTitleBar.addEventListener(MouseEvent.MOUSE_DOWN, tbMouseMoveHandler);
		}
		private function tbMouseMoveHandler(event:MouseEvent):void 
		{
			var dragInitiator:Panel=Panel(event.currentTarget.parent);
			var ds:DragSource = new DragSource();
			ds.addData(event.currentTarget.parent, 'panel'); 
			
			_xOff = event.currentTarget.mouseX;
			_yOff = event.currentTarget.mouseY;
			
			DragManager.doDrag(dragInitiator, ds, event);                    
		}
		public function mouseMoveHandler(event:MouseEvent):void
		{
			event.stopImmediatePropagation();		
			
			rubberBandComp.height = rubberBandComp.height + event.stageY - initY;  
			rubberBandComp.width = rubberBandComp.width + event.stageX - initX;
			
			initX = event.stageX;
			initY = event.stageY;						
		}
		
		public function mouseUpHandler(event:MouseEvent):void
		{
		 	var videoDisp:VideoDisplay = resizingPanel.getElementAt(0) as VideoDisplay;
			event.stopImmediatePropagation();		
			
			if (rubberBandComp.height <= 50)
			{
				resizingPanel.height = 50;    
			}
			else
			{
				resizingPanel.height = rubberBandComp.height;   
				videoDisp.height = rubberBandComp.height - 33;
			}				
			
			if (rubberBandComp.width <= 150)
			{
				resizingPanel.width = 150;  
			}
			else
			{
				resizingPanel.width = rubberBandComp.width;	  
				videoDisp.width = rubberBandComp.width - 2;
			}				
			
			
			_canvas.setChildIndex(resizingPanel, _canvas.numChildren-1);
			
			rubberBandComp.x = 0;
			rubberBandComp.y = 0;
			rubberBandComp.height = 0;
			rubberBandComp.width = 0;
			rubberBandComp.visible = false; 					
			_sysManager.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler, true);
			_sysManager.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, true	);
			_sysManager
		}
		public function deletePanel(toStremName:String):void{
			for (var i:int = 0; i < _clients.length; i++){
				if(_clients[i].toStreamName == toStremName){
					
				}
			}
			
		}
	}
}