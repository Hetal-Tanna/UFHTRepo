/**
  * @Class Name: UltraTrackWrapperTest
  * @Description: This class contains unit tests for UltraTrackWrapper.cls
  * =====================================================================================================
  *       Version   | Date        | Author              | Comments
  * -----------------------------------------------------------------------------------------------------
  *       1.0       | 16/11/2015  | Eternus Solutions   | 1.Created the Test Class for UltraTrackWrapper
  * =====================================================================================================
  **/
@isTest
private class UltraTrackWrapperTest {
  
    /** 
      * @Author Eternus Solutions
      * @Description: This template method to test functionality of following 3 constructors:
      *               1. UltraTrackWrapper(String fieldApiName, String fieldLabel)
      *               2. UltraTrackWrapper(String fieldApiName, String fieldLabel, List<HistoryWrapper> pHistoryList)
      *               3. UltraTrackWrapper(String fieldName, String fieldLabel, Boolean isSelected)
      * @Param: Method has following parameters:
      *         1. pFieldApiNameList: List of string to hold the fields name
      *         2. pFieldLabelList: List of string to hold the fields label
      *         3. pHistoryWrapperListOfList: List to hold the list of HistoryWrapper records
      *         4. pIsSelectedList: List of boolean values to check asserts
      * @Return: NA
      * @Date: 09/08/2016
      **/ 
    static void ultraTrackWrapperTest(list<String> pFieldApiNameList,
                                      list<String> pFieldLabelList,
                                      list<String> pFieldDataType,
                                      list<list<HistoryWrapper>> pHistoryWrapperListOfList, 
                                      list<Boolean> pIsSelectedList,
                                      list<Boolean> pIsToggleList) {
    
        Test.startTest();
        if(pFieldApiNameList != null && pFieldLabelList != null && pFieldDataType !=null) {
            if(pHistoryWrapperListOfList == null && pIsSelectedList == null) {
                for(String fieldName : pFieldApiNameList) {
                    for(String fieldLabel : pFieldLabelList) {
                        for(String fieldDataType : pFieldDataType) {
                            UltraTrackWrapper wrapperObj = new UltraTrackWrapper(fieldName, fieldLabel,fieldDataType);
                            checkAssertForUltraTrackWrapper(wrapperObj.fieldApiName, fieldName);
                            checkAssertForUltraTrackWrapper(wrapperObj.fieldLabel, fieldLabel);
                            checkAssertForUltraTrackWrapper(wrapperObj.fieldDataType, fieldDataType);
                        }
                    }
                }
            }
            else if(pHistoryWrapperListOfList != null) {
                for(String fieldName : pFieldApiNameList) {
                    for(String fieldLabel : pFieldLabelList) {
                        for(String fieldDataType : pFieldDataType) {
                            for(list<HistoryWrapper> historyWrapperList : pHistoryWrapperListOfList) {
                                UltraTrackWrapper wrapperObj = new UltraTrackWrapper(fieldName, fieldLabel,fieldDataType,historyWrapperList);
                                checkAssertForUltraTrackWrapper(wrapperObj.fieldApiName, fieldName);
                                checkAssertForUltraTrackWrapper(wrapperObj.fieldLabel, fieldLabel);
                                checkAssertForUltraTrackWrapper(wrapperObj.fieldDataType, fieldDataType);
                                checkAssertForHistoryWrapperList(wrapperObj.historyList, historyWrapperList);
                            }
                        }
                    }
                }
            }
            else if(pIsSelectedList != null) {
                for(String fieldName : pFieldApiNameList) {
                    for(String fieldLabel : pFieldLabelList) {
                        for(Boolean isSelected : pIsSelectedList) {
                            for(Boolean fieldToggle : pIsToggleList) {
                                for(String fieldDataType : pFieldDataType) {
                                    UltraTrackWrapper wrapperObj = new UltraTrackWrapper(fieldName, fieldLabel, isSelected,fieldToggle,fieldDataType);
                                    checkAssertForUltraTrackWrapper(wrapperObj.fieldApiName, fieldName);
                                    checkAssertForUltraTrackWrapper(wrapperObj.fieldLabel, fieldLabel);
                                    checkAssertForBooleanValue(wrapperObj.isSelected, isSelected );
                                    checkAssertForBooleanValue(wrapperObj.fieldToggle, fieldToggle );
                                    checkAssertForUltraTrackWrapper(wrapperObj.fieldDataType, fieldDataType );
                                }
                            }
                        }
                    }
                }
            }
        }
        Test.stopTest();    
    }
    
