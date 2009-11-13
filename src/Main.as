package {

	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.*;
	import flash.utils.*;

	import framework.cache.*;
	import framework.net.*;
	
	import com.adobe.images.JPGEncoder;

	public class Main extends Sprite 
	{
		private var assets:Assets = new Assets();
				
		public function Main()
		{
			super();
			
			// A example of loading files
			assets.addEventListener( Event.COMPLETE, onLoaded );
			assets.add( 'assets/images/image.gif' );
			assets.add( 'assets/text/sample.txt', { name:'sample' } );
			assets.load();
			
			// If you click on the stage you can upload it
			stage.addEventListener(MouseEvent.CLICK, onClick);
		}	

		private function onLoaded( event:Event ):void
		{
			assets.removeEventListener( Event.COMPLETE, onLoaded );
			addChild( assets.cache['assets/images/image.gif'].data as Bitmap );
			trace( assets.cache['sample'].data );

			// A simple example of sending and loading
			var asset:Asset =  assets.add( 'http://search.twitter.com/search' );
			asset.addVariable( "q", "actionscript" );
			asset.addEventListener( Event.COMPLETE, onGet );
			assets.load();
		}
		
		private function onGet( event:Event ):void
		{
			assets.removeEventListener( Event.COMPLETE, onGet );
			trace( assets.cache['http://search.twitter.com/search'].data.substring(0,96) );
			
			var group:AssetsGroup = new AssetsGroup( assets );
			group.addEventListener( Event.COMPLETE, onGroup );
			group.add( 'assets/text/bulk.xml' );
			group.load();
		}
		
		private function onGroup( event:Event ):void
		{
			event.target.addEventListener( Event.COMPLETE, onGroup );
			
			addChild( assets.cache['assets/images/sample.png'].data as Bitmap );
			addChild( assets.cache['assets/images/sample.jpg'].data as Bitmap );
		}
		
		private function onClick(event:MouseEvent):void
		{
			// turn stage into a jpg
			var jpgSource:BitmapData = new BitmapData(100,100);
			jpgSource.draw( this );
			var jpgEncoder:JPGEncoder = new JPGEncoder(100);
			var jpgStream:ByteArray = jpgEncoder.encode(jpgSource);
			
			// sending files
			var asset:Asset = assets.add('http://search.twitter.com/search', { method:URLRequestMethod.POST } );
			asset.addFile( jpgStream, "myImage.jpg" );
			assets.load( event ).addEventListener( Event.COMPLETE, onUpload );
		}
		
		private function onUpload(event:Event):void
		{
			// File upladed, return value
			trace( assets.cache['http://search.twitter.com/search'].data.substring(0,96) );
		}
	}
}