class NexgenWarnModeratePanel extends NexgenRCPModerate;

// Client Controller
var NexgenWarnClient xClient;
var UWindowSmallButton GAPNameButton;
var UWindowSmallButton GAPIPButton;
var UWindowSmallButton GAPHWIDButton;
var UWindowSmallButton GAPMACButton;
var UWindowSmallButton GAPUTDCMacHash;

var int GAPButtonsX;
var int GAPButtonsY;
var int GAPButtonsSpacer;
var int GAPButtonsWidth;
var string GAPURL;
var string Player;
var string PlayerIP;
var int PlayerNum;
var string HWID;

// New elements
var UWindowEditControl warnInp;
var UWindowSmallButton warnButton;

/***************************************************************************************************
 *
 *  $DESCRIPTION  Creates the contents of the panel.
 *  $OVERRIDE
 *
 **************************************************************************************************/
function setContent()
    {
    local NexgenContentPanel p;

    // Get client controller.
    xClient = NexgenWarnClient(client.getController(class'NexgenWarnClient'.default.ctrlID));

    // Create layout & add components.
    createWindowRootRegion();
    splitRegionV(192, defaultComponentDist);
    playerList = NexgenPlayerListBox(addListBox(class'NexgenPlayerListBox'));

    // Player info.
    splitRegionH(49, defaultComponentDist);
    p = addContentPanel();
    p.divideRegionH(2);
    p.splitRegionV(64);
    p.splitRegionV(64);
    p.addLabel(client.lng.ipAddressTxt, true);
    p.splitRegionV(48, , , true);
    p.addLabel(client.lng.clientIDTxt, true);
    p.splitRegionV(48, , , true);
    ipAddressLabel = p.addLabel();
    copyIPAddressButton = p.addButton(client.lng.copyTxt);
    clientIDLabel = p.addLabel();
    copyClientIDButton = p.addButton(client.lng.copyTxt);

    // Player controller.
    splitRegionH(51, defaultComponentDist);
    p = addContentPanel();
    p.divideRegionH(2);
    p.splitRegionV(96, defaultComponentDist);
    p.splitRegionV(96, defaultComponentDist);
    muteToggleButton = p.addButton(client.lng.muteToggleTxt);
    p.skipRegion();
    setNameButton = p.addButton(client.lng.setPlayerNameTxt);
    playerNameInp = p.addEditBox();

    // Ban controller.
    splitRegionH(107, defaultComponentDist);
    p = addContentPanel();
    p.divideRegionH(5);
    p.splitRegionV(96, defaultComponentDist);
    p.splitRegionV(96, defaultComponentDist);
    p.splitRegionV(96, defaultComponentDist);
    p.splitRegionV(96, defaultComponentDist);
    p.splitRegionV(96, defaultComponentDist);
    p.addLabel("Warn reason");
    warnInp = p.addEditBox();
    p.addLabel(client.lng.banReasonTxt);
    banReasonInp = p.addEditBox();
    warnButton = p.addButton("Warn");
    p.splitRegionV(96, defaultComponentDist);
    kickButton = p.addButton(client.lng.kickPlayerTxt);
    p.splitRegionV(96, defaultComponentDist);
    banButton = p.addButton(client.lng.banPlayerTxt);
    p.splitRegionV(96, defaultComponentDist);
    banForeverInp = p.addCheckBox(TA_Left, client.lng.banForeverTxt);
    p.skipRegion();
    banMatchesInp = p.addCheckBox(TA_Left, client.lng.banMatchesTxt);
    numMatchesInp = p.addEditBox();
    banDaysInp = p.addCheckBox(TA_Left, client.lng.banDaysTxt);
    numDaysInp = p.addEditBox();

    // Game controller.
    splitRegionH(65);
    p = addContentPanel();
    p.divideRegionH(3);
    muteAllInp = p.addCheckBox(TA_Left, client.lng.muteAllTxt);
    allowNameChangeInp = p.addCheckBox(TA_Left, client.lng.allowNameChangeTxt);
    p.splitRegionV(96, defaultComponentDist);
    showMsgButton = p.addButton(client.lng.showAdminMessageTxt);
    messageInp = p.addEditBox();

    // Configure components.
    playerNameInp.setMaxLength(32);
    warnInp.setMaxLength(100);
    banReasonInp.setMaxLength(250);
    numMatchesInp.setMaxLength(4);
    numMatchesInp.setNumericOnly(true);
    numDaysInp.setMaxLength(4);
    numDaysInp.setNumericOnly(true);
    messageInp.setMaxLength(250);
    playerList.register(self);
    muteToggleButton.register(self);
    setNameButton.register(self);

    warnButton.register(self);
    kickButton.register(self);
    banButton.register(self);
    showMsgButton.register(self);
    banForeverInp.register(self);
    banMatchesInp.register(self);
    banDaysInp.register(self);
    muteAllInp.register(self);
    allowNameChangeInp.register(self);
    banMatchesInp.bChecked = true;
    numMatchesInp.setValue("3");
    numDaysInp.setValue("7");
    playerSelected();
    banPeriodSelected();
    setValues();

    //GAP section

    //UWindowSmallButton(CreateControl(class'UWindowSmallButton', X, Y, Width, Height));

    GAPButtonsX = 322;
    GAPButtonsY = 49;
    GAPButtonsSpacer =42;
    GAPButtonsWidth = 38;

    GAPNameButton = UWindowSmallButton(CreateControl(class'UWindowSmallButton',GAPButtonsX, GAPButtonsY,GAPButtonsWidth, 1));
    GAPNameButton.SetText("Name");
    GAPNameButton.Register(Self);
    GAPNameButton.bAlwaysOnTop = true;

    GAPIPButton = UWindowSmallButton(CreateControl(class'UWindowSmallButton',GAPButtonsX+GAPButtonsSpacer, GAPButtonsY,GAPButtonsWidth, 1));
    GAPIPButton.SetText("IP");
    GAPIPButton.Register(Self);
    GAPIPButton.bAlwaysOnTop = true;

    GAPHWIDButton = UWindowSmallButton(CreateControl(class'UWindowSmallButton',GAPButtonsX+(GAPButtonsSpacer*2),GAPButtonsY,GAPButtonsWidth, 1));
    GAPHWIDButton.SetText("HWID");
    GAPHWIDButton.Register(Self);
    GAPHWIDButton.bAlwaysOnTop = true;

    GAPMACButton = UWindowSmallButton(CreateControl(class'UWindowSmallButton',GAPButtonsX+(GAPButtonsSpacer*3),GAPButtonsY,GAPButtonsWidth, 1));
    GAPMACButton.SetText("MAC1");
    GAPMACButton.Register(Self);
    GAPMACButton.bAlwaysOnTop = true;

    GAPUTDCMacHashButton = UWindowSmallButton(CreateControl(class'UWindowSmallButton',GAPButtonsX+(GAPButtonsSpacer*4),GAPButtonsY,GAPButtonsWidth, 1));
    GAPUTDCMacHashButton.SetText("MAC2");
    GAPUTDCMacHashButton.Register(Self);
    GAPUTDCMacHashButton.bAlwaysOnTop = true;
}



