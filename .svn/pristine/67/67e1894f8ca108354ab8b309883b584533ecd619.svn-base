/**
 * @Class Name: ConfigurationControllerTest
 * @Description: This class contains unit tests for ConfigurationController.cls
 * =====================================================================================================
 *     Version   | Date        | Author              | Comments
 * -----------------------------------------------------------------------------------------------------
 *     1.0       | 26/02/2016  | Eternus Solutions   | 1. Created test class for ConfigurationController
 * ======================================================================================================
 **/
@isTest
private class ConfigurationControllerTest {

    /**
     * @Author: Eternus Solutions
     * @Description: Test method to verify "saveConfiguration()" by passing all valid parameters.
     * @Param: 1. Configuration__c object to insert custom setting data.
     *         2. columns: To display fields in number of columns.
     *         3. fieldsPerColumns: To display number of fields in columns.
     *         4. historyRecords: To display number of history records per page.
     *         5. sortFieldsBy: To store the fields sorting order.
     *         6. baseURL: To store salesforce base url to making callouts.
     *         7. assertColumns: To test the assert value against variable columns.
     *         8. assertFieldsPerColumns: To test the assert value against variable fieldsPerColumns.
     *         9. assertHistoryRecords: To test the assert value against variable historyRecords.
     *        10. assertSortFieldsBy: To test the assert value against variable sortFieldsBy.
     *        11. assertBaseURL: To test the assert value against variable baseURL.
     *
     * @Return: NA.
     * @Date: 01/08/2016
     **/
    static void saveConfigurationTest(Configuration__c configurationObj, 
                                      Integer columns,
                                      Integer fieldsPerColumns, 
                                      Integer historyRecords,
                                      String sortFieldsBy,
                                      String baseURL,
                                      Integer assertColumns,
                                      Integer assertFieldsPerColumns,
                                      Integer assertHistoryRecords,
                                      String assertSortFieldsBy,
                                      String assertBaseURL
                                      ) {
        if(configurationObj != null) {
            insert configurationObj;
        }   
        Test.startTest();
        ConfigurationController controllerObj = new ConfigurationController();
        
        controllerObj.numberOfColumns = columns;
        controllerObj.numberOfFieldsPerColumns = fieldsPerColumns;
        controllerObj.numberOfHistoryRecords = historyRecords;
        controllerObj.sortFieldsBy = sortFieldsBy;
        controllerObj.baseURL = baseURL;
            
        controllerObj.saveConfiguration();
        Test.stopTest();
    
        Configuration__c configurationUpdatedObj = Configuration__c.getAll().get(System.Label.ConfigureColsAndFieldsCustomSettingRecordName);

        System.assertEquals(assertColumns, configurationUpdatedObj.Number_Of_Columns__c);
        System.assertEquals(assertFieldsPerColumns, configurationUpdatedObj.Number_Of_Fields_Per_Column__c);
        System.assertEquals(assertHistoryRecords, configurationUpdatedObj.Number_Of_Records_Per_Page__c);
        System.assertEquals(assertSortFieldsBy, configurationUpdatedObj.Sort_Fields_By__c);
        System.assertEquals(assertBaseURL, configurationUpdatedObj.SalesforceBaseURL__c );
    }
    
