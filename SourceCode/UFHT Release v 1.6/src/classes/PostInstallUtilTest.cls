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

        Test.startTest();
        PostInstallUtil objInstall = new PostInstallUtil();
        // As we don't have previous package version need to pass version as null
        Test.testInstall(objInstall, null);
        Test.stopTest();

        list<Configuration__c> configurationList = Configuration__c.getAll().values();
        checkAssertForConfigurationCSData(configurationList);

        list<Number_Of_Columns__c> numberOfColumnsList = Number_Of_Columns__c.getAll().values();
        checkAssertForCSData(4, numberOfColumnsList.size());

        list<Number_Of_Fields_Per_Column__c> numberOfFieldsColumnsList = Number_Of_Fields_Per_Column__c.getAll().values();
        checkAssertForCSData(3, numberOfFieldsColumnsList.size());

        list<Number_Of_Records_Per_Page__c> numberOfHistoryRecordsList = Number_Of_Records_Per_Page__c.getAll().values();
        checkAssertForCSData(4, numberOfHistoryRecordsList.size());

        list<Profile> profileList = [SELECT Id
                                     FROM Profile
                                     WHERE Name = 'System Administrator'
                                     LIMIT 1];
        View_Field_History_Sharing_Setting__c viewFieldHistorySharingCSList = View_Field_History_Sharing_Setting__c.getInstance(profileList[0].Id);
        System.assertEquals(true, viewFieldHistorySharingCSList.View_All_Data__c);
        System.assertNotEquals(null, viewFieldHistorySharingCSList);

        list<Sort_Fields__c> sortByOptionsList = Sort_Fields__c.getAll().values();
        checkAssertForCSData(2, sortByOptionsList.size());

        list<Standard_Objects__c> standardObjectCSList = Standard_Objects__c.getAll().values();
        checkAssertForCSData(7, standardObjectCSList.size());

        list<View_Field_History_Date_Filters__c> historyDateFiltersDataList = View_Field_History_Date_Filters__c.getAll().values();
        checkAssertForCSData(9, historyDateFiltersDataList.size());

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
        System.assertEquals(System.Label.ConfigureColsAndFieldsCustomSettingRecordName, configurationList[0].Name);
        System.assertEquals(5, configurationList[0].Number_Of_Columns__c);
        System.assertEquals(10, configurationList[0].Number_Of_Fields_Per_Column__c);
        System.assertEquals('Ascending', configurationList[0].Sort_Fields_By__c);
        System.assertEquals(50, configurationList[0].Number_Of_Records_Per_Page__c);
        System.assertEquals(URL.getSalesforceBaseUrl().getHost(), configurationList[0].SalesforceBaseURL__c );
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test method to verify whether the custom setting "Number_Of_Columns__c" data is created or not.
      * @Param: numberOfColumnsNewList: list of Number_Of_Columns__c custom setting
      * @Return: NA
      * @Date: 04/08/2016
      **/
    static void getCreateNumberOfColumnsCSDataAssert(list<String> numberOfColumnsNewList) {
        Test.startTest();
        new PostInstallUtil().createNumberOfColumnsCSData(numberOfColumnsNewList);
        Test.stopTest();
        list<Number_Of_Columns__c> numberOfColumnsList = Number_Of_Columns__c.getAll().values();
        if(numberOfColumnsNewList != null) {
            checkAssertForCSData(numberOfColumnsNewList.size(), numberOfColumnsList.size());
            if(!numberOfColumnsList.isEmpty()) {
                System.assertEquals(numberOfColumnsNewList[0], numberOfColumnsList[0].Name);
                System.assertEquals(numberOfColumnsNewList[1], numberOfColumnsList[1].Name);
                System.assertEquals(numberOfColumnsNewList[2], numberOfColumnsList[2].Name);
                System.assertEquals(numberOfColumnsNewList[3], numberOfColumnsList[3].Name);
            }
        }
        else{
            checkAssertForCSData(0, numberOfColumnsList.size());
        }
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test method to verify whether the custom setting "Number_Of_Columns__c" data is created
      *               when list of string with valid values is passed in parameter.
      * @Expected Result: Method should return "Number_Of_Columns__c" custom setting list
      * @Date: 22/07/2016
      **/
    static testMethod void createNumberOfColumnsCSDataTestCase1() {
        getCreateNumberOfColumnsCSDataAssert(new list<String> {UFHTConstants.NUMERIC_2,
                                                               UFHTConstants.NUMERIC_3,
                                                               UFHTConstants.NUMERIC_4,
                                                               UFHTConstants.NUMERIC_5});
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test method to verify whether the custom setting "Number_Of_Columns__c" data is created or not
      *               when null is passed in parameter.
      * @Expected Result: Method should return "Number_Of_Columns__c" custom setting list
      *                   as null.
      * @Date: 22/07/2016
      **/
    static testMethod void createNumberOfColumnsCSDataTestCase2() {

        getCreateNumberOfColumnsCSDataAssert(null);
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test method to verify whether the custom setting "Number_Of_Columns__c" data is created or not
      *               when empty list is passed in parameter.
      * @Expected Result: Method should return "Number_Of_Columns__c" custom setting list
      *                   as empty.
      * @Date: 22/07/2016
      **/
    static testMethod void createNumberOfColumnsCSDataTestCase3() {

        getCreateNumberOfColumnsCSDataAssert(new list<String> {});
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test method to verify whether the custom setting "Number_Of_Fields_Per_Column__c" data is created or not.
      * @Param: numberOfFieldsColumnsNewList: list of Number_Of_Fields_Per_Column__c custom setting
      * @Return: NA
      * @Date: 04/08/2016
      **/
    static void getCreateNumberOfFieldsCSDataAssert(list<String> numberOfFieldsColumnsNewList) {
        Test.startTest();
        new PostInstallUtil().createNumberOfFieldsCSData(numberOfFieldsColumnsNewList);
        Test.stopTest();
        list<Number_Of_Fields_Per_Column__c> numberOfFieldsColumnsList = Number_Of_Fields_Per_Column__c.getAll().values();
        if(numberOfFieldsColumnsNewList != null) {
            checkAssertForCSData(numberOfFieldsColumnsNewList.size(), numberOfFieldsColumnsList.size());
            if(!numberOfFieldsColumnsList.isEmpty()) {
                System.assertEquals(numberOfFieldsColumnsNewList[0], numberOfFieldsColumnsList[0].Name);
                System.assertEquals(numberOfFieldsColumnsNewList[1], numberOfFieldsColumnsList[1].Name);
                System.assertEquals(numberOfFieldsColumnsNewList[2], numberOfFieldsColumnsList[2].Name);
            }
        }
        else{
            checkAssertForCSData(0, numberOfFieldsColumnsList.size());
        }
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test method to verify whether the custom setting "Number_Of_Fields_Per_Column__c" data is created
      *               when list of string with valid values is passed in parameter.
      * @Expected Result: Method should return "Number_Of_Fields_Per_Column__c" custom setting list.
      * @Date: 22/07/2016
      **/
    static testMethod void createNumberOfFieldsCSDataTestCase1() {

        getCreateNumberOfFieldsCSDataAssert(new list<String> {UFHTConstants.NUMERIC_05,
                                                              UFHTConstants.NUMERIC_10,
                                                              UFHTConstants.NUMERIC_15});
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test method to verify whether the custom setting "Number_Of_Fields_Per_Column__c" data is created
      *               or not when null is passed in parameter.
      * @Expected Result: Method should return "Number_Of_Fields_Per_Column__c" custom setting list
      *                   as null.
      * @Date: 22/07/2016
      **/
    static testMethod void createNumberOfFieldsCSDataTestCase2() {

        getCreateNumberOfFieldsCSDataAssert(null);
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test method to verify whether the custom setting "Number_Of_Fields_Per_Column__c" data is created
      *               or not when empty list is passed in parameter.
      * @Expected Result: Method should return "Number_Of_Fields_Per_Column__c" custom setting list
      *                   as empty.
      * @Date: 22/07/2016
      **/
    static testMethod void createNumberOfFieldsCSDataTestCase3() {

        getCreateNumberOfFieldsCSDataAssert(new list<String> {});
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test method to verify whether the custom setting "Number_Of_Records_Per_Page__c" data is created or not.
      * @Param: numberOfHistoryRecordsNewList: list of Number_Of_Records_Per_Page__c custom setting
      * @Return: NA
      * @Date: 04/08/2016
      **/
    static void getCreateNumberOfRecordsCSDataTestAssert(list<String> numberOfHistoryRecordsNewList) {
        Test.startTest();
        new PostInstallUtil().createNumberOfRecordsCSData(numberOfHistoryRecordsNewList);
        Test.stopTest();
        list<Number_Of_Records_Per_Page__c> numberOfHistoryRecordsList = Number_Of_Records_Per_Page__c.getAll().values();
        if(numberOfHistoryRecordsNewList != null) {
            checkAssertForCSData(numberOfHistoryRecordsNewList.size(), numberOfHistoryRecordsList.size());
            if(!numberOfHistoryRecordsList.isEmpty()) {
                System.assertEquals(numberOfHistoryRecordsNewList[0], numberOfHistoryRecordsList[0].Name);
                System.assertEquals(numberOfHistoryRecordsNewList[1], numberOfHistoryRecordsList[1].Name);
                System.assertEquals(numberOfHistoryRecordsNewList[2], numberOfHistoryRecordsList[2].Name);
                System.assertEquals(numberOfHistoryRecordsNewList[3], numberOfHistoryRecordsList[3].Name);
            }
        }
        else{
            checkAssertForCSData(0, numberOfHistoryRecordsList.size());
        }
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test method to verify whether the custom setting "Number_Of_Records_Per_Page__c" data is created
      *               when list of string with valid values is passed in parameter.
      * @Expected Result: Method should return "Number_Of_Records_Per_Page__c" custom setting list.
      * @Date: 22/07/2016
      **/
    static testMethod void createNumberOfRecordsCSDataTestCase1() {

        getCreateNumberOfRecordsCSDataTestAssert(new list<String> {UFHTConstants.NUMERIC_25,
                                                                   UFHTConstants.NUMERIC_50,
                                                                   UFHTConstants.NUMERIC_75,
                                                                   UFHTConstants.NUMERIC_100});
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test method to verify whether the custom setting "Number_Of_Records_Per_Page__c" data is created
      *               or not when null is passed in parameter.
      * @Expected Result: Method should return "Number_Of_Records_Per_Page__c" custom setting list
      *                   as null.
      * @Date: 22/07/2016
      **/
    static testMethod void createNumberOfRecordsCSDataTestCase2() {

        getCreateNumberOfRecordsCSDataTestAssert(null);
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test method to verify whether the custom setting "Number_Of_Records_Per_Page__c" data is created
      *               or not when empty list is passed in parameter.
      * @Expected Result: Method should return "Number_Of_Records_Per_Page__c" custom setting list
      *                   as Empty.
      * @Date: 22/07/2016
      **/
    static testMethod void createNumberOfRecordsCSDataTestCase3() {

        getCreateNumberOfRecordsCSDataTestAssert(new list<String> {});
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
        checkAssertForCSData(9, historyDateFiltersDataList.size());
        System.assertEquals('Current and Previous Month', historyDateFiltersDataList[0].Name);
        System.assertEquals('Month', historyDateFiltersDataList[0].Month_Week_Day_Filter_Category__c);
        System.assertEquals(7, historyDateFiltersDataList[0].Sr_No__c);
        System.assertEquals(null, historyDateFiltersDataList[0].Value__c);
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
    static void checkAssertForCSData(Integer actualResult, Integer expectedResult) {

        expectedResult = (actualResult == 0) ? 0 : expectedResult ;
        System.assertEquals(expectedResult, actualResult);
    }
}