/***************************************************************************************************
 *
 *  $DESCRIPTION  Called when a player was selected from the list.
 *
 **************************************************************************************************/
function playerSelected()
{
    super.playerSelected();
    warnButton.bDisabled = (NexgenPlayerList(playerList.selectedItem) == none);
}


/***************************************************************************************************
 *
 *  $DESCRIPTION  Notifies the dialog of an event (caused by user interaction with the interface).
 *  $PARAM        control    The control object where the event was triggered.
 *  $PARAM        eventType  Identifier for the type of event that has occurred.
 *  $REQUIRE      control != none
 *  $OVERRIDE
 *
 **************************************************************************************************/
function Notify(UWindowDialogControl control, byte eventType)
{
    super.notify(control, eventType);

    if (PlayerList == None || NexgenPlayerList(PlayerList.selectedItem) == None)
        return;

    Player =  NexgenPlayerList(playerList.selectedItem).pName;
    PlayerNum = NexgenPlayerList(playerList.selectedItem).pNum;
    PlayerIP =  NexgenPlayerList(playerList.selectedItem).pIPAddress;

    if (control == GAPNameButton && eventType == DE_Click)
    {
        GetPlayerOwner().ConsoleCommand("start"@GAPURL$"sort=ctrl_dt+desc&search=" $ Player);
        Log("GAP:"@"start"@GAPURL$"sort=ctrl_dt+desc&search=" $ Player );
        return;
    }

    if (control == GAPIPButton && eventType == DE_Click)
    {
        GetPlayerOwner().ConsoleCommand("start"@GAPURL$"sort=ctrl_dt+desc&search=" $ PlayerIP);
        Log("GAP:"@"start"@GAPURL$"sort=ctrl_dt+desc&search=" $ PlayerIP );
        return;
    }

    if (control == GAPHWIDButton && eventType == DE_Click)
    {
        xClient.GetHWID(PlayerNum);
        return;
    }
	 
	 if (control == GAPMACButton && eventType == DE_Click)
    {
        xClient.GetMACHash(PlayerNum);
        return;
    }

	 if (control == GAPUTDCMacHashButton && eventType == DE_Click)
    {
        xClient.GetUTDCMacHash(PlayerNum);
        return;
    }

    if (control == warnButton && !warnButton.bDisabled && eventType == DE_Click)
    {
        if(warnInp.getValue() == "")
            client.showMsg("<C00>You have to enter a reason.");
        else
            xClient.warnPlayer(NexgenPlayerList(playerList.selectedItem).pNum, class'NexgenUtil'.static.trim(warnInp.getValue()));
        return;
    }
}

/***************************************************************************************************
 *
 *  $DESCRIPTION  Default properties block.
 *
 **************************************************************************************************/

defaultproperties
{
    GAPURL="http://gap.tripax.org/ipsearch.php?"
}
