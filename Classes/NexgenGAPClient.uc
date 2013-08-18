class NexgenGAPClient extends NexgenClientController;

var NexgenGAP xControl;           // Plugin controller.

var bool bCurrentlyWarned;         // Whether this clients is currently warned
var NexgenClient target;
var string reason;                 // The warn reason
var string adminName;              // Admin who initiated the warning
var string GAPURL;
var string GAPSortOrder;
var string TERM;
var string HWID;
var string MACHash;
var string UTDCMacHash;
var string GAPTabTxt;
/***************************************************************************************************
 *
 *  $DESCRIPTION  Replication block.
 *
 **************************************************************************************************/
replication
{
    reliable if (role == ROLE_Authority) // Replicate to client...
        getWarned, Target, GAPSearch, HWID, MACHash, UTDCMacHash;

    reliable if (role < ROLE_Authority) // Replicate to server...
        warnPlayer, getHWID, getMACHash, getUTDCMacHash;
}

/***************************************************************************************************
 *
 *  $DESCRIPTION  Initializes the client controller. This function is automatically called after
 *                the critical variables have been set, such as the client variable.
 *  $PARAM        creator  The Actor that has added the controller to the client.
 *  $OVERRIDE
 *
 **************************************************************************************************/
function initialize(optional Actor creator) {
	xControl = NexgenGAP(creator);
}


/***************************************************************************************************
 *
 *  $DESCRIPTION  Initializes the client controller.
 *  $OVERRIDE
 *
 **************************************************************************************************/
simulated event postNetBeginPlay() {
	if (bNetOwner) {
		super.postNetBeginPlay();

		// Enable timer.
		setTimer(1.0, true);

	} else {
		destroy();
	}
}


/***************************************************************************************************
 *
 *  $DESCRIPTION  Modifies the setup of the Nexgen remote control panel.
 *  $OVERRIDE
 *
 **************************************************************************************************/
simulated function setupControlPanel() {
  local NexgenPanelContainer container;
  local UWindowPageControlPage pageControl;
  local NexgenPanel newPanel;

  if (client.hasRight(client.R_Moderate)) {

    // Since we can only modify a few existing tabs directly, we have to do a work around
    // First, locate the parent tab of the existing moderator tab
  	container = NexgenPanelContainer(client.mainWindow.mainPanel.getPanel("game"));

  	// Delete the tab
//  	if(container != none) {
//	    container.pages.DeleteTab(container.pages.GetTab(client.lng.moderatorTabTxt));
//    }

    // Spawn our modfied moderator tab and insert it before the match controller tab
    pageControl = container.pages.InsertPage(container.pages.GetPage(client.lng.matchControlTabTxt), "GAP Search", class'NexgenGAPPanel');
    if (pageControl != none) {
			newPanel = NexgenPanel(pageControl.page);
			newPanel.client = self.client;
			newPanel.setContent();
		}
  }
}


/***************************************************************************************************
 *
 *  $DESCRIPTION  Warn a specified player.
 *  $PARAM        playerNum The playernum of the selected player
 *  $PARAM        reason The warn reason.
 *
 **************************************************************************************************/
simulated function warnPlayer(int playerNum, string reason) {
  local NexgenClient target;
  local NexgenGAPClient xClient;
  local string args;


  // Preliminary checks.
	if (!client.hasRight(client.R_Moderate)) {
		return;
	}

	// Get target client.
	target = control.getClientByNum(playerNum);
	if (target == none) return;

	// Warn player.
	xClient = NexgenGAPClient(target.getController(class'NexgenGAPClient'.default.ctrlID));
	xClient.getWarned(reason, client.playerName);

  // Signal event.
	class'NexgenUtil'.static.addProperty(args, "client", client.playerNum);
	class'NexgenUtil'.static.addProperty(args, "target", target.playerNum);
	class'NexgenUtil'.static.addProperty(args, "reason", reason);
	control.signalEvent("player_warned", args, true);

	logAdminAction("<C07>"$client.playerName$" warned"@target.playerName$".");

}

