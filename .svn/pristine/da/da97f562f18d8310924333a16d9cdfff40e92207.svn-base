/* @Class Name: ConfigurationControllerTest
 * @Description: Test class for ConfigurationController class.
 * ========================================================================================================================
 *       Version   | Date        | Author             | Comments
 * -------------------------------------------------------------------------------------------------------------------------
 *       1.0       | 26-2-2016  | Eternus Solution   | 1.Created the class
 * ========================================================================================================================
 **/
@isTest
private class ConfigurationControllerTest {
    
    /** 
     * @Author: Eternus Solutions
     * @description: Get columns for Configuration Test
     * Expected Result: Method should return all picklist values and default value from Configuration
     *                  number of columns list
     * @date: 26-02-2016
     */   
    static testMethod void getColumnsTestCase() {

        list<Number_Of_Columns__c> numberOfColumnList = TestDataFactory.getNumberOfColumnList(new list<string> {'1','2','3','4'});
        insert numberOfColumnList;
        
        //PageReference pageRef = Page.Configuration;
        //Test.setCurrentPage(pageRef);
        
        
        ConfigurationController controllerObj;

        test.startTest();
        controllerObj = new ConfigurationController();
        test.stopTest();
        
        system.assertEquals(5,controllerObj.numberOfColValues.size());
        system.assertEquals(1,controllerObj.numberOfFieldsPerColValues.size());
        
        system.assertEquals(system.label.PicklistDefaultLabel,controllerObj.numberOfColValues[0].getLabel());
        system.assertEquals('',controllerObj.numberOfColValues[0].getValue());
        
        system.assertEquals(system.label.PicklistDefaultLabel,controllerObj.numberOfFieldsPerColValues[0].getLabel());
        system.assertEquals('',controllerObj.numberOfFieldsPerColValues[0].getValue());
        
        for(integer index = 1; index < controllerObj.numberOfColValues.size(); index++) {
            system.assertEquals(numberOfColumnList[index - 1].Name,controllerObj.numberOfColValues[index].getLabel());
            system.assertEquals(numberOfColumnList[index - 1].Name,controllerObj.numberOfColValues[index].getValue());
        }
    }
    
     /** 
     * @Author: Eternus Solutions
     * @description: get Fields Per Column for Configuration Test
     * Expected Result: Method should return all picklist values and default value from Configuration
     *                  number of fields per columns list
     * @Date: 26-02-2016
     */  
    static testMethod void getFieldsPerColumnTestCase() {

        list<Number_Of_Fields_Per_Column__c> numberOfFieldPerColumnList = TestDataFactory.getNumberOfFieldPerColumnList
                                                                          (new list<string> {'6','7','8','9'});
        insert numberOfFieldPerColumnList;
        
        ConfigurationController controllerObj;

        test.startTest();
        controllerObj = new ConfigurationController();
        test.stopTest();
        
        system.assertEquals(1,controllerObj.numberOfColValues.size());
        system.assertEquals(5,controllerObj.numberOfFieldsPerColValues.size());
        
        system.assertEquals(system.label.PicklistDefaultLabel,controllerObj.numberOfColValues[0].getLabel());
        system.assertEquals('',controllerObj.numberOfColValues[0].getValue());
        
        system.assertEquals(system.label.PicklistDefaultLabel,controllerObj.numberOfFieldsPerColValues[0].getLabel());
        system.assertEquals('',controllerObj.numberOfFieldsPerColValues[0].getValue());
        
        for(integer index = 1; index < controllerObj.numberOfFieldsPerColValues.size(); index++) {
            system.assertEquals(numberOfFieldPerColumnList[index - 1].Name,controllerObj.numberOfFieldsPerColValues[index].getLabel());
            system.assertEquals(numberOfFieldPerColumnList[index - 1].Name,controllerObj.numberOfFieldsPerColValues[index].getValue());
        }
    }
    
