/**
 * Class Name:       ViewDataNumberOfAttachmentWebSeriveTest 
 * @description:     Class to test ViewDataNumberOfAttachmentWebSerive class for web service
 * @author: 
 * @date(mm-dd-yy):  07-01-2016
 * @revised:   
 */
@isTest
private class ViewDataNumberOfAttachmentWebSeriveTest {
    
    /**
     * @author 
     * @description    Method to set up test data to be used ahead in test methods to test the functionality
     * @param          NA
     * @return         NA
     * @date(mm-dd-yy) 07-01-2016
    */ 
    @testSetup 
    static void setupTestData() {
        
        List<Ultra_Track_Container__c> listUltraTrackContainer = new list<Ultra_Track_Container__c>();
        list<Attachment> listAttachment = new list<Attachment>();
        list<HistoryWrapper> listHistory = new list<HistoryWrapper>();
        
        Account objAccount = TestDataFactory.getAccount('TestAccount');
        insert objAccount;
        
        listUltraTrackContainer.addAll(
            TestDataFactory.getUltraTrackContainerList(new list<string> {'Account','Opportunity'},
                                                       new list<string> {'Account','Opportunity'},
                                                       new list<boolean> {true, false},
                                                       new list<string> {'Email,Name', 'Name'}
                                                      ));
        insert listUltraTrackContainer;
        
        listHistory.addAll(TestDataFactory.getHistoryList(new list<string> {'a@b.com','c@b.com'},
                                                          new list<string> {'c@b.com','a@b.com'},
                                                          string.ValueOf(objAccount.Id),
                                                          UserInfo.getUserId(),
                                                          new list<DateTime> {system.now(),
                                                              system.now()}
                                                         ));
        
        string attachmentBodyForAccount = '{"Email":' + System.JSON.serialize(listHistory); 
        attachmentBodyForAccount += '},"Name":{[]}';
        string attachmentBodyForOpportunity = '{"Name":{[]}}';
        
        listAttachment.addAll(TestDataFactory.getAttachementList(new list<string> {'UltraHistoryDataAccount',
                                                                                   'UltraHistoryDataOpportunity'},
                                                                 new list<blob> {blob.valueOf(attachmentBodyForAccount),
                                                                                 blob.valueOf(attachmentBodyForOpportunity)},
                                                                 new list<Id> {listUltraTrackContainer[0].Id,
                                                                               listUltraTrackContainer[1].Id}
                                                                ));
        insert listAttachment;
        
    }
    
    /**
     * @author 
     * @description    Method to test response of webservice when we pass proper Ultra Track Container Id
     * @param          NA
     * @return         NA
     * @date(mm-dd-yy) 07-01-2016
    */ 
    @isTest
    static void testResponseWhenUltraTrackContacinerHasAtLeastOneAttachment(){
        
        Test.startTest();
        
        Id objId = [Select Id From UFHT__Ultra_Track_Container__c   Limit 1][0].id;
        
        Test.setMock( HttpCalloutMock.class, new MockHttpResponseTest() );
        
        Http httpInstance = new Http();        
        HttpRequest request = new HttpRequest();
        
        request.setEndpoint( '/services/apexrest/UFHT/getNumberOfAttachmentPerObject/'); 
        request.setMethod('POST');
        request.setBody('{"selectedObjectId":"'+objId+'"}');
         
        HttpResponse response = httpInstance.send(request);
        
        Test.stopTest();
        
        Map<String, Object> mapParameterAndResult = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
        
        System.assertEquals(1,Integer.ValueOf(mapParameterAndResult.get('0')));
    }
    
    /**
     * @author 
     * @description    Method to test response of webservice when we pass blank value
     * @param          NA
     * @return         NA
     * @date(mm-dd-yy) 07-01-2016
    */
    @isTest
    static void testResponseWhenIdPassesIsBlank(){
        
        Test.startTest();
        
        Test.setMock( HttpCalloutMock.class, new MockHttpResponseTest() );
        
        Http httpInstance = new Http();        
        HttpRequest request = new HttpRequest();
        
        request.setEndpoint( 'services/apexrest/UFHT/getNumberOfAttachmentPerObject/'); 
        request.setMethod('POST');
        request.setBody('{"selectedObjectId":""}');
         
        HttpResponse response = httpInstance.send(request);
        
        Test.stopTest();
        
        Map<String, Object> mapParameterAndResult = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
        
        System.assertEquals(0,Integer.ValueOf(mapParameterAndResult.get('0')));
    }
    
    /**
     * @author 
     * @description    Method to test response of webservice when we pass null value
     * @param          NA
     * @return         NA
     * @date(mm-dd-yy) 07-01-2016
    */
    @isTest
    static void testResponseWhenIdPassesIsNull(){
        
        Test.startTest();
        
        Test.setMock( HttpCalloutMock.class, new MockHttpResponseTest() );
        
        Http httpInstance = new Http();        
        HttpRequest request = new HttpRequest();
        
        request.setEndpoint( 'services/apexrest/UFHT/getNumberOfAttachmentPerObject/'); 
        request.setMethod('POST');
        request.setBody('{"selectedObjectId":"null"}');
         
        HttpResponse response = httpInstance.send(request);
        
        Test.stopTest();
        
        Map<String, Object> mapParameterAndResult = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
        
        System.assertEquals(0,Integer.ValueOf(mapParameterAndResult.get('0')));
    }
    
    /**
     * @author 
     * @description    Method to test response of webservice when we pass Id other than that of Ulta Track Container's record
     * @param          NA
     * @return         NA
     * @date(mm-dd-yy) 07-01-2016
    */
    @isTest
    static void testResponseWhenIdPassesIsOtherThanUltraTrackContainer(){
        
        Account objAccount = new Account(Name='Test Account Name');
        insert objAccount;  
        
        Test.startTest();
        
        Test.setMock( HttpCalloutMock.class, new MockHttpResponseTest() );
        
        Http httpInstance = new Http();        
        HttpRequest request = new HttpRequest();
        
        request.setEndpoint( '/services/apexrest/UFHT/getNumberOfAttachmentPerObject/'); 
        request.setMethod('POST');
        request.setBody('{"selectedObjectId":"'+objAccount.Id+'"}');
         
        HttpResponse response = httpInstance.send(request);
        
        Test.stopTest();
        
        Map<String, Object> mapParameterAndResult = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
        
        System.assertEquals(0,Integer.ValueOf(mapParameterAndResult.get('0')));
    }
}