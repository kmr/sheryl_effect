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
	public class SherylEffect2 extends BasicView {
		private static var NUM_FACES_W:uint = 10;
		private static var NUM_FACES_H:uint = 10;
		private static var YAW_DEGREE:Number = 3;
		private var basePlane:DisplayObject3D;
		private var texture:BitmapFileMaterial;
		private var sizeW:Number;
		private var sizeH:Number;
		private var planes:Array;
		private var frameCounter:uint = 0;
		
		public function SherylEffect2() {
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
			camera.z = 0;
			camera.fov = 35;
			
			this.basePlane = new DisplayObject3D();
			scene.addChild(this.basePlane);
			createFaces();
			startRendering();
		}
		
		override protected function onRenderTick(event:Event=null):void {
			if (this.planes.length == NUM_FACES_W * NUM_FACES_H && this.basePlane.localRotationY > -180) {
				rotateBase();
				movePlanes();
			} else {
				if (this.planes[NUM_FACES_W - 1].x > this.sizeW * (NUM_FACES_W - 1)) {
					movePlanes();
				}
				pushPlane();
			}
			
			if (camera.z > -1000) {
				camera.z -= 3.5 * YAW_DEGREE;
			}
			super.onRenderTick(event);
		}
		
		private function pushPlane():void {
			for (var i:uint = 0; i < NUM_FACES_H; i++) {
				for (var j:uint = 0; j < NUM_FACES_W; j++) {
					var plane:Plane = this.planes[i * NUM_FACES_W + j];
					if (this.frameCounter * YAW_DEGREE > i * j + 20 && plane.z > -50) {
						plane.z -= 5 * YAW_DEGREE;
					}
				}
			}
			this.frameCounter += 1;
		}
		
		private function rotateBase():void {
			this.basePlane.yaw(-YAW_DEGREE);
		}
		
		private function movePlanes():void {
			for (var i:uint = 0; i < NUM_FACES_H; i++) {
				for (var j:uint = 0; j < NUM_FACES_W; j++) {
					var plane:Plane = this.planes[i * NUM_FACES_W + j];
					plane.x -= .2 * j * YAW_DEGREE;
					plane.y -= .2 * i * YAW_DEGREE;
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
					plane.x = (this.sizeW + 50) * j;
					plane.y = (this.sizeH + 50) * i - texture.bitmap.height / 2;
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
			setToStartingLine();
		}
		
		private function setToStartingLine():void {
			this.basePlane.rotationY = 180;
			this.basePlane.yaw(-1);
		}
	}
}