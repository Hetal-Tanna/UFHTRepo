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
        system.assert(groupIdVsUserIdSetMap.get(groupObj.Id).size() == 2);
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
        system.assert(groupIdVsUserIdSetMap.get(groupObj1.Id).size() == 3);
        
        system.assert(groupIdVsUserIdSetMap.containsKey(groupObj2.Id));
        system.assert(groupIdVsUserIdSetMap.get(groupObj2.Id).size() == 1);
    }
    
     /*static testMethod void getSubGroupDetailsTestCase3() {
        
        map <Id, set<Id>> groupIdVsUserIdSetMap = new map <Id, set<Id>>();
        Id user1Id, user2Id, user3Id;
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User user1 = TestDataFactory.getUser('User1', 'user1', 'test@user1.come', p.Id );
        User user2 = TestDataFactory.getUser('User2', 'user2', 'test@user2.come', p.Id );
        User user3 = TestDataFactory.getUser('User3', 'user3', 'test@user3.come', p.Id );
        UserRole ur1 = new UserRole(Name = 'CEO');
        insert ur1;
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
        groupObj1.RelatedId = ur1.Id;
        insert groupObj1;
        
        Group groupObj2 = TestDataFactory.getGroup('Test2', 'TestGroup2');
        insert groupObj2;
        
        Group groupObj3 = TestDataFactory.getGroup('Test3', 'TestGroup3');
        insert groupObj3;
        
        groupObj3.RelatedId = ur1.Id;
        update groupObj3;
    
        list<GroupMember> groupMemberList = TestDataFactory.getGroupMemeber(groupObj3.Id, new set<Id> {user3Id});
        groupMemberList.addAll(TestDataFactory.getGroupMemeber(groupObj2.Id, new set<Id> {user1Id}));
        groupMemberList.addAll(TestDataFactory.getGroupMemeber(groupObj1.Id, new set<Id> {user2Id, groupObj2.Id, groupObj3.Id}));
        insert groupMemberList;
        
        test.startTest();
        groupIdVsUserIdSetMap = UltraTrackUtilityClass.getSubGroupDetails(new set<Id> {groupObj1.Id, groupObj2.Id});
        test.stopTest();

        system.assert(groupIdVsUserIdSetMap.containsKey(groupObj1.Id));
        system.assert(groupIdVsUserIdSetMap.get(groupObj1.Id).size() == 3);
        
        system.assert(groupIdVsUserIdSetMap.containsKey(groupObj2.Id));
        system.assert(groupIdVsUserIdSetMap.get(groupObj2.Id).size() == 1);
    }*/
    
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
        
        system.assert(result.size() == 1);
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
        system.assert(userIdVsAllManagerIdMap.get(user3Id).size() == 2);
        
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
    
     static testMethod void hasSObjectFieldTestCase() {

        boolean isFieldPresent;
        Account accountObj = TestDataFactory.getAccount('TestAccount');
        insert accountObj;

        test.startTest();
        isFieldPresent = UltraTrackUtilityClass.hasSObjectField('Name', accountObj, accountObj);
        test.stopTest();
        
        system.assertEquals(isFieldPresent, true);
    }
}