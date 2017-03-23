/**
  * @Class Name: MockHttpResponseDyanamicTriggerGenerator
  * @Description: Mock response class to generate dummy response for class "DynamicTriggerGenerator".
  *               This class is used in test class "DynamicTriggerGeneratorTest" to 
  *               generate dummy response.
  * =================================================================================================
  *    Version   | Date        | Author             | Comments
  * -------------------------------------------------------------------------------------------------
  *    1.0       | 29/02/2016  | Eternus Solution   | 1. Created mock response class.
  * =================================================================================================
  **/
@isTest
global class MockHttpResponseDyanamicTriggerGenerator implements HttpCalloutMock {
    /**
      * @Author: Eternus Solutions.
      * @Description: Implemented a method to override response method from HttpCalloutMock interface.
      * @Param: Dummy HttpRequest from test class which performs the callout.
      * @Return: It returns the HTTPResponse. 
      * @Date: 29/02/2016.
      **/
    global HttpResponse respond(HttpRequest req) {
    
        list<ApexTrigger> triggersList = [SELECT Id,
                                                 Name 
                                         FROM ApexTrigger 
                                         WHERE TableEnumOrId =: 'UFHT__Sharing_Purpose__c'
                                         LIMIT 1];
        
        // Create a dummy response
        HttpResponse res = new HttpResponse();
        res.setHeader(UFHTConstants.HTTP_CONTENT_TYPE, UFHTConstants.HTTP_CONTENT_TYPE_JSON);
        res.setBody('{"id":"'+ triggersList[0].Id +'" ,"success": true,"errors" : []}');
        res.setStatusCode(UFHTConstants.HTTP_RESPONSE_SUCCESS_CODE);
        TestUtil.checkAssertsForMockResponse(res);
        return res;
    }
}