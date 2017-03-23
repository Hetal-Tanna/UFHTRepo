/**
  * @Class Name: DateFilterWrapperTest
  * @Description: This class contains unit tests for DateFilterWrapper.cls
  * ===========================================================================================================
  *       Version   | Date        | Author             | Comments
  * -----------------------------------------------------------------------------------------------------------
  *       1.0       | 21/07/2016  | Eternus Solutions  | 1.Created the Test Class for DateFilterWrapper
  * ===========================================================================================================
  **/
@isTest
public class DateFilterWrapperTest {
    
   /** 
    * @Author: Eternus Solutions
    * @Description: Method to create an instance of DateFilterWrapper with valid and invalid scenarios
    * @Param: 1. serialNumber: An integer which will be a serial number to used to sort a list
    *         2. dateFilters: Date filters values which will be sort according to serial number
    * @Date: 21/07/2016
    **/ 
    static void createDateFilterWrapper(Integer serialNumber, String dateFilters) {
        Test.startTest();
        DateFilterWrapper dateFilterObj = new DateFilterWrapper(serialNumber, dateFilters);
        Test.stopTest();
        
        // Check assert for serial number
        serialNumber = (serialNumber == null) ? 0 : serialNumber;
        System.assertEquals(serialNumber, dateFilterObj.srNo);
        
        // Check assert for date filters
        dateFilters = (dateFilters == null) ? UFHTConstants.EMPTY_STRING : dateFilters;
        System.assertEquals(dateFilters, dateFilterObj.name);
    }
    
