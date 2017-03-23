@isTest
global class MockHttpResponseDyanamicTriggerGenrator implements HttpCalloutMock {

    global HTTPResponse respond(HTTPRequest req) {
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"id" : "01q280000003o9O","success" : true,"errors" : []}');
        res.setStatusCode(200);
        return res;
    }
}