/**
  * Class Name: PostInstallUtilTest
  * @Description: This class contains unit tests for PostInstallUtil.cls
  * ====================================================================================================================
  *       Version   | Date        | Author             | Comments
  * --------------------------------------------------------------------------------------------------------------------
  *       1.0       | 11/04/2016  | Eternus Solutions  | 1.Created Test Class for PostInstallUtil
  * ====================================================================================================================
  **/
@isTest
public class PostInstallUtilTest {
    /**
      * @Author: Eternus Solutions
      * @Description: Test method to verify whether the custom settings for "Configuration__c",
      *               "Number_Of_Columns__c","Number_Of_Fields_Per_Column__c",
      *               "Number_Of_Records_Per_Page__c","View_Field_History_Sharing_Setting__c ","Sort_Fields__c",
      *               "Standard_Objects__c","View_Field_History_Date_Filters__c" data is created or not.
      * @Expected Result: Method should return all required custom setting lists
      * @Date: 11/04/2016
      **/
    static testMethod void onInstallTestCase() {

        Document document =  new Document();
        document.Name = 'UFHT_AppLogo';
        document.FolderId = [SELECT Id 
                               FROM Folder
                              WHERE Name = 'Ultra FieldHistory Tracker'].Id;
        document.Body = Blob.valueOf('muscles and bones');
        insert document;
        
        Test.setMock(HttpCalloutMock.class, new LicenseMgmtCalloutsMock());
          
        Test.startTest();
        PostInstallUtil objInstall = new PostInstallUtil();
        // As we don't have previous package version need to pass version as null
        Test.testInstall(objInstall, null);
        Test.stopTest();

        list<Configuration__c> configurationList = Configuration__c.getAll().values();
        checkAssertForConfigurationCSData(configurationList);

        list<Profile> profileList = [SELECT Id
                                     FROM Profile
                                     WHERE Name = 'System Administrator'
                                     LIMIT 1];
        View_Field_History_Sharing_Setting__c viewFieldHistorySharingCSInstance = View_Field_History_Sharing_Setting__c.getInstance(profileList[0].Id);
        System.assertEquals(true, viewFieldHistorySharingCSInstance.View_All_Data__c);
        System.assertNotEquals(null, viewFieldHistorySharingCSInstance);

        list<Sort_Fields__c> sortByOptionsList = Sort_Fields__c.getAll().values();
        checkAssertForCSData(2, sortByOptionsList.size());

        list<Standard_Objects__c> standardObjectCSList = Standard_Objects__c.getAll().values();
        checkAssertForCSData(7, standardObjectCSList.size());

        list<View_Field_History_Date_Filters__c> historyDateFiltersDataList = View_Field_History_Date_Filters__c.getAll().values();
        checkAssertForCSData(11, historyDateFiltersDataList.size());

        list<UFHT__Encrypted_Field_Mask__c> uFHTEncryptedFieldMaskList = UFHT__Encrypted_Field_Mask__c.getAll().values();
        checkAssertForCSData(6, uFHTEncryptedFieldMaskList.size());
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test method to verify whether the custom setting "Configuration__c" data is created or not.
      * @Expected Result: Method should return "Configuration__c" custom setting list
      * @Date: 22/07/2016
      **/
    static testMethod void createConfigurationCSDataTestCase() {

        Test.startTest();
        new PostInstallUtil().createConfigurationCSData();
        Test.stopTest();

        list<Configuration__c> configurationList = Configuration__c.getAll().values();
        checkAssertForConfigurationCSData(configurationList);
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test method to check assert for "Configuration__c" custom setting list
      * @Expected Result: Method should check expected results with actual result
      * @Date: 04/08/2016
      **/
    static void checkAssertForConfigurationCSData(list<Configuration__c> configurationList) {
        System.assertEquals(1, configurationList.size());
        System.assertEquals(URL.getSalesforceBaseUrl().getHost(), configurationList[0].SalesforceBaseURL__c );
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test method to verify whether the custom setting "View_Field_History_Sharing_Setting__c" data is created or not.
      * @Expected Result: Method should return "View_Field_History_Sharing_Setting__c" custom setting list.
      * @Date: 22/07/2016
      **/
    static testMethod void createViewFieldHistoryForSharingCSDataTestCase() {

        Test.startTest();
        new PostInstallUtil().createViewFieldHistoryForSharingCSData();
        Test.stopTest();

        list<Profile> profileList = [SELECT Id
                                     FROM Profile
                                     WHERE Name = 'System Administrator'
                                     LIMIT 1];
        View_Field_History_Sharing_Setting__c viewFieldHistorySharingCSList =
                                              View_Field_History_Sharing_Setting__c.getInstance(profileList[0].Id);
        System.assertNotEquals(null, viewFieldHistorySharingCSList);
        System.assertEquals(true, viewFieldHistorySharingCSList.View_All_Data__c);
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test method to verify whether the custom setting "Sort_Fields__c" data is created or not.
      * @Expected Result: Method should return "Sort_Fields__c" custom setting list.
      * @Date: 22/07/2016
      **/
    static testMethod void createSortFieldsByCSDataTestCase() {

        Test.startTest();
        new PostInstallUtil().createSortFieldsByCSData();
        Test.stopTest();

        list<Sort_Fields__c> sortByOptionsList = Sort_Fields__c.getAll().values();
        checkAssertForCSData(2, sortByOptionsList.size());
        System.assertEquals('Ascending', sortByOptionsList[0].Name);
        System.assertEquals('Descending', sortByOptionsList[1].Name);
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test method to verify whether the custom setting "Standard_Objects__c" data is created or not.
      * @Param: standardObjectCsNewList: list of Standard_Objects__c custom setting
      * @Return: NA
      * @Date: 04/08/2016
      **/
    static void getCreateStandardObjectsCSDataTestAssert(map<String, String> standardObjectCsNewMap) {
        Test.startTest();
        new PostInstallUtil().createStandardObjectsCSData(standardObjectCsNewMap);
        Test.stopTest();
        list<Standard_Objects__c> standardObjectCSList = Standard_Objects__c.getAll().values();
        if(standardObjectCsNewMap != null) {
            checkAssertForCSData(standardObjectCsNewMap.size(), standardObjectCSList.size());
            if(!standardObjectCSList.isEmpty()) {
                System.assertEquals(standardObjectCsNewMap.get(UFHTConstants.ACCOUNT_STRING), standardObjectCSList[0].Organization_Field_Name__c);
                System.assertEquals(standardObjectCsNewMap.get(UFHTConstants.CAMPAIGN_STRING), standardObjectCSList[1].Organization_Field_Name__c);
                System.assertEquals(standardObjectCsNewMap.get(UFHTConstants.CASE_STRING), standardObjectCSList[2].Organization_Field_Name__c);
                System.assertEquals(standardObjectCsNewMap.get(UFHTConstants.CONTACT_STRING), standardObjectCSList[3].Organization_Field_Name__c);
                System.assertEquals(standardObjectCsNewMap.get(UFHTConstants.LEAD_STRING), standardObjectCSList[4].Organization_Field_Name__c);
                System.assertEquals(standardObjectCsNewMap.get(UFHTConstants.OPPORTUNITY_STRING), standardObjectCSList[5].Organization_Field_Name__c);
                System.assertEquals(standardObjectCsNewMap.get(UFHTConstants.PRICEBOOK_STRING), standardObjectCSList[6].Organization_Field_Name__c);
            }
        }
        else{
            checkAssertForCSData(0, standardObjectCSList.size());
        }
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test method to verify whether the custom setting "Standard_Objects__c" data is created
      *               when map of string with valid values is passed in parameter.
      * @Expected Result: Method should return "Standard_Objects__c" custom setting list.
      * @Date: 22/07/2016
      **/
    static testMethod void createStandardObjectsCSDataTestCase1() {

        getCreateStandardObjectsCSDataTestAssert( new map<String, String> {
                   UFHTConstants.ACCOUNT_STRING => UFHTConstants.DEFAULT_ACCOUNT_ACCESS,
                   UFHTConstants.CAMPAIGN_STRING => UFHTConstants.DEFAULT_CAMPAIGN_ACCESS,
                   UFHTConstants.CASE_STRING => UFHTConstants.DEFAULT_CASE_ACCESS,
                   UFHTConstants.CONTACT_STRING => UFHTConstants.DEFAULT_CONTACT_ACCESS,
                   UFHTConstants.LEAD_STRING => UFHTConstants.DEFAULT_LEAD_ACCESS,
                   UFHTConstants.OPPORTUNITY_STRING => UFHTConstants.DEFAULT_OPPORTUNITY_ACCESS,
                   UFHTConstants.PRICEBOOK_STRING => UFHTConstants.DEFAULT_PRICEBOOK_ACCESS
        });
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test method to verify whether the custom setting "Standard_Objects__c" data is created or not
      *               when null is passed in parameter.
      * @Expected Result: Method should return "Standard_Objects__c" custom setting list as null.
      * @Date: 22/07/2016
      **/
    static testMethod void createStandardObjectsCSDataTestCase2() {

        getCreateStandardObjectsCSDataTestAssert(null);
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test method to verify whether the custom setting "Standard_Objects__c" data is created or not
      *               when empty list is passed in parameter.
      * @Expected Result: Method should return "Standard_Objects__c" custom setting list as empty.
      * @Date: 22/07/2016
      **/
    static testMethod void createStandardObjectsCSDataTestCase3() {

        getCreateStandardObjectsCSDataTestAssert(new map<String, String> {});
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test method to verify whether the custom setting "View_Field_History_Date_Filters__c" data is created or not.
      * @Expected Result: Method should return "View_Field_History_Date_Filters__c" custom setting list.
      * @Date: 22/07/2016
      **/
    static testMethod void createViewFieldHistoryDateFiltersCSDataTestCase() {

        Test.startTest();
        new PostInstallUtil().createViewFieldHistoryDateFiltersCSData();
        Test.stopTest();

        list<View_Field_History_Date_Filters__c> historyDateFiltersDataList = View_Field_History_Date_Filters__c.getAll().values();
        checkAssertForCSData(11, historyDateFiltersDataList.size());
        System.assertEquals('Current and Previous Month', historyDateFiltersDataList[0].Name);
        System.assertEquals('Month', historyDateFiltersDataList[0].Month_Week_Day_Filter_Category__c);
        System.assertEquals(9, historyDateFiltersDataList[0].Sr_No__c);

    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test method to verify whether the custom setting "UFHT__Encrypted_Field_Mask__c" data is created or not.
      * @Expected Result: Method should return "UFHT__Encrypted_Field_Mask__c" custom setting list.
      * @Date: 22/07/2016
      **/
    static testMethod void createEncryptedFieldMaskCSDataTestCase() {

        Test.startTest();
        new PostInstallUtil().createEncryptedFieldMaskCSData();
        Test.stopTest();

        list<UFHT__Encrypted_Field_Mask__c> uFHTEncryptedFieldMaskList = UFHT__Encrypted_Field_Mask__c.getAll().values();
        checkAssertForCSData(6, uFHTEncryptedFieldMaskList.size());
        System.assertEquals(UFHTConstants.REGEX_ASCII, uFHTEncryptedFieldMaskList[0].RegEx__c);
        System.assertEquals(UFHTConstants.REGEX_ASCII, uFHTEncryptedFieldMaskList[1].RegEx__c);
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test method to check assert for positive and negative scenario for all test cases
      * @Expected Result: Method should check expected results with actual result
      * @Date: 22/07/2016
      **/
    static void checkAssertForCSData(Integer expectedResult, Integer actualResult) {

        expectedResult = (actualResult == 0) ? 0 : expectedResult ;
        System.assertEquals(expectedResult, actualResult);
    }
    
    /**
      * @Author: Eternus Solutions
      * @Description: Test method to verify whether the custom setting "UFHT__Encrypted_Field_Mask__c" data is created or not.
      * @Expected Result: Method should return "UFHT__Encrypted_Field_Mask__c" custom setting list.
      * @Date: 22/07/2016
      **/
    static testMethod void validTestCase() {
         list<Ultra_Track_Container__c> ultraTrackContainerList = new list<Ultra_Track_Container__c>();
        ultraTrackContainerList.addAll( TestDataFactory.getUltraTrackContainerList(
            new list<string> {'UFHT__Sharing_Purpose__c', 'Account'},
            new list<string> {'Sharing_Purpose', 'Account'},
            new list<boolean> {true, true},
            new list<string> {'Email:0, Name:1', 'Name:1, AccountNumber:1, Owner:0'}
        ));

        if(!ultraTrackContainerList.isEmpty()) {
            insert ultraTrackContainerList;
            ultraTrackContainerList.sort();
        }
        
        List<String> objectlist = new List<String>();
        objectlist.add('Account');
        List<String> restrictedObjectlist = new List<String>();
        restrictedObjectlist.add('FeedItem');
        Test.startTest();
        new PostInstallUtil().createObjectForWhichCreateRecordNotWork(objectlist);
        new PostInstallUtil().updateContainerObject();
        new PostInstallUtil().createRestrictedObjectForFieldTrackingCSData(restrictedObjectlist);
        Test.stopTest();

        list<UFHT__Encrypted_Field_Mask__c> uFHTEncryptedFieldMaskList = UFHT__Encrypted_Field_Mask__c.getAll().values();
        checkAssertForCSData(6, uFHTEncryptedFieldMaskList.size());

    }
}