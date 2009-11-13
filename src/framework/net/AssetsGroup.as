package framework.net 
{
	import flash.events.*;
	
	import framework.cache.*;
	
	public class AssetsGroup extends EventDispatcher
	{
		private var _cache:Cache;
		private var _assets:Assets;
		private var _loading:Array = [];
		
		public function AssetsGroup( assets:Assets )
		{
			super();
			
			_assets = assets;
			_cache = _assets.cache;
		}
		
		public function add( path:String, options:Object=null ):void
		{
			_loading.push( path );
			_assets.add( path, options );
		}
		
		public function load():void
		{
			_assets.load().addEventListener( Event.COMPLETE, onLoaded );
		}
		
		private function onLoaded( event:Event ):void
		{
			event.target.removeEventListener( Event.COMPLETE, onLoaded );
			
			for each( var preloads:String in _loading ){
				var data:XML = XML( _cache[preloads].data );
				for each( var file:XML in data.elements() ){
					var options:Object = {};
					options.name = file.@name.toString()||null;
					options.method = file.@method.toString()||null;
					options.type = file.@type.toString()||null;
					_assets.add( file.@src.toString()||file.@href.toString()||file.text(), options );
				}
			}
			_assets.load().addEventListener( Event.COMPLETE, onComplete );
		}
		
		private function onComplete( event:Event ):void
		{
			event.target.removeEventListener( Event.COMPLETE, onComplete );
			dispatchEvent( event );
		}
	}
}