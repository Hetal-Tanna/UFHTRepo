/**
  * @Class Name: LMSConfigManager 
  * @Description: Class for getting the config for LMS
  * ====================================================================================================================
  *       Version   | Date        | Author             | Comments
  * --------------------------------------------------------------------------------------------------------------------
  *       1.0       | 02/23/2017  | Eternus Solutions  | 1. Initial Draft
  * ====================================================================================================================
  **/
global with sharing class LMSConfigManager {
    
    public class InvalidLicenseException extends Exception {}
    
    // Keeping these as private as this is some confidential information
    static final String SCHEDULER_PREFIX_NAME = 'UFHTLicenseCheck';
    static final String SALESFORCE_SANDBOX_ENDPOINT = 'https://devp-esplindia-devp.cs6.force.com';
    static final String SALESFORCE_PROD_ENDPOINT = 'https://eternussolutions.secure.force.com/LicenseManagement';
    
    static final String UNINSTALL_EXCEPTION_MAIL_SUBJECT = 'Ultra FieldHistory Tracker uninstallation error';
    static String UNINSTALL_EXCEPTION_MAIL_BODY = 'There has been an error while trying to uninstall Ultra FieldHistory Tracker.'
        + 'Please find the subscriber information below\n\n'
        + '------------------------------ \n'
        + 'Organization ID: ' + UserInfo.getOrganizationId() + ' \n'
        + 'User ID: ' + UserInfo.getUserId() + ' \n'
        + 'Package Version: ' + System.requestVersion();
    
    static final String APPSUPPORT_MAIL_ADDRESS = 'appsupport@eternussolutions.com';
    
    // Store the current environment here
    // @TODO - Change the value to PKG before creating the MANAGED RELEASE package
    public Enum ENV { DEV, PKG }
    public static final ENV CURRENT_ENV = ENV.PKG;
    
    /**
     * @Author: Eternus Solutions
     * @Description: Method to get the status of installation for add-ons
     * @Param:
     * @Return: Boolean value that denotes whether the license is valid or not
     * @Date: 24/02/2017
     **/
    public static Boolean getIfLicenseValid () {
        String featureName = LMSConstants.FEATURE_FHT;
        Feature_Installation_Master__c feature = getFeatureDetails(featureName);
        return feature != null && 
            (feature.Is_Active__c && 
                (feature.License_Days_Remaining__c != null || feature.Never_Expires__c));
    }

    /**
     * @Author: Eternus Solutions
     * @Description: Method to get the feature installation instance
     * @Param:
     * @Return: Feature installation instance
     * @Date: 24/02/2017
     **/
    public static Feature_Installation_Master__c getFeatureDetails (String featureName) {
        return Feature_Installation_Master__c.getAll().get(featureName);
    }

    /**
     * @Author: Eternus Solutions
     * @Description: Future method for license validation
     * @Param:
     * @Return: 
     * @Date: 24/02/2017
     **/
    @future(callout=true)
    global static void validateLicenseFuture() {
        validateLicense();
    }
    
    /**
     * @Author: Eternus Solutions
     * @Description: Method to validate license on installation
     * @Param:
     * @Return: 
     * @Date: 24/02/2017
     **/
    public static void validateLicense() {
        //LmaCommunicationManager.LoginInformation loginInfo = LmaCommunicationManager.getLmaSessionId();
        LmaCommunicationManager.LicenseInformation licenseInfo = LmaCommunicationManager.checkLicenseValidity(true, false);

        if (licenseInfo.isValid) {
            Feature_Installation_Master__c feature = new Feature_Installation_Master__c(
                    Name = LMSConstants.FEATURE_FHT,
                    Feature_Installed_By__c = UserInfo.getUserId(),
                    Installation_Date_Time__c = System.Datetime.now(),
                    Is_Active__c = true
            );
            
            if (Feature_Installation_Master__c.sObjectType.getDescribe().isCreateable()) {
              insert feature;
            }
         

            Feature_Installation_Master__c toUpdate = LicenseCheckScheduler.calculateFeatureValues(LMSConstants.FEATURE_FHT, licenseInfo);
            if (Feature_Installation_Master__c.sObjectType.getDescribe().isUpdateable()) {
                update toUpdate;
            }
        } else {
            //throw new InvalidLicenseException(LMSConstants.MSG_INVALID_LICENSE);
            EmailTemplate et = [
                SELECT Id
                     , HtmlValue
                  FROM EmailTemplate
                 WHERE DeveloperName
                  LIKE '%InAdequate_License_For_Package_Installation%'
                 LIMIT 1
            ];
            
            Document appLogoClone = [
                SELECT Id
                     , body 
                  FROM Document 
                 WHERE Name LIKE '%UFHT_AppLogo%'
                 LIMIT 1
            ];
            
            User objUser = [
                SELECT Id
                     , Name
                  FROM User 
                 WHERE Profile.Name LIKE '%System Administrator%'
                   AND IsActive = true
              ORDER BY LastLoginDate DESC
                 LIMIT 1
            ];
            
            String emailBody = et.HtmlValue;
           
            emailBody = emailBody.replace('!APP_LOGO!', URL.getSalesforceBaseUrl().toExternalForm()
                                                        + '/servlet/servlet.ImageServer?'
                                                        + 'id='+appLogoClone.id
                                                        + '&oid='+UserInfo.getOrganizationId())
                .replace('!USER_NAME!', objUser.Name);
            Messaging.sendEmail(new List<Messaging.Email> { 
                generateEmail(
                    LMSConstants.MAIL_SUBJECT_INADEQUATE_LICENSE_NOTIFICATION,
                    emailBody,
                    objUser.Id
                )
            });
        }
        
    }
    /**
     * @Author: Eternus Solutions
     * @Description: Method to generate email with given body and sender ID
     * @Param:
     * @Return: 
     * @Date: 09/03/2017
     **/
    public static Messaging.Email generateEmail(String subject, String mailBody, Id receiverId) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setHtmlBody(mailBody);
        mail.setTargetObjectId(receiverId);
        mail.setSubject(subject);
        mail.setSaveAsActivity(false);
        return mail;
    }
    
    /**
     * @Author: Eternus Solutions
     * @Description: Method to be run from the post uninstall script
     * @Param:
     * @Return: 
     * @Date: 24/02/2017
     **/
    global static void onUninstall() {
        //LmaCommunicationManager.LoginInformation loginInfo = LmaCommunicationManager.getLmaSessionId();
        Feature_Installation_Master__c feature = getFeatureDetails(LMSConstants.FEATURE_FHT);
        
        Boolean isSendMail = false;
        
        LmaCommunicationManager.LicenseUpdateRequest updateRequest = new LmaCommunicationManager.LicenseUpdateRequest();
        updateRequest.orgId = UserInfo.getOrganizationId();
        updateRequest.packageName = LMSConstants.APPLICATION_NAME;
        updateRequest.licenseId = feature.License_Record_ID__c;
        updateRequest.isUninstall = true;
        try {
            if (Limits.getLimitCallouts() != 0) {
                LmaCommunicationManager.updateLicense(updateRequest);
            } else {
                isSendMail = true;
                UNINSTALL_EXCEPTION_MAIL_BODY += '\n\nException Information: Too Many Callouts: 1';
            }
        } catch (Exception ex) {
            isSendMail = true;
            UNINSTALL_EXCEPTION_MAIL_BODY += '\n\nException Information: ' + ex.getMessage() + '-' + ex.getStackTraceString();
        }
        
        if (isSendMail) {
            Messaging.Email email = generateEmail(
                UNINSTALL_EXCEPTION_MAIL_SUBJECT,
                UNINSTALL_EXCEPTION_MAIL_BODY,
                APPSUPPORT_MAIL_ADDRESS
            );
            
            Messaging.sendEmail(new List<Messaging.Email> { email });
        }
        
        if (Feature_Installation_Master__c.sObjectType.getDescribe().isDeletable()) {
           delete feature;
        }
    }
    
    /**
     * @Author: Eternus Solutions
     * @Description: Method to kickoff the scheduler for LMS
     * @Param:
     * @Return: 
     * @Date: 24/02/2017
     **/
    public static Id kickoffLmsScheduler() {
        /* List<CronTrigger> lstScheduleJobs = [SELECT 
                                                  Id
                                              FROM CronTrigger 
                                              WHERE CronJobDetail.Name =: SCHEDULER_PREFIX_NAME + UserInfo.getOrganizationId() AND
                                              State IN ('WAITING','ACQUIRED','EXECUTING','BLOCKED','PAUSED_BLOCKED','PAUSED') 
                                              LIMIT 1];
                                      
        if(lstScheduleJobs.isEmpty()) {*/
            return System.schedule(SCHEDULER_PREFIX_NAME + UserInfo.getOrganizationId(), '0 0 0 * * ?', new LicenseCheckScheduler());
        /*}
        return null;
        */
        
    }
    
    /**
     * @Author: Eternus Solutions
     * @Description: Method to create the endpoint settings on package installation
     * @Param:
     * @Return: 
     * @Date: 24/02/2017
     **/
    public static void createEndpoint() {
        Endpoint_Settings__c endpoint = new Endpoint_Settings__c(
            Name = LMSConstants.LMS_ENDPOINT_SETTING,
            Is_Active__c = true
        );
        
        if (CURRENT_ENV == ENV.DEV) {
            if (Schema.sObjectType.Endpoint_Settings__c.fields.Endpoint_Url__c.isAccessible() &&
                Schema.sObjectType.Endpoint_Settings__c.fields.Endpoint_Url__c.isUpdateable() && 
                Schema.sObjectType.Endpoint_Settings__c.fields.Endpoint_Url__c.isCreateable()) {
                endpoint.Endpoint_Url__c = SALESFORCE_SANDBOX_ENDPOINT;
            }
        } else if (CURRENT_ENV == ENV.PKG) {
            if (Schema.sObjectType.Endpoint_Settings__c.fields.Endpoint_Url__c.isAccessible() &&
                Schema.sObjectType.Endpoint_Settings__c.fields.Endpoint_Url__c.isUpdateable() &&
                Schema.sObjectType.Endpoint_Settings__c.fields.Endpoint_Url__c.isCreateable()) {
                 endpoint.Endpoint_Url__c = SALESFORCE_PROD_ENDPOINT;
            }
        }
        if (Endpoint_Settings__c.sObjectType.getDescribe().isCreateable()) {
            if(Endpoint_Settings__c.sObjectType.getDescribe().isAccessible()) {
                if(Endpoint_Settings__c.getInstance(LMSConstants.LMS_ENDPOINT_SETTING) == null) {
                    insert endpoint;
                }
            }
         }
    }
}