// HWID
simulated function GetHWID(int playerNum)
{
    local NexgenGAPClient xClient;
    local Actor A;

    // Preliminary checks.
    if (!client.hasRight(client.R_Moderate))
        return;

    // Get target client.
    target = control.getClientByNum(playerNum);

    if (target == none)
        return;

    foreach Target.Owner.ChildActors(class'Actor', A)
    {
        log("Actors:"@A);
        if (A.IsA('ACEReplicationInfo'))
        {
            HWID = mid(A.GetPropertyText("HWHash"), 1);
            break;
        }
    }

    GapSearch(HWID);
}


// MACHash
simulated function GetMACHash(int playerNum)
{
    local NexgenGAPClient xClient;
    local Actor A;

    // Preliminary checks.
    if (!client.hasRight(client.R_Moderate))
        return;

    // Get target client.
    target = control.getClientByNum(playerNum);

    if (target == none)
        return;

    foreach Target.Owner.ChildActors(class'Actor', A)
    {
        log("Actors:"@A);
        if (A.IsA('ACEReplicationInfo'))
        {
            MACHash = A.GetPropertyText("MACHash");
            break;
        }
    }

    GAPSearch(MACHash);
}

// UTDCMacHash
simulated function GetUTDCMacHash(int playerNum)
{
    local NexgenGAPClient xClient;
    local Actor A;

    // Preliminary checks.
    if (!client.hasRight(client.R_Moderate))
        return;

    // Get target client.
    target = control.getClientByNum(playerNum);

    if (target == none)
        return;

    foreach Target.Owner.ChildActors(class'Actor', A)
    {
        log("Actors:"@A);
        if (A.IsA('ACEReplicationInfo'))
        {
            UTDCMacHash = A.GetPropertyText("UTDCMacHash");
            break;
        }
    }

    GAPSearch(UTDCMacHash);
}


simulated function GAPSearch(string TERM)
{
    Self.Owner.ConsoleCommand("start"@GAPURL$"sort=ctrl_dt+desc&search=" $ TERM);
    Log("GAP:"@"start"@GAPURL$"sort=ctrl_dt+desc&search=" $ TERM);
}

/***************************************************************************************************
 *
 *  $DESCRIPTION  Called when this client has been warned.
 *  $PARAM        warnReason The warn reason.
 *  $PARAM        warnAdminName The admin name who performed the warning.
 *
 **************************************************************************************************/
simulated function getWarned(string warnReason, string warnAdminName) {

	// Save values for further use
	reason = warnReason;
	adminName = warnAdminName;
	bCurrentlyWarned = True;

	client.showPopup(string(class'NexgenGAPDialog'), reason, adminName);
}




/***************************************************************************************************
 *
 *  $DESCRIPTION  Timer called every second. Reopens the warn dialog if the checkbox hasn't been
 *                ticked.
 *
 **************************************************************************************************/
simulated function timer() {

  if(bCurrentlyWarned) {

    // Warn player again if necessary.
	  if(NexgenGAPDialog(client.popupWindow.clientArea) == none ||
      !client.popupWindow.bWindowVisible) {


      client.showPopup(string(class'NexgenGAPDialog'), reason, adminName);
    }
  }
}


/***************************************************************************************************
 *
 *  $DESCRIPTION  Wrapper function for NexgenController.logAdminAction().
 *  $PARAM        msg           Message that describes the action performed by the administrator.
 *  $PARAM        str1          Message specific content.
 *  $PARAM        str2          Message specific content.
 *  $PARAM        str3          Message specific content.
 *  $PARAM        bNoBroadcast  Whether not to broadcast this administrator action.
 *
 **************************************************************************************************/
function logAdminAction(string msg, optional coerce string str1, optional coerce string str2,
                        optional coerce string str3, optional bool bNoBroadcast) {
	control.logAdminAction(client, msg, client.playerName, str1, str2, str3,
	                       client.player.playerReplicationInfo, bNoBroadcast);
}


/***************************************************************************************************
 *
 *  $DESCRIPTION  Default properties block.
 *
 **************************************************************************************************/

defaultproperties
{
    GAPTabTxt="GAP Search"
	 ctrlID="NexgenGAPClient"
    GAPURL="http://gap.tripax.org/ipsearch.php?"
}
