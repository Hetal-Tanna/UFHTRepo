/**
  * @Class Name: UnauthorizedEndpointResponse 
  * @Description: The class provides dummy mock response for Unauthorized end point.
  * ===================================================================================================
  *    Version   | Date        | Author             | Comments
  * ---------------------------------------------------------------------------------------------------
  *    1.0       | 27/07/2016  | Eternus Solutions  | 1. Created the respond method for dummy respose.
  * ===================================================================================================
  **/

/**
  * @Author: Eternus Solutions
  * @Description: Implemented interface method to provide dummy mock response for Unauthorized end point.
  * @Param: HttpRequest param to hold the Request.
  * @Return: HttpResponse.
  * @Date: 27/07/2016
  **/
@isTest
global class UnauthorizedEndpointResponse implements HttpCalloutMock {

    global HttpResponse respond(HttpRequest request) {
        CalloutException callException = (CalloutException)CalloutException.class.newInstance();
        callException.setMessage('Unauthorized endpoint, please check Setup->Security->Remote site settings.');
        System.assertNotEquals(null, callException);
        System.assertEquals('Unauthorized endpoint, please check Setup->Security->Remote site settings.', callException.getMessage());
        throw callException;
    }
}