    /** 
     * @Author: Eternus Solutions
     * @Description: This template method created to varify "createOrUpdateConfiguration()".
     * @Param: 1. configurationObj: Configuration__c object to create/update custom setting record.
     *         2. sortOrder: To hold field sorting order.
     *         3. assertSortOrder: To store expected assert value of variable sortOrder.
     *         4. assertBaseURL: To store the expected assert value of baseUrl.
     * @Return: NA.
     * @Date: 01/08/2016
     **/
    static void createOrUpdateConfigurationTest(Configuration__c configurationObj, 
                                                String sortOrder,
                                                String assertSortOrder,
                                                String assertBaseURL) {
        
        Test.startTest();
        ConfigurationController controllerObj = new ConfigurationController();
        if((assertSortOrder == null || String.isBlank(assertSortOrder)) && 
        (assertBaseURL == null || String.isBlank(assertBaseURL))) {
            Test.setCurrentPage(Page.Ultra_Setup);
        }
        controllerObj.createOrUpdateConfiguration(configurationObj, sortOrder); 
        Test.stopTest();
        
        Configuration__c configurationUpdatedObj = Configuration__c.getAll().get(system.Label.ConfigureColsAndFieldsCustomSettingRecordName);
        
        if((assertSortOrder == null || String.isBlank(assertSortOrder )) && 
        (assertBaseURL == null || String.isBlank(assertBaseURL))) {
            System.assertEquals('Required fields are missing: [Name]', ApexPages.getMessages()[0].getSummary());
            System.assertEquals(ApexPages.Severity.ERROR, ApexPages.getMessages()[0].getSeverity());
        }
        else {
            System.assertEquals(assertSortOrder, configurationUpdatedObj.Sort_Fields_By__c);
            System.assertEquals(assertBaseURL, configurationUpdatedObj.SalesforceBaseURL__c);
        }
    }
    
    /** 
     * @Author: Eternus Solutions
     * @Description: This template method to varify "parseStringToInteger()".
     * @Pram: 1. pIntegerToStoreList: It holds all possiable values for parameter pStringToParse.
     *        2. pStringToParseList: It hold all the possiable values of parameter StringToParse.
     *        3. assertResultList: It hold all expected return value of method parseStringToInteger().
     * @Return: NA.
     * @Date: 02/08/2016
     **/
     static void parseStringToIntegerTest(list<Integer> pIntegerToStoreList,
                                          list<String> pStringToParseList,
                                          list<list<Integer>> assertResultList) {
        Integer parsedValue;
        Test.startTest();
        
        ConfigurationController controllerObj = new ConfigurationController();
        for(Integer index1 = 0; index1 < pIntegerToStoreList.size(); index1++) {
            for(Integer index2 = 0; index2 < pStringToParseList.size(); index2++) {
                if((index1 == 1 || index1 == 2) && index2 == 3){
                    Test.setCurrentPage(Page.Ultra_Setup);
                    parsedValue = controllerObj.parseStringToInteger(pIntegerToStoreList[index1], pStringToParseList[index2]);
                    System.assertEquals('There was an error while fetching the configuration data. Please contact the System Administrator.',
                                        ApexPages.getMessages()[0].getSummary());
                    System.assertEquals(ApexPages.Severity.ERROR, ApexPages.getMessages()[0].getSeverity());
                }
                else{
                    parsedValue = controllerObj.parseStringToInteger(pIntegerToStoreList[index1], pStringToParseList[index2]);
                    System.assertEquals(parsedValue, assertResultList[index1][index2]);
                }
            }
        }
        Test.stopTest();
    }
    
    /** 
     * @Author: Eternus Solutions
     * @Description: Test template method to verify "createOptionsFromCustomSetting()".         
     * @Param: 1. sObjectList: sObject list to hold the custom setting records.
     *         2. pIsIntegerData: Boolean parameter to indicate picklist values are integer or not.
     *         3. isException: Boolean to indicate method handles exception or not.
     * @Return: NA.
     * @Date: 02/08/2016
     **/
     static void createOptionsFromCustomSettingTest(list<sObject> sObjectList,
                                                    boolean pIsIntegerData,
                                                    Boolean isException) {
        list<SelectOption> selectOptionList;
         
        if(sObjectList != null) {
            insert sObjectList;
        }
        Test.startTest();
        if(isException) {
            Test.setCurrentPage(Page.Ultra_Setup);
        }
        ConfigurationController controllerObj = new ConfigurationController();
        selectOptionList = controllerObj.createOptionsFromCustomSetting(sObjectList, pIsIntegerData); 
        Test.stopTest();
        
        if(sObjectList == null) {
            System.assertEquals(1, selectOptionList.size());
            System.assertEquals(System.Label.PicklistDefaultLabel, selectOptionList[0].getLabel());
        }
        else if(isException) {
            System.assertEquals('There was an error while fetching the configuration data. Please contact the System Administrator.', 
                                ApexPages.getMessages()[0].getSummary());
            System.assertEquals(ApexPages.Severity.ERROR, ApexPages.getMessages()[0].getSeverity());
        }
        else {
            System.assertEquals(sObjectList.size()+1, selectOptionList.size());
            for(Integer index = 1; index < sObjectList.size(); index++) {
                System.assertEquals(String.ValueOf(sObjectList[index - 1].get(UFHTConstants.SOBJECT_NAME)),
                                    selectOptionList[index].getLabel());
                System.assertEquals(String.ValueOf(sObjectList[index - 1].get(UFHTConstants.SOBJECT_NAME)),
                                    selectOptionList[index].getValue());
            }
        }
    }
    
