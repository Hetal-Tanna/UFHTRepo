/*
 * Class Name: UltraTrackUtilityClassTest
 * @Description: Test class for UltraTrackUtilityClass class. 
  ============================================================================================
        Version   | Date        | Author             | Comments
    ------------------------------------------------------------------------------------------
        1.0       | 1-3-2016    | Eternus Solution   | Test Cases for getFieldNamesAndLabels, 
                                                     | displayMessage methods.
   ===========================================================================================
 */
@isTest
private class UltraTrackUtilityClassTest {
    
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
        ultraTrackContainerList.addAll(TestDataFactory.getUltraTrackContainerList(
            new list<string> {'Account','Opportunity'},
            new list<string> {'Account','Opportunity'},
            new list<boolean> {true, false},
            new list<string> {'Name', 'Name'}
        ));
        
        insert ultraTrackContainerList;
        
        historyList.addAll(TestDataFactory.getHistoryList(new list<string> {'a@b.com','c@b.com'},
                                                          new list<string> {'c@b.com','a@b.com'},
                                                          string.ValueOf(accountObj.Id),
                                                          UserInfo.getUserId(),
                                                          new list<DateTime> {system.now(),
                                                                             system.now()}
                                                         ));
                           
        string attachmentBodyForAccount = '{"Name":' + System.JSON.serialize(historyList); 
        attachmentBodyForAccount += '},"Email__c":{[]}';
        string attachmentBodyForOpportunity = '{"Name":{[]}}';
        
