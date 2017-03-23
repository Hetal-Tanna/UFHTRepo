/**
 * Class Name:       ViewDataServiceTest 
 * @description:     Class to test ViewDataService class for web service
 * @author: 
 * @date(mm-dd-yy):  07-04-2016
 * @revised:   
 */
@isTest
public class ViewDataServiceTest {
    
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
        
        Test.setMock( HttpCalloutMock.class, new MockHttpResponseViewDataService () );
        
        Http httpInstance = new Http();        
        HttpRequest request = new HttpRequest();
        
        request.setEndpoint( '/services/apexrest/UFHT/getRecordsForAnSelectedObject'); 
        request.setMethod('POST');
        request.setBody('{"selectedObjectId":"'+objId+'",'
                        + '"startDateStr":"'+strDay+'/'+strMonth+'/'+strYear+'",'
                        +'"endDateStr":"'+strDay+'/'+strMonth+'/'+strYear+'",'
                        +'"userFlag":"true",'
                        +'"offSetStr":"0"'
                        +'}');
         
        HttpResponse response = httpInstance.send(request);
        
        Test.stopTest();
        
        list<object> listJsonResponse = new list<object>();
        listJsonResponse = (list<object>) JSON.deserializeUntyped(response.getBody());        
        
        system.assertEquals(listJsonResponse.size(), 2);
    }
    
    /**
     * @author 
     * @description    Method to test webservice for attachments that contains ED in its name
     * @param          NA
     * @return         NA
     * @date(mm-dd-yy) 07-04-2016
    */ 
    @isTest
    static void getRecordsForASelectedObjectWithAttachmentThatContainsEDInItsName() {
    
        Id objId = [Select Id From UFHT__Ultra_Track_Container__c Where UFHT__Object_Name__c =:'Account' Limit 1][0].id;
        Id accountId = [Select Id From Account Limit 1][0].Id;
        
        list<Attachment> attachmentList = new list<Attachment>();  
        list<HistoryWrapper> historyList = new list<HistoryWrapper>();
        
        historyList.addAll(TestDataFactory.getHistoryList(new list<string> {'a@b.com','c@b.com'},
                                                          new list<string> {'c@b.com','a@b.com'},
                                                          string.ValueOf(accountId),
                                                          UserInfo.getUserId(),
                                                          new list<DateTime> {system.now(),
                                                                             system.now()}
                                                         ));
                           
        string attachmentBodyForAccount = '{"Name":' + System.JSON.serialize(historyList); 
        attachmentBodyForAccount += '},"Email__c":{[]}';
        
        DateTime todayDate = Date.today();
        
        String strAttachmentName = 'UltraHistoryDataAccountSD'
                                   + DateTime.newInstance(todayDate.year(), todayDate.month(), todayDate.day()).format('MM/dd/YYYY')
                                   + 'ED' 
                                   + DateTime.newInstance(todayDate.year(), todayDate.month(), todayDate.day()).format('MM/dd/YYYY')
                                   +'.txt';
        
        attachmentList.addAll(TestDataFactory.getAttachementList(new list<string> {strAttachmentName},
                                                                 new list<blob> {blob.valueOf(attachmentBodyForAccount)},
                                                                 new list<Id> {objId}
                                                                ));
        insert attachmentList;
        
        Test.startTest();
        
        String strTodaysDate =  DateTime.newInstance(System.today().year(),
                                                     System.today().month(),
                                                     System.today().day()).format('DD/MM/YYYY');
        String strDay = String.valueOf(System.today().day());
        String strMonth = String.valueOf(System.today().month());
        String strYear = String.valueOf(System.today().year());
        
        Test.setMock( HttpCalloutMock.class, new MockHttpResponseViewDataService () );
        
        Http httpInstance = new Http();        
        HttpRequest request = new HttpRequest();
        
        request.setEndpoint( '/services/apexrest/UFHT/getRecordsForAnSelectedObject'); 
        request.setMethod('POST');
        request.setBody('{"selectedObjectId":"'+objId+'",'
                        + '"startDateStr":"'+strDay+'/'+strMonth+'/'+strYear+'",' 
                        +'"endDateStr":"'+strDay+'/'+strMonth+'/'+strYear+'",'
                        +'"userFlag":"true",'
                        +'"offSetStr":"0"'
                        +'}');
         
        HttpResponse response = httpInstance.send(request);
        
        Test.stopTest();
        
        list<object> listJsonResponse = new list<object>();
        listJsonResponse  = (list<object>) JSON.deserializeUntyped(response.getBody());  
        
        system.assertEquals(listJsonResponse.size(), 2);
    }
    
    /**
     * @author 
     * @description    Method to test webservice, when start date passed is null
     * @param          NA
     * @return         NA
     * @date(mm-dd-yy) 07-05-2016
    */ 
    @isTest
    static void getRecordsForASelectedObjectWhenStartDateIsNull() {
    
        Id objId = [Select Id From UFHT__Ultra_Track_Container__c Where UFHT__Object_Name__c =:'Account' Limit 1][0].id;       
        
        Test.startTest();
        
        String strTodaysDate =  DateTime.newInstance(System.today().year(),
                                                     System.today().month(),
                                                     System.today().day()).format('DD/MM/YYYY');
        String strDay = String.valueOf(System.today().day());
        String strMonth = String.valueOf(System.today().month());
        String strYear = String.valueOf(System.today().year());
        
        Test.setMock( HttpCalloutMock.class, new MockHttpResponseViewDataService () );
        
        Http httpInstance = new Http();        
        HttpRequest request = new HttpRequest();
        
        request.setEndpoint( '/services/apexrest/UFHT/getRecordsForAnSelectedObject'); 
        request.setMethod('POST');
        request.setBody('{"selectedObjectId":"'+objId+'",'
                        + '"startDateStr":"",' 
                        +'"endDateStr":"'+strDay+'/'+strMonth+'/'+strYear+'",'
                        +'"userFlag":"true",'
                        +'"offSetStr":"0"'
                        +'}');
         
        HttpResponse response = httpInstance.send(request);
        
        Test.stopTest();
        
        list<object> listJsonResponse = new list<object>();
        listJsonResponse  = (list<object>) JSON.deserializeUntyped(response.getBody()); 
        
        system.assertEquals(listJsonResponse.size(), 2);
    }
    
    /**
     * @author 
     * @description    Method to test webservice, when end date passed is null
     * @param          NA
     * @return         NA
     * @date(mm-dd-yy) 07-05-2016
    */ 
    @isTest
    static void getRecordsForASelectedObjectWhenEndDateIsNull() {
    
        Id objId = [Select Id From UFHT__Ultra_Track_Container__c Where UFHT__Object_Name__c =:'Account' Limit 1][0].id;       
        
        Test.startTest();
        
        String strTodaysDate =  DateTime.newInstance(System.today().year(),
                                                     System.today().month(),
                                                     System.today().day()).format('DD/MM/YYYY');
        String strDay = String.valueOf(System.today().day());
        String strMonth = String.valueOf(System.today().month());
        String strYear = String.valueOf(System.today().year());
        
        Test.setMock( HttpCalloutMock.class, new MockHttpResponseViewDataService () );
        
        Http httpInstance = new Http();        
        HttpRequest request = new HttpRequest();
        
        request.setEndpoint( '/services/apexrest/UFHT/getRecordsForAnSelectedObject'); 
        request.setMethod('POST');
        request.setBody('{"selectedObjectId":"'+objId+'",'
                        + '"startDateStr":"'+strDay+'/'+strMonth+'/'+strYear+'",' 
                        +'"endDateStr":"",'
                        +'"userFlag":"true",'
                        +'"offSetStr":"0"'
                        +'}');
         
        HttpResponse response = httpInstance.send(request);
        
        Test.stopTest();
        
        list<object> listJsonResponse = new list<object>();
        listJsonResponse  = (list<object>) JSON.deserializeUntyped(response.getBody()); 
        
        system.assertEquals(listJsonResponse.size(), 2);
    }
    
    /**
     * @author 
     * @description    Method to test webservice when start and end date passes are null
     * @param          NA
     * @return         NA
     * @date(mm-dd-yy) 07-05-2016
    */ 
    @isTest
    static void getRecordsForASelectedObjectWhenStartAndEndDatesAreNull() {
    
        Id objId = [Select Id From UFHT__Ultra_Track_Container__c Where UFHT__Object_Name__c =:'Account' Limit 1][0].id;       
        
        Test.startTest();
        
        String strTodaysDate =  DateTime.newInstance(System.today().year(),
                                                     System.today().month(),
                                                     System.today().day()).format('DD/MM/YYYY');
        String strDay = String.valueOf(System.today().day());
        String strMonth = String.valueOf(System.today().month());
        String strYear = String.valueOf(System.today().year());
        
        Test.setMock( HttpCalloutMock.class, new MockHttpResponseViewDataService () );
        
        Http httpInstance = new Http();        
        HttpRequest request = new HttpRequest();
        
        request.setEndpoint( '/services/apexrest/UFHT/getRecordsForAnSelectedObject'); 
        request.setMethod('POST');
        request.setBody('{"selectedObjectId":"'+objId+'",'
                        + '"startDateStr":"",' 
                        +'"endDateStr":"",'
                        +'"userFlag":"true",'
                        +'"offSetStr":"0"'
                        +'}');
         
        HttpResponse response = httpInstance.send(request);
        
        Test.stopTest();
        
        list<object> listJsonResponse = new list<object>();
        listJsonResponse  = (list<object>) JSON.deserializeUntyped(response.getBody());
        
        system.assertEquals(listJsonResponse.size(), 2);
    }
    
    /**
     * @author 
     * @description    Method to test webservice, when attachment contains ED in its name with ED in attachment name
     *                 less then end date passes and start date passed is null
     * @param          NA
     * @return         NA
     * @date(mm-dd-yy) 07-05-2016
    */ 
    @isTest
    static void getRecordsForASelectedObjectWhenStartDateIsNullAndEndDateIsGreaterThenEndDateOnAttachment() {
    
        Id objId = [Select Id From UFHT__Ultra_Track_Container__c Where UFHT__Object_Name__c =:'Account' Limit 1][0].id;
        Id accountId = [Select Id From Account Limit 1][0].Id;
        
        list<Attachment> attachmentList = new list<Attachment>();  
        list<HistoryWrapper> historyList = new list<HistoryWrapper>();
        
        historyList.addAll(TestDataFactory.getHistoryList(new list<string> {'a@b.com','c@b.com'},
                                                          new list<string> {'c@b.com','a@b.com'},
                                                          string.ValueOf(accountId),
                                                          UserInfo.getUserId(),
                                                          new list<DateTime> {system.now(),
                                                                             system.now()}
                                                         ));
                           
        string attachmentBodyForAccount = '{"Name":' + System.JSON.serialize(historyList); 
        attachmentBodyForAccount += '},"Email__c":{[]}';
        
        DateTime todayDate = Date.today();
        
        String strAttachmentName = 'UltraHistoryDataAccountSD'
                                   + DateTime.newInstance(todayDate.year(), todayDate.month(), todayDate.day()).format('MM/dd/YYYY')
                                   + 'ED' 
                                   + (DateTime.newInstance(todayDate.year(), todayDate.month(), todayDate.day())-1).format('MM/dd/YYYY')
                                   +'.txt';
        
        attachmentList.addAll(TestDataFactory.getAttachementList(new list<string> {strAttachmentName},
                                                                 new list<blob> {blob.valueOf(attachmentBodyForAccount)},
                                                                 new list<Id> {objId}
                                                                ));
        insert attachmentList;   
        
        Test.startTest();
        
        String strTodaysDate =  DateTime.newInstance(System.today().year(),
                                                     System.today().month(),
                                                     System.today().day()).format('DD/MM/YYYY');
        String strDay = String.valueOf(System.today().day());
        String strMonth = String.valueOf(System.today().month());
        String strYear = String.valueOf(System.today().year());
        
        Test.setMock( HttpCalloutMock.class, new MockHttpResponseViewDataService () );
        
        Http httpInstance = new Http();        
        HttpRequest request = new HttpRequest();
        
        request.setEndpoint( '/services/apexrest/UFHT/getRecordsForAnSelectedObject'); 
        request.setMethod('POST');
        request.setBody('{"selectedObjectId":"'+objId+'",'
                        + '"startDateStr":"",' 
                        +'"endDateStr":"'+strDay+'/'+strMonth+'/'+strYear+'",'
                        +'"userFlag":"true",'
                        +'"offSetStr":"0"'
                        +'}');
         
        HttpResponse response = httpInstance.send(request);
        
        Test.stopTest();
        
        list<object> listJsonResponse = new list<object>();
        listJsonResponse  = (list<object>) JSON.deserializeUntyped(response.getBody());
        
        system.assertEquals(listJsonResponse.size(), 2);
    }
    
    /**
     * @author 
     * @description    Method to test webservice, when attachment contains SD in its name with SD greater than 
     *                 Start Date passes as parameter, and End date passes is null
     * @param          NA
     * @return         NA
     * @date(mm-dd-yy) 07-05-2016
    */ 
    @isTest
    static void getRecordsForASelectedObjectWhenEndDatesIsNullAndStartDateIsLessThenStartDateOnAttachment() {
    
        Id objId = [Select Id From UFHT__Ultra_Track_Container__c Where UFHT__Object_Name__c =:'Account' Limit 1][0].id;
        Id accountId = [Select Id From Account Limit 1][0].Id;
        
        list<Attachment> attachmentList = new list<Attachment>();  
        list<HistoryWrapper> historyList = new list<HistoryWrapper>();
        
        historyList.addAll(TestDataFactory.getHistoryList(new list<string> {'a@b.com','c@b.com'},
                                                          new list<string> {'c@b.com','a@b.com'},
                                                          string.ValueOf(accountId),
                                                          UserInfo.getUserId(),
                                                          new list<DateTime> {system.now(),
                                                                             system.now()}
                                                         ));
                           
        string attachmentBodyForAccount = '{"Name":' + System.JSON.serialize(historyList); 
        attachmentBodyForAccount += '},"Email__c":{[]}';
        
        DateTime todayDate = Date.today();
        
        String strAttachmentName = 'UltraHistoryDataAccountSD'
                                   + (DateTime.newInstance(todayDate.year(), todayDate.month(), todayDate.day())+1).format('MM/dd/YYYY')
                                   + 'ED' 
                                   + (DateTime.newInstance(todayDate.year(), todayDate.month(), todayDate.day())+1).format('MM/dd/YYYY')
                                   +'.txt';
        
        attachmentList.addAll(TestDataFactory.getAttachementList(new list<string> {strAttachmentName},
                                                                 new list<blob> {blob.valueOf(attachmentBodyForAccount)},
                                                                 new list<Id> {objId}
                                                                ));
        insert attachmentList;   
        
        Test.startTest();
        
        String strTodaysDate =  DateTime.newInstance(System.today().year(),
                                                     System.today().month(),
                                                     System.today().day()).format('DD/MM/YYYY');
        String strDay = String.valueOf(System.today().day());
        String strMonth = String.valueOf(System.today().month());
        String strYear = String.valueOf(System.today().year());
        
        Test.setMock( HttpCalloutMock.class, new MockHttpResponseViewDataService () );
        
        Http httpInstance = new Http();        
        HttpRequest request = new HttpRequest();
        
        request.setEndpoint( '/services/apexrest/UFHT/getRecordsForAnSelectedObject'); 
        request.setMethod('POST');
        request.setBody('{"selectedObjectId":"'+objId+'",'
                        + '"startDateStr":"'+strDay+'/'+strMonth+'/'+strYear+'",' 
                        +'"endDateStr":"",'
                        +'"userFlag":"true",'
                        +'"offSetStr":"0"'
                        +'}');
         
        HttpResponse response = httpInstance.send(request);
        
        Test.stopTest();
        
        list<object> listJsonResponse = new list<object>();
        listJsonResponse  = (list<object>) JSON.deserializeUntyped(response.getBody());
        
        system.assertEquals(listJsonResponse.size(), 2);
    }
    
    /**
     * @author 
     * @description    Method to test webservice when tracked fields contain more than one field.
     * @param          NA
     * @return         NA
     * @date(mm-dd-yy) 07-05-2016
    */ 
    @isTest
    static void getRecordsForASelectedObjectWhenTrackFieldContainsMoreThanOneField() {
    
        UFHT__Ultra_Track_Container__c objUltrTrackContainer = [Select Id 
                                                                From   UFHT__Ultra_Track_Container__c 
                                                                Where  UFHT__Object_Name__c =:'Account' 
                                                                Limit  1];
        
        // Add more than one field in the tracked fields and update the record
        objUltrTrackContainer.UFHT__Tracked_Fields__c = 'Name, Email';
        update objUltrTrackContainer;
        
        Test.startTest();
        
        String strTodaysDate =  DateTime.newInstance(System.today().year(),
                                                     System.today().month(),
                                                     System.today().day()).format('DD/MM/YYYY');
        String strDay = String.valueOf(System.today().day());
        String strMonth = String.valueOf(System.today().month());
        String strYear = String.valueOf(System.today().year());
        
        Test.setMock( HttpCalloutMock.class, new MockHttpResponseViewDataService () );
        
        Http httpInstance = new Http();        
        HttpRequest request = new HttpRequest();
        
        request.setEndpoint( '/services/apexrest/UFHT/getRecordsForAnSelectedObject'); 
        request.setMethod('POST');
        request.setBody('{"selectedObjectId":"'+objUltrTrackContainer.Id+'",'
                        + '"startDateStr":"'+strDay+'/'+strMonth+'/'+strYear+'",' 
                        +'"endDateStr":"'+strDay+'/'+strMonth+'/'+strYear+'",' 
                        +'"userFlag":"true",'
                        +'"offSetStr":"0"'
                        +'}');
         
        HttpResponse response = httpInstance.send(request);
        
        Test.stopTest();
        
        list<object> listJsonResponse = new list<object>();
        listJsonResponse  = (list<object>) JSON.deserializeUntyped(response.getBody());
        
        system.assertEquals(listJsonResponse.size(), 2);
    }
    
    /**
     * @author 
     * @description    Method to test webservice when object id in parameter is null
     * @param          NA
     * @return         NA
     * @date(mm-dd-yy) 07-05-2016
    */ 
    @isTest
    static void getRecordsForASelectedObjectWhenObjectIdPassesIsNull() {
        
        Test.startTest();
        
        String strTodaysDate =  DateTime.newInstance(System.today().year(),
                                                     System.today().month(),
                                                     System.today().day()).format('DD/MM/YYYY');
        String strDay = String.valueOf(System.today().day());
        String strMonth = String.valueOf(System.today().month());
        String strYear = String.valueOf(System.today().year());
        
        Test.setMock( HttpCalloutMock.class, new MockHttpResponseViewDataService () );
        
        Http httpInstance = new Http();        
        HttpRequest request = new HttpRequest();
        
        request.setEndpoint( '/services/apexrest/UFHT/getRecordsForAnSelectedObject'); 
        request.setMethod('POST');
        request.setBody('{"selectedObjectId":null,'
                        + '"startDateStr":"'+strDay+'/'+strMonth+'/'+strYear+'",' 
                        +'"endDateStr":"'+strDay+'/'+strMonth+'/'+strYear+'",' 
                        +'"userFlag":"true",'
                        +'"offSetStr":"0"'
                        +'}');
         
        HttpResponse response = httpInstance.send(request);
        
        Test.stopTest();
        
        system.assertEquals('null', response.getBody());
    }
    
    /**
     * @author 
     * @description    Method to test webservice when selectedObjectId, startDateStr and endDateStr are null
     * @param          NA
     * @return         NA
     * @date(mm-dd-yy) 07-05-2016
    */ 
    @isTest
    static void getRecordsForASelectedObjectWhenSomeParametersAreNull() {
        
        Test.startTest();
        
        String strTodaysDate =  DateTime.newInstance(System.today().year(),
                                                     System.today().month(),
                                                     System.today().day()).format('DD/MM/YYYY');
        String strDay = String.valueOf(System.today().day());
        String strMonth = String.valueOf(System.today().month());
        String strYear = String.valueOf(System.today().year());
        
        Test.setMock( HttpCalloutMock.class, new MockHttpResponseViewDataService () );
        
        Http httpInstance = new Http();        
        HttpRequest request = new HttpRequest();
        
        request.setEndpoint( '/services/apexrest/UFHT/getRecordsForAnSelectedObject'); 
        request.setMethod('POST');
        request.setBody('{"selectedObjectId":null,'
                        + '"startDateStr":null,' 
                        +'"endDateStr":null,' 
                        +'"userFlag":"false",'
                        +'"offSetStr":"0"'
                        +'}');
         
        HttpResponse response = httpInstance.send(request);
         
        Test.stopTest();
        
        system.assertEquals('null', response.getBody());
    }
}