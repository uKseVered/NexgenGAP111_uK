/*
   Nexgen Warning Plugin by Patrick 'Sp0ngeb0b' Peltzer
   spongebobut@yahoo.com

	Updated to include GAP earches by 
		.seVered.][ [ channingd@hotmail.com ]
			& ~V~ [ dave@unrealize.uk.co ]
				& Higor [ caco_fff@hotmail.com ]
	
*/
//////////////////
// OFFICIAL PUBLIC NEXGEN PLUGIN
//////////////////

class NexgenGAP extends NexgenPlugin;


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
	local NexgenGAPClient xClient;

	xClient = NexgenGAPClient(client.addController(class'NexgenGAPClient', self));

}

/***************************************************************************************************
 *
 *  $DESCRIPTION  Default properties block.
 *
 **************************************************************************************************/

defaultproperties
{
     pluginName="Nexgen GAP Search Plugin"
     pluginAuthor=".seVered.]["
     pluginVersion="0.1"
}
