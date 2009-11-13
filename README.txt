<h1>Assets is used to unify loading and sending of all types of files in ActionScript.</h1>
<h2>It is setup to be configured in many different ways to easily fit any type of project.</h2>

<b>Loading files and listening for events</b>
The base system is based on three main parts, (Assets, Asset, and Job)
Assets is the main class that manages everything. You can call add() on 
an instance of Assets to add a file to be loaded. Internally it will create a Asset
object that will save all of the information about the asset that is being loaded. 
The add() method will return this Asset instance. If you are only interested in 
this one Asset to be loaded you can listen for all loading events (complete, progress, 
IOError, etc. ) on this Asset instance.

After all of your assets are added to your Assets instance you can call load().
This will close the Job that all of your Asset objects have been added to and 
start loading your assets. The load() method will return an instance of the Job that 
these files has been added to. This Job instance dispatches events about all of the 
Assets that are loading within it. So if you have 5 Asset objects in your Job, and you 
are listening to progress events on your Job you will get bytesLoaded that is a sum
of all of the Asset objects bytesLoaded added together.
If you then add more Asset objects to Assets and load them before your last Job was 
finished you can also listen for progress events on Assets which gives you information
about all Jobs that are loading.

<b>Sending files</b>
Every time you add a Asset to be loaded you can think about this as simply a URL that
will have a return value. Sometimes the return value is just for confirmation and what 
you are really interested in is the values that are sent to the server. This project was 
created with all of this in mind. To add a name value pair to your Asset instance use the 
addVariable() method. Here is an example. 

var assets:Assets = new Assets( new Cache() );
var asset:Asset = assets.add("http://search.twitter.com/search");
asset.addVariable("name", "value");
assets.load();

In this example we added one variable, of course you can add as many of these
that you need but this is only the beginning. What if you want to send a file?
Sending any type of data besides name value pairs is very complicated and filled
with security concerns. The first thing that you will notice if you try to do it
based on the Adobe docs there way of doing it makes uploading multiple files 
impossible and sending variables along with them forces you to hack stuff together.
This is how you do it in our system...

var asset:Asset = assets.add('http://search.twitter.com/search' );
asset.addFile( file, "myImage.jpg" );
asset.addVariable("name", "value");
assets.load( event );

You can add as many files as you like and whatever variables along with them the only
thing in addition that you have to add is to pass in a MouseEvent to assets.load();
We will take care of the rest. Behind the scenes this class is writing pure HTTP 
messages in binary to make this work.

<b>Accessing loaded files</b>
After a Asset is loaded it is saved in a cache. These objects will be saved in the cache
until they are deleted. If you want different instances of Assets with the same cache you 
can pass one Assets cache into another or have one Assets instance and change out the cache 
at some later point you can do that. Most projects wont need these features but what you 
will need is to know how to get stuff out of the cache. The cache is pretty much a big object
you can access like any other object which stores instances of your Assets. 

var asset:Asset = assets.cache["http://search.twitter.com/search"];

You can delete it like this:
delete assets.cache["http://search.twitter.com/search"];

A Asset objects loaded content is saved in a property called data.
So if the data was an image you could do this:
addChild( assets.cache["http://search.twitter.com/search"].data as Bitmap );