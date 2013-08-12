/*
   Nexgen Warning Plugin by Patrick 'Sp0ngeb0b' Peltzer
   spongebobut@yahoo.com

	Update to include GAP lookups by .seVered.][ [channingd@hotmail.com]
		with STRONG support from Dave @ unrealize.uk.co
	
*/
//////////////////
// OFFICIAL PUBLIC NEXGEN PLUGIN
//////////////////

class NexgenWarn extends NexgenPlugin;

/***************************************************************************************************
 *
 *  $DESCRIPTION  Initializes the plugin. Note that if this function returns false the plugin will
 *                be destroyed and is not to be used anywhere.
 *  $RETURN       True if the initialization succeeded, false if it failed.
 *  $OVERRIDE
 *
 **************************************************************************************************/
function bool initialize() {

	return true;
}

/***************************************************************************************************
 *
 *  $DESCRIPTION  Called when a new client has been created. Use this function to setup the new
 *                client with your own extensions (in order to support the plugin).
 *  $PARAM        client  The client that was just created.
 *  $REQUIRE      client != none
 *  $OVERRIDE
 *
 **************************************************************************************************/
function clientCreated(NexgenClient client) {
	local NexgenWarnClient xClient;

	xClient = NexgenWarnClient(client.addController(class'NexgenWarnClient', self));

}

/***************************************************************************************************
 *
 *  $DESCRIPTION  Default properties block.
 *
 **************************************************************************************************/

defaultproperties
{
     pluginName="Nexgen Warning Plugin"
     pluginAuthor="Sp0ngeb0b"
     pluginVersion="1.0"
}
