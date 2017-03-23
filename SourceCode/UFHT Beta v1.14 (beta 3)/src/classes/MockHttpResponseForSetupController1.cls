/**
  * @Class Name: MockHttpResponseForSetupController 1
  * @Description: The class provides mock response for http callout from UltraSetupController.
  * ===================================================================================================
  *    Version   | Date        | Author             | Comments
  * ---------------------------------------------------------------------------------------------------
  *    1.0       | 15/11/2015  | Eternus Solutions  | 1. Created the respond method for dummy response.
  * ===================================================================================================
  **/
@isTest
global class MockHttpResponseForSetupController1 implements HttpCalloutMock {
    /**
      * @Author: Eternus Solutions
      * @Description: Implemented interface method to create dummy response.
      * @Param: HttpRequest param to hold the Request.
      * @Return: HttpResponse.
      * @Date: 15/11/2015
      **/
    global HttpResponse respond(HttpRequest req) {
        // Create a dummy response
        
        HttpResponse res = new HttpResponse();
        
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"encoding" : "UTF-8","maxBatchSize" : 200,"sobjects" : [ {"activateable" : false,'
                    +'"createable" : true,"custom" : false,"customSetting" : false,"deletable" : true,'
                    +'"deprecatedAndHidden" : false,"feedEnabled" : true,"keyPrefix" : "001","label" : "Account",'
                    +'"labelPlural" : "Accounts","layoutable" : true,"mergeable" : true,"name" : "Account",'
                    +'"queryable" : true,"replicateable" : true,"retrieveable" : true,"searchable" : true,"triggerable" : true,'
                    +'"undeletable" : true,"updateable" : true,'
                    +'"urls" : {"compactLayouts" : "/services/data/v34.0/sobjects/Account/describe/compactLayouts",'
                    +'"rowTemplate" : "/services/data/v34.0/sobjects/Account/{ID}",'
                    +'"approvalLayouts" : "/services/data/v34.0/sobjects/Account/describe/approvalLayouts",'
                    +'"listviews" : "/services/data/v34.0/sobjects/Account/listviews",'
                    +'"describe" : "/services/data/v34.0/sobjects/Account/describe",'
                    +'"quickActions" : "/services/data/v34.0/sobjects/Account/quickActions",'
                    +'"layouts" : "/services/data/v34.0/sobjects/Account/describe/layouts",'
                    +'"sobject" : "/services/data/v34.0/sobjects/Account"}}]}');
        res.setStatusCode(UFHTConstants.HTTP_RESPONSE_SUCCESS_CODE);
        TestUtil.checkAssertsForMockResponse(res);
       
        return res;
       
    }
}