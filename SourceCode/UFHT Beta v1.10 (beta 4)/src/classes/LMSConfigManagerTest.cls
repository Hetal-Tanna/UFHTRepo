/**
  * Class Name: LMSConfigManagerTest 
  * @Description: This class contains unit tests for LMSConfigManager.cls
  * ====================================================================================================================
  *       Version   | Date        | Author             | Comments
  * --------------------------------------------------------------------------------------------------------------------
  *       1.0       | 28/02/2017  | Eternus Solutions  | 1.Initial Draft
  * ====================================================================================================================
  **/
@isTest
public class LMSConfigManagerTest {
    
    /**
      * @Author: Eternus Solutions
      * @Description: Test method to verify whether the  License is valid or not.
      * @Expected Result: Method should return false
      * @Date: 01/03/2017
      **/
    static testMethod void getIfLicenseValidCase() {
        
        Boolean licenseValid = LMSConfigManager.getIfLicenseValid();
        Test.startTest();
        LMSConfigManager.getIfLicenseValid();
        Test.stopTest();          
        System.assert(!licenseValid);
    }
    /**
      * @Author: Eternus Solutions
      * @Description: Test method to verify whether the  License is valid or not.
      * @Expected Result: Method should return all required custom setting lists
      * @Date: 01/03/2017
      **/
    static testMethod void getkickoffLmsScheduler() {
                
        Test.startTest();
        Id schedulerId = LMSConfigManager.kickoffLmsScheduler();
        Test.stopTest(); 
        
         // Get the information from the CronTrigger API object
        CronTrigger ct = [SELECT Id,
                                 CronExpression,
                                 TimesTriggered,
                                 NextFireTime
                            FROM CronTrigger WHERE id = :schedulerId];

   
        //Verify the job has not run
        System.assertEquals(0, ct.TimesTriggered);
        //System.assertEquals(System.today(), String.valueOf(ct.NextFireTime));
       
        }
        
      /**
      * @Author: Eternus Solutions
      * @Description: Test method to verify whether the  Endpoint is created or not.
      * @Expected Result: Method should return all required custom setting lists
      * @Date: 01/03/2017
      **/
    static testMethod void getcreateEndpoint() {
        
        Test.startTest();
        LMSConfigManager.createEndpoint();
        Test.stopTest();
        List<UFHT__Endpoint_Settings__c> endPointList = [SELECT Name
                                 FROM UFHT__Endpoint_Settings__c]; 
        System.assert(endPointList.size() == 1);  
    }
    
    /**
      * @Author: Eternus Solutions
      * @Description: Test method to verify whether the  License is valid or not.
      * @Expected Result: Method should return all required custom setting lists
      * @Date: 01/03/2017
      **/
    static testMethod void getvalidateLicenseFuture() {
        
         Test.setMock(HttpCalloutMock.class, new LicenseMgmtCalloutsMock());
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
        Test.startTest();
        LMSConfigManager.validateLicenseFuture();
        Test.stopTest(); 
        List<Feature_Installation_Master__c> featureList = [SELECT Name
                                                              FROM Feature_Installation_Master__c];
        System.assert(featureList.size() == 1);
        
    }
    
    /**
      * @Author: Eternus Solutions
      * @Description: Test method to verify whether the  License is valid or not.
      * @Expected Result: Method should return all required custom setting lists
      * @Date: 01/03/2017
      **/
    static testMethod void getvalidateLicense() {
        
     
        Test.setMock(HttpCalloutMock.class, new LicenseMgmtCalloutsMock());
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
        
        Test.startTest();
        LMSConfigManager.validateLicense();
        Test.stopTest();
        List<Feature_Installation_Master__c> featureList = [SELECT Name
                                                              FROM Feature_Installation_Master__c];
        System.assert(featureList.size() == 1); 
     }
    /**
      * @Author: Eternus Solutions
      * @Description: Test method to verify whether license record gets deleted post uninstall.
      * @Expected Result: Method should delete the license record.
      * @Date: 01/03/2017
      **/
    static testMethod void getonUninstall() {
    
    Test.setMock(HttpCalloutMock.class, new LicenseMgmtCalloutsMock());
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
        
        Test.startTest();
        LMSConfigManager.onUninstall();
        Test.stopTest(); 
        List<Feature_Installation_Master__c> recordList = [SELECT Name                                  
                                                             FROM Feature_Installation_Master__c]; 
        System.assert(recordList.size()==0);    
    }    
}