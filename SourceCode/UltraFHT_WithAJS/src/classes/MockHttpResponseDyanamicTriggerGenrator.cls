/**
 * @Class Name: MockHttpResponseDyanamicTriggerGenrator
 * @Description: Mock response class for testing dynamic trigger generator class.
 * ========================================================================================================================
 *       Version   | Date        | Author             | Comments
 *   -------------------------------------------------------------------------------------------------------------------------
 *       1.0       | 30-03-2016  | Eternus Solution   | 1. Created mock response class.
 *  ========================================================================================================================
 **/

@isTest
global class MockHttpResponseDyanamicTriggerGenrator implements HttpCalloutMock {

    /**
     * @Description : Overridden respond method from HttpCalloutMock interface
     * @Parameter   : dummy HttpRequest from test class which performs the callout.
     **/
    global HTTPResponse respond(HTTPRequest req) {
        
        // Create a dummy response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"id" : "01q280000003o9O","success" : true,"errors" : []}');
        res.setStatusCode(200);
        return res;
    }
}