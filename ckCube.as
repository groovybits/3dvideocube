package
{
   import flash.display.Sprite;
   import flash.events.*;
   import flash.display.*;
   import flash.media.Video;
   import flash.net.NetConnection;
   import flash.net.NetStream;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.utils.Timer;
   
   //import org.papervision3d.core.effects.view.ReflectionView;
   import org.papervision3d.view.Viewport3D;
   import org.papervision3d.scenes.Scene3D;
   import org.papervision3d.cameras.Camera3D;
   import org.papervision3d.materials.ColorMaterial;
   import org.papervision3d.materials.WireframeMaterial;
   import org.papervision3d.materials.VideoStreamMaterial;
   import org.papervision3d.materials.utils.MaterialsList;
   import org.papervision3d.objects.primitives.Cube;
   import org.papervision3d.render.BasicRenderEngine;
   import org.papervision3d.materials.shadematerials.FlatShadeMaterial;
   import org.papervision3d.lights.PointLight3D;

   public class ckCube extends Sprite
   {
      // Main 3D View
      //public var rview :ReflectionView;
      public var viewport: Viewport3D;
      public var scene: Scene3D;
      public var camera: Camera3D;    
      public var renderer: BasicRenderEngine;
      
      // Cube Stuff
      public var mainCube:Cube;
      public var cubeBase:Cube;
      public var primitiveCubeArray:Array = new Array();
      public var videoArray:Array = new Array();    
      public var videostreamMaterialArray:Array = new Array();    
      public var cube_init:Boolean = false;
      public var pl3D:PointLight3D;
      
      // XML Stuff
      private var xmlData:XML;
      private var tracklist:XMLList;
      private var tracks:XML;
      private var video:XML;
      private var xmlLoader:URLLoader = new URLLoader();
      private var xmlRequest:URLRequest;

      // Video Loop Timer
      private var timer:Timer;
      
      // Input Settings
      public var sw:int = 640;
      public var sh:int = 480;
      public var fov:int = 30;
      public var myheight:int = 88;
      public var mywidth:int = 88;
      public var bh:int = 5;
      public var bw:int = 5;
      public var bd:int = 5;
      public var myrow:int = 4;
      public var mycol:int = 4;
      public var mydep:int = 4;
      public var playsecs:int = 3;
      public var cq:int = 1;
         
      public function ckCube():void
      { 
	// VMS Cube Main Class
      }
      
      public function createVM(url:String, width:int, height:int):VideoStreamMaterial {
	var customClient:Object = new Object();
	var netConnection:NetConnection;
        var video:Video;
        var netStream:NetStream;           
         
	customClient.onMetaData = metaDataHandler;
	netConnection = new NetConnection();
	netConnection.connect(null); 
	netStream = new NetStream(netConnection);
	netStream.client = customClient;
	netStream.play(url);
	video = new Video(width, height);
	
	video.attachNetStream(netStream);
	
	video.width = width;
	video.height = height;
	video.smoothing = true;

	return new VideoStreamMaterial(video, netStream);
      }
      
      internal function metaDataHandler(infoObject:Object):void {
	
      }   

      // Solid Cube
      public function createSolidCube(color:uint, width:int, length:int, height:int):Cube {
	 var colorMaterial: ColorMaterial;
         colorMaterial = new ColorMaterial(color);
         colorMaterial.opposite = false;

	 var materialsList:MaterialsList = new MaterialsList();
	 materialsList.addMaterial( colorMaterial, "all" );

         return new Cube(materialsList, width, length, height, 4, 4, 4, Cube.NONE, Cube.NONE);
      }
     
      // Solid Shaded Cube
      public function createSolidShadedCube(color:uint, width:int, length:int, height:int):Cube {
	 var flatShadeMaterial:FlatShadeMaterial;
	 flatShadeMaterial = new FlatShadeMaterial(pl3D, color, (0x999999&color));
         flatShadeMaterial.opposite = false;

	 var materialsList:MaterialsList = new MaterialsList();
	 materialsList.addMaterial( flatShadeMaterial, "all" );

         return new Cube(materialsList, width, length, height, 4, 4, 4, Cube.NONE, Cube.NONE);
      }
          
      // Video Cube
      public function createCube(width:int, length:int, height:int, 
      		back:String, front:String, 
      		left:String, right:String,
      		bottom:String, top:String):Cube 
      {
	 var colorMaterialGrey:FlatShadeMaterial;
	 colorMaterialGrey = new FlatShadeMaterial(pl3D, 0xa0a0a0, 0x707070);
         colorMaterialGrey.opposite = false;

	 var colorMaterialBlack:FlatShadeMaterial;
	 colorMaterialBlack = new FlatShadeMaterial(pl3D, 0x505050, 0x000000);
         colorMaterialBlack.opposite = false;

	 var videostreamMaterialFront: VideoStreamMaterial;  
	 var videostreamMaterialBack: VideoStreamMaterial;
	 var videostreamMaterialLeft: VideoStreamMaterial;
	 var videostreamMaterialRight: VideoStreamMaterial;
	 var videostreamMaterialTop: VideoStreamMaterial;
	 var videostreamMaterialBottom: VideoStreamMaterial;
	 
	 var materialsList:MaterialsList = new MaterialsList();
	 
	 if (front != "") {
	 	videostreamMaterialFront = createVM(front, width, height);
	 	videostreamMaterialFront.opposite = false;
	 	materialsList.addMaterial( videostreamMaterialFront, "front" );
		videostreamMaterialArray.push(videostreamMaterialFront);
	 } else
	 	materialsList.addMaterial( colorMaterialBlack, "front" );
	 	
	 if (back != "") {
	 	videostreamMaterialBack = createVM(back, width, height);
	 	videostreamMaterialBack.opposite = false;
	 	materialsList.addMaterial( videostreamMaterialBack, "back" );
		videostreamMaterialArray.push(videostreamMaterialBack);
	 } else
	 	materialsList.addMaterial( colorMaterialBlack, "back" );
	 	
	 if (left != "") {
	 	videostreamMaterialLeft = createVM(left, width, height);
	 	videostreamMaterialLeft.opposite = false;
	 	materialsList.addMaterial( videostreamMaterialLeft, "left" );
		videostreamMaterialArray.push(videostreamMaterialLeft);
	 } else
	 	materialsList.addMaterial( colorMaterialBlack, "left" );
	 
	 if (right != "") {
	 	videostreamMaterialRight = createVM(right, width, height);
	 	videostreamMaterialRight.opposite = false;
	 	materialsList.addMaterial( videostreamMaterialRight, "right" );
		videostreamMaterialArray.push(videostreamMaterialRight);
	 } else
	 	materialsList.addMaterial( colorMaterialBlack, "right" );
	 	
	 if (top != "") {
	 	videostreamMaterialTop = createVM(top, width, height);
	 	videostreamMaterialTop.opposite = false;
	 	materialsList.addMaterial( videostreamMaterialTop, "top" );
		videostreamMaterialArray.push(videostreamMaterialTop);
	 } else
	 	materialsList.addMaterial( colorMaterialGrey, "top" );
	 	
	 if (bottom != "") {
	 	videostreamMaterialBottom = createVM(bottom, width, height);
	 	videostreamMaterialBottom.opposite = false;
	 	materialsList.addMaterial( videostreamMaterialBottom, "bottom" );
		videostreamMaterialArray.push(videostreamMaterialBottom);
	 } else
	 	materialsList.addMaterial( colorMaterialGrey, "bottom" );
         	         
         return new Cube(materialsList, width, length, height, cq, cq, cq, Cube.NONE, Cube.NONE);
      }             
	
      /** 
      * Startup Cube
      */
      private function setupVW():void { 		
		 //viewport = new Viewport3D(w, h, scaleToStage, interactive, 
		 //	autoClipping:Boolean = true, autoCulling:Boolean = true);
		 var sts:Boolean = false;
		 if (sw == 0 && sh == 0)
			sts = true;
	         //rview = new ReflectionView(sw, sh, sts, false, "Target");
	         viewport = new Viewport3D(sw, sh, sts, true, true, true);
	         
	         //instantiates a Scene3D instance
	         scene = new Scene3D();
	         
	         //instantiates a Camera3D instance
	         //(fov:Number = 60, near:Number = 10, far:Number = 5000, 
		 //	useCulling:Boolean = false, useProjection:Boolean = false)
	         camera = new Camera3D(fov, 10, 5000, true, true);
	         
	         //renderer draws the scene to the stage
	         renderer = new BasicRenderEngine();	

		 // Light Source
      		 pl3D = new PointLight3D(true, false);

		 var wireframeMaterial: WireframeMaterial;
         	 wireframeMaterial = new WireframeMaterial(0x000000, 0, 0);
         	 wireframeMaterial.opposite = false;

	 	 var materialsList:MaterialsList = new MaterialsList();
	 	 materialsList.addMaterial( wireframeMaterial, "all" );

          	 mainCube = new Cube(materialsList, 
			((mywidth+bw)*myrow), ((mywidth+bd)*mydep), 
			((myheight+bh)*mycol), 1, 1, 1, Cube.ALL, Cube.ALL);
	         
	         var i:int = 0;
	         var pos:int = 0;
	         for (var zplane:int = 0; zplane < mydep; zplane++) {	         	 
		         for (var yplane:int = 0; yplane < mycol; yplane++) {		      
		             for (var xplane:int = 0; xplane < myrow; xplane++, pos++) {
		             	var sidesArray:Array = new Array();
		             	
		                if (zplane > 0 && zplane < (mydep-1)) {
		                	if (yplane > 0 && yplane < (mycol-1)) {
		                		if (xplane > 0 && xplane < (myrow-1)) {
		                			// No Cube, middle of Box
		                			continue;
		                		}
		                	} 
		                }
		                
		         	var primitiveCube:Cube;
	         	
				if (zplane == 0 && yplane == (mycol-1) && xplane == (myrow-1)) {
					// First Cube is Red
		         		primitiveCube = 
						createSolidShadedCube(0xff0000, mywidth, mywidth, myheight);
				} else {
        		                if (videoArray.length <= (i+1))
        		                	sidesArray.push("");
        	                	else if (zplane == 0)  // Front
        	                		sidesArray.push(videoArray[i++]);
        	                	else
        	                		sidesArray.push("");
        	                		
        	                	if (videoArray.length <= (i+1))
        		                	sidesArray.push("");
        	                	else if (zplane == (mydep-1))  // Back
        	         			sidesArray.push(videoArray[i++]);
        	         		else
        	         			sidesArray.push("");
        	         		
        	         		if (videoArray.length <= (i+1))
        		                	sidesArray.push("");
        	                	else if (xplane == 0)
        	         			sidesArray.push(videoArray[i++]);
        	         		else
        	         			sidesArray.push("");
        	         		
        	         		if (videoArray.length <= (i+1))
        		                	sidesArray.push("");
        	                	else if (xplane == (myrow-1))
        	         			sidesArray.push(videoArray[i++]);
        	         		else
        	         			sidesArray.push("");
        	         		
        	         		if (videoArray.length <= (i+1))
        		                	sidesArray.push("");
        	                	else if (yplane == 0)
        	         			sidesArray.push(videoArray[i++]);
        	         		else
        	         			sidesArray.push("");
        	         			
        	         		if (videoArray.length <= (i+1))
        		                	sidesArray.push("");
        	                	else if (yplane == (mycol-1))
        	         			sidesArray.push(videoArray[i++]);
        	         		else
        	         			sidesArray.push("");
		                
		         		primitiveCube = createCube(mywidth, mywidth, myheight, 
		         			sidesArray[0], // Back
		         			sidesArray[1], // Front
		         			sidesArray[2], // Left
		         			sidesArray[3], // Right
		         			sidesArray[4], // Bottom
		         			sidesArray[5]); // Top
				}
		         	
		         	primitiveCube.x = (xplane*(mywidth+bw)) - (((mywidth+bw)*(myrow-1))/2);
		         	primitiveCube.y = (yplane*(myheight+bh)) - (((myheight+bh)*(mycol-1))/2);
		         	primitiveCube.z = (zplane*(mywidth+bd)) - (((mywidth+bd)*(mydep-1))/2);
		         
		         	primitiveCubeArray.push(primitiveCube);
		         	
		         	if (yplane == 0 && xplane == 0 && zplane == 0) {
					cubeBase = primitiveCube; // First Base Cube
					mainCube.addChild(cubeBase);
		         	} else {
		         		mainCube.addChild(primitiveCube);		         	
				}
		             }
		         }  
	         }		   
		// Add Viewport to display

		//rview.surfaceHeight = 0;
		//addChild(rview);	
		//rview.scene.addChild(mainCube);
	 	//rview.camera.target = mainCube;
		//rview.singleRender();

		addChild(viewport);	
		scene.addChild(mainCube);	
	 	camera.target = mainCube;
		mainCube.rotationX = -20;
		mainCube.rotationZ = -15;
		mainCube.rotationY = 15;

		// Cube Initialized
		cube_init = true;

		// Loop Timer for Video restart
		timer = new Timer(1000, 0);
		timer.addEventListener(flash.events.TimerEvent.TIMER, loopVW);
		timer.start();
        }
      	    
        /** 
        * Render Cube
        */
        public function renderVW():void { 		    
	 	renderer.renderScene(scene, camera, viewport);
	 	//rview.renderer.renderScene(rview.scene, rview.camera, rview.viewport);
		//rview.singleRender();
	}

        /** 
        *  Loop Video Timer Callback
        */
        internal function loopVW(e:TimerEvent):void { 		    
	 	for (var v:int=0; v < videostreamMaterialArray.length; v++) {
	 		if (videostreamMaterialArray[v].stream.time >= playsecs) {
	 			videostreamMaterialArray[v].stream.pause();
	 			videostreamMaterialArray[v].stream.seek(0);
	 			videostreamMaterialArray[v].stream.resume();
	 		}
	 	}       	    
        }
      
        /**
	* Load Data from XML File
	*/
        public function readXML(fname:String):void {
                // Load XML Playlist File
                try {
                        // XML Events to listen for
                        xmlLoader.addEventListener(Event.COMPLETE, xmlLoaded);
                        xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, errorLoad);
                        
                        // Load XML Playlist
                        xmlRequest = new URLRequest(fname);
                        xmlLoader.load(xmlRequest);
                } catch (error:Error) {
                        trace(error.name);
                }
                return;
        }
        
        /**
        * Error loading XML File
        */
        internal function errorLoad(e:Event):void {
        	trace("Error Loading XML");
        }
	
        /**
        * XML File Loaded OK
        */
	internal function xmlLoaded(e:Event):void {
                xmlLoader.removeEventListener(Event.COMPLETE, xmlLoaded);
                xmlLoader.removeEventListener(IOErrorEvent.IO_ERROR, errorLoad);
                
                // Process XML Data
                processXML(e.target.data);
                
                return;
	}
	
        /**
        * Process String into XML Data
        */
        internal function processXML(db:String):void {
		// XML Data
    		xmlData = new XML(db);
    		
		// Get tracklist from XML File
    		xmlData.ignoreWhite = true;
    		tracklist = xmlData.children();
    		
    		setupVideos();
        }
        
	/**
	* setupVideos Config.
        *   
	*/
	internal function setupVideos():void {                  	
        	var i:int = 0;
        	
        	for each (tracks in tracklist.children()) {
                	for each (video in tracks.children()) {	  	                        	  	                        	                    	
                                if (video.name() == "http://xspf.org/ns/0/::location") {
                                	videoArray.push(video.text());
                                } else if (video.name() == "http://xspf.org/ns/0/::annotation") {
                                	// Annotation
                                } else if (video.name() == "http://xspf.org/ns/0/::image") {
                                    	// Full Video File
                                } 
                                video = null;	                             
                        }
                        i++; 
                }
                
                // Setup Cube
                setupVW();
                
                return;
	}
        
   }
}
