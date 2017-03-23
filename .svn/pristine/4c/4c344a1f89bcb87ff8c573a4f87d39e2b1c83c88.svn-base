/**
  * @Class Name: UltraTrackUtilityTest
  * @Description: This class contains unit tests for UltraTrackUtility.cls
  * ===================================================================================================
  *       Version   | Date        | Author             | Comments
  * ---------------------------------------------------------------------------------------------------
  *       1.0       | 1/3/2016    | Eternus Solutions  | 1.Created the Test Class for UltraTrackUtility
  * ====================================================================================================
  **/
@isTest
private class UltraTrackUtilityTest {
    
    private static final String STRINGACCOUNT   = 'Account';
    private static final String STRINGCLASSNAME = 'AccountClass';
    private static final String STRINGBLANK     = '';
    private static final String STRINGOUTPUT    = '@isTest(SeeAllData=true)\n'                                                                         +
                                                   'public class '+ STRINGCLASSNAME + ' {\n'                                                           +
                                                   'testmethod static void dynamicTriggerGenenratorTest() {\n'                                         +
                                                   'Integer retryCount = 0;\n String recordUpdateFailError;\n'                                         +
                                                   'list<sObject> objList = Database.query(\''+ 'SELECT Id' + ' FROM ' + STRINGACCOUNT + ' ORDER BY Id DESC' + ' LIMIT 1' + '\');\n' +
                                                   'if(!objList.isEmpty() && objList[0] != null) {\n'                                                  +
                                                   'do {\n' + 'try {\n' + 'recordUpdateFailError = \'\';\n'                                            +
                                                   'retryCount ++;\n' + 'update objList[0];\n'  + 'break; \n}\n'                                       +
                                                   'catch(DMLException ex) {\n recordUpdateFailError = ex.getDmlMessage(0); \n }\n'                           +
                                                   '} while(retryCount < 3);\n'                                                                        +
                                                   'if(retryCount == 3 && String.isNotBlank(recordUpdateFailError)) {\n'                               +
                                                   'throw new UFHT.UFHTExceptions.DynamicTestClassCreationFailException(\'Please modify the data for specified record to comply with the mentioned validation: \'' +
                                                   '+ recordUpdateFailError + \'. Click <a href="/\' + objList[0].Id + \'"\' + \' target=\\\'_balnk \\\'>here</a> to edit the record.\');\n}\n'+                            +
                                                   'else {\nSystem.assert(objList[0].Id != null);\n}\n}'                                               +
                                                   'else {throw new UFHT.UFHTExceptions.DynamicTestClassCreationFailException(\'No Record found for selected object to create test class.\');\n}\n' +
                                                   '}\n}';
    
