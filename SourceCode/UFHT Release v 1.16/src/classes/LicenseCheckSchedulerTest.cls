/**
  * Class Name: LicenseCheckSchedulerTest 
  * @Description: This class contains unit tests for LMSConfigManager.cls
  * ====================================================================================================================
  *       Version   | Date        | Author             | Comments
  * --------------------------------------------------------------------------------------------------------------------
  *       1.0       | 28/02/2017  | Eternus Solutions  | 1.Initial Draft
  * ====================================================================================================================
  **/
@isTest(SeeAllData = false)
private class LicenseCheckSchedulerTest {
    
     /**
      * @Author: Eternus Solutions
      * @Description: Test method to verify whether the  License is valid or not.
      * @Expected Result: Creates Custom Setting Data
      * @Date: 01/03/2017
      **/
    @testSetup static void setupData() {
        // Create common test document
        Document document =  new Document();
        document.Name = 'UFHT_AppLogo';
        document.FolderId = [SELECT Id 
                               FROM Folder
                              WHERE Name = 'Ultra FieldHistory Tracker'].Id;
        document.Body = Blob.valueOf('muscles and bones');
        insert document;        
        // Create custom setting record for feature installation master
        insert new Endpoint_Settings__c(
            Name = LMSConstants.LMS_ENDPOINT_SETTING,
            Endpoint_Url__c = 'https://cs6.salesforce.com' + LMSConstants.LMS_ENDPOINT,
            Is_Active__c = true
         );
        
        List<Endpoint_Settings__c> endpointInstance = [
            SELECT Id
              FROM Endpoint_Settings__c
             WHERE Name =: LMSConstants.LMS_ENDPOINT_SETTING
             LIMIT 1
        ];
        
        insert new Feature_Installation_Master__c(
            Name = LMSConstants.FEATURE_FHT,
            Feature_Installed_By__c = UserInfo.getUserId(),
            Installation_Date_Time__c = System.now(),
            Is_Active__c = true,
            License_Days_Remaining__c = 365,
            License_Expiration_Date__c = System.today().addDays(365),
            License_Record_ID__c = 'a06N000000BuEN3'
        );
        
        System.assert(endpointInstance.isEmpty() == false
            , 'LicenseStatusCheckSchedulerTest.setupData - Endpoint_Settings__c not inserted');
    }
    
     /**
      * @Author: Eternus Solutions
      * @Description: Test method to check the status of License.
      * @Expected Result: 1. License record not created in custom setting.
      *                   2. Liscense record is null.
      *                   3. License Expiration date Mismatch.
      *                   4. License remaining days invalid.
      * @Date: 01/03/2017
      **/
    @isTest
    static void testLicenseCheckImmediate() {
        Test.setMock(HttpCalloutMock.class, new LicenseMgmtCalloutsMock());

        Test.startTest();            
            new LicenseCheckScheduler().execute(null);
        Test.stopTest();

        Feature_Installation_Master__c ufht = LMSConfigManager.getFeatureDetails(LMSConstants.FEATURE_FHT);
        System.assert(ufht != null
            , 'LicenseStatusCheckSchedulerTest.testLicenseCheckImmediate() - UFHT custom setting record is not created');

        System.assert(ufht.License_Record_ID__c != null
            , 'LicenseStatusCheckSchedulerTest.testLicenseCheckImmediate() - License record is null');

        System.assert(ufht.License_Expiration_Date__c != null && ufht.License_Expiration_Date__c == System.today().addDays(15)
            , 'LicenseStatusCheckSchedulerTest.testLicenseCheckImmediate() - Expiration dates do not match');

        System.assert(ufht.License_Days_Remaining__c != null && ufht.License_Days_Remaining__c.intValue() == 15
            , 'LicenseStatusCheckSchedulerTest.testLicenseCheckImmediate() - License days remaining invalid'); 
    
    }
    
     /**
      * @Author: Eternus Solutions
      * @Description: Test method to verify whether the License updated immediatly or not.
      * @Expected Result: 1. License Update not successful.
      *                   2. Invalid license id.
      *                   3. Invalid response message on Update License.
      * @Date: 01/03/2017
      **/
    @isTest
    static void updateLicenseImmediate() {

        Test.setMock(HttpCalloutMock.class, new LicenseMgmtCalloutsMock());
        Test.startTest();
            LmaCommunicationManager.LicenseUpdateRequest req = new LmaCommunicationManager.LicenseUpdateRequest();
            req.orgId = UserInfo.getOrganizationId();
            req.packageName = LMSConstants.APPLICATION_NAME;
            req.licenseId = 'a06N000000BuEN3';
            req.isUninstall = true;
            
            LmaCommunicationManager.LicenseUpdateResponse response = 
                LmaCommunicationManager.updateLicense( req);
        Test.stopTest();
    
        /*System.assert(response.message == null
            , 'LicenseStatusCheckSchedulerTest.updateLicenseImmediate() - Invalid response message');*/

        System.assert(response.isSuccess == '' + true
            , 'LicenseCheckSchedulerTest.updateLicenseImmediate() - Update not successful');

        System.assert(response.licenseId != null
            , 'LicenseCheckSchedulerTest.updateLicenseImmediate() - Invalid license id');
    }
}