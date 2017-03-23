/**
 * @Class Name: UltraSetupControllerTest
 * @Description: This class contains unit tests for UltraSetupController.cls
 * =========================================================================================================
 *       Version   | Date        | Author             | Comments
 * ----------------------------------------------------------------------------------------------------------
 *       1.0       | 26/02/2016  | Eternus Solutions  | 1.Created the Test Class for UltraSetupController
 * ==========================================================================================================
 **/
@isTest
private class UltraSetupControllerTest {

    /**
       * @Author: Eternus Solutions
       * @Description: Generic method to check asserts from the list provided.
       * @Params: List of list of Objects, in inner list: 1st item - Expected value, 2nd item - actual value
       * @Date: 09/08/2016
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
    static void getConfigurationSettingDataTestData(Boolean isInsert,
                                                    Integer numberOfColumns,
                                                    Integer numberOfFieldsPerColumns,
                                                    Integer numberOfRecordToDisplayPicklistValue,
                                                    String sortFieldsValue,
                                                    String baseUrl) {

        if(isInsert) {
            Configuration__c configurationObj = TestDataFactory.getConfiguration(numberOfColumns,
                                                                                 numberOfFieldsPerColumns,
                                                                                 numberOfRecordToDisplayPicklistValue,
                                                                                 sortFieldsValue,
                                                                                 baseUrl);
            insert configurationObj;
        }

        Test.setMock(HttpCalloutMock.class, new MockHttpResponseForSetupController1());

        PageReference pageRef = Page.Ultra_Setup;
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
    static void getConfigurationSettingDataTest(Boolean configIsInsert,
                                                Integer configNumberOfColumns,
                                                Integer configNumberOfFieldsPerColumns,
                                                Integer configNumberOfRecordToDisplay,
                                                String configSortFieldsValue,
                                                String configBaseUrl,
                                                Integer assertNumberOfColumns,
                                                Integer assertNumberOfFieldsPerColumns,
                                                Integer assertNumberOfRecordToDisplay,
                                                String assertSortFieldsValue,
                                                Integer assertPageSize) {

        getConfigurationSettingDataTestData(configIsInsert,
                                            configNumberOfColumns,
                                            configNumberOfFieldsPerColumns,
                                            configNumberOfRecordToDisplay,
                                            configSortFieldsValue,
                                            configBaseUrl);
        Test.startTest();
        UltraSetupController ultraSetupObj = new UltraSetupController();
        Test.stopTest();

        performAsserts(new list<list<Object>> {
            new list<Object> {assertNumberOfColumns, ultraSetupObj.numberOfColumns},
            new list<Object> {assertNumberOfFieldsPerColumns, ultraSetupObj.numberOfFieldsPerColumns},
            new list<Object> {assertNumberOfRecordToDisplay, ultraSetupObj.numberOfRecordToDisplayPicklistValue},
            new list<Object> {assertSortFieldsValue, ultraSetupObj.sortFieldsValue},
            new list<Object> {assertPageSize, ultraSetupObj.pageSize}
        });
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
    static void setConfigurationSettingDataTest(String configNumberOfColumns,
                                                String configNumberOfFieldsPerColumns,
                                                String configNumberOfRecordToDisplay,
                                                String configSortFieldsValue,
                                                String configBaseUrl,
                                                Integer assertNumberOfColumns,
                                                Integer assertNumberOfFieldsPerColumns,
                                                Integer assertNumberOfRecordToDisplay,
                                                String assertSortFieldsValue) {

        getConfigurationSettingDataTestData(false,
                                            null,
                                            null,
                                            null,
                                            null,
                                            null);

        UltraSetupController ultraSetupObj = new UltraSetupController();
        Test.startTest();
        ultraSetupObj.setConfigurationSettingData(configNumberOfColumns,
                                                  configNumberOfFieldsPerColumns,
                                                  configNumberOfRecordToDisplay,
                                                  configSortFieldsValue,
                                                  configBaseUrl);
        Test.stopTest();

        performAsserts(new list<list<Object>> {
            new list<Object> {assertNumberOfColumns, ultraSetupObj.numberOfColumns},
            new list<Object> {assertNumberOfFieldsPerColumns, ultraSetupObj.numberOfFieldsPerColumns},
            new list<Object> {assertNumberOfRecordToDisplay, ultraSetupObj.numberOfRecordToDisplayPicklistValue},
            new list<Object> {assertSortFieldsValue, ultraSetupObj.sortFieldsValue},
            new list<Object> {0, ultraSetupObj.pageNumber},
            new list<Object> {false, ultraSetupObj.isObject},
            new list<Object> {false, ultraSetupObj.isAllSelected},
            new list<Object> {false, ultraSetupObj.isRemoteSiteSettings}
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
            new list<Object> {assertObjListSize, ultraSetupObj.objList.size()},
            new list<Object> {assertIsRemoteSiteSetting, ultraSetupObj.isRemoteSiteSettings}
        };

        if(isInvalidProtocol == true) {
            ApexPages.Message[] pageMessages = ApexPages.getMessages();
            assertionValuesList.add(new list<Object> {'ERROR', String.valueOf(pageMessages[0].getSeverity()) });
            assertionValuesList.add(new list<Object> {'Invalid protocol.', pageMessages[0].getSummary() });
        }

        performAsserts(assertionValuesList);
    }

    /**
       * @Author: Eternus Solutions
       * @Description: Template Method for testing refresh method.
       * @Param: 1. objectsValue: Value for objects property.
       * @Return: NA
       * @Date: 09/08/2016
       **/
    static void refreshTest(String objectsValue) {

        UltraSetupController ultraSetupObj = updateSettingTestData(new list<String> {'Account'},
                                                                   new list<String> {'Account'},
                                                                   new list<Boolean> {true},
                                                                   new list<String> {'Email, Name, Phone'}
                                                                   );
        Test.startTest();
        ultraSetupObj.objects = objectsValue;
        ultraSetupObj.refresh();
        test.stopTest();

        Integer assertWrapperListSize = String.isBlank(objectsValue)
                                      ? 0
                                      : ultraSetupObj.pageSize / Integer.valueOf(ultraSetupObj.numberOfColumns);

        performAsserts(new list<list<Object>> {
            new list<Object> {false, ultraSetupObj.isAllSelected},
            new list<Object> {0, ultraSetupObj.counter},
            new list<Object> {1, ultraSetupObj.pageNumber},
            new list<Object> {assertWrapperListSize, ultraSetupObj.lstWrapperClassList.size()}
        });
    }

