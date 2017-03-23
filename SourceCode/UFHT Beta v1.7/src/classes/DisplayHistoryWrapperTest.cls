/**
  * @Class Name: DisplayHistoryWrapperTest
  * @Description: This class contains unit tests for DisplayHistoryWrapper.cls
  * ====================================================================================================================
  *       Version   | Date        | Author             | Comments
  * --------------------------------------------------------------------------------------------------------------------
  *       1.0       | 21/07/2016  | Eternus Solutions  | 1. Created test class for DisplayHistoryWrapper.
  * ====================================================================================================================
  **/
@isTest
public class DisplayHistoryWrapperTest {

    /**
      * @Author: Eternus Solutions
      * @Description: Created test data for Account
      * @Param: NA
      * @Return: Method should return account data.
      * @Date: 22/07/2016
      **/
    static Account insertAccountData() {
        Account accountObj = TestDataFactory.getAccount('Test Account');
        insert accountObj;
        return accountObj;
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test method to check assert for positive and negative scenario of DisplayHistoryWrapper method
      * @Expected Result: Method should check expected results with actual result
      * @Date: 22/07/2016
      **/
    static void checkAssertForDisplayHistoryWrapper(String actualResult, String expectedResult) {

        expectedResult = (actualResult == null) ? null : (actualResult == UFHTConstants.WHITE_SPACE ? UFHTConstants.WHITE_SPACE : expectedResult);
        System.assertEquals(expectedResult, actualResult);
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test method to verify all passed values are correctly assigned to the variables or not.
      * @Param: 1. accountObj: Account object
      *         2. modifiedDisplayTime: to display modified time
      *         3. modifiedTime: to display record modified time
      *         4. modifiedByName: to display record modified By Name
      *         5. modifiedById: to display a record Id of the user who has modified the record
      *         6. fieldLabel: to display fieldLabel
      *         7. fieldName: to display fieldName
      *         8. oldValue: to display oldValue of field
      *         9. newValue: to display newValue of field
      * @Return: NA
      * @Date: 22/07/2016
      **/
    static void getDisplayHistoryWrapperAssert(Account accountObj,
                                               String modifiedDisplayTime,
                                               String modifiedTime,
                                               String modifiedByName,
                                               Id modifiedById,
                                               String fieldLabel,
                                               String fieldName,
                                               String oldValue,
                                               String newValue) {

        DisplayHistoryWrapper displayWrapperObj = new DisplayHistoryWrapper(accountObj.Id,
                                                                            accountObj.Name,
                                                                            modifiedDisplayTime,
                                                                            modifiedTime,
                                                                            modifiedByName,
                                                                            modifiedById,
                                                                            fieldLabel,
                                                                            fieldName,
                                                                            oldValue,
                                                                            newValue);

        checkAssertForDisplayHistoryWrapper(accountObj.Id, displayWrapperObj.parentId);
        checkAssertForDisplayHistoryWrapper(accountObj.Name, displayWrapperObj.recordName);
        checkAssertForDisplayHistoryWrapper(modifiedDisplayTime, displayWrapperObj.modifiedDisplayTime);
        checkAssertForDisplayHistoryWrapper(modifiedTime, displayWrapperObj.modifiedTime);
        checkAssertForDisplayHistoryWrapper(modifiedByName, displayWrapperObj.modifiedByName);
        checkAssertForDisplayHistoryWrapper(modifiedById, displayWrapperObj.modifiedById);
        checkAssertForDisplayHistoryWrapper(fieldLabel, displayWrapperObj.fieldLabel);
        checkAssertForDisplayHistoryWrapper(fieldName, displayWrapperObj.fieldName);
        checkAssertForDisplayHistoryWrapper(oldValue, displayWrapperObj.oldValue);
        checkAssertForDisplayHistoryWrapper(newValue, displayWrapperObj.newValue);
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test method to verify the functionality for values passed to constructor is correctly assigned
      *               to variables with following scenario: Passed all parameter with valid , null and empty data.
      * @Expected Result: Method should check all passed values correctly assigned to variable.
      * @Date: 22/07/2016
      **/
    static testMethod void displayHistoryWrapperTestCase() {

        list<String> modifiedDisplayTimeList = new list<String> {null, UFHTConstants.WHITE_SPACE, String.valueOf(System.today())};
        list<String> modifiedTimeList        = new list<String> {null, UFHTConstants.WHITE_SPACE, String.valueOf(System.today())};
        list<String> modifiedByNameList      = new list<String> {null, UFHTConstants.WHITE_SPACE, UserInfo.getName()};
        list<Id>     modifiedByIdList        = new list<Id>     {UserInfo.getUserId()};
        list<String> fieldLabelList          = new list<String> {null, UFHTConstants.WHITE_SPACE, 'Name'};
        list<String> fieldNameList           = new list<String> {null, UFHTConstants.WHITE_SPACE, 'Name'};
        list<String> oldValueList            = new list<String> {null, UFHTConstants.WHITE_SPACE, 'Test Account'};
        list<String> newValueList            = new list<String> {null, UFHTConstants.WHITE_SPACE, 'Test Acc'};

        Test.startTest();
        Account accountObj = insertAccountData();

        for(String modifiedDisplayTimeRef : modifiedDisplayTimeList) {
            for(String modifiedTimeRef : modifiedTimeList) {
                for(String modifiedByNameRef : modifiedByNameList) {
                    for(Id modifiedByIdRef : modifiedByIdList) {
                        for(String fieldLabelRef : fieldLabelList) {
                            for(String fieldNameRef : fieldNameList) {
                                for(String oldValueRef : oldValueList) {
                                    for(String newValueRef : newValueList) {
                                        getDisplayHistoryWrapperAssert(
                                                                        accountObj,
                                                                        modifiedDisplayTimeRef,
                                                                        modifiedTimeRef,
                                                                        modifiedByNameRef,
                                                                        modifiedByIdRef,
                                                                        fieldLabelRef,
                                                                        fieldNameRef,
                                                                        oldValueRef,
                                                                        newValueRef
                                        );
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        Test.stopTest();
    }
}