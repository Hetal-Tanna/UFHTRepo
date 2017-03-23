/*
 * Class Name: ViewDataControllerCloneTest
 * @Description: Test class for ViewDataControllerClone class.
  ============================================================================================
        Version   | Date        | Author              | Comments
    ------------------------------------------------------------------------------------------
        1.0       | 29-2-2016    | Eternus Solution   | Test Cases for getObjects, getshowTrackHistory
                                                      | getRendered methods.
   ===========================================================================================
 */
@isTest
private class ViewDataControllerCloneTest {
    
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
        
        ViewDataControllerClone viewDataObj = new ViewDataControllerClone();
        
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
        
        ViewDataControllerClone viewDataObj = new ViewDataControllerClone();
        
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
        
        ViewDataControllerClone viewDataObj = new ViewDataControllerClone();
        
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
                                                          UserInfo.getUserId(),
                                                          new list<DateTime> {system.now(),
                                                                             system.now()}
                                                         )
                           );
        string attachmentBodyForAccount = '{"Email__c":' + System.JSON.serialize(historyList); 
        attachmentBodyForAccount += '},"Name":{[]}';
        string attachmentBodyForOpportunity = '{"Name":{[]}}';
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
        
        string attachmentBodyForAccount = '{"Email__c":[],"Name":[]}';
        string attachmentBodyForOpportunity = '{"Name":[]}';
        
        attachmentList.addAll(TestDataFactory.getAttachementList(new list<string> {'UltraHistoryDataAccount',
                                                                                   'UltraHistoryDataOpportunity'},
                                                                 new list<blob> {blob.valueOf(attachmentBodyForAccount),
                                                                                 blob.valueOf(attachmentBodyForOpportunity)},
                                                                 new list<Id> {ultraTrackContainerList[0].Id,
                                                                               ultraTrackContainerList[1].Id}
                                                                )
                             );
        insert attachmentList;
        
        ViewDataControllerClone viewDataObj = new ViewDataControllerClone();
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
                                                          UserInfo.getUserId(),
                                                          new list<DateTime> {system.now(),
                                                                             system.now()}
                                                         )
                           );
        string attachmentBodyForAccount = '{"Email__c":' + System.JSON.serialize(historyList); 
        attachmentBodyForAccount += '},"Name":{}';
        string attachmentBodyForOpportunity = '{"Name":}';
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
        
        ViewDataControllerClone viewDataObj = new ViewDataControllerClone();
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
                                                          UserInfo.getUserId(),
                                                          new list<DateTime> {system.now(),
                                                                             system.now()+1})
                           );
        string attachmentBodyForAccount = '{"Name":'+ System.JSON.serialize(historyList) + '}' ; 
        string attachmentBodyForOpportunity = '{"Email__c": ,"Name":}';
        attachmentList.addAll(TestDataFactory.getAttachementList(new list<string> {'UltraHistoryDataAccount',
                                                                                   'UltraHistoryDataOpportunity'},
                                                                 new list<blob> {blob.valueOf(attachmentBodyForOpportunity),
                                                                                 blob.valueOf(attachmentBodyForAccount)},
                                                                 new list<Id> {ultraTrackContainerList[0].Id,
                                                                               ultraTrackContainerList[1].Id}
                                                                )
                             );
        insert attachmentList;
        
        
        ViewDataControllerClone viewDataObj = new ViewDataControllerClone();
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
                                                          UserInfo.getUserId(),
                                                          new list<DateTime> {system.now(),
                                                                             system.now()+1})
                           );
        string attachmentBodyForAccount = '{"Name":'+ System.JSON.serialize(historyList) + '}' ; 
        string attachmentBodyForOpportunity = '{"Email__c":,"Name":}';
        attachmentList.addAll(TestDataFactory.getAttachementList(new list<string> {'UltraHistoryDataAccount',
                                                                                   'UltraHistoryDataOpportunity'},
                                                                 new list<blob> {blob.valueOf(attachmentBodyForOpportunity),
                                                                                 blob.valueOf(attachmentBodyForAccount)},
                                                                 new list<Id> {ultraTrackContainerList[0].Id,
                                                                               ultraTrackContainerList[1].Id}
                                                                )
                             );
        insert attachmentList;
        
        
        
        ViewDataControllerClone viewDataObj = new ViewDataControllerClone();
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
                                                          UserInfo.getUserId(),
                                                          new list<DateTime> {system.now(),
                                                                             system.now()+1})
                           );
        string attachmentBodyForAccount = '{"Name":'+ System.JSON.serialize(historyList) + '}' ; 
        string attachmentBodyForOpportunity = '{"Email__c":,"Name":}';
        attachmentList.addAll(TestDataFactory.getAttachementList(new list<string> {'UltraHistoryDataAccount',
                                                                                   'UltraHistoryDataOpportunity'},
                                                                 new list<blob> {blob.valueOf(attachmentBodyForOpportunity),
                                                                                 blob.valueOf(attachmentBodyForAccount)},
                                                                 new list<Id> {ultraTrackContainerList[0].Id,
                                                                               ultraTrackContainerList[1].Id}
                                                                )
                             );
        insert attachmentList;
        
        
        
        ViewDataControllerClone viewDataObj = new ViewDataControllerClone();
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
                                                          UserInfo.getUserId(),
                                                          new list<DateTime> {system.now(),
                                                                             system.now()})
                           );
        string attachmentBodyForAccount = '{"Email__c":' + System.JSON.serialize(historyList); 
        attachmentBodyForAccount += ',"Name":[]}';
        string attachmentBodyForOpportunity = '{"Name":[]}';
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
        
        ViewDataControllerClone viewDataObj = new ViewDataControllerClone();
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
        ViewDataControllerClone viewDataObj = new ViewDataControllerClone();
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
         ViewDataControllerClone viewDataObj = new ViewDataControllerClone();
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
         ViewDataControllerClone viewDataObj = new ViewDataControllerClone();
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
         ViewDataControllerClone viewDataObj = new ViewDataControllerClone();
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
         ViewDataControllerClone viewDataObj = new ViewDataControllerClone();
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
         ViewDataControllerClone viewDataObj = new ViewDataControllerClone();
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
         ViewDataControllerClone viewDataObj = new ViewDataControllerClone();
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
        ViewDataControllerClone viewDataObj = new ViewDataControllerClone();
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
        ViewDataControllerClone viewDataObj = new ViewDataControllerClone();
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
                                                          new list<DateTime> {system.now(),
                                                                             system.now()})
                           );
        string attachmentBodyForAccount = '{"Email__c":' + System.JSON.serialize(historyList); 
        attachmentBodyForAccount += ',"Name":[]}';
        string attachmentBodyForOpportunity = '{"Name":[]}';
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

        ViewDataControllerClone viewDataObj = new ViewDataControllerClone();
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
        ViewDataControllerClone viewDataObj = new ViewDataControllerClone();
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
        ViewDataControllerClone viewDataObj = new ViewDataControllerClone();
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
        ViewDataControllerClone viewDataObj = new ViewDataControllerClone();
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
        ViewDataControllerClone viewDataObj = new ViewDataControllerClone();
        viewDataObj.selectedDateFilter = 'Last Month';
        viewDataObj.selectedObject = 'Account';
        viewDataObj.dateFilter();
        test.stopTest();   
        
        system.assertEquals(viewDataObj.startDateObj.DateHolder__c, lastMonthDate.toStartOfMonth());
        system.assertEquals(viewDataObj.endDateObj.DateHolder__c, lastMonthDate.toStartOfMonth().addDays(dayOfMonth - 1));
     }
     
     static testMethod void dateFileterWhenStartEndDateNullTestCase() {
     	getUltraContainer();
     	list<View_Field_History_Date_Filters__c> dateFileterList = TestDataFactory.getDateFileters('Custom', '', 'Custom', 2);
        dateFileterList.addAll(TestDataFactory.getDateFileters('Last Month', '', 'Last Month', 1));
        insert dateFileterList;
        
        test.startTest();
        ViewDataControllerClone viewDataObj = new ViewDataControllerClone();
        viewDataObj.startDateObj.DateHolder__c = null;
        viewDataObj.endDateObj.DateHolder__c = null;
        viewDataObj.dateFileterWhenStartEndDateNull();
        test.stopTest();  
        
        system.assertEquals(viewDataObj.displayHistoryWrapperList.size(), 0);
        system.assertEquals(viewDataObj.selectedDateFilter, 'Custom');
     }
     
     /** 
     * @author Eternus Solutions
     * @description: getShowMoredata test method.
     * Expected Result: Method should return number of value in showMoreData.
     * @date: 26-05-2016
     */
     static testMethod void getShowMoredataTestCase() {
        
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
                                                          new list<DateTime> {system.now(),
                                                                             system.now()})
                           );
        string attachmentBodyForAccount = '{"Email__c":' + System.JSON.serialize(historyList); 
        attachmentBodyForAccount += ',"Name":[]}';
        string attachmentBodyForOpportunity = '{"Name":[]}';
        system.debug('DDDDD'+attachmentBodyForAccount);
        attachmentList.addAll(TestDataFactory.getAttachementList(new list<string> {'UltraHistoryDataAccount1',
                                                                                   'UltraHistoryDataOpportunity',
                                                                                   'UltraHistoryDataAccount2'},
                                                                 new list<blob> {blob.valueOf(attachmentBodyForAccount),
                                                                                 blob.valueOf(attachmentBodyForOpportunity),
                                                                                 blob.valueOf(attachmentBodyForAccount)},
                                                                 new list<Id> {ultraTrackContainerList[0].Id,
                                                                               ultraTrackContainerList[1].Id,
                                                                               ultraTrackContainerList[0].Id}
                                                                )
                             );
        insert attachmentList;
        Configuration__c objConfig = TestDataFactory.getConfiguration(4,10,25, 'Ascending');
        insert objConfig;
        
        View_Field_History_Sharing_Setting__c  objSharing = TestDataFactory.getViewFieldHistorySharingSetting();
        insert objSharing;

        ViewDataControllerClone viewDataObj = new ViewDataControllerClone();
        test.startTest();
        viewDataObj.selectedUser = UserInfo.getUserId();
        viewDataObj.selectedObject = 'Account';
        viewDataObj.getRecord();
        viewDataObj.getShowMoredata();
        test.stopTest();   
        
        system.assertEquals(viewDataObj.showMoreData, 1);
        system.assertEquals(viewDataObj.offsetSize, 1);
     }
     
     /** 
     * @author Eternus Solutions
     * @description: selectedObjectIsNull test method.
     * Expected Result: Method should return zero number of record to be displayed .
     * @date: 26-05-2016
     */
     static testMethod void selectedObjectIsNullTestCase() {
        getUltraContainer();
        list<View_Field_History_Date_Filters__c> dateFileterList = TestDataFactory.getDateFileters('Custom', '', 'Custom', 2);
        dateFileterList.addAll(TestDataFactory.getDateFileters('Last Month', '', 'Last Month', 1));
        insert dateFileterList;
        
        test.startTest();
        ViewDataControllerClone viewDataObj = new ViewDataControllerClone();
        viewDataObj.selectedObject = '  ';
        viewDataObj.getRecord();
        test.stopTest();  
        
        system.assertEquals(viewDataObj.displayHistoryWrapperList.size(), 0);
     }
}