/**
 * Class Name: DynamicTriggerGenericHandlerTest
 * @description: Test class for DynamicTriggerGenericHandler class.
 * @author: Eternus Solutions
 * @date:  03-03-2016
 * @revised:   
 */
@isTest
private class DynamicTriggerGenericHandlerTest {
    
    
   /** 
     * @author: Eternus Solutions
     * @description: Test method to test history data is stored in attachment file under container object.
     * Expected Result: Method should store the old new values record into attachment file.
     * @date: 02-03-2016
    */  
   static testMethod void onUpdateStoreHistoryDataTestCase1() {
      list<Ultra_Track_Container__c> ultraTrackContainerList = new list<Ultra_Track_Container__c>();
      list<Attachment> attachmentList = new list<Attachment>();
      list<Account> accountList = new list<Account>();
      
      Account accObj = TestDataFactory.getAccount('Test Account');
      insert accObj;
      
      accountList.add(accObj);
      accObj.Phone = '12345';
      accObj.Name = 'Test';
      update accObj;
      
      accountList.add(new Account(Id = accObj.Id));

      ultraTrackContainerList.addAll(TestDataFactory.getUltraTrackContainerList(new list<string> {'Account'},
                                                                                  new list<string> {'Account'},
                                                                                  new list<boolean> {true},
                                                                                  new list<string> {'Phone,Name'}
                                                                                  )
                                      );
        
      insert ultraTrackContainerList;
      
      string attachmentBodyForAccount = '{"Phone":[],"Name":[]}';
      attachmentList.addAll(TestDataFactory.getAttachementList(new list<string> {'UltraHistoryDataAccount'},
                                                                 new list<blob> {blob.valueOf(attachmentBodyForAccount)},
                                                                 new list<Id> {ultraTrackContainerList[0].Id}
                                                                )
                             );
       insert attachmentList;
       
       DynamicTriggerGenericHandler dynamicTriggerHandlerObj = new DynamicTriggerGenericHandler();
       test.startTest();
       dynamicTriggerHandlerObj.onUpdateStoreHistoryData(new Map<Id, Sobject> {accountList[0].Id => (sObject)accountList[0]},
                                                        new Map<Id, Sobject> {accountList[1].Id => (sObject)accountList[1]},
                                                        'Account'
                                                        );
       test.stopTest();
       
       List<Attachment> updatedAttchmentList = [select Id, Body
                                               from Attachment
                                               where ParentId =: ultraTrackContainerList[0].Id
                                               ];
       map<String,List<HistoryWrapper>> ultraTrackWapperMap = (map<String,List<HistoryWrapper>>)
                                                            System.JSON.deserialize(updatedAttchmentList[0].body.toString(), 
                                                            map<String,List<HistoryWrapper>>.class);
       system.assertEquals(1, ultraTrackWapperMap.get('Name').size());
       system.assertEquals(1, ultraTrackWapperMap.get('Phone').size());
   }
    /** 
     * @author: Eternus Solutions
     * @description: Test method to test history data is updated or not into attachment file under container object.
     * Expected Result: Method should update the attachment file and store data.
     * @date: 02-03-2016
    */ 
    static testMethod void onUpdateStoreHistoryDataTestCase2() {
      
      list<Ultra_Track_Container__c> ultraTrackContainerList = new list<Ultra_Track_Container__c>();
      list<Attachment> attachmentList = new list<Attachment>();
      list<Account> accountList = new list<Account>();
      
      Account accObj = TestDataFactory.getAccount('Test Account');
      insert accObj;
      
      accountList.add(accObj);
      accObj.Phone = '12345';
      accObj.Name = 'Test';
      update accObj;
      
      accountList.add(new Account(Id = accObj.Id));

      ultraTrackContainerList.addAll(TestDataFactory.getUltraTrackContainerList(new list<string> {'Account'},
                                                                                  new list<string> {'Account'},
                                                                                  new list<boolean> {true},
                                                                                  new list<string> {'Phone,Name'}
                                                                                  )
                                      );
        
      insert ultraTrackContainerList;
     
       DynamicTriggerGenericHandler dynamicTriggerHandlerObj = new DynamicTriggerGenericHandler();
       test.startTest();
       dynamicTriggerHandlerObj.onUpdateStoreHistoryData(new Map<Id, Sobject> {accountList[0].Id => (sObject)accountList[0]},
                                                        new Map<Id, Sobject> {accountList[1].Id => (sObject)accountList[1]},
                                                        'Account'
                                                        );
       test.stopTest();
       
       List<Attachment> updatedAttchmentList = [select Id, Body
                                               from Attachment
                                               where ParentId =: ultraTrackContainerList[0].Id
                                               ];
       map<String,List<HistoryWrapper>> ultraTrackWapperMap = (map<String,List<HistoryWrapper>>)
                                                            System.JSON.deserialize(updatedAttchmentList[0].body.toString(), 
                                                            map<String,List<HistoryWrapper>>.class);
       system.assertEquals(1, ultraTrackWapperMap.get('Name').size());
       system.assertEquals(1, ultraTrackWapperMap.get('Phone').size());
   }
   
