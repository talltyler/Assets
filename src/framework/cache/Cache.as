package framework.cache 
{	
	/**
	 *  Cache is a dynamic class that extends object, it is used to store data.
	 */
	dynamic public class Cache extends Object
	{
		
		/**
		 *	@constructor
		 *	@param	context	 A reference to your application context, not really needed most of the time
		 */
		public function Cache( context:* = null )
		{
			super();
			
			if( context )
				this.context = context;
		}
		
		/**
		 *	Utility method to convert the object to a String
		 *	@return	Returns a String version of the data within your Cache object
		 */
		public function toString():String
		{
			var result:String = "";
			for( var prop:String in this ) {
				result += prop + ":" + this[prop] + "; "
			}
			return result;
		}
	}
}