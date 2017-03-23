/*
 * Class Name: ViewDataControllerTest
 * @Description: Test class for ViewDataController class.
  ============================================================================================
        Version   | Date        | Author              | Comments
    ------------------------------------------------------------------------------------------
        1.0       | 29-2-2016    | Eternus Solution   | Test Cases for getObjects, getshowTrackHistory
                                                      | getRendered methods.
   ===========================================================================================
 */
@isTest
private class ViewDataControllerTest {
    
    /** 
     * @author Eternus Solution
     * @description: getObjects test case
     *               Two object having tracking enabled.
     * Expected Result: Method should return objects who has tracking enabled.
     * @date: 29-02-2016
     */ 
   /* static testMethod void getObjectsTestCase1() {
        
        list<Ultra_Track_Container__c> ultraTrackContainerList = new list<Ultra_Track_Container__c>();
        
        PageReference pageRef = Page.ViewData;
        Test.setCurrentPage(pageRef);
        
        ultraTrackContainerList.addAll(TestDataFactory.getUltraTrackContainerList(new list<string> {'Work__c','Opportunity'},
                                                                                  new list<string> {'Work','Opportunity'},
                                                                                  new list<boolean> {true, true},
                                                                                  new list<string> {'Email,Name', 'Name'}
                                                                                  )
                                      );
        
        insert ultraTrackContainerList;
        ultraTrackContainerList.sort();
        
        ViewDataController viewDataObj = new ViewDataController();
        
        test.startTest();
        viewDataObj.getObjects();
        test.stopTest();
        system.debug('viewDataObj.objectSelectedoptionsList=='+viewDataObj.objectSelectedoptionsList);
        
        system.assertEquals(2, viewDataObj.objectSelectedoptionsList.size());

    }
    */
    /** 
     * @author Eternus Solution
     * @description: getObjects test case
     *               No object having tracking enabled.
     * Expected Result: Method should return no objects. 
     * @date: 29-02-2016
     */
    /*static testMethod void getObjectsTestCase2() {
        
        list<Ultra_Track_Container__c> ultraTrackContainerList = new list<Ultra_Track_Container__c>();
        
        PageReference pageRef = Page.ViewData;
        Test.setCurrentPage(pageRef);
        
        ultraTrackContainerList.addAll(TestDataFactory.getUltraTrackContainerList(new list<string> {'Work__c','Opportunity'},
                                                                                  new list<string> {'Work','Opportunity'},
                                                                                  new list<boolean> {false, false},
                                                                                  new list<string> {'Email,Name', 'Name'}
                                                                                  )
                                      );
        
        insert ultraTrackContainerList;
        
        ViewDataController viewDataObj = new ViewDataController();
        
        test.startTest();
        viewDataObj.getObjects();
        test.stopTest();
        
        system.assertEquals(0, viewDataObj.objectSelectedoptionsList.size());

    }
    */
    /** 
     * @author Eternus Solution
     * @description: getObjects test case
     *               one object having tracking enabled and one object with no tracking enabled.
     * Expected Result: Method should return objects who has tracking enabled.
     * @date: 29-02-2016
     */
   /* static testMethod void getObjectsTestCase3() {
        
        list<Ultra_Track_Container__c> ultraTrackContainerList = new list<Ultra_Track_Container__c>();
        
        PageReference pageRef = Page.ViewData;
        Test.setCurrentPage(pageRef);
        
        ultraTrackContainerList.addAll(TestDataFactory.getUltraTrackContainerList(new list<string> {'Work__c','Opportunity'},
                                                                                  new list<string> {'Work','Opportunity'},
                                                                                  new list<boolean> {true, false},
                                                                                  new list<string> {'Email,Name', 'Name'}
                                                                                  )
                                      );
        
        insert ultraTrackContainerList;
        
        ViewDataController viewDataObj = new ViewDataController();
        
        test.startTest();
        viewDataObj.getObjects();
        test.stopTest();
        
        system.assertEquals(1, viewDataObj.objectSelectedoptionsList.size());
        system.assertEquals('Work__c', viewDataObj.objectSelectedoptionsList[0].getValue());
    }
    */
     static void getUltraContainer() {
        list<Ultra_Track_Container__c> ultraTrackContainerList = new list<Ultra_Track_Container__c>();
        list<Attachment> attachmentList = new list<Attachment>();
        list<HistoryWrapper> historyList = new list<HistoryWrapper>();
        PageReference pageRef = Page.ViewData;
        Test.setCurrentPage(pageRef);
        
        Account accountObj = TestDataFactory.getAccount('TestAccount');
        insert accountObj;
        
        ultraTrackContainerList.addAll(TestDataFactory.getUltraTrackContainerList(new list<string> {'Account','Opportunity'},
                                                                                  new list<string> {'Account','Opportunity'},
                                                                                  new list<boolean> {true, false},
                                                                                  new list<string> {'Email__c,Name', 'Name'}
                                                                                  )
                                      );
        
        insert ultraTrackContainerList;
        
        historyList.addAll(TestDataFactory.getHistoryList(new list<string> {'a@b.com','c@b.com'},
                                                          new list<string> {'c@b.com','a@b.com'},
                                                          string.ValueOf(accountObj.Id),
                                                          null,
                                                          null,
                                                          new list<DateTime> {system.now(),
                                                                             system.now()},
                                                          new list<string> {'Changed from a@b.com to c@b.com', 'Changed from c@b.com to a@b.com'}
                                                         )
                           );
        string attachmentBodyForAccount = '{"Email__c":{"lstHistory":' + System.JSON.serialize(historyList); 
        attachmentBodyForAccount += ',"fieldLabel":"Email","fieldApiName":"Email__c"},"Name":{"lstHistory":[],"fieldLabel":"details","fieldApiName":"Name"}}';
        string attachmentBodyForOpportunity = '{"Name":{"lstHistory":[],"fieldLabel":"details","fieldApiName":"Name"}}';
        system.debug('DDDDD'+attachmentBodyForAccount);
        attachmentList.addAll(TestDataFactory.getAttachementList(new list<string> {'UltraHistoryDataAccount',
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
     * @author Eternus Solution
     * @description: getshowTrackHistoryData test case
     *               No History records present for selected object.
     *               startDate and endDate is null.
     * Expected Result: Method should return empty map of recordVsHiatoryRecord.
     * @date: 29-02-2016
     */
    static testMethod void getshowTrackHistoryDataTestCase1() {
        
        list<Ultra_Track_Container__c> ultraTrackContainerList = new list<Ultra_Track_Container__c>();
        list<Attachment> attachmentList = new list<Attachment>();
        
        PageReference pageRef = Page.ViewData;
        Test.setCurrentPage(pageRef);
        
        ultraTrackContainerList.addAll(TestDataFactory.getUltraTrackContainerList(new list<string> {'Account','Opportunity'},
                                                                                  new list<string> {'Account','Opportunity'},
                                                                                  new list<boolean> {true, false},
                                                                                  new list<string> {'Email__c,Name', 'Name'}
                                                                                  )
                                      );
        
        insert ultraTrackContainerList;
        
        string attachmentBodyForAccount = '{"Email__c":{"lstHistory":[],"fieldLabel":"Email","fieldApiName":"Email__c"},"Name":{"lstHistory":[],"fieldLabel":"details","fieldApiName":"Name"}}';
        string attachmentBodyForOpportunity = '{"Name":{"lstHistory":[],"fieldLabel":"details","fieldApiName":"Name"}}';
        
        attachmentList.addAll(TestDataFactory.getAttachementList(new list<string> {'UltraHistoryDataAccount',
                                                                                   'UltraHistoryDataOpportunity'},
                                                                 new list<blob> {blob.valueOf(attachmentBodyForAccount),
                                                                                 blob.valueOf(attachmentBodyForOpportunity)},
                                                                 new list<Id> {ultraTrackContainerList[0].Id,
                                                                               ultraTrackContainerList[1].Id}
                                                                )
                             );
        insert attachmentList;
        
        ViewDataController viewDataObj = new ViewDataController();
        viewDataObj.selectedObject = 'Account';
        viewDataObj.getObjects();
        
        test.startTest();
        viewDataObj.getshowTrackHistoryData();
        test.stopTest();
        
        system.assertEquals(0, viewDataObj.IdVsAccountNameMap.size());
    }
    
    /** 
     * @author Eternus Solution
     * @description: getshowTrackHistoryData test case
     *               History records present for selected object.
     *               startDate and endDate is null.
     * Expected Result: Method should return map of recordVsHiatoryRecord.
     * @date: 29-02-2016
     */
     static testMethod void getshowTrackHistoryDataTestCase2() {
        
        list<Ultra_Track_Container__c> ultraTrackContainerList = new list<Ultra_Track_Container__c>();
        list<Attachment> attachmentList = new list<Attachment>();
        list<HistoryWrapper> historyList = new list<HistoryWrapper>();
        
        PageReference pageRef = Page.ViewData;
        Test.setCurrentPage(pageRef);
        
        Account accountObj = TestDataFactory.getAccount('TestAccount');
        insert accountObj;
        
        ultraTrackContainerList.addAll(TestDataFactory.getUltraTrackContainerList(new list<string> {'Account','Opportunity'},
                                                                                  new list<string> {'Account','Opportunity'},
                                                                                  new list<boolean> {true, false},
                                                                                  new list<string> {'Email__c,Name', 'Name'}
                                                                                  )
                                      );
        
        insert ultraTrackContainerList;
        
        historyList.addAll(TestDataFactory.getHistoryList(new list<string> {'a@b.com','c@b.com'},
                                                          new list<string> {'c@b.com','a@b.com'},
                                                          string.ValueOf(accountObj.Id),
                                                          null,
                                                          null,
                                                          new list<DateTime> {system.now(),
                                                                             system.now()},
                                                          new list<string> {'Changed from a@b.com to c@b.com', 'Changed from c@b.com to a@b.com'}
                                                         )
                           );
        string attachmentBodyForAccount = '{"Email__c":{"lstHistory":' + System.JSON.serialize(historyList); 
        attachmentBodyForAccount += ',"fieldLabel":"Email","fieldApiName":"Email__c"},"Name":{"lstHistory":[],"fieldLabel":"details","fieldApiName":"Name"}}';
        string attachmentBodyForOpportunity = '{"Name":{"lstHistory":[],"fieldLabel":"details","fieldApiName":"Name"}}';
        system.debug('DDDDD'+attachmentBodyForAccount);
        attachmentList.addAll(TestDataFactory.getAttachementList(new list<string> {'UltraHistoryDataAccount',
                                                                                   'UltraHistoryDataOpportunity'},
                                                                 new list<blob> {blob.valueOf(attachmentBodyForAccount),
                                                                                 blob.valueOf(attachmentBodyForOpportunity)},
                                                                 new list<Id> {ultraTrackContainerList[0].Id,
                                                                               ultraTrackContainerList[1].Id}
                                                                )
                             );
        insert attachmentList;
        system.debug('attachmentList='+attachmentList);
        
        ViewDataController viewDataObj = new ViewDataController();
        viewDataObj.selectedObject = 'Account';
        viewDataObj.getObjects();
        
        test.startTest();
        viewDataObj.getshowTrackHistoryData();
        test.stopTest();
        system.assertEquals(1, viewDataObj.IdVsAccountNameMap.size());
        //system.assertEquals(2, viewDataObj.recordIdVsAllUltraTrackWrapperMap.get(accountObj.Id).size());
    }
    
   
     /** 
     * @author Eternus Solution
     * @description: getshowTrackHistoryData test case
     *               History records present for selected object.
     *               startDate is not null and endDate is null.
     * Expected Result: Method should return empty map of recordVsHiatoryRecord.
     * @date: 29-02-2016
     */
    static testMethod void getshowTrackHistoryDataTestCase3() {
        
        list<Ultra_Track_Container__c> ultraTrackContainerList = new list<Ultra_Track_Container__c>();
        list<Attachment> attachmentList = new list<Attachment>();
        list<HistoryWrapper> historyList = new list<HistoryWrapper>();
        
        PageReference pageRef = Page.ViewData;
        Test.setCurrentPage(pageRef);
        
        Account accountObj = TestDataFactory.getAccount('TestAccount');
        insert accountObj;
        
        ultraTrackContainerList.addAll(TestDataFactory.getUltraTrackContainerList(new list<string> {'Opportunity','Account'},
                                                                                  new list<string> {'Opportunity','Account'},
                                                                                  new list<boolean> {true, true},
                                                                                  new list<string> {'Email__c,Name', 'Name'}
                                                                                  )
                                      );
        
        insert ultraTrackContainerList;
        
        historyList.addAll(TestDataFactory.getHistoryList(new list<string> {'a@b.com','c@b.com'},
                                                          new list<string> {'c@b.com','a@b.com'},
                                                          string.ValueOf(accountObj.Id),
                                                          null,
                                                          null,
                                                          new list<DateTime> {system.now(),
                                                                             system.now()+1},
                                                          new list<string> {'Changed from a@b.com to c@b.com', 'Changed from c@b.com to a@b.com'}
                                                         )
                           );
        string attachmentBodyForAccount = '{"Name":{"lstHistory":'+ System.JSON.serialize(historyList) + ',"fieldLabel":"details","fieldApiName":"Name"}}' ; 
        string attachmentBodyForOpportunity = '{"Email__c":{"lstHistory":[],"fieldLabel":"Email","fieldApiName":"Email__c"},"Name":{"lstHistory":[],"fieldLabel":"details","fieldApiName":"Name"}}';
        attachmentList.addAll(TestDataFactory.getAttachementList(new list<string> {'UltraHistoryDataAccount',
                                                                                   'UltraHistoryDataOpportunity'},
                                                                 new list<blob> {blob.valueOf(attachmentBodyForOpportunity),
                                                                                 blob.valueOf(attachmentBodyForAccount)},
                                                                 new list<Id> {ultraTrackContainerList[0].Id,
                                                                               ultraTrackContainerList[1].Id}
                                                                )
                             );
        insert attachmentList;
        
        
        ViewDataController viewDataObj = new ViewDataController();
        viewDataObj.selectedObject = 'Account';
        viewDataObj.startDate = Date.Today();
        viewDataObj.getObjects();
        
        test.startTest();
        viewDataObj.getshowTrackHistoryData();
        test.stopTest();
        
        system.assertEquals(1, viewDataObj.IdVsAccountNameMap.size());
        //system.assertEquals(2, viewDataObj.recordIdVsAllUltraTrackWrapperMap.get(accountObj.Id).size());
    }
    
     /** 
     * @author Eternus Solution
     * @description: getshowTrackHistoryData test case
     *               History records present for selected object.
     *               startDate and endDate is not null.
     * Expected Result: Method should return empty map of recordVsHistoryRecord.
     * @date: 29-02-2016
     */
    static testMethod void getshowTrackHistoryDataTestCase4() {
        
        list<Ultra_Track_Container__c> ultraTrackContainerList = new list<Ultra_Track_Container__c>();
        list<Attachment> attachmentList = new list<Attachment>();
        list<HistoryWrapper> historyList = new list<HistoryWrapper>();
        
        PageReference pageRef = Page.ViewData;
        Test.setCurrentPage(pageRef);
        
        Account accountObj = TestDataFactory.getAccount('TestAccount');
        insert accountObj;
        
        ultraTrackContainerList.addAll(TestDataFactory.getUltraTrackContainerList(new list<string> {'Opportunity','Account'},
                                                                                  new list<string> {'Opportunity','Account'},
                                                                                  new list<boolean> {true, true},
                                                                                  new list<string> {'Email__c,Name', 'Name'}
                                                                                  )
                                      );
        
        insert ultraTrackContainerList;
        
        historyList.addAll(TestDataFactory.getHistoryList(new list<string> {'a@b.com','c@b.com'},
                                                          new list<string> {'c@b.com','a@b.com'},
                                                          string.ValueOf(accountObj.Id),
                                                          null,
                                                          null,
                                                          new list<DateTime> {system.now(),
                                                                             system.now()+1},
                                                          new list<string> {'Changed from a@b.com to c@b.com', 'Changed from c@b.com to a@b.com'}
                                                         )
                           );
        string attachmentBodyForAccount = '{"Name":{"lstHistory":'+ System.JSON.serialize(historyList) + ',"fieldLabel":"details","fieldApiName":"Name"}}' ; 
        string attachmentBodyForOpportunity = '{"Email__c":{"lstHistory":[],"fieldLabel":"Email","fieldApiName":"Email__c"},"Name":{"lstHistory":[],"fieldLabel":"details","fieldApiName":"Name"}}';
        attachmentList.addAll(TestDataFactory.getAttachementList(new list<string> {'UltraHistoryDataAccount',
                                                                                   'UltraHistoryDataOpportunity'},
                                                                 new list<blob> {blob.valueOf(attachmentBodyForOpportunity),
                                                                                 blob.valueOf(attachmentBodyForAccount)},
                                                                 new list<Id> {ultraTrackContainerList[0].Id,
                                                                               ultraTrackContainerList[1].Id}
                                                                )
                             );
        insert attachmentList;
        
        
        
        ViewDataController viewDataObj = new ViewDataController();
        viewDataObj.selectedObject = 'Account';
        viewDataObj.startDate = Date.Today();
        viewDataObj.endDate = Date.Today().addDays(1);
        viewDataObj.getObjects();

        test.startTest();
        viewDataObj.getshowTrackHistoryData();
        test.stopTest();
        
        system.assertEquals(1, viewDataObj.IdVsAccountNameMap.size());
        //system.assertEquals(2, viewDataObj.recordIdVsAllUltraTrackWrapperMap.get(accountObj.Id).size());
    }
    
     /** 
     * @author Eternus Solution
     * @description: getshowTrackHistoryData test case
     *               No History records present for selected object.
     *               startDate is null and endDate is not null.
     * Expected Result: Method should return empty map of recordVsHiatoryRecord.
     * @date: 29-02-2016
     */
    static testMethod void getshowTrackHistoryDataTestCase5() {
        
        list<Ultra_Track_Container__c> ultraTrackContainerList = new list<Ultra_Track_Container__c>();
        list<Attachment> attachmentList = new list<Attachment>();
        list<HistoryWrapper> historyList = new list<HistoryWrapper>();
        
        PageReference pageRef = Page.ViewData;
        Test.setCurrentPage(pageRef);
        
        Account accountObj = TestDataFactory.getAccount('TestAccount');
        insert accountObj;
        
        ultraTrackContainerList.addAll(TestDataFactory.getUltraTrackContainerList(new list<string> {'Opportunity','Account'},
                                                                                  new list<string> {'Opportunity','Account'},
                                                                                  new list<boolean> {true, true},
                                                                                  new list<string> {'Email__c,Name', 'Name'}
                                                                                  )
                                      );
        
        insert ultraTrackContainerList;
        
        historyList.addAll(TestDataFactory.getHistoryList(new list<string> {'a@b.com','c@b.com'},
                                                          new list<string> {'c@b.com','a@b.com'},
                                                          string.ValueOf(accountObj.Id),
                                                          null,
                                                          null,
                                                          new list<DateTime> {system.now(),
                                                                             system.now()+1},
                                                          new list<string> {'Changed from a@b.com to c@b.com', 'Changed from c@b.com to a@b.com'}
                                                         )
                           );
        string attachmentBodyForAccount = '{"Name":{"lstHistory":'+ System.JSON.serialize(historyList) + ',"fieldLabel":"details","fieldApiName":"Name"}}' ; 
        string attachmentBodyForOpportunity = '{"Email__c":{"lstHistory":[],"fieldLabel":"Email","fieldApiName":"Email__c"},"Name":{"lstHistory":[],"fieldLabel":"details","fieldApiName":"Name"}}';
        attachmentList.addAll(TestDataFactory.getAttachementList(new list<string> {'UltraHistoryDataAccount',
                                                                                   'UltraHistoryDataOpportunity'},
                                                                 new list<blob> {blob.valueOf(attachmentBodyForOpportunity),
                                                                                 blob.valueOf(attachmentBodyForAccount)},
                                                                 new list<Id> {ultraTrackContainerList[0].Id,
                                                                               ultraTrackContainerList[1].Id}
                                                                )
                             );
        insert attachmentList;
        
        
        
        ViewDataController viewDataObj = new ViewDataController();
        viewDataObj.selectedObject = 'Account';
        viewDataObj.endDate = Date.Today();
        viewDataObj.getObjects();

        test.startTest();
        viewDataObj.getshowTrackHistoryData();
        test.stopTest();
        
        system.assertEquals(1, viewDataObj.IdVsAccountNameMap.size());
    }
    
     /** 
     * @author Eternus Solution
     * @description: getshowTrackHistoryData test case
     *               History records present for selected object.
     *               startDate and endDate is null.
     * Expected Result: Method should return map of recordVsHiatoryRecord.
     * @date: 29-02-2016
     */
     static testMethod void getshowTrackHistoryDataTestCase6() {
        
        list<Ultra_Track_Container__c> ultraTrackContainerList = new list<Ultra_Track_Container__c>();
        list<Attachment> attachmentList = new list<Attachment>();
        list<HistoryWrapper> historyList = new list<HistoryWrapper>();
        
        PageReference pageRef = Page.ViewData;
        Test.setCurrentPage(pageRef);
        
        Account accountObj = TestDataFactory.getAccount('TestAccount');
        insert accountObj;
        
        ultraTrackContainerList.addAll(TestDataFactory.getUltraTrackContainerList(new list<string> {'Account','Opportunity'},
                                                                                  new list<string> {'Account','Opportunity'},
                                                                                  new list<boolean> {true, false},
                                                                                  new list<string> {'Email__c,Name', 'Name'}
                                                                                  )
                                      );
        
        insert ultraTrackContainerList;
        
        historyList.addAll(TestDataFactory.getHistoryList(new list<string> {'a@b.com','c@b.com'},
                                                          new list<string> {'c@b.com','a@b.com'},
                                                          string.ValueOf(accountObj.Id),
                                                          null,
                                                          null,
                                                          new list<DateTime> {system.now(),
                                                                             system.now()},
                                                          new list<string> {'Changed from a@b.com to c@b.com', 'Changed from c@b.com to a@b.com'}
                                                         )
                           );
        string attachmentBodyForAccount = '{"Email__c":{"lstHistory":' + System.JSON.serialize(historyList); 
        attachmentBodyForAccount += ',"fieldLabel":"Email","fieldApiName":"Email__c"},"Name":{"lstHistory":[],"fieldLabel":"details","fieldApiName":"Name"}}';
        string attachmentBodyForOpportunity = '{"Name":{"lstHistory":[],"fieldLabel":"details","fieldApiName":"Name"}}';
        system.debug('DDDDD'+attachmentBodyForAccount);
        attachmentList.addAll(TestDataFactory.getAttachementList(new list<string> {'UltraHistoryDataAccount',
                                                                                   'UltraHistoryDataOpportunity'},
                                                                 new list<blob> {blob.valueOf(attachmentBodyForAccount),
                                                                                 blob.valueOf(attachmentBodyForOpportunity)},
                                                                 new list<Id> {ultraTrackContainerList[0].Id,
                                                                               ultraTrackContainerList[1].Id}
                                                                )
                             );
        insert attachmentList;
        system.debug('attachmentList='+attachmentList);
        
        ViewDataController viewDataObj = new ViewDataController();
        viewDataObj.selectedObject = 'Account';
        viewDataObj.startDateObj.DateHolder__c = null;
        viewDataObj.endDateObj.DateHolder__c = null;
        viewDataObj.getObjects();
        
        test.startTest();
        viewDataObj.getshowTrackHistoryData();
        test.stopTest();
        system.assertEquals(1, viewDataObj.IdVsAccountNameMap.size());
        //system.assertEquals(2, viewDataObj.recordIdVsAllUltraTrackWrapperMap.get(accountObj.Id).size());
    }
    
    /** 
     * @author Eternus Solution
     * @description: getRendered test case
     *               IdVsAccountNameMap is empty
     * Expected Result: Method should return false.
     * @date: 29-02-2016
     */
    static testMethod void getRenderedTestCase1() {
        
        list<Ultra_Track_Container__c> ultraTrackContainerList = new list<Ultra_Track_Container__c>();
        list<Attachment> attachmentList = new list<Attachment>();
        
        PageReference pageRef = Page.ViewData;
        Test.setCurrentPage(pageRef);
        
        ultraTrackContainerList.addAll(TestDataFactory.getUltraTrackContainerList(new list<string> {'Account','Opportunity'},
                                                                                  new list<string> {'Account','Opportunity'},
                                                                                  new list<boolean> {true, false},
                                                                                  new list<string> {'Email__c,Name', 'Name'}
                                                                                  )
                                      );
        
        insert ultraTrackContainerList;
        
        string attachmentBodyForAccount = '{"Email__c":{"lstHistory":[],"fieldLabel":"Email","fieldApiName":"Email__c"},"Name":{"lstHistory":[],"fieldLabel":"details","fieldApiName":"Name"}}';
        string attachmentBodyForOpportunity = '{"Name":{"lstHistory":[],"fieldLabel":"details","fieldApiName":"Name"}}';
        
        attachmentList.addAll(TestDataFactory.getAttachementList(new list<string> {'UltraHistoryDataAccount',
                                                                                   'UltraHistoryDataOpportunity'},
                                                                 new list<blob> {blob.valueOf(attachmentBodyForAccount),
                                                                                 blob.valueOf(attachmentBodyForOpportunity)},
                                                                 new list<Id> {ultraTrackContainerList[0].Id,
                                                                               ultraTrackContainerList[1].Id}
                                                                )
                             );
        insert attachmentList;
        
        ViewDataController viewDataObj = new ViewDataController();
        
        test.startTest();
        viewDataObj.selectedObject = 'Account';
        boolean check = viewDataObj.getRendered();
        test.stopTest();
        
        system.assertEquals(false, check);
    }
    
    /** 
     * @author Eternus Solution
     * @description: getRendered test case
     *               IdVsAccountNameMap is not empty
     * Expected Result: Method should return true.
     * @date: 29-02-2016
     */
    static testMethod void getRenderedTestCase2() {
        
        getUltraContainer();
        PageReference pageRef = Page.ViewData;
        Test.setCurrentPage(pageRef);
        
        Account accountObj = TestDataFactory.getAccount('TestAccount');
        insert accountObj;
        
        ViewDataController viewDataObj = new ViewDataController();
        viewDataObj.IdVsAccountNameMap.put(accountObj.Id, accountObj.Name);
        
        test.startTest();
        viewDataObj.selectedObject = 'Account';
        boolean check = viewDataObj.getRendered();
        test.stopTest();
        
        system.assertEquals(true, check);
    }
    
    /** 
     * @author Eternus Solution
     * @description: redirectToRecord test case
     *               redirectToRecordId is not empty
     * Expected Result: Method should return url to redirect to Record.
     * @date: 29-02-2016
     */
    static testMethod void redirectToRecordTestCase1() {
        getUltraContainer();
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = TestDataFactory.getUser('User2', 'user2', 'test@user2.come', p.Id );
        
        PageReference redirectToRecord;
        ViewDataController viewDataObj = new ViewDataController();
        
        system.runAs(u) {
            viewDataObj.redirectToRecordId = UserInfo.getUserId();
            test.startTest();
            viewDataObj.selectedObject = 'Account';
            redirectToRecord = viewDataObj.redirectToRecord();
            test.stopTest();
        }
        system.assertEquals(URL.getSalesforceBaseUrl().toExternalForm() + '/' + viewDataObj.redirectToRecordId, redirectToRecord.getUrl());
    }
    
     /** 
     * @author Eternus Solution
     * @description: redirectToRecord test case
     *               redirectToRecordId is empty
     * Expected Result: Method should return null.
     * @date: 29-02-2016
     */
    static testMethod void redirectToRecordTestCase2() {
        
        getUltraContainer();
        PageReference redirectToRecord;
        ViewDataController viewDataObj = new ViewDataController();
        viewDataObj.selectedObject = 'Account';
        
        test.startTest();
        redirectToRecord = viewDataObj.redirectToRecord();
        test.stopTest();
        
        system.assertEquals(null, redirectToRecord);
    } 
    /** 
     * @author Eternus Solutions
     * @description: Test getUsers method.
     * Expected Result: Method should return user list.
     * @date: 13-04-2016
     */
    static testMethod void getUsersTestCase1(){
    	getUltraContainer();
        Configuration__c objConfig = TestDataFactory.getConfiguration(4,10,25, 'Ascending');
        insert objConfig;
        View_Field_History_Sharing_Setting__c  objSharing = TestDataFactory.getViewFieldHistorySharingSetting();
        insert objSharing;
        ViewDataController viewDataObj = new ViewDataController();
        //viewDataObj.getUsers();
        system.assertNotEquals(0, viewDataObj.userSelectOptionList.size());  
    }
     /** 
     * @author Eternus Solutions
     * @description: Test exportAsCSVFile method.
     * Expected Result: Method should return pageReference.
     * @date: 13-04-2016
     */
     static testMethod void exportAsCSVFileTestCase(){
     	 getUltraContainer();
         ViewDataController viewDataObj = new ViewDataController();
         viewDataObj.selectedObject = 'Account';
         test.startTest();
         PageReference pageObj = viewDataObj.exportAsCSVFile();
         test.stopTest();
         system.assertEquals('/apex/UFHT__GenerateCsvFilePage', pageObj.getUrl());
        
     }
     /** 
     * @author Eternus Solutions
     * @description: Test exportAsPDFFile method.
     * Expected Result: Method should return pageReference.
     * @date: 13-04-2016
     */
     static testMethod void exportAsPDFFileTestCase(){
     	 getUltraContainer();
         ViewDataController viewDataObj = new ViewDataController();
         viewDataObj.selectedObject = 'Account';
         test.startTest();
         PageReference pageObj = viewDataObj.exportAsPDFFile();
         test.stopTest();
         system.assertEquals('/apex/UFHT__GeneratePdfFilePage', pageObj.getUrl());
        
     }
     /** 
     * @author Eternus Solutions
     * @description: Test checkStartEndDateRange method.If startDate is null and modified
                     date is less then end date.
     * Expected Result: Method should return boolean value.
     * @date: 13-04-2016
     */
     static testMethod void checkStartEndDateRangeTestCase1(){
     	 getUltraContainer();
         ViewDataController viewDataObj = new ViewDataController();
         viewDataObj.selectedObject = 'Account';
         boolean flag;
         viewDataObj.startDate = null;
         viewDataObj.endDate = Date.today().addDays(30);
         test.startTest();
         flag = viewDataObj.checkStartEndDateRange(Date.today());
         test.stopTest();
         system.assertEquals(true,flag);
     }
      /** 
     * @author Eternus Solutions
     * @description: Test checkStartEndDateRange method. if endDate is null 
         and modified date is grater than startDate.
     * Expected Result: Method should return boolean value.
     * @date: 13-04-2016
     */
     static testMethod void checkStartEndDateRangeTestCase2(){
     	 getUltraContainer();
         ViewDataController viewDataObj = new ViewDataController();
         boolean flag;
         viewDataObj.selectedObject = 'Account';
         viewDataObj.startDate = Date.today();
         viewDataObj.endDate = null;
         test.startTest();
         flag = viewDataObj.checkStartEndDateRange(Date.today().addDays(3));
         test.stopTest();
         system.assertEquals(true,flag);
     }
      /** 
     * @author Eternus Solutions
     * @description: Test getHasPrevious method.
     * Expected Result: Method should return boolean value.
     * @date: 13-04-2016
     */
     static testMethod void getHasPreviousTestCase(){
     	 getUltraContainer();
         ViewDataController viewDataObj = new ViewDataController();
         boolean flag = false;
         viewDataObj.selectedObject = 'Account';
         viewDataObj.counter = 0;
         test.startTest();
         flag = viewDataObj.getHasPrevious();
         test.stopTest();
         system.assertEquals(true,flag);
     }
     /** 
     * @author Eternus Solutions
     * @description: Test getHasNext method.
     * Expected Result: Method should return boolean value.
     * @date: 13-04-2016
     */
     static testMethod void getHasNextTestCase(){
     	 getUltraContainer();
         ViewDataController viewDataObj = new ViewDataController();
         boolean flag = true;
         viewDataObj.counter = 1;
         viewDataObj.pageSize = 5;
         viewDataObj.totalSize = 20;
         viewDataObj.selectedObject = 'Account';
         test.startTest();
         flag = viewDataObj.getHasNext();
         test.stopTest();
         system.assertEquals(false,flag);
     }
     
   /** 
     * @author Eternus Solutions
     * @description: getDateFileters test method.
     * Expected Result: Method should return correct number of date filters.
     * @date: 13-04-2016
     */
     static testMethod void getDateFiletersTestCase1() {
        
        getUltraContainer();
        list<View_Field_History_Date_Filters__c> dateFileterList = TestDataFactory.getDateFileters('Custom', '', 'Custom', 2);
        dateFileterList.addAll(TestDataFactory.getDateFileters('Last Month', '', 'Last Month', 1));
        insert dateFileterList;

        test.startTest();
        ViewDataController viewDataObj = new ViewDataController();
        viewDataObj.selectedObject = 'Account';
        test.stopTest();
        
        system.assertEquals(viewDataObj.dateFilterSelectOptionsList.size(), 2);
        
     }
     
     /** 
     * @author Eternus Solutions
     * @description: getinitializeHistoryList test method.
     * Expected Result: Method should return correct number of opportunity record.
     * @date: 13-04-2016
     */
     static testMethod void getinitializeHistoryListTestCase1() {
        
        getUltraContainer();
        
        Configuration__c objConfig = TestDataFactory.getConfiguration(4,10,25, 'Ascending');
        insert objConfig;
        
        View_Field_History_Sharing_Setting__c  objSharing = TestDataFactory.getViewFieldHistorySharingSetting();
        insert objSharing;

        test.startTest();
        ViewDataController viewDataObj = new ViewDataController();
        viewDataObj.selectedObject = 'Account';
        test.stopTest();   
        
        system.assertEquals(viewDataObj.displayHistoryWrapperList.size(), 2);
        
     }
     
    /** 
     * @author Eternus Solutions
     * @description: getinitializeHistoryList test method.
     * Expected Result: Method should return correct number of opportunity record for selected users.
     * @date: 13-04-2016
     */
     static testMethod void getinitializeHistoryListTestCase2() {
        
        list<Ultra_Track_Container__c> ultraTrackContainerList = new list<Ultra_Track_Container__c>();
        list<Attachment> attachmentList = new list<Attachment>();
        list<HistoryWrapper> historyList = new list<HistoryWrapper>();
        PageReference pageRef = Page.ViewData;
        Test.setCurrentPage(pageRef);
        
        Account accountObj = TestDataFactory.getAccount('TestAccount');
        insert accountObj;
        
        ultraTrackContainerList.addAll(TestDataFactory.getUltraTrackContainerList(new list<string> {'Account','Opportunity'},
                                                                                  new list<string> {'Account','Opportunity'},
                                                                                  new list<boolean> {true, false},
                                                                                  new list<string> {'Email__c,Name', 'Name'}
                                                                                  )
                                      );
        
        insert ultraTrackContainerList;
        
        historyList.addAll(TestDataFactory.getHistoryList(new list<string> {'a@b.com','c@b.com'},
                                                          new list<string> {'c@b.com','a@b.com'},
                                                          string.ValueOf(accountObj.Id),
                                                          UserInfo.getUserId(),
                                                          UserInfo.getUserName(),
                                                          new list<DateTime> {system.now(),
                                                                             system.now()},
                                                          new list<string> {'Changed from a@b.com to c@b.com', 'Changed from c@b.com to a@b.com'}
                                                         )
                           );
        string attachmentBodyForAccount = '{"Email__c":{"lstHistory":' + System.JSON.serialize(historyList); 
        attachmentBodyForAccount += ',"fieldLabel":"Email","fieldApiName":"Email__c"},"Name":{"lstHistory":[],"fieldLabel":"details","fieldApiName":"Name"}}';
        string attachmentBodyForOpportunity = '{"Name":{"lstHistory":[],"fieldLabel":"details","fieldApiName":"Name"}}';
        system.debug('DDDDD'+attachmentBodyForAccount);
        attachmentList.addAll(TestDataFactory.getAttachementList(new list<string> {'UltraHistoryDataAccount',
                                                                                   'UltraHistoryDataOpportunity'},
                                                                 new list<blob> {blob.valueOf(attachmentBodyForAccount),
                                                                                 blob.valueOf(attachmentBodyForOpportunity)},
                                                                 new list<Id> {ultraTrackContainerList[0].Id,
                                                                               ultraTrackContainerList[1].Id}
                                                                )
                             );
        insert attachmentList;
        Configuration__c objConfig = TestDataFactory.getConfiguration(4,10,25, 'Ascending');
        insert objConfig;
        
        View_Field_History_Sharing_Setting__c  objSharing = TestDataFactory.getViewFieldHistorySharingSetting();
        insert objSharing;

        ViewDataController viewDataObj = new ViewDataController();
        test.startTest();
        viewDataObj.selectedUser = UserInfo.getUserId();
        viewDataObj.selectedObject = 'Account';
        viewDataObj.getRecord();
        test.stopTest();   
        
        system.assertEquals(viewDataObj.displayHistoryWrapperList.size(), 2);
        
     }
     
     /** 
     * @author Eternus Solutions
     * @description: previous test method.
     * Expected Result: Method should return correct value for counter.
     * @date: 13-04-2016
     */
     static testMethod void previousTestCase() {
        getUltraContainer();
        list<Ultra_Track_Container__c> ultraTrackContainerList = new list<Ultra_Track_Container__c>();
        list<Attachment> attachmentList = new list<Attachment>();
        list<HistoryWrapper> historyList = new list<HistoryWrapper>();
        Configuration__c objConfig = TestDataFactory.getConfiguration(4,10,25, 'Ascending');
        insert objConfig;

        
        test.startTest();
        ViewDataController viewDataObj = new ViewDataController();
        viewDataObj.selectedObject = 'Account';
        viewDataObj.previous();
        test.stopTest();   
        
        system.assertEquals(viewDataObj.counter, -25);
        
     }
     
     /** 
     * @author Eternus Solutions
     * @description: next test method.
     * Expected Result: Method should return correct value for counter.
     * @date: 13-04-2016
     */
     static testMethod void nextTestCase() {
        
        getUltraContainer();
        list<Ultra_Track_Container__c> ultraTrackContainerList = new list<Ultra_Track_Container__c>();
        list<Attachment> attachmentList = new list<Attachment>();
        list<HistoryWrapper> historyList = new list<HistoryWrapper>();
        Configuration__c objConfig = TestDataFactory.getConfiguration(4,10,25, 'Ascending');
        insert objConfig;

        
        test.startTest();
        ViewDataController viewDataObj = new ViewDataController();
        viewDataObj.selectedObject = 'Account';
        viewDataObj.next();
        test.stopTest();   
        
        system.assertEquals(viewDataObj.counter, 25);
        
     }
     
     /** 
     * @author Eternus Solutions
     * @description: last test method.
     * Expected Result: Method should return correct value for counter.
     * @date: 13-04-2016
     */
     static testMethod void lastTestCase() {
        
        getUltraContainer();
        list<HistoryWrapper> historyList = new list<HistoryWrapper>();
        Configuration__c objConfig = TestDataFactory.getConfiguration(4,10,25, 'Ascending');
        insert objConfig;

        
        test.startTest();
        ViewDataController viewDataObj = new ViewDataController();
        viewDataObj.selectedObject = 'Account';
        viewDataObj.last();
        test.stopTest();   
        
        system.assertEquals(viewDataObj.counter, 0);
        
     }
     
     /** 
     * @author Eternus Solutions
     * @description: dateFilter test method.
     * Expected Result: Method should return correct start and end date for selected date filter.
     * @date: 13-04-2016
     */
     static testMethod void dateFilterTestCase() {

        getUltraContainer();
        list<View_Field_History_Date_Filters__c> dateFileterList = TestDataFactory.getDateFileters('Custom', '', 'Custom', 2);
        dateFileterList.addAll(TestDataFactory.getDateFileters('Last Month', '', 'Last Month', 1));
        insert dateFileterList;
        Date lastMonthDate = Date.Today().addMonths(-1);
        integer dayOfMonth = Date.daysInMonth(lastMonthDate.year(), lastMonthDate.month());
        
        test.startTest();
        ViewDataController viewDataObj = new ViewDataController();
        viewDataObj.selectedDateFilter = 'Last Month';
        viewDataObj.selectedObject = 'Account';
        viewDataObj.dateFilter();
        test.stopTest();   
        
        system.assertEquals(viewDataObj.startDateObj.DateHolder__c, lastMonthDate.toStartOfMonth());
        system.assertEquals(viewDataObj.endDateObj.DateHolder__c, lastMonthDate.toStartOfMonth().addDays(dayOfMonth - 1));
     }
     
   
}