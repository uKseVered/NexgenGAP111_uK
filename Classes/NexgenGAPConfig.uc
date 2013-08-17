/***************************************************************************************************
 *
 *  Nexgen GAP Search Plugin Config by .seVered.][.
 *
 *  $CLASS        NexgenGAPConfig
 *  $VERSION      0.01 .seVered.][. initial version
 *  $CONTACT      channingd@hotmail.com
 *  $DESCRIPTION  Configuration class for the help plugin.
 *
 **************************************************************************************************/
class NexgenGAPConfig extends ReplicationInfo;

var NexgenGAP xControl;                             // Help Plugin controller.

// Special settings.
var config int lastInstalledVersion;              // Last installed version of the plugin.

// Data transfer control.
var int dynamicChecksums[2];                      // Checksum for the dynamic replicated variables.
var int dynamicChecksumModifiers[2];              // Dynamic data checksum salt.
var int updateCounts[2];                          // How many times the settings have been updated
                                                  // during the current game. Used to detect setting
                                                  // changes clientside.
                                                  
// General settings.
var int generalSettingsChecksum;                  // Checksum for the general settings variables.

var config  GAPURL;										// URL for GAP Search
var config  GAPSortOrder; 							// Ascending, Descending
var GAPUserName;											// if we ever get to use it.			
var GAPPassword;








var config bool enableMoreSettings;
var config bool enableHelpTab;
var config bool enableKeyBindregion;
var config bool enableUUregion;
var config bool enableButtonregion;
var config bool autoReconnect;

var config string buttonHeader;
var config string button1;
var config string button2;
var config string button3;
var config string url1;
var config string url2;
var config string url3;
var config string command1a;
var config string command1b;
var config string command2a;
var config string command2b;
var config string command3a;
var config string command3b;
var config string command4a;
var config string command4b;
var config string command5a;
var config string command5b;
var config string keybindtext1;
var config string keybindtext2;
var config string keybindtext3;

var config string bindCommand[3];


// Events.
const EVENT_NexgenHelpPluginConfigChanged = "NexgenHelpPlugin_config_changed";

// Config types.
const CT_GeneralSettings = 0;                // General Settings.
const CT_DetailedSettings = 1;               // Detailed settings.


/***************************************************************************************************
 *
 *  $DESCRIPTION  Replication block.
 *
 **************************************************************************************************/
replication {

	reliable if (role == ROLE_Authority)
		//Config settings.
    buttonHeader,button1,button2,button3,url1,url2,url3,
    command1a,command1b,command2a,command2b,command3a,command3b,command4a,command4b,command5a,command5b,
    keybindtext1,keybindtext2,keybindtext3,
    enableMoreSettings,enableHelpTab,enableKeyBindregion,enableUUregion,enableButtonregion,autoReconnect,
    
    bindCommand,

    // Data transfer control.
		dynamicChecksums, dynamicChecksumModifiers, updateCounts;
}


/***************************************************************************************************
 *
 *  $DESCRIPTION  Calculates a checksum of the replicated dynamic variables.
 *  $PARAM        configType  The configuration type for which the checksum is to be calculated.
 *  $REQUIRE      configType == CT_UTStatsClientSettings
 *  $RETURN       The checksum of the replicated variables.
 *
 **************************************************************************************************/
simulated function int calcDynamicChecksum(byte configType) {
	local int checksum;
	local int index;

	checksum += dynamicChecksumModifiers[configType];

	switch (configType) {
		case CT_GeneralSettings: //  General settings config type.
			checksum += int(enableMoreSettings)  << 1 |
                  int(enableHelpTab)       << 2 |
                  int(enableKeyBindregion) << 3 |
                  int(enableUUregion)      << 4 |
                  int(enableButtonregion)  << 5 |
                  int(autoReconnect)       << 6 ;
			break;
			
		case CT_DetailedSettings: //  Detailed settings config type.
			checksum += len(buttonHeader)        +
                  len(button1)             +
                  len(button2)             +
                  len(button3)             +
                  len(url1)                +
                  len(url2)                +
                  len(url3)                +
                  len(keybindtext1)        +
                  len(keybindtext2)        +
                  len(keybindtext3)        ;
      for (index = 0; index < arrayCount(bindCommand); index++) {
				checksum += len(bindCommand[index]);
    }
			break;
  }

	return checksum;
}


