/**
  * @Class Name: InvalidProtocolResponse
  * @Description: The class provides mock response for invalid protocol.
  * ===================================================================================================
  *    Version   | Date        | Author             | Comments
  * ---------------------------------------------------------------------------------------------------
  *    1.0       | 27/07/2016  | Eternus Solutions  | 1. Created the respond method for dummy response.
  * ===================================================================================================
  **/

/**
  * @Author: Eternus Solutions
  * @Description: Implemented interface method to provide dummy mock response for invalid protocol
  * @Param: HttpRequest param to hold the Request.
  * @Return: HttpResponse.
  * @Date: 27/07/2016
  **/
@isTest
global class InvalidProtocolResponse implements HttpCalloutMock {

    global HttpResponse respond(HttpRequest request) {
        CalloutException callException = (CalloutException)CalloutException.class.newInstance();
        callException.setMessage('Invalid protocol.');
        System.assertNotEquals(null, callException);
        System.assertEquals('Invalid protocol.', callException.getMessage());
        throw callException;
    }
}