    /** 
     * @author: Eternus Solutions
     * @description: Test method to test relationship field values are stored as record name insted of id.
     * Expected Result: Method should update the attachment file and store data.
     * @date: 02-03-2016
    */ 
   static testMethod void onUpdateStoreHistoryDataTestCase3() {
      
      list<Ultra_Track_Container__c> ultraTrackContainerList = new list<Ultra_Track_Container__c>();
      list<Attachment> attachmentList = new list<Attachment>();
      list<Account> accountList = new list<Account>();
      Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = TestDataFactory.getUser('User2', 'user2', 'test@user2.come', p.Id );
        
      Account accObj = TestDataFactory.getAccount('Test Account');
      insert accObj;
      
      accountList.add(accObj);
      system.runAs(u){
      accObj.Phone = '12345';
      accObj.Name = 'Test';
      accObj.OwnerId= UserInfo.getUserID();
      update accObj;
      }
      
      
      accountList.add(new Account(Id = accObj.Id));


      ultraTrackContainerList.addAll(TestDataFactory.getUltraTrackContainerList(new list<string> {'Account'},
                                                                                  new list<string> {'Account'},
                                                                                  new list<boolean> {true},
                                                                                  new list<string> {'Phone,Name,OwnerId'}
                                                                                  )
                                      );
        
      insert ultraTrackContainerList;
      
      string attachmentBodyForAccount = '{"Phone":[],"OwnerId":[]}';
                                         
      attachmentList.addAll(TestDataFactory.getAttachementList(new list<string> {'UltraHistoryDataAccount'},
                                                                 new list<blob> {blob.valueOf(attachmentBodyForAccount)},
                                                                 new list<Id> {ultraTrackContainerList[0].Id}
                                                                )
                             );
       insert attachmentList;
       
       DynamicTriggerGenericHandler dynamicTriggerHandlerObj = new DynamicTriggerGenericHandler();
       test.startTest();
       dynamicTriggerHandlerObj.onUpdateStoreHistoryData(new Map<Id, Sobject> {accountList[0].Id => (sObject)accountList[0]},
                                                        new Map<Id, Sobject> {accountList[1].Id => (sObject)accountList[1]},
                                                        'Account'
                                                        );
       test.stopTest();
       
       List<Attachment> updatedAttchmentList = [select Id, Body
                                               from Attachment
                                               where ParentId =: ultraTrackContainerList[0].Id
                                               ];
       map<String,List<HistoryWrapper>> ultraTrackWapperMap = (map<String,List<HistoryWrapper>>)
                                                            System.JSON.deserialize(updatedAttchmentList[0].body.toString(), 
                                                            map<String,List<HistoryWrapper>>.class);
       system.assertEquals(1, ultraTrackWapperMap.get('OwnerId').size());
       system.assertEquals(1, ultraTrackWapperMap.get('Phone').size());
   }
   /**
       * @Author: Eternus Solutions
       * @description : Method to check old field value and new field values are diffrent.
       * @Expected result : return true if values are diffrent otherwise false.
       * @Date:27/05/2016
    */
    static testMethod void isFieldValueChangedTestCase1() {
        boolean result;
        DynamicTriggerGenericHandler obj = new DynamicTriggerGenericHandler();
        test.startTest();
        result = obj.isFieldValueChanged('test','test1');
        system.assertEquals(true,result);
        result = obj.isFieldValueChanged('','test1');
        system.assertEquals(true,result);
        result = obj.isFieldValueChanged('test1','test1');
        system.assertEquals(false,result);
        test.stopTest();
        
    }
    /**
       * @Author: Eternus Solutions
       * @description : Test method to check method returns historyWrapper instance or not, if updated field is not relationship type.
       * @Expected result : returned history wrapper object should not null.
       * @Date:27/05/2016
    */
    static testMethod void getHistoryWrapperInstanceTestCase1() {
    	Account accObj = TestDataFactory.getAccount('TestAccount');
    	insert accObj;
    	
    	DynamicTriggerGenericHandler obj = new DynamicTriggerGenericHandler();
    	test.startTest();
    	HistoryWrapper objWrapper = DynamicTriggerGenericHandler.getHistoryWrapperInstance('phone', '1234',
    														   '123', 
    														   string.valueOf(accObj.ID), 
    														   string.valueOf(accObj.LastModifiedById), 
    														   (DateTime)accObj.LastModifiedDate);
    	test.stopTest();
    	system.assertNotEquals(null,objWrapper);
    }
    /**
       * @Author: Eternus Solutions
       * @description : Test method to check method returns historyWrapper instance or not, if relationship field is updated.
       * @Expected result : Returned historyWrapper class object should not null.
       * @Date:30/05/2016
    */
    static testMethod void getHistoryWrapperInstanceTestCase2() {
    	List<Account> lstAccount = TestDataFactory.getAccountList(2);
    	insert lstAccount;
    	
    	DynamicTriggerGenericHandler obj = new DynamicTriggerGenericHandler();
    	DynamicTriggerGenericHandler.setRelationshipFields.add('AccountId');
    	test.startTest();
    	HistoryWrapper objWrapper = DynamicTriggerGenericHandler.getHistoryWrapperInstance('AccountId', string.valueOf(lstAccount[0].ID),
    														   string.valueOf(lstAccount[1].ID), 
    														   string.valueOf(lstAccount[1].ID), 
    														   string.valueOf(lstAccount[1].LastModifiedById), 
    														   (DateTime)lstAccount[1].LastModifiedDate);
    	test.stopTest();
    	system.assertNotEquals(null,objWrapper);
    }
    /**
       * @Author: Eternus Solutions
       * @description : test method to get attachment related to  Ultra_Track_Container__c object.
       * @Expected result :  return the 1 attachment file related to Ultra_Track_Container__c object.
       * @Date:30/05/2016
    */
    static testMethod void getAttachmentsRelatedToUTCTestCase1() {
    	list<Ultra_Track_Container__c> lstContainer = TestDataFactory.getUltraTrackContainerList(
	    																new list<String>{'Account'},
	    																new list<String>{'Account (Account)'},
	    																new list<boolean>{true},
	    																new list<String>{'name,phone'}
	    																);
    	insert lstContainer;
    	
    	string attachmentBodyForAccount = '{"Phone":[],"Name":[]}';
    	list<Attachment> lstAttachment = TestDataFactory.getAttachementList(new list<String>{system.Label.AttachmentFileName+'002'},
    														new list<blob> {blob.valueOf(attachmentBodyForAccount)},
    														new list<ID>{lstContainer[0].ID}
    														);
  		insert lstAttachment;
  		DynamicTriggerGenericHandler obj = new DynamicTriggerGenericHandler();
  		
  		test.startTest();
  		map<ID,Attachment> mapParentIdVsAttachment = obj.getAttachmentsRelatedToUTC(new list<ID>{lstContainer[0].ID});
  		test.stopTest();
  		system.assertEquals(1,mapParentIdVsAttachment.values().size());
    }
    /**
       * @Author: Eternus Solutions
       * @description : Test method to get relationship fields from sObject record. 
       * @Expected result : method should return relationship field set.
       * @Date:30/05/2016
    */
    static testMethod void getRelationshipFieldsTestCase1() {
    	Account accObj = TestDataFactory.getAccount('TestAccount');
    	insert accObj;
    	
    	Contact conObj = TestDataFactory.getContact('Test',accObj.ID);
    	insert conObj;
    	
    	DynamicTriggerGenericHandler obj = new DynamicTriggerGenericHandler();
    	test.startTest();
    	set<String> setRelationshipFields = DynamicTriggerGenericHandler.getRelationshipFields('Contact',
    												new list<String>{'AccountId','lastname'},
    												(sObject)conObj,(sObject)conObj
    												);
    	test.stopTest();
    	system.assertEquals(setRelationshipFields.size(),1);
    	
    }
    /**
       * @Author: Eternus Solutions
       * @description : Test method to check relationship field id values 
       * @Expected result : result should be set of parentid which are in relationship field.
       * @Date:30/05/2016
    */
    static testMethod void getAllParentRecordIdsTestCase1() {
    	list<Contact> lstContact = new list<Contact>();
    	Account objAcc1 = TestDataFactory.getAccount('Test Account 1');
    	insert objAcc1;
    	Account objAcc2 = TestDataFactory.getAccount('Test Account 2');
    	insert objAcc2;
    	
    	Contact conObj = TestDataFactory.getContact('Test Contact',objAcc1.ID);
    	insert conObj;
    	
    	lstContact.add(conObj);
    	
    	lstContact.add(new Contact(ID = conObj.id, AccountId = objAcc2.Id, lastName = 'Test con'));
    	DynamicTriggerGenericHandler obj = new DynamicTriggerGenericHandler();
    	test.startTest();
    	set<ID> setParentID = DynamicTriggerGenericHandler.getAllParentRecordIds(new set<String>{'AccountId'},
    													new Map<Id, Sobject> {lstContact[0].Id => (sObject)lstContact[0]},
                                                        new Map<Id, Sobject> {lstContact[1].Id => (sObject)lstContact[1]}
    													);
    	test.stopTest();
    	system.assertEquals(setParentID.size(),2);
    	
    }
    /**
       * @Author: Eternus Solutions
       * @description : test method to check record Names for given parent Ids. 
       * @Expected result : respected record name should be get from id. 
       * @Date:30/05/2016
    */
    static testMethod void getIdVsRecordNameMapTestCase1() {
    	set<ID> setParentId = new set<ID>();
    	map<ID,String> mapIdVsRecordName = new map<ID,String>();
    	List<Account> lstAccount = TestDataFactory.getAccountList(3);
    	insert lstAccount;
    	for(Account objAcc : lstAccount){
    		setParentId.add(objAcc.ID);
    	}
    	system.debug('Test == '+setParentId);
    	List<Contact> lstContact = TestDataFactory.getContactList(3);
    	insert lstContact;
    	for(Contact objCon : lstContact){
    		setParentId.add(objCon.ID);
    	}
    	system.debug('Test == '+setParentId);
    	DynamicTriggerGenericHandler obj = new DynamicTriggerGenericHandler();
    	test.startTest();
    	mapIdVsRecordName = DynamicTriggerGenericHandler.getIdVsRecordNameMap(setParentId);
    	test.stopTest();
    	system.debug('Test mp== '+mapIdVsRecordName);
    	system.assertEquals(mapIdVsRecordName.values().size(),6);
    }
    
