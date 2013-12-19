package
{
    import ckCube;
    import flash.display.Sprite;
    import flash.events.*;
    import flash.display.*;
    import flash.net.URLRequest;
    import flash.net.navigateToURL;


    [SWF(width="640", height="480", backgroundColor="0xffffff", frameRate="60")]

    public class test extends Sprite
    {
	private var myCube:ckCube;
	private var done_init:Boolean = false;
	private var doRotate:Boolean = true;

	// Input Settings
	public var cx:int = 0; // Cube X coordinate
	public var cy:int = 0; // Cube Y coordinate
      	public var sw:int = 640; // Scene Width
      	public var sh:int = 480; // Scene Height
      	public var fov:int = 30; // Field of View (in degrees)
      	public var myheight:int = 88; // Video Height
      	public var mywidth:int = 88;  // Video Width
      	public var bh:int = 5; // height spacing between cubes
      	public var bw:int = 5; // width spacing
      	public var bd:int = 5; // depth spacing
      	public var myrow:int = 4; // row # of cubes
      	public var mycol:int = 4; // columns # of cubes
      	public var mydep:int = 4; // depth # of cubes
      	public var playsecs:int = 3; // seconds to play video loop
      	public var cq:int = 1;       // Cube quality, takes a lot of resources > 1, but looks nicer
	public var rx:Number = 0;
	public var ry:Number = .80;
	public var rz:Number = 0;
	public var pl:String = "3dthumbs.xml";
	public var clickURL:String = "player.php?m=1&p=";

	public var rbxcube:Boolean = false;

     	public function test():void
	{
		super();
                for (var fv:Object in root.loaderInfo.parameters) {
       			switch(fv) {
               			case 'cx': // Cube X Coordinate Position
               				cx = root.loaderInfo.parameters[fv];
               				break;
               			case 'cy': //  Cube Y Coordinate Position
               				cy = root.loaderInfo.parameters[fv];
               				break;
               			case 'pl': // XML Video file
               				pl = root.loaderInfo.parameters[fv];
               				break;
               			case 'url': // clickable URL
               				clickURL = root.loaderInfo.parameters[fv];
               				break;
               			case 'w': // Video/Box width
               				mywidth = root.loaderInfo.parameters[fv];
               				break;
               			case 'h': // Video/Box height
               				myheight = root.loaderInfo.parameters[fv];
               				break;
               			case 'r': // boxes rows
               				myrow = root.loaderInfo.parameters[fv];
               				break;
               			case 'c': // boxes columns
               				mycol = root.loaderInfo.parameters[fv];
               				break;
               			case 'd': // boxes deep
               				mydep = root.loaderInfo.parameters[fv];
               				break;
               			case 'ps': // Seconds before loop
               				playsecs = root.loaderInfo.parameters[fv];
               				break;
               			case 'sh': // stage height
               				sh = root.loaderInfo.parameters[fv];
               				break;
               			case 'sw': // stage width
               				sw = root.loaderInfo.parameters[fv];
               				break;
               			case 'rx': // X rotation per frame
               				rx = root.loaderInfo.parameters[fv];
               				break;
               			case 'ry': // Y rotation per frame
               				ry = root.loaderInfo.parameters[fv];
               				break;
               			case 'rz': // Z rotation per frame
               				rz = root.loaderInfo.parameters[fv];
               				break;
               			case 'bh': // Buffer height between cubes
               				bh = root.loaderInfo.parameters[fv];
               				break;
               			case 'bw': // Buffer width between cubes
               				bw = root.loaderInfo.parameters[fv];
               				break;
               			case 'bd': // Buffer depth between cubes
               				bd = root.loaderInfo.parameters[fv];
               				break;
               			case 'fov': // How close cube is
               				fov = root.loaderInfo.parameters[fv];
               				break;
               			case 'cq': // Cube Quality
               				cq = root.loaderInfo.parameters[fv];
               				break;
               			case 'rbxcube': // Rubix Cube Effect
               				rbxcube = root.loaderInfo.parameters[fv];
               				break;
       			}
       	 	}

		stage.scaleMode = StageScaleMode.NO_SCALE;
	 	stage.align = StageAlign.TOP_LEFT;

		/**
		* Create ckCube Class Instance
		*/
		myCube = new ckCube();

		/**
		* Configure Cube
		*/
		myCube.x = cx;
		myCube.y = cy;
		myCube.mywidth = mywidth;
		myCube.myheight = myheight;
		myCube.bw = bw;
		myCube.bh = bh;
		myCube.bd = bd;
		myCube.sw = sw;
		myCube.sh = sh;
		myCube.myrow = myrow;
		myCube.mycol = mycol;
		myCube.mydep = mydep;
		myCube.fov = fov;
		myCube.cq = cq;

		/**
		* form clickable URL to video wall
		*/
		clickURL = clickURL + pl;

		/**
		* Read XML File
		*/
		myCube.readXML(pl);

		addEventListener(Event.ENTER_FRAME, onEnterFrame); 
		addEventListener(MouseEvent.CLICK, goToURL);
	}

	private function goToURL (e:MouseEvent):void {

		rotateToggle(e);

		if (clickURL != "" ) {
			var request:URLRequest = new URLRequest(clickURL);
                	//flash.net.navigateToURL(request, "_blank");
                	flash.net.navigateToURL(request, "_self");
		}
	}

	private function rotateToggle (e:MouseEvent):void 
	{
		if (!doRotate) {
			doRotate=true;
		} else {
			doRotate = false;
		}
	}

    	private function onEnterFrame(e:Event):void {
		if (!done_init && myCube.cube_init) {
			addChild(myCube);
			done_init = true;
		} else if (done_init) {
			// Rotation is OFF
			if (!doRotate) {
				myCube.renderVW();
				return;
			}

			// Global Rotation of All Cubes
			if (rx != 0) {
				myCube.mainCube.pitch(rx);
			}
			if (ry != 0) {
				myCube.mainCube.yaw(ry);
			}
			if (rz != 0) {
				myCube.mainCube.roll(rz);
			}

			// Rotate individual Cubes
			if (rbxcube) {
				var rand_num:Number;
				var rand_num_x:Number;
				var rand_num_y:Number;
				var rand_num_z:Number;
				rand_num_x = Math.floor(Math.random() * ((1+rx) - 1 + 1)) + 1;
				rand_num_y = Math.floor(Math.random() * ((1+ry) - 1 + 1)) + 1;
				rand_num_z = Math.floor(Math.random() * ((1+rz) - 1 + 1)) + 1;
				for (var v:int = 0; v < myCube.primitiveCubeArray.length; v++) {
					rand_num = Math.floor(Math.random() * ((myCube.primitiveCubeArray.length-1) - 1 + 1)) + 1;
					if (rx != 0) {
						if ((rand_num%2) == 0)
							myCube.primitiveCubeArray[rand_num].localRotationX += rand_num_x;
						else
							myCube.primitiveCubeArray[rand_num].localRotationX -= rand_num_x;
					}
					if (ry != 0) {
						if ((rand_num%2) == 0)
							myCube.primitiveCubeArray[rand_num].localRotationY += rand_num_y;
						else
							myCube.primitiveCubeArray[rand_num].localRotationY -= rand_num_y;
					}
					if (rz != 0) {
						if ((rand_num%2) == 0)
							myCube.primitiveCubeArray[rand_num].localRotationZ += rand_num_z;
						else
							myCube.primitiveCubeArray[rand_num].localRotationZ -= rand_num_z;
					}
				}
			}

			// Mouse Control
			if (rx == 0 && ry == 0 && rz == 0) {
				//myCube.mainCube.yaw(myCube.mouseX/2);
				//myCube.mainCube.pitch(myCube.mouseY/2);
				//myCube.mainCube.roll(myCube.mouseY/2);
				myCube.mainCube.localRotationX = -(myCube.mouseY / 2);
				myCube.mainCube.localRotationY = (myCube.mouseX / 2);
				//myCube.mainCube.localRotationZ = -(myCube.mouseY / 2);
			}

			myCube.renderVW();
		}
    	}
    }
}