    /**
       * @Author: Eternus Solutions
       * @Description: Template Method for testing saveAndUpdateConfigurationSetting method.
       * @Param: 1. isObjectSelected: Boolean indicating if an object is selected..
       * @Return: NA
       * @Date: 09/08/2016
       **/
    static void saveAndUpdateConfigurationSettingTest(Boolean isObjectSelected) {
        getConfigurationSettingDataTestData(true,
                                            4,
                                            8,
                                            12,
                                            System.Label.DefaultFieldSortingOption,
                                            URL.getSalesforceBaseUrl().getHost());

        UltraSetupController ultraSetupObj = new UltraSetupController();

        Test.startTest();
        if(isObjectSelected == true) {
            ultraSetupObj.objects = 'Account (Account)';
            ultraSetupObj.getFieldsList();
        }
        ultraSetupObj.saveAndUpdateConfigurationSetting();
        test.stopTest();

        Map<String, Configuration__c> mapConfig = Configuration__c.getAll();
        list<Configuration__c> configurationUpdatedList = new list<Configuration__c>
                                                         {Configuration__c.getAll().get
                                                         (System.Label.ConfigureColsAndFieldsCustomSettingRecordName)
                                                         };

        list<list<Object>> assertionValuesList = new list<list<Object>> {
            new list<Object> {ultraSetupObj.numberOfColumnsPicklistValue, configurationUpdatedList[0].Number_Of_Columns__c},
            new list<Object> {ultraSetupObj.numberOfFieldsPerColumnsPicklistValue, configurationUpdatedList[0].Number_Of_Fields_Per_Column__c},
            new list<Object> {ultraSetupObj.numberOfRecordToDisplayPicklistValue, configurationUpdatedList[0].Number_Of_Records_Per_Page__c}
        };

        if(isObjectSelected == true) {
            assertionValuesList.add(new list<Object> {0, ultraSetupObj.counter});
            assertionValuesList.add(new list<Object> {1, ultraSetupObj.pageNumber});
            assertionValuesList.add(new list<Object> {false, ultraSetupObj.allFieldswrapperClassList.isEmpty()});
        }

        performAsserts(assertionValuesList);
    }

    /**
       * @Author: Eternus Solutions
       * @Description: Template Method for testing getHasNext method.
       * @Param: 1. isOnLastPage: Boolean indicating if last() method is to be called.
       * @Return: NA
       * @Date: 09/08/2016
       **/
    static void getHasNextTest(Boolean isOnLastPage) {

        list<Ultra_Track_Container__c> ultraTrackContainerList = new list<Ultra_Track_Container__c>();

        Configuration__c configurationObj = TestDataFactory.getConfiguration(4,
                                                                             8,
                                                                             12,
                                                                             System.Label.DefaultFieldSortingOption,
                                                                             URL.getSalesforceBaseUrl().getHost());
        insert configurationObj;

        UltraSetupController ultraSetupObj = updateSettingTestData(new list<String> {'Account'},
                                                                    new list<String> {'Account'},
                                                                    new list<Boolean> {true},
                                                                    new list<String> {'Email, Name, Phone'}
                                                                   );

        Test.startTest();
        ultraSetupObj.objects = 'Account(Account)';
        ultraSetupObj.refresh();
        if(isOnLastPage == true) {
            ultraSetupObj.last();
        }
        Boolean hasNext = ultraSetupObj.getHasNext();
        test.stopTest();

        performAsserts(new list<list<Object>> {
            new list<Object> {isOnLastPage, hasNext}
        });
    }

    /**
       * @Author: Eternus Solutions
       * @Description: Template Method for testing getHasPrevious method.
       * @Param: 1. isOnFirstPage: Boolean indicating if first() method is to be called.
       * @Return: NA
       * @Date: 09/08/2016
       **/
    static void getHasPreviousTest(Boolean isOnFirstPage) {

        list<Ultra_Track_Container__c> ultraTrackContainerList = new list<Ultra_Track_Container__c>();

        Configuration__c configurationObj = TestDataFactory.getConfiguration(4,
                                                                             8,
                                                                             12,
                                                                             System.Label.DefaultFieldSortingOption,
                                                                             URL.getSalesforceBaseUrl().getHost());
        insert configurationObj;

        UltraSetupController ultraSetupObj = updateSettingTestData(new list<String> {'Account'},
                                                                   new list<String> {'Account'},
                                                                   new list<Boolean> {true},
                                                                   new list<String> {'Email, Name, Phone'}
                                                                   );

        Test.startTest();
        ultraSetupObj.objects = 'Account(Account)';
        ultraSetupObj.refresh();
        if(isOnFirstPage == false) {
            ultraSetupObj.next();
        }
        Boolean hasPrevious = ultraSetupObj.getHasPrevious();
        test.stopTest();

        performAsserts(new list<list<Object>> {
            new list<Object> {isOnFirstPage, hasPrevious}
        });
    }

    /**
       * @Author: Eternus Solutions
       * @Description: Template Method for testing first method.
       * @Param: 1. objectsValue: Value for objects property.
       * @Return: NA
       * @Date: 10/08/2016
       **/
    static void firstTest(String objectsValue) {

        Integer assertWrapperListSize = 0;

        UltraSetupController ultraSetupObj = updateSettingTestData(new list<String> {'Account'},
                                                                    new list<String> {'Account'},
                                                                    new list<Boolean> {true},
                                                                    new list<String> {'Email, Name, Phone'}
                                                                   );

        Test.startTest();
        ultraSetupObj.objects = objectsValue;
        if(String.isNotBlank(objectsValue)) {
            ultraSetupObj.getFieldsList();
        }
        ultraSetupObj.first();
        test.stopTest();

        assertWrapperListSize = String.isNotBlank(objectsValue)
                              ? ultraSetupObj.pageSize / Integer.valueOf(ultraSetupObj.numberOfColumns)
                              : 0;

        performAsserts(new list<list<Object>> {
            new list<Object> {false, ultraSetupObj.isAllSelected},
            new list<Object> {0, ultraSetupObj.counter},
            new list<Object> {1, ultraSetupObj.pageNumber},
            new list<Object> {assertWrapperListSize, ultraSetupObj.lstWrapperClassList.size()}
        });
    }

    /**
       * @Author: Eternus Solutions
       * @Description: Template Method for testing selectAllCheckboxes method.
       * @Param: 1. ultraTrackWrapperList: list of input UltraTrackWrappers.
       *         2. assertIsAllSelected: Expected value for isAllSelected property.
       * @Return: NA
       * @Date: 10/08/2016
       **/
    static void selectAllCheckboxesTest(list<UltraTrackWrapper> ultraTrackWrapperList,
                                        Boolean assertIsAllSelected) {

        getConfigurationSettingDataTestData(false,
                                            null,
                                            null,
                                            null,
                                            null,
                                            null);

        UltraSetupController ultraSetupObj = new UltraSetupController();
        Test.startTest();
        ultraSetupObj.selectAllCheckboxes(ultraTrackWrapperList);
        test.stopTest();

        performAsserts(new list<list<Object>> {
            new list<Object> {assertIsAllSelected, ultraSetupObj.isAllSelected}
        });
    }