    /** 
     * @Author: Eternus Solutions
     * @Description: Test method to verify "saveConfiguration()" with the following scenario:
     *               Considered Configuration__c custom setting record is present.
     * @Expected Result: Method should update configuration record with new values.
     * @Date: 26/02/2016
     **/
    static testMethod void saveConfigurationTestCase1() {
        Configuration__c configurationObj = TestDataFactory.getConfiguration(1, 5, 20, 'Descending',
                                                                            Url.getSalesforceBaseUrl().getHost()
                                                                            );
        
        saveConfigurationTest(configurationObj, 4, 15, 25, 'Ascending', 
                              Url.getSalesforceBaseUrl().getHost(), 4,
                              15, 25, 'Ascending', 
                              Url.getSalesforceBaseUrl().getHost()
                             );
    }
    
    /** 
     * @Author: Eternus Solutions
     * @Description: Test method to verify "saveConfiguration()" with the following scenario:
     *               Configuration__c custom setting record is not present.
     * @Expected Result: Method should create new configuration record.
     * @Date: 14/07/2016
     **/
    static testMethod void saveConfigurationTestCase2() {
        Configuration__c configurationObj;
        
        saveConfigurationTest(configurationObj, 2, 10, 20, 'Descending',
                              Url.getSalesforceBaseUrl().getHost(), 2, 10,
                              20, 'Descending', Url.getSalesforceBaseUrl().getHost()   
                             );
    }
    
    /** 
     * @Author: Eternus Solutions
     * @Description: Test method to verify "saveConfiguration()" with the following scenario:
     *               Default custom setting Configuration__c's record is not present and other
     *               Configuration__c records are present.          
     * @Expected Result: Method should create new configuration record and delete other then 
     *                   default custom setting record.
     * @Date: 14/07/2016
     **/
    static testMethod void saveConfigurationTestCase3() {
        // Map to hold the records of custom setting "Configuration__c"
        map<String, Configuration__c> configMap = new map<String, Configuration__c>();
        Configuration__c configObj = TestDataFactory.getConfiguration(1, 5, 20, 'Descending',
                                                                      Url.getSalesforceBaseUrl().getHost()
                                                                     );
        // Change custom setting name other then default name 
        configObj.name = System.Label.ConfigureColsAndFieldsCustomSettingRecordName + 'Test';
        
        saveConfigurationTest(configObj, 2, 10, 20, 'Descending',
                              Url.getSalesforceBaseUrl().getHost(),
                              2, 10, 20, 'Descending',
                              Url.getSalesforceBaseUrl().getHost()
                             );
        configMap = Configuration__c.getAll();
        System.assertEquals(1, configMap.values().size());
        System.assertEquals(System.Label.ConfigureColsAndFieldsCustomSettingRecordName, configMap.values()[0].Name);
        System.assertEquals(false, configMap.containsKey(System.Label.ConfigureColsAndFieldsCustomSettingRecordName + 'Test'));
    }
    