    /** 
     * @Author: Eternus Solutions
     * @description: Get Number of history records for Configuration Test
     * Expected Result: Method should return all picklist values and default value from Configuration
     *                  number of History records
     * @Date: 26-02-2016
     */   
    static testMethod void getHistoryRecordsTestCase() {

        list<Number_Of_Records_Per_Page__c> numberOfHistoryRecordsList = TestDataFactory.getNumberOfHistoryRecordsList(new list<string> {'6','7','8','9'});
        insert numberOfHistoryRecordsList;
             
        ConfigurationController controllerObj;

        test.startTest();
        controllerObj = new ConfigurationController();
        test.stopTest();
        
        system.assertEquals(5,controllerObj.numberOfHistoryRecordsToDisplay.size());
        system.assertEquals(1,controllerObj.numberOfFieldsPerColValues.size());
        system.assertEquals(1,controllerObj.numberOfColValues.size());
        
        system.assertEquals(system.label.PicklistDefaultLabel,controllerObj.numberOfHistoryRecordsToDisplay[0].getLabel());
        system.assertEquals('',controllerObj.numberOfHistoryRecordsToDisplay[0].getValue());
        
        system.assertEquals(system.label.PicklistDefaultLabel,controllerObj.numberOfFieldsPerColValues[0].getLabel());
        system.assertEquals('',controllerObj.numberOfFieldsPerColValues[0].getValue());
        
        system.assertEquals(system.label.PicklistDefaultLabel,controllerObj.numberOfColValues[0].getLabel());
        system.assertEquals('',controllerObj.numberOfColValues[0].getValue());
        
        for(integer index = 1; index < controllerObj.numberOfHistoryRecordsToDisplay.size(); index++) {
            system.assertEquals(numberOfHistoryRecordsList[index - 1].Name,controllerObj.numberOfHistoryRecordsToDisplay[index].getLabel());
            system.assertEquals(numberOfHistoryRecordsList[index - 1].Name,controllerObj.numberOfHistoryRecordsToDisplay[index].getValue());
        }
    }
     /** 
     * @Author: Eternus Solutions
     * @description: get Fields Per Column for Configuration Test
     * Expected Result: Method should return all picklist values and default value from Configuration
     *                  number of fields per columns list
     * @Date: 26-02-2016
     */  
    static testMethod void getBothNumberFieldsAndColumnTestCase() {

        list<Number_Of_Columns__c> numberOfColumnList = TestDataFactory.getNumberOfColumnList(new list<string> {'1','2','3','4'});
        insert numberOfColumnList;
        
        list<Number_Of_Fields_Per_Column__c> numberOfFieldPerColumnList = TestDataFactory.getNumberOfFieldPerColumnList
                                                                          (new list<string> {'6','7','8','9'});
        insert numberOfFieldPerColumnList;
        
        ConfigurationController controllerObj;

        test.startTest();
        controllerObj = new ConfigurationController();
        test.stopTest();
        
        system.assertEquals(5,controllerObj.numberOfColValues.size());
        system.assertEquals(5,controllerObj.numberOfFieldsPerColValues.size());
        
        system.assertEquals(system.label.PicklistDefaultLabel,controllerObj.numberOfColValues[0].getLabel());
        system.assertEquals('',controllerObj.numberOfColValues[0].getValue());
        
        system.assertEquals(system.label.PicklistDefaultLabel,controllerObj.numberOfFieldsPerColValues[0].getLabel());
        system.assertEquals('',controllerObj.numberOfFieldsPerColValues[0].getValue());
        
        for(integer index = 1; index < controllerObj.numberOfColValues.size(); index++) {
            system.assertEquals(numberOfColumnList[index - 1].Name,controllerObj.numberOfColValues[index].getLabel());
            system.assertEquals(numberOfColumnList[index - 1].Name,controllerObj.numberOfColValues[index].getValue());
        }
        for(integer index = 1; index < controllerObj.numberOfFieldsPerColValues.size(); index++) {
            system.assertEquals(numberOfFieldPerColumnList[index - 1].Name,controllerObj.numberOfFieldsPerColValues[index].getLabel());
            system.assertEquals(numberOfFieldPerColumnList[index - 1].Name,controllerObj.numberOfFieldsPerColValues[index].getValue());
        }
    }
    
