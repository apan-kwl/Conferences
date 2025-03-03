#region header
Configuration Demo1
{
    $Credsglobaladmin = Get-Credential -Message "Admin Credentials"

    $OrganizationName = $Credsglobaladmin.UserName.Split('@')[1]
    Import-DscResource -ModuleName Microsoft365DSC

    Node localhost
    {
    #endregion
        AADGroupsNamingPolicy GNP
        {
            CustomBlockedWordsList        = @("CEO","President","Secret");
            Ensure                        = "Present";
            GlobalAdminAccount            = $Credsglobaladmin;
            IsSingleInstance              = "Yes";
            PrefixSuffixNamingRequirement = "[Title]TestNik[Company][GroupName][Office]Canada";
        }
        AADMSGroupLifecyclePolicy GLP
        {
            AlternateNotificationEmails = @("admin@$OrganizationName");
            Ensure                      = "Present";
            GlobalAdminAccount          = $Credsglobaladmin;
            GroupLifetimeInDays         = 777;
            IsSingleInstance            = "Yes";
            ManagedGroupTypes           = "All";
        }
        TeamsMeetingPolicy TMP
        {
            Identity                                   = "M365 Virtual Saturday - Ottawa";
            AllowAnonymousUsersToStartMeeting          = $False;
            AllowChannelMeetingScheduling              = $True;
            AllowCloudRecording                        = $True;
            AllowExternalParticipantGiveRequestControl = $False;
            AllowIPVideo                               = $True;
            AllowMeetNow                               = $True;
            AllowOutlookAddIn                          = $True;
            AllowParticipantGiveRequestControl         = $True;
            AllowPowerPointSharing                     = $True;
            AllowPrivateMeetingScheduling              = $True;
            AllowPSTNUsersToBypassLobby                = $False;
            AllowSharedNotes                           = $True;
            AllowTranscription                         = $False;
            AllowWhiteboard                            = $True;
            AutoAdmittedUsers                          = "EveryoneInCompany";
            Ensure                                     = "Present";
            GlobalAdminAccount                         = $Credsglobaladmin;
            MediaBitRateKb                             = 50000;
            ScreenSharingMode                          = "EntireScreen";
        }
        #region footer
    }
}
Demo1 -ConfigurationData .\ConfigurationData.psd1
Start-DscConfiguration Demo1 -Verbose -Force -Wait
#endregion