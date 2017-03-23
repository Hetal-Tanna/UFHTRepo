/**
 * @Class Name: UltraSetupControllerTest
 * @Description: This class contains unit tests for UltraSetupController.cls
 * =========================================================================================================
 *       Version   | Date        | Author             | Comments
 * ----------------------------------------------------------------------------------------------------------
 *       1.0       | 01/02/2017  | Eternus Solutions  | 1.Created the Test Class for UltraSetupController
 * ==========================================================================================================
 **/
@isTest
private class UltraSetupControllerTest {

    /**
       * @Author: Eternus Solutions
       * @Description: Generic method to check asserts from the list provided.
       * @Params: List of list of Objects, in inner list: 1st item - Expected value, 2nd item - actual value
       * @Date: 01/02/2017
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

        PageReference pageRef = Page.Ultra_Setup;
        Test.setCurrentPage(pageRef);
        
         performAsserts(new list<list<Object>> {
            new list<Object> {'ap2.salesforce.com',URL.getSalesforceBaseUrl().getHost()}
        });
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
    static UltraSetupController updateSettingTestData(list<String> objectNameList,
                                                       list<String> objectLabelList,
                                                       list<Boolean> isEnabledTackingList,
                                                       list<String> trackedFieldList
                                       ) {

        Test.setMock(HttpCalloutMock.class, new MockHttpResponseForSetupController1());

        PageReference pageRef = Page.Ultra_Setup;
        Test.setCurrentPage(pageRef);

        UltraSetupController ultraSetupObj = new UltraSetupController();

        list<Ultra_Track_Container__c> ultraTrackContainerList = new list<Ultra_Track_Container__c>();
        ultraTrackContainerList.addAll(TestDataFactory.getUltraTrackContainerList(objectNameList,
                                                                                  objectLabelList,
                                                                                  isEnabledTackingList,
                                                                                  trackedFieldList
                                                                                  )
                                      );

        insert ultraTrackContainerList;

        return ultraSetupObj;
    }

    /**
       * @Author: Eternus Solutions
       * @Description: Template Method for testing getConfigurationSettingData method.
       * @Param: 1. configBaseUrl: Salesforce base url.
       * @Return: NA
       * @Date: 01/02/2017
       **/
    static void getConfigurationSettingDataTest(String configBaseUrl) {
        getConfigurationSettingDataTestData(configBaseUrl);
        Test.startTest();
        UltraSetupController ultraSetupObj = new UltraSetupController();
        Test.stopTest();

    }

