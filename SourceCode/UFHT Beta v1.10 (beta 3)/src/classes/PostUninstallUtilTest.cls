/**
  * Class Name: PostUninstallUtilTest
  * @Description: This class contains unit tests for PostUninstallUtil.cls
  * ====================================================================================================================
  *       Version   | Date        | Author             | Comments
  * --------------------------------------------------------------------------------------------------------------------
  *       1.0       | 28/02/2016  | Eternus Solutions  | 1.Created Test Class for PostUninstallUtil
  * ====================================================================================================================
  **/
@isTest
public class PostUninstallUtilTest{
    static testMethod void onUninstallTestCase() {
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
         PostUninstallUtil objInstall = new PostUninstallUtil();
         Test.testUninstall(objInstall);
         Test.stopTest();
            
         List<Feature_Installation_Master__c> recordList = [SELECT Name                                  
                                                              FROM Feature_Installation_Master__c]; 
         System.assert(recordList.size()==0);
    }
    

}