    /** 
      * @Author Eternus Solutions
      * @Description: Method to check equality UltraTrackWrapper records.
      * @Param: Method has following parameters:
      *         1. expectedResult: String to hold the expected result value
      *         2. actualResult: String to hold the actual value
      * @Return: NA.
      * @Date: 09/08/2016
      **/
    static void checkAssertForUltraTrackWrapper(String expectedResult, String actualResult) {
        actualResult = String.isNotBlank(actualResult) 
                       ? actualResult
                       : UFHTConstants.WHITE_SPACE;
        System.assertEquals(expectedResult, actualResult);
    }
    
    /** 
      * @Author Eternus Solutions
      * @Description: Method to check the equality of HistoryWrapper records
      * @Param: Method has following parameters:
      *         1. expectedResultList: List to hold the records of HistoryWrapper class.
      *         2. expectedResultList: List to hold the records of HistoryWrapper class.
      * @Return: NA.
      * @Date: 09/08/2016
      **/
    static void checkAssertForHistoryWrapperList(list<HistoryWrapper> expectedResultList, list<HistoryWrapper> actualResultList) {
        if(actualResultList != null && !actualResultList.isEmpty()) {
            for(Integer index = 0; index < actualResultList.size(); index++) {
                System.assertEquals(expectedResultList[index], actualResultList[index]);
            }
        }
        else {
            actualResultList = new list<HistoryWrapper>();
            System.assertEquals(expectedResultList.isEmpty(), actualResultList.isEmpty());
        }
    }
    
    /** 
      * @Author Eternus Solutions
      * @Description: Method to check the equality of boolean values
      * @Param: Method has following parameters:
      *         1. expectedResult: It holds the expected boolean value
      *         2. actualResult: It holds the actualResult boolean value
      * @Return: NA.
      * @Date: 09/08/2016
      **/
    static void checkAssertForBooleanValue(Boolean expectedResult, Boolean actualResult) {
        actualResult = actualResult != null ? actualResult : false;
        System.assertEquals(expectedResult, actualResult);
    }
    
    /** 
      * @Author Eternus Solutions
      * @Description: This is template method to test functionality of method "compareTo()"
      * @Param: Method has following parameters:
      *         1. pConfigObj: It holds the configuration__c custom setting data
      *         2. pFieldApiName: List of string to hold the field api names
      *         3. pFieldLabel: List of string to hold the fields labels
      *         4. pAssertApiName: List of string to hold asssert values of field name
      *         5. pAssertLabel: list of string to hold assert values of field label
      * @Return: NA.
      * @Date: 09/08/2016
      **/
    static void compareToTest(Configuration__c pConfigObj ,
                              list<String> pFieldApiName,
                              list<String> pFieldLabel,
                              list<String> pDataType,
                              list<String> pAssertApiName,
                              list<String> pAssertLabel) {
        list<UltraTrackWrapper> ultraTrackWrapperList = new list<UltraTrackWrapper>();
        if(pConfigObj != null) {
            insert pConfigObj;
        }
        Test.startTest();
        ultraTrackWrapperList.addAll(TestDataFactory.getUltraTrackList(pFieldApiName, pFieldLabel,pDataType));
        ultraTrackWrapperList.sort();
        Test.stopTest();
        
        System.assertEquals(1, ultraTrackWrapperList.size());
        
        for(Integer index = 0; index < ultraTrackWrapperList.size(); index++) {
            checkAssertForUltraTrackWrapper(ultraTrackWrapperList[index].fieldApiName, pAssertApiName[index]);
            checkAssertForUltraTrackWrapper(ultraTrackWrapperList[index].fieldLabel, pAssertLabel[index]);
            checkAssertForUltraTrackWrapper(ultraTrackWrapperList[index].fieldDataType, pDataType[index]);
        }
    }
    
