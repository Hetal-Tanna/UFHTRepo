/**
  * @Class Name: TestUtil
  * @Description: This is used to check asserts in all the test classes
  * ====================================================================================================================
  *       Version   | Date        | Author             | Comments
  * --------------------------------------------------------------------------------------------------------------------
  *       1.0       | 10/08/2016  | Eternus Solutions   | 1. Created Class to check asserts in all test classes
  * ====================================================================================================================
  **/
@isTest
global class TestUtil {

    /**
      * @Author: Eternus Solutions
      * @Description: Test method to check assert related to HttpResponse
      * @Expected Result: Method should check expected results with actual result
      * @Date: 25/07/2016
      **/
    global static void checkAssertsForMockResponse(HttpResponse expectedResponse){
        if(expectedResponse != null) {
            System.assertNotEquals(null, expectedResponse);
            System.assertEquals(200, expectedResponse.getStatusCode());
        }
        else {
            System.assertEquals(null, expectedResponse);
        }
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test method to check assert for positive and negative scenario related to test setupData
      * @Expected Result: Method should check expected results with actual result
      * @Date: 25/07/2016
      **/
    public static void checkAssertsForSetupData(String objectName, Integer expectedListSize){

        Integer numberOfRecords = 0;
        if(String.isNotBlank(objectName) && UltraTrackUtility.sobjectMap.containsKey(objectName) 
           && UltraTrackUtility.sobjectMap.get(objectName).getDescribe().isQueryable()) {
            String queryStr = ' SELECT COUNT()' + ' FROM '+ objectName ;
            numberOfRecords = database.countQuery(queryStr);

            System.assertEquals(expectedListSize, numberOfRecords);
        }
        else {
            System.assertEquals(0, numberOfRecords);
        }
    }
}