        String strDate = String.valueOf(todayDate.month()+100).right(2)+'/'
                          + String.valueOf(todayDate.day()+100).right(2)+'/'
                          + String.valueOf(todayDate.year());

        
        attachmentList.addAll(TestDataFactory.getAttachementList(
            new list<string> {Label.AttachmentFileName+'SD'+strDate,
                Label.AttachmentFileName+'SD'+ strDate +'ED'+ strDate,
                Label.AttachmentFileName},
            new list<blob> {blob.valueOf(attachmentBodyForAccount),blob.valueOf(attachmentBodyForAccount),
                blob.valueOf(attachmentBodyForOpportunity)},
            new list<Id> {ultraTrackContainerList[0].Id,ultraTrackContainerList[0].Id,
                ultraTrackContainerList[1].Id}
        ));
        insert attachmentList;
    }
    
    /** 
      * @author: Eternus Solutions
      * @description: getFieldNamesAndLabels test
      *               object name is null
      * Expected Result: Method should returned empty map for fields.
      * @date: 1-03-2016
      */ 
    static testMethod void getFieldNamesAndLabelsTestCase1() {
        
        UltraTrackUtilityClass util = new UltraTrackUtilityClass();
        
        test.startTest();
        Map<String,String> fieldNameVsLabelMap = util.getFieldNamesAndLabels(null);
        test.stopTest();
        
        system.assertEquals(0, fieldNameVsLabelMap.size());
    }
    
    /** 
      * @author: Eternus Solutions
      * @description: getFieldNamesAndLabels test
      *               object name is not null
      * Expected Result: Method should returned map for fields.
      * @date: 1-03-2016
      */ 
    static testMethod void getFieldNamesAndLabelsTestCase2() {
        
        UltraTrackUtilityClass util = new UltraTrackUtilityClass();
        
        test.startTest();
        Map<String,String> fieldNameVsLabelMap = util.getFieldNamesAndLabels('Account');
        test.stopTest();
        
        system.assertNotEquals(0, fieldNameVsLabelMap.size());
    }
    
    /** 
      * @author: Eternus Solutions
      * @description: getFieldNamesAndLabels test
      *               object name is not null but object is not present in the org.
      * Expected Result: Method should returned empty map for fields.
      * @date: 1-03-2016
      */ 
    static testMethod void getFieldNamesAndLabelsTestCase3() {
        
        UltraTrackUtilityClass util = new UltraTrackUtilityClass();
        
        test.startTest();
        Map<String,String> fieldNameVsLabelMap = util.getFieldNamesAndLabels('abc');
        test.stopTest();
        
        system.assertEquals(0, fieldNameVsLabelMap.size());
    }
    
    /** 
      * @author: Eternus Solutions
      * @description: displayMessage test
      *               message is null
      * Expected Result: Method should add apex page message.
      * @date: 1-03-2016
      */ 
    static testMethod void displayMessageTestCase1() {
        
        UltraTrackUtilityClass util = new UltraTrackUtilityClass();
        
        test.startTest();
        util.displayMessage(ApexPages.severity.CONFIRM,'');
        test.stopTest();
        
        ApexPages.Message[] pageMessages = ApexPages.getMessages();
        system.assertEquals(1, pageMessages.size());
        
        system.assertEquals('CONFIRM', string.valueOf(pageMessages[0].getSeverity()));
        system.assertEquals('', pageMessages[0].getSummary());
    }
    
    /** 
      * @author: Eternus Solutions
      * @description: displayMessage test
      *               message is not null
      * Expected Result: Method should add apex page message.
      * @date: 1-03-2016
      */ 
    static testMethod void displayMessageTestCase2() {
        
        UltraTrackUtilityClass util = new UltraTrackUtilityClass();
        
        test.startTest();
        util.displayMessage(ApexPages.severity.CONFIRM,'Record Saved.');
        test.stopTest();
        
        ApexPages.Message[] pageMessages = ApexPages.getMessages();
        system.assertEquals(1, pageMessages.size());
        
        system.assertEquals('CONFIRM', string.valueOf(pageMessages[0].getSeverity()));
        system.assertEquals('Record Saved.', pageMessages[0].getSummary());
    }
    
     /** 
      * @author: Eternus Solutions
      * @description: getOwdForAnObjec test
      *               object is Opportunity
      * Expected Result: Method should return opportunity share object name, fieldName and isCustom false.
      * @date: 12-04-2016
      */
    static testMethod void getOwdForAnObjectTestCase1() {
        
        new UltraTrackUtilityClass();
        map<boolean, list<string>> result = new map<boolean, list<string>>();
        
        test.startTest();
        result = UltraTrackUtilityClass.getOwdForAnObject('Opportunity');
        test.stopTest();
        
        system.assertEquals(result.containsKey(true), true);
        list<string> resultList = result.get(true);
        system.assertEquals(resultList[0], 'Opportunityshare');
        system.assertEquals(resultList[1], 'OpportunityId');
        system.assertEquals(resultList[2], 'false');
    }
     
     /** 
      * @author: Eternus Solutions
      * @description: getOwdForAnObject test
      *               object is custom object
      * Expected Result: Method should return custom object share object name, fieldName and isCustom true.
      * @date: 12-04-2016
      */
     static testMethod void getOwdForAnObjectTestCase2() {
        
        new UltraTrackUtilityClass();
        map<boolean, list<string>> result = new map<boolean, list<string>>();
        
        test.startTest();
        result = UltraTrackUtilityClass.getOwdForAnObject(system.Label.Package_Prefix + '__' + system.Label.Sharing_Purpose);
        test.stopTest();
        
        system.assertEquals(result.containsKey(true), true);
        list<string> resultList = result.get(true);
        system.assertEquals(resultList[0], 'UFHT__Sharing_Purpose__share');
        system.assertEquals(resultList[1], 'ParentId');
        system.assertEquals(resultList[2], 'true');
    }
    
    /** 
      * @author: Eternus Solutions
      * @description: getOwdForAnObject test
      *               object is custom object having open OWD
      * Expected Result: Method should return true as it is open OWD.
      * @date: 12-04-2016
      */
    static testMethod void getOwdForAnObjectTestCase3() {
        
        new UltraTrackUtilityClass();
        map<boolean, list<string>> result = new map<boolean, list<string>>();
        
        test.startTest();
        result = UltraTrackUtilityClass.getOwdForAnObject(system.Label.Package_Prefix + '__' + system.Label.Ultra_Track_Container);
        test.stopTest();
        
        system.assertEquals(result.containsKey(false), true);
        list<string> resultList = result.get(false);
        system.assertEquals(resultList[0], 'true');
    }
    
     /** 
      * @author: Eternus Solutions
      * @description: getSubGroupDetails test
      *               Group Id having group member as user
      * Expected Result: Method should return users belongs to group.
      * @date: 12-04-2016
      */
    static testMethod void getSubGroupDetailsTestCase1() {
        
        map <Id, set<Id>> groupIdVsUserIdSetMap = new map <Id, set<Id>>();
        Id user1Id, user2Id;
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User user1 = TestDataFactory.getUser('User1', 'user1', 'test@user1.come', p.Id );
        User user2 = TestDataFactory.getUser('User2', 'user2', 'test@user2.come', p.Id );
        system.runAs(user1) {
            user1Id = UserInfo.getUserId();
            
        }
        system.runAs(user2) {
            user2Id = UserInfo.getUserId();
        }
        Group groupObj = TestDataFactory.getGroup('Test', 'TestGroup');
        insert groupObj;
    
        list<GroupMember> groupMemberList = TestDataFactory.getGroupMemeber(groupObj.Id, new set<Id> {user1Id, user2Id});
        insert groupMemberList;
        
        test.startTest();
        groupIdVsUserIdSetMap = UltraTrackUtilityClass.getSubGroupDetails(new set<Id> {groupObj.Id});
        test.stopTest();

        system.assert(groupIdVsUserIdSetMap.containsKey(groupObj.Id));
        system.assertEquals(2,groupIdVsUserIdSetMap.get(groupObj.Id).size());
    }
    
    /** 
      * @author: Eternus Solutions
      * @description: getSubGroupDetails test
      *               Group Id having group member as user and group
      * Expected Result: Method should return users belongs to group.
      * @date: 12-04-2016
     */
    static testMethod void getSubGroupDetailsTestCase2() {
        
        map <Id, set<Id>> groupIdVsUserIdSetMap = new map <Id, set<Id>>();
        Id user1Id, user2Id, user3Id;
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User user1 = TestDataFactory.getUser('User1', 'user1', 'test@user1.come', p.Id );
        User user2 = TestDataFactory.getUser('User2', 'user2', 'test@user2.come', p.Id );
        User user3 = TestDataFactory.getUser('User3', 'user3', 'test@user3.come', p.Id );
        system.runAs(user1) {
            user1Id = UserInfo.getUserId();
            
        }
        system.runAs(user2) {
            user2Id = UserInfo.getUserId();
        }
        
        system.runAs(user3) {
            user3Id = UserInfo.getUserId();
        }
        Group groupObj1 = TestDataFactory.getGroup('Test1', 'TestGroup1');
        insert groupObj1;
        
        Group groupObj2 = TestDataFactory.getGroup('Test2', 'TestGroup2');
        insert groupObj2;
        
        Group groupObj3 = TestDataFactory.getGroup('Test3', 'TestGroup3');
        insert groupObj3;
    
        list<GroupMember> groupMemberList = TestDataFactory.getGroupMemeber(groupObj3.Id, new set<Id> {user3Id});
        groupMemberList.addAll(TestDataFactory.getGroupMemeber(groupObj2.Id, new set<Id> {user1Id}));
        groupMemberList.addAll(TestDataFactory.getGroupMemeber(groupObj1.Id, new set<Id> {user2Id, groupObj2.Id, groupObj3.Id}));
        insert groupMemberList;
        
        test.startTest();
        groupIdVsUserIdSetMap = UltraTrackUtilityClass.getSubGroupDetails(new set<Id> {groupObj1.Id, groupObj2.Id});
        test.stopTest();

        system.assert(groupIdVsUserIdSetMap.containsKey(groupObj1.Id));
        system.assertEquals(3,groupIdVsUserIdSetMap.get(groupObj1.Id).size());
        
        system.assert(groupIdVsUserIdSetMap.containsKey(groupObj2.Id));
        system.assertEquals(1,groupIdVsUserIdSetMap.get(groupObj2.Id).size());
    }

    /** 
      * @author: Eternus Solutions
      * @description: getAllSubRoleIds test
      *               Role Id 
      * Expected Result: Method should return sub role Id belongs to Role.
      * @date: 12-04-2016
     */
    static testMethod void getAllSubRoleIdsTestCase1() {
        set<Id> result = new set<Id>();
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        
        UserRole ur1 = new UserRole(Name = 'CEO');
        insert ur1;
        
        UserRole ur2 = new UserRole(Name = 'CEO', ParentRoleId = ur1.Id);
        insert ur2;
        
        User user1 = TestDataFactory.getUser('User1', 'user1', 'test@user1.come', p.Id, ur1.Id);
        User user2 = TestDataFactory.getUser('User2', 'user2', 'test@user2.come', p.Id, ur2.Id);
        User user3 = TestDataFactory.getUser('User3', 'user3', 'test@user3.come', p.Id, ur2.Id);
        
        test.startTest();
        result = UltraTrackUtilityClass.getAllSubRoleIds(new set<Id> {ur1.Id});
        test.stopTest();
        
        system.assertEquals(1,result.size());
    }
    
    /** 
      * @author: Eternus Solutions
      * @description: getAllManagerForUser test
      *               user Id
      * Expected Result: Method should return all managers Id for an user.
      * @date: 12-04-2016
    */
    static testMethod void getAllManagerForUserTestCase() {
        map<Id, Set<ID>> userIdVsAllManagerIdMap = new map<Id, Set<ID>>();
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        Id user1Id, user2Id, user3Id;
        User user1 = TestDataFactory.getUser('User1', 'user1', 'test@user1.come', p.Id);
       
        system.runAs(user1) {
            user1Id = UserInfo.getUserId();
            
        }
        
        User user2 = TestDataFactory.getUser('User2', 'user2', 'test@user2.come', p.Id, user1Id);
        system.runAs(user2) {
            user2Id = UserInfo.getUserId();
        }
        User user3 = TestDataFactory.getUser('User3', 'user3', 'test@user3.come', p.Id, user2Id);
        system.runAs(user3) {
            user3Id = UserInfo.getUserId();
        }
        
        new UltraTrackUtilityClass();
        
        test.startTest();
        userIdVsAllManagerIdMap = UltraTrackUtilityClass.getAllManagerForUser(new set<Id> {user3Id});
        test.stopTest();
        
        system.assert(userIdVsAllManagerIdMap.containsKey(user3Id));
        system.assertEquals(2,userIdVsAllManagerIdMap.get(user3Id).size());
        
    }
    
    /** 
      * @author: Eternus Solutions
      * @description: getSharing test
      *               account share object name, fieldName and isCustom.
      * Expected Result: Method should return users who have access to record.
      * @date: 12-04-2016
    */
    static testMethod void getSharingTestCase1() {
        
         map<Id, set<Id>> recordIdVsUserOrGroupIdSetMap = new map<Id, set<Id>>();
         Account accountObj = TestDataFactory.getAccount('TestAccount');
         insert accountObj;

        test.startTest();
        recordIdVsUserOrGroupIdSetMap = UltraTrackUtilityClass.getSharing(new list<string> {'accountshare', 'AccountId', 'false'}, 
                                          new set<Id> {accountObj.ID});
        test.stopTest();
        
        system.assertEquals(1,recordIdVsUserOrGroupIdSetMap.size());
    }
    /** 
      * @author: Eternus Solutions
      * @description: getSharing test
      *               Sharing_Purpose share object name, fieldName, isCustom and record Id.
      * Expected Result: Method should return users who have access to record.
      * @date: 12-04-2016
    */
   static testMethod void getSharingTestCase2() {
        
         map<Id, set<Id>> recordIdVsUserOrGroupIdSetMap = new map<Id, set<Id>>();
         Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
         Id user1Id, user2Id, user3Id;
         User user1 = TestDataFactory.getUser('User1', 'user1', 'test@user1.come', p.Id);
         Sharing_Purpose__c shareObj = TestDataFactory.getSharing_Purpose('test1');
         insert shareObj;
         
         system.runAs(user1) {
            user1Id = UserInfo.getUserId();
            
         } 
        
        Sharing_Purpose__share accShareObj = TestDataFactory.getSharing_PurposeSharing(user1Id, shareObj.Id, 'Edit');
        insert accShareObj;
         
        test.startTest();
        recordIdVsUserOrGroupIdSetMap = UltraTrackUtilityClass.getSharing(new list<string> {'Sharing_Purpose__share', 'ParentId', 'true'}, 
                                          new set<Id> {shareObj.ID});
        test.stopTest();
        
        system.assert(!recordIdVsUserOrGroupIdSetMap.isEmpty());
        system.assertEquals(2, recordIdVsUserOrGroupIdSetMap.get(shareObj.Id).size());
        
    }
    
    /** 
      * @author: Eternus Solutions
      * @description: getSharing test
      *               Sharing_Purpose share object name, fieldName, isCustom and record Id.
      * Expected Result: Method should return users who have access to record.
      * @date: 12-04-2016
    */
    static testMethod void getSharingTestCase3() {
        
         map<Id, set<Id>> recordIdVsUserOrGroupIdSetMap = new map<Id, set<Id>>();
         Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
         Id user1Id, user2Id;
         User user1 = TestDataFactory.getUser('User1', 'user1', 'test@user1.come', p.Id);
         User user2 = TestDataFactory.getUser('User2', 'user2', 'test@user2.come', p.Id);
         Sharing_Purpose__c shareObj = TestDataFactory.getSharing_Purpose('test1');
         insert shareObj;
         
         Group groupObj1 ;
         
         system.runAs(user1) {
            user1Id = UserInfo.getUserId();
            
         } 
         
         system.runAs(user2) {
            user2Id = UserInfo.getUserId();
            groupObj1 = TestDataFactory.getGroup('Test1', 'TestGroup1');
            insert groupObj1;
    
            list<GroupMember> groupMemberList = TestDataFactory.getGroupMemeber(groupObj1.Id, new set<Id> {user1Id, user2Id});
            insert groupMemberList;    
            
         } 
         
        Sharing_Purpose__share accShareObj = TestDataFactory.getSharing_PurposeSharing(groupObj1.Id, shareObj.Id, 'Edit');
        insert accShareObj;
         
        test.startTest();
        recordIdVsUserOrGroupIdSetMap = UltraTrackUtilityClass.getSharing(new list<string> {'Sharing_Purpose__share', 'ParentId', 'true'}, 
                                          new set<Id> {shareObj.ID});
        test.stopTest();
        
        system.assert(!recordIdVsUserOrGroupIdSetMap.isEmpty());
        system.assertEquals(3, recordIdVsUserOrGroupIdSetMap.get(shareObj.Id).size());
    }
    
    /** 
      * @author: Eternus Solutions
      * @description: getStartAndEndDateForFilte test
      *               DateFilter is Last Month
      * Expected Result: Method should return startDate and EndDate object.
      * @date: 12-04-2016
    */
    static testMethod void getStartAndEndDateForFilterTestCase1() {
        
        list<Ultra_Track_Container__c> startEndDateList = new list<Ultra_Track_Container__c>();
        
        list<View_Field_History_Date_Filters__c> dateFileterList = TestDataFactory.getDateFileters('Last Month', '', 'Month', 1);
        insert dateFileterList;
        
        Date lastMonthDate = Date.Today().addMonths(-1);
        integer dayOfMonth = Date.daysInMonth(lastMonthDate.year(), lastMonthDate.month());
        test.startTest();
        startEndDateList = UltraTrackUtilityClass.getStartAndEndDateForFilter('Last Month');
        test.stopTest();
        
        system.assertEquals(startEndDateList[0].DateHolder__c, lastMonthDate.toStartOfMonth());
        system.assertEquals(startEndDateList[1].DateHolder__c, lastMonthDate.toStartOfMonth().addDays(dayOfMonth - 1));
        
    }
    
    /** 
      * @auth: Eternus Solutions
      * @description: getStartAndEndDateForFilte test
      *               DateFilter is This Month
      * Expected Result: Method should return startDate and EndDate object.
      * @date: 12-04-2016
    */
    static testMethod void getStartAndEndDateForFilterTestCase2() {
        
        list<Ultra_Track_Container__c> startEndDateList = new list<Ultra_Track_Container__c>();
        
        list<View_Field_History_Date_Filters__c> dateFileterList = TestDataFactory.getDateFileters('This Month', '', 'Month', 1);
        insert dateFileterList;
        
        Date currentMonthDate = Date.Today();
        integer dayOfMonth = Date.daysInMonth(currentMonthDate.year(), currentMonthDate.month());
        test.startTest();
        startEndDateList = UltraTrackUtilityClass.getStartAndEndDateForFilter('This Month');
        test.stopTest();
        
        system.assertEquals(startEndDateList[0].DateHolder__c, currentMonthDate.toStartOfMonth());
        system.assertEquals(startEndDateList[1].DateHolder__c, currentMonthDate.toStartOfMonth().addDays(dayOfMonth - 1));
        
    }
    
    /** 
      * @author: Eternus Solutions
      * @description: getStartAndEndDateForFilte test
      *               DateFilter is Current and Previous Month
      * Expected Result: Method should return startDate and EndDate object.
      * @date: 12-04-2016
    */
    static testMethod void getStartAndEndDateForFilterTestCase3() {
        
        list<Ultra_Track_Container__c> startEndDateList = new list<Ultra_Track_Container__c>();
        
        list<View_Field_History_Date_Filters__c> dateFileterList = TestDataFactory.getDateFileters('Current and Previous Month', '', 'Month', 1);
        insert dateFileterList;
        
        Date currentMonthDate = Date.Today();
        Date lastMonthDate = Date.Today().addMonths(-1);
        integer dayOfMonth = Date.daysInMonth(currentMonthDate.year(), currentMonthDate.month()) ;
        test.startTest();
        startEndDateList = UltraTrackUtilityClass.getStartAndEndDateForFilter('Current and Previous Month');
        test.stopTest();
        
        system.assertEquals(startEndDateList[0].DateHolder__c, lastMonthDate.toStartOfMonth());
        system.assertEquals(startEndDateList[1].DateHolder__c, currentMonthDate.toStartOfMonth().addDays(dayOfMonth - 1));
        
    }
    /** 
      * @author: Eternus Solutions
      * @description: getStartAndEndDateForFilte test
      *               DateFilter is Last Week
      * Expected Result: Method should return startDate and EndDate object.
      * @date: 12-04-2016
    */
     static testMethod void getStartAndEndDateForFilterTestCase4() {
        
        list<Ultra_Track_Container__c> startEndDateList = new list<Ultra_Track_Container__c>();
        
        list<View_Field_History_Date_Filters__c> dateFileterList = TestDataFactory.getDateFileters('Last Week', '', 'Week', 1);
        insert dateFileterList;
        
        Date lastWeekDate = Date.Today().addDays(-7);
        test.startTest();
        startEndDateList = UltraTrackUtilityClass.getStartAndEndDateForFilter('Last Week');
        test.stopTest();
        
        system.assertEquals(startEndDateList[0].DateHolder__c, lastWeekDate.toStartofWeek());
        system.assertEquals(startEndDateList[1].DateHolder__c, lastWeekDate.toStartofWeek().addDays(6));
        
    }
    
    /** 
      * @author: Eternus Solutions
      * @description: getStartAndEndDateForFilte test
      *               DateFilter is This Week
      * Expected Result: Method should return startDate and EndDate object.
      * @date: 12-04-2016
    */
    static testMethod void getStartAndEndDateForFilterTestCase5() {
        
        list<Ultra_Track_Container__c> startEndDateList = new list<Ultra_Track_Container__c>();
        
        list<View_Field_History_Date_Filters__c> dateFileterList = TestDataFactory.getDateFileters('This Week', '', 'Week', 1);
        insert dateFileterList;
        
       Date CurrentWeekDate = Date.Today();
        test.startTest();
        startEndDateList = UltraTrackUtilityClass.getStartAndEndDateForFilter('This Week');
        test.stopTest();
        
        system.assertEquals(startEndDateList[0].DateHolder__c, CurrentWeekDate.toStartofWeek());
        system.assertEquals(startEndDateList[1].DateHolder__c, CurrentWeekDate.toStartofWeek().addDays(6));
        
    }
    
    /** 
      * @author: Eternus Solutions
      * @description: getStartAndEndDateForFilte test
      *               DateFilter is Today
      * Expected Result: Method should return startDate and EndDate object.
      * @date: 12-04-2016
    */
    static testMethod void getStartAndEndDateForFilterTestCase6() {
        
        list<Ultra_Track_Container__c> startEndDateList = new list<Ultra_Track_Container__c>();
        
        list<View_Field_History_Date_Filters__c> dateFileterList = TestDataFactory.getDateFileters('Today', '', '', 1);
        insert dateFileterList;
        
        test.startTest();
        startEndDateList = UltraTrackUtilityClass.getStartAndEndDateForFilter('Today');
        test.stopTest();
        
        system.assertEquals(startEndDateList[0].DateHolder__c, Date.Today());
        system.assertEquals(startEndDateList[1].DateHolder__c, Date.Today());
        
    }
    
    /** 
      * @author: Eternus Solutions
      * @description: getStartAndEndDateForFilte test
      *               DateFilter is Yesterday
      * Expected Result: Method should return startDate and EndDate object.
      * @date: 12-04-2016
    */
    static testMethod void getStartAndEndDateForFilterTestCase7() {
        
        list<Ultra_Track_Container__c> startEndDateList = new list<Ultra_Track_Container__c>();
        
        list<View_Field_History_Date_Filters__c> dateFileterList = TestDataFactory.getDateFileters('Yesterday', '', '', 1);
        insert dateFileterList;
        
        test.startTest();
        startEndDateList = UltraTrackUtilityClass.getStartAndEndDateForFilter('Yesterday');
        test.stopTest();
        
        system.assertEquals(startEndDateList[0].DateHolder__c, Date.Today().addDays(-1));
        system.assertEquals(startEndDateList[1].DateHolder__c, Date.Today().addDays(-1));
        
    }
    
    /** 
      * @author: Eternus Solutions
      * @description: getStartAndEndDateForFilte test
      *               DateFilter is Last 90 Days
      * Expected Result: Method should return startDate and EndDate object.
      * @date: 12-04-2016
    */
    static testMethod void getStartAndEndDateForFilterTestCase8() {
        
        list<Ultra_Track_Container__c> startEndDateList = new list<Ultra_Track_Container__c>();
        
        list<View_Field_History_Date_Filters__c> dateFileterList = TestDataFactory.getDateFileters('Last 90 Days', '90', 'Day', 1);
        insert dateFileterList;
        
        test.startTest();
        startEndDateList = UltraTrackUtilityClass.getStartAndEndDateForFilter('Last 90 Days');
        test.stopTest();
        
        system.assertEquals(startEndDateList[0].DateHolder__c,Date.Today().addDays(90));
        system.assertEquals(startEndDateList[1].DateHolder__c, Date.Today());
        
    }
    
    /** 
      * @author: Eternus Solutions
      * @description: getStartAndEndDateForFilte test
      *               DateFilter is custom
      * Expected Result: Method should return startDate and EndDate object.
      * @date: 12-04-2016
    */
    static testMethod void getStartAndEndDateForFilterTestCase9() {
        
        list<Ultra_Track_Container__c> startEndDateList = new list<Ultra_Track_Container__c>();
        
        list<View_Field_History_Date_Filters__c> dateFileterList = TestDataFactory.getDateFileters('Custom', '', 'Custom', 1);
        insert dateFileterList;
        
        test.startTest();
        startEndDateList = UltraTrackUtilityClass.getStartAndEndDateForFilter('Custom');
        test.stopTest();
        
        system.assertEquals(startEndDateList[0].DateHolder__c, null);
        system.assertEquals(startEndDateList[1].DateHolder__c, null);
        
    }
    
     /** 
      * @author: Eternus Solutions
      * @description: getStartAndEndDateForFilter test
      *               DateFilter is custom
      *               getDateFileters custom setting is empty
      * Expected Result: Method should return empty list.
      * @date: 12-04-2016
    */
    static testMethod void getStartAndEndDateForFilterTestCase10() {

        list<Ultra_Track_Container__c> startEndDateList = new list<Ultra_Track_Container__c>();
        test.startTest();
        startEndDateList = UltraTrackUtilityClass.getStartAndEndDateForFilter('Custom');
        test.stopTest();
        
        system.assert(startEndDateList.isEmpty());
        
    }
    
    /** 
      * @author: Eternus Solutions
      * @description: getNameUniqueField test
      *               objectName is Account
      * Expected Result: Method should return name field for an account.
      * @date: 12-04-2016
    */
    static testMethod void getNameUniqueFieldTestCase1() {
        
        string fieldName;
        test.startTest();
        fieldName = UltraTrackUtilityClass.getNameUniqueField('Account');
        test.stopTest();
        
        system.assertEquals(fieldName, 'Name');
    }
    
    /** 
      * @author: Eternus Solutions
      * @description: getNameUniqueField test
      *               objectName is Case
      * Expected Result: Method should return name field for an case.
      * @date: 12-04-2016
    */
    static testMethod void getNameUniqueFieldTestCase2() {
        
        string fieldName;
        test.startTest();
        fieldName = UltraTrackUtilityClass.getNameUniqueField('Case');
        test.stopTest();
        
        system.assertEquals(fieldName, 'CaseNumber');
    }
    /** 
      * @author: Eternus Solutions
      * @description: getNameUniqueField test
      *               objectName is Solution
      * Expected Result: Method should return name field for an solution.
      * @date: 12-04-2016
    */
    static testMethod void getNameUniqueFieldTestCase3() {
        
        string fieldName;
        test.startTest();
        fieldName = UltraTrackUtilityClass.getNameUniqueField('Solution');
        test.stopTest();
        
        system.assertEquals(fieldName, 'SolutionName');
    }
     /** 
      * @author: Eternus Solutions
      * @description: Test method to check method returns or not fields from record
      * Expected Result: method returns set of fields form records.
      * @date: 8-06-2016
    */
    static testMethod void getFieldsTestCase1() {
        list<Contact> lstContact = new list<Contact>();
        Contact objCon1 = TestDataFactory.getContact('Test', 'Contact','202012546', '0104578', 'Other');
        insert objCon1;
        lstContact.add(objCon1);
        
        objCon1.FirstName = 'Test1';
        objCon1.LastName = 'Test';
        update objCon1;
        lstContact.add(new Contact(ID = objCon1.id));

        test.startTest();
        set<String> setFields = UltraTrackUtilityClass.getFields((sObject)lstContact[0],
                                                (sObject)lstContact[1]
                                                );
        test.stopTest();
        system.assertEquals(setFields.contains('FirstName'), true);
        system.assertEquals(setFields.contains('LeadSource'), true);
    }
    /** 
      * @author: Eternus Solutions
      * @description: Test method to check currency type 
      * Expected Result: Method returns no element in the list if fiels type is not currency,Percent and EncryptedString
      * @date: 8-06-2016
    */
    static testMethod void checkCurrencyOrPercentFieldCase1() {
        List<string> fieldValue;
        test.startTest();
        fieldValue = UltraTrackUtilityClass.checkCurrencyOrPercentField('UFHT__Sharing_Purpose__c', 'Name','1234','1234');
        test.stopTest();
        system.assertEquals(fieldValue.size(), 0);
    }
    
    /** 
      * @author: Eternus Solutions
      * @description: Test method to check currency type
      * Expected Result: Method returns INR value of fiels type is currency
      * @date: 8-06-2016
    */
    static testMethod void checkCurrencyOrPercentFieldCase2() {
        List<string> fieldValue;
        test.startTest();
        fieldValue = UltraTrackUtilityClass.checkCurrencyOrPercentField('UFHT__Sharing_Purpose__c', 'UFHT__Currency_Field__c','1234','1234');
        test.stopTest();
        system.assertEquals(fieldValue[0], 'INR 1234'); 
    }
    
    /** 
      * @author: Eternus Solutions
      * @description: Test method to check currency type
      * Expected Result: Method returns % value of fiels type is Percent
      * @date: 8-06-2016
    */
    static testMethod void checkCurrencyOrPercentFieldCase3() {
        List<string> fieldValue;
        test.startTest();
        fieldValue = UltraTrackUtilityClass.checkCurrencyOrPercentField('UFHT__Sharing_Purpose__c', 'UFHT__Percent_Field__c','1234','1234');
        test.stopTest();
        system.assertEquals(fieldValue[0], '1234%'); 
    }
    /** 
      * @author: Eternus Solutions
      * @description: Test method to check currency type
      * Expected Result: Method returns Masked Characters if value of fiels type is Encrypted String
      * @date: 8-06-2016
    */
    
    static testMethod void checkCurrencyOrPercentFieldCase4() {
        UFHT__Encrypted_Field_Mask__c fieldMaskObj = new UFHT__Encrypted_Field_Mask__c (Name = 'all',UFHT__RegEx__c = '\\p{ASCII}');
        insert fieldMaskObj;
         
        List<string> fieldValue;
        test.startTest();
        fieldValue = UltraTrackUtilityClass.checkCurrencyOrPercentField('UFHT__Sharing_Purpose__c', 'UFHT__EncryptedString_Field__c','1234','1234');
        test.stopTest();
        system.assertEquals(fieldValue[0], 'XXXX'); 
    }
    
    /** 
      * @author: Eternus Solutions
      * @description: Test method to check type of Field
      * Expected Result: Method returns type of field
      * @date: 8-06-2016
    */
    static testMethod void getFieldTypeCase1() {
        Schema.DisplayType fieldType;
        test.startTest();
        fieldType = UltraTrackUtilityClass.getFieldType('Account', 'Name');
        test.stopTest();
        String actualType = String.valueOf(fieldType );
        system.assert(actualType.equalsIgnoreCase('STRING'));    
    }
    
    /** 
      * @author: Eternus Solutions
      * @description: Test method to check type of Field when its null
      * Expected Result: Method returns null if field is not specified
      * @date: 8-06-2016
    */
    static testMethod void getFieldTypeCase2() {
        Schema.DisplayType fieldType;
        test.startTest();
        fieldType = UltraTrackUtilityClass.getFieldType('Account', '');
        test.stopTest();
        system.assertEquals(fieldType , null); 
    }
           
    /** 
      * @author: Eternus Solutions
      * @description: maskEncryptedDataCase1 test 
      * Expected Result: Method returns masked value for all when All is selected
      * @date: 8-06-2016
    */
    static testMethod void maskEncryptedDataCase1() {
         UFHT__Encrypted_Field_Mask__c fieldMaskObj = new UFHT__Encrypted_Field_Mask__c (Name = 'all',UFHT__RegEx__c = '\\p{ASCII}');
         insert fieldMaskObj ;
         
         List<String> updatedValues;
         test.startTest();
         updatedValues = UltraTrackUtilityClass.maskEncryptedData(UFHT__Sharing_Purpose__c.UFHT__EncryptedFieldsFor_All__c.getDescribe(),'1234-1234-1234-1234','1234-1234-1234-1234');
         test.stopTest();
         System.assertEquals(updatedValues[0], 'XXXXXXXXXXXXXXXXXXX');
    }
    
    /** 
      * @author: Eternus Solutions
      * @description: maskEncryptedDataCase1 test 
      * Expected Result: Method returns masked value for Credit Card number
      * @date: 8-06-2016
    */
    static testMethod void maskEncryptedDataCase2() {
         UFHT__Encrypted_Field_Mask__c fieldMaskObj = new UFHT__Encrypted_Field_Mask__c (Name = 'creditCard',UFHT__RegEx__c = '[0-9]}');
         insert fieldMaskObj ;
         
         List<String> updatedValues;
         test.startTest();
         updatedValues = UltraTrackUtilityClass.maskEncryptedData(UFHT__Sharing_Purpose__c.UFHT__EncryptedFieldsFor_CreditCard__c.getDescribe(),'1234-1234-1234-1234','1234-1234-1234-1234');
         test.stopTest();
         System.assertEquals(updatedValues[0], '1234-1234-1234-1234');
    }
    
    /** 
      * @author: Eternus Solutions
      * @description: maskEncryptedDataCase1 test 
      * Expected Result: Method returns masked value when LastFour is selected
      * @date: 8-06-2016
    */
    static testMethod void maskEncryptedDataCase3() {
         UFHT__Encrypted_Field_Mask__c fieldMaskObj = new UFHT__Encrypted_Field_Mask__c (Name = 'lastFour',UFHT__RegEx__c = '\\p{ASCII}');
         insert fieldMaskObj ;
         
         List<String> updatedValues;
         test.startTest();
         updatedValues = UltraTrackUtilityClass.maskEncryptedData(UFHT__Sharing_Purpose__c.UFHT__EncryptedFieldsFor_LastFour__c.getDescribe(),'1234-1234-1234-1234','1234-1234-1234-1234');
         test.stopTest();
         System.assertEquals(updatedValues[0], 'XXXXXXXXXXXXXXX1234');
    }
    
    /** 
      * @author: Eternus Solutions
      * @description: maskEncryptedDataCase1 test 
      * Expected Result: Method returns masked value for nino(National Insurance Number)
      * @date: 8-06-2016
    */
    static testMethod void maskEncryptedDataCase4() {
         UFHT__Encrypted_Field_Mask__c fieldMaskObj = new UFHT__Encrypted_Field_Mask__c (Name = 'nino',UFHT__RegEx__c = '[^\\ ]');
         insert fieldMaskObj ;
         
         List<String> updatedValues;
         test.startTest();
         updatedValues = UltraTrackUtilityClass.maskEncryptedData(UFHT__Sharing_Purpose__c.UFHT__EncryptedFieldsFor_Nino__c.getDescribe(),'12 12 12 12 1','12 12 12 12 1');
         test.stopTest();
         System.assertEquals(updatedValues[0], 'XX XX XX XX X');
    }
    
    /** 
      * @author: Eternus Solutions
      * @description: maskEncryptedDataCase1 test 
      * Expected Result: Method returns masked value for SSN(Social Security Number)
      * @date: 8-06-2016
    */
    static testMethod void maskEncryptedDataCase5() {
         UFHT__Encrypted_Field_Mask__c fieldMaskObj = new UFHT__Encrypted_Field_Mask__c (Name = 'ssn',UFHT__RegEx__c = '[0-9]');
         insert fieldMaskObj ;
         
         List<String> updatedValues;
         test.startTest();
         updatedValues = UltraTrackUtilityClass.maskEncryptedData(UFHT__Sharing_Purpose__c.UFHT__EncryptedFieldsFor_SSN__c.getDescribe(),'123-12-1234','123-12-1234');
         test.stopTest();
         System.assertEquals(updatedValues[0], 'XXX-XX-1234');
    }
    
    /** 
      * @author: Eternus Solutions
      * @description: maskEncryptedDataCase1 test 
      * Expected Result: Method returns masked value for SIN(Social Insurance Number)
      * @date: 8-06-2016
    */
    static testMethod void maskEncryptedDataCase6() {
         UFHT__Encrypted_Field_Mask__c fieldMaskObj = new UFHT__Encrypted_Field_Mask__c (Name = 'sin',UFHT__RegEx__c = '[0-9]');
         insert fieldMaskObj ;
         
         List<String> updatedValues;
         test.startTest();
         updatedValues = UltraTrackUtilityClass.maskEncryptedData(UFHT__Sharing_Purpose__c.UFHT__EncryptedFieldsFor_SIN__c.getDescribe(),'123-123-123','123-123-123');
         test.stopTest();
         System.assertEquals(updatedValues[0], 'XXX-XXX-123');
    }
    
    /** 
      * @author        : Eternus Solutions
      * @description   : Method to test count when all proper parameters are provided
      * Expected Result: 
      * @date          : 07-08-2016
    */
    static testMethod void testRecordCountForSelectedIdWithAllProperParameters() {
        
        Test.startTest();
        
        Id objId = [Select Id 
                    From UFHT__Ultra_Track_Container__c  
                    Where UFHT__Object_Name__c = 'Account' 
                    Limit 1][0].id;
        
        String strTodaysDate =  DateTime.newInstance(System.today().year(),
                                                     System.today().month(),
                                                     System.today().day()).format('DD/MM/YYYY');
        String strDay = String.valueOf(System.today().day());
        String strMonth = String.valueOf(System.today().month());
        String strYear = String.valueOf(System.today().year());
		String strDate = strDay+'/'+strMonth+'/'+strYear;      
        
        Integer recordCount = UltraTrackUtilityClass.getAttachmentRecordCount(String.valueOf(objId),
                                                                             strDate,strDate);        
        Test.stopTest(); 
        
        system.assertEquals(2, recordCount);
    }
    
    /** 
      * @author        : Eternus Solutions
      * @description   : Method to test count when id and start date is provided but end date is null
      * Expected Result: 
      * @date          : 07-08-2016
    */
    static testMethod void testRecordCountForSelectedIdWhenEndDateNotProvided() {
        
        Test.startTest();
        
        Id objId = [Select Id 
                    From UFHT__Ultra_Track_Container__c  
                    Where UFHT__Object_Name__c = 'Account' 
                    Limit 1][0].id;
        
        String strTodaysDate =  DateTime.newInstance(System.today().year(),
                                                     System.today().month(),
                                                     System.today().day()).format('DD/MM/YYYY');
        String strDay = String.valueOf(System.today().day());
        String strMonth = String.valueOf(System.today().month());
        String strYear = String.valueOf(System.today().year());
		String strDate = strDay+'/'+strMonth+'/'+strYear;      
        
        Integer recordCount = UltraTrackUtilityClass.getAttachmentRecordCount(String.valueOf(objId),
                                                                             strDate,null);
        
        Test.stopTest();        
        
        system.assertEquals(2,recordCount);
    }
    
    /** 
      * @author        : Eternus Solutions
      * @description   : Method to test count when id and end date is provided but start date is null
      * Expected Result: 
      * @date          : 07-08-2016
    */
    static testMethod void testRecordCountForSelectedIdWhenStartDateNotProvided() {
        
        Test.startTest();
        
        Id objId = [Select Id 
                    From UFHT__Ultra_Track_Container__c  
                    Where UFHT__Object_Name__c = 'Account' 
                    Limit 1][0].id;
        
        String strTodaysDate =  DateTime.newInstance(System.today().year(),
                                                     System.today().month(),
                                                     System.today().day()).format('DD/MM/YYYY');
        String strDay = String.valueOf(System.today().day());
        String strMonth = String.valueOf(System.today().month());
        String strYear = String.valueOf(System.today().year());
		String strDate = strDay+'/'+strMonth+'/'+strYear;      
        
        Integer recordCount = UltraTrackUtilityClass.getAttachmentRecordCount(String.valueOf(objId),
                                                                              null, strDate);
        
        Test.stopTest();        
        
        system.assertEquals(2,recordCount);
    }
    
    /** 
      * @author        : Eternus Solutions
      * @description   : Method to test count when id is provided but start date and end date are null
      * Expected Result: 
      * @date          : 07-08-2016
    */
    static testMethod void testRecordCountForSelectedIdWhenStartAndEndDatesNotProvided() {
        
        Test.startTest();
        
        Id objId = [Select Id 
                    From UFHT__Ultra_Track_Container__c  
                    Where UFHT__Object_Name__c = 'Account' 
                    Limit 1][0].id;
        
        String strDay = String.valueOf(System.today().day());
        String strMonth = String.valueOf(System.today().month());
        String strYear = String.valueOf(System.today().year());
		String strDate = strDay+'/'+strMonth+'/'+strYear;      
        
        Integer recordCount = UltraTrackUtilityClass.getAttachmentRecordCount(String.valueOf(objId),
                                                                              null, null);
        
        Test.stopTest();        
        
        system.assertEquals(2,recordCount);
    }
    
    /** 
      * @author        : Eternus Solutions
      * @description   : Method to test count when id is provided but start date greater than end date 
      * Expected Result: 
      * @date          : 07-08-2016
    */
    static testMethod void testRecordCountForSelectedIdWhenStartDateGreaterThanEndDate() {
        
        Test.startTest();
        
        Id objId = [Select Id 
                    From UFHT__Ultra_Track_Container__c  
                    Where UFHT__Object_Name__c = 'Account' 
                    Limit 1][0].id;
        
        String strTodaysDate =  DateTime.newInstance(System.today().year(),
                                                     System.today().month(),
                                                     System.today().day()).format('DD/MM/YYYY');
        
        String strStartDay = String.valueOf(System.today().day()+1);
        String strEndDay = String.valueOf(System.today().day());
        String strMonth = String.valueOf(System.today().month());
        String strYear = String.valueOf(System.today().year());
		String strStartDate = strStartDay+'/'+strMonth+'/'+strYear;  
        String strEndDate = strEndDay+'/'+strMonth+'/'+strYear;
        
        Integer recordCount = UltraTrackUtilityClass.getAttachmentRecordCount(String.valueOf(objId),
                                                                              strStartDate, strEndDate);
        
        Test.stopTest();        
        
        system.assertEquals(0,recordCount);
    }
    
    /** 
      * @author        : Eternus Solutions
      * @description   : Method to test count when id is null 
      * Expected Result: 
      * @date          : 07-08-2016
    */
    static testMethod void testRecordCountWhenIdIsNull() {
        
        Test.startTest();
        
        String strStartDay = String.valueOf(System.today().day()+1);
        String strEndDay = String.valueOf(System.today().day());
        String strMonth = String.valueOf(System.today().month());
        String strYear = String.valueOf(System.today().year());
		String strStartDate = strStartDay+'/'+strMonth+'/'+strYear;  
        String strEndDate = strEndDay+'/'+strMonth+'/'+strYear;
        
        Integer recordCount = UltraTrackUtilityClass.getAttachmentRecordCount(null, strStartDate, strEndDate);
        
        Test.stopTest();        
        
        system.assertEquals(null,recordCount);
    }
    
    /** 
      * @author        : Eternus Solutions
      * @description   : Method to test Attachment records when id, start date, end date and offset 
      *                  are provided with proper value
      * Expected Result: 
      * @date          : 07-08-2016
    */
    static testMethod void testAttachmentRecordsWhenProperValuesAreProvided() {
        
        Test.startTest();
        
        Id objId = [Select Id 
                    From UFHT__Ultra_Track_Container__c  
                    Where UFHT__Object_Name__c = 'Account' 
                    Limit 1][0].id;
        
        String strDay = String.valueOf(System.today().day());
        String strMonth = String.valueOf(System.today().month());
        String strYear = String.valueOf(System.today().year());
		String strDate = strDay+'/'+strMonth+'/'+strYear;  
        
        Attachment objAttachment = UltraTrackUtilityClass.getAttachments(String.valueOf(objId),
                                                                                strDate, strDate, '0');
        
        Test.stopTest();  
        
        strDate = String.valueOf(System.today().month()+100).right(2)+'/'
                + String.valueOf(System.today().day()+100).right(2)+'/'
                + String.valueOf(System.today().year());
        
        system.assert(objAttachment.Name.containsIgnoreCase(Label.AttachmentFileName+'SD'+strDate));
    }
    
    /** 
      * @author        : Eternus Solutions
      * @description   : Method to test Attachment records when id, start date and offset 
      *                  are provided but end date is null
      * Expected Result: 
      * @date          : 07-08-2016
    */
    static testMethod void testAttachmentRecordsWhenEndDateIsNull() {
        
        Test.startTest();
        
        Id objId = [Select Id 
                    From UFHT__Ultra_Track_Container__c  
                    Where UFHT__Object_Name__c = 'Account' 
                    Limit 1][0].id;
        
        String strDay = String.valueOf(System.today().day());
        String strMonth = String.valueOf(System.today().month());
        String strYear = String.valueOf(System.today().year());
		String strDate = strDay+'/'+strMonth+'/'+strYear;  
        
        Attachment objAttachment = UltraTrackUtilityClass.getAttachments(String.valueOf(objId),
                                                                                strDate, null, '0');
        
        Test.stopTest();  
        
        strDate = String.valueOf(System.today().month()+100).right(2)+'/'
                + String.valueOf(System.today().day()+100).right(2)+'/'
                + String.valueOf(System.today().year());
        
        system.assert(objAttachment.Name.containsIgnoreCase(Label.AttachmentFileName+'SD'+strDate));
    }
    
    /** 
      * @author        : Eternus Solutions
      * @description   : Method to test Attachment records when id, end date and offset 
      *                  are provided but start date is null
      * Expected Result: 
      * @date          : 07-08-2016
    */
    static testMethod void testAttachmentRecordsWhenStartDateIsNull() {
        
        Test.startTest();
        
        Id objId = [Select Id 
                    From UFHT__Ultra_Track_Container__c  
                    Where UFHT__Object_Name__c = 'Account' 
                    Limit 1][0].id;
        
        String strDay = String.valueOf(System.today().day());
        String strMonth = String.valueOf(System.today().month());
        String strYear = String.valueOf(System.today().year());
		String strDate = strDay+'/'+strMonth+'/'+strYear;  
        
        Attachment objAttachment = UltraTrackUtilityClass.getAttachments(String.valueOf(objId),
                                                                                null, strDate, '0');
        
        Test.stopTest();  
        
        strDate = String.valueOf(System.today().month()+100).right(2)+'/'
                + String.valueOf(System.today().day()+100).right(2)+'/'
                + String.valueOf(System.today().year());
        
        system.assert(objAttachment.Name.containsIgnoreCase(Label.AttachmentFileName+'SD'+strDate));
    }
    
    /** 
      * @author        : Eternus Solutions
      * @description   : Method to test Attachment records when id and offset 
      *                  are provided but start and end dates are null
      * Expected Result: 
      * @date          : 07-08-2016
    */
    static testMethod void testAttachmentRecordsWhenStartAndEndDatesAreNull() {
        
        Test.startTest();
        
        Id objId = [Select Id 
                    From UFHT__Ultra_Track_Container__c  
                    Where UFHT__Object_Name__c = 'Account' 
                    Limit 1][0].id;
        
        
		String strDate;  
        
        Attachment objAttachment = UltraTrackUtilityClass.getAttachments(String.valueOf(objId),
                                                                                null, null, '0');
        
        Test.stopTest();  
        
        strDate = String.valueOf(System.today().month()+100).right(2)+'/'
                + String.valueOf(System.today().day()+100).right(2)+'/'
                + String.valueOf(System.today().year());
        
        system.assert(objAttachment.Name.containsIgnoreCase(Label.AttachmentFileName+'SD'+strDate));
    }
    
    /** 
      * @author        : Eternus Solutions
      * @description   : Method to test Attachment records when all parameters are null
      * Expected Result: 
      * @date          : 07-08-2016
    */
    static testMethod void testAttachmentRecordsWhenAllParametersAreNull() {
        
        Test.startTest();
        
        Attachment objAttachment = UltraTrackUtilityClass.getAttachments(null , null, null, null);
        
        Test.stopTest();
        
        system.assert(String.isBlank(objAttachment.Name));
    }
    
    /** 
      * @author        : Eternus Solutions
      * @description   : Method to checkCurrencyOrPercentField() method with sObject API name 
      *                  and an improper field
      * Expected Result: 
      * @date          : 07-08-2016
    */
    static testMethod void testCheckCurrencyOrPercentFieldForImproperField() {
        
        Test.startTest();
        
        List<String> listString = 
            UltraTrackUtilityClass.checkCurrencyOrPercentField('Account','Name_c','Old','New');
        
        Test.stopTest();
        
        system.assert(listString == null);
    }
    
    /** 
      * @author        : Eternus Solutions
      * @description   : Method to testCurrencyOrPercentField() method with sObject API name 
      *                  and an improper field
      * Expected Result: 
      * @date          : 07-08-2016
    */
    static testMethod void testGetFieldTypeWithImproperSObjectName() {
        
        Test.startTest();
        
        Map<String, Schema.SObjectField> mapStringAndSObjectField = 
                                            UltraTrackUtilityClass.getFieldType('Account__c');
        
        Test.stopTest();
        
        system.assert(mapStringAndSObjectField == null);
    }
    
     /** 
      * @author        : Eternus Solutions
      * @description   : Method to maskEncryptedData() method when fieldDescribe is null
      * Expected Result: 
      * @date          : 07-08-2016
      */
    static testMethod void testMaskEncryptedDataWhenFieldDescribeIsNull() {
         UFHT__Encrypted_Field_Mask__c fieldMaskObj = 
                                   new UFHT__Encrypted_Field_Mask__c (Name = 'sin',UFHT__RegEx__c = '[0-9]');
         insert fieldMaskObj ;
         
         test.startTest();
         List<String> updatedValues = 
             UltraTrackUtilityClass.maskEncryptedData(null,'123-123-123','123-123-123');
         test.stopTest();
         System.assert(updatedValues == null);
    }
    
    /** 
      * @author        : Eternus Solutions
      * @description   : Method to maskEncryptedData() method when oldValue and newValue is null
      * Expected Result: 
      * @date          : 07-08-2016
      */
    static testMethod void testMaskEncryptedDataWhenOldValueAndNewValueIsNull() {
        
        UFHT__Encrypted_Field_Mask__c fieldMaskObj = 
            new UFHT__Encrypted_Field_Mask__c (Name = 'sin',UFHT__RegEx__c = '[0-9]');
        insert fieldMaskObj ;
        
        UFHT__Encrypted_Field_Mask__c fieldMaskObj1 = 
            new UFHT__Encrypted_Field_Mask__c (Name = 'all',UFHT__RegEx__c = '\\p{ASCII}');
        insert fieldMaskObj1 ;
        
        UFHT__Encrypted_Field_Mask__c fieldMaskObj2 = new UFHT__Encrypted_Field_Mask__c (Name = 'ssn',UFHT__RegEx__c = '[0-9]');
         insert fieldMaskObj2 ;
        
        test.startTest();
        List<String> updatedValues = 
            UltraTrackUtilityClass.maskEncryptedData(UFHT__Sharing_Purpose__c.UFHT__EncryptedFieldsFor_SIN__c
                                                     .getDescribe(),
                                                     null,null);
        
        
        updatedValues = 
            UltraTrackUtilityClass.maskEncryptedData(UFHT__Sharing_Purpose__c.UFHT__EncryptedFieldsFor_All__c
                                                     .getDescribe(),
                                                     null,null);
        updatedValues = 
            UltraTrackUtilityClass.maskEncryptedData(UFHT__Sharing_Purpose__c.UFHT__EncryptedFieldsFor_SSN__c
                                                     .getDescribe(),
                                                     null,null);
        
        test.stopTest();
        
        System.assertEquals(2,updatedValues.size());
    }
}