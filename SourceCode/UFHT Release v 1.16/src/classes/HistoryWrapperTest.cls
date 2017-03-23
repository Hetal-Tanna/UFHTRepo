/**
  * @Class Name: HistoryWrapperTest
  * @Description: This class contains unit tests for HistoryWrapper.cls
  * ====================================================================================================================
  *       Version   | Date        | Author             | Comments
  * --------------------------------------------------------------------------------------------------------------------
  *       1.0       | 15/11/2015  | Eternus Solution   | 1.Created Test Class for HistoryWrapper
  * ====================================================================================================================
  **/
@isTest
private class HistoryWrapperTest {

    /**
      * @Author: Eternus Solutions
      * @Description: Created test data for Account
      * @Param: NA
      * @Return: Method should return account data.
      * @Date: 03/08/2016
      **/
    static Account insertAccountData() {
        Account accountObj = TestDataFactory.getAccount('TestAccount');
        insert accountObj;
        return accountObj;
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test method to verify if values are properly set related to history data or not
      * @Param: 1. oldValue: to display oldValue of field
      *         2. newValue: to display newValue of field
      *         3. parentId: to display record Id
      *         4. modifiedById: to display a record Id of the user who has modified the record
      *         5. modifiedDisplayTime: to display record modified time
      * @Return: NA
      * @Date: 03/08/2016
      **/
    static void getHistoryWrapperAssert(Account accountObj,
                                        String oldValue,
                                        String newValue,
                                        Id modifiedById,
                                        DateTime modifiedDateTime) {

        HistoryWrapper historyWrapperObj = new HistoryWrapper(oldValue,
                                                              newValue,
                                                              accountObj.Id,
                                                              modifiedById,
                                                              modifiedDateTime);

        checkAssertForHistoryWrapper(oldValue, historyWrapperObj.oldValue);
        checkAssertForHistoryWrapper(newValue, historyWrapperObj.newValue);
        checkAssertForHistoryWrapper(accountObj.Id, historyWrapperObj.parentId);
        checkAssertForHistoryWrapper(modifiedById, historyWrapperObj.modifiedById);
        
        if(modifiedDateTime != null) {
            checkAssertForHistoryWrapper(modifiedDateTime.formatGMT(UFHTConstants.DATE_TIME_FORMAT), historyWrapperObj.modifiedDateTime);
        }
        else {
            checkAssertForHistoryWrapper(String.valueOf(modifiedDateTime), historyWrapperObj.modifiedDateTime);
        }
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test method to check assert for positive and negative scenario of HistoryWrapper method
      * @Expected Result: Method should check expected results with actual result
      * @Date: 03/08/2016
      **/
    static void checkAssertForHistoryWrapper(String actualResult,String expectedResult) {

        expectedResult = (actualResult == null) ? null 
                                                : (actualResult == UFHTConstants.EMPTY_STRING ? UFHTConstants.EMPTY_STRING 
                                                                                              : expectedResult);
        System.assertEquals(expectedResult, actualResult);
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test method to verify the functionality of sorting with valid and invalid data
      * @Param: 1. accountObj: Account object
                2. oldValueList: list of oldValue
      *         3. newValueList: list of newValue
      *         4. modifiedById: for display modifiedBy Id
      *         5. modifiedDateTimeList: list of modifiedDateTime
      * @Return: Method should return the list of historyWrapper
      * @Date: 03/08/2016
      **/
    static list<HistoryWrapper> compareToForHistoryList(Account accountObj,
                                                        list<String> oldValueList,
                                                        list<String> newValueList,
                                                        Id modifiedById,
                                                        list<DateTime> modifiedDateTimeList) {

        // List to hold the records of wrapper class "HistoryWrapper"
        list<HistoryWrapper> historyList = new list<HistoryWrapper>();

        Test.startTest();
        historyList = TestDataFactory.getHistoryList(oldValueList,
                                                     newValueList,
                                                     accountObj.Id,
                                                     modifiedById,
                                                     modifiedDateTimeList
                                                    );
        historyList.sort();
        Test.stopTest();
        return historyList;
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test method to check assert for positive and negative scenario of compareTo method
      * @Expected Result: Method should check expected results with actual result
      * @Date: 03/08/2016
      **/
    static void checkAssertForCompareTo(Account accountObj,
                                        list<HistoryWrapper> expectedHistoryList,
                                        list<HistoryWrapper> historyList) {

        if(historyList != null){
            
            for(integer i= 0; i < historyList.size(); i++) {
                
                if(historyList[i] != null) {
                    if(expectedHistoryList[i].ModifiedDateTime != null) {
                        System.assertEquals(expectedHistoryList[i].ModifiedDateTime, historyList[i].ModifiedDateTime);
                    }
                    else {
                        System.assertEquals(null, historyList[i].ModifiedDateTime);
                    }
                    System.assertEquals(expectedHistoryList[i].oldValue, historyList[i].oldValue);
                    System.assertEquals(expectedHistoryList[i].newValue, historyList[i].newValue);
                    System.assertEquals(expectedHistoryList[i].parentId, historyList[i].parentId);
                    System.assertEquals(expectedHistoryList[i].ModifiedById, historyList[i].ModifiedById);
                }
                else {
                    System.assertEquals(expectedHistoryList[i] , historyList[i]);
                }
            }
        }
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test method to verify the functionality for values passed to constructor is correctly assigned
      *               to variables with following scenario: Passed all parameter with valid , null and empty data.
      * @Expected Result: Method should check all passed values correctly assigned to variable.
      * @Date: 03/08/2016
      **/
    static testMethod void historyWrapperTestCase() {

        list<String>   oldValueList          = new list<String> {null,UFHTConstants.EMPTY_STRING,'TestAccount'};
        list<String>   newValueList          = new list<String> {null,UFHTConstants.EMPTY_STRING,'Test Acc'};
        list<Id>       modifiedByIdList      = new list<Id>     {UserInfo.getUserId()};
        list<DateTime> modifiedDateTimeList  = new list<DateTime> {null,DateTime.newInstance(2016, 07, 28, 20, 45, 00)};

        Test.startTest();
        Account accountObj = insertAccountData();

        for(String oldValueRef : oldValueList) {
            for(String newValueRef : newValueList) {
                for(String modifiedByIdRef : modifiedByIdList) {
                    for(DateTime modifiedDateTimeRef : modifiedDateTimeList) {
                        getHistoryWrapperAssert(
                                                accountObj,
                                                oldValueRef,
                                                newValueRef,
                                                modifiedByIdRef,
                                                modifiedDateTimeRef
                        );
                    }
                }
            }
        }
        Test.stopTest();
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test method to verify the sorting of HistoryWrapper records based on ModifiedDatetime.
      * @Expected Result: Method should sort history wrapper records in descending order based on ModifiedDatetime.
      * @Date: 03/08/2016
      **/
    static testMethod void compareToTestCase1() {
        Account accountObj = insertAccountData();
        list<HistoryWrapper> historyList = compareToForHistoryList(accountObj,
                                                                   new list<String> {'2', '3', '4'},
                                                                   new list<String> {'5', '6', '7'},
                                                                   UserInfo.getUserId(),
                                                                   new list<DateTime> {DateTime.newInstance(2016, 07, 26, 20, 45, 00),
                                                                                       DateTime.newInstance(2016, 07, 27, 20, 45, 00),
                                                                                       DateTime.newInstance(2016, 07, 28, 20, 45, 00)});
                                                                                       
        list<HistoryWrapper> expectedHistoryList = TestDataFactory.getHistoryList(new list<String> {'4', '3', '2'},
                                                                             new list<String> {'7', '6', '5'},
                                                                             accountObj.Id,
                                                                             UserInfo.getUserId(),
                                                                             new list<DateTime> {DateTime.newInstance(2016, 07, 28, 20, 45, 00),
                                                                                                 DateTime.newInstance(2016, 07, 27, 20, 45, 00),
                                                                                                 DateTime.newInstance(2016, 07, 26, 20, 45, 00)}
                                                                            );
        checkAssertForCompareTo(accountObj, expectedHistoryList, historyList);
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test method to verify the sorting of HistoryWrapper records based on ModifiedDatetime.
      * @Expected Result: Method should sort history wrapper records in descending order based on ModifiedDatetime.
      * @Date: 03/08/2016
      **/
    static testMethod void compareToTestCase2() {
        Account accountObj = insertAccountData();
        list<HistoryWrapper> historyList = compareToForHistoryList(accountObj,
                                                                   new list<String> {'2', '3', '4'},
                                                                   new list<String> {'5', '6', '7'},
                                                                   UserInfo.getUserId(),
                                                                   new list<DateTime> {DateTime.newInstance(2016, 07, 26, 20, 45, 00),
                                                                                       DateTime.newInstance(2016, 07, 27, 20, 45, 00),
                                                                                       DateTime.newInstance(2016, 07, 27, 20, 45, 00)});
                                                                                       
        list<HistoryWrapper> expectedHistoryList = TestDataFactory.getHistoryList(new list<String> {'3', '4', '2'},
                                                                                  new list<String> {'6', '7', '5'},
                                                                                  accountObj.Id,
                                                                                  UserInfo.getUserId(),
                                                                                  new list<DateTime> {DateTime.newInstance(2016, 07, 27, 20, 45, 00),
                                                                                                      DateTime.newInstance(2016, 07, 27, 20, 45, 00),
                                                                                                      DateTime.newInstance(2016, 07, 26, 20, 45, 00)}
                                                                                 );

        checkAssertForCompareTo(accountObj, expectedHistoryList, historyList);
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test method to verify the sorting of HistoryWrapper records based on ModifiedDatetime.
      *               Scenario: ModifiedDatetime is null.
      * @Expected Result: Method should sort history wrapper records in descending order based on
      *                   ModifiedDatetime.
      * @Date: 03/08/2016
      **/
    static testMethod void compareToTestCase3() {
        Account accountObj = insertAccountData();
        list<HistoryWrapper> historyList = compareToForHistoryList(accountObj,
                                                                   new list<String> {'2', '3', '4'},
                                                                   new list<String> {'5', '6', '7'},
                                                                   UserInfo.getUserId(),
                                                                   new list<DateTime> {DateTime.newInstance(2016, 07, 26, 20, 45, 00),
                                                                                       DateTime.newInstance(2016, 07, 27, 20, 45, 00),
                                                                                       null});
        
        list<HistoryWrapper> expectedHistoryList = TestDataFactory.getHistoryList(new list<String> {'3', '2', '4'},
                                                                                  new list<String> {'6', '5', '7'},
                                                                                  accountObj.Id,
                                                                                  UserInfo.getUserId(),
                                                                                  new list<DateTime> {DateTime.newInstance(2016, 07, 27, 20, 45, 00),
                                                                                                      DateTime.newInstance(2016, 07, 26, 20, 45, 00),
                                                                                                      null
                                                                                                     }
                                                                                 );

        checkAssertForCompareTo(accountObj, expectedHistoryList, historyList);
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test method to verify the sorting of HistoryWrapper records based on ModifiedDatetime.
      *               Scenario: HistoryWrapper class object is null.
      * @Expected Result: Method should sort history wrapper records in descending order based on
      *                   ModifiedDatetime. If list contains null object then it will come at first position
      *                   and if ModifiedDatetime is null then record will come at last position.
      * @Date: 03/08/2016
      **/
    static testMethod void compareToTestCase4() {
        Account accountObj = insertAccountData();
        list<HistoryWrapper> historyList = compareToForHistoryList(accountObj,
                                                                   new list<String> {'2', '3', '4'},
                                                                   new list<String> {'5', '6', '7'},
                                                                   UserInfo.getUserId(),
                                                                   new list<DateTime> {DateTime.newInstance(2016, 07, 26, 20, 45, 00),
                                                                                       DateTime.newInstance(2016, 07, 27, 20, 45, 00),
                                                                                       DateTime.newInstance(2016, 07, 28, 20, 45, 00)});
        historyList.add(null);
        historyList.sort();
        
        list<HistoryWrapper> expectedHistoryList = new list<HistoryWrapper>();
        expectedHistoryList.add(null);
        expectedHistoryList.addAll(TestDataFactory.getHistoryList(new list<String> {'4', '3', '2'},
                                                                               new list<String> {'7', '6', '5'},
                                                                               accountObj.Id,
                                                                               UserInfo.getUserId(),
                                                                               new list<DateTime> {DateTime.newInstance(2016, 07, 28, 20, 45, 00),
                                                                                                   DateTime.newInstance(2016, 07, 27, 20, 45, 00),
                                                                                                   DateTime.newInstance(2016, 07, 26, 20, 45, 00)}
                                                            ));
                                                                                 
        checkAssertForCompareTo(accountObj, expectedHistoryList, historyList);
    }
}