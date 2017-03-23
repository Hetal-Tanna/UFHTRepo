/**
  * @Class Name: LmaCommunicationManager 
  * @Description: Class to perform communication with the Eternus LMA org
  * ====================================================================================================================
  *       Version   | Date        | Author             | Comments
  * --------------------------------------------------------------------------------------------------------------------
  *       1.0       | 02/23/2017  | Eternus Solutions  | 1. Initial Draft
  * ====================================================================================================================
  **/
global with sharing class LmaCommunicationManager {
    
    // Wrapper to store the session information
    global class LoginInformation {
        public String access_token;
        public String instance_url;
        public String id;
        public String token_type;
        public String issued_at;
        public String signature;
    }

    // Wrapper to store license information
    global class LicenseInformation {
        public Boolean isValid;
        public String status;
        public String expiryDate;
        public String licenseId;
    }

    // Wrapper for license information check request
    global class LicenseCheckRequest {
        public String orgId;
        public Boolean isInstall;
        public Boolean isUpgrade;
        public Boolean isUninstall;
    }

    // Wrapper for license update request
    global class LicenseUpdateRequest {
        public String orgId;
        public String packageName;
        public String licenseId;
        public Boolean isUninstall;
    }

    // Wrapper for license update response
    global class LicenseUpdateResponse {
        public String isSuccess;
        public String licenseId;
        public String message;
    }

    /**
     * @Author: Eternus Solutions
     * @Description: Method to perform the license check in the LMA org
     * @Param:1.loginInfo
     *        2.isInstall
     *        3.isUpgrade
     * @Return: LicenseInformation wrapper instance
     * @Date: 24/02/2017
     **/
    
    public static LicenseInformation checkLicenseValidity(Boolean isInstall, Boolean isUpgrade) {
        final Endpoint_Settings__c lmaEndpointSetting = 
            Endpoint_Settings__c.getAll().get(LMSConstants.LMS_ENDPOINT_SETTING);
        
        String response = '';
        // Form the request for license validity check
        String endpoint = lmaEndpointSetting.Endpoint_Url__c + LMSConstants.LMS_ENDPOINT;
        endpoint += '?' + LMSConstants.PARAM_SUBSCRIBER_ID + '=' + UserInfo.getOrganizationId()
        + '&' + LMSConstants.PARAM_IS_INSTALL + '=' + isInstall
        + '&' + LMSConstants.PARAM_IS_UPGRADE + '=' + isUpgrade
        + '&' + LMSConstants.PARAM_PACKAGE_NAME + '=' + EncodingUtil.urlEncode(LMSConstants.APPLICATION_NAME, 'UTF-8');
        
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint(endpoint);
        req.setHeader(LMSConstants.CONTENT_TYPE_KEY_FOR_HEADER, LMSConstants.CONTENT_TYPE_JSON);
        req.setTimeout(12000);

        response = new Http().send(req).getBody();
        // Parse the response and return
        return (LicenseInformation)JSON.deserialize(response, LicenseInformation.class);
    }

    /**
     * @Author: Eternus Solutions
     * @Description: Method to update the license status in the LMA org
     * @Param:1.loginInfo
     *        2.updateRequest
     * @Return: LicenseUpdateResponse wrapper instance
     * @Date: 24/02/2017
     **/
     global static LicenseUpdateResponse updateLicense(LicenseUpdateRequest updateRequest) {
        final Endpoint_Settings__c lmaEndpointSetting = 
            Endpoint_Settings__c.getAll().get(LMSConstants.LMS_ENDPOINT_SETTING);
        
        String response = '';
        
        // Form the request for license validity check
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint(lmaEndpointSetting.Endpoint_Url__c + LMSConstants.LMS_ENDPOINT);
        req.setBody(JSON.serialize(updateRequest));
        req.setHeader(LMSConstants.CONTENT_TYPE_KEY_FOR_HEADER, LMSConstants.CONTENT_TYPE_JSON);
        req.setTimeout(12000);

        response = new Http().send(req).getBody();

        // Parse the response and return
        return (LicenseUpdateResponse)JSON.deserialize(response, LicenseUpdateResponse.class);
    }
    
}