    /**
       * @Author: Eternus Solutions
       * @Description: Template Method for testing setConfigurationSettingData method.
       * @Param: 1. configBaseUrl: Salesforce base url.
       * @Return: NA
       * @Date: 01/02/2017
       **/
    static void setConfigurationSettingDataTest(String configBaseUrl) {

        getConfigurationSettingDataTestData(
                                            null);

        UltraSetupController ultraSetupObj = new UltraSetupController();
        Test.startTest();
        ultraSetupObj.setConfigurationSettingData(
                                                  configBaseUrl);
        Test.stopTest();
        performAsserts(new list<list<Object>> {
            new list<Object> {false, UltraSetupController.isRemoteSiteSettings}
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
       * @Date: 01/02/2017
       **/
    static void getObjectListTest(HttpCalloutMock mockClassInstance,
                                  String baseUrl,
                                  Boolean isInvalidProtocol,
                                  Boolean assertIsRemoteSiteSetting,
                                  Integer assertObjListSize
                                  ) {

        Test.setMock(HttpCalloutMock.class, mockClassInstance);

        PageReference pageRef = Page.Ultra_Setup;
        Test.setCurrentPage(pageRef);

        Test.startTest();
        UltraSetupController ultraSetupObj = new UltraSetupController();
        if(String.isNotBlank(baseUrl)) {
            ultraSetupObj.baseURL = baseUrl;
            ultraSetupObj.getObjectList();
        }
        test.stopTest();

        list<list<Object>> assertionValuesList = new list<list<Object>> {
            new list<Object> {assertObjListSize, UltraSetupController.objList.size()},
            new list<Object> {assertIsRemoteSiteSetting, UltraSetupController.isRemoteSiteSettings}
        };
        performAsserts(assertionValuesList);
    }

    

    /**
       * @Author: Eternus Solutions
       * @Description: Template Method for testing saveAndUpdateConfigurationSetting method.
       * @Param: 1. isObjectSelected: Boolean indicating if an object is selected..
       * @Return: NA
       * @Date: 01/02/2017
       **/
    static void saveAndUpdateConfigurationSettingTest(Boolean isObjectSelected) {
        getConfigurationSettingDataTestData(
                                            URL.getSalesforceBaseUrl().getHost());

        UltraSetupController ultraSetupObj = new UltraSetupController();

        Test.startTest();
        if(isObjectSelected == true) {
            UltraSetupController.objects = 'Account (Account)';
            UltraSetupController.getFieldsList(UltraSetupController.objects);
        }
        //ultraSetupObj.saveAndUpdateConfigurationSetting();
        test.stopTest();

        Map<String, Configuration__c> mapConfig = Configuration__c.getAll();
        list<Configuration__c> configurationUpdatedList = new list<Configuration__c>
                                                         {Configuration__c.getAll().get
                                                         (System.Label.ConfigureColsAndFieldsCustomSettingRecordName)
                                                         };
       if(isObjectSelected == true) {
          performAsserts(new list<list<Object>> {
            new list<Object> {false, UltraSetupController.allFieldswrapperClassList.isEmpty()}
        });
       }
    }

    /**
       * @Author: Eternus Solutions
       * @Description: Template Method for testing getCommaSeparatedFields method.
       * @Param: 1. fieldNamesSet: set of field names for giving as input to method.
       *         2. assertCommaSeparatedString: Expected value for the output commaSeparatedString.
       *         3. isInvalidProtocol:  Boolean indicating if the base url has invalid protocol.
       *         4. assertIsRemoteSiteSetting: Expected value for isRemoteSiteSetting property.
       *         5. assertObjListSize: Expected value for size of objList property.
       * @Return: NA
       * @Date: 01/02/2017
       **/
    static void getCommaSeparatedFieldsTest(set<String> fieldNamesSet,
                                            String assertCommaSeparatedString) {

        getConfigurationSettingDataTestData(
                                            null);

        UltraSetupController ultraSetupObj = new UltraSetupController();

        Test.startTest();
        String commaSeparatedString = UltraSetupController.getCommaSepratedFields(fieldNamesSet);
        test.stopTest();

        performAsserts(new list<list<Object>> {
            new list<Object> {assertCommaSeparatedString, commaSeparatedString}
        });
    }

    /**
       * @Author: Eternus Solutions
       * @Description: Template Method for testing getFieldsList method.
       * @Param: 1. fieldNamesList: List of field names for tracking.
       *         2. objectsValue: Value for objects property
       *         3. isInvalidObject: Boolean indicating if the objects property has invalid value.
       *         4. assertFieldCount: Expected value for isRemoteSiteSetting property.
       * @Return: NA
       * @Date: 01/02/2017
       **/
    static void getFieldsListTest(list<String> fieldNamesList,
                                  String objectsValue,
                                  Boolean isInvalidObject,
                                  list<String> fieldTypeList) {

        PageReference pageRef = Page.Ultra_Setup;
        Test.setCurrentPage(pageRef);

        Test.setMock(HttpCalloutMock.class, new MockHttpResponseForSetupController1());

        UltraSetupController ultraSetupObj = isInvalidObject == false
                                           ? updateSettingTestData(new list<String> {'Account'},
                                                                   new list<String> {'Account'},
                                                                   new list<Boolean> {false},
                                                                   fieldNamesList
                                                                   )
                                           : new UltraSetupController();

        list<list<Object>> assertionValuesList = new list<list<Object>>();

        Test.startTest();
        UltraSetupController.objects = objectsValue;
        UltraSetupController.getFieldsList(UltraSetupController.objects);
        test.stopTest(); 

        if(isInvalidObject == false) {
            map<String, String> fieldsForObject =  UltraTrackUtility.getFieldNamesAndLabels('Account');
            map<String, String> fieldsTypeForObject =  UltraTrackUtility.getFieldNamesAndDataType('Account');
            integer selectedFieldCount = 0;

            assertionValuesList.add(new list<Object> {fieldsForObject.size(), UltraSetupController.allFieldswrapperClassList.size()} );
            for(UltraTrackWrapper wrapper : UltraSetupController.allFieldswrapperClassList) {
                if(wrapper.isSelected) {
                    selectedFieldCount++;
                }
            }

            assertionValuesList.add(new list<Object> {0, selectedFieldCount} );
        } else {
            assertionValuesList.add(new list<Object> {0, UltraSetupController.allFieldswrapperClassList.size()} );
            assertionValuesList.add(new list<Object> {false, UltraSetupController.isObject} );
        }
        performAsserts(assertionValuesList);
    }

    /**
       * @Author: Eternus Solutions
       * @Description: Template Method for testing saveSetting method.
       * @Param: 1. fieldNamesSet: Set of field names to provide as input to the method.
       *         2. isMockNeeded: Boolean to decide if a mock response is needed.
       *         3. isManualSelection: Boolean indicating the fields are selected manually by the user.
       *         4. isExpectedListEmpty: Boolean indicating if the expected Ultra_Track_Container__c list will be empty.
       *         5. assertPageMessageSeverity: Expected value for page message severity.
       *         6. assertPageMessageSummary: Expected value for page message summary.
       * @Return: NA
       * @Date: 01/02/2017
       **/
    static void saveSettingTest(list<String> selectedFieldSet,
                                String selectedOWD,
                                Ultra_Track_Container__c ultraContainerObject, 
                                String objectName,
                                String FieldNameToggleValue,
                                Boolean isMockNeeded,
                                Boolean isManualSelection,
                                Boolean isExpectedListEmpty
                                ) {
        
        list<list<Object>> assertionValuesList = new list<list<Object>>();
        Integer assertFieldListSize = 0;

        getConfigurationSettingDataTestData(null);

        UltraSetupController ultraSetupObj = new UltraSetupController();

        Test.startTest();

        if(isMockNeeded == true) {
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseDyanamicTriggerGenerator());
        }

        UltraSetupController.objects = 'Account (Account)';

        if(isManualSelection == true) {
            UltraSetupController.getFieldsList(UltraSetupController.objects);
            UltraSetupController.allFieldswrapperClassList[0].isSelected = true;
            UltraSetupController.allFieldswrapperClassList[1].isSelected = true;
            UltraSetupController.selectedFieldsName(UltraSetupController.objects,
                                                        new list<String>{'Account (Account)'},
                                                        selectedFieldSet,
                                                        selectedOWD,
                                                        ultraContainerObject,
                                                        FieldNameToggleValue);
            assertFieldListSize = 2;
        }

        else {
            UltraSetupController.saveSetting(selectedFieldSet,selectedOWD,ultraContainerObject,objectName,FieldNameToggleValue);
            assertFieldListSize = selectedFieldSet != null
                                ? selectedFieldSet.size()
                                : 0;
        }
         list<Ultra_Track_Container__c> insertedUltraultraTrackContainerList = [SELECT Id,
                                                                                      Is_Tracking_Enabled__c,
                                                                                      Tracked_Fields__c,
                                                                                      Object_Label__c,
                                                                                      Object_Name__c
                                                                                 FROM UFHT__Ultra_Track_Container__c];
        test.stopTest();

        assertionValuesList.add(new list<Object>{isExpectedListEmpty, insertedUltraultraTrackContainerList.isEmpty()});
        if(isExpectedListEmpty == false) {
            list<String> trackedField = insertedUltraultraTrackContainerList[0].Tracked_Fields__c.split(',');
            assertionValuesList.add(new list<Object>{assertFieldListSize, trackedField.size()});
            assertionValuesList.add(new list<Object>{true, insertedUltraultraTrackContainerList[0].Is_Tracking_Enabled__c});
            assertionValuesList.add(new list<Object>{'Account', insertedUltraultraTrackContainerList[0].Object_Name__c});
            assertionValuesList.add(new list<Object>{'Account (Account)', insertedUltraultraTrackContainerList[0].Object_Label__c});
            assertionValuesList.add(new list<Object>{false, UltraSetupController.isObject});
         }
    }
    
    /**
       * @Author: Eternus Solutions
       * @Description: Test method to test with following scenario: values for numberOfColumns, numberOfFieldsPerColumns,
       *               numberOfRecordToDisplayPicklistValue, sortFieldsValue should assign properly when Configuration record aleardy
       *               inserted.
       * @Expected Result: Method should assign passed values numberOfColumns, numberOfFieldsPerColumns,
       *                   numberOfRecordToDisplayPicklistValue, baseURL and pageSize.
       * @Date: 01/02/2017
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
       * @Date: 01/02/2017
       **/
    static testMethod void getConfigurationSettingDataTestCase2() {

        getConfigurationSettingDataTest(
           null
        );
    }


    /**
       * @Author: Eternus Solutions
       * @Description: Test method to test with following scenario: method should assign correct values to numberOfColumns, numberOfFieldsPerColumns,
       *               numberOfRecordToDisplayPicklistValue, baseURL and sortFieldsValue when configuration record is not inserted.
       * @Expected Result: Method should assign default values numberOfColumns, numberOfFieldsPerColumns,
       *                   numberOfRecordToDisplayPicklistValue, baseURL and sortFieldsValue.
       * @Date: 01/02/2017
       **/
    static testMethod void setConfigurationSettingDataTestCase1() {

        setConfigurationSettingDataTest(
            Url.getSalesforceBaseUrl().toExternalForm());
    }

    /**
       * @Author: Eternus Solutions
       * @Description: Test method to test with following scenario: method with numberOfColumns, numberOfFieldsPerColumns,
       *               numberOfRecordToDisplayPicklistValue as blank and sortFieldsValue, baseUrl with valid values.
       * @Expected Result: Method should assign default values numberOfColumns, numberOfFieldsPerColumns,
       *                   numberOfRecordToDisplayPicklistValue, baseURL and sortFieldsValue.
       * @Date: 01/02/2017
       **/
    static testMethod void setConfigurationSettingDataTestCase2() {

        setConfigurationSettingDataTest(Url.getSalesforceBaseUrl().toExternalForm());
    }

    /**
       * @Author: Eternus Solutions
       * @Description: Test method to test with following scenario: method numberOfColumns, numberOfFieldsPerColumns,
       *               numberOfRecordToDisplayPicklistValue, sortFieldsValue and baseUrl with blank.
       * @Expected Result: Method should assign default values numberOfColumns, numberOfFieldsPerColumns,
       *                   numberOfRecordToDisplayPicklistValue, baseURL and sortFieldsValue.
       * @Date: 01/02/2017
       **/
    static testMethod void setConfigurationSettingDataTestCase3() {

       setConfigurationSettingDataTest('');
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test method to test with following scenario: method numberOfColumns, numberOfFieldsPerColumns,
      *               numberOfRecordToDisplayPicklistValue, sortFieldsValue and baseUrl with valid values.
      * @Expected Result: Method should assign default values numberOfColumns, numberOfFieldsPerColumns,
      *                   numberOfRecordToDisplayPicklistValue, baseURL and sortFieldsValue.
      * @Date: 01/02/2017
      **/
    static testMethod void setConfigurationSettingDataTestCase4() {

        setConfigurationSettingDataTest(null);
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test method to test with following scenario: to check functionality with objList having 1 item.
      * @Expected Result: Method should check size of objList is correct or not.
      * @Date: 01/02/2017
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
      * @Date: 01/02/2017
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
      * @Date: 01/02/2017
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
      * @Date: 01/02/2017
      **/
    static testMethod void getObjectListTestCase4() {

        getObjectListTest(
            new InvalidProtocolResponse(), 'xy1.salesforce.com',
            true, false, 0);
    }

    /**
      * @Author: Eternus Solutions
      * @Description: getFieldsList test case to test method with following steps:
      *               Inserted Ultra_Track_Container__c record for an object.
      *               Selected an object.
      *               Two fields selected for field tracking.
      * Expected Result: Method should assign values in isSelected true for 2 fields for an object.
      * @Date: 01/02/2017
      **/
    static testMethod void getFieldsListTestCase1() {
        getFieldsListTest(
            new list<String> {'Email:1, Name:1, Phone:0'}, 'Account (Account)', false,
            new list<String> {'Email, Text, Phone'}
        );
    }

    /**
      * @Author: Eternus Solutions
      * @Description: getFieldsList test case to test method with following steps:
      *               Inserted Ultra_Track_Container__c record for an object.
      *               Selected an object.
      *               No fields selected for field tracking.
      * @Expected Result: Method should assign values in isSelected is false for all fields of an object.
      * @Date: 01/02/2017
      **/
    static testMethod void getFieldsListTestCase2() {
        getFieldsListTest(
            new list<String>(), 'Account (Account)', false,
            new list<String> ()
        );
    }

    /**
      * @Author: Eternus Solutions
      * @Description: getFieldsList test case to test method by selecting object as blank.
      * @Expected Result: Method should check if result is empty or not.
      * @Date: 01/02/2017
      **/
    static testMethod void getFieldsListTestCase3() {
        getFieldsListTest(
            new list<String>(), '', true,
            new list<String> ()
        );
    }

    /**
      * @Author: Eternus Solutions
      * @Description: getFieldsList test case to test method by adding selected object is not present.
      * @Expected Result: Method should check if result is empty or not.
      * @Date: 01/02/2017
      **/
    static testMethod void getFieldsListTestCase4() {
        getFieldsListTest(
            new list<String>(), 'Test', true,
            new list<String> ()
        );
    }



   
    /**
      * @Author: Eternus Solutions
      * @Description: getCommaSeperatedFields test case to test method with valid set of String.
      * @Expected Result: Method should return comma separated fields.
      * @date: 01/02/2017
      **/
    static testMethod void getCommaSeparatedFieldsTestCase1() {
        getCommaSeparatedFieldsTest(new set<String> {'abc', 'cde', 'fg'}, 'abc,cde,fg');
    }

    /**
      * @Author: Eternus Solutions
      * @Description: getCommaSeperatedFields test case to test method with empty set of String.
      * @Expected Result: Method should return empty String.
      * @Date: 01/02/2017
      **/
    static testMethod void getCommaSeparatedFieldsTestCase2() {
        getCommaSeparatedFieldsTest(new set<String>(), '');
        Boolean testAssert = true;
        System.assertEquals(true, testAssert);
    }

    /**
      * @Author: Eternus Solutions
      * @Description: getCommaSeperatedFields test case to test method with null set.
      * @Expected Result: Method should return null String.
      * @Date: 01/02/2017
      **/
    static testMethod void getCommaSeparatedFieldsTestCase3() {
        getCommaSeparatedFieldsTest(null, '');
    }

    
    static testMethod void saveSettingTestCase1() {
        saveSettingTest(
            new list<String> {'Email, Name, Phone'},
            'Read',
            null,
            'Account (Account)',
            'Name:1,Phone:0,Email:1',
            true, false, false
        );
    }

    /**
      * @Author: Eternus Solutions
      * @Description: saveSetting test case to test method with following steps:
      *               No Ultra_Track_Container__c record for an object.
      *               Selected an object.
      *               Pass empty set to method.
      * @Expected Result: Method should not insert Ultra_Track_Container__c record with Selected fields
      *                   and display error message on page.
      * @Date: 01/02/2017
      **/
    static testMethod void saveSettingTestCase2() {
        list<Ultra_Track_Container__c> ultraTrackContainerList = new list<Ultra_Track_Container__c>();
        ultraTrackContainerList.addAll(TestDataFactory.getUltraTrackContainerList(new list<String> {'Account'},
                                                                                  new list<String> {'Account'},
                                                                                  new list<Boolean> {true},
                                                                                  new list<String> {'Email, Name, Phone'}
                                                                                  )
                                      );
        saveSettingTest(
            new list<String>(), 
            'Read',
            ultraTrackContainerList.get(0),
            'Account (Account)',
            'Name:1,Phone:0,Email:1',
            false, false, true
        );

    }

    
    /**
      * @Author: Eternus Solutions
      * @Description: selectedFieldsName test case to test method with following steps:
      *               Inserted Ultra_Track_Container__c record for an object.
      *               Selected an object.
      *               Added two fields selected for field tracking.
      * @Expected Result: Method should assign values for all selected fields in selectedFieldSet.
      * @Date: 01/02/2017
      **/
    static testMethod void selectedFieldsNameTestCase1() {

        UltraSetupController ultraSetupObj = updateSettingTestData(new list<String> {'Account'},
                                                                   new list<String> {'Account'},
                                                                   new list<Boolean> {true},
                                                                   new list<String> {'Name, Phone'}
                                                                   );
        Profile profileObj = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User userObj = new User(Alias = 'standt', Email='stduserUFHT@testorg.com', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = profileObj.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='stduserUFHT@testorg.com');
        
        Test.startTest();
        System.runAs(userObj) {
        Ultra_Track_Container__c ultraTrackContainerobj = new Ultra_Track_Container__c();
        UltraSetupController.objects = 'Account (Account)';
        UltraSetupController.getFieldsList(UltraSetupController.objects);
        
        UltraSetupController.selectedFieldsName(UltraSetupController.objects,
                                                    new list<String>{'Account (Account)'},
                                                    new list<String> {'Name, Phone'},
                                                    'Read',
                                                    ultraTrackContainerobj,
                                                    'Name:1, Phone:0');
        }
        test.stopTest();

        System.assertEquals(0, ultraSetupObj.selectedFieldSet.size());
    }

    /**
      * @Author: Eternus Solutions
      * @Description: selectedFieldsName test case to test method with following steps:
      *               No Ultra_Track_Container__c record for an object.
      *               Selected an object.
      *               No fields selected for field tracking.
      * @Expected Result: Method should assign values for no selected fields in SELECTedFieldSet.
      * @Date: 01/02/2017
      **/
    static testMethod void selectedFieldsNameTestCase2() {

        Test.setMock(HttpCalloutMock.class, new MockHttpResponseForSetupController1());

        PageReference pageRef = Page.Ultra_Setup;
        Test.setCurrentPage(pageRef);

        UltraSetupController ultraSetupObj = new UltraSetupController();
        Ultra_Track_Container__c ultraTrackContainerobj = new Ultra_Track_Container__c();
        Test.startTest();
        UltraSetupController.objects = 'Account(Account)';
        UltraSetupController.getFieldsList(UltraSetupController.objects);
        UltraSetupController.selectedFieldsName(UltraSetupController.objects,
                                                    new list<String>{'Account (Account)'},
                                                    new list<String> {'Name, Phone'},
                                                    'Read',
                                                    ultraTrackContainerobj,
                                                    'Name:1, Phone:0');
        test.stopTest();

        System.assertEquals(0, ultraSetupObj.selectedFieldSet.size());
    }

    /**
      * @Author: Eternus Solutions
      * @Description: selectedFieldsName test case to test method with following steps:
      *               Inserted Ultra_Track_Container__c record for an object.
      *               Selected an object.
      *               Added two fields selected for field tracking.
      *               Http callout fail and objList is empty.
      * @Expected Result: Method should check fields are not selected and added message on page.
      * @Date: 01/02/2017
      **/
    static testMethod void selectedFieldsNameTestCase3() {

        list<Ultra_Track_Container__c> ultraTrackContainerList = new list<Ultra_Track_Container__c>();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseForSetupController1());

        PageReference pageRef = Page.Ultra_Setup;
        Test.setCurrentPage(pageRef);

        ultraTrackContainerList.addAll(TestDataFactory.getUltraTrackContainerList(new list<String> {'Account'},
                                                                                  new list<String> {'Account'},
                                                                                  new list<Boolean> {true},
                                                                                  new list<String> {'Name, Phone'}
                                                                                  )
                                      );

        insert ultraTrackContainerList;

        UltraSetupController ultraSetupObj = new UltraSetupController();
        Ultra_Track_Container__c ultraTrackContainerobj = new Ultra_Track_Container__c();
        Test.startTest();
        UltraSetupController.objects = 'Account (Account)';
        UltraSetupController.getFieldsList(UltraSetupController.objects);
        UltraSetupController.selectedFieldsName(UltraSetupController.objects,
                                                    new list<String>{'Account (Account)'},
                                                    new list<String> {'Name, Phone'},
                                                    'Read',
                                                    ultraTrackContainerobj,
                                                    'Name:1, Phone:0');
        test.stopTest();

        System.assertEquals(0, ultraSetupObj.selectedFieldSet.size());
    }
    
    /**
      * @Author: Eternus Solutions
      * @Description: UpdateSetting test case to test method with following steps:
      *               Inserted Ultra_Track_Container__c record for an object.
      *               Selected an object.
      *               Two fields selected for field tracking.
      * @Expected Result: Method should update Ultra_Track_Container__c record with selected fields.
      * @Date: 02/03/2016
      **/
    static testMethod void updateSettingTestCase1() {
        Ultra_Track_Container__c ultraTrackContainerobj = new Ultra_Track_Container__c();
        UltraSetupController ultraSetupObj = updateSettingTestData(new list<String> {'Account'},
                                                                   new list<String> {'Account'},
                                                                   new list<Boolean> {true},
                                                                   new list<String> {'Name, Phone'}
                                                                   );
        Test.startTest();
        UltraSetupController.objects = 'Account (Account)';
        UltraSetupController.getFieldsList(UltraSetupController.objects);
        UltraSetupController.allFieldswrapperClassList[0].isSelected = true;
        UltraSetupController.allFieldswrapperClassList[1].isSelected = true;
        // Set mock to call the mehtod selectedFieldsName() because it calls mehtod updateSetting().
        // The saveSetting() method calls future method generateDynamicTrigger() which makes callout to create trigger.
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseDyanamicTriggerGenerator());
        UltraSetupController.selectedFieldsName(UltraSetupController.objects,
                                                    new list<String>{'Account (Account)'},
                                                    new list<String> {'Name, Phone'},
                                                    'Read',
                                                    ultraTrackContainerobj,
                                                    'Name:1, Phone:0');
        test.stopTest();

        list<Ultra_Track_Container__c> updatedUltraultraTrackContainerList = [SELECT Id,
                                                                                     Is_Tracking_Enabled__c,
                                                                                     Tracked_Fields__c
                                                                             FROM Ultra_Track_Container__c
                                                                             ];

        System.assertEquals(0, ultraSetupObj.SELECTedFieldSet.size());
        list<String> trackedField = updatedUltraultraTrackContainerList[0].Tracked_Fields__c.split(',');
        System.assertEquals(2, trackedField.size());
    }

    /**
      * @Author: Eternus Solutions
      * @Description: UpdateSetting test case to test method with following steps:
      *               Selected an object.
      *               Pass null set of value to method.
      * @Expected Result: Method should not update an Ultra track container record.
      * @Date: 01/02/2017
      **/
    static testMethod void updateSettingTestCase2() {
        Ultra_Track_Container__c ultraTrackContainerobj = new Ultra_Track_Container__c();
        UltraSetupController ultraSetupObj = updateSettingTestData(new list<String> {'Account'},
                                                                   new list<String> {'Account'},
                                                                   new list<Boolean> {false},
                                                                   new list<String> ()
                                                                   );

        Test.startTest();
        UltraSetupController.objects = 'Account (Account)';
        // In this case scenario no need to set mock because updateSetting method will not call futrue method
        // if selectedFieldSet param is passed as null.
        UltraSetupController.UpdateSetting(null,null,null,null,null);
        test.stopTest();

        list<Ultra_Track_Container__c> updatedUltraultraTrackContainerList = [SELECT Id,
                                                                                     Is_Tracking_Enabled__c,
                                                                                     Tracked_Fields__c
                                                                              FROM Ultra_Track_Container__c
                                                                              ];

        System.assertEquals(null, updatedUltraultraTrackContainerList[0].Tracked_Fields__c);
        System.assertEquals(false, updatedUltraultraTrackContainerList[0].Is_Tracking_Enabled__c);
    }
    
    /**
      * @Author: Eternus Solutions
      * @Description: checkTriggerDeployementStatus test case
      *               Selected an object.
      *               Insert Ultra container record.
      *               Set correct value for asynResultId.
      * @Expected Result: Method should update an Ultra track container record regarding status of deployment.
      * @Date: 01/02/2017
      **/
    static testMethod void checkTriggerDeployementStatusTestCase1() {
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseForSetupController1());
        
        UltraSetupController ultraSetupObj = new UltraSetupController();
        
        list<Ultra_Track_Container__c> ultraTrackContainerList = new list<Ultra_Track_Container__c>();
        ultraTrackContainerList.addAll(TestDataFactory.getUltraTrackContainerList(new list<String> {'Account'},
                                                                                  new list<String> {'Account'},
                                                                                  new list<Boolean>{true},
                                                                                  new list<String>{'Name', 'Phone', 'Email'}
                                                                                  )
                                      );

        insert ultraTrackContainerList;
        
        Test.startTest();
        UltraSetupController.objects = 'Account (Account)';
        UltraSetupController.asynResultId = ultraTrackContainerList[0].Id;
        UltraSetupController.checkTriggerDeploymentStatus(UltraSetupController.asynResultId,
                                                               true,
                                                               25,
                                                               UltraSetupController.objects,
                                                               'Read');
        test.stopTest();
            
        list<Ultra_Track_Container__c> containerList = [SELECT Id, Trigger_Status__c, Trigger_Deploy_Error__c, Is_Tracking_Enabled__c
                                                        FROM Ultra_Track_Container__c
                                                        WHERE Object_Name__c = 'Account'
                                                       ];
        System.assertEquals(containerList[0].Trigger_Status__c, 'Deployed');
        System.assertEquals(containerList[0].Is_Tracking_Enabled__c, true);
        System.assertEquals(containerList[0].Trigger_Deploy_Error__c, 'Trigger Deployment Completed Successfully.');
        System.assertEquals(true, UltraSetupController.enablePollar);
    }
    
    /**
      * @Author: Eternus Solutions
      * @Description: checkTriggerDeployementStatus test case
      *               Selected an object.
      *               Insert Ultra container record.
      *               Set NULL value for asynResultId.
      *               Pass flase and null value to method
      * @Expected Result: Method should not update an Ultra track container record regarding status of deployment.
      * @Date: 01/02/2017
      **/
    static testMethod void checkTriggerDeployementStatusTestCase2() {
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseForSetupController1());
        
        UltraSetupController ultraSetupObj = new UltraSetupController();
        
        list<Ultra_Track_Container__c> ultraTrackContainerList = new list<Ultra_Track_Container__c>();
        ultraTrackContainerList.addAll(TestDataFactory.getUltraTrackContainerList(new list<String> {'Account'},
                                                                                  new list<String> {'Account'},
                                                                                  new list<Boolean>{true},
                                                                                  new list<String>{'Name', 'Phone', 'Email'}
                                                                                  )
                                      );

        insert ultraTrackContainerList;
        
        Test.startTest();
        UltraSetupController.asynResultId = null;
        UltraSetupController.checkTriggerDeploymentStatus(UltraSetupController.asynResultId,
                                                               true,
                                                               25,
                                                               UltraSetupController.objects,
                                                               'Read');
        test.stopTest();
            
        list<Ultra_Track_Container__c> containerList = [SELECT Id, Trigger_Status__c, Trigger_Deploy_Error__c, Is_Tracking_Enabled__c
                                                        FROM Ultra_Track_Container__c
                                                        WHERE Object_Name__c = 'Account'
                                                       ];
        System.assertEquals(containerList[0].Trigger_Status__c, null);
        System.assertEquals(containerList[0].Is_Tracking_Enabled__c, true);
        System.assertEquals(containerList[0].Trigger_Deploy_Error__c, null);
    }
    
