/*
 * Class Name: ViewDataServiceHandlerTest
 * @Description: Test class for ViewDataServiceHandler class.
  ============================================================================================
        Version   | Date        | Author              | Comments
    ------------------------------------------------------------------------------------------
        1.0       | 1-07-2016  | Eternus Solution   | Created test class for ViewDataServiceHandler
   ===========================================================================================
*/
@isTest
public class ViewDataServiceHandlerTest {

    /** 
     * @Author: Eternus Solutions
     * @Description: getSharedHistroyRecordsForAnObject test
     *               Insert record of ultra Track container object and attchment related to it.
     *               Pass selected object and related parameter.
     * Expected Result: Method should correct number of history records.
     * @Date: 1-07-2016
     */ 
    static testMethod void getSharedHistroyRecordsForAnObjectTestCase1() {
        
        list<Ultra_Track_Container__c> ultraTrackContainerList = new list<Ultra_Track_Container__c>();
        list<Attachment> attachmentList = new list<Attachment>();
        list<HistoryWrapper> historyList = new list<HistoryWrapper>();
        map<string,List<HistoryWrapper>> ultraTrackWrapperMap = new map<string,List<HistoryWrapper>>();
        Account accountObj = TestDataFactory.getAccount('TestAccount');
        insert accountObj;
        string result;
        
        ultraTrackContainerList.addAll(TestDataFactory.getUltraTrackContainerList(new list<string> {'Account','Opportunity'},
                                                                                  new list<string> {'Account','Opportunity'},
                                                                                  new list<boolean> {true, false},
                                                                                  new list<string> {'Email__c,Name', 'Name'}
                                                                                  )
                                      );
        if(!ultraTrackContainerList.isEmpty()) {
            insert ultraTrackContainerList;
        }
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
        attachmentList.addAll(TestDataFactory.getAttachementList(new list<string> {'UltraHistoryDataAccount',
                                                                                   'UltraHistoryDataOpportunity'},
                                                                 new list<blob> {blob.valueOf(attachmentBodyForAccount),
                                                                                 blob.valueOf(attachmentBodyForOpportunity)},
                                                                 new list<Id> {ultraTrackContainerList[0].Id,
                                                                               ultraTrackContainerList[1].Id}
                                                                )
                             );
        if(!attachmentList.isEmpty()) {
            insert attachmentList;
        }
        list<Attachment> insertedAttachment = [SELECT body, LastModifiedDate, Name  
                                               FROM Attachment
                                               WHERE parentID =: ultraTrackContainerList[0].Id
                                               AND Name like :system.Label.AttachmentFileName+'%' 
                                               order by LastModifiedDate Desc
                                               limit 1
                                               offset 0
                                               ];
        
        ultraTrackWrapperMap = (map<string,List<HistoryWrapper>>)System.JSON.deserialize(
                                                                 insertedAttachment[0].body.toString(), 
                                                                 map<string,List<HistoryWrapper>>.class);
        
        test.startTest();
        result = ViewDataServiceHandler.getSharedHistroyRecordsForAnObject(new list<string> {'Name'},
                                                                           ultraTrackWrapperMap,
                                                                           'Account',
                                                                           Date.today(),
                                                                           Date.today(),
                                                                           true);
        test.stopTest();
        
       list<object> resultList = (list<object>)JSON.deserializeUntyped(result);
       
       system.assertEquals(resultList.size(),2);
        
     }
     
