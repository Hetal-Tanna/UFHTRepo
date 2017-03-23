/**
  * Class Name: LicenseCheckScheduler 
  * @Description: Scheduler class that runs everyday to perform the license check
  * ====================================================================================================================
  *       Version   | Date        | Author             | Comments
  * --------------------------------------------------------------------------------------------------------------------
  *       1.0       | 02/23/2017  | Eternus Solutions  | 1.Initial Draft
  * ====================================================================================================================
  **/
global with sharing class LicenseCheckScheduler implements System.Schedulable {

    static final Set<Integer> SET_REMINDER_DAYS = new Set<Integer> { 15, 5 };

    /**
     * @Author: Eternus Solutions
     * @Description: Method to be called from the scheduler
     * @Param: System.SchedulableContext sc
     * @Return:
     * @Date: 24/02/2017
     **/
    global void execute(System.SchedulableContext sc) {
        // If this method is being executed, it means this is called from base class
        // Check for both the licenses
        checkIfLicenseValidFuture(LMSConstants.FEATURE_FHT, true, false);
    }
    
    /**
     * @Author: Eternus Solutions
     * @Description: Method to be called to check renewal of license
     * @Param:
     * @Return: License information wrapper instance
     * @Date: 24/02/2017
     **/
    public static LmaCommunicationManager.LicenseInformation renewal() {
        return checkIfLicenseValid(LMSConstants.FEATURE_FHT, true, false);
    }
    
    /**
     * @Author: Eternus Solutions
     * @Description: Method to check the license details and update the custom settings
     * @Param: 1. feature
     *         2. isUpdateCustomSettings
     *         3. Boolean isInstall
     * @Return: License information wrapper instance
     * @Date: 24/02/2017
     **/
    public static LmaCommunicationManager.LicenseInformation checkIfLicenseValid(String feature, Boolean isUpdateCustomSettings, Boolean isInstall) {
        //LmaCommunicationManager.LoginInformation loginInfo;
        
        // Get the available features in org
        Boolean isFeatureInstalled = LMSConfigManager.getFeatureDetails(feature) != null;
        if (isFeatureInstalled || isInstall) {
            return doLicenseCheck(isUpdateCustomSettings);
        }
        return null;
        
        /*if (isFeatureInstalled || isInstall) {
            // Get the session ID for LMA org
            try {
                loginInfo = LmaCommunicationManager.getLmaSessionId();
            } catch (Exception ex) {
                // Just catching the exception here as the loginInfo would already
                // send the email to developer for any callout exceptions
            }
        
            
        }
        return null;*/
    }

    /**
     * @Author: Eternus Solutions
     * @Description: Future method to be called from scheduler for license check
     * @Param:1. feature
     *        2. isUpdateCustomSettings
     *        3. Boolean isInstall
     * @Return:
     * @Date: 24/02/2017
     **/
    // 
    @future(callout=true)
    public static void checkIfLicenseValidFuture(String feature, Boolean isUpdateCustomSettings, Boolean isInstall) {
        checkIfLicenseValid(feature, isUpdateCustomSettings, isInstall);
    }

    /**
     * @Author: Eternus Solutions
     * @Description: Method to perform set of operations for license check and response handling
     * @Param:1. loginInfo
     *        2. isUpdateCustomSettings
     * @Return: License information wrapper instance
     * @Date: 24/02/2017
     **/
    private static LmaCommunicationManager.LicenseInformation doLicenseCheck(Boolean isUpdateCustomSettings) {
        // Perform the callout to LMA
        LmaCommunicationManager.LicenseInformation licenseInfo = 
            LmaCommunicationManager.checkLicenseValidity(
                false,
                false
            );

        // If the custom settings are not to be updated then return the license info
        if (!isUpdateCustomSettings) {
            return licenseInfo;
        }

        // Update the custom setting values
        Feature_Installation_Master__c featureInfo = calculateFeatureValues(LMSConstants.FEATURE_FHT, licenseInfo);

        if (Feature_Installation_Master__c.sObjectType.getDescribe().isUpdateable()) {
            update featureInfo;
        }
        
        // Send the reminder mail to customer on license expiration 
        if (SET_REMINDER_DAYS.contains(Integer.valueOf(featureInfo.License_Days_Remaining__c))) {
            EmailTemplate et = [
                SELECT Id
                     , HtmlValue
                  FROM EmailTemplate
                 WHERE DeveloperName
                  LIKE '%License_Expiration_Notification_Template%'
                 LIMIT 1
            ];
            
            Document appLogoClone = [
                SELECT Id
                     , body 
                  FROM Document 
                 WHERE Name LIKE '%UFHT_AppLogo%'
                 LIMIT 1
            ];

            String emailBody = et.HtmlValue;
           
            emailBody = emailBody.replace('!APP_LOGO!', URL.getSalesforceBaseUrl().toExternalForm()
                                                        + '/servlet/servlet.ImageServer?'
                                                        + 'id=' + appLogoClone.id
                                                        + '&oid=' + UserInfo.getOrganizationId())
                .replace('!USER_NAME!', UserInfo.getName())
                .replace('!APP_NAME!', LMSConstants.APPLICATION_NAME)
                .replace('!DAYS!', '' + featureInfo.License_Days_Remaining__c);

            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setHtmlBody(emailBody);
            email.setSubject(LMSConstants.MAIL_SUBJECT_EXPIRY_NOTIFICATION);
            email.setTargetObjectId(UserInfo.getUserId());
            email.setSaveAsActivity(false);
            
            Messaging.sendEmail(new List<Messaging.Email> { email });
        }

        return licenseInfo;
    }

    /**
     * @Author: Eternus Solutions
     * @Description: Method to calculate feature installation master setting values
     * @Param:1. featureName
     *        2. licenseInfo
     * @Return: Updated custom setting instance
     * @Date: 24/02/2017
     **/
    public static Feature_Installation_Master__c calculateFeatureValues (String featureName, LmaCommunicationManager.LicenseInformation licenseInfo) {
        Feature_Installation_Master__c featureInfo = LMSConfigManager.getFeatureDetails(featureName);
        
            if (featureInfo == null) {
                return null;
            }
    
            if (Schema.sObjectType.Feature_Installation_Master__c.fields.License_Record_ID__c.isAccessible() &&
                Schema.sObjectType.Feature_Installation_Master__c.fields.License_Record_ID__c.isUpdateable()) {
                featureInfo.License_Record_ID__c = licenseInfo.isValid ? Id.valueOf(licenseInfo.licenseId) : null;
            }
            
            if (Schema.sObjectType.Feature_Installation_Master__c.fields.License_Expiration_Date__c.isAccessible() &&
                Schema.sObjectType.Feature_Installation_Master__c.fields.License_Expiration_Date__c.isUpdateable() ) {
                featureInfo.License_Expiration_Date__c = licenseInfo.expiryDate != null ? 
                    (licenseInfo.isValid ? Date.valueOf(licenseInfo.expiryDate) : null) :
                    null ;
            }
            
            if (Schema.sObjectType.Feature_Installation_Master__c.fields.License_Days_Remaining__c.isAccessible() &&
                Schema.sObjectType.Feature_Installation_Master__c.fields.License_Days_Remaining__c.isUpdateable()) {
                featureInfo.License_Days_Remaining__c = licenseInfo.expiryDate != null ? 
                    (licenseInfo.isValid ? System.today().daysBetween(featureInfo.License_Expiration_Date__c) : null) :
                    null;
            }
            
            if (Schema.sObjectType.Feature_Installation_Master__c.fields.Is_Active__c.isAccessible() &&
                Schema.sObjectType.Feature_Installation_Master__c.fields.Is_Active__c.isUpdateable()) {
                featureInfo.Is_Active__c = licenseInfo.isValid;
            }
            
            if (Schema.sObjectType.Feature_Installation_Master__c.fields.Never_Expires__c.isAccessible() &&
                Schema.sObjectType.Feature_Installation_Master__c.fields.Never_Expires__c.isUpdateable()) {
                featureInfo.Never_Expires__c = licenseInfo.expiryDate != null ? false : true ;
            }
            
            if (Schema.sObjectType.Feature_Installation_Master__c.fields.Is_Active__c.isAccessible()) {
                    
                if (Schema.sObjectType.Feature_Installation_Master__c.fields.License_Days_Remaining__c.isAccessible()) {
                    
                    if (LMSConstants.LICENSE_STATUS_EXPIRED.equalsIgnoreCase(licenseInfo.status)) {
                        featureInfo.Is_Active__c = false;
                        featureInfo.License_Days_Remaining__c = 0;
                    }           
                    if (LMSConstants.LICENSE_STATUS_SUSPENDED.equalsIgnoreCase(licenseInfo.status)) {
                        featureInfo.Is_Active__c = false;
                        featureInfo.License_Days_Remaining__c = -1;
                    }
                }   
            }
        return featureInfo;
    }
}