    /**
      * @Author: Eternus Solutions
      * @Description: deployStatusHelper test case
      *               Selected an object.
      *               Insert Ultra container record.
      *               Pass flase and null value to method
      *               Set correct value for asynResultId.
      * @Expected Result: Method should not update an Ultra track container record regarding status of deployment.
      * @Date: 01/02/2017
      **/
    static testMethod void deployStatusHelperTestCase1() {
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseForSetupController1());
        
        UltraSetupController ultraSetupObj = new UltraSetupController();
        
        list<Ultra_Track_Container__c> ultraTrackContainerList = new list<Ultra_Track_Container__c>();
        ultraTrackContainerList.addAll(TestDataFactory.getUltraTrackContainerList(new list<String> {'Account'},
                                                                                  new list<String> {'Account'},
                                                                                  new list<Boolean>{true},
                                                                                  new list<String>{'Name', 'Phone', 'Email'}
                                                                                  )
                                      );

        insert ultraTrackContainerList;
        
        Test.startTest();
        UltraSetupController.objects = 'Account (Account)';
        UltraSetupController.asynResultId = ultraTrackContainerList[0].Id;
        UltraSetupController.deployStatusHelper(false, null,false,0, UltraSetupController.objects,'Read');
        test.stopTest();
            
        list<Ultra_Track_Container__c> containerList = [SELECT Id, Trigger_Status__c, Trigger_Deploy_Error__c, Is_Tracking_Enabled__c
                                                        FROM Ultra_Track_Container__c
                                                        WHERE Object_Name__c = 'Account'
                                                       ];
        System.assertEquals(containerList[0].Trigger_Status__c, null);
        System.assertEquals(containerList[0].Is_Tracking_Enabled__c, true);
        System.assertEquals(containerList[0].Trigger_Deploy_Error__c, null);
            
    }
    
    /**
      * @Author: Eternus Solutions
      * @Description: Created test data method to fetch ultra track container Object name.
      * @Param: NA
      * @Return: Method should return ultra track container Name.
      * @Date: 01/02/2017
      **/
    static testMethod void getNotificationMethodCase1() {
        
        UFHT__Feature_Installation_Master__c installDetails = new UFHT__Feature_Installation_Master__c();
        
        installDetails.Name = 'FEATURE_FHT';
        installDetails.Is_Active__c = false;
        installDetails.License_Days_Remaining__c = -1;
        
        insert installDetails;
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseForSetupController1());
        Test.startTest();
        UltraSetupController ultraSetupObj = new UltraSetupController();
        system.assertEquals(LMSConstants.MSG_PACKAGE_SUSPENDED, ultraSetupObj.licenseMessage); 
        Test.stopTest();      
    }
    
    static testMethod void getNotificationMethodCase2() {
        
        UFHT__Feature_Installation_Master__c installDetails = new UFHT__Feature_Installation_Master__c();
        
        installDetails.Name = 'FEATURE_FHT';
        installDetails.Is_Active__c = false;
        installDetails.License_Days_Remaining__c = 0;
        
        insert installDetails;
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseForSetupController1());
        Test.startTest();
        UltraSetupController ultraSetupObj = new UltraSetupController();
        system.assertEquals(LMSConstants.MSG_PACKAGE_EXPIRED, ultraSetupObj.licenseMessage);
        Test.stopTest();      
    }
    
    static testMethod void getNotificationMethodCase3() {
        
        UFHT__Feature_Installation_Master__c installDetails = new UFHT__Feature_Installation_Master__c();
        
        installDetails.Name = 'FEATURE_FHT';
        installDetails.Is_Active__c = false;
        installDetails.License_Days_Remaining__c = 12;
        
        insert installDetails;
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseForSetupController1());
        Test.startTest();
        UltraSetupController ultraSetupObj = new UltraSetupController();
        system.assertEquals('Your subscription for Ultra FieldHistory Tracker is about to expire in <b>12 day(s)</b>. Please contact <a href="mailto:sales@eternussolutions.com?cc=appsupport@eternussolutions.com">sales@eternussolutions.com</a> for license renewal (<a href="javascript:void(0)" onClick="return renewalLicense();" >Purchase Now</a>)', ultraSetupObj.licenseMessage);
        Test.stopTest();      
    }
    
    static testMethod void getNotificationMethodCase4() {
        
        UFHT__Feature_Installation_Master__c installDetails = new UFHT__Feature_Installation_Master__c();
        
        installDetails.Name = 'FEATURE_FHT';
        installDetails.Is_Active__c = false;
        installDetails.License_Days_Remaining__c = 20;
        
        insert installDetails;
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseForSetupController1());
        Test.startTest();
        UltraSetupController ultraSetupObj = new UltraSetupController();
        system.assertEquals(LMSConstants.MSG_INVALID_LICENSE_NOTIFICATION , ultraSetupObj.licenseMessage);
        Test.stopTest();      
    }
    
    static testMethod void getNotificationMethodCase5() {
        
        UFHT__Feature_Installation_Master__c installDetails = new UFHT__Feature_Installation_Master__c();
        
        installDetails.Name = 'FEATURE_FHT';
        installDetails.Is_Active__c = true;
        installDetails.License_Days_Remaining__c = 20;
        
        insert installDetails;
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseForSetupController1());
        Test.startTest();
        UltraSetupController ultraSetupObj = new UltraSetupController();
        system.assertEquals(null, ultraSetupObj.licenseMessage);
        Test.stopTest();      
    }

    static testMethod void renewalLicenseCheckMethod() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseForSetupController1());
        UltraSetupController ultraSetupObj = new UltraSetupController();
        
        Test.startTest();
        ultraSetupObj.renewalLicenseCheck();
        system.assertEquals(LMSConstants.MSG_INVALID_LICENSE_NOTIFICATION ,ultraSetupObj.licenseMessage);
        Test.stopTest();      
    }

}