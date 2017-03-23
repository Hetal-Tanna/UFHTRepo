/**
 * Class Name:       MockHttpResponseViewDataService 
 * @description:     Class set mock test response for ViewDataService class
 * @author: 
 * @date(mm-dd-yy):  07-04-2016
 * @revised:   
 */
@isTest
global  class MockHttpResponseViewDataService implements HttpCalloutMock{
    
    global HTTPResponse respond(HTTPRequest request) {
        
        Map<String, Object> mapOfParameters = (Map<String, Object>)JSON.deserializeUntyped(request.getBody());
        
        String strResponse;
        
        strResponse = ViewDataService.doPost((String)mapOfParameters.get('selectedObjectId'),
                                             (String)mapOfParameters.get('startDateStr'),
                                             (String)mapOfParameters.get('endDateStr'),
                                             boolean.valueOf(mapOfParameters.get('userFlag')),
                                             (String)mapOfParameters.get('offSetStr'));
        
        if(String.isEmpty(strResponse)){
            strResponse = 'null';
        }
        
        // Send the response to the class requesting web service
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody(strResponse);
        response.setStatusCode(200);
      
        return response;
    }

}