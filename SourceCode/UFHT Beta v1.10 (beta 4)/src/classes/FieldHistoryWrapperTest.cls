/**
  * @Class Name: FieldHistoryWrapperTest
  * @Description: This class contains unit tests for FieldHistoryWrapper.cls
  * ====================================================================================================================
  *       Version   | Date        | Author             | Comments
  * -------------------------------------------------------------------------------------------------------------------
  *       1.0       | 21/07/2016  | Eternus Solutions  | 1. Created the Test Class for FieldHistoryWrapper
  * ====================================================================================================================
  **/
@isTest
public class FieldHistoryWrapperTest {
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Method to create a History record along with field name.
      * @Param: 1. fieldName - Name of the field
      *         2. fieldLabel - Label of the field
      *         3. isHistoryObjNull - Boolean variable which to identify FieldHistoryWrapper is null or not
      *                               true - not null, false - null
      * @Date: 2/08/2016
      **/ 
    static void createFieldHistoryWrapper(String fieldName, String fieldLabel, Boolean isHistoryObjNull) {
        Account accObj = TestDataFactory.getAccount('Test Account');
        insert accObj;
        HistoryWrapper historyObj;
        FieldHistoryWrapper filterWrapperObj;
        
        Test.startTest();
        if(!isHistoryObjNull) {
            historyObj = TestDataFactory.getHistoryInstance(accObj.Name, 'Test acc', accObj.Id,
                                                            UserInfo.getUserId(), System.now());
        
            
            filterWrapperObj = new FieldHistoryWrapper(fieldName, fieldLabel, historyObj);
        }
        else {
            filterWrapperObj = new FieldHistoryWrapper(fieldName, fieldLabel, null);
        }
        Test.stopTest();
        
        // Check assert when FieldHistoryWrapper object is null
        if(historyObj == null) {
            System.assert(filterWrapperObj.historyWrapperObject == null);
        }
        // Check assert when FieldHistoryWrapper object is not null
        else {
            System.assert(filterWrapperObj.historyWrapperObject != null);
        }
        
        // Check assert for fieldName of FieldHistoryWrapper
        fieldName = (String.isBlank(fieldName)) ?  UFHTConstants.WHITE_SPACE : filterWrapperObj.fieldName;
        System.assertEquals(fieldName, filterWrapperObj.fieldName);
        
        // Check assert for fieldLabel of FieldHistoryWrapper
        fieldLabel = (String.isBlank(fieldLabel)) ?  UFHTConstants.WHITE_SPACE : filterWrapperObj.fieldLabel;
        System.assertEquals(fieldLabel, filterWrapperObj.fieldLabel);
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Method to verify FieldHistoryWrapper by passing all valid parameters
      * @Expected Result: Method should check if values are assigned or not
      * @Date: 21/07/2016
      **/ 
    static testMethod void fieldHistoryWrapperTestCase1() {
       createFieldHistoryWrapper('Name', 'Name', true);
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Method to verify FieldHistoryWrapper by passing
      *               - fieldName as null
      *               - fieldLabel and historyWrapperObj with valid value
      * @Expected Result: Method should check if values are assigned or not
      * @Date: 21/07/2016
      **/ 
    static testMethod void fieldHistoryWrapperTestCase2() {
        createFieldHistoryWrapper(null, 'Name', true);
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Method to verify FieldHistoryWrapper by passing
      *               - fieldLabel as null
      *               - fieldName and historyWrapperObj with valid value
      * @Expected Result: Method should check if values are assigned or not
      * @Date: 21/07/2016
      **/ 
    static testMethod void fieldHistoryWrapperTestCase3() {
        createFieldHistoryWrapper('Name', null, true);
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Method to verify FieldHistoryWrapper by passing
      *               - historyWrapperObj as null
      *               - fieldName and fieldLabel with valid value             
      * @Expected Result: Method should check if values are assigned or not
      * @Date: 21/07/2016
      **/
    static testMethod void fieldHistoryWrapperTestCase4() {
        createFieldHistoryWrapper('Name', 'Name', false);
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Method to verify FieldHistoryWrapper by passing
      *               - fieldName and fieldLabel as null
      *               - historyWrapperObj with valid value
      * @Expected Result: Method should check if values are assigned or not
      * @Date: 21/07/2016
      **/
    static testMethod void fieldHistoryWrapperTestCase5() {
        createFieldHistoryWrapper(null, null, true);
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Method to verify FieldHistoryWrapper by passing
      *               - fieldLabel and historyWrapperObj as null
      *               - fieldName with valid value
      * @Expected Result: Method should check if values are assigned or not
      * @Date: 21/07/2016
      **/
    static testMethod void fieldHistoryWrapperTestCase6() {
        createFieldHistoryWrapper('Name', null, false);
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Method to verify FieldHistoryWrapper by passing
      *               - fieldName and historyWrapperObj as null
      *               - fieldLabel with valid value
      * @Expected Result: Method should check if values are assigned or not
      * @Date: 21/07/2016
      **/
    static testMethod void fieldHistoryWrapperTestCase7() {
        createFieldHistoryWrapper(null, 'Name', false);
    }

    /** 
      * @Author: Eternus Solutions
      * @Description: Method to verify FieldHistoryWrapper by passing all parameters as null
      * @Expected Result: Method should check if values are assigned or not
      * @Date: 21/07/2016
      **/
    static testMethod void fieldHistoryWrapperTestCase8() {
        createFieldHistoryWrapper(null, null, false);
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Method to verify FieldHistoryWrapper passing fieldName as blank
      *               - fieldName as blank
      *               - fieldLabel and historyWrapperObj with valid value
      * @Expected Result: Method should check if values are assigned or not
      * @Date: 21/07/2016
      **/
    static testMethod void fieldHistoryWrapperTestCase9() {
        createFieldHistoryWrapper('', 'Name', true);
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Method to verify FieldHistoryWrapper by passing
      *               - fieldName and fieldLabel as blank
      *               - historyWrapperObj with valid value
      * @Expected Result: Method should check if values are assigned or not
      * @Date: 21/07/2016
      **/
    static testMethod void fieldHistoryWrapperTestCase10() {
        createFieldHistoryWrapper('', '', true);
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Method to verify FieldHistoryWrapper by passing
      *               - fieldName and fieldLabel as blank
      *               - historyWrapperObj as null
      * @Expected Result: Method should check if values are assigned or not
      * @Date: 21/07/2016
      **/
    static testMethod void fieldHistoryWrapperTestCase11() {
        createFieldHistoryWrapper('', '', false);
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Method to verify FieldHistoryWrapper by passing fieldLabel as blank and valid fieldName 
      *               - fieldLabel as blank
      *               - historyWrapperObj as null
      *               - fieldName with valid value
      * @Expected Result: Method should check if values are assigned or not
      * @Date: 21/07/2016
      **/
    static testMethod void fieldHistoryWrapperTestCase12() {
        createFieldHistoryWrapper('Name', '', false);
    }
}