     /** 
     * @Author: Eternus Solutions
     * @description: save configuration test
     *               number of configuration inserted is one.
     *               numberOfColumns, numberOfFieldsPerColumns, numberOfHistoryRecords , sortFieldsBy  with some values.
     * Expected Result: Method should update configuration record with new values.
     * @Date: 26-02-2016
     */
    static testMethod void saveConfigurationTestCase1() {
        
        Configuration__c configurationObj = TestDataFactory.getConfiguration(1, 5, 20,'Descending');
        insert configurationObj;
        
        ConfigurationController controllerObj = new ConfigurationController();
        controllerObj.numberOfColumns = 4;
        controllerObj.numberOfFieldsPerColumns = 15;
        controllerObj.numberOfHistoryRecords = 25;
        controllerObj.sortFieldsBy = 'Ascending';

        test.startTest();
        controllerObj.saveConfiguration();
        test.stopTest();
        
        Map<String,Configuration__c> mapConfig = Configuration__c.getAll();
        list<Configuration__c> configurationUpdatedList = new list<Configuration__c> 
                                                         {Configuration__c.getAll().get
                                                         (system.Label.ConfigureColsAndFieldsCustomSettingRecordName)
                                                         };
        
        system.assertNotEquals(1, configurationUpdatedList[0].Number_Of_Columns__c);
        system.assertNotEquals(5, configurationUpdatedList[0].Number_Of_Fields_Per_Column__c);
        system.assertNotEquals(20, configurationUpdatedList[0].Number_Of_Records_Per_Page__c);
        system.assertNotEquals('Descending', configurationUpdatedList[0].Sort_Fields_By__c);
        
        system.assertEquals(4, configurationUpdatedList[0].Number_Of_Columns__c);
        system.assertEquals(15, configurationUpdatedList[0].Number_Of_Fields_Per_Column__c);
        system.assertEquals(25, configurationUpdatedList[0].Number_Of_Records_Per_Page__c);
        system.assertEquals('Ascending', configurationUpdatedList[0].Sort_Fields_By__c);
        
    }
    /** 
     * @Author: Eternus Solutions
     * @description: save configuration test
     *               number of configuration inserted is one.
     *               numberOfColumns, numberOfFieldsPerColumns, numberOfHistoryRecords , sortFieldsBy  with null values.
     * Expected Result: Method should update configuration record with default values.
     * @Date: 25-04-2016
     */
    static testMethod void saveConfigurationTestCase2() {
        
        Configuration__c configurationObj = TestDataFactory.getConfiguration(1, 5, 20,'Descending');
        insert configurationObj;
        
        ConfigurationController controllerObj = new ConfigurationController();
        controllerObj.numberOfColumns = 0;
        controllerObj.numberOfFieldsPerColumns = 0;
        controllerObj.numberOfHistoryRecords = 0;
        controllerObj.sortFieldsBy = '';

        test.startTest();
        controllerObj.saveConfiguration();
        test.stopTest();
        
        Map<String,Configuration__c> mapConfig = Configuration__c.getAll();
        list<Configuration__c> configurationUpdatedList = new list<Configuration__c> 
                                                         {Configuration__c.getAll().get
                                                         (system.Label.ConfigureColsAndFieldsCustomSettingRecordName)
                                                         };
        
        system.assertNotEquals(1, configurationUpdatedList[0].Number_Of_Columns__c);
        system.assertNotEquals(5, configurationUpdatedList[0].Number_Of_Fields_Per_Column__c);
        system.assertNotEquals(20, configurationUpdatedList[0].Number_Of_Records_Per_Page__c);
        system.assertNotEquals('Descending', configurationUpdatedList[0].Sort_Fields_By__c);
        
        system.assertEquals(5, configurationUpdatedList[0].Number_Of_Columns__c);
        system.assertEquals(10, configurationUpdatedList[0].Number_Of_Fields_Per_Column__c);
        system.assertEquals(25, configurationUpdatedList[0].Number_Of_Records_Per_Page__c);
        system.assertEquals(system.label.DefaultFieldSortingOption, configurationUpdatedList[0].Sort_Fields_By__c);
        
    }
}