    /** 
     * @Author: Eternus Solutions
     * @Description: Test method to verify "saveConfiguration()" with the following scenario:
     *               values are not provided for fields Number_Of_Columns__c,
     *               Number_Of_Fields_Per_Column__c, Number_Of_Records_Per_Page__c, Sort_Fields_By__c.
     * @Expected Result: Method should update configuration record with default values.
     * @Date: 25/04/2016
     **/
    static testMethod void saveConfigurationTestCase4() {
        Configuration__c configurationObj = TestDataFactory.getConfiguration(1, 5, 20, 'Descending', 
                                                                            Url.getSalesforceBaseUrl().getHost())
                                                                            ;
        
        saveConfigurationTest(configurationObj, 0, 0, 0, '',
                              Url.getSalesforceBaseUrl().getHost(),
                              Integer.valueOf(System.Label.DefaultNumberOfColumnValue),
                              Integer.valueOf(System.Label.DefaultNumberOfFieldsPerColumnValue),
                              Integer.valueOf(System.Label.DefaultNumberOfHistoryRecordsToDisplay),
                              System.Label.DefaultFieldSortingOption,
                              Url.getSalesforceBaseUrl().getHost()
                             );
    }
    
    /** 
     * @Author: Eternus Solutions
     * @Description: Test method to verify "saveConfiguration()" with the following scenario: 
     *               Values are not provided for fields Number_Of_Columns__c,
     *               Number_Of_Fields_Per_Column__c, Number_Of_Records_Per_Page__c,
     *               Sort_Fields_By__c,SalesforceBaseURL__c.
     * @Expected Result: Method should update configuration record with default values.
     * @Date: 22/07/2016
     **/
    static testMethod void saveConfigurationTestCase5() {
        Configuration__c configurationObj = TestDataFactory.getConfiguration(1, 5, 20, 'Descending', '');
        
        saveConfigurationTest(configurationObj, 0, 0, 0, '', null,
                              Integer.valueOf(System.Label.DefaultNumberOfColumnValue),
                              Integer.valueOf(System.Label.DefaultNumberOfFieldsPerColumnValue),
                              Integer.valueOf(System.Label.DefaultNumberOfHistoryRecordsToDisplay),
                              System.Label.DefaultFieldSortingOption,
                              Url.getSalesforceBaseUrl().getHost()
                             );
    }
    
    /** 
     * @Author: Eternus Solutions
     * @Description: Test method to verify "createOrUpdateConfiguration()" with the following scenario:
     *               Passed first parameter pConfigurationInstance as new Configuration__c object and 
     *               second parameter pSortOrder as blank.
     * @Expected Result: Method should create Configuration__c record and populate field Sort_Fields_By__c default
     *                   value as "Ascending".
     * @Date: 22/07/2016
     **/
    static testMethod void createOrUpdateConfigurationTestCase1() {
        Configuration__c configurationObj = TestDataFactory.getConfiguration(1, 5, 20, '', '');
        
        createOrUpdateConfigurationTest(configurationObj, '',
                                        System.Label.DefaultFieldSortingOption, 
                                        Url.getSalesforceBaseUrl().getHost()
                                       );
    }
    
    /** 
     * @Author: Eternus Solutions
     * @Description: Test method to verify "createOrUpdateConfiguration()" with the following scenario:
     *               Passed first parameter pConfigurationInstance as new Configuration__c 
     *               object and second parameter pSortOrder with some valid value.
     * @Expected Result: Method should create Configuration__c record and populate field Sort_Fields_By__c.
     * @Date: 22/07/2016
     **/
    static testMethod void createOrUpdateConfigurationTestCase2() {
        Configuration__c configurationObj = TestDataFactory.getConfiguration(1, 5, 20, '', Url.getSalesforceBaseUrl().getHost());
        
        createOrUpdateConfigurationTest(configurationObj, 'Descending',
                                        'Descending', 
                                        Url.getSalesforceBaseUrl().getHost()
                                       );
    }
    
