/**
  * @Class Name: MockHttpResponseForSetupController2
  * @Description: The class provides mock response for http callout from UltraSetupController.
  * ===================================================================================================
  *    Version   | Date        | Author             | Comments
  * ---------------------------------------------------------------------------------------------------
  *    1.0       | 15/11/2015  | Eternus Solutions  | 1. Created the respond method for dummy response.
  * ===================================================================================================
  **/
@isTest
global class MockHttpResponseForSetupController2 implements HttpCalloutMock {
    /**
      * @Author: Eternus Solutions
      * @Description: Implemented interface method to create dummy response.
      * @Param: HttpRequest param to hold the Request.
      * @Return: HttpResponse.
      * @Date: 22/07/2016
      **/
    global HttpResponse respond(HttpRequest req) {
        // Create a dummy response
        list<StaticResource> resourceList= [SELECT Name, Body 
                                            FROM StaticResource 
                                            WHERE Name = 'UltraSetupControllerJsonData'];
        HttpResponse res = new HttpResponse();
        res.setHeader(UFHTConstants.HTTP_CONTENT_TYPE , UFHTConstants.HTTP_CONTENT_TYPE_JSON );
        if(resourceList != null && !resourceList.isEmpty()) {
            res.setBody(resourceList[0].Body.toString());
        }
        else {
            res.setBody(UFHTConstants.EMPTY_STRING );
        }
        res.setStatusCode(UFHTConstants.HTTP_RESPONSE_SUCCESS_CODE );
        TestUtil.checkAssertsForMockResponse(res);
        return res;
    }
}