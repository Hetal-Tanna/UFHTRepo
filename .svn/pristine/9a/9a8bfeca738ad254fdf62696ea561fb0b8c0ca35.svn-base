/**
 * Class Name:       MockHttpResponseTest
 * @description:     Class set mock test response
 * @author: 
 * @date(mm-dd-yy):  07-01-2016
 * @revised:   
 */
@isTest
global  class MockHttpResponseTest implements HttpCalloutMock{
    
    global HTTPResponse respond(HTTPRequest request) {
        
        Map<String, Object> mapParameterAndId = (Map<String, Object>)JSON.deserializeUntyped(request.getBody());
        
        Integer intResponse = ViewDataNumberOfAttachmentWebSerive.doPost((String)mapParameterAndId .get('selectedObjectId'));
        
        // Send the response to the class requesting web service
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"0":"'+intResponse+'"}');
        response.setStatusCode(200);
        
        return response;
    }

}