    /** 
     * @Author: Eternus Solutions
     * @Description: Test method to verify "createOrUpdateConfiguration()" with the following scenario:
     *               Passed first parameter pConfigurationInstance as Configuration__c object (with id) and 
     *               second parameter pSortOrder as null.
     * @Expected Result: Method should update Configuration__c record and populate field Sort_Fields_By__c as default value.
     * @Date: 22/07/2016
     **/
    static testMethod void createOrUpdateConfigurationTestCase3() {
        Configuration__c configurationObj = TestDataFactory.getConfiguration(1, 5, 20, 'Descending', Url.getSalesforceBaseUrl().getHost());
        
        insert configurationObj;
        createOrUpdateConfigurationTest(configurationObj, null,
                                        'Ascending', 
                                        Url.getSalesforceBaseUrl().getHost()
                                       );
    }
    
    /** 
     * @Author: Eternus Solutions
     * @Description: Test method to verify "createOrUpdateConfiguration()" with the following scenario:
     *               Passed first parameter pConfigurationInstance as Configuration__c object (with id) and 
     *               second parameter pSortOrder as string with some valid value.
     * @Expected Result: Method should update Configuration__c record and populate field Sort_Fields_By__c.
     * @Date: 22/07/2016
     **/
    static testMethod void createOrUpdateConfigurationTestCase4() {
        Configuration__c configurationObj = TestDataFactory.getConfiguration(1, 5, 20, 'Descending', '');
        
        insert configurationObj;
        createOrUpdateConfigurationTest(configurationObj, 'Ascending',
                                        'Ascending', 
                                        Url.getSalesforceBaseUrl().getHost()
                                       );
    }
    
    /** 
     * @Author: Eternus Solutions
     * @Description: Test method to verify "createOrUpdateConfiguration()" with the following scenario:
     *               Handle exception.
     * @Expected Result: Method should handle the exception.
     * @Date: 22/07/2016
     **/
    static testMethod void createOrUpdateConfigurationTestCase5() {
        Configuration__c configurationObj = TestDataFactory.getConfiguration(1, 5, 20, 'Descending', '');
        configurationObj.Name = '';
        
        createOrUpdateConfigurationTest(configurationObj, 'Ascending', null, null);
   
    }
    
    /** 
     * @Author: Eternus Solutions
     * @Description: Test method to verify "parseStringToInteger()" with the following scenarios:
     *                passed first param pIntegerToStore as 0, null and valid value and second 
     *                param pStringToParse as valid value, null, balnk and invalid value.
     * @Expected Result: Method should return 0.
     * @Date: 22/07/2016 
     **/
    static testMethod void parseStringToIntegerTestCase(){
    parseStringToIntegerTest(new list<Integer>{4, 0, null},
                        new list<String>{'2', null, '', ' abc'},
                        new list<list<Integer>> {new list<Integer>{4,4,4,4},
                                                 new list<Integer>{2,0,0,5},
                                                 new list<Integer>{2,null,null,5}
                                                });
    }
   
    static testMethod void createOptionsFromCustomSettingTestCase1() {
     list<Number_Of_Columns__c> numberOfColumnsList = TestDataFactory.getNumberOfColumnList(
                                                            new list<String>{'2', '3', '4', '5'}
                                                            );
     createOptionsFromCustomSettingTest(numberOfColumnsList, true, false);
    }
    
    /** 
    * @Author: Eternus Solutions
    * @Description: Test method to verify "createOptionsFromCustomSetting()" with the following scenario:
    *               First param sObjectList with valid values and second param isIntegerData as false.
    * @Expected Result: Test method should returns list of selectOptions
    * @Date: 22/07/2016
    **/
    static testMethod void createOptionsFromCustomSettingTestCase2() {
     list<Number_Of_Columns__c> numberOfColumnsList = TestDataFactory.getNumberOfColumnList(
                                                        new list<String>{'2', '3', '4', '5'}
                                                        );
     createOptionsFromCustomSettingTest(numberOfColumnsList, false, false);
    }
     
