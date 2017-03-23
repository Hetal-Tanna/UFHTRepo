/**
  * @Class Name: UserInfoWrapperTest
  * @Description: This class contains unit tests for DisplayHistoryWrapper.cls
  * ====================================================================================================================
  *       Version   | Date        | Author             | Comments
  * --------------------------------------------------------------------------------------------------------------------
  *       1.0       | 24/01/2017  | Eternus Solutions  | 1. Created test class for UserInfoWrapper.
  * ====================================================================================================================
  **/
@isTest
private class UserInfoWrapperTest {

    static testMethod void userInfoWrapperConstructorTestCase() {
        
        List<UserInfoWrapper> userAssertList = new List<UserInfoWrapper>();
        
        Test.startTest();
        for(User userObj : [SELECT id, Name FROM User]) {
            userAssertList.add(new UserInfoWrapper(userObj.Id, userObj.Name));
        }
        Test.stopTest();
        
        System.assertNotEquals(null, userAssertList);
    }
}