     /** 
     * @Author: Eternus Solutions
     * @Description: getSharedHistroyRecordsForAnObject test
     *               Insert record of ultra Track container object and attchment related to it.
     *               Pass selected object and related parameter for an user who is not system admin.
     * Expected Result: Method should return zero number of history records. 
     * @Date: 1-07-2016
     */ 
     static testMethod void getSharedHistroyRecordsForAnObjectTestCase2() {
        
        list<Ultra_Track_Container__c> ultraTrackContainerList = new list<Ultra_Track_Container__c>();
        list<Attachment> attachmentList = new list<Attachment>();
        list<HistoryWrapper> historyList = new list<HistoryWrapper>();
        map<string,List<HistoryWrapper>> ultraTrackWrapperMap = new map<string,List<HistoryWrapper>>();
        Account accountObj = TestDataFactory.getAccount('TestAccount');
        insert accountObj;
        string result;
        
        ultraTrackContainerList.addAll(TestDataFactory.getUltraTrackContainerList(new list<string> {'Account','Opportunity'},
                                                                                  new list<string> {'Account','Opportunity'},
                                                                                  new list<boolean> {true, false},
                                                                                  new list<string> {'Email__c,Name', 'Name'}
                                                                                  )
                                      );
        if(!ultraTrackContainerList.isEmpty()) {
            insert ultraTrackContainerList;
        }
        
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
        attachmentList.addAll(TestDataFactory.getAttachementList(new list<string> {'UltraHistoryDataAccount',
                                                                                   'UltraHistoryDataOpportunity'},
                                                                 new list<blob> {blob.valueOf(attachmentBodyForAccount),
                                                                                 blob.valueOf(attachmentBodyForOpportunity)},
                                                                 new list<Id> {ultraTrackContainerList[0].Id,
                                                                               ultraTrackContainerList[1].Id}
                                                                )
                             );
        if(!attachmentList.isEmpty()) {
            insert attachmentList;
        }
        list<Attachment> insertedAttachment = [SELECT body, LastModifiedDate, Name  
                                               FROM Attachment
                                               WHERE parentID =: ultraTrackContainerList[0].Id
                                               AND Name like :system.Label.AttachmentFileName+'%' 
                                               order by LastModifiedDate Desc
                                               limit 1
                                               offset 0
                                               ];
        
        ultraTrackWrapperMap = (map<string,List<HistoryWrapper>>)System.JSON.deserialize(
                                                                 insertedAttachment[0].body.toString(), 
                                                                 map<string,List<HistoryWrapper>>.class);
        
        test.startTest();
        result = ViewDataServiceHandler.getSharedHistroyRecordsForAnObject(new list<string> {'Name'},
                                                                           ultraTrackWrapperMap,
                                                                           'Account',
                                                                           Date.today(),
                                                                           Date.today(),
                                                                           false);
        test.stopTest();
        
        system.assert(result == null);
        
     }
     
     /** 
     * @Author: Eternus Solutions
     * @Description: getSharedHistroyRecordsForAnObject test
     *               Insert record of ultra Track container object and attchment related to it.
     *               Pass selected object and related parameter for an user who is not system admin.
     * Expected Result: Method should return correct number of history records. 
     * @Date: 1-07-2016
     */ 
     static testMethod void getSharedHistroyRecordsForAnObjectTestCase3() {
        
        list<Ultra_Track_Container__c> ultraTrackContainerList = new list<Ultra_Track_Container__c>();
        list<Attachment> attachmentList = new list<Attachment>();
        list<HistoryWrapper> historyList = new list<HistoryWrapper>();
        map<string,List<HistoryWrapper>> ultraTrackWrapperMap = new map<string,List<HistoryWrapper>>();
        Sharing_Purpose__c accountObj = TestDataFactory.getSharing_Purpose('TestSharing');
        insert accountObj;
        string result;
        
        ultraTrackContainerList.addAll(TestDataFactory.getUltraTrackContainerList(new list<string> {'Sharing_Purpose__c'},
                                                                                  new list<string> {'Sharing_Purpose__c'},
                                                                                  new list<boolean> {true},
                                                                                  new list<string> {'Name'}
                                                                                  )
                                      );
        if(!ultraTrackContainerList.isEmpty()) {
            insert ultraTrackContainerList;
        }
        historyList.addAll(TestDataFactory.getHistoryList(new list<string> {'a@b.com','c@b.com'},
                                                          new list<string> {'c@b.com','a@b.com'},
                                                          string.ValueOf(accountObj.Id),
                                                          UserInfo.getUserId(),
                                                          new list<DateTime> {system.now(),
                                                                             system.now()}
                                                         )
                           );
        string attachmentBodyForAccount = '{"Name":' + System.JSON.serialize(historyList); 
        attachmentBodyForAccount += '}';
        attachmentList.addAll(TestDataFactory.getAttachementList(new list<string> {'UltraHistoryDataAccount'},
                                                                 new list<blob> {blob.valueOf(attachmentBodyForAccount)},
                                                                 new list<Id> {ultraTrackContainerList[0].Id}
                                                                )
                             );
        if(!attachmentList.isEmpty()) {
            insert attachmentList;
        }
        list<Attachment> insertedAttachment = [SELECT body, LastModifiedDate, Name  
                                               FROM Attachment
                                               WHERE parentID =: ultraTrackContainerList[0].Id
                                               AND Name like :system.Label.AttachmentFileName+'%' 
                                               order by LastModifiedDate Desc
                                               limit 1
                                               offset 0
                                               ];
        
        ultraTrackWrapperMap = (map<string,List<HistoryWrapper>>)System.JSON.deserialize(
                                                                 insertedAttachment[0].body.toString(), 
                                                                 map<string,List<HistoryWrapper>>.class);
        
        test.startTest();
        result = ViewDataServiceHandler.getSharedHistroyRecordsForAnObject(new list<string> {'Name'},
                                                                           ultraTrackWrapperMap,
                                                                           'UFHT__Sharing_Purpose__c',
                                                                           Date.today(),
                                                                           Date.today(),
                                                                           false);
        test.stopTest();
        list<object> resultList = (list<object>)JSON.deserializeUntyped(result);
        system.assertEquals(resultList.size(),2);
        
     }
     
