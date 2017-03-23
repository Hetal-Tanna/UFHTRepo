/**
  * @Class Name: DataProviderForViewDataTest
  * @Description: This class contains unit tests for DataProviderForViewData.cls
  * ====================================================================================================================
  *       Version   | Date        | Author             | Comments
  * --------------------------------------------------------------------------------------------------------------------
  *       1.0       | 07/04/2016  | Eternus Solutions  | 1. Created test class for DataProviderForViewData.
  * ====================================================================================================================
  **/
@isTest
private class DataProviderForViewDataTest {

    /**
      * @Author: Eternus Solutions
      * @Description: Test method to create test data which will be used in test methods to test the functionality.
      * @Return: NA
      * @Date: 07/04/2016
      **/
    @testSetup
    static void setupTestData() {

        list<Ultra_Track_Container__c> ultraTrackContainerList = new list<Ultra_Track_Container__c>();
        list<Attachment> attachmentList = new list<Attachment>();
        list<HistoryWrapper> historyList = new list<HistoryWrapper>();
        map<String, list<HistoryWrapper>> ultraTrackWrapperMap = new map<String, list<HistoryWrapper>>();
        list<HistoryWrapper> historyForShareObjectList = new list<HistoryWrapper>();

        //Insert Account object data
        Account accountObj = TestDataFactory.getAccount('TestAccount');
        insert accountObj;

        //Insert Sharing Purpose object data
        Sharing_Purpose__c shareObj = TestDataFactory.getSharing_Purpose('test1');
        insert shareObj;

        //Insert ultra track container data
        Date todayDate = Date.today();
        ultraTrackContainerList = TestDataFactory.getUltraTrackContainerList(new list<String> {'Account', 'Sharing_Purpose__c', 'Opportunity'},
                                                                                 new list<String> {'Account (Account)', 'Sharing Purpose (Sharing_Purpose__c)', 'Opportunity (Opportunity)'},
                                                                                 new list<Boolean> {true, true, false},
                                                                                 new list<String> {'Name', 'Name', 'Name'}
                                                                             );

        insert ultraTrackContainerList;

        //Create history wrapper list for account
        historyList = TestDataFactory.getHistoryList(new list<String> {'a@b.com','c@b.com'},
                                                     new list<String> {'c@b.com','a@b.com'},
                                                     String.valueOf(accountObj.Id),
                                                     UserInfo.getUserId(),
                                                     new list<DateTime> {
                                                                         System.now(),
                                                                         System.now()
                                                                        }
                                                    );


        String attachmentBodyForAccount = '{"Name":' + System.JSON.serialize(historyList);
        attachmentBodyForAccount += '},"Email__c":{[]}';
        String attachmentBodyForOpportunity = '{"Name":{[]}}';

        //Create history wrapper list for Sahring purpose object
        historyForShareObjectList = TestDataFactory.getHistoryList(new list<String> {'a@bc.com','c@bc.com'},
                                                                   new list<String> {'c@bc.com','a@bc.com'},
                                                                   String.valueOf(shareObj.Id),
                                                                   UserInfo.getUserId(),
                                                                   new list<DateTime> {
                                                                                       System.now(),
                                                                                       System.now()
                                                                                      }
                                                                  );

        String attachmentBodyForShareObject = '{"Name":' + System.JSON.serialize(historyForShareObjectList);
        attachmentBodyForShareObject += '},"Email__c":{[]}';

        //Insert Attachment data for Account, Sharing purpose and opportunity objects
        attachmentList = TestDataFactory.getAttachementList(new list<String> {
                                                                                 'UltraHistoryDataAccountSD' +
                                                                                  DateTime.newInstance(todayDate.year(),
                                                                                  todayDate.month(),
                                                                                  todayDate.day()).format('MM/dd/YYYY'),
                                                                                  'UltraHistoryDataShareObjectSD' +
                                                                                  DateTime.newInstance(todayDate.year(),
                                                                                  todayDate.month(),
                                                                                  todayDate.day()).format('MM/dd/YYYY'),
                                                                                  'UltraHistoryDataOpportunity'
                                                                              },
                                                                              new list<blob> {blob.valueOf(attachmentBodyForAccount),
                                                                              blob.valueOf(attachmentBodyForShareObject),
                                                                              blob.valueOf(attachmentBodyForOpportunity)},
                                                                              new list<Id> {ultraTrackContainerList[0].Id,
                                                                              ultraTrackContainerList[1].Id,
                                                                              ultraTrackContainerList[2].Id}
                                                           );
        insert attachmentList;
        TestUtil.checkAssertsForSetupData('Account', 1);
        TestUtil.checkAssertsForSetupData('Sharing_Purpose__c', 1);
        TestUtil.checkAssertsForSetupData('Ultra_Track_Container__c', ultraTrackContainerList.size());
        TestUtil.checkAssertsForSetupData('Attachment', attachmentList.size());
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Created test data method to fetch ultra track container Id.
      * @Param: NA
      * @Return: Method should return ultra track container Id.
      * @Date: 01/08/2016
      **/
    static String getUltraTrackContainerId() {
        Id objId = [SELECT Id FROM Ultra_Track_Container__c LIMIT 1][0].Id;
        return String.valueOf(objId);
    }

     /**
       * @Author: Eternus Solutions
       * @Description: Created test data method to create start/end date.
       * @Param: NA
       * @Return: Method should return start/end date.
       * @Date: 01/08/2016
       **/
    static String getStartAndEndDate() {
        String day = String.valueOf(System.today().day());
        String month = String.valueOf(System.today().month());
        String year = String.valueOf(System.today().year());
        String startAndEndDate = (day+UFHTConstants.DATE_SEPARATOR_SLASH+month+UFHTConstants.DATE_SEPARATOR_SLASH+year);
        return startAndEndDate;
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test method to verify assert for count of attachment records for selected object.
      * @Param: 1. selectedObjectId: to display selected object Id
      *         2. startDate: to display start date
      *         3. endDate: to display end date
      * @Expected Result: Method should check the attachment count of selected object.
      * @Date: 22/07/2016
      **/
    static void getAttachmentCountAssert(Id selectedObjectId, String startDate, String endDate) {

        Integer attachmentCount =  DataProviderForViewData.getAttachmentCount(
                                                            selectedObjectId,
                                                            startDate,
                                                            endDate
        );

        System.assertEquals(1, attachmentCount);
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test method to verify the functionality for fetching attachments of selected object.
      * @Param: 1. selectedObjectId: to display selected object Id
      *         2. startDate: to display start date
      *         3. endDate: to display end date
      *         4. userFlag: to display records to specific user
      *         5. offSetStr: to display offset
      * @Expected Result: Method should check expected results with actual result.
      * @Date: 01/08/2016
      **/
    static void fetchAttachmentsAssert(Id selectedObjectId,
                                       String startDateStr,
                                       String endDateStr,
                                       Boolean userFlag,
                                       String offSetStr) {

        Test.startTest();
        String jsonResult = DataProviderForViewData.fetchAttachments(String.valueOf(selectedObjectId),
                                                                     startDateStr,
                                                                     endDateStr,
                                                                     userFlag,
                                                                     offSetStr);

        Test.stopTest();

        if(String.isBlank(jsonResult)) {
            if(jsonResult != null) {
                System.assertEquals(UFHTConstants.EMPTY_STRING, jsonResult);
            }
            else{
                System.assertEquals(null, jsonResult);
            }
        }
        else{
            //Attachment is inserted for account object, so that checks jsonresult contains account id or not
            list<Account> accountList = [SELECT Id FROM Account LIMIT 1];
            System.assertEquals(true, jsonResult.contains(accountList[0].Id));
        }
    }

     /**
       * @Author: Eternus Solutions
       * @Description: Test Method to verify the functionality for attachment count of selected object
       *               with following scenario: Passed all parameter with valid , null and empty data.
       * @Expected Result: Method should check the attachment count.
       * @Date: 22/07/2016
       **/
    static testMethod void getAttachmentCountTestCase() {

        list<Id> selectedObjectList = new list<Id>     {getUltraTrackContainerId()};
        list<String> startDateList  = new list<String> {null, UFHTConstants.WHITE_SPACE, getStartAndEndDate()};
        list<String> endDateList    = new list<String> {null, UFHTConstants.WHITE_SPACE, getStartAndEndDate()};

        Test.startTest();
        for(String selectedObjectRef : selectedObjectList) {
            for(String startDateRef : startDateList) {
                for(String endDateRef : endDateList) {
                     getAttachmentCountAssert(
                            selectedObjectRef,
                            startDateRef,
                            endDateRef
                     );
                }
            }
        }
        Test.stopTest();
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test Method to verify the functionality for fetching attachments of selected object
      *               with following scenario: Passed all parameter with valid data.
      * @Expected Result: Method should check jsonResult should return valid json data of the selected object.
      * @Date: 22/07/2016
      **/
    static testMethod void fetchAttachmentsTestCase1() {

        fetchAttachmentsAssert(getUltraTrackContainerId(),
                               getStartAndEndDate(),
                               getStartAndEndDate(),
                               true,
                               '0');
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test Method to verify the functionality for fetching attachments of selected object
      *               with following scenario: Passed selected object id as null and other parameters with valid data.
      * @Expected Result: Method should check jsonResult should return empty string.
      * @Date: 22/07/2016
      **/
    static testMethod void fetchAttachmentsTestCase2() {

        fetchAttachmentsAssert(null,
                               getStartAndEndDate(),
                               getStartAndEndDate(),
                               true,
                               '0');
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test Method to verify the functionality for fetching attachments of selected object
      *               with following scenario: Passed offset value as null and other parameters with valid data.
      * @Expected Result: Method should check jsonResult should return empty string.
      * @Date: 22/07/2016
      **/
    static testMethod void fetchAttachmentsTestCase3() {

        fetchAttachmentsAssert(getUltraTrackContainerId(),
                               getStartAndEndDate(),
                               getStartAndEndDate(),
                               true,
                               null);
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test Method to verify the functionality for fetching attachments of selected object
      *               with following scenario: Passed userFlag value as null and other parameters with valid data.
      * @Expected Result: Method should check jsonResult should return json values as null.
      * @Date: 22/07/2016
      **/
    static testMethod void fetchAttachmentsTestCase4() {

        Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
        User user1 = TestDataFactory.getUser('User1', 'user1', 'test@user1.come', p.Id);

        String jsonResult;
        
        Test.startTest();
        //To check standard user have the access to the data or not if passed userflag as null
        System.runAs(user1) {
        jsonResult = DataProviderForViewData.fetchAttachments(getUltraTrackContainerId(),
                                                              System.today().format(),
                                                              System.today().format(),
                                                              null,
                                                              '0');
        }

        Test.stopTest();
        if(jsonResult != null) {
                System.assertEquals(UFHTConstants.EMPTY_STRING, jsonResult);
        }else{
                System.assertEquals(null, jsonResult);
        }
        
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test Method to verify the functionality for fetching attachments of selected object
      *               with following scenario: Passed offset value as blank and other parameters with valid data.
      * @Expected Result: Method should check jsonResult should return empty string.
      * @Date: 22/07/2016
      **/
    static testMethod void fetchAttachmentsTestCase5() {

        fetchAttachmentsAssert(getUltraTrackContainerId(),
                               getStartAndEndDate(),
                               getStartAndEndDate(),
                               true,
                               '');
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test Method to verify the functionality for fetching attachments of selected object
      *               with following scenario: Passed all parameter values as null.
      * @Expected Result: Method should check jsonResult should return empty string.
      * @Date: 22/07/2016
      **/
    static testMethod void fetchAttachmentsTestCase6() {

        fetchAttachmentsAssert(null,
                               null,
                               null,
                               null,
                               null);
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test Method to verify the functionality for fetching attachments of selected object
      *               with following scenario: Passed offSetStr value as '0' and other parameters with null values.
      * @Expected Result: Method should check jsonResult should return empty string.
      * @Date: 22/07/2016
      **/
    static testMethod void fetchAttachmentsTestCase7() {

        fetchAttachmentsAssert(null,
                               null,
                               null,
                               null,
                               '0');
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test Method to verify the functionality for fetching attachments of selected object
      *               with following scenario: Passed userFlag value as true and other parameters with null values.
      * @Expected Result: Method should check jsonResult should return empty string.
      * @Date: 22/07/2016
      **/
    static testMethod void fetchAttachmentsTestCase8() {

        fetchAttachmentsAssert(null,
                               null,
                               null,
                               true,
                               null);
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test Method to verify the functionality for fetching attachments of selected object
      *               with following scenario: Passed userFlag as true, offSetStr as '0' and
      *               other parameters with null values.
      * @Expected Result: Method should check jsonResult should return empty string.
      * @Date: 22/07/2016
      **/
    static testMethod void fetchAttachmentsTestCase9() {

       fetchAttachmentsAssert(null,
                              null,
                              null,
                              true,
                              '0');
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test Method to verify the functionality for fetching attachments of selected object
      *               with following scenario: Passed startDateStr with todays date and other parameters with null values.
      * @Expected Result: Method should check jsonResult should return empty string.
      * @Date: 22/07/2016
      **/
    static testMethod void fetchAttachmentsTestCase10() {

        fetchAttachmentsAssert(null,
                               null,
                               getStartAndEndDate(),
                               null,
                               null);
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test Method to verify the functionality for fetching attachments of selected object
      *               with following scenario: Passed endDateStr with todays date, offset value as '0' and 
      *               other parameters with null values.
      * @Expected Result: Method should check jsonResult should return empty string.
      * @Date: 22/07/2016
      **/
    static testMethod void fetchAttachmentsTestCase11() {

        fetchAttachmentsAssert(null,
                               null,
                               getStartAndEndDate(),
                               null,
                               '0');
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test Method to verify the functionality for fetching attachments of selected object
      *               with following scenario: Passed endDateStr with todays date, userFlag as true and
      *               other parameters with null values.
      * @Expected Result: Method should check jsonResult should return empty string.
      * @Date: 22/07/2016
      **/
    static testMethod void fetchAttachmentsTestCase12() {

        fetchAttachmentsAssert(null,
                               null,
                               getStartAndEndDate(),
                               true,
                               null);
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test Method to verify the functionality for fetching attachments of selected object
      *               with following scenario: Passed endDateStr with todays date, userFlag as true, offSetStr as '0'
      *               and other parameters with null values.
      * @Expected Result: Method should check jsonResult should return empty string.
      * @Date: 22/07/2016
      **/
    static testMethod void fetchAttachmentsTestCase13() {

        fetchAttachmentsAssert(null,
                               null,
                               getStartAndEndDate(),
                               true,
                               '0');
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test Method to verify the functionality for fetching attachments of selected object
      *               with following scenario: Passed startDateStr with todays date and other parameters with null values.
      * @Expected Result: Method should check jsonResult should return empty string.
      * @Date: 22/07/2016
      **/
    static testMethod void fetchAttachmentsTestCase14() {

        fetchAttachmentsAssert(null,
                               getStartAndEndDate(),
                               null,
                               null,
                               null);
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test Method to verify the functionality for fetching attachments of selected object
      *               with following scenario: Passed startDateStr with todays date, offSetStr as '0' and
      *               other parameters with null values.
      * @Expected Result: Method should check jsonResult should return empty string.
      * @Date: 22/07/2016
      **/
    static testMethod void fetchAttachmentsTestCase15() {

       fetchAttachmentsAssert(null,
                              getStartAndEndDate(),
                              null,
                              null,
                              '0');
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test Method to verify the functionality for fetching attachments of selected object
      *               with following scenario: Passed startDateStr with todays date, userFlag as true and
      *               other parameters with null values.
      * @Expected Result: Method should check jsonResult should return empty string.
      * @Date: 22/07/2016
      **/
    static testMethod void fetchAttachmentsTestCase16() {

       fetchAttachmentsAssert(null,
                              getStartAndEndDate(),
                              null,
                              true,
                              null);
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test Method to verify the functionality for fetching attachments of selected object
      *               with following scenario: Passed startDateStr with todays date, userFlag as true, offSetStr as '0'
      *               and other parameters with null values.
      * @Expected Result: Method should check jsonResult should return empty string.
      * @Date: 22/07/2016
      **/
    static testMethod void fetchAttachmentsTestCase17() {

       fetchAttachmentsAssert(null,
                              getStartAndEndDate(),
                              null,
                              true,
                              '0');
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test Method to verify the functionality for fetching attachments of selected object
      *               with following scenario: Passed startDateStr and endDateStr with todays date and
      *               other parameters with null values.
      * @Expected Result: Method should check jsonResult should return empty string.
      * @Date: 22/07/2016
      **/
    static testMethod void fetchAttachmentsTestCase18() {

        fetchAttachmentsAssert(null,
                               getStartAndEndDate(),
                               getStartAndEndDate(),
                               null,
                               null);
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test Method to verify the functionality for fetching attachments of selected object
      *               with following scenario: Passed startDateStr and endDateStr with todays date, offSetStr as '0'
      *               and other parameters with null values.
      * @Expected Result: Method should check jsonResult should return empty string.
      * @Date: 22/07/2016
      **/
    static testMethod void fetchAttachmentsTestCase19() {

        fetchAttachmentsAssert(null,
                               getStartAndEndDate(),
                               getStartAndEndDate(),
                               null,
                               '0');
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test Method to verify the functionality for fetching attachments of selected object
      *               with following scenario: Passed startDateStr and endDateStr with todays date, userFlag as true
      *               and other parameters with null values.
      * @Expected Result: Method should check jsonResult should return empty string.
      * @Date: 22/07/2016
      **/
    static testMethod void fetchAttachmentsTestCase20() {

        fetchAttachmentsAssert(null,
                               getStartAndEndDate(),
                               getStartAndEndDate(),
                               true,
                               null);
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test Method to verify the functionality for fetching attachments of selected object
      *               with following scenario: Passed selectedObjectId with object Id and other parameters with null values.
      * @Expected Result: Method should check jsonResult should return empty string.
      * @Date: 22/07/2016
      **/
    static testMethod void fetchAttachmentsTestCase21() {

        fetchAttachmentsAssert(getUltraTrackContainerId(),
                               null,
                               null,
                               null,
                               null);
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test Method to verify the functionality for fetching attachments of selected object
      *               with following scenario: Passed selectedObjectId with object Id, offSetStr as '0'
      *               and other parameters with null values.
      * @Expected Result: Method should check jsonResult should return json values as null.
      * @Date: 22/07/2016
      **/
    static testMethod void fetchAttachmentsTestCase22() {

        fetchAttachmentsAssert(getUltraTrackContainerId(),
                               null,
                               null,
                               null,
                               '0');
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test Method to verify the functionality for fetching attachments of selected object
      *               with following scenario: Passed selectedObjectId with object Id, userFlag as true
      *               and other parameters with null values.
      * @Expected Result: Method should check jsonResult should return empty string.
      * @Date: 22/07/2016
      **/
    static testMethod void fetchAttachmentsTestCase23() {

        fetchAttachmentsAssert(getUltraTrackContainerId(),
                               null,
                               null,
                               true,
                               null);
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test Method to verify the functionality for fetching attachments of selected object
      *               with following scenario: Passed selectedObjectId with object Id, userFlag as true, offSetStr as '0'
      *               and other parameters with null values.
      * @Expected Result: Method should check jsonResult should return valid json data of the selected object.
      * @Date: 22/07/2016
      **/
    static testMethod void fetchAttachmentsTestCase24() {

        fetchAttachmentsAssert(getUltraTrackContainerId(),
                               null,
                               null,
                               true,
                               '0');
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test Method to verify the functionality for fetching attachments of selected object
      *               with following scenario: Passed selectedObjectId with object Id, startDateStr with todays date
      *               and other parameters with null values.
      * @Expected Result: Method should check jsonResult should return empty string.
      * @Date: 22/07/2016
      **/
    static testMethod void fetchAttachmentsTestCase25() {

       fetchAttachmentsAssert(getUltraTrackContainerId(),
                              null,
                              getStartAndEndDate(),
                              null,
                              null);
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test Method to verify the functionality for fetching attachments of selected object
      *               with following scenario: Passed selectedObjectId with object Id, endDateStr with todays date,
      *               offSetStr as '0' and other parameters with null values.
      * @Expected Result: Method should check jsonResult should return json values as null.
      * @Date: 22/07/2016
      **/
    static testMethod void fetchAttachmentsTestCase26() {

        fetchAttachmentsAssert(getUltraTrackContainerId(),
                               null,
                               getStartAndEndDate(),
                               null,
                               '0');
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test Method to verify the functionality for fetching attachments of selected object
      *               with following scenario: Passed selectedObjectId with object Id, endDateStr with todays date,
      *               userFlag as as true and other parameters with null values.
      * @Expected Result: Method should check jsonResult should return empty string.
      * @Date: 22/07/2016
      **/
    static testMethod void fetchAttachmentsTestCase27() {

        fetchAttachmentsAssert(getUltraTrackContainerId(),
                               null,
                               getStartAndEndDate(),
                               true,
                               null);
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test Method to verify the functionality for fetching attachments of selected object
      *               with following scenario: Passed selectedObjectId with object Id, endDateStr with todays date,
      *               userFlag as as true, offSetStr as '0' and other parameters with null values.
      * @Expected Result: Method should check jsonResult should return valid json data of the selected object.
      * @Date: 22/07/2016
      **/
    static testMethod void fetchAttachmentsTestCase28() {

        fetchAttachmentsAssert(getUltraTrackContainerId(),
                               null,
                               getStartAndEndDate(),
                               true,
                               '0');
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test Method to verify the functionality for fetching attachments of selected object
      *               with following scenario: Passed selectedObjectId with object Id, startDateStr with todays date 
      *               and other parameters with null values.
      * @Expected Result: Method should check jsonResult should return empty string.
      * @Date: 22/07/2016
      **/
    static testMethod void fetchAttachmentsTestCase29() {

        fetchAttachmentsAssert(getUltraTrackContainerId(),
                               getStartAndEndDate(),
                               null,
                               null,
                               null);
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test Method to verify the functionality for fetching attachments of selected object
      *               with following scenario: Passed selectedObjectId with object Id, startDateStr with todays date,
      *               offSetStr as '0' and other parameters with null values.
      * @Expected Result: Method should check jsonResult should return json values as null.
      * @Date: 22/07/2016
      **/
    static testMethod void fetchAttachmentsTestCase30() {

        fetchAttachmentsAssert(getUltraTrackContainerId(),
                               getStartAndEndDate(),
                               null,
                               null,
                               '0');
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test Method to verify the functionality for fetching attachments of selected object
      *               with following scenario: Passed selectedObjectId with object Id, startDateStr with todays date,
      *               userFlag as true and other parameters with null values.
      * @Expected Result: Method should check jsonResult should return empty string.
      * @Date: 22/07/2016
      **/
    static testMethod void fetchAttachmentsTestCase31() {

        fetchAttachmentsAssert(getUltraTrackContainerId(),
                               getStartAndEndDate(),
                               null,
                               true,
                               null);
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test Method to verify the functionality for fetching attachments of selected object
      *               with following scenario: Passed selectedObjectId with object Id, startDateStr with todays date,
      *               userFlag as true,offSetStr as '0' and endDateStr as null.
      * @Expected Result: Method should check jsonResult should return valid json data of the selected object.
      * @Date: 22/07/2016
      **/
    static testMethod void fetchAttachmentsTestCase32() {

        fetchAttachmentsAssert(getUltraTrackContainerId(),
                               getStartAndEndDate(),
                               null,
                               true,
                               '0');
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test Method to verify the functionality for fetching attachments of selected object
      *               with following scenario: Passed selectedObjectId with object Id, startDateStr and endDateStr
      *               with todays date and other parameters with null values.
      * @Expected Result: Method should check jsonResult should return empty string.
      * @Date: 22/07/2016
      **/
    static testMethod void fetchAttachmentsTestCase33() {

        fetchAttachmentsAssert(getUltraTrackContainerId(),
                               getStartAndEndDate(),
                               getStartAndEndDate(),
                               null,
                               null);
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test Method to verify the functionality for fetching attachments of selected object
      *               with following scenario: Passed startDateStr and endDateStr invalid values and other parameters 
      *               with valid data.
      * @Expected Result: Method should check jsonResult should return valid json data of the selected object.
      * @Date: 22/07/2016
      **/
    static testMethod void fetchAttachmentsTestCase34() {

        fetchAttachmentsAssert(getUltraTrackContainerId(),
                               '1234',
                               '5678',
                               true,
                               '0');
    }
}