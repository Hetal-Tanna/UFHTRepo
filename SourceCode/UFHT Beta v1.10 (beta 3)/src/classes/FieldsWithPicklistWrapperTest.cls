/**
  * @Class Name: FieldsWithPicklistWrapperTest
  * @Description: This class contains unit tests for FieldsWithPicklistWrapper.cls
  * ====================================================================================================================
  *       Version   | Date        | Author             | Comments
  * -------------------------------------------------------------------------------------------------------------------
  *       1.0       | 2/01/2017  | Eternus Solutions  | 1. Created the Test Class for FieldsWithPicklistWrapper
  * ====================================================================================================================
  **/
@isTest
private class FieldsWithPicklistWrapperTest {

    
     /**
      * @Author: Eternus Solutions
      * @Description: Test Method to verify the functionality for fetching attachments of selected object
      *               with following scenario: Passed all parameter values as null.
      * @Expected Result: Method should check jsonResult should return empty string.
      * @Date: 22/07/2016
      **/
    static testMethod void FieldsWithPicklistWrapperValidCase() {
        list<UltraTrackWrapper> ultraTrackList = new list<UltraTrackWrapper>();
        Boolean showOWDPicklist;
        list<Ultra_Track_Container__c> ultraTrackContainerList = new list<Ultra_Track_Container__c>();
        List<PageMessageWrapper> pageMessageList = new List<PageMessageWrapper>();
        //get ultra track wrapper 
        ultraTrackList = TestDataFactory.getUltraTrackList(
                                            new list<String> {'Name', 'Phone', 'Email'},
                                            new list<String> {'Name', 'Phone', 'Email'},
                                            new List<String> {'String', 'Phone', 'Email'});
                                            
                                            
                                            
                                            
        ultraTrackContainerList = TestDataFactory.getUltraTrackContainerList(
                                         new list<String> {'Account', 'Sharing_Purpose__c'},
                                         new list<String> {'Account (Account)', 'Sharing Purpose (Sharing_Purpose__c)'},
                                         new list<Boolean> {true, true},
                                         new list<String> {'Name:1', 'Name:1'} );
        
        pageMessageList = TestDataFactory.getPageMesssageWrapperList(new list<String> {'Error message1', 'Info Message 2'},
                                                     new list<String> {'Error', 'Info'});
        
        //Insert Account object data
        Account accountObj = TestDataFactory.getAccount('TestAccount');
        insert accountObj;

        //Insert Sharing Purpose object data
        Sharing_Purpose__c shareObj = TestDataFactory.getSharing_Purpose('test1');
        insert shareObj;

        //Insert ultra track container data
        Date todayDate = Date.today();
        ultraTrackContainerList = TestDataFactory.getUltraTrackContainerList(new list<String> {'Account', 'Sharing_Purpose__c', 'Opportunity'},
                                                                                 new list<String> {'Account (Account)', 'Sharing Purpose (Sharing_Purpose__c)', 'Opportunity (Opportunity)'},
                                                                                 new list<Boolean> {true, true, false},
                                                                                 //new list<String> {'Name', 'Name', 'Name'},
                                                                                 new list<String> {'Name:1', 'Name:1', 'Name:0'}
                                                                             );

        insert ultraTrackContainerList;

        Test.startTest();
            FieldsWithPicklistWrapper fieldwrpperObj = new FieldsWithPicklistWrapper(ultraTrackList, true, ultraTrackContainerList[0], pageMessageList);
        Test.stopTest();
        System.assert(ultraTrackList.size() > 0);
        System.assert(ultraTrackContainerList.size() > 0);
        System.assert(pageMessageList.size() > 0);
    }
}