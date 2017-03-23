
@isTest
public class UltraSetupControllerCloneTest {

    /**
       * @Author: Eternus Solutions
       * @Description: Generic method to check asserts from the list provided.
       * @Params: List of list of Objects, in inner list: 1st item - Expected value, 2nd item - actual value
       * @Date: 02/02/2017
       **/
    static void performAsserts(list<list<Object>> assertionValuesList) {

        if(assertionValuesList == null) {
            return;
        }

        for(list<Object> assertionList : assertionValuesList) {

            if(assertionList == null || assertionList.size() < 2) {
                continue;
            }

            System.assertEquals(assertionList[0], assertionList[1]);
        }
    }

    /**
       * @Author: Eternus Solutions
       * @Description: Method to get test data for getConfigurationSettingData method.
       * @Param: 1. isInsert: True if configuration records need to insert otherwise false.
       *         2. numberOfColumns: Number of columns to be displayed.
       *         3. numberOfFieldsPerColumns: Number of fields per column.
       *         4. numberOfRecordToDisplayPicklistValue:  Number of records to display.
       *         5. sortFieldsValue:  Sort value for field
       *         6. baseUrl: Salesforce base url.
       * @Return: NA
       * @Date: 04/07/2016
       **/
    static void getConfigurationSettingDataTestData(String baseUrl) {

        Configuration__c configurationObj = TestDataFactory.getConfiguration(baseUrl);
        insert configurationObj;
       
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseForSetupController1());