      /** 
     * @Author Eternus Solutions
     * @Description: Test checkStartEndDateRange method.If startDate is null and modified
                     date is less then end date.
     * Expected Result: Method should return boolean value.
     * @Date: 01-07-2016
     */
     static testMethod void checkStartEndDateRangeTestCase1(){
        
         boolean flag;
         test.startTest();
         flag = ViewDataServiceHandler.checkStartEndDateRange(Date.today(), null, Date.today().addDays(30));
         test.stopTest();
         system.assertEquals(true,flag);
     }
     /** 
     * @Author Eternus Solutions
     * @Description: Test checkStartEndDateRange method. 
     *               if endDate is null and modified date is grater than startDate.
     * Expected Result: Method should return boolean value.
     * @Date: 01-07-2016
     */
     static testMethod void checkStartEndDateRangeTestCase2(){
         boolean flag;
         test.startTest();
         flag = ViewDataServiceHandler.checkStartEndDateRange(Date.today().addDays(3), Date.today(), null);
         test.stopTest();
         system.assertEquals(true,flag);
     }
     
     /** 
     * @Author Eternus Solutions
     * @Description: Test getDateTimeForUserTimeZone method. 
     *               Pass date to method with '/'
     * Expected Result: Method should return string date in correct user format.
     * @Date: 01-07-2016
     */
     static testmethod void getDateTimeForUserTimeZoneTestCase1() {
        DateTime resultDateTime;
        test.startTest();
        resultDateTime = ViewDataServiceHandler.getDateTimeForUserTimeZone('07/01/2016 11:30');
        test.stopTest();
        system.assertEquals('1/07/2016 8:30 PM', resultDateTime.format());
     }
     
     /** 
     * @Author Eternus Solutions
     * @Description: Test getDateTimeForUserTimeZone method. 
     *               Pass date to method with '-'
     * Expected Result: Method should return string date in correct user format.
     * @Date: 01-07-2016
     */
     static testmethod void getDateTimeForUserTimeZoneTestCase2() {
        DateTime resultDateTime;
        test.startTest();
        resultDateTime = ViewDataServiceHandler.getDateTimeForUserTimeZone('2016-07-01 11:30');
        test.stopTest();
        system.assertEquals('1/07/2016 8:30 PM', resultDateTime.format());
     }
     
     /** 
     * @Author Eternus Solutions
     * @Description: Test getDateTimeForUserTimeZone method. 
     *               Pass null date.
     * Expected Result: Method should return null.
     * @Date: 01-07-2016
     */
     static testmethod void getDateTimeForUserTimeZoneTestCase3() {
        DateTime resultDateTime;
        test.startTest();
        resultDateTime = ViewDataServiceHandler.getDateTimeForUserTimeZone(null);
        test.stopTest();
        system.assertEquals(null, resultDateTime);
     }
     
     /** 
     * @Author Eternus Solutions
     * @Description: Test getFormattedDateFieldValue method. 
     *               Pass date time to method.
     * Expected Result: Method should return string date in correct user format.
     * @Date: 01-07-2016
     */
     static testMethod void getFormattedDateFieldValueTestCase1() {
        string resultedFormttedDate;
        test.startTest();
        resultedFormttedDate = ViewDataServiceHandler.getFormattedDateFieldValue('07/01/2016 11:30', Schema.DisplayType.Date);
        test.stopTest();
        system.assertEquals('1/07/2016', resultedFormttedDate);
     }
     
     /** 
     * @Author Eternus Solutions
     * @Description: Test getFormattedDateFieldValue method. 
     *               Pass date time to method.
     * Expected Result: Method should return string datetime in correct user format.
     * @Date: 01-07-2016
     */
     static testMethod void getFormattedDateFieldValueTestCase2() {
        string resultedFormttedDate;
        test.startTest();
        resultedFormttedDate = ViewDataServiceHandler.getFormattedDateFieldValue('07/01/2016 11:30', Schema.DisplayType.DateTime);
        test.stopTest();
        system.assertEquals('07/01/2016 08:30 PM', resultedFormttedDate);
     }
      /** 
     * @Author Eternus Solutions
     * @Description: Test getFormattedDateFieldValue method. 
     *               Pass null to method.
     * Expected Result: Method should return null.
     * @Date: 01-07-2016
     */
     static testMethod void getFormattedDateFieldValueTestCase3() {
        string resultedFormttedDate;
        test.startTest();
        resultedFormttedDate = ViewDataServiceHandler.getFormattedDateFieldValue(null, Schema.DisplayType.DateTime);
        test.stopTest();
        system.assertEquals(null, resultedFormttedDate);
     }
}