/**
  * @Class Name: DynamicTriggerGenericHandlerTest
  * @Description: This class contains unit tests for DynamicTriggerGenericHandler.cls
  * ====================================================================================================================
  *       Version   | Date        | Author             | Comments
  * --------------------------------------------------------------------------------------------------------------------
  *       1.0       | 03/03/2016  | Eternus Solutions   | 1.Created the Test Class for DynamicTriggerGenericHandler
  * ====================================================================================================================
  **/

@isTest
private class DynamicTriggerGenericHandlerTest {

    /**
      * @Author: Eternus Solutions
      * @Description: Created test data to return object data
      * @Param: NA
      * @Return: Method should return list of sObject
      * @Date: 22/07/2016
      **/
    static list<String> getObjectData() {
        return new list<String>{'Account',
                                'AccountInvalid',
                                null
        };
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Created test data to return selected field list
      * @Param: NA
      * @Return: Method should return list of list of Selected Fields for specific sObject.
      * @Date: 22/07/2016
      **/
    static list<list<String>> getSelectedFields() {
        return new list<list<String>>{new list<String>{'Phone', 'Name'},
                                      new list<String>{'PhoneInvalid', 'NameInvalid'},
                                      new list<String>(),
                                      null
        };
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Created test data to return map of new values for account object
      * @Param: NA
      * @Return: Method should return list of map<Id, sObject> with new values.
      * @Date: 22/07/2016
      **/
    static list<map<Id, sObject>> getNewMapForAccount(list<Account> accountList) {
        return new list <map<Id, sObject>> {
                new map<Id, sObject> {accountList[1].Id => (sObject)accountList[1]},
                new map<Id, sObject>(),
                null
        };
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Created test data to return map of old values for account object
      * @Param: accountList : list of Account
      * @Return: Method should return list of map<Id, sObject> with old values.
      * @Date: 22/07/2016
      **/
    static list<map<Id, sObject>> getOldMapForAccount(list<Account> accountList) {
         return new list <map<Id, sObject>> {
             new map<Id, sObject> {accountList[0].Id => (sObject)accountList[0]},
             new map<Id, sObject>(),
             null
        };
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Created test data to return list of Selected Field Name related to account
      * @Param: NA
      * @Return: Method should return list of Selected Field Name
      * @Date: 25/07/2016
      **/
    static list<String> getSelectedFieldNameList() {
        return new list<String>{'Phone',
                                'Name',
                                'PhoneInvalid',
                                'NameInvalid',
                                 null
        };
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Created test data  to return list of old value for Contact
      * @Param: NA
      * @Return: Method should return list of Old Value for Contact
      * @Date: 25/07/2016
      **/
    static list<String> getOldValueList() {
        return new list<String>{'123',
                                '' ,
                                null
        };
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Created test data to return list of new value for Contact
      * @Param: NA
      * @Return: Method should return list of New Value for Contact
      * @Date: 25/07/2016
      **/
    static list<String> getNewValueList() {
        return new list<String>{'1234',
                                 '' ,
                                null
        };
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Created test data to return list of Record Id
      * @Param: recordId : Record Id of sObject
      * @Return: Method should return list of Record Id
      * @Date: 25/07/2016
      **/
    static list<String> getRecordIdList(Id recordId) {
        if(recordId != null){
            return new list<String>{recordId ,
                                null
            };
        }
        return null;
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Created test data to return list of ModifiedBy Id
      * @Param: LastModifiedById : LastModifiedById of sObject
      * @Return: Method should return list of ModifiedBy Id
      * @Date: 25/07/2016
      **/
    static list<String> getModifiedByIdList(Id LastModifiedById) {
        return  new list<String> {LastModifiedById,
                                  null
        };
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test data to return list of ModifiedBy Id
      * @Param: LastModifiedDate : LastModifiedDate of sObject
      * @Return: Method should return list of ModifiedBy Id
      * @Date: 25/07/2016
      **/
    static list<DateTime> getModifiedDateList(DateTime LastModifiedDate) {
        return  new list<DateTime> {LastModifiedDate,
                                    null
        };
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Created test data to return list of Set of Relationship  Field Set
      * @Param: NA
      * @Return: Method should return list of Set of Relationship  Field Set
      * @Date: 25/07/2016
      **/
    static list<set<String>> getRelationshipFieldsNameSet() {
        return new list<set<String>>{new set<String>{'AccountId'},
                                    null,
                                    new set<String>()
        };
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Created test data to return list of list Utc Id
      * @Param: NA
      * @Return: Method should return list of list  Utc Id
      * @Date: 25/07/2016
      **/
    static list<list<Id>> getUtcIdList() {
        list<Ultra_Track_Container__c> containerList = TestDataFactory.getUltraTrackContainerList(
                                                                    new list<String>{'Account'},
                                                                    new list<String>{'Account (Account)'},
                                                                    new list<Boolean>{true},
                                                                    new list<String>{'name,phone'}
                                                                    );
        insert containerList;
        if(containerList != null && !containerList.isEmpty()){
            String attachmentBodyForAccount = '{"Phone":[], "Name":[]}';
            list<Attachment> attachmentList = TestDataFactory.getAttachementList(new list<String>
                                                           {system.Label.AttachmentFileName+'002'},
                                                           new list<blob> {blob.valueOf(attachmentBodyForAccount)},
                                                           new list<Id>{containerList[0].Id});

            insert attachmentList;
            return new list<list<Id>>{new list<Id>{containerList[0].Id},
                                      null,
                                      new list<Id>()
            };
        }
        return null;
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Created test data to return list of set of parentIds.
      * @Param: NA
      * @Return: Method should return list of  set of parentIds.
      * @Date: 25/07/2016
      **/
    static list<set<Id>> getSetParentIdsList() {
        list<set<Id>> parentIdSetOfList = new list<set<Id>>();
            set<Id> parentIdSet = new set<Id>();
            map<Id,String> idVsRecordNameMap = new map<Id,String>();
            list<Account> accountList = TestDataFactory.getAccountList(3);
            insert accountList;
            for(Account objAcc : accountList){
                parentIdSet.add(objAcc.Id);
            }
            list<Contact> contactList = TestDataFactory.getContactList(3);
            insert contactList;
            for(Contact objCon : contactList){
                parentIdSet.add(objCon.Id);
            }
            parentIdSet.add(null);
            parentIdSet.addAll(new set<Id>());
        parentIdSetOfList.add(parentIdSet);
        return parentIdSetOfList;
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Created test data to return selected field list
      * @Param: NA
      * @Return: Method should return list of field list Data.
      * @Date: 22/07/2016
      **/
    static list<list<String>> getSelectedFieldsForRelationship() {
        return new list<list<String>>{new list<String>{'AccountId', 'Lastname'},
                                      new list<String>(),
                                      null};
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Created test data to return map of New Values related to Contact
      * @Param: contactList: list of Contact
      * @Return: Method should return list of map<Id, sObject> with New Values.
      * @Date: 22/07/2016
      **/
    static list<map<Id, sObject>> getNewMapForContact(list<Contact> contactList) {
        return new list <map<Id, sObject>> {
            new map<Id, sObject> {contactList[1].Id => (sObject)contactList[1]},
            new map<Id, sObject>(),
            null
        };
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Created test data to return map of Old Values related to Contact
      * @Param: contactList: list of Contact
      * @Return: Method should return list of map<Id, sObject> with Old Values.
      * @Date: 22/07/2016
      **/
    static list<map<Id, sObject>> getOldMapForContact(list<Contact> contactList) {
        return  new list <map<Id, sObject>> {
             new map<Id, sObject> {contactList[0].Id => (sObject)contactList[0]},
             new map<Id, sObject>(),
             null
        };
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Created test data to return object data for relationship
      * @Param: NA
      * @Return: Method should return list of Object Data
      * @Date: 22/07/2016
      **/
    static list<String> getObjectDataForRelationship() {
        return new list<String>{'Contact','',null};
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Created test data to return list Of Account
      * @Param: NA
      * @Return: Method should return list of Account.
      * @Date: 22/07/2016
      **/
    static list<Account> getAccountList() {
      list<Account> accountList = new list<Account>();
      Account accountObjOld = TestDataFactory.getAccount('Test Account');
      insert accountObjOld;
      accountObjOld = [SELECT Id, Name, Phone, LastModifiedById, LastModifiedDate
                       FROM   Account
                       WHERE  Id = :accountObjOld.Id];
      accountList.add(accountObjOld);

      Account accountObjNew = new Account(Id = accountObjOld.Id,Name = 'Test123',Phone ='12345');

      update accountObjNew;

      accountList.add(accountObjNew);
      return accountList;
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Created test data to return list Of Contact
      * @Param: NA
      * @Return: Method should return list of Contact.
      * @Date: 22/07/2016
      **/
    static list<Contact> getContactList(){
        list<Contact> contactList = new list<Contact>();
        Account objAcc1 = TestDataFactory.getAccount('Test Account 1');
        insert objAcc1;
        Account objAcc2 = TestDataFactory.getAccount('Test Account 2');
        insert objAcc2;

        Contact conObj = TestDataFactory.getContact('Test Contact',objAcc1.Id);
        insert conObj;

        contactList.add(conObj);

        contactList.add(new Contact(Id = conObj.id, AccountId = objAcc2.Id, lastName = 'Test con'));
        return contactList;
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Created test data to return list Of Ultra Container list
      * @Param: NA
      * @Return: Method should return list of Ultra Container.
      * @Date: 22/07/2016
      **/
    static list<Ultra_Track_Container__c> getUltraContainerList(String fieldNames){
       list<Ultra_Track_Container__c> ultraTrackContainerList = new list<Ultra_Track_Container__c>();
       ultraTrackContainerList = TestDataFactory.getUltraTrackContainerList(new list<String> {'Account'},
                                                                            new list<String> {'Account'},
                                                                            new list<Boolean> {true},
                                                                            new list<String> {fieldNames}
                                                                           );
      insert ultraTrackContainerList;
      return ultraTrackContainerList;
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Created test data to return map Of Ultra Wrapper
      * @Param: ultraTrackContainerList : Ultra Track Container list
      * @Return: Method should return map of Ultra Wrapper.
      * @Date: 22/07/2016
      **/
    static  map<String,list<HistoryWrapper>> getMapOfUltraWrapper(list<Ultra_Track_Container__c>
                                                                                 ultraTrackContainerList){
       map<String,list<HistoryWrapper>> historyWrapperMap =  new map<String,list<HistoryWrapper>>();                                                                            
       if(!ultraTrackContainerList.isEmpty()){
             list<Attachment> updatedAttchmentList =   [SELECT  Id, Body
                                                        FROM  Attachment
                                                        WHERE ParentId =: ultraTrackContainerList[0].Id];
            historyWrapperMap = (map<String,list<HistoryWrapper>>)System.JSON.deserialize(updatedAttchmentList[0].body.toString(),
                                                                        map<String,list<HistoryWrapper>>.class);
       }                                                                                
      
      return historyWrapperMap;
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Created test data to return list of Sharing Purpose with Old and New Values
      * @Param: 1.fieldName : Field for which values need to be set
      *         2. oldValue : Old value for  Sharing Purpose Object
      *         3. newValue : New Value for  Sharing Purpose Object
      *         4. ultraTrackContainerList: Ultra Track Container list
      * @Return: Method should return  list of  Sharing Purpose with Old and New Values
      * @Date: 22/07/2016
      **/
    static list<UFHT__Sharing_Purpose__c> getSharingList(String fieldName, String oldValue, String newValue,
                                                     list<Ultra_Track_Container__c> ultraTrackContainerList ){
     list<UFHT__Sharing_Purpose__c> sharingPurposeList = new list<UFHT__Sharing_Purpose__c>();

     if(String.isNotBlank(fieldName)){
         list<Attachment> attachmentList = new list<Attachment>();
         Schema.DisplayType currentFieldType = UltraTrackUtility.getFieldType('UFHT__Sharing_Purpose__c',
                                                                                                       fieldName);

         UFHT__Sharing_Purpose__c sharePurposeObjOld = TestDataFactory.getSharing_Purpose('Test Share');
         UFHT__Sharing_Purpose__c sharePurposeObjNew = new UFHT__Sharing_Purpose__c(Name = 'Test');
         if(currentFieldType != null){
             if(currentFieldType == Schema.DisplayType.Percent) {

                sharePurposeObjOld.put(fieldName,integer.valueOf(oldValue));
                sharePurposeObjNew.put(fieldName,integer.valueOf(newValue));

             }else if(currentFieldType == Schema.DisplayType.DateTime){
                sharePurposeObjOld.put(fieldName, String.isNotBlank(oldValue) ?
                                                  getDateTimeForUserTimeZone(oldValue) :
                                                  null
                                       );
                sharePurposeObjNew.put(fieldName, String.isNotBlank(newValue) ?
                                                  getDateTimeForUserTimeZone(newValue) :
                                                  null
                                       );

             }else if(currentFieldType == Schema.DisplayType.Date){
                 sharePurposeObjOld.put(fieldName, String.isNotBlank(oldValue) ?
                                                  Date.valueOf(getDateTimeForUserTimeZone(oldValue)) :
                                                  null
                                       );
                sharePurposeObjNew.put(fieldName, String.isNotBlank(newValue) ?
                                                  Date.valueOf(getDateTimeForUserTimeZone(newValue)) :
                                                  null
                                       );
             }
             insert sharePurposeObjOld;
             sharingPurposeList.add(sharePurposeObjOld);

             sharePurposeObjNew.Id= sharePurposeObjOld.Id;
             update sharePurposeObjNew;

             sharePurposeObjNew = [SELECT Name,Id,UFHT__DateTime_Field__c,UFHT__Percent_Field__c,
                                          UFHT__Date_Field__c,LastModifiedById, LastModifiedDate
                                   FROM   UFHT__Sharing_Purpose__c
                                   WHERE  Id = :sharePurposeObjNew.Id];
             sharingPurposeList.add(sharePurposeObjNew);

             String attachmentBodyForSharingPurpose = '{"'+fieldName+'":[],"Name":[]}';
             attachmentList = TestDataFactory.getAttachementList(new list<String>
                                                                   {'UltraHistoryDataSharingPurpose'},
                                                                 new list<blob> {
                                                                   blob.valueOf(attachmentBodyForSharingPurpose)},
                                                                 new list<Id> {ultraTrackContainerList[0].Id}
                                                                 );
            insert attachmentList;
         }
     }
    return sharingPurposeList;
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Created test data to convert String into date time format
      * @Param: 1.dateTimeString : Date Time in String format
      * @Return: Method should return String converted into Date Time
      * @Date: 22/07/2016
      **/
    static DateTime getDateTimeForUserTimeZone(String dateTimeString) {

        DateTime newDateTime;
        if(String.isBlank(dateTimeString)) {
            return newDateTime;
        }

        list<String> spiltStrList = dateTimeString.split(UFHTConstants.WHITE_SPACE);

        if(spiltStrList.size() >= 2) {
            list<String> dateComponentsList = spiltStrList[0].contains(UFHTConstants.DATE_SEPARATOR_SLASH) ?
            spiltStrList[0].split(UFHTConstants.DATE_SEPARATOR_SLASH) : spiltStrList[0].split(UFHTConstants.HYPHEN);
            list<String> timeComponentsList = spiltStrList[1].split(UFHTConstants.COLON);

            if(spiltStrList[0].contains(UFHTConstants.DATE_SEPARATOR_SLASH)) {
                newDateTime = DateTime.newInstance(Integer.valueOf(dateComponentsList[2]),
                                                   Integer.valueOf(dateComponentsList[0]),
                                                   Integer.valueOf(dateComponentsList[1]),
                                                   Integer.valueOf(timeComponentsList[0]),
                                                   Integer.valueOf(timeComponentsList[1]),
                                                   0);
            }
            else if(spiltStrList[0].contains(UFHTConstants.HYPHEN)) {
                newDateTime = DateTime.newInstance(Integer.valueOf(dateComponentsList[0]),
                                                   Integer.valueOf(dateComponentsList[1]),
                                                   Integer.valueOf(dateComponentsList[2]),
                                                   Integer.valueOf(timeComponentsList[0]),
                                                   Integer.valueOf(timeComponentsList[1]),
                                                   0);
            }
            return newDateTime;
        }
        return newDateTime;
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Created test data to return list of Ultra Track Container
      * @Param: 1.fieldName: Field for which values need to be set
      * @Return: Method should return list of Ultra Track Container
      * @Date: 22/07/2016
      **/
    static list<Ultra_Track_Container__c> getUltraTrackContainerListForSharingPurpose(String fieldName){
       list<Ultra_Track_Container__c> ultraTrackContainerList = new list<Ultra_Track_Container__c>();
       ultraTrackContainerList = TestDataFactory.getUltraTrackContainerList(
                                                                       new list<String> {'UFHT__Sharing_Purpose__c'},
                                                                       new list<String> {'UFHT__Sharing_Purpose__c'},
                                                                       new list<Boolean> {true},
                                                                       new list<String> {''+fieldName+',Name'});
      insert ultraTrackContainerList;
      return ultraTrackContainerList;
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Created test data to return list of account
      * @Param: NA
      * @Return: Method should return list of account
      * @Date: 22/07/2016
      **/
    static list<Account> getAccountInUserContext(){
        list<Account> accountList = new list<Account>();

        Profile profileObj = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User userObj = TestDataFactory.getUser('User2', 'user2', 'test@user2.come', profileObj.Id );

        Account accObj = TestDataFactory.getAccount('Test Account');
        insert accObj;
        //Query to fetch Last Modified Id and Date
        accObj = [SELECT Id, Name, Phone, LastModifiedById, LastModifiedDate
                  FROM   Account
                  WHERE  Id = :accObj.Id];
        accountList.add(accObj);
        system.runAs(userObj){
          accObj.Phone = '12345';
          accObj.Name = 'Test';
          accObj.OwnerId= UserInfo.getUserID();
          update accObj;
        }

        accountList.add(new Account(Id = accObj.Id));
        return accountList;
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test method to check assert for positive and negative scenario for getHistoryWrapperInstance
      * @Expected Result: Method should check expected results with actual result
      * @Date: 25/07/2016
      **/
    static void checkAssertForGetHistoryWrapperInstance(set<String> relationshipFieldsSet,
                                                        UFHT.HistoryWrapper historyWrapperObj ,
                                                        String selectedField,
                                                        String   oldValue,
                                                        String   newValue,
                                                        String   recordId,
                                                        String   modifiedById,
                                                        DateTime   modifiedDate) {
        if( String.isBlank(selectedField)
            || String.isBlank(recordId)
            || String.isBlank(modifiedById)
            || modifiedDate == null) {
                System.assertEquals(null, historyWrapperObj);
        }
        if( relationshipFieldsSet != null
            && relationshipFieldsSet.contains(selectedField)) {
           System.assertEquals('123', historyWrapperObj.newValue);
           System.assertEquals('1234', historyWrapperObj.oldValue);
        }
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test method to check assert for positive and negative scenario related to getAttachmentsRelatedToUTC
      * @Expected Result: Method should check expected results with actual result
      * @Date: 25/07/2016
      **/
    static void checkAssertForGetAttachmentsRelatedToUTC( map<Id, Attachment> utcIdVsAttachmentsMap,list<Id> utcIdList){

        if(utcIdList == null || utcIdList.isEmpty()) {
            System.assertEquals(new map<Id, Attachment>(), utcIdVsAttachmentsMap);
        }else{
            System.assertEquals(1, utcIdVsAttachmentsMap.size());
        }
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test method to check assert for positive and negative scenario related to getRelationshipFields
      * @Expected Result: Method should check expected results with actual result
      * @Date: 25/07/2016
      **/
    static void checkAssertForGetRelationshipFields(set<String> relationshipFieldsSet,
                                                    String objectName, list<String> pSelectedFieldsList) {

        if( String.isBlank(objectName)
            || (  pSelectedFieldsList == null
            || pSelectedFieldsList.isEmpty())) {
            system.assertEquals(new set<String>(),relationshipFieldsSet);
        }
        else if(UltraTrackUtility.sobjectMap != null
                && UltraTrackUtility.sobjectMap.containsKey(objectName)) {

            DynamicTriggerGenericHandler.fieldVsFieldSchemaMap = UltraTrackUtility.getFieldType(objectName);
            if(DynamicTriggerGenericHandler.fieldVsFieldSchemaMap == null) {
                System.assertEquals(0, relationshipFieldsSet.size());
            }else{
                System.assertEquals(1, relationshipFieldsSet.size());
                System.assertEquals(true, relationshipFieldsSet.contains('AccountId'));
            }
        }
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test method to check assert for positive and negative scenario related to getAllParentRecordIds
      * @Expected Result: Method should check expected results with actual result
      * @Date: 25/07/2016
      **/
    static void checkAssertForGetAllParentRecordIds(set<Id>  parentIdsSet,
                                                    set<String> relationshipFieldsNameSet,
                                                    map<Id, sObject> newRecordsMap,
                                                    map<Id, sObject> oldRecordsMap) {

        if( relationshipFieldsNameSet == null
            || relationshipFieldsNameSet.isEmpty()
            || newRecordsMap == null
            || oldRecordsMap == null
            || parentIdsSet == null
            || oldRecordsMap.isEmpty()
            || parentIdsSet.isEmpty()
            || parentIdsSet.isEmpty()) {
            System.assertEquals(0, parentIdsSet.size());
        }
        else{
            System.assertEquals(2, parentIdsSet.size());
        }
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test method to check assert for positive and negative scenario related to getFieldsFromRecords
      * @Expected Result: Method should check expected results with actual result
      * @Date: 25/07/2016
      **/
    static void checkAssertForGetFieldsFromRecords(map <Id, set<String>> recordIdVsFieldsMap,
                                                   map<Id, sObject> newRecordsMap,
                                                   map<Id, sObject> oldRecordsMap){
      if(newRecordsMap != null && !newRecordsMap.isEmpty()) {
           System.assertEquals(1, newRecordsMap.size());
      }
      if(oldRecordsMap != null && !oldRecordsMap.isEmpty()) {
           System.assertEquals(1, oldRecordsMap.size());
      }
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test method to check assert for positive and negative scenario related to 
      *               getAndInsertHistoryAttachment
      * @Expected Result: Method should check expected results with actual result
      * @Date: 25/07/2016
      **/
    static void checkAssertForGetAndInsertHistoryAttachment(  map<Id, set<String>>
                                                              idVsRecordFieldsMap,  String objectName,
                                                              list<String> selectedFieldsList,
                                                              map<Id, sObject> newRecordsMap,
                                                              map<Id, sObject> oldRecordsMap) {
        DynamicTriggerGenericHandler dynamicTriggerHandlerObj = new DynamicTriggerGenericHandler();
        if(String.isBlank(objectName)
            || selectedFieldsList == null
            || newRecordsMap == null
            || oldRecordsMap == null) {
            System.assertEquals(null, dynamicTriggerHandlerObj.attachmentsToUpsertList);
        }
        if(idVsRecordFieldsMap != null && dynamicTriggerHandlerObj.attachmentsToUpsertList != null){
            System.assertEquals(1, dynamicTriggerHandlerObj.attachmentsToUpsertList.size());
        }
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test method to test history data is stored in attachment file under container object.
      * @Expected Result: Method should store the old and new values record into attachment file.
      * @Date: 02/03/2016
      **/
    static testMethod void onUpdateStoreHistoryDataTestCase1() {
      list<Ultra_Track_Container__c> ultraTrackContainerList = new list<Ultra_Track_Container__c>();
      list<Attachment> attachmentList = new list<Attachment>();
      list<Account> accountList = getAccountList();
      ultraTrackContainerList = getUltraContainerList('Phone,Name');
      String attachmentBodyForAccount = '{"Phone":[],"Name":[]}';
      attachmentList = TestDataFactory.getAttachementList(new list<String> {'UltraHistoryDataAccount'},
                                                          new list<blob> {blob.valueOf(attachmentBodyForAccount)},
                                                          new list<Id> {ultraTrackContainerList[0].Id});
       insert attachmentList;
       Test.startTest();
       DynamicTriggerGenericHandler dynamicTriggerHandlerObj = new DynamicTriggerGenericHandler();
       dynamicTriggerHandlerObj.onUpdateStoreHistoryData(new map<Id, Sobject>
                                                         {accountList[0].Id => (sObject)accountList[0]},
                                                         new map<Id, Sobject>
                                                         {accountList[1].Id => (sObject)accountList[1]},
                                                        'Account' );
       Test.stopTest();

        map<String,list<HistoryWrapper>> ultraTrackWapperMap = getMapOfUltraWrapper(ultraTrackContainerList);
        System.assertEquals(1, ultraTrackWapperMap.get('Name').size());
        System.assertEquals('Test Account', ultraTrackWapperMap.get('Name')[0].newValue);
        System.assertEquals(1, ultraTrackWapperMap.get('Phone').size());
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test method to test history data is updated or not into attachment file under container object.
      * @Expected Result: Method should update the attachment file and store data.
      * @Date: 02/03/2016
      **/
    static testMethod void onUpdateStoreHistoryDataTestCase2() {
        list<Ultra_Track_Container__c> ultraTrackContainerList = new list<Ultra_Track_Container__c>();
        list<Attachment> attachmentList = new list<Attachment>();
        list<Account> accountList = getAccountList();
        ultraTrackContainerList = getUltraContainerList('Phone,Name');
        String attachmentBodyForAccount = '{"Phone":[],"Name":[]}';
        attachmentList = TestDataFactory.getAttachementList(new list<String> {'UltraHistoryDataAccount'},
                                                          new list<blob> {blob.valueOf(attachmentBodyForAccount)},
                                                          new list<Id> {ultraTrackContainerList[0].Id});
        insert attachmentList;

        Test.startTest();
        DynamicTriggerGenericHandler dynamicTriggerHandlerObj = new DynamicTriggerGenericHandler();
        dynamicTriggerHandlerObj.onUpdateStoreHistoryData(new map<Id, sObject>
                                                                {accountList[0].Id => (sObject)accountList[0]},
                                                          new map<Id, sObject>
                                                                {accountList[1].Id => (sObject)accountList[1]},
                                                          'Account');
        Test.stopTest();

        map<String,list<HistoryWrapper>> ultraTrackWapperMap = getMapOfUltraWrapper(ultraTrackContainerList);

        System.assertEquals(1, ultraTrackWapperMap.get('Name').size());
        System.assertEquals('Test Account', ultraTrackWapperMap.get('Name')[0].newValue);
        System.assertEquals('Test123', ultraTrackWapperMap.get('Name')[0].oldValue);
        System.assertEquals(1, ultraTrackWapperMap.get('Phone').size());
    }

    /**
      * @Author: Eternus Solutions
      * @description: Test method to test relationship field values are stored as record name instead of id.
      * @Expected Result: Method should update the attachment file and store data.
      * @Date: 02/03/2016
      **/
    static testMethod void onUpdateStoreHistoryDataTestCase3() {

      list<Ultra_Track_Container__c> ultraTrackContainerList = new list<Ultra_Track_Container__c>();
      list<Attachment> attachmentList = new list<Attachment>();
      list<Account> accountList = getAccountInUserContext();
      ultraTrackContainerList = getUltraContainerList('Phone,Name,OwnerId');

      String attachmentBodyForAccount = '{"Phone":[],"OwnerId":[]}';

      attachmentList = TestDataFactory.getAttachementList(new list<String> {'UltraHistoryDataAccount'},
                                                          new list<blob> {blob.valueOf(attachmentBodyForAccount)},
                                                          new list<Id> {ultraTrackContainerList[0].Id});
       insert attachmentList;

       Test.startTest();
       DynamicTriggerGenericHandler dynamicTriggerHandlerObj = new DynamicTriggerGenericHandler();
       dynamicTriggerHandlerObj.onUpdateStoreHistoryData(new map<Id, sObject> {accountList[0].Id =>
                                                                               (sObject)accountList[0]},
                                                         new map<Id, sObject> {accountList[1].Id =>
                                                                                (sObject)accountList[1]},
                                                         'Account');
       Test.stopTest();

       map<String,list<HistoryWrapper>> ultraTrackWapperMap = getMapOfUltraWrapper(ultraTrackContainerList);
       System.assertEquals(1, ultraTrackWapperMap.get('OwnerId').size());
       System.assertEquals('Test', ultraTrackWapperMap.get('Name')[0].newValue);
       System.assertEquals('', ultraTrackWapperMap.get('Name')[0].oldValue);
       System.assertEquals(1, ultraTrackWapperMap.get('Phone').size());
    }

    /**
      * @Author: Eternus Solutions
      * @description: Test method to test history data stored in attachment file under container object with percent
      *               field
      * @Expected Result: Method should store the old and new values record into attachment file.
      * @Date: 02/03/2016
      **/
    static testMethod void onUpdateStoreHistoryDataTestCase4() {
       list<Ultra_Track_Container__c> ultraTrackContainerList =
                                            getUltraTrackContainerListForSharingPurpose('UFHT__Percent_Field__c');
       list<UFHT__Sharing_Purpose__c> sharingPurposeList = getSharingList('UFHT__Percent_Field__c', '0', '10',
                                                           ultraTrackContainerList);
       String attachmentBodyForAccount = '{"UFHT__Percent_Field__c":[],"Name":[]}';
       list<Attachment> attachmentList = new list<Attachment>();    
      
       attachmentList = TestDataFactory.getAttachementList(new list<String> {'UltraHistoryDataAccount'},
                                                          new list<blob> {blob.valueOf(attachmentBodyForAccount)},
                                                          new list<Id> {ultraTrackContainerList[0].Id});
       insert attachmentList;  
       Test.startTest();
       DynamicTriggerGenericHandler dynamicTriggerHandlerObj = new DynamicTriggerGenericHandler();
       dynamicTriggerHandlerObj.onUpdateStoreHistoryData(
                                    new map<Id, sObject> {sharingPurposeList[0].Id => (sObject)sharingPurposeList[0]},
                                    new map<Id, sObject> {sharingPurposeList[1].Id => (sObject)sharingPurposeList[1]},
                                    'UFHT__Sharing_Purpose__c' );
       Test.stopTest();

       map<String,list<HistoryWrapper>> ultraTrackWapperMap = getMapOfUltraWrapper(ultraTrackContainerList);
       System.assertEquals(1, ultraTrackWapperMap.get('Name').size());
       System.assertEquals(1, ultraTrackWapperMap.get('UFHT__Percent_Field__c').size());
       System.assertEquals('Test', ultraTrackWapperMap.get('Name')[0].newValue);
       System.assertEquals('Test Share', ultraTrackWapperMap.get('Name')[0].oldValue);
    }

    /**
      * @Author: Eternus Solutions
      * @description: Test method to test history data stored in attachment file under container object with date
      *               field
      * @Expected Result: Method should store the old and new values record into attachment file.
      * @Date: 02/03/2016
      **/
    static testMethod void onUpdateStoreHistoryDataTestCase5() {
       list<Ultra_Track_Container__c> ultraTrackContainerList =
                                            getUltraTrackContainerListForSharingPurpose('UFHT__Date_Field__c');
       list<UFHT__Sharing_Purpose__c> sharingPurposeList = getSharingList('UFHT__Date_Field__c', '',
                                                           system.now().formatGMT(UFHTConstants.DATE_TIME_FORMAT),
                                                           ultraTrackContainerList);
       Test.startTest();
       DynamicTriggerGenericHandler dynamicTriggerHandlerObj = new DynamicTriggerGenericHandler();
       dynamicTriggerHandlerObj.onUpdateStoreHistoryData(
                        new map<Id, sObject> {sharingPurposeList[1].Id => (sObject)sharingPurposeList[1]},
                        new map<Id, sObject> {sharingPurposeList[0].Id => (sObject)sharingPurposeList[0]},
                        'UFHT__Sharing_Purpose__c' );
       Test.stopTest();

       map<String,list<HistoryWrapper>> ultraTrackWapperMap = new map<String,list<HistoryWrapper>> ();
       ultraTrackWapperMap = getMapOfUltraWrapper(ultraTrackContainerList);
       //System.assertEquals(1, ultraTrackWapperMap.get('Name').size());
       System.assertEquals(1, ultraTrackWapperMap.get('UFHT__Date_Field__c').size());
       System.assertEquals('Test', ultraTrackWapperMap.get('Name')[0].newValue);
       System.assertEquals('Test Share', ultraTrackWapperMap.get('Name')[0].oldValue);
    }

    /**
      * @Author: Eternus Solutions
      * @description: Test method to test history data stored in attachment file under container object with date time
      *               field
      * @Expected Result: Method should store the old and new values record into attachment.
      * @Date: 02/03/2016
      **/
    static testMethod void onUpdateStoreHistoryDataTestCase6() {
       list<Ultra_Track_Container__c> ultraTrackContainerList =
                                            getUltraTrackContainerListForSharingPurpose('UFHT__DateTime_Field__c');
       list<UFHT__Sharing_Purpose__c> sharingPurposeList = getSharingList('UFHT__DateTime_Field__c', '',
                                                              system.now().formatGMT(UFHTConstants.DATE_TIME_FORMAT),
                                                              ultraTrackContainerList);
       Test.startTest();
       DynamicTriggerGenericHandler dynamicTriggerHandlerObj = new DynamicTriggerGenericHandler();
       dynamicTriggerHandlerObj.onUpdateStoreHistoryData(
                                new map<Id, sObject> {sharingPurposeList[1].Id => (sObject)sharingPurposeList[1]},
                                new map<Id, sObject> {sharingPurposeList[0].Id => (sObject)sharingPurposeList[0]},
                                'UFHT__Sharing_Purpose__c' );
       Test.stopTest();

       map<String,list<HistoryWrapper>> ultraTrackWapperMap = getMapOfUltraWrapper(ultraTrackContainerList);
       System.assertEquals(1, ultraTrackWapperMap.get('Name').size());
       System.assertEquals(1, ultraTrackWapperMap.get('UFHT__DateTime_Field__c').size());
       System.assertEquals('Test', ultraTrackWapperMap.get('Name')[0].newValue);
       System.assertEquals('Test Share', ultraTrackWapperMap.get('Name')[0].oldValue);
    }

    /**
      * @Author: Eternus Solutions
      * @description: Test method to test history data stored in attachment file under container object
      *               which contains old and new date time value
      * @Expected Result: Method should store the old and new values record into attachment file.
      * @Date: 02/03/2016
      **/
    static testMethod void onUpdateStoreHistoryDataTestCase7() {
       list<Ultra_Track_Container__c> ultraTrackContainerList =
                                            getUltraTrackContainerListForSharingPurpose('UFHT__DateTime_Field__c');
       list<UFHT__Sharing_Purpose__c> sharingPurposeList = getSharingList('UFHT__DateTime_Field__c',
                                                           system.now().formatGMT(UFHTConstants.DATE_TIME_FORMAT),
                                                           system.now().addDays(1).formatGMT(UFHTConstants.DATE_TIME_FORMAT),
                                                           ultraTrackContainerList);
       Test.startTest();
       DynamicTriggerGenericHandler dynamicTriggerHandlerObj = new DynamicTriggerGenericHandler();
       dynamicTriggerHandlerObj.onUpdateStoreHistoryData(
                                        new map<Id, sObject> {sharingPurposeList[1].Id => (sObject)sharingPurposeList[1]},
                                        new map<Id, sObject> {sharingPurposeList[0].Id => (sObject)sharingPurposeList[0]},
                                        'UFHT__Sharing_Purpose__c' );
       Test.stopTest();

       map<String,list<HistoryWrapper>> ultraTrackWapperMap = getMapOfUltraWrapper(ultraTrackContainerList);
       //System.assertEquals(1, ultraTrackWapperMap.get('Name').size());
       System.assertEquals(1, ultraTrackWapperMap.get('UFHT__DateTime_Field__c').size());
       System.assertEquals('Test', ultraTrackWapperMap.get('Name')[0].newValue);
       System.assertEquals('Test Share', ultraTrackWapperMap.get('Name')[0].oldValue);
    }

    /**
      * @Author: Eternus Solutions
      * @description: Test method to test history data stored in attachment file under container object
      *               which contains  old and new date value
      * @Expected Result: Method should store the old new values record into attachment file.
      * @Date: 02/03/2016
      **/
    static testMethod void onUpdateStoreHistoryDataTestCase8() {

       list<Ultra_Track_Container__c> ultraTrackContainerList =
                                            getUltraTrackContainerListForSharingPurpose('UFHT__Date_Field__c');
       list<UFHT__Sharing_Purpose__c> sharingPurposeList = getSharingList('UFHT__Date_Field__c',
                                                             system.now().formatGMT(UFHTConstants.DATE_TIME_FORMAT),
                                                             system.now().addDays(1).formatGMT(UFHTConstants.DATE_TIME_FORMAT),
                                                             ultraTrackContainerList);
       Test.startTest();
       DynamicTriggerGenericHandler dynamicTriggerHandlerObj = new DynamicTriggerGenericHandler();
       dynamicTriggerHandlerObj.onUpdateStoreHistoryData(
                                new map<Id, sObject> {sharingPurposeList[1].Id => (sObject)sharingPurposeList[1]},
                                new map<Id, sObject> {sharingPurposeList[0].Id => (sObject)sharingPurposeList[0]},
                                'UFHT__Sharing_Purpose__c' );
       Test.stopTest();

       map<String,list<HistoryWrapper>> ultraTrackWapperMap = new map<String,list<HistoryWrapper>> ();
       ultraTrackWapperMap = getMapOfUltraWrapper(ultraTrackContainerList);
       System.assertEquals(1, ultraTrackWapperMap.get('Name').size());
       System.assertEquals(1, ultraTrackWapperMap.get('UFHT__Date_Field__c').size());
       System.assertEquals('Test', ultraTrackWapperMap.get('Name')[0].newValue);
       System.assertEquals('Test Share', ultraTrackWapperMap.get('Name')[0].oldValue);
    }

    /**
      * @Author: Eternus Solutions
      * @Description : Test method to check old field value and new field values are different.
      * @Expected Result : Method should return true if values are different otherwise false.
      * @Date:27/05/2016
      **/
    static testMethod void isFieldValueChangedTestCase() {
        Boolean resultValid, resultBlank, resultInvalid, resultNull,resultNullValues,resultBlankValues;

        Test.startTest();
            DynamicTriggerGenericHandler dynamicTriggerHandlerObj = new DynamicTriggerGenericHandler();
            resultValid       = dynamicTriggerHandlerObj.isFieldValueChanged('test', 'test1');
            resultBlank       = dynamicTriggerHandlerObj.isFieldValueChanged('', 'test1');
            resultNull        = dynamicTriggerHandlerObj.isFieldValueChanged(null, 'test1');
            resultInvalid     = dynamicTriggerHandlerObj.isFieldValueChanged('test1', 'test1');
            resultNullValues  = dynamicTriggerHandlerObj.isFieldValueChanged(null, null);
            resultBlankValues = dynamicTriggerHandlerObj.isFieldValueChanged('', '');
        Test.stopTest();

        System.assertEquals(true, resultValid);
        System.assertEquals(true, resultBlank);
        System.assertEquals(true, resultBlank);
        System.assertEquals(false, resultNullValues);
        System.assertEquals(false, resultBlankValues);
        System.assertEquals(false, resultInvalid);
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test method to check method returns historyWrapper instance or not, if relationship field is
      *                updated.
      * @Expected Result: Method should return historyWrapper class object which should not null.
      * @Date: 30/05/2016
      **/
    static testMethod void getHistoryWrapperInstanceTestCase1() {
        list<Account> accountList = TestDataFactory.getAccountList(2);
        insert accountList;
        //Query to fetch Last Modified Id and Date
        accountList = [SELECT Id,Phone, LastModifiedById, LastModifiedDate
                       FROM   Account
                       WHERE  Id IN: accountList];

        Test.startTest();
        DynamicTriggerGenericHandler dynamicTriggerHandlerObj = new DynamicTriggerGenericHandler();
        DynamicTriggerGenericHandler.relationshipFieldsSet.add('AccountId');
        HistoryWrapper objWrapper = DynamicTriggerGenericHandler.getHistoryWrapperInstance('AccountId',
                                                               String.valueOf(accountList[0].Id),
                                                               String.valueOf(accountList[1].Id),
                                                               String.valueOf(accountList[1].Id),
                                                               String.valueOf(accountList[1].LastModifiedById),
                                                               (DateTime)accountList[1].LastModifiedDate);
        Test.stopTest();
        System.assertNotEquals(null, objWrapper);
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test method to check valid as well as invalid data for history wrapper instance
      *               instance method
      * @Expected Result: Method should check all passed values correctly assigned to variable.
      * @Date: 30/05/2016
      **/
    static testMethod void getHistoryWrapperInstanceTestCase2() {
        list<Account> accountList = getAccountList();

        Test.startTest();
        set<String> relationshipFieldsSet = DynamicTriggerGenericHandler.getRelationshipFields('Contact',
                                                    new list<String>{'AccountId', 'lastname'}
                                                    );
        for(String selectedField : getSelectedFieldNameList()) {
            for(String oldValue  : getOldValueList()) {
                for(String newValue : getNewValueList() ){
                    for(String recordId : getRecordIdList(accountList[0].Id) ){
                        for(String modifiedById : getModifiedByIdList(accountList[0].LastModifiedById) ){
                            for(DateTime modifiedDate : getModifiedDateList(accountList[0].LastModifiedDate) ){
                                HistoryWrapper historyWrapperObj = 
                                                DynamicTriggerGenericHandler.getHistoryWrapperInstance(selectedField,
                                                                                                       oldValue,
                                                                                                       newValue,
                                                                                                       recordId,
                                                                                                       modifiedById,
                                                                                                       modifiedDate);
                                                checkAssertForGetHistoryWrapperInstance( relationshipFieldsSet,
                                                                        historyWrapperObj,
                                                                        selectedField,
                                                                        oldValue,
                                                                        newValue,
                                                                        recordId,
                                                                        modifiedById,
                                                                        modifiedDate);
                            }
                         }
                     }
                }
            }
        }
        Test.stopTest();
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test method to get attachment related to  Ultra_Track_Container__c object.
      * @Expected Result: Return one attachment file related to Ultra_Track_Container__c object.
      * @Date:30/05/2016
      **/
    static testMethod void getAttachmentsRelatedToUTCTestCase1() {
        list<Ultra_Track_Container__c> containerList = TestDataFactory.getUltraTrackContainerList(
                                                                        new list<String>{'Account'},
                                                                        new list<String>{'Account (Account)'},
                                                                        new list<Boolean>{true},
                                                                        new list<String>{'name, phone'}
                                                                        );
        insert containerList;

        String attachmentBodyForAccount = '{"Phone":[],"Name":[]}';
        list<Attachment> attachmentList = TestDataFactory.getAttachementList(
                                                            new list<String>{system.Label.AttachmentFileName+'002'},
                                                            new list<blob> {blob.valueOf(attachmentBodyForAccount)},
                                                            new list<Id>{containerList[0].Id}
                                                            );
        insert attachmentList;
        Test.startTest();
        DynamicTriggerGenericHandler dynamicTriggerHandlerObj = new DynamicTriggerGenericHandler();
        map<Id,Attachment> parentIdVsAttachmentMap = dynamicTriggerHandlerObj.getAttachmentsRelatedToUTC(
                                                                                new list<Id>{containerList[0].Id});
        Test.stopTest();
        System.assertEquals(1, parentIdVsAttachmentMap.values().size());
    }

    /**
      * @Author: Eternus Solutions
      * @Description : Test method to get getAttachmentsRelatedToUTC method to check valid as well as invalid data
      * @Expected Result : Method should check all passed values correctly assigned to variable.
      * @Date:25/07/2016
      **/
    static testMethod void getAttachmentsRelatedToUTCTestCase2() {

        map<Id, Attachment> utcIdVsAttachmentsMap;
        Test.startTest();
            DynamicTriggerGenericHandler dynamicTriggerHandlerObj = new DynamicTriggerGenericHandler();
            for(list<Id> utcIdList : getUtcIdList() ){
                        utcIdVsAttachmentsMap = dynamicTriggerHandlerObj.getAttachmentsRelatedToUTC(utcIdList);
                        checkAssertForGetAttachmentsRelatedToUTC( utcIdVsAttachmentsMap, utcIdList);
            }
        Test.stopTest();
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test method getRelationshipFields to check valid as well as invalid data
      * @Expected Result: Method should check all passed values correctly assigned to variable.
      * @Date: 30/05/2016
      **/
    static testMethod void getRelationshipFieldsTestCase1() {
        Test.startTest();
        for(String objectName : getObjectDataForRelationship()) {
            for(list<String> pSelectedFieldsList : getSelectedFieldsForRelationship() ){
                        set<String> relationshipFieldsSet =
                        DynamicTriggerGenericHandler.getRelationshipFields(objectName, pSelectedFieldsList);
                        checkAssertForGetRelationshipFields(relationshipFieldsSet,
                                           objectName, pSelectedFieldsList);

            }
        }
        Test.stopTest();
    }

    /**
      * @Author: Eternus Solutions
      * @description : Test method to check relationship field with valid as well as invalid data
      * @Expected result : Method should check all passed values correctly assigned to variable.
      * @Date:30/05/2016
      **/
    static testMethod void getAllParentRecordIdsTestCase1() {
        list<Contact> contactList = new list<Contact>();
        contactList =  getContactList();
        set<Id>  parentIdsSet = new set<Id>();
        Test.startTest();
        DynamicTriggerGenericHandler.idVsRecordFieldsMap = DynamicTriggerGenericHandler.getFieldsFromRecords(
                                                  new map<Id, sObject> {contactList[0].Id => (sObject)contactList[0]},
                                                  new map<Id, sObject> {contactList[1].Id => (sObject)contactList[1]});
        for(set<String> relationshipFieldsNameSet : getRelationshipFieldsNameSet()) {
            for(map<Id, sObject> newRecordsMap : getNewMapForContact(contactList)) {
                for(map<Id, sObject> oldRecordsMap : getOldMapForContact(contactList)) {
                         parentIdsSet = DynamicTriggerGenericHandler.getAllParentRecordIds( relationshipFieldsNameSet,
                                                                                            newRecordsMap,
                                                                                            oldRecordsMap);

                         checkAssertForGetAllParentRecordIds(parentIdsSet,
                                                relationshipFieldsNameSet,
                                                newRecordsMap,
                                                oldRecordsMap);
                }
            }
        }
        Test.stopTest();
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test method to check record Names for given parent Ids.
      * @Expected Result: Method should check respected record name is obtained from the id passed.
      * @Date: 30/05/2016
      **/
    static testMethod void getIdVsRecordNameMapTestCase1() {
        set<Id> parentIdSet = new set<Id>();
        map<Id,String> idVsRecordNameMap = new map<Id,String>();
        list<Account> accountList = TestDataFactory.getAccountList(2);
        insert accountList;
        
        for(Account objAcc : accountList){
            parentIdSet.add(objAcc.Id);
        }
        
        list<Contact> contactList = TestDataFactory.getContactList(2);
        insert contactList;
        
        for(Contact objCon : contactList){
            parentIdSet.add(objCon.Id);
        }

        Test.startTest();
        idVsRecordNameMap = DynamicTriggerGenericHandler.getIdVsRecordNameMap(parentIdSet);
        Test.stopTest();
        System.assertEquals(4, idVsRecordNameMap.values().size());
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test method to check record with valid as well as invalid data for getIdVsRecordNameMap.
      * @Expected Result: Respected record name should be obtained from id.
      * @Date:30/05/2016
      **/
    static testMethod void getIdVsRecordNameMapTestCase2() {
        map<Id,String> idVsRecordNameMap = new map<Id,String>();
        Test.startTest();
            for(set<Id> pParentIdSet : getSetParentIdsList()) {
                     idVsRecordNameMap = DynamicTriggerGenericHandler.getIdVsRecordNameMap( pParentIdSet);
                     checkAssertForGetIdVsRecordNameMap(idVsRecordNameMap,pParentIdSet);
            }
        Test.stopTest();
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test Case to check assert for positive and negative scenario related to getIdVsRecordNameMap
      * @Expected Result: Method should check expected results with actual result
      * @Date: 25/07/2016
      **/
    static void checkAssertForGetIdVsRecordNameMap( map<Id,String> idVsRecordNameMap,
                                                    set<Id> pParentIdSet) {

        if(pParentIdSet == null
          || pParentIdSet.isEmpty()) {
           System.assertEquals(0, idVsRecordNameMap.values().size());
        }else{
            System.assertEquals(6, idVsRecordNameMap.values().size());
        }
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test method  createOrUpdateAttachment to test attachment is inserted or not .
      * @Expected Result: Method should return records related to that field.
      * @Date: 31/05/2016
      **/
    static testMethod void createOrUpdateAttachmentTestCase1() {

      list<Ultra_Track_Container__c> ultraTrackContainerList = new list<Ultra_Track_Container__c>();
      list<Attachment> attachmentList = new list<Attachment>();
      list<Account> accountList = new list<Account>();
      list<HistoryWrapper> historyList = new list<HistoryWrapper>();
      accountList = getAccountInUserContext();
      ultraTrackContainerList = getUltraContainerList('Phone,Name,OwnerId');

      String attachmentBodyForAccount = '{"Phone":[],"OwnerId":[]}';

      attachmentList = TestDataFactory.getAttachementList(new list<String> {'UltraHistoryDataAccount'},
                                                          new list<blob> {blob.valueOf(attachmentBodyForAccount)},
                                                          new list<Id> {ultraTrackContainerList[0].Id});
       insert attachmentList;

       historyList = TestDataFactory.getHistoryList(new list<String> {'a@b.com','c@b.com'},
                                                          new list<String> {'c@b.com','a@b.com'},
                                                          String.valueOf(accountList[1].Id),
                                                          UserInfo.getUserId(),
                                                          new list<DateTime> {system.now(),
                                                                             system.now()}
                                                         );


       test.startTest();
       DynamicTriggerGenericHandler dynamicTriggerHandlerObj = new DynamicTriggerGenericHandler();
       dynamicTriggerHandlerObj.onUpdateStoreHistoryData(new map<Id, Sobject> {accountList[1].Id => (sObject)accountList[1]},
                                                        new map<Id, Sobject> {accountList[0].Id => (sObject)accountList[0]},
                                                        'Account'
                                                        );
       dynamicTriggerHandlerObj.createOrUpdateAttachment(historyList, 'Name', 'Account');
       test.stopTest();
       System.assertEquals(2, dynamicTriggerHandlerObj.fieldVsHistoryWrapperMap.get('Name').size());
       System.assertEquals('c@b.com', dynamicTriggerHandlerObj.fieldVsHistoryWrapperMap.get('Name')[0].newValue);
       System.assertEquals('a@b.com', dynamicTriggerHandlerObj.fieldVsHistoryWrapperMap.get('Name')[0].oldValue);
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test method  createOrUpdateAttachment to test attachment inserted with
      *                MAX_RECORD_COUNT limit exceeded should create new attachment.
      * @Expected Result: Method should return records related to that field.
      * @Date:31/05/2016
      **/
    static testMethod void createOrUpdateAttachmentTestCase2() {

      list<Ultra_Track_Container__c> ultraTrackContainerList = new list<Ultra_Track_Container__c>();
      list<Attachment> attachmentList = new list<Attachment>();
      list<Account> accountList = new list<Account>();
      list<HistoryWrapper> historyList = new list<HistoryWrapper>();
      accountList = getAccountInUserContext();
      ultraTrackContainerList = getUltraContainerList('Phone,Name,OwnerId');

      String attachmentBodyForAccount = '{"Phone":[';
      for(Integer i = 0 ; i<1000;i++){
          attachmentBodyForAccount+='{"parentId":"'+accountList[0].Id+'","oldValue":"123","newValue":"12345",' +
          '"modifiedDateTime":"'+accountList[0].LastModifiedDate+'","modifiedById":"'+accountList[0].LastModifiedById+'"},';
      }
      attachmentBodyForAccount = attachmentBodyForAccount.removeEnd(',');
      attachmentBodyForAccount+=']}';
      attachmentList = TestDataFactory.getAttachementList(new list<String> {'UltraHistoryDataSD'+
                                                                            DateTime.newInstance(
                                                                            Date.today().month(),
                                                                            Date.today().day(),
                                                                            Date.today().year()).format(UFHTConstants.DATE_FORMAT)
                                                                            +'.txt'},
                                                                 new list<blob> {blob.valueOf(attachmentBodyForAccount)},
                                                                 new list<Id> {ultraTrackContainerList[0].Id}
                                                                );
       insert attachmentList;
       historyList  = TestDataFactory.getHistoryList(new list<String> {'a@b.com','c@b.com'},
                                                          new list<String> {'c@b.com','a@b.com'},
                                                          String.valueOf(accountList[1].Id),
                                                          UserInfo.getUserId(),
                                                          new list<DateTime> {system.now(),
                                                                             system.now()}
                                                         );
       test.startTest();
       DynamicTriggerGenericHandler dynamicTriggerHandlerObj = new DynamicTriggerGenericHandler();
       dynamicTriggerHandlerObj.onUpdateStoreHistoryData(new map<Id, Sobject> {accountList[0].Id => (sObject)accountList[0]},
                                                        new map<Id, Sobject> {accountList[1].Id => (sObject)accountList[1]},
                                                        'Account'
                                                        );
       dynamicTriggerHandlerObj.createOrUpdateAttachment(historyList, 'Name', 'Account');
       test.stopTest();
       System.assertEquals(dynamicTriggerHandlerObj.fieldVsHistoryWrapperMap.get('Name').size(), 3);
       System.assertEquals('Test', dynamicTriggerHandlerObj.fieldVsHistoryWrapperMap.get('Name')[0].newValue);
       System.assertEquals('', dynamicTriggerHandlerObj.fieldVsHistoryWrapperMap.get('Name')[0].oldValue);
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test method to get fields from sObject records.
      * @Expected result: Method should return set of fields from sObject records.
      * @Date:07/06/2016
      **/
    static testMethod void getFieldsFromRecordsTestCase1() {
        list<Contact> contactList = new list<Contact>();
        Contact objCon1 = TestDataFactory.getContact('Test', 'Test1', '4544', '787', 'Other');
        insert objCon1;
        contactList.add(objCon1);

        objCon1.FirstName = 'Test1';
        objCon1.LastName = 'Test';
        update objCon1;
        contactList.add(new Contact(Id = objCon1.id));

        test.startTest();
        map <Id, set<String>> recordIdVsFieldsMap = DynamicTriggerGenericHandler.getFieldsFromRecords(
                                                    new map<Id, sObject> {contactList[0].Id => (sObject)contactList[0]},
                                                    new map<Id, sObject> {contactList[1].Id => (sObject)contactList[1]}
                                                );
        test.stopTest();
        System.assertEquals(true, recordIdVsFieldsMap.get(contactList[0].Id).contains('FirstName'));
        System.assertEquals(true, recordIdVsFieldsMap.get(contactList[0].Id).contains('LeadSource'));
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test Case to check valid as well as invalid data for getFieldsFromRecords.
      * @Expected Result: Method should check all passed values correctly assigned to variable.
      * @Date: 22/07/2016
      **/
    static testMethod void getFieldsFromRecordsTestCase2() {
        list<Account> accountList = new list<Account>();
        accountList =  getAccountList();
        Test.startTest();

        for(map<Id, sObject> newRecordsMap : getNewMapForAccount(accountList)){
                for(map<Id, sObject> oldRecordsMap : getOldMapForAccount(accountList)){
                     map <Id, set<String>> recordIdVsFieldsMap =
                                            DynamicTriggerGenericHandler.getFieldsFromRecords(newRecordsMap,
                                                                                                oldRecordsMap);
                    checkAssertForGetFieldsFromRecords(recordIdVsFieldsMap,newRecordsMap,oldRecordsMap);
                }
        }
        Test.stopTest();
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test Case to check valid as well as invalid data related to getAndInsertHistoryAttachment
      * @Expected Result: Method should check all passed values correctly assigned to variable.
      * @Date: 22/07/2016
      **/
    static testMethod void getAndInsertHistoryAttachmentTestCase1() {

        list<Account> accountList = new list<Account>();
        accountList =  getAccountList();
        list<Contact> contactList = new list<Contact>();
        Account objAcc1 = TestDataFactory.getAccount('Test Account 1');
        insert objAcc1;
        Account objAcc2 = TestDataFactory.getAccount('Test Account 2');
        insert objAcc2;

        Contact conObj = TestDataFactory.getContact('Test Contact',objAcc1.Id);
        insert conObj;

        contactList.add(conObj);

        contactList.add(new Contact(Id = conObj.id, AccountId = objAcc2.Id, lastName = 'Test con'));
        Test.startTest();
        DynamicTriggerGenericHandler.idVsRecordFieldsMap =
        DynamicTriggerGenericHandler.getFieldsFromRecords(
                                                new map<Id, sObject> {contactList[0].Id => (sObject)contactList[0]},
                                                new map<Id, sObject> {contactList[1].Id => (sObject)contactList[1]});
        DynamicTriggerGenericHandler dynamicTriggerHandlerObj = new DynamicTriggerGenericHandler();
        Map<String, String> accountFieldsSeverityMap = new Map<String, String>();
        accountFieldsSeverityMap = getSeverityMapForAccount(getSelectedFields()[0]);
        dynamicTriggerHandlerObj.attchmentObj = new Attachment();
        for(String objectName : getObjectData()) {
            for(list<String> selectedFieldsList : getSelectedFields()) {
                for(map<Id, sObject> newRecordsMap : getNewMapForAccount(accountList)){
                        for(map<Id, sObject> oldRecordsMap : getOldMapForAccount(accountList)){
                            dynamicTriggerHandlerObj.getAndInsertHistoryAttachment(objectName,
                                              selectedFieldsList,
                                              newRecordsMap,
                                              oldRecordsMap,
                                              accountFieldsSeverityMap);
                            checkAssertForGetAndInsertHistoryAttachment(DynamicTriggerGenericHandler.idVsRecordFieldsMap,
                                                                        objectName,
                                                                        selectedFieldsList,
                                                                        newRecordsMap,
                                                                        oldRecordsMap
                                                                        );
                        }
                }
            }
        }
        Test.stopTest();

    }
    
    /**
      * @Author: Eternus Solutions
      * @Description: Test method to verify the recursive call of trigger for an object.
      * @Expected Result: Method should return that recursive call is not done for an object.
      * @Date: 23/11/2016
      **/
    static testMethod void verifyRecursiveCallForAnObjectTestCase1() {
        
        Test.startTest();
        Boolean isRecursiveCallForAnObject = DynamicTriggerGenericHandler.verifyRecursiveCallForAnObject('Account');
        Test.stopTest();
        System.assertEquals(false, isRecursiveCallForAnObject);
    }
    
    /**
      * @Author: Eternus Solutions
      * @Description: Test method to verify the recursive call of trigger for an object.
      * @Expected Result: Method should return that recursive call is done for an object.
      * @Date: 23/11/2016
      **/
    static testMethod void verifyRecursiveCallForAnObjectTestCase2() {
        
        Boolean isRecursiveCallForAnObject;
        
        Test.startTest();
        isRecursiveCallForAnObject = DynamicTriggerGenericHandler.verifyRecursiveCallForAnObject('Account');
        isRecursiveCallForAnObject = DynamicTriggerGenericHandler.verifyRecursiveCallForAnObject('Account');
        Test.stopTest();
        System.assertEquals(true, isRecursiveCallForAnObject);
    }
    
    /**
      * @Author: Eternus Solutions
      * @Description: Created test data to return map of new values for account object
      * @Param: NA
      * @Return: Method should return list of map<Id, sObject> with new values.
      * @Date: 08/02/2017
      **
      */
    static map<String, String> getSeverityMapForAccount(list<String> selectedFieldsList) {
        map<String, String> fieldSeverityMap = new Map<String, String>();
        for(String fieldStr : selectedFieldsList) {
            fieldSeverityMap.put(fieldStr, 'Must Have');
        }
        
        return fieldSeverityMap;
        
    }
    
}