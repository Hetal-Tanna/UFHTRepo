/**
  * @Class Name: PageMessageWrapperTest
  * @Description: This class contains unit tests for PageMessageWrapper.cls
  * ====================================================================================================================
  *       Version   | Date        | Author             | Comments
  * --------------------------------------------------------------------------------------------------------------------
  *       1.0       | 07/02/2017  | Eternus Solutions  | 1. Created test class for PageMessageWrapper.
  * ====================================================================================================================
  **/
@isTest
private class PageMessageWrapperTest {
    
    static void getPageMessageAssert(String message,
                                        String messageType) {
         PageMessageWrapper messageWrapperObj =  new PageMessageWrapper(message,messageType);
         checkAssertForPageMessageWrapper(message, messageWrapperObj.triggerStatusMessage);
         checkAssertForPageMessageWrapper(messageType, messageWrapperObj.typeOfMessage);
        
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test method to check assert for positive and negative scenario of PageMessage method
      * @Expected Result: Method should check expected results with actual result
      * @Date: 07/02/2017
      **/
    static void checkAssertForPageMessageWrapper(String actualResult,String expectedResult) {

        expectedResult = (actualResult == null) ? null 
                                                : (actualResult == UFHTConstants.EMPTY_STRING ? UFHTConstants.EMPTY_STRING 
                                                                                              : expectedResult);
        System.assertEquals(expectedResult, actualResult);
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test method to check assert for positive and negative scenario of PageMessageWrapper method
      * @Expected Result: Method should check expected results with actual result
      * @Date: 07/02/2017
   **/
    static testMethod void messageWrapperTestCase() {
        list<String>   messageList     = new list<String> {'Testing the Message wraper'};
        list<String>   messageTypeList = new list<String> {'Warning','Error','Confirm'};
        
        Test.StartTest();
             for(String messageRef : messageList) {
                for(String messageTypeRef : messageTypeList) {
                	getPageMessageAssert(messageRef,messageTypeRef);
                }
             }
        Test.StopTest();
    }
}