   /** 
    * @Author: Eternus Solutions
    * @Description: Method to create an instance of DateFilterWrapper to sort with valid and invalid scenarios
    * @Param: 1. inputSrNoList: List of integer which will be a serial number to used to sort a list
    *         2. inputDateFilter: List of date filters values which will be sort according to serial number
    *         3. expectedSrNo: List of expected output of serial numbers after sorting
    *         4. expectedDateFilter: List of expected output of date filters after sorting
    * @Date: 21/07/2016
    **/ 
    static void sortDateFilterWrapper(list<Integer> inputSrNoList, list<String> inputDateFilter,
                                           list<Integer> expectedSrNo, list<String> expectedDateFilter) {
        
        list<DateFilterWrapper> dateFilterWrapperList;
        Test.startTest();
        dateFilterWrapperList = TestDataFactory.getDateFilter(inputSrNoList, inputDateFilter);
        dateFilterWrapperList.sort();
        Test.stopTest();
        
        for(Integer i = 0; i < dateFilterWrapperList.size(); i++) {
            System.assertEquals(expectedSrNo[i], dateFilterWrapperList[i].srNo);
            System.assertEquals(expectedDateFilter[i], dateFilterWrapperList[i].name);
        }
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Method to verify FieldHistoryWrapper by passing valid serial number and date filter
      * @Expected Result: Method should check if proper values are assigned or not
      * @Date: 21/07/2016
     **/ 
    static testMethod void dateFilterWrapperTestCase1() {
        createDateFilterWrapper(1, 'Current and Previous Month');
    }
    
   /** 
    * @Author: Eternus Solutions
    * @Description: Method to verify FieldHistoryWrapper by passing serial number as null and valid date filter
    * @Expected Result: Method should check if proper values are assigned or not
    * @Date: 21/07/2016
    **/ 
    static testMethod void dateFilterWrapperTestCase2() {
        createDateFilterWrapper(null, 'Current and Previous Month');
    }
    
   /** 
    * @Author: Eternus Solutions
    * @Description: Method to verify FieldHistoryWrapper by passing date filter parameter as null and valid serial number
    * @Expected Result: Method should check if proper values are assigned or not
    * @Date: 21/07/2016
    **/ 
    static testMethod void dateFilterWrapperTestCase3() {
        createDateFilterWrapper(1, null);
    }
    
   /** 
    * @Author: Eternus Solutions
    * @Description: Method to verify FieldHistoryWrapper by passing serial number and name parameters as null
    * @Expected Result: Method should check if proper values are assigned or not
    * @Date: 21/07/2016
    **/
    static testMethod void dateFilterWrapperTestCase4() {
        createDateFilterWrapper(null, null);
    }
    
   /** 
    * @Author: Eternus Solutions
    * @Description: Method to verify FieldHistoryWrapper by passing serial number and name parameters as null
    * @Expected Result: Method should check if proper values are assigned or not
    * @Date: 21/07/2016
    **/
    static testMethod void dateFilterWrapperTestCase5() {
        createDateFilterWrapper(1, '');
    }
    
   /** 
    * @Author: Eternus Solutions
    * @Description: Method to verify FieldHistoryWrapper by passing serial number and name parameters as null
    * @Expected Result: Method should check if proper values are assigned or not
    * @Date: 21/07/2016
    **/
    static testMethod void dateFilterWrapperTestCase6() {
        createDateFilterWrapper(null, '');
    }
    
   /** 
    * @Author: Eternus Solutions
    * @Description: Method to verify FieldHistoryWrapper by passing wrapper list to sort 
    *               with valid serial number and date filter parameter
    * @Expected Result: Method should check if list is sorted correctly or not
    * @Date: 21/07/2016
    **/
    static testMethod void dateFilterWrapperCompareToCaseTest1() {
        sortDateFilterWrapper(new list<Integer>{3, 1, 2}, new list<String>{'Test3', 'Test2', 'Test1'},
                              new list<Integer>{1, 2, 3}, new list<String>{'Test2', 'Test1', 'Test3'});
    }
    
   /** 
    * @Author: Eternus Solutions
    * @Description: Method to verify FieldHistoryWrapper by passing wrapper list to sort
    *               with more than one serial number and valid date filter parameter
    * @Expected Result: Method should check if list is sorted correctly or not
    * @Date: 21/07/2016
    **/
    static testMethod void dateFilterWrapperCompareToCaseTest2() {
       sortDateFilterWrapper(new list<Integer>{null, 1, null}, new list<String>{'Test3', 'Test2', 'Test1'},
                             new list<Integer>{0, 0, 1}, new list<String>{'Test3', 'Test1', 'Test2'});
    }
    
   /** 
    * @Author: Eternus Solutions
    * @Description: Method to verify FieldHistoryWrapper by passing wrapper list to sort 
    *               with all serial number as null and valid date filter parameter
    * @Expected Result: Method should check if list is sorted correctly or not
    * @Date: 21/07/2016
    **/
    static testMethod void dateFilterWrapperCompareToCaseTest3() {
        sortDateFilterWrapper(new list<Integer>{null, null, null}, new list<String>{'Test3', 'Test2', 'Test1'},
                              new list<Integer>{0, 0, 0}, new list<String>{'Test3', 'Test2', 'Test1'});
    }
    
   /** 
    * @Author: Eternus Solutions
    * @Description: Method to verify FieldHistoryWrapper by passing wrapper list to sort 
    *               with date filter as blank
    * @Expected Result: Method should check if list is sorted correctly or not
    * @Date: 21/07/2016
    **/
    static testMethod void dateFilterWrapperCompareToCaseTest4() {
        sortDateFilterWrapper(new list<Integer>{2, 3, 1}, new list<String>{'Test1', '', 'Test3'},
                              new list<Integer>{1, 2, 3}, new list<String>{'Test3', 'Test1', UFHTConstants.EMPTY_STRING});
    }
    
   /** 
    * @Author: Eternus Solutions
    * @Description: Method to verify FieldHistoryWrapper by passing wrapper list to sort 
    *               with more than 1 date filters as blank
    * @Expected Result: Method should check if list is sorted correctly or not
    * @Date: 21/07/2016
    **/
    static testMethod void dateFilterWrapperCompareToCaseTest5() {
        sortDateFilterWrapper(new list<Integer>{2, 3, 1}, 
                              new list<String>{'Test3', '', ''},
                              new list<Integer>{1, 2, 3}, 
                              new list<String>{UFHTConstants.EMPTY_STRING, 'Test3', UFHTConstants.EMPTY_STRING});
    }
    
   /** 
    * @Author: Eternus Solutions
    * @Description: Method to verify FieldHistoryWrapper by passing wrapper list to sort 
    *               with date filter as blank and serial number as null
    * @Expected Result: Method should check if list is sorted correctly or not
    * @Date: 21/07/2016
    **/
    static testMethod void dateFilterWrapperCompareToCaseTest6() {
        sortDateFilterWrapper(new list<Integer>{null, 3, 1}, 
                              new list<String>{'Test3', '', ''},
                              new list<Integer>{0, 1, 3}, 
                              new list<String>{'Test3', UFHTConstants.EMPTY_STRING, UFHTConstants.EMPTY_STRING});
    }
    
   /** 
    * @Author: Eternus Solutions
    * @Description: Method to verify FieldHistoryWrapper by passing wrapper list to sort 
    *               with date filter as null and serial number as null
    * @Expected Result: Method should check if list is sorted correctly or not
    * @Date: 21/07/2016
    **/
    static testMethod void dateFilterWrapperCompareToCaseTest9() {
        sortDateFilterWrapper(new list<Integer>{null, 3, 1}, 
                              new list<String>{null, 'Test1', null},
                              new list<Integer>{0, 1, 3}, 
                              new list<String>{UFHTConstants.EMPTY_STRING, UFHTConstants.EMPTY_STRING, 'Test1'});
    }   
}