    /**
     * @Author: Eternus Solutions 
     * @Description: Method to set up test data to be used in test methods to test the functionality.
     * @Param: NA
     * @Return: NA
     * @Date: 04/07/2016
     **/ 
    @testSetup 
    static void setupTestData() {
        
        list<Ultra_Track_Container__c> ultraTrackContainerList = new list<Ultra_Track_Container__c>();
        list<Attachment> attachmentList = new list<Attachment>();
        list<HistoryWrapper> historyList = new list<HistoryWrapper>();
 
        // Inserted account record.
        Account accountObj = TestDataFactory.getAccount('TestAccount');
        insert accountObj;
        
        
        String result;
        Date todayDate = Date.today();
        // Inserted Ultra_Track_Container records.
        ultraTrackContainerList.addAll(TestDataFactory.getUltraTrackContainerList(
            new list<String> {'Account','Opportunity'},
            new list<String> {'Account','Opportunity'},
            new list<boolean> {true, false},
            //new list<String> {'Name', 'Name'},
            new list<String> {'Name:1', 'Name:0'}
        ));
        
        insert ultraTrackContainerList;
        
        // Created list of history wrapper records.
        historyList.addAll(TestDataFactory.getHistoryList(new list<String> {'a@b.com','c@b.com'},
                                                          new list<String> {'c@b.com','a@b.com'},
                                                          String.ValueOf(accountObj.Id),
                                                          UserInfo.getUserId(),
                                                          new list<DateTime> {System.now(),
                                                                             System.now()}
                                                         ));
                           
        String attachmentBodyForAccount = '{"Name":' + System.JSON.serialize(historyList); 
        attachmentBodyForAccount += '},"Email__c":{[]}';
        String attachmentBodyForOpportunity = '{"Name":{[]}}';
        
        String strDate = String.valueOf(todayDate.month() + 100).right(2) + '/'
                       + String.valueOf(todayDate.day() + 100).right(2) + '/'
                       + String.valueOf(todayDate.year());

        // Inserted list of attachment for Ultra_Track_Container records.
        attachmentList.addAll(TestDataFactory.getAttachementList(
            new list<String> {Label.AttachmentFileName + 'SD' + strDate,
                              Label.AttachmentFileName + 'SD' + strDate + 'ED' + strDate,
                              Label.AttachmentFileName
                             },
            new list<blob> {blob.valueOf(attachmentBodyForAccount), 
                            blob.valueOf(attachmentBodyForAccount),
                            blob.valueOf(attachmentBodyForOpportunity)
                           },
            new list<Id> {ultraTrackContainerList[0].Id,
                          ultraTrackContainerList[0].Id,
                          ultraTrackContainerList[1].Id
                         }
        ));
        insert attachmentList;
        
        TestUtil.checkAssertsForSetupData('Account', 1);
        TestUtil.checkAssertsForSetupData('Ultra_Track_Container__c', ultraTrackContainerList.size());
        TestUtil.checkAssertsForSetupData('Attachment', attachmentList.size());
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Method to create a test data and test getOwdForAnObject method.
      * @Param: 1. objectName: Name of Object to be passed to method.
      *         2. expectedObjectName: Expected name of object method will return.
      *         3. expectedFieldName: Expected name of field name method will return.
      *         4. expectedBoolean: Expected value for object access.
      * @Return: NA
      * @Date: 12/04/2016
      **/
    static void getOwdForAnObjectTest(String objectName, 
                                      String expectedObjectName,
                                      String expectedFieldName,
                                      String expectedBoolean) {
        
        map<boolean, list<String>> result = new map<boolean, list<String>>();
            
        Test.startTest();
        result = UltraTrackUtility.getOwdForAnObject(objectName);
        Test.stopTest();
        
        if(!result.isEmpty()) {
            if(result.containsKey(true)){
                System.assert(result.containsKey(true));
                list<String> resultList = result.get(true);
                System.assertEquals(resultList[0], expectedObjectName);
                System.assertEquals(resultList[1], expectedFieldName);
                System.assertEquals(resultList[2], expectedBoolean);
            }
            else {
                System.assert(result.containsKey(false));
                System.assertEquals(result.get(false)[0], expectedBoolean);
            }
        }
        else {
            System.assert(result.isEmpty());
        }
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Method to create a test data and test getSharing method.
      * @Param: 1. sObjectInstance: sobject instance for which we need method returns users who have access to this sObject.
      *         2. numberOfUser: Number of user need to be created.
      *         3. objectDetails: Share Object details.
      *         4. isIdNeedsToBePassed: Boolean value to check is sObject Id need to pass to method or not.
      *         5. expectedNumberOfUser: Expected number of user who have access to sObject.
      * @Return: NA
      * @Date: 12/04/2016
      **/
    static void getSharingTest(sObject sObjectInstance, 
                               Integer numberOfUser,
                               list<String> objectDetails,
                               String isIdNeedsToBePassed,
                               Integer expectedNumberOfUser) {
                               
        map<Id, set<Id>> recordIdVsUserOrGroupIdSetMap = new map<Id, set<Id>>();
        Id user1Id, user2Id, shareWithId, sObjectId;
        User user1, user2;
        if(sObjectInstance != null) {
            insert sObjectInstance;
        }
        sObjectId = (Id)sObjectInstance.get('Id');
        if(numberOfUser > 0) {
            Profile p = [SELECT Id 
                         FROM Profile 
                         WHERE Name = 'Standard User'];
                         
            if(numberOfUser > 1) {
                Group groupObj1;
                user1 = TestDataFactory.getUser('User1', 'user1', 'test@user1.come', p.Id);
                user2 = TestDataFactory.getUser('User2', 'user2', 'test@user2.come', p.Id);
                System.runAs(user1) {
                    user1Id = UserInfo.getUserId();
                } 
                System.runAs(user2) {
                    user2Id = UserInfo.getUserId();
                    
                    groupObj1 = TestDataFactory.getGroup('Test1', 'TestGroup1');
                    insert groupObj1;
        
                    list<GroupMember> groupMemberList = TestDataFactory.getGroupMemeber(groupObj1.Id, new set<Id> {user1Id, user2Id});
                    insert groupMemberList; 
                } 
                
                shareWithId = groupObj1.Id;
            }
            else if(numberOfUser == 1) {
                user1 = TestDataFactory.getUser('User1', 'user1', 'test@user1.come', p.Id);
                System.runAs(user1) {
                    user1Id = UserInfo.getUserId();
                } 
                shareWithId = user1Id;
            }
            
        }
        if(shareWithId != null) {
            Sharing_Purpose__share accShareObj = TestDataFactory.getSharing_PurposeSharing(shareWithId, sObjectId, 'Edit');
            insert accShareObj;
        }
        Test.startTest();
        if(isIdNeedsToBePassed == null) {
            recordIdVsUserOrGroupIdSetMap = UltraTrackUtility.getSharing(objectDetails, 
                                                                         null);
        }
        else if(isIdNeedsToBePassed.equals('Pass')) {
            recordIdVsUserOrGroupIdSetMap = UltraTrackUtility.getSharing(objectDetails, 
                                                                         new set<Id> {sObjectId});
        }
        else {
            recordIdVsUserOrGroupIdSetMap = UltraTrackUtility.getSharing(objectDetails, 
                                                                         new set<Id> ());
        }
        Test.stopTest();
        
        if(!recordIdVsUserOrGroupIdSetMap.isEmpty()) {
            System.assert(!recordIdVsUserOrGroupIdSetMap.isEmpty());
            System.assertEquals(expectedNumberOfUser, recordIdVsUserOrGroupIdSetMap.get(sObjectId).size());
            set<Id> userIdSet =  recordIdVsUserOrGroupIdSetMap.get(sObjectId);
            System.assert(userIdSet.contains(UserInfo.getUserId())); 
            if(user1Id != null) {
                System.assert(userIdSet.contains(user1Id)); 
            }
            if(user2Id != null) {
                System.assert(userIdSet.contains(user2Id)); 
            }
        }
        else {
            System.assert(recordIdVsUserOrGroupIdSetMap.isEmpty());
        }
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Method to create a test data and test getSharing method.
      * @Param: 1. numberOfUser: Number of user need to be created.
      *         2. isIdNeedsToBePassed: Boolean value to check is sObject Id need to pass to method or not.
      * @Return: NA
      * @Date: 12/04/2016
      **/
    static void getSubGroupDetailsTest(Integer numberOfUser,
                                       String isIdNeedsToBePassed) {
                               
        Id user1Id, user2Id, user3Id;
        User user1, user2, user3;
        Group groupObj1, groupObj2, groupObj3;
        map <Id, set<Id>> groupIdVsUserIdSetMap = new map <Id, set<Id>>();
        set<Id> groupIdSet = new set<Id>();
        
        if(numberOfUser > 0) {
            Profile p = [SELECT Id 
                         FROM Profile 
                         WHERE Name = 'Standard User'];
                         
            if(numberOfUser > 1) {
                user1 = TestDataFactory.getUser('User1', 'user1', 'test@user1.come', p.Id );
                user2 = TestDataFactory.getUser('User2', 'user2', 'test@user2.come', p.Id );
                System.runAs(user1) {
                    user1Id = UserInfo.getUserId();
                }
                System.runAs(user2) {
                    user2Id = UserInfo.getUserId();
                }
                groupObj1 = TestDataFactory.getGroup('Test', 'TestGroup');
                insert groupObj1;
            
                list<GroupMember> groupMemberList = TestDataFactory.getGroupMemeber(groupObj1.Id, new set<Id> {user1Id, user2Id});
                insert groupMemberList;
                groupIdSet.add(groupObj1.Id);
            }
            else if(numberOfUser > 2) {
                user1 = TestDataFactory.getUser('User1', 'user1', 'test@user1.come', p.Id );
                user2 = TestDataFactory.getUser('User2', 'user2', 'test@user2.come', p.Id );
                user3 = TestDataFactory.getUser('User3', 'user3', 'test@user3.come', p.Id );
                System.runAs(user1) {
                    user1Id = UserInfo.getUserId();
                    
                }
                System.runAs(user2) {
                    user2Id = UserInfo.getUserId();
                }
                
                System.runAs(user3) {
                    user3Id = UserInfo.getUserId();
                }
                groupObj1 = TestDataFactory.getGroup('Test1', 'TestGroup1');
                insert groupObj1;
                
                groupObj2 = TestDataFactory.getGroup('Test2', 'TestGroup2');
                insert groupObj2;
                
                groupObj3 = TestDataFactory.getGroup('Test3', 'TestGroup3');
                insert groupObj3;
            
                list<GroupMember> groupMemberList = TestDataFactory.getGroupMemeber(groupObj3.Id, new set<Id> {user3Id});
                groupMemberList.addAll(TestDataFactory.getGroupMemeber(groupObj2.Id, new set<Id> {user1Id}));
                groupMemberList.addAll(TestDataFactory.getGroupMemeber(groupObj1.Id, new set<Id> {user2Id, groupObj2.Id, groupObj3.Id}));
                insert groupMemberList;
                groupIdSet.add(groupObj1.Id);
                groupIdSet.add(groupObj2.Id);
                groupIdSet.add(groupObj3.Id);
            }
            
        }
        Test.startTest();
         if(isIdNeedsToBePassed == null) {
            groupIdVsUserIdSetMap = UltraTrackUtility.getSubGroupDetails(null);
        }
        else if(isIdNeedsToBePassed.equals('Pass')) {
            groupIdVsUserIdSetMap = UltraTrackUtility.getSubGroupDetails(groupIdSet);
        }
        else {
            groupIdVsUserIdSetMap = UltraTrackUtility.getSubGroupDetails(new set<Id>());
        }
        Test.stopTest();
        
        if(!groupIdVsUserIdSetMap.isEmpty()) {
            if(groupIdSet.size() == 1) {
                System.assert(groupIdVsUserIdSetMap.containsKey(groupObj1.Id));
                System.assertEquals(2, groupIdVsUserIdSetMap.get(groupObj1.Id).size());
                set<Id> userIdSet =  groupIdVsUserIdSetMap.get(groupObj1.Id);
                System.assert(userIdSet.contains(user1Id)); 
                System.assert(userIdSet.contains(user2Id)); 
            }
            else {
                System.assert(groupIdVsUserIdSetMap.containsKey(groupObj1.Id));
                System.assertEquals(3, groupIdVsUserIdSetMap.get(groupObj1.Id).size());
                set<Id> userIdSet1 =  groupIdVsUserIdSetMap.get(groupObj1.Id);
                System.assert(userIdSet1.contains(user1Id)); 
                System.assert(userIdSet1.contains(user2Id)); 
                System.assert(userIdSet1.contains(user3Id)); 
                
                System.assert(groupIdVsUserIdSetMap.containsKey(groupObj2.Id));
                System.assertEquals(1, groupIdVsUserIdSetMap.get(groupObj2.Id).size());
                set<Id> userIdSet2 =  groupIdVsUserIdSetMap.get(groupObj2.Id);
                System.assert(userIdSet2.contains(user1Id));
            }
        }
        else {
            System.assert(groupIdVsUserIdSetMap.isEmpty());
        }
    }
    /**
      * @Author: Eternus Solutions
      * @Description: Method to create invalid test data for getOwdForAnObject method.
      * @Return: Method should return list of Object name
      * @Date: 22/07/2016
      **/
    static List<String> getOwdForAnObjectData() {
        return (new list<String>{'ABC', '', null});
    }
    
    /**
      * @Author: Eternus Solutions
      * @Description: Method to test blank and null values in test class.
      * @Return: Method should return list of values.
      * @Date: 22/07/2016
      **/
    static List<String> getInvalidData() {
        return (new list<String>{'', null});
    }
    
    
    /**
      * @Author: Eternus Solutions
      * @Description: Method to create valid and invalid test data for getFieldNamesAndLabels.
      * @Return: Method should return list of values
      * @Date: 22/07/2016
      **/
    static List<String> getFieldNamesAndLabelsData() {
        list<String> fieldNamesAndLabelsDateList = new list<String>{'Case', null, '', 'ABC'};
        return fieldNamesAndLabelsDateList;
    }
    
    /**
      * @Author: Eternus Solutions
      * @Description: Method to create valid and invalid test data for getFieldType.
      * @Return: Method should return list of values
      * @Date: 22/07/2016
      **/
    static List<String> getObjectForFieldTypeMethod() {
        list<String> objectForFieldTypeList = new list<String>{'Account', null, ''};
        return objectForFieldTypeList;
    }
    
    /**
      * @Author: Eternus Solutions
      * @Description: Method to create valid and invalid test data for getFieldType.
      * @Return: Method should return list of values
      * @Date: 22/07/2016
      **/
    static List<String> getFieldForFieldTypeMethod() {
        list<String> fieldForFieldTypeList = new list<String>{'Rating', null, ''};
        return fieldForFieldTypeList;
    }
    
    /**
      * @Author: Eternus Solutions
      * @Description: Method to create valid and invalid test data for replaceString.
      * @Return: Method should return list of values
      * @Date: 22/07/2016
      **/
    static list<list<String>> getReplaceStringData() {
        list<list<String>> replaceStringDataList = 
                           new list<list<String>>{ new list<String> {'BCD1234 xyz345','\\p{Upper}', null},
                                                   new list<String> {'BCD1234 xyz345',null, '*'},
                                                   new list<String> {null,'\\p{Upper}', '*'},
                                                   new list<String> {null,'\\p{Upper}', null},
                                                   new list<String> {null, null, '*'},
                                                   new list<String> {null, null, null},
                                                   new list<String> {'', '', ''},
                                                   new list<String> {'', '', '*'},
                                                   new list<String> {'', '\\p{Upper}', ''},
                                                   new list<String> {'','\\p{Upper}', '*'},
                                                   new list<String> {'BCD1234 xyz345','', '*'} };
        return replaceStringDataList;
    }
    
    /**
      * @Author: Eternus Solutions
      * @Description: Method to create valid and invalid test data for displayMessage.
      * @Return: Method should return list of ApexPages.severity.
      * @Date: 22/07/2016
      **/
     static list<ApexPages.severity> getSeverityForDisplayMessageData() {
        return new list<ApexPages.severity> {null, ApexPages.severity.CONFIRM};
    }
    
    /**
      * @Author: Eternus Solutions
      * @Description: Method to create valid and invalid test data for displayMessage.
      * @Return: Method should return list of message String.
      * @Date: 22/07/2016
      **/
     static list<String> getMessageForDisplayMessageData() {
        return new list<String> {'Record Saved.', null, ''};
    }
    /**
      * @Author: Eternus Solutions
      * @Description: Method to create invalid test data  checkCurrencyOrPercentField.
      * @Return: Method should return list of list<String>.
      * @Date: 22/07/2016
      **/
   /* static list<list<String>> checkCurrencyOrPercentFieldData() {
        list<list<String>> checkCurrencyOrPercentFieldDataList = 
                           new list<list<String>>{ new list<String> {'UFHT__Sharing_Purpose__c', '', '1234', '4222'},
                                                   new list<String> {'', 'UFHT__EncryptedString_Field__c', '1234', '4222'},
                                                   new list<String> {'ABC', 'UFHT__EncryptedString_Field__c', '1234', '4222'} };
        return checkCurrencyOrPercentFieldDataList;
    }*/
    
    /**
      * @Author: Eternus Solutions
      * @Description: Method to create invalid test data checkCurrencyOrPercentField.
      * @Return: Method should return list of list<set<Id>>
      * @Date: 22/07/2016
      **/
    static list<set<Id>> getSubGroupDetailsData() {
        return new list<set<Id>>{null, new set<Id>()};
    }
    
     /**
      * @Author: Eternus Solutions
      * @Description: Method to create valid and invalid test data getCurrencyIsoCode.
      * @Return: Method should return list of sObject
      * @Date: 22/07/2016
      **/
    static list<sObject> getCurrencyIsoCodeData() {
        return new list<sObject> {null, UltraTrackUtility.sobjectMap.get('UFHT__Sharing_Purpose__c').newsObject()};
    }
    
    /**
      * @Author: Eternus Solutions
      * @Description: Method to create test data for maskEncryptedData method.
      * @Param: 1. isInsertCustomSetting: Boolean value to check if custom setting need to be insert or not. 
      *         2. encryptedFieldType: Type of encrypted field.
      *         3. encryptedFieldRegularExp: Regular expression for encrypted field.
      *         4. fieldDescribe: Describe object for field.
      *         5. oldValue: Old value for field.
      *         6. newValue: New value for field.
      * @Return: Method should return list of string of old and new value.
      * @Date: 22/07/2016
      **/
    static list<String> getMaskEncryptedTestData(Boolean isInsertCustomSetting,
                                                 String encryptedFieldType,
                                                 String encryptedFieldRegularExp,
                                                 Schema.DescribeFieldResult fieldDescribe,
                                                 String oldValue,
                                                 String newValue) {
        
         if(isInsertCustomSetting) {
             UFHT__Encrypted_Field_Mask__c fieldMaskObj = TestDataFactory.getEncryptedFieldMask(encryptedFieldType, 
                                                                                                 encryptedFieldRegularExp);
             insert fieldMaskObj ;
         }

         return (UltraTrackUtility.maskEncryptedData(fieldDescribe, 
                                                     oldValue, 
                                                     newValue
                                                     )
                );
    }
    
    /**
      * @Author: Eternus Solutions
      * @Description: Method to create test data for maskEncryptedData method.
      * @Param: 1. isInsertCustomSetting: Boolean value to check if custom setting need to be insert or not. 
      *         2. filterName: Name of filter
      *         3. filterValue: Default value for filter.
      *         4. filterCategory: Category of the filter
      *         5. srNo: Serial number for filter.
      * @Return: Method should return list of Ultra_Track_Container records.
      * @Date: 22/07/2016
      **/
    static list<Ultra_Track_Container__c> getStartAndEndDateForFilterestData(Boolean isInsertCustomSetting,
                                                                             String filterName,
                                                                             String filterValue,
                                                                             String filterCategory,
                                                                             Integer srNo) {
        
         if(isInsertCustomSetting) {
             list<View_Field_History_Date_Filters__c> dateFileterList = TestDataFactory.getDateFilters(filterName, filterValue, filterCategory, srNo);
             insert dateFileterList;
         }

         return ( UltraTrackUtility.getStartAndEndDateForFilter(filterName));
    }
    
    /**
      * @Author: Eternus Solutions
      * @Description:  Test Case to check assert invalid, null and blank scenario.
      * @Expected Result: Method should check expected results with actual result
      * @Date: 25/07/2016
      **/ 
    static void checkAssertForGetStartAndEndDateForFilter(list<Ultra_Track_Container__c> startEndDateList) {
         if(startEndDateList.isEmpty()) {
           System.assert(startEndDateList.isEmpty());
         } 
    }
    
    /**
      * @Author: Eternus Solutions
      * @Description:  Test Case to check assert invalid, null and blank scenario.
      * @Param: result: Set of Ids
      * @Date: 25/07/2016
      **/ 
    static void checkAssertForGetAllSubRoleIds(set<Id> result) {
         if(result.isEmpty()) {
           System.assert(result.isEmpty());
         } 
    }
    
    /**
      * @Author: Eternus Solutions
      * @Description:  Test Case to check assert invalid, null and blank scenario.
      * @Param: userIdVsAllManagerIdMap: Map of Id to Set of Ids.
      * @Date: 25/07/2016
      **/ 
    static void checkAssertForGetAllManagersForUser(map<Id, Set<Id>> userIdVsAllManagerIdMap) {
         if(userIdVsAllManagerIdMap.isEmpty()) {
           System.assert(userIdVsAllManagerIdMap.isEmpty());
         } 
    }
    
    /**
      * @Author: Eternus Solutions
      * @Description:  Test Case to check assert invalid, null and blank scenario.
      * @param: fieldName: Name of the field
      * @Date: 25/07/2016
      **/ 
    static void checkAssertForGetNameUniqueField(String fieldName) {
        System.assertEquals(fieldName, '');
    }
    
    /**
      * @Author: Eternus Solutions
      * @Description:  Test Case to check assert invalid, null and blank scenario.
      * @Expected Result: Method should check expected results with actual result
      * @Date: 25/07/2016
      **/ 
    static void checkAssertForGetFieldNamesAndLabels(map<String, String> fieldNameVsLabelMap) {
        if(fieldNameVsLabelMap.isEmpty()) {
           System.assertEquals(0, fieldNameVsLabelMap.size());
        }
        else {
           System.assertNotEquals(0, fieldNameVsLabelMap.size());
        }
    }
    
    /**
      * @Author: Eternus Solutions
      * @Description:  Test Case to check assert invalid, null and blank scenario.
      * @Expected Result: Method should check expected results with actual result
      * @Date: 25/07/2016
      **/ 
    static void checkAssertForGetFieldType(Schema.DisplayType fieldType) {
       if(fieldType == null) {
           System.assertEquals(fieldType, null);
       }
       else {
          System.assert(String.valueOf(fieldType).equalsIgnoreCase('PICKLIST'));   
       }
    }
    
    /**
      * @Author: Eternus Solutions
      * @Description:  Test Case to check assert invalid, null and blank scenario.
      * @Expected Result: Method should check expected results with actual result
      * @Date: 25/07/2016
      **/ 
    static void checkAssertForreplaceString(String replacedStr) {
       if(String.isBlank(replacedStr)) {
           System.assertEquals(replacedStr, '');
       }
    }
    
    /**
      * @Author: Eternus Solutions
      * @Description:  Test Case to check assert invalid, null and blank scenario.
      * @Expected Result: Method should check expected results with actual result
      * @Date: 25/07/2016
      **/ 
    static void checkAssertForDisplayMessage() {
         if(!ApexPages.hasMessages()) {
           System.assert(!ApexPages.hasMessages());
         } 
         else {
            ApexPages.Message[] pageMessages = ApexPages.getMessages();
            System.assertEquals(1, pageMessages.size());
        
            System.assertEquals(ApexPages.severity.CONFIRM, pageMessages[0].getSeverity());
            System.assertEquals('Record Saved.', pageMessages[0].getSummary());
         }
    }
    
    /**
      * @Author: Eternus Solutions
      * @Description:  Test Case to check assert invalid, null and blank scenario.
      * @Expected Result: Method should check expected results with actual result
      * @Date: 25/07/2016
      **/ 
    static void checkAssertForcheckCurrencyOrPercentField(list<String> fieldValue) {
         if(fieldValue.isEmpty()) {
           System.assert(fieldValue.isEmpty());
         } 
    }
    
    /**
      * @Author: Eternus Solutions
      * @Description:  Test Case to check assert invalid, null and blank scenario.
      * @Expected Result: Method should check expected results with actual result
      * @Date: 25/07/2016
      **/ 
    static void checkAssertForgetFieldTypeSchema(map<String, Schema.sObjectField> fieldSchemaMap) {
         if(fieldSchemaMap == null) {
           System.assertEquals(fieldSchemaMap, null);
         } 
         else if(fieldSchemaMap.isEmpty()) {
            System.assert(fieldSchemaMap.isEmpty()); 
         }
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Method to test Attachment records when with valid and invalid scenarios.
      * @Param: 1. modifyStartDate - Boolean to verify start date should be modified or not
      *         2. isStartDate - Boolean to verify start date should be calculated or not
      *         3. isEndDate - Boolean to verify end date should be calculated or not
      *         4. selectedObjectId - Boolean to verify Id of Account Object should be retrieve or not
      *         5. strOffset - Offset for a date
      * @Date: 08/07/2016
      **/
    static void getAttachmentTest(Boolean modifyStartDate, Boolean isStartDate, Boolean isEndDate, 
                              Boolean selectedObjectId, String strOffset) {
    
        String strStartDate;
        String strEndDate;
        Id objId;
    
        if(selectedObjectId) {
            objId = [SELECT Id 
                    FROM UFHT__Ultra_Track_Container__c  
                    WHERE UFHT__Object_Name__c = 'Account' 
                    LIMIT 1][0].Id;
        }
        if(isStartDate) {
            String strDay = String.valueOf(System.today().day());
            String strMonth = String.valueOf(System.today().month());
            String strYear = String.valueOf(System.today().year());
            strStartDate = strDay+'/'+strMonth+'/'+strYear;  
        }
        if(isEndDate) {
            String strDay = String.valueOf(System.today().day());
            String strMonth = String.valueOf(System.today().month());
            String strYear = String.valueOf(System.today().year());
            strEndDate = strDay+'/'+strMonth+'/'+strYear;  
        }
        
        Test.startTest();
        Attachment objAttachment = UltraTrackUtility.getAttachment(String.valueOf(objId), strStartDate, strEndDate, strOffset);
        Test.stopTest();
    
        if(modifyStartDate) {
            strStartDate = String.valueOf(System.today().month()+100).right(2)+'/'
                            + String.valueOf(System.today().day()+100).right(2)+'/'
                            + String.valueOf(System.today().year());
        
            System.assert(objAttachment.Name.containsIgnoreCase(Label.AttachmentFileName+'SD'+strStartDate));
        }
        else {
            System.assert(String.isBlank(objAttachment.Name));
        }
    }
    
    /**
      * @Author: Eternus Solutions
      * @Description: Method to test record count of an attachments with valid and invalid scenarios
      * @Param: 1. idSelectedObjectId - Boolean to verify if instance of an Object should be created or not.
      *         2. isStartDate - Boolean to verify if Start date should get ctreated or not.
      *         3. isEndDate - Boolean to verify if End date should get ctreated or not.
      *         4. addDaysToStartDate - No. of days to be added in start date.
      *         5. addDaysToEndDate - No. of days to be added in end date.
      *         6. expectedRecordCount - Expected record count of an attachments.
      * @Date: 08/07/2016
      **/
    static void getRecordCountTest(Boolean idSelectedObjectId, Boolean isStartDate, Boolean isEndDate, 
                                Integer addDaysToStartDate, Integer addDaysToEndDate, Integer expectedRecordCount) {
        String strStartDate;
        String strEndDate;
        Id objId;
    
        if(idSelectedObjectId) {
            objId = [SELECT Id 
                    FROM UFHT__Ultra_Track_Container__c  
                    WHERE UFHT__Object_Name__c = 'Account' 
                    LIMIT 1][0].Id;
        }
        if(isStartDate) {
            strStartDate = String.valueOf(System.today().day() + addDaysToStartDate) + '/' 
                           + String.valueOf(System.today().month()) +'/'
                           + String.valueOf(System.today().year());   
        }
        if(isEndDate) {
            strEndDate = String.valueOf(System.today().day() + addDaysToEndDate) + '/' 
                         + String.valueOf(System.today().month()) + '/'
                         + String.valueOf(System.today().year());  
        }
        Test.startTest();
        Integer recordCount = UltraTrackUtility.getAttachmentRecordCount(String.valueOf(objId),
                                                                         strStartDate, 
                                                                         strEndDate);
        Test.stopTest();
        System.assertEquals(expectedRecordCount, recordCount);
    }
    
    /**
      * @Author: Eternus Solutions
      * @Description: Method to get created date of attachment for pass Id and sort order.
      * @Param: 1. isSelectedObjectId - Boolean to verify Id of an Object should be created or not.
      *         2. isAttchObj - Boolean to verify attachment should be created or not.
      *         3. dateFilter - Sorting order to date filter.
      * @Date: 08/07/2016
      **/
    static void getAttachmentCreatedDateTest(Boolean isSelectedObjectId, Boolean isAttchObj, String dateFilter) {
        Id objId;
    
        if(isSelectedObjectId) {
            objId = [SELECT Id 
                    FROM UFHT__Ultra_Track_Container__c  
                    WHERE UFHT__Object_Name__c = 'Account' 
                    LIMIT 1][0].Id; 
        }
    
        Test.startTest();
        Date resultDate = UltraTrackUtility.getAttachmentCreatedDate(String.valueOf(objId), dateFilter); 
        Test.stopTest();
    
        if(isAttchObj && String.isNotBlank(dateFilter)) {
            Attachment attchObj = [SELECT Id, CreatedDate
                                   FROM Attachment
                                   WHERE ParentId =: objId
                                   ORDER by CreatedDate
                                   limit 1];
            System.assertEquals(date.newinstance(attchObj.createdDate.year(), attchObj.createdDate.month(), attchObj.createdDate.day()), resultDate);
        }
        else {
            System.assertEquals(resultDate, null);
        }
    }
    
    /**
      * @Author: Eternus Solutions
      * @Description: Method to create Ultra_Track_Container__c object with valid and invalid scenarios.
      * @Param: 1. objectName - Name of the Object
      *         2. isTrackingEnabled - Boolean value to enable tracking.
      * @Date: 09/08/2016
      **/
    static void getTrackedObjectsTest(String objectName, Boolean isTrackingEnabled) {
        
        List<Ultra_Track_Container__c>  trackContainerList;
        Ultra_Track_Container__c trackContainerObj = new Ultra_Track_Container__c(UFHT__Object_Label__c = objectName,
                                                                                  UFHT__Object_Name__c = objectName,
                                                                                  UFHT__Is_Tracking_Enabled__c = isTrackingEnabled);
        insert trackContainerObj;
        Test.StartTest();
        list<SelectOption> objectSelectedOptionsList = UltraTrackUtility.getTrackedObjects();
        Test.StopTest();
        trackContainerList = [SELECT ID, UFHT__Object_Name__c
                              FROM Ultra_Track_Container__c
                              WHERE UFHT__Object_Name__c =: objectName
                              AND UFHT__Is_Tracking_Enabled__c = true];
        if(isTrackingEnabled && String.isNotBlank(objectName)) {
            System.assertEquals(1, trackContainerList.size());
        }
        else {
            System.assertEquals(0, trackContainerList.size());
        }
    }
    
    /**
      * @Author: Eternus Solutions
      * @Description: Method to create SelectOption list of Object.
      * @Param: 1. emptyList - Boolean to verify if an empty list should be passed or not
      *         2. onlyOneItemInList - Boolean to verify if list with one element should be passed or not
      *         3. moreThanOneItem - Boolean to verify if list with multiple elements should be passed or not
      *         3. expectedOutput - expected output of the list
      * @Date: 09/08/2016
      **/
    static void getFirstObjectTest(Boolean emptyList, Boolean onlyOneItemInList, 
                                   Boolean moreThanOneItem, String expectedOutput) {
        list<SelectOption> objectList;
        
        if(emptyList) {
            objectList = new list<SelectOption>{};
        }
        if(onlyOneItemInList) {
            objectList = new list<SelectOption>{new SelectOption('Object1', 'Object1')};
        }
        if(moreThanOneItem) {
            objectList = new list<SelectOption>{new SelectOption('Object3', 'Object3'),
                                                new SelectOption('Object2', 'Object2'),
                                                new SelectOption('Object3', 'Object3')};
        }
        
        Test.StartTest();
        String objectNameAfterSorting = UltraTrackUtility.getFirstObject(objectList);
        Test.StopTest();
        
        System.assertEquals(objectNameAfterSorting, expectedOutput);
    }
    
    /**
      * @Author: Eternus Solutions
      * @Description:  Test Case to check assert valid and null scenario.
      * @Expected Result: Method should check expected results with actual result
      * @Date: 25/07/2016
      **/ 
    static void checkAssertForGetCurrencySymbol(String currencySymbol) {
         if(String.isBlank(currencySymbol)) {
           System.assertEquals(currencySymbol, '');
         }
        else {
            System.assertEquals(currencySymbol,                
                                UltraTrackUtility.getCurrencyIsoCode(UltraTrackUtility.sobjectMap.get('UFHT__Sharing_Purpose__c').newsObject())); 
        }
    }
    
    /**
      * @Author: Eternus Solutions
      * @Description:  Test Case to check assert valid and null scenario.
      * @Expected Result: Method should check expected results with actual result
      * @Date: 25/07/2016
      **/ 
    static void checkAssertForGetCurrencyIsoCode(String currencySymbol) {
         if(String.isBlank(currencySymbol)) {
           System.assertEquals(currencySymbol, '');
         }
        else {
            System.assertEquals(currencySymbol, UserInfo.isMultiCurrencyOrganization()
                                ? (String)UltraTrackUtility.sobjectMap.get('UFHT__Sharing_Purpose__c').newsObject().get(UFHTConstants.CURRENCY_ISO_CODE)
                                : UserInfo.getDefaultCurrency()
                                );   
        }
    }
    
    /**
      * @Author: Eternus Solutions
      * @Description: Method to test Insert/Update is allowed for Custom Setting object and fields or not.
      * @Param: 1. objectname - Name of an Object.
      *         2. checkDML - DML operation which need to be performed on field.
      *         3. expectedOutput - Expected output which is a boolean value.
      *                             Returns true if field have insert/update access else false
      * @Date: 10/08/2016
      **/
    static void insertDMLForCustomSettingTest(String objectname, String checkDML, Boolean expectedOutput) {
        Test.StartTest();
        Boolean isObjCreateable = UltraTrackUtility.isAllowDMLForCustomSetting(objectname, checkDML);
        Test.StopTest();
        System.assertEquals(expectedOutput, isObjCreateable);
    }
    
    /** 
      * @Author: Eternus Solutions
      * @description: Method to test Attachment records when Id and invalid offset 
      *               are provided with null start and end date.
      * @Expected Result: Method will not assign any value to attachment.
      * @Date: 08/07/2016
      **/
    static testMethod void getAttachmentTestCaseWhenOffsetisInvalid1() {
        
        Id objId = [SELECT Id 
                    FROM UFHT__Ultra_Track_Container__c  
                    WHERE UFHT__Object_Name__c = 'Account' 
                    LIMIT 1][0].Id;
        
        Test.startTest();
 
        Attachment objAttachment = UltraTrackUtility.getAttachment(String.valueOf(objId),
                                                                   null, 
                                                                   null, 
                                                                   'abc');
        
        Test.stopTest();  
        
        System.assert(String.isBlank(objAttachment.Name));
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Test method to test getOwdForAnObject with the following scenario:
      *               Pass standard Object name as parameter
      * @Return: Method should return opportunity share object name, fieldName and isCustom false.
      * @Date: 12/04/2016
      **/
    static testMethod void getOwdForAnObjectTestCase1() {
        
        getOwdForAnObjectTest('Opportunity', 
                              'Opportunityshare',
                              'OpportunityId',
                              'false');
    }
     
    /** 
      * @Author: Eternus Solutions
      * @Description: Test method to test getOwdForAnObject with the following scenario:
      *               Pass custom Object name as parameter
      * @Expected Result: Method should return custom object share object name, fieldName and isCustom true.
      * @Date: 12/04/2016
      **/
     static testMethod void getOwdForAnObjectTestCase2() {
        
        getOwdForAnObjectTest(System.Label.Package_Prefix + '__' + System.Label.Sharing_Purpose, 
                              'UFHT__Sharing_Purpose__share',
                              'ParentId',
                              'true');
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Test method to test getOwdForAnObject with the following scenario:
      *               Object is custom object name having open OWD as parameter
      * @Expected Result: Method should return true as it is open OWD.
      * @Date: 12/04/2016
      **/
    static testMethod void getOwdForAnObjectTestCase3() {
        
        getOwdForAnObjectTest(System.Label.Package_Prefix + '__' + System.Label.Ultra_Track_Container, 
                              '',
                              '',
                              'true');
    }
    
    /**
      * @Author: Eternus Solutions
      * @description : Test method to test getOwdForAnObject with the invalid object name.
      * @Expected result : Method should return empty map.
      * @Date: 23/07/2016
      **/
    static testMethod void getOwdForAnObjectTestCase4() {
        getOwdForAnObjectTest('ABC', '', '', '');
    }
    
    /**
      * @Author: Eternus Solutions
      * @description : Test method to test getOwdForAnObject with the null object name.
      * @Expected result : Method should return empty map.
      * @Date: 23/07/2016
      **/
    static testMethod void getOwdForAnObjectTestCase5() {
        getOwdForAnObjectTest(null, '', '', '');
    }
    
    /**
      * @Author: Eternus Solutions
      * @description : Test method to test getOwdForAnObject with the blank object name.
      * @Expected result : Method should return empty map.
      * @Date: 23/07/2016
      **/
    static testMethod void getOwdForAnObjectTestCase6() {
        getOwdForAnObjectTest('', '', '', '');
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Test method to test getSharing with the following scenario.
      *               Valid sObjectInstance, noOfUser, Objectlist, Id
      * @Expected Result: Method should return users who have access to record.
      * @Date: 12/04/2016
      **/
    static testMethod void getSharingTestCase1() {
        
        getSharingTest((sObject)TestDataFactory.getAccount('TestAccount'), 
                       0,
                       new list<String> {'accountshare', 'AccountId', 'false'},
                       'Pass',
                       1);
    }
    /** 
      * @Author: Eternus Solutions
      * @Description: Test method to test getSharing with the following scenario.
      *               Sharing_Purpose share object name, fieldName, isCustom and record Id.
      *               Records of Sharing_Purpose object shared with one user.
      * @Expected Result: Method should return users who have access to record.
      * @Date: 12/04/2016
      **/
    static testMethod void getSharingTestCase2() {
        
        getSharingTest((sObject)TestDataFactory.getSharing_Purpose('test1'), 
                       1,
                       new list<String> {'Sharing_Purpose__share', 'ParentId', 'true'},
                       'Pass',
                       2);
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Test method to test getSharing with the following scenario.
      *               Sharing_Purpose share object name, fieldName, isCustom and record Id.
      *               Records of Sharing_Purpose object shared with group.
      * @Expected Result: Method should return users who have access to record.
      * @Date: 12/04/2016
      **/
    static testMethod void getSharingTestCase3() {
        
        getSharingTest((sObject)TestDataFactory.getSharing_Purpose('test1'), 
                       2,
                       new list<String> {'Sharing_Purpose__share', 'ParentId', 'true'},
                       'Pass',
                       3);
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Test method to test getSharing with the following scenario.
      *               Pass list of object details and set of record Id as empty
      * @Expected Result: Method should return empty map.
      * @Date: 12/04/2016
      **/
    static testMethod void getSharingTestCase4() {
        
        getSharingTest((sObject)TestDataFactory.getSharing_Purpose('test1'), 
                       0, new list<String> (), '', 0);
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Test method to test getSharing with the following scenario.
      *               Pass empty list of object details and set of record Id.
      * @Expected Result: Method should return empty map.
      * @Date: 12/04/2016
      **/
    static testMethod void getSharingTestCase5() {
        
        getSharingTest((sObject)TestDataFactory.getAccount('TestAccount'), 
                       0, new list<String> (), 'Pass', 0);
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Test method to test getSharing with the following scenario.
      *               Pass list of object details and empty set of record Id.
      * @Expected Result: Method should return empty map.
      * @Date: 12/04/2016
      **/
    static testMethod void getSharingTestCase6() {
        
        getSharingTest((sObject)TestDataFactory.getAccount('TestAccount'), 
                       0,
                       new list<String> {'Sharing_Purpose__share', 'ParentId', 'true'},
                       '',
                       0);
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Test method to test getSharing with the following scenario.
      *               Pass null list of object detail and null set of record Id.
      * @Expected Result: Method should return empty map.
      * @Date: 12/04/2016
      **/
    static testMethod void getSharingTestCase7() {
        
        getSharingTest((sObject)TestDataFactory.getAccount('TestAccount'), 
                       0, null, null, 0);
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Test method to test getSharing with the following scenario.
      *               Pass null object details and set of record Id.
      * @Expected Result: Method should return empty map.
      * @Date: 12/04/2016
      **/
    static testMethod void getSharingTestCase8() {
        
        getSharingTest((sObject)TestDataFactory.getAccount('TestAccount'), 
                       0, null, 'Pass', 0);
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Test method to test getSharing with the following scenario.
      *               Pass list of object details and null set of record Id.
      * @Expected Result: Method should return empty map.
      * @Date: 12/04/2016
      **/
    static testMethod void getSharingTestCase9() {
        
        getSharingTest((sObject)TestDataFactory.getAccount('TestAccount'), 
                       0,
                       new list<String> {'Sharing_Purpose__share', 'ParentId', 'true'},
                       null,
                       0);
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Test method to test getSubGroupDetails with the following scenario.
      *               Group Id having group member as user
      * @Expected Result: Method should return users belonging to group.
      * @Date: 12/04/2016
      **/
    static testMethod void getSubGroupDetailsTestCase1() {
        
        getSubGroupDetailsTest(2, 'Pass');
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Test method to test getSubGroupDetails with the following scenario.
      *               Group Id having group member as user and group
      * @Expected Result:  Method should return users belonging to group.
      * @Date: 12/04/2016
      **/
    static testMethod void getSubGroupDetailsTestCase2() {
        
        getSubGroupDetailsTest(3, 'Pass');
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Test method to test getSubGroupDetails with pass empty set to method.
      * @Expected Result: Method should return empty map.
      * @Date: 12/04/2016
      **/
    static testMethod void getSubGroupDetailsTestCase3() {
        getSubGroupDetailsTest(0, '');
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Test method to test getSubGroupDetails with null pass to parameter.
      * @Expected Result: Method should return empty map.
      * @Date: 12/04/2016
      **/
    static testMethod void getSubGroupDetailsTestCase4() {
        getSubGroupDetailsTest(0, null);
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Test method to test getAllSubRoleIds with the following scenario.
      *               Set of role Id's
      * @Expected Result: Method should return sub role Id belongs to Role.
      * @Date: 12/04/2016
      **/
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
        
        Test.startTest();
        result = UltraTrackUtility.getAllSubRoleIds(new set<Id> {ur1.Id});
        Test.stopTest();
        
        System.assertEquals(1, result.size());
        System.assert(result.contains(ur2.Id));
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Test method to test getAllSubRoleIds with the parameters as null, blank or invalid.
      * @Expected Result: Method should return empty set of subrole Id's.
      * @Date: 12/04/2016
      **/
    static testMethod void getAllSubRoleIdsTestCase2() {

        Test.startTest();
        for(set<Id> idSet : getSubGroupDetailsData()) {
            checkAssertForGetAllSubRoleIds(UltraTrackUtility.getAllSubRoleIds(idSet));
        }
        Test.stopTest();
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Test method to test getAllManagersForUser by creating valid Users.
      * @Expected Result: Method should return all managers Id's for an each passed user Id.
      * @date: 12/04/2016
      **/
    static testMethod void getAllManagersForUserTestCase1() {
        
        map<Id, set<Id>> userIdVsAllManagerIdMap = new map<Id, set<Id>>();
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        Id user1Id, user2Id, user3Id;
        User user1 = TestDataFactory.getUser('User1', 'user1', 'test@user1.come', p.Id);
       
        System.runAs(user1) {
            user1Id = UserInfo.getUserId();
        }
        
        User user2 = TestDataFactory.getUser('User2', 'user2', 'test@user2.come', p.Id, user1Id);
        System.runAs(user2) {
            user2Id = UserInfo.getUserId();
        }
        User user3 = TestDataFactory.getUser('User3', 'user3', 'test@user3.come', p.Id, user2Id);
        System.runAs(user3) {
            user3Id = UserInfo.getUserId();
        }
     
        Test.startTest();
        userIdVsAllManagerIdMap = new UltraTrackUtility().getAllManagersForUser(new set<Id> {user3Id});
        Test.stopTest();
        
        System.assert(userIdVsAllManagerIdMap.containsKey(user3Id));
        System.assertEquals(2, userIdVsAllManagerIdMap.get(user3Id).size());
        set<Id> managerIdSet = userIdVsAllManagerIdMap.get(user3Id);
        System.assert(managerIdSet.contains(user1Id));
        System.assert(managerIdSet.contains(user2Id));
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Test method to test getAllManagersForUser with parameters as null, blank or invalid.
      * @Expected Result: Method should return empty map.
      * @date: 12/04/2016
      **/
    static void getAllManagersForUserTestCase2() {

        Test.startTest();
        for(set<Id> idSet : getSubGroupDetailsData()) {
           checkAssertForGetAllManagersForUser(new UltraTrackUtility().getAllManagersForUser(idSet));
        }
        Test.stopTest();
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Test method to test getStartAndEndDateForFilter with the following scenario:
      *               Selected DateFilter as Last Month, filterValue as blank, filterCategory as month
      *               and srNo as 1
      * @Expected Result: Method should return startDate and EndDate object.
      * @Date: 12/04/2016
      **/
    static testMethod void getStartAndEndDateForFilterTestCase1() {
        
        list<Ultra_Track_Container__c> startEndDateList = new list<Ultra_Track_Container__c>();

        Date lastMonthDate = Date.today().addMonths(-1);
        integer dayOfMonth = Date.daysInMonth(lastMonthDate.year(), lastMonthDate.month());
        Test.startTest();
        startEndDateList = getStartAndEndDateForFilterestData(true,
                                                              'Previous Month',
                                                              '',
                                                              'Month',
                                                              1);
        Test.stopTest();
        System.assertEquals(startEndDateList[0].DateHolder__c, lastMonthDate.toStartOfMonth());
        System.assertEquals(startEndDateList[1].DateHolder__c, lastMonthDate.toStartOfMonth().addDays(dayOfMonth - 1));
        
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Test method to test getStartAndEndDateForFilter with the following scenario:
      *               Selected DateFilter as This Month, filterValue as blank, filterCategory as month
      *               and srNo as 1
      * @Expected Result: Method should return startDate and EndDate object.
      * @Date: 12/04/2016
      **/
    static testMethod void getStartAndEndDateForFilterTestCase2() {
        
        list<Ultra_Track_Container__c> startEndDateList = new list<Ultra_Track_Container__c>();
 
        Date currentMonthDate = Date.today();
        integer dayOfMonth = Date.daysInMonth(currentMonthDate.year(), currentMonthDate.month());
        Test.startTest();
        startEndDateList = getStartAndEndDateForFilterestData(true,
                                                              'Current Month', 
                                                              '', 
                                                              'Month', 
                                                              1);
        Test.stopTest();
        
        System.assertEquals(startEndDateList[0].DateHolder__c, currentMonthDate.toStartOfMonth());
        System.assertEquals(startEndDateList[1].DateHolder__c, currentMonthDate.toStartOfMonth().addDays(dayOfMonth - 1));
        
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Test method to test getStartAndEndDateForFilter with the following scenario:
      *               Selected DateFilter as Current and Previous Month, filterValue as blank, 
      *               filterCategory as month and srNo as 1
      * @Expected Result: Method should return startDate and EndDate object.
      * @Date: 12/04/2016
      **/
    static testMethod void getStartAndEndDateForFilterTestCase3() {
        
        list<Ultra_Track_Container__c> startEndDateList = new list<Ultra_Track_Container__c>();

        Date currentMonthDate = Date.today();
        Date lastMonthDate = Date.today().addMonths(-1);
        integer dayOfMonth = Date.daysInMonth(currentMonthDate.year(), currentMonthDate.month()) ;
        Test.startTest();
        startEndDateList = getStartAndEndDateForFilterestData(true,
                                                              'Current and Previous Month', 
                                                              '', 
                                                              'Month', 
                                                              1);
        Test.stopTest();
        
        System.assertEquals(startEndDateList[0].DateHolder__c, lastMonthDate.toStartOfMonth());
        System.assertEquals(startEndDateList[1].DateHolder__c, currentMonthDate.toStartOfMonth().addDays(dayOfMonth - 1));
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Test method to test getStartAndEndDateForFilter with the following scenario:
      *               Selected DateFilter as Last Week, filterValue as blank, filterCategory as Week
      *               and srNo as 1
      * @Expected Result: Method should return startDate and EndDate object.
      * @Date: 12/04/2016
      **/
     static testMethod void getStartAndEndDateForFilterTestCase4() {
        
        list<Ultra_Track_Container__c> startEndDateList = new list<Ultra_Track_Container__c>();

        Date lastWeekDate = Date.today().addDays(-7);
        Test.startTest();
        startEndDateList = getStartAndEndDateForFilterestData(true,
                                                              'Previous Week', 
                                                              '', 
                                                              'Week', 
                                                              1);
        Test.stopTest();
        
        System.assertEquals(startEndDateList[0].DateHolder__c, lastWeekDate.toStartofWeek());
        System.assertEquals(startEndDateList[1].DateHolder__c, lastWeekDate.toStartofWeek().addDays(6));
        
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Test method to test getStartAndEndDateForFilter with the following scenario:
      *               Selected DateFilter as This Week, filterValue as blank, filterCategory as Week
      *               and srNo as 1
      * @Expected Result: Method should return startDate and EndDate object.
      * @Date: 12/04/2016
      **/
    static testMethod void getStartAndEndDateForFilterTestCase5() {
        
        list<Ultra_Track_Container__c> startEndDateList = new list<Ultra_Track_Container__c>();

        Date CurrentWeekDate = Date.Today();
        Test.startTest();
        startEndDateList = getStartAndEndDateForFilterestData(true,
                                                              'Current Week', 
                                                              '', 
                                                              'Week', 
                                                              1);
        Test.stopTest();
        
        System.assertEquals(startEndDateList[0].DateHolder__c, CurrentWeekDate.toStartofWeek());
        System.assertEquals(startEndDateList[1].DateHolder__c, CurrentWeekDate.toStartofWeek().addDays(6));
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Test method to test getStartAndEndDateForFilter with the following scenario:
      *               Selected DateFilter as Today, filterValue as blank, filterCategory as blank
      *               and srNo as 1
      * @Expected Result: Method should return startDate and EndDate object.
      * @Date: 12-04-2016
      **/
    static testMethod void getStartAndEndDateForFilterTestCase6() {
        
        list<Ultra_Track_Container__c> startEndDateList = new list<Ultra_Track_Container__c>();

        Test.startTest();
        startEndDateList = getStartAndEndDateForFilterestData(true,
                                                              'Today', 
                                                              '', 
                                                              '', 
                                                              1);
        Test.stopTest();
        
        System.assertEquals(startEndDateList[0].DateHolder__c, Date.today());
        System.assertEquals(startEndDateList[1].DateHolder__c, Date.today());
        
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Test method to test getStartAndEndDateForFilter with the following scenario:
      *               Selected DateFilter as Yesterday, filterValue as blank, filterCategory as blank
      *               and srNo as 1
      * @Expected Result: Method should return startDate and EndDate object.
      * @Date: 12-04-2016
      **/
    static testMethod void getStartAndEndDateForFilterTestCase7() {
        
        list<Ultra_Track_Container__c> startEndDateList = new list<Ultra_Track_Container__c>();

        Test.startTest();
        startEndDateList = getStartAndEndDateForFilterestData(true,
                                                              'Yesterday', 
                                                              '', 
                                                              '', 
                                                              1);
        Test.stopTest();
        
        System.assertEquals(startEndDateList[0].DateHolder__c, Date.today().addDays(-1));
        System.assertEquals(startEndDateList[1].DateHolder__c, Date.today().addDays(-1));
        
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Test method to test getStartAndEndDateForFilter with the following scenario:
      *               Selected DateFilter as Custom, filterValue as blank, filterCategory as Custom
      *               and srNo as 1
      * @Expected Result: Method should return startDate and EndDate object.
      * @Date: 12/04/2016
      **/
    static testMethod void getStartAndEndDateForFilterTestCase8() {
        
        list<Ultra_Track_Container__c> startEndDateList = new list<Ultra_Track_Container__c>();

        Test.startTest();
        startEndDateList = getStartAndEndDateForFilterestData(true,
                                                              'Custom', 
                                                              '', 
                                                              'Custom', 
                                                              1);
        Test.stopTest();
        
        System.assertEquals(startEndDateList[0].DateHolder__c, System.today());
        System.assertEquals(startEndDateList[1].DateHolder__c, System.today());
        
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Test method to test getStartAndEndDateForFilter with the following scenario:
      *               Selected DateFilter as Custom, filterValue as blank, filterCategory as Custom
      *               and srNo as 1 with no custom is added
      * @Expected Result: Method should return empty list.
      * @Date: 12/04/2016
      **/
    static testMethod void getStartAndEndDateForFilterTestCase9() {

        list<Ultra_Track_Container__c> startEndDateList = new list<Ultra_Track_Container__c>();
        
        Test.startTest();
        startEndDateList = getStartAndEndDateForFilterestData(false,
                                                              'Custom', 
                                                              '', 
                                                              'Custom', 
                                                              1);
        Test.stopTest();
        
        System.assert(startEndDateList.isEmpty());
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Test method to test getStartAndEndDateForFilter with the following scenario:
      *               Selected DateFilter as blank or null , filterValue as blank, filterCategory as blank
      *               and srNo as null with no custom is added
      * @Expected Result: Method should return empty list.
      * @Date: 12/04/2016
      **/
    static testMethod void getStartAndEndDateForFilterTestCase10() {

        Test.startTest();
        for(String objectName : getInvalidData()) {
             checkAssertForGetStartAndEndDateForFilter(UltraTrackUtility.getStartAndEndDateForFilter(objectName));
        }
        Test.stopTest();
    }
    
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Test method to test getNameUniqueField with the following scenario:
      *               objectName is Account
      * @Expected Result: Method should return name field for an account.
      * @Date: 12/04/2016
      **/
    static testMethod void getNameUniqueFieldTestCase1() {
        
        String fieldName;
        Test.startTest();
        fieldName = UltraTrackUtility.getNameUniqueField('Account');
        Test.stopTest();
        
        System.assertEquals(fieldName, 'Name');
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Test method to test getNameUniqueField with the following scenario:
      *               objectName is Case
      * @Expected Result: Method should return name field for an case.
      * @Date: 12/04/2016
      **/
    static testMethod void getNameUniqueFieldTestCase2() {
        
        String fieldName;
        Test.startTest();
        fieldName = UltraTrackUtility.getNameUniqueField('Case');
        Test.stopTest();
        
        System.assertEquals(fieldName, 'CaseNumber');
    }
    /** 
      * @Author: Eternus Solutions
      * @Description: Test method to test getNameUniqueField with the following scenario:
      *               objectName is Solution
      * @Expected Result: Method should return name field for an solution.
      * @Date: 12/04/2016
      **/
    static testMethod void getNameUniqueFieldTestCase3() {
        
        String fieldName;
        Test.startTest();
        fieldName = UltraTrackUtility.getNameUniqueField('Solution');
        Test.stopTest();
        
        System.assertEquals(fieldName, 'SolutionName');
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Test method to test getNameUniqueField with the following scenario:
      *               Pass invalid, null and blank object name
      * @Expected Result: Method should return empty String.
      * @Date: 12/04/2016
      **/
    static testMethod void getNameUniqueFieldTestCase4() {
        
        String fieldName;
        Test.startTest();
        for(String objectName : getOwdForAnObjectData()) {
             checkAssertForGetNameUniqueField(UltraTrackUtility.getNameUniqueField(objectName));
        }
        Test.stopTest();
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Test method to test getFieldNamesAndLabels with the following scenario:
      *               object name is null, blank and valid object name.
      * @Expected Result: Method should returned empty map for fields for invalid input and map of field for valid input.
      * @Date: 1/03/2016
      **/ 
    static testMethod void getFieldNamesAndLabelsTestCase1() {

        Test.startTest();
        for(String objectName : getFieldNamesAndLabelsData()) {
             checkAssertForGetFieldNamesAndLabels(UltraTrackUtility.getFieldNamesAndLabels(objectName));
        }
        Test.stopTest();
    }
    
     /** 
      * @Author: Eternus Solutions
      * @Description: Test method to check type of Field by passing text field
      * @Expected Result: Method returns type of field
      * @Date: 8/06/2016
      **/
    static testMethod void getFieldTypeCase1() {
        
        Schema.DisplayType fieldType;
        
        Test.startTest();
        fieldType = UltraTrackUtility.getFieldType('Account', 'Name');
        Test.stopTest();
        
        System.assert(String.valueOf(fieldType).equalsIgnoreCase('STRING'));    
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Test method to check type of Field by passing phone number field
      * @Expected Result: Method returns type of field
      * @Date: 8/06/2016
      **/
    static testMethod void getFieldTypeCase2() {
        
        Schema.DisplayType fieldType;
        
        Test.startTest();
        fieldType = UltraTrackUtility.getFieldType('Account', 'Phone');
        Test.stopTest();
      
        System.assert(String.valueOf(fieldType).equalsIgnoreCase('PHONE'));    
    }

    /** 
      * @Author: Eternus Solutions
      * @Description: Test method to check type of Field for valid, null and blank data.
      * @Expected Result: Method returns null if field is invalid specified
      * @Date: 8/06/2016
      **/
    static testMethod void getFieldTypeCase3() {

        Schema.DisplayType fieldType;
        Test.startTest();
        for(String objectName : getObjectForFieldTypeMethod()) {
            for(String fieldName : getFieldForFieldTypeMethod()) {
                checkAssertForGetFieldType(UltraTrackUtility.getFieldType(objectName, fieldName));
            }
        }
        Test.stopTest();
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Test method to test maskEncryptedData with the following scenario:
      *               Custom setting data is inserted for 'All' type encrypted field.
      * @Expected Result: Method returns masked value for all when All is selected
      * @Date: 8/06/2016
      **/
    static testMethod void maskEncryptedDataTestCase1() {

        list<String> updatedValues;
         
        Test.startTest();
        updatedValues = getMaskEncryptedTestData(true,
                                                  'all',
                                                  '\\p{ASCII}',
                                                  UFHT__Sharing_Purpose__c.UFHT__EncryptedFieldsFor_All__c.getDescribe(), 
                                                  '1234-1234-1234-1234', 
                                                  '1234-1234-1234-1234');
        Test.stopTest();
        System.assertEquals(updatedValues[0], 'XXXXXXXXXXXXXXXXXXX');
        System.assertEquals(updatedValues[1], 'XXXXXXXXXXXXXXXXXXX');
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Test method to test maskEncryptedData with the following scenario:
      *               Custom setting data is inserted for 'creditCard' type encrypted field.
      * @Expected Result: Method returns masked value for Credit Card number
      * @Date: 8/06/2016
      **/
    static testMethod void maskEncryptedDataTestCase2() {
        
        list<String> updatedValues;
        Test.startTest();
        updatedValues = getMaskEncryptedTestData(true,
                                                  'creditCard', 
                                                  '[0-9]',
                                                   UFHT__Sharing_Purpose__c.UFHT__EncryptedFieldsFor_CreditCard__c.getDescribe(), 
                                                  '1234-1234-1234-1234', 
                                                  '1234-1234-1234-4444');
        Test.stopTest();
        System.assertEquals(updatedValues[0], 'XXXX-XXXX-XXXX-1234');
        System.assertEquals(updatedValues[1], 'XXXX-XXXX-XXXX-4444');
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Test method to test maskEncryptedData with the following scenario:
      *               Custom setting data is inserted for 'lastFour' type encrypted field.
      * @Expected Result: Method returns masked value when LastFour is selected
      * @Date: 8-06-2016
      **/
    static testMethod void maskEncryptedDataTestCase3() {

        list<String> updatedValues;
        Test.startTest();
        updatedValues = getMaskEncryptedTestData(true,
                                                'lastFour', 
                                                '\\p{ASCII}',
                                                 UFHT__Sharing_Purpose__c.UFHT__EncryptedFieldsFor_LastFour__c.getDescribe(), 
                                                 '1234-1234-1234-1234', 
                                                 '1234-1234-1234-1414');
        Test.stopTest();
        
        System.assertEquals(updatedValues[0], 'XXXXXXXXXXXXXXX1234');
        System.assertEquals(updatedValues[1], 'XXXXXXXXXXXXXXX1414');
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Test method to test maskEncryptedData with the following scenario:
      *               Custom setting data is inserted for 'nino' type encrypted field.
      * @Expected Result: Method returns masked value for nino(National Insurance Number)
      * @Date: 8/06/2016
      **/
    static testMethod void maskEncryptedDataTestCase4() {
    
        list<String> updatedValues;
        Test.startTest();
        updatedValues = getMaskEncryptedTestData(true,
                                                'nino', 
                                                '[^\\ ]',
                                                 UFHT__Sharing_Purpose__c.UFHT__EncryptedFieldsFor_Nino__c.getDescribe(),
                                                 '12 12 12 12 1',
                                                 '12 12 12 12 2');
        Test.stopTest();
        
        System.assertEquals(updatedValues[0], 'XX XX XX XX X');
        System.assertEquals(updatedValues[1], 'XX XX XX XX X');
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Test method to test maskEncryptedData with the following scenario:
      *               Custom setting data is inserted for 'SSN' type encrypted field.
      * @Expected Result: Method returns masked value for SSN(Social Security Number)
      * @Date: 8/06/2016
      **/
    static testMethod void maskEncryptedDataTestCase5() {

        list<String> updatedValues;
        Test.startTest();
        updatedValues = getMaskEncryptedTestData(true,
                                                'ssn', 
                                                '[0-9]',
                                                 UFHT__Sharing_Purpose__c.UFHT__EncryptedFieldsFor_SSN__c.getDescribe(),
                                                 '123-12-1234',
                                                 '123-12-4422');
        Test.stopTest();
        
        System.assertEquals(updatedValues[0], 'XXX-XX-1234');
        System.assertEquals(updatedValues[1], 'XXX-XX-4422');
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Test method to test maskEncryptedData with the following scenario:
      *               Custom setting data is inserted for 'sin' type encrypted field.
      * @Expected Result: Method returns masked value for SIN(Social Insurance Number)
      * @Date: 8/06/2016
      **/
    static testMethod void maskEncryptedDataTestCase6() {
    
        list<String> updatedValues;
        Test.startTest();
        updatedValues = getMaskEncryptedTestData(true,
                                                'sin', 
                                                '[0-9]',
                                                 UFHT__Sharing_Purpose__c.UFHT__EncryptedFieldsFor_SIN__c.getDescribe(),
                                                 '123-123-123',
                                                 '123-123-142');
        Test.stopTest();
        
        System.assertEquals(updatedValues[0], 'XXX-XXX-123');
        System.assertEquals(updatedValues[1], 'XXX-XXX-142');
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Test method to test maskEncryptedDataCase with the following scenario:
      *               No custom setting data is inserted
      * @Expected Result: Method returns masked value for SIN(Social Insurance Number)
      * @Date: 8/06/2016
      **/
    static testMethod void maskEncryptedDataTestCase7() {
         
        list<String> updatedValues;
        Test.startTest();
        updatedValues = getMaskEncryptedTestData(false,
                                                 null, 
                                                 null,
                                                 UFHT__Sharing_Purpose__c.UFHT__EncryptedFieldsFor_SIN__c.getDescribe(),
                                                '123-123-123',
                                                '123-123-142');
        Test.stopTest();
        
        System.assertEquals(updatedValues, null);
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Test method to test maskEncryptedDataCase with the following scenario:
      *               Pass all parameters as null
      * @Expected Result: Method returns masked value for SIN(Social Insurance Number)
      * @Date: 8/06/2016
      **/
    static testMethod void maskEncryptedDataTestCase8() {
         
        list<String> updatedValues;
        Test.startTest();
        updatedValues = getMaskEncryptedTestData(true,
                                                 'sin', 
                                                 '[0-9]',
                                                  null,
                                                  null,
                                                  null);
        Test.stopTest();
        
        System.assertEquals(updatedValues, null);
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Test method to test maskEncryptedDataCase with the following scenario:
      *               Pass first two parameter s as null          
      * @Expected Result: Method returns masked value for SIN(Social Insurance Number)
      * @Date: 8/06/2016
      **/
    static testMethod void maskEncryptedDataTestCase9() {
    
        list<String> updatedValues;
        Test.startTest();
        updatedValues = getMaskEncryptedTestData(true,
                                                 'sin', 
                                                 '[0-9]',
                                                  null,
                                                  null,
                                                 '123-123-142');
        Test.stopTest();
        
        System.assertEquals(updatedValues, null);
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Test method to test maskEncryptedDataCase with the following scenario:
      *               Custom setting data is inserted.
      *               Pass first and last parameter s as null          
      * @Expected Result: Method returns masked value for SIN(Social Insurance Number)
      * @Date: 8/06/2016
      **/
    static testMethod void maskEncryptedDataTestCase10() {
    
        list<String> updatedValues;
        Test.startTest();
        updatedValues = getMaskEncryptedTestData(true,
                                                 'sin', 
                                                 '[0-9]',
                                                  null,
                                                 '123-123-142',
                                                  null);
        Test.stopTest();
        
        System.assertEquals(updatedValues, null);
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Test method to test maskEncryptedDataCase with the following scenario:
      *               Custom setting data is inserted.
      *               Pass first parameter  as null          
      * @Expected Result: Method returns masked value for SIN(Social Insurance Number)
      * @Date: 8/06/2016
      **/
    static testMethod void maskEncryptedDataTestCase11() {
         
        list<String> updatedValues;
        Test.startTest();
        updatedValues = getMaskEncryptedTestData(true,
                                                 'sin', 
                                                 '[0-9]',
                                                  null,
                                                 '123-123-142',
                                                 '123-123-142');
        Test.stopTest();
        
        System.assertEquals(updatedValues, null);
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Test method to test maskEncryptedDataCase with the following scenario:
      *               Custom setting data is inserted.
      *               Pass valid field name, old and new value as null.       
      * @Expected Result: Method returns masked value for SIN(Social Insurance Number)
      * @Date: 8/06/2016
      **/
    static testMethod void maskEncryptedDataTestCase12() {

        list<String> updatedValues;
        Test.startTest();
        updatedValues = getMaskEncryptedTestData(true,
                                                 'sin', 
                                                 '[0-9]',
                                                 UFHT__Sharing_Purpose__c.UFHT__EncryptedFieldsFor_SIN__c.getDescribe(),
                                                 null,
                                                 null);
        Test.stopTest();
        
        System.assertEquals(updatedValues[0], null);
        System.assertEquals(updatedValues[1], null);
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Test method to test maskEncryptedDataCase with the following scenario:
      *               Custom setting data is inserted.
      *               Pass valid field name, null old value and new value as valid.           
      * @Expected Result: Method returns masked value for SIN(Social Insurance Number)
      * @Date: 8/06/2016
      **/
    static testMethod void maskEncryptedDataTestCase13() {

        list<String> updatedValues;
        Test.startTest();
        updatedValues = getMaskEncryptedTestData(true,
                                                 'sin', 
                                                 '[0-9]',
                                                 UFHT__Sharing_Purpose__c.UFHT__EncryptedFieldsFor_SIN__c.getDescribe(),
                                                 null,
                                                '123-123-142');
        Test.stopTest();
        
        System.assertEquals(updatedValues[0], null);
        System.assertEquals(updatedValues[1], 'XXX-XXX-142');
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Test method to test maskEncryptedDataCase with the following scenario:
      *               Custom setting data is inserted.
      *               Pass valid field name, valid old value and new value as null.         
      * @Expected Result: Method returns masked value for SIN(Social Insurance Number)
      * @Date: 8/06/2016
      **/
    static testMethod void maskEncryptedDataTestCase14() {

        list<String> updatedValues;
        Test.startTest();
        updatedValues = getMaskEncryptedTestData(true,
                                                 'sin', 
                                                 '[0-9]',
                                                 UFHT__Sharing_Purpose__c.UFHT__EncryptedFieldsFor_SIN__c.getDescribe(),
                                                 '123-123-142',
                                                  null);
        Test.stopTest();
        
        System.assertEquals(updatedValues[0], 'XXX-XXX-142');
        System.assertEquals(updatedValues[1], null);
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Test method to test maskEncryptedDataCase with the following scenario:
      *               Custom setting data is inserted for 'All' encrypted type.
      *               Pass valid field name, valid old value and new value as null.    
      * @Expected Result: Method returns masked value for all when All is selected
      * @Date: 8/06/2016
      **/
    static testMethod void maskEncryptedDataTestCase15() {

        list<String> updatedValues;
        Test.startTest();
        updatedValues = getMaskEncryptedTestData(true,
                                                 'all', 
                                                 '\\p{ASCII}',
                                                 UFHT__Sharing_Purpose__c.UFHT__EncryptedFieldsFor_All__c.getDescribe(), 
                                                 '1234-1234-1234-1234', 
                                                 null);
        Test.stopTest();
        System.assertEquals(updatedValues[0], 'XXXXXXXXXXXXXXXXXXX');
        System.assertEquals(updatedValues[1], null);
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Test method to test maskEncryptedDataCase with the following scenario:
      *               Custom setting data is inserted for 'All' encrypted type.
      *               Pass valid field name, null old value and valid new value.
      * @Expected Result: Method returns masked value for all when 'All' encrypted type is selected
      * @Date: 8/06/2016
      **/
    static testMethod void maskEncryptedDataTestCase16() {
    
        list<String> updatedValues;
        Test.startTest();
        updatedValues = getMaskEncryptedTestData(true,
                                                 'all', 
                                                 '\\p{ASCII}',
                                                 UFHT__Sharing_Purpose__c.UFHT__EncryptedFieldsFor_All__c.getDescribe(), 
                                                 null, 
                                                 '1234-1234-1234-1234');
        Test.stopTest();
        System.assertEquals(updatedValues[0], null);
        System.assertEquals(updatedValues[1], 'XXXXXXXXXXXXXXXXXXX');
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Test method to test maskEncryptedDataCase with the following scenario:
      *               Custom setting data is inserted for 'creditCard' encrypted type.
      *               Pass valid field name, valid old value and null new value.
      * @Expected Result: Method returns masked value for 'Credit Card' encrypted type.
      * @Date: 8/06/2016
      **/
    static testMethod void maskEncryptedDataTestCase17() {
        
        list<String> updatedValues;
        Test.startTest();
        updatedValues = getMaskEncryptedTestData(true,
                                                 'creditCard', 
                                                 '[0-9]',
                                                 UFHT__Sharing_Purpose__c.UFHT__EncryptedFieldsFor_CreditCard__c.getDescribe(),
                                                 '1234-1234-1234-1234',
                                                 null);
        Test.stopTest();
        System.assertEquals(updatedValues[0], 'XXXX-XXXX-XXXX-1234');
        System.assertEquals(updatedValues[1], null);
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Test method to test maskEncryptedDataCase with the following scenario:
      *               Custom setting data is inserted for 'creditCard' encrypted type.
      *               Pass valid field name, null old value and valid new value.
      * @Expected Result: Method returns masked value for 'Credit Card' encrypted type.
      * @Date: 8/06/2016
      **/
    static testMethod void maskEncryptedDataTestCase18() {

        list<String> updatedValues;
        Test.startTest();
        updatedValues = getMaskEncryptedTestData(true,
                                                 'creditCard', 
                                                 '[0-9]',
                                                 UFHT__Sharing_Purpose__c.UFHT__EncryptedFieldsFor_CreditCard__c.getDescribe(),
                                                 null,
                                                 '1234-1234-1234-1234');
        Test.stopTest();
        System.assertEquals(updatedValues[0], null);
        System.assertEquals(updatedValues[1], 'XXXX-XXXX-XXXX-1234');
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Test method to test maskEncryptedDataCase with the following scenario:
      *               Custom setting data is inserted for 'LastFour' encrypted type.
      *               Pass valid field name, valid old value and null new value.
      * @Expected Result: Method returns masked value when 'LastFour' encrypted type is selected
      * @Date: 8-06-2016
      **/
    static testMethod void maskEncryptedDataTestCase19() {

        list<String> updatedValues;
        Test.startTest();
        updatedValues = getMaskEncryptedTestData(true,
                                                'lastFour', 
                                                '\\p{ASCII}',
                                                UFHT__Sharing_Purpose__c.UFHT__EncryptedFieldsFor_LastFour__c.getDescribe(),
                                                '1234-1234-1234-1234',
                                                null);
        Test.stopTest();
        
        System.assertEquals(updatedValues[0], 'XXXXXXXXXXXXXXX1234');
        System.assertEquals(updatedValues[1], null);
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Test method to test maskEncryptedDataCase with the following scenario:
      *               Custom setting data is inserted for 'LastFour' encrypted type.
      *               Pass valid field name, null old value and valid new value.
      * @Expected Result: Method returns masked value when 'LastFour' encrypted type is selected
      * @Date: 8-06-2016
      **/
    static testMethod void maskEncryptedDataTestCase20() {

        list<String> updatedValues;
        Test.startTest();
        updatedValues = getMaskEncryptedTestData(true,
                                                'lastFour', 
                                                '\\p{ASCII}',
                                                UFHT__Sharing_Purpose__c.UFHT__EncryptedFieldsFor_LastFour__c.getDescribe(),
                                                null,
                                                '1234-1234-1234-1234');
        Test.stopTest();
        
        System.assertEquals(updatedValues[0], null);
        System.assertEquals(updatedValues[1], 'XXXXXXXXXXXXXXX1234');
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Test method to test maskEncryptedDataCase with the following scenario:
      *               Custom setting data is inserted for 'nino' encrypted type.
      *               Pass valid field name, valid old value and null new value.
      * @Expected Result: Method returns masked value for 'nino'(National Insurance Number) encrypted type
      * @Date: 8/06/2016
      **/
    static testMethod void maskEncryptedDataTestCase21() {

        list<String> updatedValues;
        Test.startTest();
        updatedValues = getMaskEncryptedTestData(true,
                                                'nino', 
                                                '[^\\ ]',
                                                UFHT__Sharing_Purpose__c.UFHT__EncryptedFieldsFor_Nino__c.getDescribe(),
                                                '12 12 12 12 1',
                                                null);
        Test.stopTest();
        
        System.assertEquals(updatedValues[0], 'XX XX XX XX X');
        System.assertEquals(updatedValues[1], null);
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Test method to test maskEncryptedDataCase with the following scenario:
      *               Custom setting data is inserted for 'nino' encrypted type.
      *               Pass valid field name, null old value and valid new value.
      * @Expected Result: Method returns masked value for 'nino'(National Insurance Number) encrypted type
      * @Date: 8/06/2016
      **/
    static testMethod void maskEncryptedDataTestCase22() {

        list<String> updatedValues;
        Test.startTest();
        updatedValues = getMaskEncryptedTestData(true,
                                                'nino', 
                                                '[^\\ ]',
                                                UFHT__Sharing_Purpose__c.UFHT__EncryptedFieldsFor_Nino__c.getDescribe(),
                                                null,
                                                '12 12 12 12 1');
        Test.stopTest();
        
        System.assertEquals(updatedValues[0], null);
        System.assertEquals(updatedValues[1], 'XX XX XX XX X');
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Test method to test maskEncryptedDataCase with the following scenario:
      *               Custom setting data is inserted for 'SSN' encrypted type.
      *               Pass valid field name, valid old value and null new value.
      * @Expected Result: Method returns masked value for SSN(Social Security Number) encrypted type.
      * @Date: 8/06/2016
      **/
    static testMethod void maskEncryptedDataTestCase23() {

        list<String> updatedValues;
        Test.startTest();
        updatedValues = getMaskEncryptedTestData(true,
                                                'ssn', 
                                                '[0-9]',
                                                UFHT__Sharing_Purpose__c.UFHT__EncryptedFieldsFor_SSN__c.getDescribe(),
                                                '123-12-1234',
                                                null);
        Test.stopTest();
        
        System.assertEquals(updatedValues[0], 'XXX-XX-1234');
        System.assertEquals(updatedValues[1], null);
    }
     
    /** 
      * @Author: Eternus Solutions
      * @Description: Test method to test maskEncryptedDataCase with the following scenario:
      *               Custom setting data is inserted for 'SSN' encrypted type.
      *               Pass valid field name, null old value and valid new value.
      * @Expected Result: Method returns masked value for SSN(Social Security Number) encrypted type.
      * @Date: 8/06/2016
      **/
    static testMethod void maskEncryptedDataTestCase24() {
         
        list<String> updatedValues;
        Test.startTest();
        updatedValues = getMaskEncryptedTestData(true,
                                                'ssn', 
                                                '[0-9]',
                                                UFHT__Sharing_Purpose__c.UFHT__EncryptedFieldsFor_SSN__c.getDescribe(),
                                                null,
                                               '123-12-1234');
        Test.stopTest();
        
        System.assertEquals(updatedValues[0], null);
        System.assertEquals(updatedValues[1], 'XXX-XX-1234');
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Test method to test replaceString with the following scenario:
      *               Pass valid input String
      *               Pass valid regEx and replacement String       
      * @Expected Result: Method returns input String with replace regEx with replacement String.
      * @Date: 8/06/2016
      **/
     static testMethod void replaceStringTestCase1() {
        
        String replacedStr;
        Test.startTest();
        replacedStr = UltraTrackUtility.replaceString('abcd1234 xyz345',
                                                      '\\p{Digit}',
                                                      '*');
        Test.stopTest();
        
        System.assertEquals(replacedStr, 'abcd**** xyz***');
     }
     
    /** 
      * @Author: Eternus Solutions
      * @Description: Test method to test replaceString with the following scenario:
      *               Pass valid input String
      *               Pass valid regEx and blank replacement String       
      * @Expected Result: Method returns input String with replace regEx with replacement String.
      * @Date: 8/06/2016
      **/
     static testMethod void replaceStringTestCase2() {
        
        String replacedStr;
        Test.startTest();
        replacedStr = UltraTrackUtility.replaceString('BCD1234 xyz345',
                                                      '\\p{Upper}',
                                                      '');
        Test.stopTest();
        
        System.assertEquals(replacedStr, '1234 xyz345');
     }
     
    /** 
      * @Author: Eternus Solutions
      * @Description: Test method to test replaceString with the following scenario:
      *               Pass valid input String
      *               Pass valid regEx and null replacement String       
      * @Expected Result: Method returns empty String.
      * @Date: 8/06/2016
      **/
     static testMethod void replaceStringTestCase3() {

        String replacedStr;
        Test.startTest();
        for(list<String> paramList : getReplaceStringData()) {
            checkAssertForreplaceString(UltraTrackUtility.replaceString(paramList[0],
                                                                        paramList[1],
                                                                        paramList[2]));
        }
        Test.stopTest();
     }
     
    /** 
      * @Author: Eternus Solutions
      * @Description: displayMessage test case for valid and invalid parameters.
      * @Expected Result: Method should check expected results with actual result.
      * @Date: 1/03/2016
      **/ 
    static testMethod void displayMessageTestCase() {
        
        Test.startTest();
        for(ApexPages.severity servity : getSeverityForDisplayMessageData()) {
            for(String msg : getMessageForDisplayMessageData()) {
                UltraTrackUtility.displayMessage(servity, msg);
                checkAssertForDisplayMessage();
            }
        }
        Test.stopTest();
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Test method to check method returns or not fields from record sobject records.
      * @Expected Result: Method returns set of fields form records.
      * @Date: 8/06/2016
      **/
    static testMethod void getFieldsTestCase1() { 

        list<Contact> ContactList = new list<Contact>();
        Contact contactObj = TestDataFactory.getContact('Test', 
                                                       'Contact',
                                                       '202012546', 
                                                       '0104578',
                                                        'Other');
        insert contactObj;
        
        ContactList.add(contactObj);
        
        contactObj.FirstName = 'Test1';
        contactObj.Email = 'abc@test.com';
        update contactObj;
        
        ContactList.add(new Contact(Id = contactObj.id));

        Test.startTest();
        set<String> setFields = UltraTrackUtility.getFields((sObject)ContactList[0],
                                                            (sObject)ContactList[1]
                                                           );
        Test.stopTest();
        System.assertEquals(setFields.size(), 7);
        System.assert(setFields.contains('Id'));
        System.assert(setFields.contains('FirstName'));
        System.assert(setFields.contains('LastName'));
        System.assert(setFields.contains('Email'));
        System.assert(setFields.contains('OtherPhone'));
        System.assert(setFields.contains('HomePhone'));
        System.assert(setFields.contains('LeadSource'));
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Test method to test getFields with the following scenario:
      *               Pass first sObject null and second with valid sObject.
      * @Expected Result: Method returns empty set.
      * @Date: 8/06/2016
      **/
    static testMethod void getFieldsTestCase2() { 

        list<Contact> lstContact = new list<Contact>();
        Contact contactObj = TestDataFactory.getContact('Test', 
                                                       'Contact',
                                                       '202012546', 
                                                       '0104578',
                                                       'Other');
        insert contactObj;
       
        Test.startTest();
        set<String> setFields = UltraTrackUtility.getFields(null,
                                                            (sObject)contactObj
                                                            );
        Test.stopTest();
        System.assert(setFields.isEmpty());
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Test method to test getFields with the following scenario:
      *               Pass second sObject null and first with valid sObject.
      * @Expected Result: Method returns empty set.
      * @Date: 8/06/2016
      **/
    static testMethod void getFieldsTestCase3() { 

        list<Contact> lstContact = new list<Contact>();
        Contact contactObj = TestDataFactory.getContact('Test', 
                                                     'Contact',
                                                     '202012546', 
                                                     '0104578',
                                                     'Other');
        insert contactObj;
       
        Test.startTest();
        set<String> setFields = UltraTrackUtility.getFields((sObject)contactObj,
                                                            null
                                                            );
        Test.stopTest();
        System.assert(setFields.isEmpty());
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Test method to test getFields with the following scenario:
      *               Pass both sObject parameters as null.
      * @Expected Result: Method returns empty set.
      * @Date: 8/06/2016
      **/
    static testMethod void getFieldsTestCase4() { 
       
        Test.startTest();
        set<String> setFields = UltraTrackUtility.getFields(null,
                                                            null
                                                            );
        Test.stopTest();
        System.assert(setFields.isEmpty());
    }
    
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Test method to check field is not currency, percent and encrypted field 
      *               by passing valid Object and text field.
      * @Expected Result: Method returns zero element in the list if fields type is not currency, percent and encrypted String
      * @Date: 8/06/2016
      **/
    static testMethod void checkCurrencyOrPercentFieldCase1() {

        list<String> fieldValue;
        
        Test.startTest();
        fieldValue = UltraTrackUtility.checkCurrencyOrPercentField('UFHT__Sharing_Purpose__c', 
                                                                    new UFHT__Sharing_Purpose__c(),
                                                                    new UFHT__Sharing_Purpose__c(),
                                                                    'Name',
                                                                    '1234',
                                                                    '1234');
        Test.stopTest();
        
        System.assertEquals(fieldValue.size(), 0);
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Test method to check field is currency type
      *               by passing valid Object and currency field.
      * @Expected Result: Method returns INR prefix with passed values.
      * @date: 8/06/2016
      **/
    static testMethod void checkCurrencyOrPercentFieldCase2() {
        list<String> fieldValue;
        String currencySymbol ;
        Test.startTest();
        fieldValue = UltraTrackUtility.checkCurrencyOrPercentField('UFHT__Sharing_Purpose__c', 
                                                                    new UFHT__Sharing_Purpose__c(),
                                                                    new UFHT__Sharing_Purpose__c(),
                                                                   'UFHT__Currency_Field__c',
                                                                   '1234',
                                                                   '4444');
        Test.stopTest();
        currencySymbol = UltraTrackUtility.getCurrencySymbol(UltraTrackUtility.sobjectMap.get('UFHT__Sharing_Purpose__c').newsObject());
        
        System.assertEquals(fieldValue[0], currencySymbol + ' 1234'); 
        System.assertEquals(fieldValue[1], currencySymbol + ' 4444'); 
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Test method to check field is percent type
      *               by passing valid Object and percent field.
      * @Expected Result: Method returns % appended with passed values.
      * @Date: 8/06/2016
      **/
    static testMethod void checkCurrencyOrPercentFieldCase3() {
        
        list<String> fieldValue;
        
        Test.startTest();
        fieldValue = UltraTrackUtility.checkCurrencyOrPercentField('UFHT__Sharing_Purpose__c',
                                                                   new UFHT__Sharing_Purpose__c(), 
                                                                   new UFHT__Sharing_Purpose__c(),
                                                                   'UFHT__Percent_Field__c',
                                                                   '50',
                                                                   '20');
        Test.stopTest();
        
        System.assertEquals(fieldValue[0], '50%'); 
        System.assertEquals(fieldValue[1], '20%'); 
    }
    /** 
      * @Author: Eternus Solutions
      * @Description: Test method to check Encrypted type field values
      *               by passing valid Object and encrypted field.
      * @Expected Result: Method returns Masked Characters if value of fields type is Encrypted String
      * @Date: 8/06/2016
      **/
    static testMethod void checkCurrencyOrPercentFieldCase4() {

        UFHT__Encrypted_Field_Mask__c fieldMaskObj = new UFHT__Encrypted_Field_Mask__c (Name = 'all',UFHT__RegEx__c = '\\p{ASCII}');
        insert fieldMaskObj;
         
        list<String> fieldValue;
        
        Test.startTest();
        fieldValue = UltraTrackUtility.checkCurrencyOrPercentField('UFHT__Sharing_Purpose__c',
                                                                   new UFHT__Sharing_Purpose__c(), 
                                                                   new UFHT__Sharing_Purpose__c(),
                                                                   'UFHT__EncryptedString_Field__c',
                                                                   '1234',
                                                                   '4222');
        Test.stopTest();
        
        System.assertEquals(fieldValue[0], 'XXXX'); 
        System.assertEquals(fieldValue[1], 'XXXX'); 
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Test method to check currency type for invalid data
      *               by passing all combinations of invalid Object and field.
      * @Expected Result: Method returns empty list.
      * @Date: 8/06/2016
      **/
    static testMethod void checkCurrencyOrPercentFieldCase5() {

        list<String> fieldValue;
        
        Test.startTest();
        checkAssertForcheckCurrencyOrPercentField(UltraTrackUtility.checkCurrencyOrPercentField('UFHT__Sharing_Purpose__c', 
                                                                                                 new UFHT__Sharing_Purpose__c(),
                                                                                                 new UFHT__Sharing_Purpose__c(), 
                                                                                                 '', 
                                                                                                 '1234', 
                                                                                                 '4222'));
        checkAssertForcheckCurrencyOrPercentField(UltraTrackUtility.checkCurrencyOrPercentField('', 
                                                                                                new UFHT__Sharing_Purpose__c(), 
                                                                                                new UFHT__Sharing_Purpose__c(),
                                                                                                'UFHT__EncryptedString_Field__c', 
                                                                                                '1234', 
                                                                                                '4222'));
        checkAssertForcheckCurrencyOrPercentField(UltraTrackUtility.checkCurrencyOrPercentField('ABC', 
                                                                                                 new UFHT__Sharing_Purpose__c(), 
                                                                                                 new UFHT__Sharing_Purpose__c(),
                                                                                                 'UFHT__EncryptedString_Field__c', 
                                                                                                 '1234', 
                                                                                                 '4222'));
        Test.stopTest();
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: getFieldType test case for valid, invalid, null and blank parameters.
      * @Expected Result: Method returns map of Schema.sObjectField with correct value.
      * @Date: 8/06/2016
      **/
    static testMethod void getFieldTypeSchemaCase() {
        
        Test.startTest();
        for(String objectName : getFieldNamesAndLabelsData()) {
            checkAssertForgetFieldTypeSchema(UltraTrackUtility.getFieldType(objectName));
        }
        Test.stopTest();
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Test method to test getStringDate with the following scenario:
      *               Pass null value to method
      * @Expected Result: Method returns empty String.
      * @Date: 8/06/2016
      **/
    static testMethod void getStringDateTestCase1() {
        String resultDate;
        
        Test.startTest();
        resultDate = UltraTrackUtility.getStringDate(null);
        Test.stopTest();
        
        System.assertEquals(resultDate, '');
    }    
    /** 
      * @Author: Eternus Solutions
      * @Description: Test method to test getStringDate with the following scenario:
      *               Pass valid date to method
      * @Expected Result: Method returns String date in mm/dd/yy format.
      * @Date: 8/06/2016
      **/
    static testMethod void getStringDateTestCase2() {
        String resultDate;
        Date inputDate = System.today().addDays(2);
        
        Test.startTest();
        resultDate = UltraTrackUtility.getStringDate(inputDate);
        Test.stopTest();
        
        String exceptedDate = String.valueOf(inputDate.month() + 100).right(2) + '/'
                            + String.valueOf(inputDate.day() + 100).right(2) + '/'
                            + String.valueOf(inputDate.year());
        
        System.assertEquals(resultDate, exceptedDate);
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Method to test Attachment records when Id, start date,end date and offset are provided.
      * @Expected Result: Method should return attachment instance for passed date range and object Id.
      * @Date: 08/07/2016
      **/
    static testMethod void getAttachmentTestCase1() {
        getAttachmentTest(true, true, true, true, '0');
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Method to test Attachment records when Id, start date and offset are provided and end date is null.
      * @Expected Result: Method should return attachment instance for passed date range and object Id.
      * @Date: 08/07/2016
      **/
    static testMethod void getAttachmentTestCase2() {
        getAttachmentTest(true, true, false, true, '0');
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Method to test Attachment records when Id, end date and offset are provided and start date is null.
      * @Expected Result: Method should return attachment instance for passed date range and object Id.
      * @Date: 08/07/2016
      **/
    static testMethod void getAttachmentTestCase3() {
        getAttachmentTest(true, false, true, true, '0');
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Method to test Attachment records when Id, and offset are provided with start date and end date as null.
      * @Expected Result: Method should return attachment instance for passed date range and object Id.
      * @Date: 08/07/2016
      **/
    static testMethod void getAttachmentTestCase4() {
        getAttachmentTest(true, false, false, true, '0');
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Method to test Attachment records when Id, start date,end date and offset are provided as null.
      * @Expected Result: Method should return attachment instance for passed date range and object Id.
      * @Date: 08/07/2016
      **/
    static testMethod void getAttachmentTestCase5() {
        getAttachmentTest(false, false, false, false, null);
    }
    
    /** 
      * @Author: Eternus Solutions
      * @Description: Method to test Attachment records passing start date, end date as null and invalid offset.
      * @Expected Result: Method should return attachment instance for passed date range and object Id.
      * @Date: 08/07/2016
      **/
    static testMethod void getAttachmentTestCase6() {
        getAttachmentTest(false, false, false, true, '4000');
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Method to test record count of an attachments when Id, Start and end date is provided.
      * @Expected Result: Method should return correct record count for attachment.
      * @Date: 10/08/2016
      **/
    static testMethod void getRecordCountTestCase1() {
        getRecordCountTest(true, true, true, 0, 0, 2);
    }
    
    /**
      * @Author: Eternus Solutions
      * @Description: Method to test record count of an attachments when valid Id, Start Date
      *               and null end date is provided.
      * @Expected Result: Method should return correct record count for attachment.
      * @Date: 10/08/2016
      **/
    static testMethod void getRecordCountTestCase2() {
        getRecordCountTest(true, true, false, 0, 0, 2);
    }
    
    /**
      * @Author: Eternus Solutions
      * @Description: Method to test record count of an attachments when valid Id, end date
      *               and null start date is provided.
      * @Expected Result: Method should return correct record count for attachment.
      * @Date: 10/08/2016
      **/
    static testMethod void getRecordCountTestCase3() {
        getRecordCountTest(true, false, true, 0, 0, 2);
    }
    
    /**
      * @Author: Eternus Solutions
      * @Description: Method to test record count of an attachments when valid Id
      *               and null start date, end date are provided.
      * @Expected Result: Method should return correct record count for attachment.
      * @Date: 10/08/2016
      **/
    static testMethod void getRecordCountTestCase4() {
        getRecordCountTest(true, false, false, 0, 0, 2);
    }
    
    
    /**
      * @Author: Eternus Solutions
      * @Description: Method to test record count of an attachments when 
      *               valid Id, start date, end date are provided with adding days to end date.
      * @Expected Result: Method should return correct record count for attachment.
      * @Date: 10/08/2016
      **/
    static testMethod void getRecordCountTestCase5() {
        getRecordCountTest(false, true, true, 0, 1, 0);
    }
    
    /**
      * @Author: Eternus Solutions
      * @Description: Method to test record count of an attachments when Id, start date and end date
      *              are provided as null
      * @Expected Result: Method should return correct record count for attachment.
      * @Date: 10/08/2016
      **/
    static testMethod void getRecordCountTestCase6() {
        getRecordCountTest(false, false, false, 0, 0, 0);
    }
    
    /**
      * @Author: Eternus Solutions
      * @Description: Method to test created date of attachment by passing Id and sort order.
      * @Expected Result: Method should return created date of attachment.
      * @Date: 08/07/2016
      **/
    static testMethod void getAttachmentCreatedDateTestCase1() {
        getAttachmentCreatedDateTest(true, true, 'asc');
    }
    
    /**
      * @Author: Eternus Solutions
      * @Description: Method to test created date of attachment by passing Id and blank sort order.
      * @Expected Result: Method should return created date of attachment.
      * @Date: 08/07/2016
      **/
    static testMethod void getAttachmentCreatedDateTestCase2() {
        getAttachmentCreatedDateTest(true, true, '');
    }
    
    /**
      * @Author: Eternus Solutions
      * @Description: Method to test created date of attachment by passing Id and blank sort order
      *               without creating attachment.
      * @Expected Result: Method should return created date of attachment.
      * @Date: 08/07/2016
      **/
    static testMethod void getAttachmentCreatedDateTestCase3() {
        getAttachmentCreatedDateTest(true, false, '');
    }
    
    /**
      * @Author: Eternus Solutions
      * @Description: Method to test created date of attachment by passing null Id and valid sort order
      *               without creating attachment.
      * @Expected Result: Method should return created date of attachment.
      * @Date: 08/07/2016
      **/
    static testMethod void getAttachmentCreatedDateTestCase4() {
        getAttachmentCreatedDateTest(false, false, 'asc');
    }
    
    /**
      * @Author: Eternus Solutions
      * @Description: Method to test created date of attachment by passing null Id and blank sort order
      *               without creating attachment.
      * @Expected Result: Method should return created date of attachment.
      * @Date: 08/07/2016
      **/
    static testMethod void getAttachmentCreatedDateTestCase5() {
        getAttachmentCreatedDateTest(false, false, '');
    }
    
    /**
      * @Author: Eternus Solutions
      * @Description: Method to test is tracking enabled or not for an Object by passing 
      *               - isTrackingEnabled as true
      *               - valid Object Name
      * @Expected Result: Method should check whether tracking is enabled or not
      * @Date: 09/08/2016
      **/ 
    static testMethod void getTrackedObjectsTestCase1() {
        getTrackedObjectsTest('TestObject', true);
    }
    
    /**
      * @Author: Eternus Solutions
      * @Description: Method to test is tracking enabled or not for an Object by passing 
      *               - isTrackingEnabled as false
      *               - valid Object Name
      * @Expected Result: Method should check whether tracking is enabled or not
      * @Date: 09/08/2016
      **/ 
    static testMethod void getTrackedObjectsTestCase2() {
        getTrackedObjectsTest('TestObject', false);
    }
    
    /**
      * @Author: Eternus Solutions
      * @Description: Method to test is tracking enabled or not for an Object by passing 
      *               - isTrackingEnabled as false
      *               - Object Name as blank
      * @Expected Result: Method should check whether tracking is enabled or not
      * @Date: 09/08/2016
      **/ 
    static testMethod void getTrackedObjectsTestCase3() {
        getTrackedObjectsTest('', false);
    }
    
    /**
      * @Author: Eternus Solutions
      * @Description: Method to test the first element of the list by passing empty list
      * @Expected Result: Method should check whether first element of the list is valid or not
      * @Date: 09/08/2016
      **/ 
     static testMethod void getFirstObjectTestCase1() {
        getFirstObjectTest(true, false, false, UFHTConstants.WHITE_SPACE);
    }
    
    /**
      * @Author: Eternus Solutions
      * @Description: Method to test the first element of the list by passing only one element in the list
      * @Expected Result: Method should check whether first element of the list is valid or not
      * @Date: 09/08/2016
      **/
    static testMethod void getFirstObjectTestCase2() {
        getFirstObjectTest(false, true, false, UFHTConstants.WHITE_SPACE);
    }
    
    /**
      * @Author: Eternus Solutions
      * @Description: Method to test the first element of the list by passing multiple elements in the list
      * @Expected Result: Method should check whether first element of the list is valid or not
      * @Date: 09/08/2016
      **/
    static testMethod void getFirstObjectTestCase3() {
        getFirstObjectTest(false, false, true, 'Object2');
    }
    
    /**
      * @Author: Eternus Solutions
      * @Description: Method to test the first element of the list by null list
      * @Expected Result: Method should check whether first element of the list is valid or not
      * @Date: 09/08/2016
      **/
    static testMethod void getFirstObjectTestCase4() {
        getFirstObjectTest(false, false, false, null);
    }
    
    /**
      * @Author: Eternus Solutions
      * @Description: Method to get currency symbol for logged in user when sObject is null and valid sObject.
      * @Expected Result: Method should return correct currency symbol.
      * @Date: 08/07/2016
      **/
    static testMethod void getCurrencySymbolTestCase() {
        
        String currencySymbol;
        Test.startTest();
        for(sObject sObj : getCurrencyIsoCodeData()) {
            checkAssertForGetCurrencySymbol(UltraTrackUtility.getCurrencySymbol(sObj));
        }      
        Test.stopTest(); 
    }
    
   /**
      * @Author: Eternus Solutions
      * @Description: Method to get currency symbol for logged in user when sObject is valid sObject and null.
      * @Expected Result: Method should return correct currency symbol.
      * @Date: 08/07/2016
      **/  
    static testMethod void getCurrencyIsoCodeTestCase() {

        Test.startTest();
        for(sObject sObj : getCurrencyIsoCodeData()) {
            checkAssertForGetCurrencyIsoCode(UltraTrackUtility.getCurrencyIsoCode(sObj));
        }           
        Test.stopTest(); 
    }
    
    /**
      * @Author: Eternus Solutions
      * @Description: Method to test Insert/Update is allowed for Custom Setting object and fields or not
      *               by passing valid custom setting object and valid DML operation(insert).
      * @Expected Result: Method should return true value.
      * @Date: 08/07/2016
      **/
    static testMethod void insertDMLForCustomSettingTestCase1() {
        insertDMLForCustomSettingTest('UFHT__Configuration__c', 'isInsert', true);
    }
    
    /**
      * @Author: Eternus Solutions
      * @Description: Method to test Insert/Update is allowed for Custom Setting object and fields or not
      *               by passing invalid custom setting object and valid DML operation(insert).
      * @Expected Result: Method should return false value.
      * @Date: 08/07/2016
      **/
    static testMethod void insertDMLForCustomSettingTestCase2() {
        insertDMLForCustomSettingTest('testObject', 'isInsert', false);
    }
    
    /**
      * @Author: Eternus Solutions
      * @Description: Method to test Insert/Update is allowed for Custom Setting object and fields or not
      *               by passing blank custom setting object and valid DML operation(insert).
      * @Expected Result: Method should return false value.
      * @Date: 08/07/2016
      **/
    static testMethod void insertDMLForCustomSettingTestCase3() {
        insertDMLForCustomSettingTest('', 'isInsert', false);
    }
    
    /**
      * @Author: Eternus Solutions
      * @Description: Method to test Insert/Update is allowed for Custom Setting object and fields or not
      *               by passing valid custom setting object and valid DML operation(update).
      * @Expected Result: Method should true value.
      * @Date: 08/07/2016
      **/
    static testMethod void insertDMLForCustomSettingTestCase4() {
        insertDMLForCustomSettingTest('UFHT__Configuration__c', 'isUpdate', true);
    }
    
    /**
      * @Author: Eternus Solutions
      * @Description: Method to test Insert/Update is allowed for Custom Setting object and fields or not
      *               by passing invalid custom setting object and valid DML operation(update).
      * @Expected Result: Method should return false value.
      * @Date: 08/07/2016
      **/
    static testMethod void insertDMLForCustomSettingTestCase5() {
        insertDMLForCustomSettingTest('testObject', 'isUpdate', false);
    }
    
    /**
      * @Author: Eternus Solutions
      * @Description: Method to test Insert/Update is allowed for Custom Setting object and fields or not
      *               by passing blank custom setting object and valid DML operation(update).
      * @Expected Result: Method should return false value.
      * @Date: 08/07/2016
      **/
    static testMethod void insertDMLForCustomSettingTestCase6() {
        insertDMLForCustomSettingTest('', 'isUpdate', false);
    }
    
    /**
      * @Author: Eternus Solutions
      * @Description: Method to test Insert/Update is allowed for Custom Setting object and fields or not
      *               by passing valid custom setting object and blank DML operation.
      * @Expected Result: Method should return false value.
      * @Date: 08/07/2016
      **/
    static testMethod void insertDMLForCustomSettingTestCase7() {
        insertDMLForCustomSettingTest('UFHT__Configuration__c', '', false);
    }
    
    /**
      * @Author: Eternus Solutions
      * @Description: Method to test Insert/Update is allowed for Custom Setting object and fields or not
      *               by passing blank custom setting object and blank DML operation.
      * @Expected Result: Method should return false value.
      * @Date: 08/07/2016
      **/
    static testMethod void insertDMLForCustomSettingTestCase8() {
        insertDMLForCustomSettingTest('', '', false);
    }
    
    /**
      * @Author: Eternus Solutions
      * @Description: Method to test Insert/Update is allowed for Custom Setting object and fields or not
      *               by passing valid custom setting object and invalid DML operation.
      * @Expected Result: Method should return false value.
      * @Date: 08/07/2016
      **/
    static testMethod void insertDMLForCustomSettingTestCase9() {
        insertDMLForCustomSettingTest('UFHT__Configuration__c', 'testDML', false);
    }
    
    /**
      * @Author: Eternus Solutions
      * @Description: Method to test Insert/Update is allowed for Custom Setting object and fields or not
      *               by passing invalid custom setting object and invalid DML operation.
      * @Expected Result: Method should return false value.
      * @Date: 08/07/2016
      **/
    static testMethod void insertDMLForCustomSettingTestCase10() {
        insertDMLForCustomSettingTest('testObject', 'testDML', false);
    }
    
    /**
      * @Author: Eternus Solutions
      * @Description: Method to test Insert/Update is allowed for Custom Setting object and fields or not
      *               by passing invalid custom setting object and invalid DML operation.
      * @Expected Result: Method should false value.
      * @Date: 08/07/2016
      **/
    static testMethod void insertDMLForCustomSettingTestCase11() {
        insertDMLForCustomSettingTest('Account', 'insert', false);
    }
    
    /**
     * @Author: Amruta Kumbhakarn 
     * @Description: Method to test createDynamicTestClassForAnObject by passing valid arguments
     * @Expected Result: Method should return valid String of test method.
     * @Date: 11/17/2016
     **/
    static testMethod void createDynamicTestClassForAnObjectTest() {
        list<String> dataString = new list<String>{ null, '' };
        Test.startTest();
        String testClassString = UltraTrackUtility.createDynamicTestClassForAnObject(STRINGACCOUNT, STRINGCLASSNAME);
        
        System.assertEquals(STRINGOUTPUT, testClassString);
        
        for(String stringObj : dataString) {
            for(String stringObjTwo : dataString) {
                
                testClassString = UltraTrackUtility.createDynamicTestClassForAnObject(stringObj, stringObjTwo);
            
                System.assertEquals(STRINGBLANK, testClassString);
            }
        }
        Test.stopTest();
    }
    
    /**
     * @Author: Eternus Solutions 
     * @Description: Method to test getfieldSeverityMap by passing valid object name
     * @Expected Result: Method should return valid String of test method.
     * @Date: 24/01/2017
     **/
    static testMethod void getFieldAndSeverityMapTestCase() {
        
        String fieldSeverityStr = getUltraTrackContainerSeverrityField();
        Map<String, String> fieldSeverityMap = new Map<String, String>();
        Test.startTest();
            fieldSeverityMap = UltraTrackUtility.getfieldSeverityMap(fieldSeverityStr);
        Test.stopTest();
        
        System.assertNotEquals(0, fieldSeverityMap.Size());
        //System.assertNotEquals(STRINGBLANK, fieldSeverityMap[0].value());
    }
    
    /**
     * @Author: Eternus Solutions 
     * @Description: Method to test convertFieldToTitleCase by a string
     * @Expected Result: Method should return valid String.
     * @Date: 24/01/2017
     **/
    static testMethod void convertFieldToTitleTestCase() {
        
        String upperCaseStr = 'TESTSTRING';
        String assertStr = '';
        Test.startTest();
            assertStr = UltraTrackUtility.convertFieldToTitleCase(upperCaseStr);
        Test.stopTest();
        
        System.assertEquals(assertStr, 'Teststring');
    }
    
    /**
     * @Author: Eternus Solutions 
     * @Description: Method to test getFieldNamesAndDataType by passing valid object name
     * @Expected Result: Method should return valid Map of fieldName and respective datatye.
     * @Date: 24/01/2017
     **/
    static testMethod void getFieldNamesAndDataTypeTestCase() {
        
        String objNameStr = getUltraTrackContainerObjectLabel();
        Map<String, String> fieldDataTypeMap = new Map<String, String>();
        Test.startTest();
            fieldDataTypeMap = UltraTrackUtility.getFieldNamesAndDataType(objNameStr);
        Test.stopTest();
        
        System.assertNotEquals(0, fieldDataTypeMap.Size());
        //System.assertNotEquals(STRINGBLANK, fieldSeverityMap[0].value());
    }
    
    /**
      * @Author: Eternus Solutions
      * @Description: Created test data method to fetch ultra track container Object name.
      * @Param: NA
      * @Return: Method should return ultra track container Name.
      * @Date: 01/08/2016
      **/
    static String getUltraTrackContainerSeverrityField() {
        String objFieldSeverity = [SELECT Id, Tracked_fields__c FROM Ultra_Track_Container__c LIMIT 1][0].Tracked_fields__c;
        return objFieldSeverity;
    }
    
    /**
      * @Author: Eternus Solutions
      * @Description: Created test data method to fetch ultra track container Object name.
      * @Param: NA
      * @Return: Method should return ultra track container Name.
      * @Date: 01/08/2016
      **/
    static String getUltraTrackContainerObjectLabel() {
        String objName = [SELECT Id, Object_Label__c FROM Ultra_Track_Container__c LIMIT 1][0].Object_Label__c;
        return objName;
    }
}