/***************************************************************************************************
 *
 *  $DESCRIPTION  Updates the checksums for the dynamic replication info.
 *  $ENSURE       foreach(type => dynamicChecksum in dynamicChecksums)
 *                  dynamicChecksum == calcDynamicChecksum(type)
 *
 **************************************************************************************************/
function updateDynamicChecksums() {
	local byte index;

	for (index = 0; index < arrayCount(dynamicChecksums); index++) {
		updateChecksum(index);
	}
}


/***************************************************************************************************
 *
 *  $DESCRIPTION  Updates the checksums for the current replication info.
 *  $PARAM        configType  The configuration type for which the checksum is to be calculated.
 *  $ENSURE       dynamicChecksums[configType] == calcDynamicChecksum(configType)
 *
 **************************************************************************************************/
function updateChecksum(byte configType) {
	dynamicChecksumModifiers[configType] = rand(maxInt);
	dynamicChecksums[configType] = calcDynamicChecksum(configType);
}


/***************************************************************************************************
 *
 *  $DESCRIPTION  Loads the plugins configuration.
 *  $OVERRIDE
 *
 **************************************************************************************************/
function preBeginPlay() {

	xControl =NexgenGAP(owner);
}


/***************************************************************************************************
 *
 *  $DESCRIPTION  Automatically installs the Nexgen GAP Seach plugin.
 *  $ENSURE       lastInstalledVersion >= xControl.versionNum
 *
 **************************************************************************************************/
function install() {

	if (lastInstalledVersion < 100) installVersion100();
	if (lastInstalledVersion < 101) installVersion101();
	if (lastInstalledVersion < 102) installVersion102();
	if (lastInstalledVersion < 103) installVersion103();
	//if (lastInstalledVersion < 104) installVersion104();
	// etc.

	if (lastInstalledVersion < xControl.versionNum) {
		lastInstalledVersion = xControl.versionNum;
		saveConfig();
	}
}


/***************************************************************************************************
 *
 *  $DESCRIPTION  Automatically installs version 100 of the Nexgen Help plugin.
 *
 **************************************************************************************************/
function installVersion100() {
  buttonHeader="Online Help";
  button1="Button1 Text";
  button2="Button2 Text";
  button3="Button3 Text";
  url1="start http://www.example.org";
  url2="start http://www.example.net";
  url3="start http://www.example.com";
  command1a="!nscstats";
  command1b="(View the ServerRankings)";
  command2a="!rules";
  command2b="(View the ServerRules)";
  command3a="!vote";
  command3b="(Open Mapvote)";
}


/***************************************************************************************************
 *
 *  $DESCRIPTION  Automatically installs version 101 of the Nexgen Help plugin.
 *
 **************************************************************************************************/
function installVersion101() {
  enableHelpTab = True;
  enableKeyBindregion = True;
  enableUUregion = True;
  enableButtonregion = True;
  keybindtext1="Suicide";
  keybindtext2="Toogle SmartCTF Stats on/off";
  keybindtext3="Toogle UUHud on/off";
  bindCommand[0]="suicide";
  bindCommand[1]="mutate smartctf showstats";
  bindCommand[2]="mutate universalunreal togglehud";
}


/***************************************************************************************************
 *
 *  $DESCRIPTION  Automatically installs version 102 of the Nexgen Help plugin.
 *
 **************************************************************************************************/
function installVersion102() {
  command2a="!rules";
  command2b="(View the ServerRules)";
  command3a="!vote";
  command3b="(Open Mapvote)";
  command4a="";
  command4b="";
  command5a="";
  command5b="";
}


/***************************************************************************************************
 *
 *  $DESCRIPTION  Automatically installs version 103 of the Nexgen Help plugin.
 *
 **************************************************************************************************/
function installVersion103() {
  enableMoreSettings = True;
  autoReconnect = False;
}


/***************************************************************************************************
 *
 *  $DESCRIPTION  Initializes the configuration.
 *
 **************************************************************************************************/
function initialize() {
	local int index;

	// Last thing to do is to make sure all the checksums are up to date.
	updateDynamicChecksums();
	for (index = 0; index < arrayCount(dynamicChecksums); index++) {
		updateCounts[index] = 1;
	}
}

defaultproperties
{
}
