@isTest
private class DataProviderForViewDataTest {

    /**
     * @author 
     * @description    Method to set up test data to be used ahead in test methods to test the functionality
     * @param          NA
     * @return         NA
     * @date(mm-dd-yy) 07-04-2016
    */ 
    @testSetup 
    static void setupTestData() {
        
        list<Ultra_Track_Container__c> ultraTrackContainerList = new list<Ultra_Track_Container__c>();
        list<Attachment> attachmentList = new list<Attachment>();
        list<HistoryWrapper> historyList = new list<HistoryWrapper>();
        map<string,List<HistoryWrapper>> ultraTrackWrapperMap = new map<string,List<HistoryWrapper>>();
        
        Account accountObj = TestDataFactory.getAccount('TestAccount');
        insert accountObj;
        
        string result;
        Date todayDate = Date.today();
        ultraTrackContainerList.addAll(TestDataFactory.getUltraTrackContainerList(new list<string> {'Account','Opportunity'},
                                                                                  new list<string> {'Account','Opportunity'},
                                                                                  new list<boolean> {true, false},
                                                                                  new list<string> {'Name', 'Name'}
                                                                                  )
                                      );
        
        insert ultraTrackContainerList;
        
        historyList.addAll(TestDataFactory.getHistoryList(new list<string> {'a@b.com','c@b.com'},
                                                          new list<string> {'c@b.com','a@b.com'},
                                                          string.ValueOf(accountObj.Id),
                                                          UserInfo.getUserId(),
                                                          new list<DateTime> {system.now(),
                                                                             system.now()}
                                                         )
                           );
                           
        string attachmentBodyForAccount = '{"Name":' + System.JSON.serialize(historyList); 
        attachmentBodyForAccount += '},"Email__c":{[]}';
        string attachmentBodyForOpportunity = '{"Name":{[]}}';
        
        attachmentList.addAll(TestDataFactory.getAttachementList(new list<string> {'UltraHistoryDataAccountSD'+ 
                                                                                   DateTime.newInstance(todayDate.year(),
                                                                                                todayDate.month(),
                                                                                                todayDate.day()).format('MM/dd/YYYY'),
                                                                                   'UltraHistoryDataOpportunity'},
                                                                 new list<blob> {blob.valueOf(attachmentBodyForAccount),
                                                                                 blob.valueOf(attachmentBodyForOpportunity)},
                                                                 new list<Id> {ultraTrackContainerList[0].Id,
                                                                               ultraTrackContainerList[1].Id}
                                                                )
                             );
        insert attachmentList;
    }
    
    /**
     * @author 
     * @description    Method to test normal run of the call out for todays date
     * @param          NA
     * @return         NA
     * @date(mm-dd-yy) 07-04-2016
    */ 
    @isTest
    static void getRecordsForASelectedObjectWhenProperValuesAreProvided() {
        
        Test.startTest();
        
        Id objId = [Select Id From UFHT__Ultra_Track_Container__c   Limit 1][0].id;
        
        String strTodaysDate =  DateTime.newInstance(System.today().year(),
                                                     System.today().month(),
                                                     System.today().day()).format('DD/MM/YYYY');
        String strDay = String.valueOf(System.today().day());
        String strMonth = String.valueOf(System.today().month());
        String strYear = String.valueOf(System.today().year());

        DataProviderForViewData.getAttachmentCount(
            String.valueOf(objId),
            (strDay+'/'+strMonth+'/'+strYear),
            (strDay+'/'+strMonth+'/'+strYear)
        );

        DataProviderForViewData.fetchAttachments(
            String.valueOf(objId),
            (strDay+'/'+strMonth+'/'+strYear),
            (strDay+'/'+strMonth+'/'+strYear),
            true,
            '0');
        
        Test.stopTest();
        
        /*list<object> listJsonResponse = new list<object>();
        listJsonResponse = (list<object>) JSON.deserializeUntyped(response.getBody());        
        
        system.assertEquals(listJsonResponse.size(), 2);*/
    }
}