        PageReference pageRef = Page.Ultra_SetupClone;
        Test.setCurrentPage(pageRef);
    }
    
    /**
       * @Author: Eternus Solutions
       * @Description: Method to get test data for updateSetting method.
       * @Param: 1. objectNameList: List of object names for Ultra_Track_Container__c record.
       *         2. objectLabelList: List of object labels for Ultra_Track_Container__c record.
       *         3. isEnabledTackingList: List of isEnabled for tracking fields for Ultra_Track_Container__c record.
       *         4. trackedFieldList: List of tracked fields for Ultra_Track_Container__c record.
       * @Return: UltraSetupController instance
       * @Date: 04/07/2016
       **/
    static UltraSetupControllerClone updateSettingTestData(list<String> objectNameList,
                                                       list<String> objectLabelList,
                                                       list<Boolean> isEnabledTackingList,
                                                       list<String> trackedFieldList,
                                                       list<String> severitytrackedFieldList
                                       ) {

        Test.setMock(HttpCalloutMock.class, new MockHttpResponseForSetupController1());

        PageReference pageRef = Page.Ultra_SetupClone;
        Test.setCurrentPage(pageRef);

        UltraSetupControllerClone ultraSetupObj = new UltraSetupControllerClone();

        list<Ultra_Track_Container__c> ultraTrackContainerList = new list<Ultra_Track_Container__c>();
        ultraTrackContainerList.addAll(TestDataFactory.getUltraTrackContainerList(objectNameList,
                                                                                  objectLabelList,
                                                                                  isEnabledTackingList,
                                                                                  trackedFieldList,
                                                                                  severitytrackedFieldList
                                                                                  )
                                      );

        insert ultraTrackContainerList;
        return ultraSetupObj;
    }
    /**
       * @Author: Eternus Solutions
       * @Description: Template Method for testing getConfigurationSettingData method.
       * @Param: 1. configIsInsert: True if configuration records need to inserted otherwise false.
       *         2. configNumberOfColumns: Number of columns to be displayed.
       *         3. configNumberOfFieldsPerColumns: Number of fields per column.
       *         4. configNumberOfRecordToDisplay:  Number of records to display.
       *         5. configSortFieldsValue:  Sort value for field
       *         6. configBaseUrl: Salesforce base url.
       *         7. assertNumberOfColumns: expected value for number of columns
       *         8. assertNumberOfFieldsPerColumns: expected value for Number of fields per column.
       *         9. assertNumberOfRecordToDisplay:  expected value for Number of records to display.
       *         10. assertSortFieldsValue:  expected value for Sort value for field
       *         11. assertPageSize: expected value for Salesforce base url.
       * @Return: NA
       * @Date: 09/08/2016
       **/
    static void getConfigurationSettingDataTest(String configBaseUrl) {

        getConfigurationSettingDataTestData(configBaseUrl);
        Test.startTest();
        UltraSetupControllerClone ultraSetupObj = new UltraSetupControllerClone();
        Test.stopTest();
    }
    /**
       * @Author: Eternus Solutions
       * @Description: Template Method for testing setConfigurationSettingData method.
       * @Param: 1. configNumberOfColumns: Number of columns to be displayed.
       *         2. configNumberOfFieldsPerColumns: Number of fields per column.
       *         3. configNumberOfRecordToDisplay:  Number of records to display.
       *         4. configSortFieldsValue:  Sort value for field.
       *         5. configBaseUrl: Salesforce base url.
       *         6. assertNumberOfColumns: expected value for number of columns.
       *         7. assertNumberOfFieldsPerColumns: expected value for Number of fields per column.
       *         8. assertNumberOfRecordToDisplay:  expected value for Number of records to display.
       *         9. assertSortFieldsValue:  expected value for Sort value for field.
       * @Return: NA
       * @Date: 09/08/2016
       **/
    static void setConfigurationSettingDataTest(String configBaseUrl) {

        getConfigurationSettingDataTestData(null);

        UltraSetupControllerClone ultraSetupObj = new UltraSetupControllerClone();
        Test.startTest();
        ultraSetupObj.setConfigurationSettingData(configBaseUrl);
        Test.stopTest();

        performAsserts(new list<list<Object>> {
           
            new list<Object> {false, UltraSetupControllerClone.isRemoteSiteSettings}
        });
    }
    /**
       * @Author: Eternus Solutions
       * @Description: Template Method for testing getObjectList method.
       * @Param: 1. mockClassInstance: Instance of the mock class to be set for testing.
       *         2. baseUrl: Salesforce base url.
       *         3. isInvalidProtocol:  Boolean indicating if the base url has invalid protocol.
       *         4. assertIsRemoteSiteSetting: Expected value for isRemoteSiteSetting property.
       *         5. assertObjListSize: Expected value for size of objList property.
       * @Return: NA
       * @Date: 09/08/2016
       **/
    static void getObjectListTest(HttpCalloutMock mockClassInstance,
                                  String baseUrl,
                                  Boolean isInvalidProtocol,
                                  Boolean assertIsRemoteSiteSetting,
                                  Integer assertObjListSize
                                  ) {

        Test.setMock(HttpCalloutMock.class, mockClassInstance);

        PageReference pageRef = Page.Ultra_SetupClone;
        Test.setCurrentPage(pageRef);

        Test.startTest();
        UltraSetupControllerClone ultraSetupObj = new UltraSetupControllerClone();
        if(String.isNotBlank(baseUrl)) {
            ultraSetupObj.baseURL = baseUrl;
            ultraSetupObj.getObjectList();
        }
        test.stopTest();

        list<list<Object>> assertionValuesList = new list<list<Object>> {
            new list<Object> {assertObjListSize, UltraSetupControllerClone.objList.size()},
            new list<Object> {assertIsRemoteSiteSetting, UltraSetupControllerClone.isRemoteSiteSettings}
        };

        /*if(isInvalidProtocol == true) {
            ApexPages.Message[] pageMessages = ApexPages.getMessages();
            assertionValuesList.add(new list<Object> {'ERROR', String.valueOf(pageMessages[0].getSeverity()) });
            assertionValuesList.add(new list<Object> {'Invalid protocol.', pageMessages[0].getSummary() });
        }*/

        performAsserts(assertionValuesList);
    }
    
    /**
       * @Author: Eternus Solutions
       * @Description: Test method to test with following scenario: values for numberOfColumns, numberOfFieldsPerColumns,
       *               numberOfRecordToDisplayPicklistValue, sortFieldsValue should assign properly when Configuration record aleardy
       *               inserted.
       * @Expected Result: Method should assign passed values numberOfColumns, numberOfFieldsPerColumns,
       *                   numberOfRecordToDisplayPicklistValue, baseURL and pageSize.
       * @Date: 22/07/2016
       **/
    static testMethod void getConfigurationSettingDataTestCase1() {

        getConfigurationSettingDataTest(
            Url.getSalesforceBaseUrl().toExternalForm()
        );

    }
    
    /**
       * @Author: Eternus Solutions
       * @Description: Test method to test with following scenario: values for numberOfColumns, numberOfFieldsPerColumns,
       *               numberOfRecordToDisplayPicklistValue, sortFieldsValue should assign properly when Configuration record not
       *               inserted.
       * @Expected Result: Method should assign default values numberOfColumns, numberOfFieldsPerColumns,
       *                   numberOfRecordToDisplayPicklistValue, baseURL and pageSize.
       * @Date: 22/07/2016
       **/
    static testMethod void getConfigurationSettingDataTestCase2() {

        getConfigurationSettingDataTest(null
        );
    }
    
    /**
       * @Author: Eternus Solutions
       * @Description: Test method to test with following scenario: method numberOfColumns, numberOfFieldsPerColumns,
       *               numberOfRecordToDisplayPicklistValue, sortFieldsValue and baseUrl with blank.
       * @Expected Result: Method should assign default values numberOfColumns, numberOfFieldsPerColumns,
       *                   numberOfRecordToDisplayPicklistValue, baseURL and sortFieldsValue.
       * @Date: 22/07/2016
       **/
    static testMethod void setConfigurationSettingDataTestCase3() {

       setConfigurationSettingDataTest('');
    }
    
    /**
      * @Author: Eternus Solutions
      * @Description: Test method to test with following scenario: to check functionality with objList having 1 item.
      * @Expected Result: Method should check size of objList is correct or not.
      * @Date: 02/03/2016
      **/
    static testMethod void getObjectListTestCase1() {

        getObjectListTest(
            new MockHttpResponseForSetupController1(), null,
            false, false, 1);
    }
    
    /**
      * @Author: Eternus Solutions
      * @Description: Test method to test with following scenario: check functionality with objList having multiple items.
      * @Expected Result: Method should check size of objList is correct or not.
      * @Date: 02/03/2016
      **/
    static testMethod void getObjectListTestCase2() {

        getObjectListTest(
            new MockHttpResponseForSetupController2(), null,
            false, false, 16);
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test method to test with following scenario: check functionality with invalid endpoint.
      * @Expected Result: Method should check size of objList is correct or not and check for error.
      * @Date: 02/03/2016
      **/
    static testMethod void getObjectListTestCase3() {

        getObjectListTest(
            new UnauthorizedEndpointResponse(), 'https://xy1.salesforce.com',
            false, true, 0);
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test method to test with following scenario: check functionality with invalid protocol in endpoint URL.
      * @Expected Result: Method should check size of objList is correct or not and check for error.
      * @Date: 02/03/2016
      **/
    static testMethod void getObjectListTestCase4() {

        getObjectListTest(
            new InvalidProtocolResponse(), 'xy1.salesforce.com',
            true, false, 0);
    }

}