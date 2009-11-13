package framework.net {
	
	import flash.events.*;
	
	/**
	 *  A Job is a grouping of Assets, it manages them while they are loading. 
	 *	A Job is created every time you call load. You can push thing into or 
	 *	take things out of a running Job if you need to but this isn't normally 
	 *	needed.
	 */
	public class Job extends EventDispatcher {
		
		public var event:Event;
		
		private var _assets:Array = [];

		public function Job(){ super(); }
		
		/**
		 *	To take something out of a job call remove
		 *	@param	asset	 The Asset that you want to delete form the job
		 */
		public function remove(asset:Asset):void 
		{
			var index:int = _assets.indexOf(asset);
			if (index > -1) {
				_assets.splice(index, 1);
			}
		}
		
		/**
		 *	@return		Returns the number of bytes loaded as a int for all Assets in the Job
		 */
		public function get bytesLoaded():int 
		{
			var bytesLoaded:int = 0;
			for each (var asset:Asset in _assets) {
				if (asset.bytesLoaded) {
					bytesLoaded += asset.bytesLoaded;
				}
			}
			return bytesLoaded;
		}
		
		/**
		 *	@return		Returns the number of bytes total as a int for all Assets in the Job
		 */
		public function get bytesTotal():int {
			var _bytesTotal:int = 0;
			for each (var asset:Asset in _assets) {
				if (asset.bytesTotal) {
					_bytesTotal += asset.bytesTotal;
				}
			}
			return _bytesTotal;
		}

		/**
		 *	@return		Returns the number of Assets inside of this Job
		 */
		public function get length():int {
			return _assets.length;
		}
		
		/**
		 *	@param	...args	 A rest paramiter to pass in any amount of Assets.
		 *	@return		Returns the length of the Jobs after all the Assets have been added
		 */
		public function push(...args):uint {
			_assets.push.apply(null, args);
			return _assets.length;
		}
		
		/**
		 *	@param	callback	The call back function that you want to call on each item
		 *	@param	thisObject	A reference to this, default is null
		 */
		public function forEach(callback:Function, thisObject:* = null):void {
			_assets.forEach(callback, thisObject);
		}
		
		/**
		 *	@private
		 *	Clears everything in Job
		 */
		public function wipe():void {
			for each (var asset:Asset in _assets) {
				asset.job = undefined;
			}
		}
	}
}