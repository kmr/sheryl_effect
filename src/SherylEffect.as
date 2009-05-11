package {
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import org.papervision3d.core.math.NumberUV;
	import org.papervision3d.materials.BitmapFileMaterial;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.primitives.Plane;
	import org.papervision3d.view.BasicView;

    [SWF(width="800", height="500",backgroundColor="0x000000")]
	public class SherylEffect extends BasicView {
		private static var NUM_FACES_W:uint = 10;
		private static var NUM_FACES_H:uint = 10;
		private var basePlane:DisplayObject3D;
		private var texture:BitmapFileMaterial;
		private var sizeW:Number;
		private var sizeH:Number;
		private var planes:Array;
		
		public function SherylEffect() {
			super(0,0,true,true,"Target");
			init();
		}
		
		private function init():void {
			stage.frameRate = 60;
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.MEDIUM;
			camera.x = 0;
			camera.y = 0;
			camera.z = -1200;
			camera.fov = 35;
			
			this.basePlane = new DisplayObject3D();
			scene.addChild(this.basePlane);
			createFaces();
			startRendering();
		}
		
		override protected function onRenderTick(event:Event=null):void {
			this.basePlane.yaw(1);
			if (this.planes.length == NUM_FACES_W * NUM_FACES_H) {
				movePlanes();
			}
			super.onRenderTick(event);
		}
		
		private function movePlanes():void {
			for (var i:uint = 0; i < NUM_FACES_H; i++) {
				for (var j:uint = 0; j < NUM_FACES_W; j++) {
					var plane:Plane = this.planes[i * NUM_FACES_W + j];
					plane.x = this.sizeW * j + j * .2 * Math.abs(this.basePlane.rotationY);
					plane.y = this.sizeH * i + i * .2 * Math.abs(this.basePlane.rotationY) - texture.bitmap.height / 2;
				}
			}
		}
		
		private function createFaces():void {
			this.texture = new BitmapFileMaterial("../assets/sheryl.jpg");
			texture.doubleSided = true;
			this.planes = new Array();
			BitmapFileMaterial.callback = onLoadTexture;
		}
		
		private function onLoadTexture():void {			
			this.sizeW = texture.bitmap.width / NUM_FACES_W;
			this.sizeH = texture.bitmap.height / NUM_FACES_H;
			for (var i:uint = 0; i < NUM_FACES_H; i++) {
				for (var j:uint = 0; j < NUM_FACES_W; j++) {
					var plane:Plane = new Plane(texture, this.sizeW, this.sizeH);
					this.basePlane.addChild(plane);
					plane.x = this.sizeW * j;
					plane.y = this.sizeH * i - texture.bitmap.height / 2;
					plane.z = 0;
					plane.geometry.faces[0].uv = [new NumberUV(sizeW * j / texture.bitmap.width,
					                                           sizeH * i / texture.bitmap.height),
					                              new NumberUV(sizeW * (j + 1) / texture.bitmap.width,
					                                           sizeH * i / texture.bitmap.height),
					                              new NumberUV(sizeW * j / texture.bitmap.width,
					                                           sizeH * (i + 1) / texture.bitmap.height)];
					plane.geometry.faces[1].uv = [new NumberUV(sizeW * (j + 1) / texture.bitmap.width,
					                                           sizeH * (i + 1) / texture.bitmap.height),
					                              new NumberUV(sizeW * j / texture.bitmap.width,
					                                           sizeH * (i + 1) / texture.bitmap.height),
					                              new NumberUV(sizeW * (j + 1) / texture.bitmap.width,
					                                           sizeH * i / texture.bitmap.height)];
					this.planes.push(plane);
				}
			}			
		}
	}
}