    /**
       * @Author: Eternus Solutions
       * @Description: Template Method for testing selectAllCheckboxes method without URL parameters.
       * @Param: 1. isAllSelectedValue: Value for isAllSelected property.
       * @Return: NA
       * @Date: 10/08/2016
       **/
    static void selectAllCheckboxesWithOutParamTest(Boolean isAllSelectedValue) {

        getConfigurationSettingDataTestData(false,
                                            null,
                                            null,
                                            null,
                                            null,
                                            null);

        UltraSetupController ultraSetupObj = new UltraSetupController();

        Test.startTest();
        ultraSetupObj.objects = 'Account (Account)';
        ultraSetupObj.getFieldsList();
        ultraSetupObj.isAllSelected = isAllSelectedValue;
        ultraSetupObj.selectAllCheckboxes();
        test.stopTest();

        list<list<Object>> assertionValuesList = new list<list<Object>>();
        for(UltraTrackWrapper wrapperIterator : ultraSetupObj.allFieldswrapperClassList) {
             assertionValuesList.add(new list<Object> {wrapperIterator.isSelected, ultraSetupObj.isAllSelected});
        }

        performAsserts(assertionValuesList);
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
       * @Date: 10/08/2016
       **/
    static void getCommaSeparatedFieldsTest(set<String> fieldNamesSet,
                                            String assertCommaSeparatedString) {

        getConfigurationSettingDataTestData(false,
                                            null,
                                            null,
                                            null,
                                            null,
                                            null);

        UltraSetupController ultraSetupObj = new UltraSetupController();

        Test.startTest();
        String commaSeparatedString = ultraSetupObj.getCommaSepratedFields(fieldNamesSet);
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
       *         5. assertPageMessageSeverity: Expected value for page message severity.
       *         6. assertPageMessageSummary: Expected value for page message summary.
       *         7. assertIsObject: Expected value for isObject property.
       * @Return: NA
       * @Date: 10/08/2016
       **/
    static void getFieldsListTest(list<String> fieldNamesList,
                                  String objectsValue,
                                  Boolean isInvalidObject,
                                  Integer assertFieldCount,
                                  String assertPageMessageSeverity,
                                  String assertPageMessageSummary,
                                  Boolean assertIsObject) {

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
        ultraSetupObj.objects = objectsValue;
        ultraSetupObj.getFieldsList();
        test.stopTest();

        if(isInvalidObject == false) {
            map<String, String> fieldsForObject =  UltraTrackUtility.getFieldNamesAndLabels('Account');
            integer selectedFieldCount = 0;

            assertionValuesList.add(new list<Object> {fieldsForObject.size(), ultraSetupObj.allFieldswrapperClassList.size()} );
            for(UltraTrackWrapper wrapper : ultraSetupObj.allFieldswrapperClassList) {
                if(wrapper.isSelected) {
                    selectedFieldCount++;
                }
            }

            assertionValuesList.add(new list<Object> {0, selectedFieldCount} );
        } else {
            assertionValuesList.add(new list<Object> {0, ultraSetupObj.allFieldswrapperClassList.size()} );
            assertionValuesList.add(new list<Object> {false, ultraSetupObj.isObject} );

            if(String.isNotBlank(assertPageMessageSeverity)
            && String.isNotBlank(assertPageMessageSummary)) {

                ApexPages.Message[] pageMessages = ApexPages.getMessages();

                assertionValuesList.add(new list<Object>{assertPageMessageSeverity, String.valueOf(pageMessages[0].getSeverity())});
                assertionValuesList.add(new list<Object>{assertPageMessageSummary, pageMessages[0].getSummary()});
            }
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
       * @Date: 10/08/2016
       **/
    static void saveSettingTest(set<String> fieldNamesSet,
                                Boolean isMockNeeded,
                                Boolean isManualSelection,
                                Boolean isExpectedListEmpty,
                                String assertPageMessageSeverity,
                                String assertPageMessageSummary) {

        list<list<Object>> assertionValuesList = new list<list<Object>>();
        Integer assertFieldListSize = 0;

        getConfigurationSettingDataTestData(false,
                                            null,
                                            null,
                                            null,
                                            null,
                                            null);

        UltraSetupController ultraSetupObj = new UltraSetupController();

        Test.startTest();

        if(isMockNeeded == true) {
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseDyanamicTriggerGenerator());
        }

        ultraSetupObj.objects = 'Account (Account)';

        if(isManualSelection == true) {
            ultraSetupObj.getFieldsList();
            ultraSetupObj.allFieldswrapperClassList[0].isSelected = true;
            ultraSetupObj.allFieldswrapperClassList[1].isSelected = true;
            ultraSetupObj.selectedFieldsName();
            assertFieldListSize = 2;
        }

        else {
            ultraSetupObj.saveSetting(fieldNamesSet);
            assertFieldListSize = fieldNamesSet != null
                                ? fieldNamesSet.size()
                                : 0;
        }
        test.stopTest();

        list<Ultra_Track_Container__c> insertedUltraultraTrackContainerList = [SELECT Id,
                                                                                      Is_Tracking_Enabled__c,
                                                                                      Tracked_Fields__c,
                                                                                      Object_Label__c,
                                                                                      Object_Name__c
                                                                                 FROM Ultra_Track_Container__c];

        assertionValuesList.add(new list<Object>{isExpectedListEmpty, insertedUltraultraTrackContainerList.isEmpty()});

        if(isExpectedListEmpty == false) {
            list<String> trackedField = insertedUltraultraTrackContainerList[0].Tracked_Fields__c.split(',');
            assertionValuesList.add(new list<Object>{assertFieldListSize, trackedField.size()});
            assertionValuesList.add(new list<Object>{true, insertedUltraultraTrackContainerList[0].Is_Tracking_Enabled__c});
            assertionValuesList.add(new list<Object>{'Account', insertedUltraultraTrackContainerList[0].Object_Name__c});
            assertionValuesList.add(new list<Object>{'Account (Account)', insertedUltraultraTrackContainerList[0].Object_Label__c});
            assertionValuesList.add(new list<Object>{false, ultraSetupObj.isObject});
        }

        if(String.isNotBlank(assertPageMessageSeverity)
        && String.isNotBlank(assertPageMessageSummary)) {

            ApexPages.Message[] pageMessages = ApexPages.getMessages();

            assertionValuesList.add(new list<Object>{assertPageMessageSeverity, String.valueOf(pageMessages[0].getSeverity())});
            assertionValuesList.add(new list<Object>{assertPageMessageSummary, pageMessages[0].getSummary()});
        }

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
            true, 4, 8, 12, System.Label.DefaultFieldSortingOption, Url.getSalesforceBaseUrl().toExternalForm(),
            4, 8, 12, System.Label.DefaultFieldSortingOption, 32
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

        getConfigurationSettingDataTest(
            false, null, null, null, null, null,
            5, 10, 25, System.Label.DefaultFieldSortingOption, 50
        );
    }


    /**
       * @Author: Eternus Solutions
       * @Description: Test method to test with following scenario: values for numberOfColumns, numberOfFieldsPerColumns,
       *               numberOfRecordToDisplayPicklistValue, sortFieldsValue should assign properly when Configuration record aleardy
       *               inserted with all null values.
       * @Expected Result: Method should assign default values numberOfColumns, numberOfFieldsPerColumns,
       *                   numberOfRecordToDisplayPicklistValue, baseURL and pageSize.
       * @Date: 22/07/2016
       **/
   static testMethod void getConfigurationSettingDataTestCase3() {

        getConfigurationSettingDataTest(
            true, null, null, null, null, null,
            5, 10, 25, System.Label.DefaultFieldSortingOption, 50
        );
    }

    /**
       * @Author: Eternus Solutions
       * @Description: Test method to test with following scenario: values for numberOfColumns, numberOfFieldsPerColumns,
       *               numberOfRecordToDisplayPicklistValue, sortFieldsValue should assign properly configuration records with numberOfColumns,
       *               numberOfRecordToDisplayPicklistValue, sortFieldsValue with valid input and numberOfFieldsPerColumns, baseUrl with null.
       * @Expected Result: Method should assign passed values numberOfColumns, numberOfFieldsPerColumns,
       *                   numberOfRecordToDisplayPicklistValue, baseURL and pageSize.
       * @Date: 22/07/2016
       **/
    static testMethod void getConfigurationSettingDataTestCase4() {

        getConfigurationSettingDataTest(
            true, 4, null, 12, System.Label.DefaultFieldSortingOption, null,
            4, 10, 12, System.Label.DefaultFieldSortingOption, 40
        );

    }

    /**
       * @Author: Eternus Solutions
       * @Description: Test method to test with following scenario: method should assign correct values to numberOfColumns, numberOfFieldsPerColumns,
       *               numberOfRecordToDisplayPicklistValue, baseURL and sortFieldsValue when configuration record is not inserted.
       * @Expected Result: Method should assign default values numberOfColumns, numberOfFieldsPerColumns,
       *                   numberOfRecordToDisplayPicklistValue, baseURL and sortFieldsValue.
       * @Date: 22/07/2016
       **/
    static testMethod void setConfigurationSettingDataTestCase1() {

        setConfigurationSettingDataTest(
            '8', '10', '20', System.Label.DefaultFieldSortingOption, Url.getSalesforceBaseUrl().toExternalForm(),
            8, 10, 20, System.Label.DefaultFieldSortingOption);
    }

    /**
       * @Author: Eternus Solutions
       * @Description: Test method to test with following scenario: method with numberOfColumns, numberOfFieldsPerColumns,
       *               numberOfRecordToDisplayPicklistValue as blank and sortFieldsValue, baseUrl with valid values.
       * @Expected Result: Method should assign default values numberOfColumns, numberOfFieldsPerColumns,
       *                   numberOfRecordToDisplayPicklistValue, baseURL and sortFieldsValue.
       * @Date: 22/07/2016
       **/
    static testMethod void setConfigurationSettingDataTestCase2() {

        setConfigurationSettingDataTest(
            '', '', '', System.Label.DefaultFieldSortingOption, Url.getSalesforceBaseUrl().toExternalForm(),
            5, 10, 25, System.Label.DefaultFieldSortingOption);
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

       setConfigurationSettingDataTest(
            '', '', '', '', '',
            5, 10, 25, System.Label.DefaultFieldSortingOption);
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test method to test with following scenario: method numberOfColumns, numberOfFieldsPerColumns,
      *               numberOfRecordToDisplayPicklistValue, sortFieldsValue and baseUrl with valid values.
      * @Expected Result: Method should assign default values numberOfColumns, numberOfFieldsPerColumns,
      *                   numberOfRecordToDisplayPicklistValue, baseURL and sortFieldsValue.
      * @Date: 22/07/2016
      **/
    static testMethod void setConfigurationSettingDataTestCase4() {

        setConfigurationSettingDataTest(
            null, null, null, null, null,
            5, 10, 25, System.Label.DefaultFieldSortingOption);
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

    /**
      * @Author: Eternus Solutions
      * @Description: getFieldsList test case to test method with following steps:
      *               Inserted Ultra_Track_Container__c record for an object.
      *               Selected an object.
      *               Two fields selected for field tracking.
      * Expected Result: Method should assign values in isSelected true for 2 fields for an object.
      * @Date: 02/03/2016
      **/
    static testMethod void getFieldsListTestCase1() {
        getFieldsListTest(
            new list<String> {'Email, Name, Phone'}, 'Account (Account)', false,
            0, null, null, true
        );
    }

    /**
      * @Author: Eternus Solutions
      * @Description: getFieldsList test case to test method with following steps:
      *               Inserted Ultra_Track_Container__c record for an object.
      *               Selected an object.
      *               No fields selected for field tracking.
      * @Expected Result: Method should assign values in isSelected is false for all fields of an object.
      * @Date: 02/03/2016
      **/
    static testMethod void getFieldsListTestCase2() {
        getFieldsListTest(
            new list<String>(), 'Account (Account)', false,
            0, null, null, true
        );
    }

    /**
      * @Author: Eternus Solutions
      * @Description: getFieldsList test case to test method by selecting object as blank.
      * @Expected Result: Method should check if result is empty or not.
      * @Date: 02/03/2016
      **/
    static testMethod void getFieldsListTestCase3() {
        getFieldsListTest(
            new list<String>(), '', true,
            0, null, null, false
        );
    }

    /**
      * @Author: Eternus Solutions
      * @Description: getFieldsList test case to test method by adding selected object is not present.
      * @Expected Result: Method should check if result is empty or not.
      * @Date: 02/03/2016
      **/
    static testMethod void getFieldsListTestCase4() {
        getFieldsListTest(
            new list<String>(), 'Test', true,
            0, String.valueOf(ApexPages.severity.WARNING), UFHTConstants.WHITE_SPACE + System.Label.Object_Not_Found, false
        );
    }

    /**
      * @Author: Eternus Solutions
      * @Description: selectedFieldsName test case to test method with following steps:
      *               Inserted Ultra_Track_Container__c record for an object.
      *               Selected an object.
      *               Added two fields selected for field tracking.
      * @Expected Result: Method should assign values for all selected fields in selectedFieldSet.
      * @Date: 02/03/2016
      **/
    static testMethod void selectedFieldsNameTestCase1() {

        UltraSetupController ultraSetupObj = updateSettingTestData(new list<String> {'Account'},
                                                                   new list<String> {'Account'},
                                                                   new list<Boolean> {true},
                                                                   new list<String> {'Name, Phone'}
                                                                   );
        Test.startTest();
        ultraSetupObj.objects = 'Account (Account)';
        ultraSetupObj.getFieldsList();
        ultraSetupObj.selectedFieldsName();
        test.stopTest();

        System.assertEquals(1, ultraSetupObj.selectedFieldSet.size());
    }

    /**
      * @Author: Eternus Solutions
      * @Description: selectedFieldsName test case to test method with following steps:
      *               No Ultra_Track_Container__c record for an object.
      *               Selected an object.
      *               No fields selected for field tracking.
      * @Expected Result: Method should assign values for no selected fields in SELECTedFieldSet.
      * @Date: 02/03/2016
      **/
    static testMethod void selectedFieldsNameTestCase2() {

        Test.setMock(HttpCalloutMock.class, new MockHttpResponseForSetupController1());

        PageReference pageRef = Page.Ultra_Setup;
        Test.setCurrentPage(pageRef);

        UltraSetupController ultraSetupObj = new UltraSetupController();

        Test.startTest();
        ultraSetupObj.objects = 'Account(Account)';
        ultraSetupObj.getFieldsList();
        ultraSetupObj.selectedFieldsName();
        test.stopTest();

        System.assertEquals(0, ultraSetupObj.selectedFieldSet.size());
    }

    /**
      * @Author: Eternus Solutions
      * @Description: selectedFieldsName test case to test method with following steps:
      *               No Ultra_Track_Container__c record for an object.
      *               Selected an object.
      *               Two fields selected for field tracking.
      * @Expected Result: Method should assign values for two selected fields in selectedFieldSet.
      * @Date: 02/03/2016
      **/
    static testMethod void selectedFieldsNameTestCase3() {

        Test.setMock(HttpCalloutMock.class, new MockHttpResponseForSetupController1());

        PageReference pageRef = Page.Ultra_Setup;
        Test.setCurrentPage(pageRef);

        UltraSetupController ultraSetupObj = new UltraSetupController();

        Test.startTest();
        ultraSetupObj.objects = 'Account (Account)';
        ultraSetupObj.getFieldsList();
        ultraSetupObj.allFieldswrapperClassList[0].isSelected = true;
        ultraSetupObj.allFieldswrapperClassList[1].isSelected = true;
        ultraSetupObj.selectedFieldsName();
        test.stopTest();

        System.assertEquals(2, ultraSetupObj.selectedFieldSet.size());
    }

    /**
      * @Author: Eternus Solutions
      * @Description: selectedFieldsName test case to test method with following steps:
      *               Inserted Ultra_Track_Container__c record for an object.
      *               Selected an object.
      *               Added two fields selected for field tracking.
      *               Http callout fail and objList is empty.
      * @Expected Result: Method should check fields are not selected and added message on page.
      * @Date: 02/03/2016
      **/
    static testMethod void selectedFieldsNameTestCase4() {

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
        Test.startTest();
        ultraSetupObj.objects = 'Account (Account)';
        ultraSetupObj.getFieldsList();
        ultraSetupObj.selectedFieldsName();
        test.stopTest();

        System.assertEquals(0, ultraSetupObj.selectedFieldSet.size());
        ApexPages.Message[] pageMessages = ApexPages.getMessages();

        System.assertEquals(ApexPages.severity.WARNING, pageMessages[1].getSeverity());
        System.assertEquals(UFHTConstants.WHITE_SPACE + System.Label.Object_Not_Found, pageMessages[1].getSummary());
    }

    /**
      * @Author: Eternus Solutions
      * @Description: refresh test case to test method with following steps:
      *               Inserted Ultra_Track_Container__c record for an object.
      *               Selected an object.
      *               Not All fields selected for field tracking.
      * @Expected Result: Method should assign value to false value to isAllSelected.
      * @Date: 02/03/2016
      **/
    static testMethod void refreshTestCase1() {
        refreshTest('Account (Account)');
    }

    /**
      * @Author: Eternus Solutions
      * @Description: refresh test case to test method with following steps:
      *               No object is selected.
      *               Not All fields selected for field tracking.
      * @Expected Result: Method should assign value to false value to isAllSelected.
      * @Date: 02/03/2016
      **/
    static testMethod void refreshTestCase2() {
        refreshTest('');
    }

    /**
      * @Author: Eternus Solutions
      * @Description: selectAllCheckboxes test case to test method with empty list of UltraTrackWrapper.
      * @Expected Result: Method should assign value to false value to isAllSelected.
      * @Date: 02/03/2016
      **/
    static testMethod void selectAllCheckboxesTestCase1() {
        selectAllCheckboxesTest(new list<UltraTrackWrapper>(), false);
     }

    /**
      * @Author: Eternus Solutions
      * @Description: selectAllCheckboxes test case to test method with null value to list.
      * @Expected Result: Method should assign value to false value to isAllSelected.
      * @Date: 02/03/2016
      **/
    static testMethod void selectAllCheckboxesTestCase2() {
        selectAllCheckboxesTest(null, false);
     }

    /**
      * @Author: Eternus Solutions
      * @Description: selectAllCheckboxes test case to test method with valid data in list UltraTrackWrapper.
      * @Expected Result: Method should assign value to true value to isAllSelected
      *                   if isSelected of wrapper is true else false.
      * @Date: 02/03/2016
      **/
    static testMethod void selectAllCheckboxesTestCase3() {
        selectAllCheckboxesTest(
            TestDataFactory.getUltraTrackList(
                new list<String> {'Name', 'Phone', 'Email'},
                new list<String> {'Name', 'Phone', 'Email'},
                new list<list<HistoryWrapper>>(),
                new list<Boolean>{true, true, true}
            ),
            true
        );
     }

    /**
      * @Author: Eternus Solutions
      * @Description: selectAllCheckboxes test
      *               selectAllCheckboxes test case to test method with list UltraTrackWrapper.
      * @Expected Result: Method should assign value to true value to isAllSelected
      *                   if isSelected of wrapper is true else false.
      * @Date: 02/03/2016
      **/
    static testMethod void selectAllCheckboxesTestCase4() {
        selectAllCheckboxesTest(
            TestDataFactory.getUltraTrackList(
                new list<String> {'Name', 'Phone', 'Email'},
                new list<String> {'Name', 'Phone', 'Email'},
                new list<list<HistoryWrapper>>(),
                new list<Boolean>{true, false, true}
            ),
            false
        );
     }

    /**
      * @Author: Eternus Solutions
      * @Description: selectAllCheckboxes test case to test method without parameter and Set isAllSelected is true.
      * @Expected Result: Method should assign value to true value to isAllSelected
      *                   if isSelected of wrapper is true else false.
      * @Date: 02/03/2016
      **/
    static testMethod void selectAllCheckboxesWithOutParamTestCase1() {
        selectAllCheckboxesWithOutParamTest(true);
    }

    /**
      * @Author: Eternus Solutions
      * @Description: selectAllCheckboxes test case to test method without parameter and Set isAllSelected is false
      * @Expected Result: Method should assign value to true value to isAllSelected
      *                   if isSelected of wrapper is true else false.
      * @Date: 02/03/2016
      **/
    static testMethod void selectAllCheckboxesWithOutParamTestCase2() {
        selectAllCheckboxesWithOutParamTest(false);
     }

    /**
      * @Author: Eternus Solutions
      * @Description: saveSetting test case to test method with following steps:
      *               No Ultra_Track_Container__c record for an object.
      *               Selected an object.
      *               Passed three fields to method.
      * @Expected Result: Method should insert Ultra_Track_Container__c record with Selected fields and Is_Tracking_Enabled__c as true.
      * @Date: 02/03/2016
      **/
    static testMethod void saveSettingTestCase1() {

        saveSettingTest(
            new set<String>{'Name', 'Phone', 'Email'}, true, false, false,
            String.valueOf(ApexPages.severity.CONFIRM),
            UFHTConstants.WHITE_SPACE
            + System.label.Ultra_Track_Container_Save_Message1
            + ' Account '
            + System.label.Ultra_Track_Container_Save_Message2
        );

    }

    /**
      * @Author: Eternus Solutions
      * @Description: saveSetting test case to test method with following steps:
      *               No Ultra_Track_Container__c record for an object.
      *               Selected an object.
      *               Two fields Selected for field tracking.
      * @Expected Result: Method should insert Ultra_Track_Container__c record with Selected fields and Is_Tracking_Enabled__c as true.
      * @Date: 02/03/2016
      **/
    static testMethod void saveSettingTestCase2() {

        saveSettingTest(
            null, true, true, false,
            String.valueOf(ApexPages.severity.CONFIRM),
            UFHTConstants.WHITE_SPACE
            + System.label.Ultra_Track_Container_Save_Message1
            + ' Account '
            + System.label.Ultra_Track_Container_Save_Message2
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
      * @Date: 02/03/2016
      **/
    static testMethod void saveSettingTestCase3() {

        saveSettingTest(
            new set<String>(), false, false, true,
            String.valueOf(ApexPages.severity.WARNING),
            System.Label.Field_Not_Selected
        );

    }

    /**
      * @Author: Eternus Solutions
      * @Description: saveSetting test case to test method with following steps:
      *               No Ultra_Track_Container__c record for an object.
      *               Selected an object.
      *               Pass null value to method.
      * @Expected Result: Method should not insert Ultra_Track_Container__c record.
      * @Date: 02/03/2016
      **/
    static testMethod void saveSettingTestCase4() {

        saveSettingTest(
            null, false, false, true,
            null, null
        );
    }

    /**
      * @Author: Eternus Solutions
      * @Description: getCommaSeperatedFields test case to test method with valid set of String.
      * @Expected Result: Method should return comma separated fields.
      * @date: 02/03/2016
      **/
    static testMethod void getCommaSeparatedFieldsTestCase1() {
        getCommaSeparatedFieldsTest(new set<String> {'abc', 'cde', 'fg'}, 'abc,cde,fg');
    }

    /**
      * @Author: Eternus Solutions
      * @Description: getCommaSeperatedFields test case to test method with empty set of String.
      * @Expected Result: Method should return empty String.
      * @Date: 02/03/2016
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
      * @Date: 02/03/2016
      **/
    static testMethod void getCommaSeparatedFieldsTestCase3() {
        getCommaSeparatedFieldsTest(null, '');
    }

    /**
      * @Author: Eternus Solutions
      * @Description: initializeFieldList test case to test method with following steps:
      *               Selected an object.
      *               Called getFieldsList and set counter to 0.
      * @Expected Result: Method should check size of lstWrapperClassList is correct or not.
      * @Date: 02/03/2016
      **/
    static testMethod void initializeFieldListTestCase1() {

        list<Ultra_Track_Container__c> ultraTrackContainerList = new list<Ultra_Track_Container__c>();

        getConfigurationSettingDataTestData(false,
                                            null,
                                            null,
                                            null,
                                            null,
                                            null);

        UltraSetupController ultraSetupObj = new UltraSetupController();

        Test.startTest();
        ultraSetupObj.objects = 'Account (Account)';
        ultraSetupObj.getFieldsList();
        ultraSetupObj.counter = 0;
        ultraSetupObj.initializeFieldList();
        test.stopTest();

        System.assertEquals(ultraSetupObj.pageSize / Integer.valueOf(ultraSetupObj.numberOfColumns), ultraSetupObj.lstWrapperClassList.size());
        System.assertEquals(ultraSetupObj.totalSize, ultraSetupObj.allFieldswrapperClassList.size());

    }

    /**
      * @Author: Eternus Solutions
      * @Description: initializeFieldList test case to test method with following steps:
      *               Selected an object.
      *               Called getFieldsList and set counter greater than zero.
      * @Expected Result: Method should check size of lstWrapperClassList is correct or not.
      * @Date: 02/03/2016
      **/
    static testMethod void initializeFieldListTestCase2() {

        list<Ultra_Track_Container__c> ultraTrackContainerList = new list<Ultra_Track_Container__c>();

        getConfigurationSettingDataTestData(false,
                                            null,
                                            null,
                                            null,
                                            null,
                                            null);

        UltraSetupController ultraSetupObj = new UltraSetupController();

        Test.startTest();
        ultraSetupObj.objects = 'Account (Account)';
        ultraSetupObj.getFieldsList();
        ultraSetupObj.counter = 3;
        ultraSetupObj.initializeFieldList();
        test.stopTest();

        System.assertEquals(ultraSetupObj.pageSize / Integer.valueOf(ultraSetupObj.numberOfColumns), ultraSetupObj.lstWrapperClassList.size());
        System.assertEquals(ultraSetupObj.totalSize, ultraSetupObj.allFieldswrapperClassList.size());

    }

    /**
      * @Author: Eternus Solutions
      * @Description: initializeFieldList test case to test method with following steps:
      *               Selected an object.
      *               Called getFieldsList and set counter greater than zero.
      *               All Field list will be null.
      * @Expected Result: Method should check size of lstWrapperClassList is correct or not.
      * @Date: 02/03/2016
      **/
    static testMethod void initializeFieldListTestCase3() {

        list<Ultra_Track_Container__c> ultraTrackContainerList = new list<Ultra_Track_Container__c>();

        getConfigurationSettingDataTestData(false,
                                            null,
                                            null,
                                            null,
                                            null,
                                            null);

        UltraSetupController ultraSetupObj = new UltraSetupController();

        Test.startTest();
        ultraSetupObj.objects = 'Account (Account)';
        ultraSetupObj.getFieldsList();
        ultraSetupObj.counter = 3;
        ultraSetupObj.allFieldswrapperClassList = null;
        ultraSetupObj.initializeFieldList();
        test.stopTest();

        System.assertEquals(0, ultraSetupObj.lstWrapperClassList.size());
        System.assertEquals(ultraSetupObj.totalSize, 0);

    }

    /**
      * @Author: Eternus Solutions
      * @Description: first test case to test method with following steps:
      *               Inserted Ultra_Track_Container__c record for an object.
      *               Selected an object.
      *               Not All fields selected for field tracking.
      * @Expected Result: Method should assign value to false value to isAllSelected.
      * @Date: 02/03/2016
      **/
    static testMethod void firstTestCase1() {
        firstTest('Account (Account)');
    }

    /**
      * @Author: Eternus Solutions
      * @Description: first test case to test method with following steps:
      *               No object is selected.
      *               Not All fields selected for field tracking.
      * @Expected Result: Method should assign value to false value to isAllSelected.
      * @Date: 02/03/2016
      **/
    static testMethod void firstTestCase2() {
        firstTest('');
    }

    /**
      * @Author: Eternus Solutions
      * @Description: previous test case to test method with following steps:
      *               Inserted Ultra_Track_Container__c record for an object.
      *               Selected an object.
      *               Two All fields selected for field tracking.
      * @Expected Result: Method should assign value to false value to isAllSelected.
      * @Date : 02/03/2016
      **/
    static testMethod void previousTestCase() {

        list<Ultra_Track_Container__c> ultraTrackContainerList = new list<Ultra_Track_Container__c>();
        Integer counter;

        ultraTrackContainerList.addAll(TestDataFactory.getUltraTrackContainerList(new list<String> {'Account'},
                                                                                  new list<String> {'Account'},
                                                                                  new list<Boolean> {true},
                                                                                  new list<String> {'Email, Name, Phone'}
                                                                                  )
                                      );

        insert ultraTrackContainerList;

        Test.setMock(HttpCalloutMock.class, new MockHttpResponseForSetupController1());

        PageReference pageRef = Page.Ultra_Setup;
        Test.setCurrentPage(pageRef);

        UltraSetupController ultraSetupObj = new UltraSetupController();

        Test.startTest();
        ultraSetupObj.objects = 'Account(Account)';
        ultraSetupObj.refresh();
        counter = ultraSetupObj.counter;
        ultraSetupObj.previous();
        test.stopTest();

        System.assertEquals(false, ultraSetupObj.isAllSelected);
        System.assertEquals((counter - ultraSetupObj.pageSize), ultraSetupObj.counter);
        System.assertEquals(0, ultraSetupObj.pageNumber);

    }

    /**
      * @Author: Eternus Solutions
      * @Description: previous test case to test method with following steps:
      *               Inserted Ultra_Track_Container__c record for an object.
      *               Selected an object.
      *               All fields selected for field tracking.
      * @Expected Result: Method should assign value to true value to isAllSelected.
      * @Date: 02/03/2016
      **/
    static testMethod void nextTestCase() {

        Integer counter;

        Configuration__c configurationObj = TestDataFactory.getConfiguration(4,
                                                                             8,
                                                                             12,
                                                                             System.Label.DefaultFieldSortingOption,
                                                                             URL.getSalesforceBaseUrl().getHost());
        insert configurationObj;

        UltraSetupController ultraSetupObj = updateSettingTestData(new list<String> {'Account'},
                                                                    new list<String> {'Account'},
                                                                    new list<Boolean> {true},
                                                                    new list<String> {'Email, Name, Phone'}
                                                                   );
        ultraSetupObj.objects = 'Account(Account)';

        ultraSetupObj.refresh();

        for(integer index = 0; index < ultraSetupObj.allFieldswrapperClassList.size(); index++) {
            ultraSetupObj.allFieldswrapperClassList[index].isSelected = true;
        }

        Test.startTest();
        counter = ultraSetupObj.counter;
        ultraSetupObj.next();
        test.stopTest();

        System.assertEquals(true, ultraSetupObj.isAllSelected);
        System.assertEquals((counter + ultraSetupObj.pageSize), ultraSetupObj.counter);
        System.assertEquals(2, ultraSetupObj.pageNumber);
    }

    /**
      * @Author: Eternus Solutions
      * @Description: last test case to test method with following steps:
      *               Inserted Ultra_Track_Container__c record for an object.
      *               Selected an object.
      *               All fields selected for field tracking.
      * @Expected Result: Method should assign value to true value to isAllSelected.
      * @Date: 02/03/2016
      **/
    static testMethod void lastTestCase() {

        list<Ultra_Track_Container__c> ultraTrackContainerList = new list<Ultra_Track_Container__c>();
        Integer counter;
        Integer pageNumber;

        Configuration__c configurationObj = TestDataFactory.getConfiguration(4,
                                                                             8,
                                                                             12,
                                                                             System.Label.DefaultFieldSortingOption,
                                                                             URL.getSalesforceBaseUrl().getHost());
        insert configurationObj;

        UltraSetupController ultraSetupObj = updateSettingTestData(new list<String> {'Account'},
                                                                    new list<String> {'Account'},
                                                                    new list<Boolean> {true},
                                                                    new list<String> {'Email, Name, Phone'}
                                                                   );
        ultraSetupObj.objects = 'Account(Account)';

        ultraSetupObj.refresh();

        ultraSetupObj.totalSize = ultraSetupObj.allFieldswrapperClassList.size();
        for(integer index = 0; index < ultraSetupObj.allFieldswrapperClassList.size(); index++) {
            ultraSetupObj.allFieldswrapperClassList[index].isSelected = true;
        }

        Test.startTest();
        ultraSetupObj.last();
        test.stopTest();

        Integer reminder = Math.mod(ultraSetupObj.totalSize, ultraSetupObj.pageSize);
        if(reminder == 0) {
            pageNumber = ultraSetupObj.totalSize/ ultraSetupObj.pageSize;
            counter = ultraSetupObj.totalSize- (ultraSetupObj.totalSize/ ultraSetupObj.pageSize);
        }

        else {
            pageNumber = Math.round(ultraSetupObj.totalSize/ ultraSetupObj.pageSize) + 1;
            counter = ultraSetupObj.totalSize- reminder;
        }

        System.assertEquals(true, ultraSetupObj.isAllSelected);
        System.assertEquals(counter, ultraSetupObj.counter);
        System.assertEquals(pageNumber, ultraSetupObj.pageNumber);
    }

    /**
      * @Author: Eternus Solutions
      * @Description: getHasPrevious test case to test method with following steps:
      *               Inserted Ultra_Track_Container__c record for an object.
      *               Selected an object.
      *               Two fields selected for field tracking.
      *               User is on first page.
      * @Expected Result: Method should return true.
      * @Date: 02/03/2016
      **/
    static testMethod void getHasPreviousTestCase1() {
        getHasPreviousTest(true);
     }

    /**
      * @Author: Eternus Solutions
      * @Description: getHasPrevious test case to test method with following steps:
      *               Inserted Ultra_Track_Container__c record for an object.
      *               Selected an object.
      *               Two fields selected for field tracking.
      *               User is on page which has previous page.
      * @Expected Result: Method should return false.
      * @Date: 02/03/2016
      **/
    static testMethod void getHasPreviousTestCase2() {
        getHasPreviousTest(false);
    }

    /**
      * @Author: Eternus Solutions
      * @Description: getHasPrevious test case to test method with following steps:
      *               Inserted Ultra_Track_Container__c record for an object.
      *               Selected an object.
      *               Two fields selected for field tracking.
      *               User is on first page.
      * @Expected Result: Method should return false.
      * @Date: 02/03/2016
      **/
    static testMethod void getHasNextTestCase1() {
        getHasNextTest(false);
    }

    /**
      * @Author: Eternus Solutions
      * @Description: getHasPrevious test case to test method with following steps:
      *               Inserted Ultra_Track_Container__c record for an object.
      *               Selected an object.
      *               Two fields selected for field tracking.
      *               User is on last page.
      * @Expected Result: Method should return true.
      * @Date: 02/03/2016
      **/
    static testMethod void getHasNextTestCase2() {
        getHasNextTest(true);
    }

    /**
      * @Author: Eternus Solutions
      * @Description: saveAndUpdateConfigurationSetting test case to test update Configuration setting functionality when configuration record
      *               already inserted.
      * @Expected Result: Method to test the configuration setting is updated or not.
      * @Date: 02/03/2016
      **/
    static testMethod void saveAndUpdateConfigurationSettingTestCase1() {
        saveAndUpdateConfigurationSettingTest(false);
    }

    /**
      * @Author: Eternus Solutions
      * @Description: saveAndUpdateConfigurationSetting test case to test update Configuration setting functionality when configuration record
      *               already inserted.
      * @Expected Result: Method to test the configuration setting is updated or not.
      * @Date: 02/03/2016
      **/
    static testMethod void saveAndUpdateConfigurationSettingTestCase2() {
        saveAndUpdateConfigurationSettingTest(true);
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

        UltraSetupController ultraSetupObj = updateSettingTestData(new list<String> {'Account'},
                                                                   new list<String> {'Account'},
                                                                   new list<Boolean> {true},
                                                                   new list<String> {'Name, Phone'}
                                                                   );
        Test.startTest();
        ultraSetupObj.objects = 'Account (Account)';
        ultraSetupObj.getFieldsList();
        ultraSetupObj.allFieldswrapperClassList[0].isSelected = true;
        ultraSetupObj.allFieldswrapperClassList[1].isSelected = true;
        // Set mock to call the mehtod selectedFieldsName() because it calls mehtod updateSetting().
        // The saveSetting() method calls future method generateDynamicTrigger() which makes callout to create trigger.
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseDyanamicTriggerGenerator());
        ultraSetupObj.selectedFieldsName();
        test.stopTest();

        list<Ultra_Track_Container__c> updatedUltraultraTrackContainerList = [SELECT Id,
                                                                                     Is_Tracking_Enabled__c,
                                                                                     Tracked_Fields__c
                                                                             FROM Ultra_Track_Container__c
                                                                             ];

        System.assertEquals(3, ultraSetupObj.SELECTedFieldSet.size());
        list<String> trackedField = updatedUltraultraTrackContainerList[0].Tracked_Fields__c.split(',');
        System.assertEquals(3, trackedField.size());
        ApexPages.Message[] pageMessages = ApexPages.getMessages();
        System.assertEquals('CONFIRM', String.valueOf(pageMessages[0].getSeverity()));
        System.assertEquals(UFHTConstants.WHITE_SPACE + System.label.Ultra_Track_Container_Save_Message1 + ' Account ' + System.label.Ultra_Track_Container_Save_Message2, pageMessages[0].getSummary());
        System.assertEquals(false, ultraSetupObj.isObject);

    }

    /**
      * @Author: Eternus Solutions
      * @Description: UpdateSetting test case to test method with following steps:
      *               Inserted Ultra_Track_Container__c record for an object.
      *               Selected an object.
      *               No fields selected for field tracking.
      * @Expected Result: Method should update Ultra_Track_Container__c record with selected fields and Is_Tracking_Enabled__c as false.
      * @Date: 02/03/2016
      **/
    static testMethod void updateSettingTestCase2() {

         UltraSetupController ultraSetupObj = updateSettingTestData(new list<String> {'Account'},
                                                                    new list<String> {'Account'},
                                                                    new list<Boolean> {true},
                                                                    new list<String> ()
                                                                   );
        Test.startTest();
        ultraSetupObj.objects = 'Account (Account)';
        ultraSetupObj.getFieldsList();
        ultraSetupObj.selectedFieldsName();
        test.stopTest();

        list<Ultra_Track_Container__c> updatedUltraultraTrackContainerList = [SELECT Id,
                                                                                     Is_Tracking_Enabled__c,
                                                                                     Tracked_Fields__c
                                                                             FROM Ultra_Track_Container__c
                                                                             ];

        System.assertEquals(0, ultraSetupObj.SELECTedFieldSet.size());
        System.assertEquals(null, updatedUltraultraTrackContainerList[0].Tracked_Fields__c);
        System.assertEquals(true, updatedUltraultraTrackContainerList[0].Is_Tracking_Enabled__c);
        ApexPages.Message[] pageMessages = ApexPages.getMessages();

        System.assertEquals('WARNING', String.valueOf(pageMessages[0].getSeverity()));
        System.assertEquals(System.Label.Field_Not_Selected, pageMessages[0].getSummary());

        System.assertEquals(true, ultraSetupObj.isObject);
    }

    /**
      * @Author: Eternus Solutions
      * @Description: UpdateSetting test case to test method with following steps:
      *               Inserted Ultra_Track_Container__c record for an object.
      *               Selected an object.
      *               Two fields selected for field tracking.
      * @Expected Result: Method should update Ultra_Track_Container__c record with selected fields and Is_Tracking_Enabled__c as true.
      * @Date: 02/03/2016
      **/
    static testMethod void updateSettingTestCase3() {

        UltraSetupController ultraSetupObj = updateSettingTestData(new list<String> {'Account'},
                                                                   new list<String> {'Account'},
                                                                   new list<Boolean> {false},
                                                                   new list<String> ()
                                                                   );

        Test.startTest();
        ultraSetupObj.objects = 'Account (Account)';
        ultraSetupObj.getFieldsList();
        ultraSetupObj.allFieldswrapperClassList[0].isSelected = true;
        ultraSetupObj.allFieldswrapperClassList[1].isSelected = true;

        // Set mock to call the mehtod selectedFieldsName() because it calls mehtod updateSetting().
        // The saveSetting() method calls future method generateDynamicTrigger() which makes callout to create trigger.
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseDyanamicTriggerGenerator());
        ultraSetupObj.selectedFieldsName();
        test.stopTest();

        list<Ultra_Track_Container__c> updatedUltraultraTrackContainerList = [SELECT Id,
                                                                                     Is_Tracking_Enabled__c,
                                                                                     Tracked_Fields__c
                                                                             FROM Ultra_Track_Container__c
                                                                             ];

        System.assertEquals(2, ultraSetupObj.SELECTedFieldSet.size());
        list<String> trackedField = updatedUltraultraTrackContainerList[0].Tracked_Fields__c.split(',');
        System.assertEquals(2, trackedField.size());
        System.assertEquals(true, updatedUltraultraTrackContainerList[0].Is_Tracking_Enabled__c);
        ApexPages.Message[] pageMessages = ApexPages.getMessages();

        System.assertEquals('CONFIRM', String.valueOf(pageMessages[0].getSeverity()));
        System.assertEquals(UFHTConstants.WHITE_SPACE + System.label.Ultra_Track_Container_Save_Message1 + ' Account ' + System.label.Ultra_Track_Container_Save_Message2, pageMessages[0].getSummary());
        System.assertEquals(false, ultraSetupObj.isObject);

    }

    /**
      * @Author: Eternus Solutions
      * @Description: UpdateSetting test case to test method with following steps:
      *               Selected an object.
      *               Pass null set of value to method.
      * @Expected Result: Method should not update an Ultra track container record.
      * @Date: 02/03/2016
      **/
    static testMethod void updateSettingTestCase4() {

        UltraSetupController ultraSetupObj = updateSettingTestData(new list<String> {'Account'},
                                                                   new list<String> {'Account'},
                                                                   new list<Boolean> {false},
                                                                   new list<String> ()
                                                                   );

        Test.startTest();
        ultraSetupObj.objects = 'Account (Account)';
        // In this case scenario no need to set mock because updateSetting method will not call futrue method
        // if selectedFieldSet param is passed as null.
        ultraSetupObj.UpdateSetting(null);
        test.stopTest();

        list<Ultra_Track_Container__c> updatedUltraultraTrackContainerList = [SELECT Id,
                                                                                     Is_Tracking_Enabled__c,
                                                                                     Tracked_Fields__c
                                                                              FROM Ultra_Track_Container__c
                                                                              ];

        System.assertEquals(null, updatedUltraultraTrackContainerList[0].Tracked_Fields__c);
        System.assertEquals(false, updatedUltraultraTrackContainerList[0].Is_Tracking_Enabled__c);
    }
}