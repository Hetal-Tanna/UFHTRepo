/**
 * @Class Name: MockHttpResponseTriggerActivator.
 * @Description: Mock response class to generate dummy response for class "DynamicTriggerGenerator".
 *               This class is used in test class "DynamicTriggerGeneratorTest" to 
 *               generate dummy response.
 * ====================================================================================
 *    Version   | Date        | Author             | Comments
 * ------------------------------------------------------------------------------------
 *    1.0       | 03/07/2016  | Eternus Solutions   | 1. Created mock response class.
 * ====================================================================================
 **/
@isTest
global class MockHttpResponseTriggerActivator implements HttpCalloutMock{
    String sObjectId;
    
    /**
      * @Author: Eternus Solutions.
      * @Description: Constructor to initialise the member variables of class.
      * @Param: 1. pObjectId as Id to hold sObject Id.
      * @Return: NA. 
      * @Date: 03/07/2016.
    **/
    global MockHttpResponseTriggerActivator(String psObjectId){
        this.sObjectId = psObjectId;
    }
    
    /**
      * @Author: Eternus Solutions.
      * @Description: Implemented a method to override response method from HttpCalloutMock interface.
      * @Param: Dummy HttpRequest from test class which performs the callout.
      * @Return: It returns the HTTPResponse. 
      * @Date: 03/07/2016.
    **/
    global HttpResponse respond(HttpRequest req) {
                
        // Create a dummy response
        HttpResponse res = new HttpResponse();
        res.setHeader(UFHTConstants.HTTP_CONTENT_TYPE, UFHTConstants.HTTP_CONTENT_TYPE_JSON);
        res.setBody('{"id":"'+ sObjectId +'" ,"success": true,"errors" : []}');
        res.setStatusCode(UFHTConstants.HTTP_RESPONSE_SUCCESS_CODE);
        TestUtil.checkAssertsForMockResponse(res);
        return res;
    }
}