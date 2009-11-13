package framework.net
{	
	/**
	 *  This class is able to break appart any URI into it's different parts
	 */
    public class URI
	{
		public var rawString:String;
		public var protocol:String;
		public var port:int;
		public var host:String;
		public var path:String;
		public var queryString:String;
		public var queryObject:Object;
		public var queryLength:int = 0;
		
		/**
		 *	@constructor
		 *	@param	rawString	 The URI that you would like to break appart
		 */
		public function URI(rawString:String)
		{
			super();
			this.rawString = rawString;
			var regex:RegExp = /((?P<protocol>[a-zA-Z]+: \/\/)   (?P<host>[^:\/]*) (:(?P<port>\d+))?)?  (?P<path>[^?]*)? ((?P<query>.*))? /x; 
			var match:* = regex.exec(rawString);
			if (match){
				protocol = Boolean(match.protocol) ? match.protocol : "http://";
				protocol = protocol.substr(0, protocol.indexOf("://"));
				host = match.host || null;
				port = match.port ? int(match.port) : 80;
				path = match.path;
				queryString = match.query;
				if (queryString){
					queryObject = {};
					queryString = queryString.substr(1);
					var value:String;
					var varName:String;
					for each (var pair:String in queryString.split("&")){
						varName = pair.split("=")[0];
						value = pair.split("=")[1];
						queryObject[varName] = value;
						queryLength ++;
					}
				}
			}else{
				trace("no match");
			}
		}
		
		/**
		 *	@param	verbose	 Boolean value defining if you would like to get a discriptive output of URI
		 *	@return		String value of URI
		 */
		public function toString( verbose:Boolean=false ):String
		{
			if(verbose){
				return "[URL] rawString :" + rawString + ", protocol: " + protocol + ", port: " + port + ", host: " + host + ", path: " + path + ". queryLength: "  + queryLength;
			}
			return rawString;
		}
	}
}