    /** 
    * @Author: Eternus Solutions
    * @Description: Test method to verify "createOptionsFromCustomSetting()" with the following scenario:
    *               First param sObjectList with valid values and second param isIntegerData as true to
    *               handle the exception.
    * @Expected Result: Test method should handle the exception.
    * @Date: 22/07/2016
    **/
    static testMethod void createOptionsFromCustomSettingTestCase3() { 
     list<Number_Of_Columns__c> numberOfColumnsList = TestDataFactory.getNumberOfColumnList(
                                                    new list<String>{' abc', '3', '4', '5'}
                                                    );
     createOptionsFromCustomSettingTest(numberOfColumnsList, true, true);
    }
    
    /** 
    * @Author: Eternus Solutions
    * @Description: Test method to verify "createOptionsFromCustomSetting()" with the following scenario:
    *               First param sObjectList as null and second param isIntegerDAta with valid value.
    * @Expected Result: Test method should return list of SelectOption which have default 1 element.
    * @Date: 22/07/2016
    **/
    static testMethod void createOptionsFromCustomSettingTestCase4() {
    list<Number_Of_Columns__c> numberOfColumnsList;
    createOptionsFromCustomSettingTest(numberOfColumnsList, true, false);
    }
    
    /** 
    * @Author: Eternus Solutions
    * @Description: Test method to verify "createOptionsFromCustomSetting()" with the following scenario:
    *               First param sObjectList as valid value and second param isIntegerData as null.
    * @Expected Result: Test method should return list of SelectOption.
    * @Date: 22/07/2016
    **/
    static testMethod void createOptionsFromCustomSettingTestCase5() {
    list<Number_Of_Fields_Per_Column__c> numberOfFieldsList = TestDataFactory.getNumberOfFieldPerColumnList(
                                                                new list<String>{'2', '3',  '4', '5'}
                                                                );
    createOptionsFromCustomSettingTest(numberOfFieldsList, null, false);
    }
    
    /** 
    * @Author: Eternus Solutions
    * @Description: Test method to verify "verifyUserHasPermissionToCreateRemoteSiteSetting()" with the following scenario:
    *               By using Standard User profile checking that user has a permission to create custom setting or not
    * @Expected Result: Test method should return user does not have premission for creating custom setting record
    * @Date: 23/11/2016
    **/
    static testMethod void verifyUserHasPermissionToCreateRemoteSiteSettingTestCase() {

        Profile profileObj = [SELECT Id,
                                     Name,
                                     PermissionsViewSetup,
                                     PermissionsModifyAllData
                              FROM Profile
                              WHERE Name = 'Standard User'];
        
        User userObj = TestDataFactory.getUser('User3', 'user3', 'test@user3.come', profileObj.Id);
        
        System.runAs(userObj) {
        
            Test.startTest();
            ConfigurationController configurationControllerObj = new ConfigurationController();
            configurationControllerObj.verifyUserHasPermissionToCreateRemoteSiteSetting();
            Test.stopTest();
            
            System.assertEquals(false, configurationControllerObj.isUserHasPermissionToCreateRemoteSiteSetting);
        }
    }
    
    /** 
    * @Author: Eternus Solutions
    * @Description: Test method to verify "verifyUserHasPermissionToCreateRemoteSiteSetting()" with the following scenario:
    *               By using System Admin profile checking that user has a permission to create custom setting or not
    * @Expected Result: Test method should return user have premission for creating custom setting record
    * @Date: 23/11/2016
    **/
    static testMethod void verifyUserHasPermissionToCreateRemoteSiteSettingTestCase2() {
        
        Profile profileObj = [SELECT Id,
                                     Name,
                                     PermissionsViewSetup,
                                     PermissionsModifyAllData
                              FROM Profile
                              WHERE Name = 'System Administrator'];
        
        User userObj = TestDataFactory.getUser('User4', 'user4', 'test@user4.come', profileObj.Id);
        
        System.runAs(userObj) {
            
            Test.startTest();
            ConfigurationController configurationControllerObj = new ConfigurationController();
            configurationControllerObj.verifyUserHasPermissionToCreateRemoteSiteSetting();
            Test.stopTest();
            
            System.assertEquals(true, configurationControllerObj.isUserHasPermissionToCreateRemoteSiteSetting);
        }
    }
}