/**
  * @Class Name: RelatedListComponentExtension
  * @Description: Extension to show history records in detail page
  * ======================================================================================================
  *         Version   | Date        | Author             | Comments
  * ------------------------------------------------------------------------------------------------------
  *         1.0       | 16/01/2017  | Eternus Solutions  | 1. Initial Draft
  * =======================================================================================================
  **/
public with sharing class RelatedListComponentExtension {
    
    public String recordId { get; set; }
    public Boolean inlineFlag { get; set; }
    public boolean isValidLicense {get;set;}
    public String licenseMessages {get;set;}
    
     /**
      * @Author: Eternus Solutions
      * @Description: RelatedListComponentExtension constructor
      * @Param: Current package installation context.
      * @Return: NA
      * @Date: 16/01/2017
      **/
    public RelatedListComponentExtension(ApexPages.StandardController stdController) {
        recordId = string.valueOf(ApexPages.currentPage()).substringBetween('id=', '&');
        isValidLicense = LMSConfigManager.getIfLicenseValid(); 
        licenseMessages = getNotificationMessage();
        if(string.valueOf(ApexPages.currentPage()).contains('inline')) {
            inlineFlag = true;
        }else {
            inlineFlag = false;
        }
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Message to compile the reminder notification for package
      * @Param: none
      * @Return: null
      * @Date: 16/01/2017
      **/
    private String getNotificationMessage() {
        Feature_Installation_Master__c installDetails = LMSConfigManager.getFeatureDetails(LMSConstants.FEATURE_FHT);
    
        if (installDetails == null) {
            return LMSConstants.MSG_INVALID_LICENSE;
        }       
        String message;   
        String reminderMessage = LMSConstants.MSG_PACKAGE_RENEWAL_REMINDER;
        String expiredMessage = LMSConstants.MSG_PACKAGE_EXPIRED;
        String suspendedMessage = LMSConstants.MSG_PACKAGE_SUSPENDED;
    
        // Check for suspended package
        if (installDetails.Is_Active__c == false && installDetails.License_Days_Remaining__c == -1) {
            return suspendedMessage;
        }
    
        // If yes, then check if the remaining days is less than 15
        if (installDetails.License_Days_Remaining__c <= 15) {
            // Check if it is equal to zero
            if (installDetails.License_Days_Remaining__c == 0) {
                // If yes, then add the expired message
                message = expiredMessage;
            } else {
                // else add the less than 15 days message
                message = reminderMessage.replace('DATEREMAINING', '' + installDetails.License_Days_Remaining__c);
            }
        }
        
        if (!String.isBlank(message)) {
           return message;
        }
        
        if (!LMSConfigManager.getIfLicenseValid()) {
           return LMSConstants.MSG_INVALID_LICENSE;
        }        
        return null;
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Check License information for renewal 
      * @Param: none
      * @Return: NA
      * @Date: 16/01/2017
      **/
    public void renewalLicenseCheck() {
        LmaCommunicationManager.LicenseInformation renewalInfo;
        renewalInfo = LicenseCheckScheduler.renewal();
        if(renewalInfo != null && renewalInfo.isValid == true) {
           licenseMessages = getNotificationMessage();
        }
    }
}