    static testMethod void createOrUpdateAttachmentTestCase() {
    	
      list<Ultra_Track_Container__c> ultraTrackContainerList = new list<Ultra_Track_Container__c>();
      list<Attachment> attachmentList = new list<Attachment>();
      list<Account> accountList = new list<Account>();
      list<HistoryWrapper> historyList = new list<HistoryWrapper>();
      Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
      User u = TestDataFactory.getUser('User2', 'user2', 'test@user2.come', p.Id );
        
      Account accObj = TestDataFactory.getAccount('Test Account');
      insert accObj;
      
      accountList.add(accObj);
      system.runAs(u){
      accObj.Phone = '12345';
      accObj.Name = 'Test';
      accObj.OwnerId= UserInfo.getUserID();
      update accObj;
      }
      
      
      accountList.add(new Account(Id = accObj.Id));


      ultraTrackContainerList.addAll(TestDataFactory.getUltraTrackContainerList(new list<string> {'Account'},
                                                                                  new list<string> {'Account'},
                                                                                  new list<boolean> {true},
                                                                                  new list<string> {'Phone,Name,OwnerId'}
                                                                                  )
                                      );
        
      insert ultraTrackContainerList;
      
      string attachmentBodyForAccount = '{"Phone":[],"OwnerId":[]}';
                                         
      attachmentList.addAll(TestDataFactory.getAttachementList(new list<string> {'UltraHistoryDataAccount'},
                                                                 new list<blob> {blob.valueOf(attachmentBodyForAccount)},
                                                                 new list<Id> {ultraTrackContainerList[0].Id}
                                                                )
                             );
       insert attachmentList;
       
       historyList.addAll(TestDataFactory.getHistoryList(new list<string> {'a@b.com','c@b.com'},
                                                          new list<string> {'c@b.com','a@b.com'},
                                                          string.ValueOf(accObj.Id),
                                                          UserInfo.getUserId(),
                                                          new list<DateTime> {system.now(),
                                                                             system.now()}
                                                         )
                           );
       
       DynamicTriggerGenericHandler dynamicTriggerHandlerObj = new DynamicTriggerGenericHandler();
       dynamicTriggerHandlerObj.onUpdateStoreHistoryData(new Map<Id, Sobject> {accountList[0].Id => (sObject)accountList[0]},
                                                        new Map<Id, Sobject> {accountList[1].Id => (sObject)accountList[1]},
                                                        'Account'
                                                        );
       test.startTest();
       dynamicTriggerHandlerObj.createOrUpdateAttachment(historyList, 'Name', 'Account');
       test.stopTest();
       
       system.assertEquals(dynamicTriggerHandlerObj.mapFieldVsHistoryWapper.get('Name').size(), 3);
    } 
}