    /** 
      * @Author Eternus Solutions
      * @Description: Test method to test the functionality of constructor 
      *               "UltraTrackWrapper(String fieldApiName, String fieldLabel)".
      *               by passing historyWrapperRecord and boolean list pIsSelectedList as null
      * @Expected Result: Method should initialise class variables fieldApiName, fieldLabel.
      * @Date: 26/07/2016
      **/
    static testMethod void ultraTrackWrapperTestCase1() {
        ultraTrackWrapperTest(new list<String>{'AssistantName', null, ''},
                              new list<String>{'Assistant', null, ''},
                              new list<String>{'Text', null, ''},
                              null,
                              null,
                              null
                             );
    }
    
    /** 
      * @Author Eternus Solutions
      * @Description: Test method to test the functionality of constructor 
      *               "UltraTrackWrapper(String fieldApiName, String fieldLabel, List<HistoryWrapper> pHistoryList)"
      *               by passing boolean list pIsSelectedList as null.
      * @Expected Result: Method should initialise class variables fieldApiName, fieldLabel, historyList. 
      * @Date: 26/07/2016
      **/
    static testMethod void ultraTrackWrapperTestCase2() {
        // List to hold records of HistoryWrapper
        list<HistoryWrapper> historyList1 = new list<HistoryWrapper>();
        list<HistoryWrapper> historyList2;
        Account accountObj = TestDataFactory.getAccount('TestAccount');
        insert accountObj;
        
        historyList1.addAll(TestDataFactory.getHistoryList(new List<String> {'Value1', 'oldValue2'},
                                                           new List<String> {'Value2', 'oldValue2'},
                                                           accountObj.Id,
                                                           UserInfo.getUserId(), 
                                                           new List<DateTime> {DateTime.newInstance(2016, 07, 26, 20, 45, 00),
                                                                               DateTime.newInstance(2016, 07, 26, 20, 45, 00)}
                                                          )
                           );
        ultraTrackWrapperTest(new list<String>{'AssistantName', null, ''},
                              new list<String>{'Assistant', null, ''},
                              new list<String>{'Text', null, ''},
                              new list<list<HistoryWrapper>> {historyList1,
                                                              historyList2,
                                                              new list<HistoryWrapper>()
                                                             },
                              null,
                              null
                             );
    }
    
    /** 
      * @Author Eternus Solutions
      * @Description: Test method to test the functionality of constructor 
      *                "UltraTrackWrapper(String fieldApiName, String fieldLabel, Boolean isSelected)"
      *                by passing historyWrapperRecord.
      * @Expected Result: Method should initialise class variables fieldApiName, fieldLabel, isSelected. 
      * @Date: 26/07/2016
      **/
    static testMethod void ultraTrackWrapperTestCase3() {
        ultraTrackWrapperTest(new list<String>{'Assistant', null, ''},
                              new list<String>{'AssistantName', null, ''},
                              new list<String>{'Text', null, ''},
                              null,
                              new list<Boolean>{true, false, null},
                              new list<Boolean>{true, false, null});
    } 
    
    /** 
      * @Author Eternus Solutions
      * @Description: Method to test sorting of UltraTrackWrapper records based on fieldLabel variable
      *               with the following scenario: Assumed Configuration Custom setting is present and Field sorting 
      *               order is set as Ascending.
      * @Expected Result: Method should sort the UltraTrackWrapper records in ascending order based on fieldLabel.
      * @Date: 26/07/2016
      **/
    static testMethod void compareToTestCase1() {
        Configuration__c configObj = TestDataFactory.getConfiguration(URL.getSalesforceBaseUrl().getHost());
        compareToTest(configObj, 
                      new list<String>{'Description'},
                      new list<String>{'Description'},
                      new list<String>{'Long Text Area'},
                      new list<String>{'Description'},
                      new list<String>{'Description'});
    }
    
    /** 
      * @Author Eternus Solutions
      * @Description: Method to test sorting of UltraTrackWrapper records based on fieldLabel variable
      *               with the following scenario: Assumed Configuration Custom setting is not present.
      * @Expected Result: Method should sort the UltraTrackWrapper records by default in Ascending order based on fieldLabel.
      * @Date: 26/07/2016
      **/
    static testMethod void compareToTestCase2() {
        Configuration__c configObj;
        compareToTest(null, 
                      new list<String>{'Description'},
                      new list<String>{'Description'},
                      new list<String>{'Long Text Area'},
                      new list<String>{'Description'},
                      new list<String>{'Description'});
    }
}