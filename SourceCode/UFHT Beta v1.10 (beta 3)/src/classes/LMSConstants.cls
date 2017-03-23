/**
  * @Class Name: LMSConstants
  * @Description: Class to store the license management constants
  * ====================================================================================================================
  *       Version   | Date        | Author             | Comments
  * --------------------------------------------------------------------------------------------------------------------
  *       1.0       | 02/23/2017  | Eternus Solutions  | 1. Initial Draft
  * ====================================================================================================================
  **/
public class LMSConstants {

    public static final String FEATURE_FHT = 'FEATURE_FHT';
    public static final String APPLICATION_NAME = 'Ultra FieldHistory Tracker';
    public static final String HEADER_GRANT_TYPE = 'grant_type';
    public static final String HEADER_CLIENT_ID = 'client_id';
    public static final String HEADER_CLIENT_SECRET = 'client_secret';
    public static final String HEADER_USERNAME = 'username';
    public static final String HEADER_PASSWORD = 'password';
    public static final String GRANT_TYPE_PASSWORD = 'password';
    public static final String CONTENT_TYPE_JSON = 'application/json';
    public static final String AUTHORIZATION_KEY_FOR_HEADER = 'Authorization';
    public static final String AUTHORIZATION_VALUE_FOR_HEADER = 'OAuth ';
    public static final String CONTENT_TYPE_KEY_FOR_HEADER = 'Content-Type';    
    public static final String SF_LOGIN_ENDPOINT = 'https://login.salesforce.com/services/oauth2/token';
    
    public static final String MSG_ENDPOINT_NOT_CONFIGURED = 'Endpoint for communicating with license management app not configured. Please contact your Eternus consultant';
    public static final String MSG_INVALID_LICENSE = 'You do not have sufficient licenses to install Ultra FieldHistory Tracker. Please contact sales@eternussolutions.com to purchase one.';
    public static final String MSG_INVALID_LICENSE_NOTIFICATION = 'You do not have sufficient licenses to install Ultra FieldHistory Tracker. Please contact <a href="mailto:sales@eternussolutions.com?cc=appsupport@eternussolutions.com">sales@eternussolutions.com</a> to purchase one.';
    public static final String LMS_ENDPOINT = '/services/apexrest/LicenseManagement';
    public static final String LMS_ENDPOINT_SETTING = 'LICENSE_MGMT_ENDPOINT';
    public static final String PARAM_SUBSCRIBER_ID = 'sub';
    public static final String PARAM_IS_INSTALL = 'isInstall';
    public static final String PARAM_IS_UPGRADE = 'isUpgrade';
    public static final String PARAM_PACKAGE_NAME = 'packageName';
    
    public static final String LICENSE_STATUS_UNINSTALLED = 'Uninstalled';
    public static final String LICENSE_STATUS_EXPIRED = 'Expired';
    public static final String LICENSE_STATUS_SUSPENDED = 'Suspended';
    public static final String LICENSE_STATUS_NO_EXPIRY = 'Does not expire';
    
    public static final String MSG_PACKAGE_RENEWAL_REMINDER = 'Your subscription for Ultra FieldHistory Tracker is about to expire in <b>DATEREMAINING day(s)</b>. Please contact <a href="mailto:sales@eternussolutions.com?cc=appsupport@eternussolutions.com">sales@eternussolutions.com</a> for license renewal (<a href="javascript:void(0)" onClick="return renewalLicense();" >Purchase Now</a>)';
    public static final String MSG_PACKAGE_EXPIRED = 'Your subscription for Ultra FieldHistory Tracker has expired. Please contact <a href="mailto:sales@eternussolutions.com?cc=appsupport@eternussolutions.com">sales@eternussolutions.com</a> for license renewal (<a href="javascript:void(0)" onClick="return renewalLicense();" >Purchase Now</a>)';
    public static final String MAIL_SUBJECT_EXPIRY_NOTIFICATION = '[URGENT] Ultra FieldHistory Tracker License Expiration';
    public static final String MSG_PACKAGE_SUSPENDED = 'Your subscription for Ultra FieldHistory Tracker has been suspended. Please contact <a href="mailto:sales@eternussolutions.com?cc=appsupport@eternussolutions.com">sales@eternussolutions.com</a> for further information';
    public static final String LMA_LICENSE_CHECK_SITE_DOMAIN = 'https://devp-esplindia-devp.cs6.force.com';
    //public static final String LMA_LICENSE_CHECK_ENDPOINT = '/services/apexrest/LicenseManagement';
    
    public static final String MAIL_SUBJECT_INADEQUATE_LICENSE_NOTIFICATION = '[URGENT] Inadequate licenses for Ultra FieldHistory Tracker';
    
}