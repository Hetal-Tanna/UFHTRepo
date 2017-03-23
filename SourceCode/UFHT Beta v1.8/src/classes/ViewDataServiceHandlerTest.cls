/**
  * @Class Name: ViewDataServiceHandlerTest
  * @Description: This class contains unit tests for ViewDataServiceHandler.cls
  * ===================================================================================================================
  *      Version   | Date        | Author                | Comments
  *  ------------------------------------------------------------------------------------------------------------------
  *      1.0       | 1/07/2016   | Eternus Solutions     | Created test class for ViewDataServiceHandler
  * ===================================================================================================================
  **/

@isTest
public class ViewDataServiceHandlerTest {

     /**
       * @Author: Eternus Solutions
       * @Description: Created test data for Selected Tracked Field list
       * @Param: NA
       * @Return: Method should return list of list Selected Tracked Field
       * @Date: 22/07/2016
       **/
    static list<list<String>> getSelectedTrackedFieldListOfList() {
        return new list<list<String>> {new list<String>{'Name'},
                                       new list<String>{'NameInvalid'},
                                       new list<String>(),
                                       null};
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Created test data for list of map<String,list<HistoryWrapper>>
      * @Param: insertedAttachment : list of Attachment
      * @Return: Method should return list of  Ultra Track Wrapper Map
      * @Date: 22/07/2016
      **/
    static  list<map<String,list<HistoryWrapper>>> getUltraTrackWrapperMap(list<Attachment> insertedAttachment) {
        map<String,list<HistoryWrapper>> ultraTrackWrapperMap = new map<String,list<HistoryWrapper>>();
        ultraTrackWrapperMap = (map<String,list<HistoryWrapper>>)System.JSON.deserialize(
                                                                 insertedAttachment[0].body.toString(),
                                                                 map<String,list<HistoryWrapper>>.class);
        return new list<map<String,list<HistoryWrapper>>>{ultraTrackWrapperMap,
                                                          new map<String,list<HistoryWrapper>>()
                                                         };
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Created test data for Selected Object
      * @Param: NA
      * @Return: Method should return list of Selected Object
      * @Date: 22/07/2016
      **/
    static list<String> getSelectedObjectList() {
        return new list<String> {'Account',
                                 'AccountInvalid',
                                 '',
                                 null};
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Created test data for Start Date and End Date list
      * @Param: NA
      * @Return: Method should return list of  Date
      * @Date: 22/07/2016
      **/
    static list<Date> getDateList() {
        return new list<Date>{Date.today(),
                              Date.today().addDays(2),
                              Date.today().addDays(3),
                              null};
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Created test data for View User Filter
      * @Param: NA
      * @Return: Method should return list of Boolean for View User Filter 
      * @Date: 22/07/2016
      **/
    static list<Boolean> getViewUserFilterList() {
        return new list<Boolean> {true,
                                  false};
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Created test data for map of fields and labels
      * @Param: selectedObject: Name of the selected object
      * @Return: Method should return list of map of fields and labels
      * @Date: 22/07/2016
      **/
    static list<map<String, String>> getFieldsAndLabelsMapList(String selectedObject) {
        return new list<map<String, String>> {UltraTrackUtility.getFieldNamesAndLabels(selectedObject),
                                                null,
                                                new map<String, String> ()};
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Created test data for Date Time in hyphen and slash format
      * @Param: NA
      * @Return: Method should return list of date time in string format
      * @Date: 22/07/2016
      **/
    static list<String> getDateTimeString(){
        return new list<String> {'07/01/2016 11:30',
                                 '2016-07-01 11:30',
                                  null};
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Created test data for list of Attachments
      * @Param: NA
      * @Return: Method should return list of Attachments
      * @Date: 22/07/2016
      **/
    static list<Attachment> getAttachments() {
        list<Ultra_Track_Container__c> ultraTrackContainerList = new list<Ultra_Track_Container__c>();
        list<Attachment> attachmentList = new list<Attachment>();
        list<HistoryWrapper> historyList = new list<HistoryWrapper>();
        String result;
        Account accountObj = TestDataFactory.getAccount('TestAccount');
        insert accountObj;

        ultraTrackContainerList = TestDataFactory.getUltraTrackContainerList(
                                                                            new list<String> {'Account','Opportunity'},
                                                                            new list<String> {'Account','Opportunity'},
                                                                            new list<Boolean> {true, false},
                                                                            new list<String> {'Email__c,Name', 'Name'}
                                                                            );
        if(!ultraTrackContainerList.isEmpty()) {
            insert ultraTrackContainerList;
        }
        historyList.addAll(TestDataFactory.getHistoryList(new list<String> {'a@b.com','c@b.com'},
                                                          new list<String> {'c@b.com','a@b.com'},
                                                          String.valueOf(accountObj.Id),
                                                          UserInfo.getUserId(),
                                                          new list<DateTime> {System.now(),
                                                                             System.now()}
                                                         ));
        String attachmentBodyForAccount = '{"Name":' + System.JSON.serialize(historyList);
        attachmentBodyForAccount += '},"Email__c":{[]}';
        String attachmentBodyForOpportunity = '{"Name":{[]}}';
        attachmentList = TestDataFactory.getAttachementList(new list<String> {'UltraHistoryDataAccount',
                                                                              'UltraHistoryDataOpportunity'},
                                                            new list<blob> {
                                                                            blob.valueOf(attachmentBodyForAccount),
                                                                            blob.valueOf(attachmentBodyForOpportunity)},
                                                            new list<Id> {ultraTrackContainerList[0].Id,
                                                                               ultraTrackContainerList[1].Id}
                                                          );
        if(!attachmentList.isEmpty()) {
            insert attachmentList;
        }
        list<Attachment> insertedAttachment = [SELECT Body, LastModifiedDate, Name
                                               FROM Attachment
                                               WHERE ParentId =: ultraTrackContainerList[0].Id
                                               AND Name LIKE :System.Label.AttachmentFileName+'%'
                                               ORDER BY LastModifiedDate Desc
                                               LIMIT 1
                                               OFFSET 0 ];
        return insertedAttachment;
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Created test data for json String in DisplayHistoryWrapper format
      * @Param: result: The Json String fetched from the method
      * @Return: Method should return json String in DisplayHistoryWrapper format
      * @Date: 22/07/2016
      **/
    static DisplayHistoryWrapper getJsonStringConvertedToDisplayHistoryWrapper(String result) {
        if(String.isNotBlank (result)){
            result = result.removeStartIgnoreCase('[');
            result = result.removeEndIgnoreCase(']');
            return (DisplayHistoryWrapper)JSON.deserialize(result, DisplayHistoryWrapper.class);
        }
        return null;
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Created test data field Value for Date Time in String format
      * @Param: NA
      * @Return: Method should return list of date time in string format
      * @Date: 22/07/2016
      **/
    static list<String> getFieldValueForDate(){
        return new list<String> {DateTime.newInstance(2016, 9, 15, 12, 30, 0).format(),
                                 null};
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Created test data for List of display field type with Date and Date Time
      * @Param: NA
      * @Return: Method should return list of display field type with Date and Date Time
      * @Date: 22/07/2016
      **/
    static list<Schema.DisplayType> getDisplayType(){
        return new list<Schema.DisplayType>{Schema.DisplayType.Date,
                                            Schema.DisplayType.DateTime,
                                            null};
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Created test data for List of Display Wrapper List with invalid data
      * @Param: NA
      * @Return: Method should return list of Display Wrapper List
      * @Date: 22/07/2016
      **/
    static list<list<DisplayHistoryWrapper>> getDisplayHistoryWrapperList(){
        return new list<list<DisplayHistoryWrapper>>{new list<DisplayHistoryWrapper>(),
                                                    null};
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Created test data for List of IdVsAccountNameMap with invalid data
      * @Param: NA
      * @Return: Method should return list of map<Id, String> consisting invalid data
      * @Date: 22/07/2016
      **/
    static list<map<Id, String>> getIdVsAccountNameMapList(){
        return new list<map<Id, String>>{new map<Id, String>(),
                                         null};
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Created test data for List of IdVsOwnerIdMap with invalid data
      * @Param: NA
      * @Return: Method should return list of map<Id, Id> consisting invalid data
      * @Date: 22/07/2016
      **/
    static list<map<Id, Id>> getIdVsOwnerIdMapList(){
        return new list<map<Id, Id>>{new map<Id, Id>(),
                                     null};
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Created test data for Map of String and list of History Wrapper
      * @Param: 1. oldValueList: list of Old Values for Sharing Purpose
      *         2. newValueList: list of New Values for Sharing Purpose
      *         3. selectedFieldList: list of fields for respective sharing object
      *         4. fieldName: Field Name to be passed in attachment body
      * @Return: Method should return Map of String and list of History Wrapper
      * @Date: 22/07/2016
      **/
    static map<String,list<HistoryWrapper>> getUltraTrackMapForSharingPurpose( list<String> oldValueList,
                                                                               list<String> newValueList,
                                                                               list<String> selectedFieldList,
                                                                               String fieldName){
        list<Ultra_Track_Container__c> ultraTrackContainerList = new list<Ultra_Track_Container__c>();
        list<Attachment> attachmentList = new list<Attachment>();
        list<HistoryWrapper> historyList = new list<HistoryWrapper>();
        String result;
        Sharing_Purpose__c shareObj = TestDataFactory.getSharing_Purpose('TestSharing');
        insert shareObj;

        ultraTrackContainerList = TestDataFactory.getUltraTrackContainerList(new list<String> {'Sharing_Purpose__c'},
                                                                             new list<String> {'Sharing_Purpose__c'},
                                                                             new list<Boolean> {true},
                                                                             selectedFieldList);
        if(!ultraTrackContainerList.isEmpty()) {
            insert ultraTrackContainerList;
        }
        historyList = TestDataFactory.getHistoryList( oldValueList,
                                                      newValueList,
                                                      String.valueOf(shareObj.Id),
                                                      UserInfo.getUserId(),
                                                      new list<DateTime> {System.now(),
                                                                          System.now()}
                                                         );
        String attachmentBodyForSharing = '{"'+fieldName+'":' + System.JSON.serialize(historyList);
        attachmentBodyForSharing += '}';

        attachmentList = TestDataFactory.getAttachementList(new list<String> {'UltraHistoryDataShare'},
                                                            new list<blob> {blob.valueOf(attachmentBodyForSharing)},
                                                            new list<Id> {ultraTrackContainerList[0].Id} );

        if(!attachmentList.isEmpty()) {
            insert attachmentList;
        }
        list<Attachment> insertedAttachment = [SELECT Body, LastModifiedDate, Name
                                               FROM Attachment
                                               WHERE parentId =: ultraTrackContainerList[0].Id
                                               AND Name LIKE :System.Label.AttachmentFileName+'%'
                                               ORDER BY LastModifiedDate Desc
                                               LIMIT 1
                                               OFFSET 0];

        return (map<String,list<HistoryWrapper>>)System.JSON.deserialize(
                                                                 insertedAttachment[0].body.toString(),
                                                                 map<String,list<HistoryWrapper>>.class);

    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test method to check assert for positive and negative scenario for getDateTimeForUserTimeZone
      * @Expected Result: Method should check expected results with actual result
      * @Date: 25/07/2016
      **/
    static void checkAssertForGetFormattedDateFieldValue(String resultedFormttedDate, String fieldValue,
                                                         Schema.DisplayType fieldType){
         if(String.isNotBlank(fieldValue)) {
            DateTime temp_DateTimeInstance = ViewDataServiceHandler.getDateTimeForUserTimeZone(fieldValue);
            String formattedDate;
            if (temp_DateTimeInstance != null) {
               if(fieldType == Schema.DisplayType.Date) {
                    formattedDate = temp_DateTimeInstance.date().format();
                }
                else if(fieldType == Schema.DisplayType.DateTime) {
                    formattedDate = temp_DateTimeInstance.format() ;
                }
            }
            System.assertEquals(formattedDate, resultedFormttedDate);
        }else{
            System.assertEquals(null, resultedFormttedDate);
        }
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test method to check assert for positive and negative scenario for getDateTimeForUserTimeZone
      * @Expected Result: Method should check expected results with actual result
      * @Date: 25/07/2016
      **/
    static void checkAssertForGetDateTimeForUserTimeZone(DateTime resultDateTime,String dateTimeString ){
        DateTime newDateTime;
        if(String.isNotBlank(dateTimeString)) {
            list<String> spiltStrList = dateTimeString.split(UFHTConstants.WHITE_SPACE);
            if(spiltStrList.size() >= 2) {
                 list<String> dateComponentsList = spiltStrList[0].contains(UFHTConstants.DATE_SEPARATOR_SLASH) ?
                           spiltStrList[0].split(UFHTConstants.DATE_SEPARATOR_SLASH) : spiltStrList[0].split('-');
                 list<String> timeComponentsList = spiltStrList[1].split(UFHTConstants.COLON);
                if(spiltStrList[0].contains(UFHTConstants.DATE_SEPARATOR_SLASH)) {
                newDateTime = DateTime.newInstanceGmt(Integer.valueOf(dateComponentsList[2]),
                                                                       Integer.valueOf(dateComponentsList[0]),
                                                                       Integer.valueOf(dateComponentsList[1]),
                                                                       Integer.valueOf(timeComponentsList[0]),
                                                                       Integer.valueOf(timeComponentsList[1]),
                                                                       0);
                }
                else if(spiltStrList[0].contains(UFHTConstants.HYPHEN)) {
                    newDateTime = DateTime.newInstanceGmt(Integer.valueOf(dateComponentsList[0]),
                                                       Integer.valueOf(dateComponentsList[1]),
                                                       Integer.valueOf(dateComponentsList[2]),
                                                       Integer.valueOf(timeComponentsList[0]),
                                                       Integer.valueOf(timeComponentsList[1]),
                                                       0);
                }
                System.assertEquals(newDateTime.format(), resultDateTime.format());
            }
        }else{
            System.assertEquals(null, resultDateTime);
        }
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test method to check assert for positive and negative scenario related to
      *               checkStartEndDateRange
      * @Expected Result: Method should check expected results with actual result
      * @Date: 25/07/2016
      **/
    static void checkAssertForCheckStartEndDateRange(Date modifiedDate,
                                                     Date startDate,
                                                     Date endDate,
                                                     Boolean flag) {
         if(modifiedDate != null &&
          ((startDate != null && endDate != null && modifiedDate >= startDate && modifiedDate <= endDate) ||
           (startDate != null && endDate == null && modifiedDate >= startDate) ||
           (startDate == null && endDate != null && modifiedDate <= endDate)) ) {
                   System.assertEquals(true, flag);
        }
        else{
            System.assertEquals(false, flag);
        }
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test method to check assert for positive and negative scenario
      * @Expected Result: Method should check expected results with actual result
      * @Date: 25/07/2016
      **/
    static void checkAssertForGetHistoryRecordsFromAttachment( map<Id, list<FieldHistoryWrapper>>
                                                              recordIdVsAllUltraTrackWrapperMap,
                                                              String selectedObject,
                                                              Date startDate,
                                                              Date endDate,
                                                              list<String> selectedTrackedFieldList,
                                                              map<String, list<HistoryWrapper>> ultraTrackWrapperMap,
                                                              map<String, String> fieldsAndLabelsMap) {
        if(String.isBlank(selectedObject) ||
           selectedTrackedFieldList == null ||
           ultraTrackWrapperMap == null ||
           selectedTrackedFieldList.isEmpty() ||
           ultraTrackWrapperMap.isEmpty() ||
           fieldsAndLabelsMap == null ||
           fieldsAndLabelsMap.isEmpty()) {
           System.assertEquals( new map<Id, list<FieldHistoryWrapper>> (),recordIdVsAllUltraTrackWrapperMap);
        }else if(!fieldsAndLabelsMap.isEmpty() && fieldsAndLabelsMap == null) {
           System.assertEquals(1,recordIdVsAllUltraTrackWrapperMap.size());
        }
    }

    /**
      * @Author: Eternus Solutions
      * @Description: getSharedHistroyRecordsForAnObject test method to test functionality with following scenarios:
      *                 1. selectedTrackedFieldList: Name 
      *                 2. ultraTrackWrapperMap: map of Ultra Track wrapper [Record of ultra Track container object]
      *                 3. selectedObject: Account
      *                 4. startDate, endDate: Date.today(), Date.today().addDays(2)
      *                 5. viewUserFilter: true
      * @Expected Result: Method should return correct number of history records.
      * @Date: 1/07/2016
      **/
    static testMethod void getSharedHistroyRecordsForAnObjectTestCase1() {
        list<Attachment> insertedAttachment = getAttachments();
        map<String,list<HistoryWrapper>> ultraTrackWrapperMap = new map<String,list<HistoryWrapper>>();
        Map<String, String> fieldSeverityMap = new Map<String, String>();
        ultraTrackWrapperMap = (map<String,list<HistoryWrapper>>)System.JSON.deserialize(
                                                                 insertedAttachment[0].body.toString(),
                                                                 map<String,list<HistoryWrapper>>.class);
        fieldSeverityMap = UltraTrackUtility.getfieldSeverityMap('Account');

        Test.startTest();
        String result = ViewDataServiceHandler.getSharedHistoryRecordsForAnObject( new list<String> {'Name'},
                                                                                   ultraTrackWrapperMap,
                                                                                   'Account',
                                                                                   Date.today(),
                                                                                   Date.today().addDays(2),
                                                                                   true, 
                                                                                   fieldSeverityMap);
        Test.stopTest();
        DisplayHistoryWrapper resultValue = getJsonStringConvertedToDisplayHistoryWrapper(result);

        System.assertEquals('a@b.com', resultValue.oldValue);
        System.assertEquals('c@b.com', resultValue.newValue);
     }

     /**
       * @Author: Eternus Solutions
       * @Description: getSharedHistroyRecordsForAnObject test  method to test functionality with following scenarios:
       *                 1. selectedTrackedFieldList: Name 
       *                 2. ultraTrackWrapperMap: map of Ultra Track wrapper [Record of ultra Track container object]
       *                 3. selectedObject: Account
       *                 4. startDate, endDate: Date.today()
       *                 5. viewUserFilter: false
       * @Expected Result: Method should return null for history records.
       * @Date: 1/07/2016
       **/
     static testMethod void getSharedHistroyRecordsForAnObjectTestCase2() {
        list<Attachment> insertedAttachment = getAttachments();
        Map<String, String> fieldSeverityMap = new Map<String, String>();
        map<String,list<HistoryWrapper>> ultraTrackWrapperMap  = (map<String,list<HistoryWrapper>>)
                                                                 System.JSON.deserialize(
                                                                 insertedAttachment[0].body.toString(),
                                                                 map<String,list<HistoryWrapper>>.class);
        fieldSeverityMap = UltraTrackUtility.getfieldSeverityMap('Account');

        Test.startTest();
        String result = ViewDataServiceHandler.getSharedHistoryRecordsForAnObject(new list<String> {'Name'},
                                                                           ultraTrackWrapperMap,
                                                                           'Account',
                                                                           Date.today(),
                                                                           Date.today(),
                                                                           false,
                                                                           fieldSeverityMap);
        Test.stopTest();

        System.assert(result == null);
     }

     /**
       * @Author: Eternus Solutions
       * @Description: getSharedHistroyRecordsForAnObject test method to test functionality with following scenarios:
       *                 1. selectedTrackedFieldList: Name 
       *                 2. ultraTrackWrapperMap: map of Ultra Track wrapper [Record of ultra Track container object]
       *                 3. selectedObject: UFHT__Sharing_Purpose__c
       *                 4. startDate, endDate: Date.today()
       *                 5. viewUserFilter: false
       * @Expected Result: Method should return correct number of history records.
       * @Date: 1/07/2016
       **/
     static testMethod void getSharedHistroyRecordsForAnObjectTestCase3() {
        Map<String, String> fieldSeverityMap = new Map<String, String>();
        map<String,list<HistoryWrapper>> ultraTrackWrapperMap = new map<String,list<HistoryWrapper>>();
        ultraTrackWrapperMap = getUltraTrackMapForSharingPurpose(new list<String> {'a@b.com', 'c@b.com'},
                                                                 new list<String> {'c@b.com', 'a@b.com'},
                                                                 new list<String> {'Name'},
                                                                 'Name');
        fieldSeverityMap = UltraTrackUtility.getfieldSeverityMap('Account');
        Test.startTest();
        String result = ViewDataServiceHandler.getSharedHistoryRecordsForAnObject(new list<String> {'Name'},
                                                                                   ultraTrackWrapperMap,
                                                                                   'UFHT__Sharing_Purpose__c',
                                                                                   Date.today(),
                                                                                   Date.today(),
                                                                                   false,
                                                                                   fieldSeverityMap);
        Test.stopTest();
        DisplayHistoryWrapper resultValue = getJsonStringConvertedToDisplayHistoryWrapper(result);

        System.assertEquals('a@b.com', resultValue.oldValue);
        System.assertEquals('c@b.com', resultValue.newValue);

     }

     /**
       * @Author: Eternus Solutions
       * @Description: getSharedHistroyRecordsForAnObject test method to test functionality with following scenarios:
       *                 1. selectedTrackedFieldList: Name 
       *                 2. ultraTrackWrapperMap: map of Ultra Track wrapper [Record of ultra Track container object]
       *                 3. selectedObject: AccountInvalid
       *                 4. startDate, endDate: Date.today()
       *                 5. viewUserFilter: true
       * @Expected Result: Method should return null for history records.
       * @Date: 1/07/2016
       **/
    static testMethod void getSharedHistroyRecordsForAnObjectTestCase4() {
        list<Attachment> insertedAttachment = getAttachments();
        Map<String, String> fieldSeverityMap = new Map<String, String>();
        map<String,list<HistoryWrapper>> ultraTrackWrapperMap = new map<String,list<HistoryWrapper>>();
        ultraTrackWrapperMap = (map<String,list<HistoryWrapper>>)System.JSON.deserialize(
                                                                 insertedAttachment[0].body.toString(),
                                                                 map<String,list<HistoryWrapper>>.class);
        fieldSeverityMap = UltraTrackUtility.getfieldSeverityMap('Account');

        Test.startTest();
        String result = ViewDataServiceHandler.getSharedHistoryRecordsForAnObject(new list<String> {'Name'},
                                                                                   ultraTrackWrapperMap,
                                                                                   'AccountInvalid',
                                                                                   Date.today(),
                                                                                   Date.today(),
                                                                                   true,
                                                                                   fieldSeverityMap);
        Test.stopTest();

        System.assert(result == null);
    }

    /**
      * @Author: Eternus Solutions
      * @Description: getSharedHistroyRecordsForAnObject test method to test functionality with following scenarios:
      *                 1. selectedTrackedFieldList: Name 
      *                 2. ultraTrackWrapperMap: null
      *                 3. selectedObject: AccountInvalid
      *                 4. startDate, endDate: Date.today()
      *                 5. viewUserFilter: true
      * @Expected Result: Method should return null for history records.
      * @Date: 1/07/2016
      **/
    static testMethod void getSharedHistroyRecordsForAnObjectTestCase5() {
        Map<String, String> fieldSeverityMap = new Map<String, String>();
        fieldSeverityMap = UltraTrackUtility.getfieldSeverityMap('Account');
        Test.startTest();
        String result = ViewDataServiceHandler.getSharedHistoryRecordsForAnObject( new list<String> {'Name'},
                                                                                   null,
                                                                                   'Account',
                                                                                   Date.today(),
                                                                                   Date.today(),
                                                                                   true,
                                                                                   fieldSeverityMap);
        Test.stopTest();

        System.assert(result == null);
    }

    /**
      * @Author: Eternus Solutions
      * @Description: getSharedHistroyRecordsForAnObject test method to test functionality with following scenarios:
      *                 1. selectedTrackedFieldList: NameInvalid 
      *                 2. ultraTrackWrapperMap: map of Ultra Track wrapper [Record of ultra Track container object]
      *                 3. selectedObject: Account
      *                 4. startDate, endDate: Date.today()
      *                 5. viewUserFilter: true
      * @Expected Result: Method should return null for history records.
      * @Date: 1/07/2016
     **/
    static testMethod void getSharedHistroyRecordsForAnObjectTestCase6() {
        list<Attachment> insertedAttachment = getAttachments();
        map<String,list<HistoryWrapper>> ultraTrackWrapperMap = new map<String,list<HistoryWrapper>>();
        Map<String, String> fieldSeverityMap = new Map<String, String>();
        fieldSeverityMap = UltraTrackUtility.getfieldSeverityMap('Account');
        ultraTrackWrapperMap = (map<String,list<HistoryWrapper>>)System.JSON.deserialize(
                                                                 insertedAttachment[0].body.toString(),
                                                                 map<String,list<HistoryWrapper>>.class);

        Test.startTest();
        String result = ViewDataServiceHandler.getSharedHistoryRecordsForAnObject(new list<String> {'NameInvalid'},
                                                                                   ultraTrackWrapperMap,
                                                                                   'Account',
                                                                                   Date.today(),
                                                                                   Date.today(),
                                                                                   true,
                                                                                   fieldSeverityMap);
        Test.stopTest();

        System.assert(result == null);
    }

    /**
      * @Author: Eternus Solutions
      * @Description: getSharedHistroyRecordsForAnObject test method to test functionality with following scenarios:
      *                 1. selectedTrackedFieldList:null
      *                 2. ultraTrackWrapperMap: map of Ultra Track wrapper [Record of ultra Track container object]
      *                 3. selectedObject: Account
      *                 4. startDate, endDate: Date.today()
      *                 5. viewUserFilter: true
      * @Expected Result: Method should return null for history records.
      * @Date: 1/07/2016
      **/
    static testMethod void getSharedHistroyRecordsForAnObjectTestCase7() {
        list<Attachment> insertedAttachment = getAttachments();
        Map<String, String> fieldSeverityMap = new Map<String, String>();
        fieldSeverityMap = UltraTrackUtility.getfieldSeverityMap('Account');
        map<String,list<HistoryWrapper>> ultraTrackWrapperMap = new map<String,list<HistoryWrapper>>();
        ultraTrackWrapperMap = (map<String,list<HistoryWrapper>>)System.JSON.deserialize(
                                                                 insertedAttachment[0].body.toString(),
                                                                 map<String,list<HistoryWrapper>>.class);

        Test.startTest();
        String result = ViewDataServiceHandler.getSharedHistoryRecordsForAnObject(null,
                                                                                   ultraTrackWrapperMap,
                                                                                   'Account',
                                                                                   Date.today(),
                                                                                   Date.today(),
                                                                                   true,
                                                                                   fieldSeverityMap);
        Test.stopTest();

        System.assert(result == null);
    }

    /**
      * @Author: Eternus Solutions
      * @Description: getSharedHistroyRecordsForAnObject test method to test functionality with following scenarios:
      *                 1. selectedTrackedFieldList:NameInvalid
      *                 2. ultraTrackWrapperMap: map of Ultra Track wrapper [Record of ultra Track container object]
      *                 3. selectedObject: AccountInvalid
      *                 4. startDate, endDate: Date.today()
      *                 5. viewUserFilter: true
      * @Expected Result: Method should return null for history records.
      * @Date: 1/07/2016
      **/
    static testMethod void getSharedHistroyRecordsForAnObjectTestCase8() {
        list<Attachment> insertedAttachment = getAttachments();
        Map<String, String> fieldSeverityMap = new Map<String, String>();
        fieldSeverityMap = UltraTrackUtility.getfieldSeverityMap('Account');
        map<String,list<HistoryWrapper>> ultraTrackWrapperMap = new map<String,list<HistoryWrapper>>();
        ultraTrackWrapperMap = (map<String,list<HistoryWrapper>>)System.JSON.deserialize(
                                                                 insertedAttachment[0].body.toString(),
                                                                 map<String,list<HistoryWrapper>>.class);

        Test.startTest();
        String result = ViewDataServiceHandler.getSharedHistoryRecordsForAnObject(new list<String> {'NameInvalid'},
                                                                                   ultraTrackWrapperMap,
                                                                                   'AccountInvalid',
                                                                                   Date.today(),
                                                                                   Date.today(),
                                                                                   true,
                                                                                   fieldSeverityMap);
        Test.stopTest();

        System.assert(result == null);
    }

    /**
      * @Author: Eternus Solutions
      * @Description: getSharedHistroyRecordsForAnObject test method to test functionality with following scenarios:
      *                 1. selectedTrackedFieldList:UFHT__Date_Field__c
      *                 2. ultraTrackWrapperMap: map of Ultra Track wrapper [Record of ultra Track container object]
      *                 3. selectedObject: UFHT__Sharing_Purpose__c
      *                 4. startDate, endDate: Date.today(),Date.today().addDays(9)
      *                 5. viewUserFilter: false
      * @Expected Result: Method should check all passed values correctly assigned to variable.
      * @Date: 1/07/2016
      **/
    static testMethod void getSharedHistoryRecordsForAnObjectTestCase9() {
        map<String,list<HistoryWrapper>> ultraTrackWrapperMap = new map<String,list<HistoryWrapper>>();
        Map<String, String> fieldSeverityMap = new Map<String, String>();
        fieldSeverityMap = UltraTrackUtility.getfieldSeverityMap('Account');
        ultraTrackWrapperMap = getUltraTrackMapForSharingPurpose(new list<String> {
                                                    System.now().formatGMT(UFHTConstants.DATE_TIME_FORMAT) ,
                                                    System.now().AddDays(2).formatGMT(UFHTConstants.DATE_TIME_FORMAT) },
                                                    new list<String> {
                                                    System.now().AddDays(1).formatGMT(UFHTConstants.DATE_TIME_FORMAT),
                                                    System.now().AddDays(3).formatGMT(UFHTConstants.DATE_TIME_FORMAT)},
                                                    new list<String> {'UFHT__Date_Field__c','UFHT__Date_Field__c'},
                                                    'UFHT__Date_Field__c');

        Test.startTest();
        String result = ViewDataServiceHandler.getSharedHistoryRecordsForAnObject(
                                                                           new list<String> {'UFHT__Date_Field__c'},
                                                                           ultraTrackWrapperMap,
                                                                           'UFHT__Sharing_Purpose__c',
                                                                           Date.today(),
                                                                           Date.today().addDays(9),
                                                                           false,
                                                                           fieldSeverityMap);
        Test.stopTest();

        DisplayHistoryWrapper resultValue = getJsonStringConvertedToDisplayHistoryWrapper(result);
        System.assertEquals(String.valueOf(System.today().format()), resultValue.oldValue);
        System.assertEquals(String.valueOf(System.today().AddDays(1).format()), resultValue.newValue);
    }

    /**
      * @Author: Eternus Solutions
      * @Description: getSharedHistroyRecordsForAnObject test method to test functionality with following scenarios:
      *                 1. selectedTrackedFieldList:UFHT__Date_Field__c
      *                 2. ultraTrackWrapperMap: map of Ultra Track wrapper [Record of ultra Track container object]
      *                 3. selectedObject: UFHT__Sharing_Purpose__c
      *                 4. startDate, endDate: null,Date.today().addDays(9)
      *                 5. viewUserFilter: false
      * @Expected Result: Method should check all passed values correctly assigned to variable.
      * @Date: 1/07/2016
      **/
    static testMethod void getSharedHistoryRecordsForAnObjectTestCase10() {
        map<String,list<HistoryWrapper>> ultraTrackWrapperMap = new map<String,list<HistoryWrapper>>();
        Map<String, String> fieldSeverityMap = new Map<String, String>();
        fieldSeverityMap = UltraTrackUtility.getfieldSeverityMap('Account');
        ultraTrackWrapperMap = getUltraTrackMapForSharingPurpose(new list<String> {
                                                                    System.now().format(),System.now().format()},
                                                                 new list<String> {
                                                                    System.now().format(),System.now().format()},
                                                                 new list<String> {'UFHT__Date_Field__c',
                                                                                   'UFHT__Date_Field__c'},
                                                                 'UFHT__Date_Field__c');
        Test.startTest();
        String result = ViewDataServiceHandler.getSharedHistoryRecordsForAnObject(
                                                                           new list<String> {'UFHT__Date_Field__c'},
                                                                           ultraTrackWrapperMap,
                                                                           'UFHT__Sharing_Purpose__c',
                                                                           null,
                                                                           Date.today().addDays(-29),
                                                                           false,
                                                                           fieldSeverityMap);
        Test.stopTest();
        DisplayHistoryWrapper resultValue = getJsonStringConvertedToDisplayHistoryWrapper(result);
        System.assertEquals(null, resultValue);
    }

     /**
       * @Author: Eternus Solutions
       * @Description: getHistoryRecordsFromAttachment test method to test functionality with following scenarios:
       *               Test Case to check  invalid as well as valid data.
       *               Pass selected object and related parameter.
       * @Expected Result: Method should check all passed values correctly assigned to variable.
       * @Date: 1/07/2016
       **/
    static testMethod void getHistoryRecordsFromAttachmentTestCase1() {
        list<Attachment> insertedAttachment = getAttachments();
        map<Id, list<FieldHistoryWrapper>> recordIdVsAllUltraTrackWrapperMap;
        Test.startTest();
        for(list<String> selectedTrackedFieldList : getSelectedTrackedFieldListOfList()) {
            for(map<String, list<HistoryWrapper>> ultraTrackWrapperMap : getUltraTrackWrapperMap(insertedAttachment)) {
                for(String selectedObject : getSelectedObjectList()){
                        for(Date startDate  : getDateList()){
                              for(Date endDate : getDateList()){
                                  for( map<String, String> fieldsAndLabelsMap :
                                                                        getFieldsAndLabelsMapList(selectedObject)){
                                      recordIdVsAllUltraTrackWrapperMap =
                                                ViewDataServiceHandler.getHistoryRecordsFromAttachment( selectedObject,
                                                                           startDate,
                                                                           endDate,
                                                                           selectedTrackedFieldList,
                                                                           ultraTrackWrapperMap,
                                                                           fieldsAndLabelsMap);
                                     checkAssertForGetHistoryRecordsFromAttachment(recordIdVsAllUltraTrackWrapperMap,
                                                                           selectedObject,
                                                                           startDate,
                                                                           endDate,
                                                                           selectedTrackedFieldList,
                                                                           ultraTrackWrapperMap,
                                                                           fieldsAndLabelsMap);
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
      * @Description: Test getHistoryRecordsAsPerUser method with invalid  data for
      *               selectedObject, viewUserFilter, displayAllHistoryWrapperList, idVsAccountNameMap and
      *               idVsOwnerIdMap
      * @Expected Result: Method should check all passed values correctly assigned to variable.
      * @Date: 01/07/2016
      **/
     static testMethod void getHistoryRecordsAsPerUserTestCase(){
        String result;
        Test.startTest();
        for(String selectedObject : getSelectedObjectList()){
            for( Boolean viewUserFilter : getViewUserFilterList()){
                for(list<DisplayHistoryWrapper> displayAllHistoryWrapperList : getDisplayHistoryWrapperList()){
                    for(map<Id, String> idVsAccountNameMap : getIdVsAccountNameMapList()){
                        for( map<Id, Id> idVsOwnerIdMap : getIdVsOwnerIdMapList()){
                        result = ViewDataServiceHandler.getHistoryRecordsAsPerUser(selectedObject,
                                                                            viewUserFilter,
                                                                            displayAllHistoryWrapperList,
                                                                            idVsAccountNameMap,
                                                                            idVsOwnerIdMap);
                        }
                    }
                }
            }
        }
        Test.stopTest();
        System.assert(result == null);
     }

    /**
      * @Author: Eternus Solutions
      * @Description: Test checkStartEndDateRange test method to test functionality by passing invalid and valid
      *               date values for modifiedDate, startDate, endDate.
      * @Expected Result: Method should return boolean value as expected.
      * @Date: 01/07/2016
      **/
     static testMethod void checkStartEndDateRangeTestCase(){
         Test.startTest();
            for(Date modifiedDate: getDateList()){
                for(Date startDate: getDateList()){
                    for(Date endDate: getDateList()){
                        Boolean flag = ViewDataServiceHandler.checkStartEndDateRange(modifiedDate, startDate, endDate);
                        checkAssertForCheckStartEndDateRange(modifiedDate,startDate,endDate,flag);
                    }
                }
            }

         Test.stopTest();

     }

    /**
      * @Author: Eternus Solutions
      * @Description: Test getDateTimeForUserTimeZone test method to test functionality with following scenarios:
      *               Passed date to method with null, '/' and '-'
      * @Expected Result: Method should check expected results with actual result.
      * @Date: 01/07/2016
      **/
    static testmethod void getDateTimeForUserTimeZoneTestCase() {
        DateTime resultDateTime;
        Test.startTest();
        for(String dateTimeString : getDateTimeString()){
            resultDateTime = ViewDataServiceHandler.getDateTimeForUserTimeZone(dateTimeString);
            checkAssertForGetDateTimeForUserTimeZone(resultDateTime, dateTimeString);
        }
        Test.stopTest();
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test getFormattedDateFieldValue test method to test functionality with following scenarios:
      *               Passed fieldValue and Schema.DisplayType with valid as well as invalid data
      * @Expected Result: Method should check expected results with actual result
      * @Date: 01/07/2016
      **/
     static testMethod void getFormattedDateFieldValueTestCase() {
        Test.startTest();
        for(String fieldValue: getFieldValueForDate()){
            for(Schema.DisplayType fieldType : getDisplayType()){
                String resultedFormttedDate = ViewDataServiceHandler.getFormattedDateFieldValue(fieldValue,fieldType);
                checkAssertForGetFormattedDateFieldValue(resultedFormttedDate, fieldValue, fieldType);
            }
        }

        Test.stopTest();
     }
}