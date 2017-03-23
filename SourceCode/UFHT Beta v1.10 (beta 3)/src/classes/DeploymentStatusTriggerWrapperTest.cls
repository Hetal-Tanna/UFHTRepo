/**
  * @Class Name: DeploymentStatusTriggerWrapper
  * @Description: This class contains unit tests for DeploymentStatusTriggerWrapper.cls
  * ====================================================================================================================
  *       Version   | Date        | Author             | Comments
  * --------------------------------------------------------------------------------------------------------------------
  *       1.0       | 07/02/2017  | Eternus Solutions  | 1. Created test class for DeploymentStatusTriggerWrapper.
  * ====================================================================================================================
  **/
@isTest
private class DeploymentStatusTriggerWrapperTest {
	
	 /**
      * @Author: Eternus Solutions
      * @Description: Test method to check assert for positive and negative scenario of DeploymentStatusTriggerWrapper method
      * @Expected Result: Method should check expected results with actual result
      * @Date: 07/02/2017
      **/
    static testMethod void DeploymentStatusTriggerWrapperCase1() {
    	Boolean isEnablePollar = true;
        Integer progCounter = 25;
        Id asyncId = null;
        Boolean isRemoteSitePresent = true;

        List<PageMessageWrapper> pageMessageList = new List<PageMessageWrapper>();
        pageMessageList = TestDataFactory.getPageMesssageWrapperList(new list<String> {'Error message1', 'Info Message 2'},
                                                     new list<String> {'Error', 'Info'});
        
        test.startTest();
        DeploymentStatusTriggerWrapper objStatus = new DeploymentStatusTriggerWrapper(isEnablePollar,progCounter,
                                                   asyncId,isRemoteSitePresent,pageMessageList);
        test.stopTest();
        System.assert(pageMessageList.size() > 0);
        System.assertEquals(isEnablePollar,objStatus.isEnablePollar);
        System.assertEquals(progCounter,objStatus.progCounter);
        System.assertEquals(asyncId,objStatus.asyncId);
        System.assertEquals(isRemoteSitePresent,objStatus.isRemoteSiteSettings);
        System.assertEquals(pageMessageList,objStatus.lstPageMessagesWrapper);
        
    }
}