/**
 * @Class Name: ViewDataControllerTest
 * @Description: This class contains unit tests for ViewDataController.cls
 * =================================================================================================
 *       Version   | Date        | Author              | Comments
 * -------------------------------------------------------------------------------------------------
 *       1.0       | 04/07/2016  | Eternus Solutions   | 1.Created the Test Class for ViewDataController
 * =================================================================================================
 **/
@isTest
private class ViewDataControllerTest {

    /**
      * @Author: Eternus Solutions
      * @Description: Implemented methods to create test data for Ultra_Track_Container__c
      * @Return: NA.
      * @Date: 27/07/2016
      **/
    @testSetup
    static void setupTestData() {
        list<Ultra_Track_Container__c> ultraTrackContainerList = new list<Ultra_Track_Container__c>();

        ultraTrackContainerList.addAll( TestDataFactory.getUltraTrackContainerList(
            new list<string> {'UFHT__Sharing_Purpose__c', 'Account'},
            new list<string> {'Sharing_Purpose', 'Account'},
            new list<boolean> {true, true},
            new list<string> {'Email:0, Name:1', 'Name:1, AccountNumber:1, Owner:0'}
        ));

        if(!ultraTrackContainerList.isEmpty()) {
            insert ultraTrackContainerList;
            ultraTrackContainerList.sort();
        }
        TestUtil.checkAssertsForSetupData('Ultra_Track_Container__c', ultraTrackContainerList.size());
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Generic method to test constructor of class.
      * @Params: 1. configObjectName: Name to be given to Configuration__c record created.
      *          2. isFieldHistoryData: Boolean to decide if UFHT__View_Field_History_Date_Filters__c data exists.
      *          3. isTrackingDisabledRecord: Boolean to decide if Tracking disabled Ultra_Track_Container__c record exists.
      * @Date: 05/08/2016
      **/
    static void testConstructor(String configObjectName, Boolean isFieldHistoryData, Boolean isTrackingDisabledRecord) {

        list<UFHT__View_Field_History_Date_Filters__c> dateFilterList =
            new list<UFHT__View_Field_History_Date_Filters__c>();

        list<list<Object>> assertionValuesList = new list<list<Object>>();

        UFHT__Configuration__c configObj = TestDataFactory.getConfiguration(
            Url.getSalesforceBaseUrl().getHost());

        if(String.isNotBlank(configObjectName)) {
            configObj.Name = configObjectName;
        }

        insert configObj;

        if(isFieldHistoryData == true) {
            dateFilterList = TestDataFactory.getDateFilters(
                'Current Week',
                '0',
                'Week',
                3
            );
            dateFilterList.addAll(
                TestDataFactory.getDateFilters(
                    'Last N Days',
                    '30',
                    'Day',
                    2
            ));

            insert dateFilterList;
        }

        if(isTrackingDisabledRecord == true) {
            Ultra_Track_Container__c utcInstanceAccount = [SELECT Id
                                                             FROM Ultra_Track_Container__c
                                                            WHERE Is_Tracking_Enabled__c = true
                                                              AND Object_Name__c = 'Account'
                                                            LIMIT 1];

            utcInstanceAccount.Is_Tracking_Enabled__c = false;
            update utcInstanceAccount;
        }

        Ultra_Track_Container__c utcInstanceSharing = [SELECT Id
                                                         FROM Ultra_Track_Container__c
                                                        WHERE Is_Tracking_Enabled__c = true
                                                        LIMIT 1];

        System.Test.startTest();
        System.Test.setCurrentPage(Page.ViewData);
        
        ViewDataController controllerInstance = new ViewDataController();
        controllerInstance.selectedObject = controllerInstance.objectSelectedOptionsList[1].getValue();
        controllerInstance.dateFilter();
        System.Test.stopTest();

        assertionValuesList.add(new list<Object> {30, controllerInstance.lastNumberOfDays});
        assertionValuesList.add(new list<Object> {false, controllerInstance.isAllDataAccessible});
        assertionValuesList.add(new list<Object> {100, controllerInstance.pageSize});

        performAsserts(assertionValuesList);
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Generic method to test getDateFilters() method.
      * @Params: 1. srNoValues: values for Sr_No__c field on UFHT__View_Field_History_Date_Filters__c
      *          2. isNullValues: boolean to indicate if the Sr_No__c values are null
      * @Date: 05/08/2016
      **/
    static void testGetDateFilters(List<Integer> srNoValues, Boolean isNullValues) {

        Integer dateFilterListIndex = isNullValues == true ? 0 : 1;
        list<list<Object>> assertionValuesList = new list<list<Object>>();

        UFHT__Configuration__c configObj = TestDataFactory.getConfiguration(
            Url.getSalesforceBaseUrl().getHost());

        insert configObj;

        list<UFHT__View_Field_History_Date_Filters__c> dateFilterList = TestDataFactory.getDateFilters(
            'Current Week',
            '0',
            'Week',
            srNoValues[0]
        );
        dateFilterList.addAll(
            TestDataFactory.getDateFilters(
                'Last N Days',
                '30',
                'Day',
                srNoValues[1]
        ));

        insert dateFilterList;
        Account accObj = new Account(name = 'TestAccount');
        insert accObj;

        System.Test.startTest();
        System.Test.setCurrentPage(Page.ViewData);
        ApexPages.currentPage().getParameters().put('id', accObj.id);
        ViewDataController controllerInstance = new ViewDataController();
        controllerInstance.selectedObject = controllerInstance.objectSelectedOptionsList[1].getValue();
        controllerInstance.getDateFilters();
        System.Test.stopTest();
        
                Ultra_Track_Container__c utcInstance = [SELECT Id
                                                  FROM Ultra_Track_Container__c
                                                 WHERE Is_Tracking_Enabled__c = true
                                                   AND Object_Name__c = 'Account'
                                                 LIMIT 1];

        assertionValuesList.add(new list<Object> {30, controllerInstance.lastNumberOfDays});
        assertionValuesList.add(new list<Object> {false, controllerInstance.isAllDataAccessible});
        assertionValuesList.add(new list<Object> {100, controllerInstance.pageSize});
        assertionValuesList.add(new list<Object> {dateFilterList[dateFilterListIndex].Name, controllerInstance.dateFilterSelectOptionsList[dateFilterListIndex].getValue()});
        assertionValuesList.add(new list<Object> {utcInstance.Id, controllerInstance.selectedObject});

        performAsserts(assertionValuesList);
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Generic method to test dateFilter() method.
      * @Params: 1. selectedDateFilter: value for the selectedDateFilter property of the class.
      *          2. lastNumberOfDays: value for the lastNumberOfDays property of the class.
      * @Date: 05/08/2016
      **/
    static void testDateFilter(String selectedDateFilter, Integer lastNumberOfDays) {

        String assertStartDate = '';
        String assertEndDate = '';
        Integer lastNumberOfDaysExpected = 30;
        list<list<Object>> assertionValuesList = new list<list<Object>>();

        UFHT__Configuration__c configObj = TestDataFactory.getConfiguration(
                       Url.getSalesforceBaseUrl().getHost());

        insert configObj;

        list<UFHT__View_Field_History_Date_Filters__c> dateFilterList = TestDataFactory.getDateFilters(
            'Current Week',
            '0',
            'Week',
            3
        );
        dateFilterList.addAll(
            TestDataFactory.getDateFilters(
                'Last N Days',
                '30',
                'Day',
                2
        ));

        insert dateFilterList;

        System.Test.startTest();
        System.Test.setCurrentPage(Page.ViewData);
        ViewDataController controllerInstance = new ViewDataController();
        controllerInstance.selectedObject = controllerInstance.objectSelectedOptionsList[1].getValue();
        if(String.isNotBlank(selectedDateFilter)
        && lastNumberOfDays != null) {

            controllerInstance.selectedDateFilter = selectedDateFilter;

            if(selectedDateFilter.equalsIgnoreCase('Last N Days')) {
                assertStartDate = Date.today().addDays(-lastNumberOfDays).format();
                assertEndDate = Date.today().format();
            }

            else if(selectedDateFilter.equalsIgnoreCase('Current Week')) {
                assertStartDate = Date.today().toStartofWeek().format();
                assertEndDate = Date.today().toStartofWeek().addDays(6).format();
            }

            controllerInstance.lastNumberOfDays = lastNumberOfDays;
            lastNumberOfDaysExpected = lastNumberOfDays;
        }
        else if(selectedDateFilter == null || lastNumberOfDays == null) {
            assertStartDate = null;
            assertEndDate = null;
        }
        else {
            assertStartDate = Date.today().format();
            assertEndDate = Date.today().format();
        }
        controllerInstance.dateFilter();
        System.Test.stopTest();

        Ultra_Track_Container__c utcInstance = [SELECT Id
                                                  FROM Ultra_Track_Container__c
                                                 WHERE Is_Tracking_Enabled__c = true
                                                   AND Object_Name__c = 'Account'
                                                 LIMIT 1];

        assertionValuesList.add(new list<Object> {lastNumberOfDaysExpected, controllerInstance.lastNumberOfDays});
        assertionValuesList.add(new list<Object> {false, controllerInstance.isAllDataAccessible});
        assertionValuesList.add(new list<Object> {utcInstance.Id, controllerInstance.selectedObject});
        assertionValuesList.add(new list<Object> {assertStartDate, controllerInstance.startDate});
        assertionValuesList.add(new list<Object> {assertEndDate, controllerInstance.endDate});
                
        performAsserts(assertionValuesList);
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Generic method to check asserts for positive and negative scenario
      * @Params: List of list of Objects, in inner list: 1st item - Expected value, 2nd item - actual value
      * @Date: 05/08/2016
      **/
    static void performAsserts(list<list<Object>> assertionValuesList) {

        if(assertionValuesList == null) {
            return;
        }

        for(list<Object> assertionList : assertionValuesList) {

            if(assertionList == null || assertionList.size() < 2) {
                continue;
            }

            System.assertEquals(assertionList[0], assertionList[1]);
        }
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test method to verify constructor without View_Field_History_Date_Filters__c data.
      * @Expected Result: Method should set lastNumberOfDays and isAllDataAccessible values.
      * @Date: 27/07/2016
      **/
    static testMethod void constructorTestCase1() {

        testConstructor(null, false, false);
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test method to verify constructor with View_Field_History_Date_Filters__c data present
      *               and tracking enabled Ultra Track Container record.
      * @Expected Result: Method should set lastNumberOfDays and isAllDataAccessible values and
      *                   should populate dateFilterSelectOptionsList and selectedObject.
      * @Date: 27/07/2016
      **/
    static testMethod void constructorTestCase2() {

        testConstructor(null, true, false);
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test method to verify constructor with View_Field_History_Date_Filters__c data present
      *               and no tracking enabled Ultra Track Container record.
      * @Expected Result: Method should set lastNumberOfDays and isAllDataAccessible values and
      *                   should populate dateFilterSelectOptionsList and selectedObject should be blank.
      * @Date: 28/07/2016
      **/
    static testMethod void constructorTestCase3() {

        testConstructor(null, false, true);
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test method to verify constructor without View_Field_History_Date_Filters__c data and
      *               Configuration__c record with incorrect name.
      * @Expected Result: Method should set lastNumberOfDays and isAllDataAccessible values and pageSize = 25.
      * @Date: 01/08/2016
      **/
    static testMethod void constructorTestCase4() {

        testConstructor('Test Configuration', false, false);
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test method to verify getDateFilters with View_Field_History_Date_Filters__c data with valid Sr No values.
      * @Expected Result: Method should populate dateFilterSelectOptionsList.
      * @Date: 27/07/2016
      **/
    static testMethod void getDateFiltersTestCase1() {

        testGetDateFilters(new list<Integer> {3, 2}, false);
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test method to verify getDateFilters with View_Field_History_Date_Filters__c data having Sr No null.
      * @Expected Result: Method should populate dateFilterSelectOptionsList.
      * @Date: 29/07/2016
      **/
    static testMethod void getDateFiltersTestCase2() {

        testGetDateFilters(new list<Integer> {3, 2}, false);
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test method to verify getDateFormat using Bulgarian locale.
      * @Expected Result: Method should set lastNumberOfDays and isAllDataAccessible values and
      *                   should populate dateFilterSelectOptionsList, selectedObject
      *                   and dateFormat = 'DD.MM.YYYY' (Bulgarian Locale)
      * @Date: 27/07/2016
      **/
    static testMethod void getDateFormatTestCase1() {

        UFHT__Configuration__c configObj = TestDataFactory.getConfiguration(
            Url.getSalesforceBaseUrl().getHost());

        insert configObj;

        list<UFHT__View_Field_History_Date_Filters__c> dateFilterList = TestDataFactory.getDateFilters(
            'Current Week',
            '0',
            'Week',
            3
        );
        dateFilterList.addAll(
            TestDataFactory.getDateFilters(
                'Last N Days',
                '30',
                'Day',
                2
        ));

        insert dateFilterList;

        Profile standardProfile = [SELECT Id
                                     FROM Profile
                                    WHERE Name = 'Standard User'];

        System.runAs(TestDataFactory.getUserWithLocale('lastName', 'lName', 'test@user.name', 'bg_BG', standardProfile.Id)) {
            System.Test.startTest();
            System.Test.setCurrentPage(Page.ViewData);
            ViewDataController controllerInstance = new ViewDataController();
            controllerInstance.getDateFormat();
            System.Test.stopTest();

            // These asserts need to be inside runAs block as the controller instance is getting created
            // inside this block and won't be accessible outside this block.
            System.assertEquals(30, controllerInstance.lastNumberOfDays);
            System.assertEquals(100, controllerInstance.pageSize);
            System.assertEquals(false, controllerInstance.isAllDataAccessible);
            System.assertEquals('DD.MM.YYYY', controllerInstance.dateFormat);
        }
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test method to verify date filter with no values assigned for start date and end date.
      * @Expected Result: Start date and end date are set to today.
      * @Date: 28/07/2016
      **/
    static testMethod void dateFilterTestCase1() {

        testDateFilter(null, null);
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test method to verify date filter for this week.
      * @Expected Result: Start date and end date are set for this week.
      * @Date: 28/07/2016
      **/
    static testMethod void dateFilterTestCase2() {

        testDateFilter('Current Week', 0);
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Test method to verify date filter for last n days.
      * @Expected Result: Start date is set to n days before today and end date is set to today.
      * @Date: 28/07/2016
      **/
    static testMethod void dateFilterTestCase3() {

        testDateFilter('Last N Days', 8);
    }
    
    /**
      * @Author: Eternus Solutions
      * @Description: Created test method to get notification for a user about suspension of package
      * @Param: NA
      * @Return: NA
      * @Date: 01/02/2017
      **/
    static testMethod void getNotificationMethodCase1() {
        
        UFHT__Feature_Installation_Master__c installDetails = new UFHT__Feature_Installation_Master__c();
        
        installDetails.Name = 'FEATURE_FHT';
        installDetails.Is_Active__c = false;
        installDetails.License_Days_Remaining__c = -1;
        
        insert installDetails;
        Test.startTest();
        ViewDataController controllerObj = new ViewDataController();
        system.assertEquals(LMSConstants.MSG_PACKAGE_SUSPENDED, controllerObj.licenseMessages); 
        Test.stopTest();
    }
    
    /**
      * @Author: Eternus Solutions
      * @Description: Created test method to get notification for a user with expired version of app
      * @Param: NA
      * @Return: NA
      * @Date: 01/02/2017
      **/
    static testMethod void getNotificationMethodCase2() {
        
        UFHT__Feature_Installation_Master__c installDetails = new UFHT__Feature_Installation_Master__c();
        
        installDetails.Name = 'FEATURE_FHT';
        installDetails.Is_Active__c = false;
        installDetails.License_Days_Remaining__c = 0;
        
        insert installDetails;
        Test.startTest();
        ViewDataController controllerObj = new ViewDataController();
        system.assertEquals(LMSConstants.MSG_PACKAGE_EXPIRED, controllerObj.licenseMessages);
        Test.stopTest();
    }
    
    /**
      * @Author: Eternus Solutions
      * @Description: Created test method to get notification for a user for renewal of license for UFHT app
      * @Param: NA
      * @Return: NA
      * @Date: 01/02/2017
      **/
    static testMethod void getNotificationMethodCase3() {
        
        UFHT__Feature_Installation_Master__c installDetails = new UFHT__Feature_Installation_Master__c();
        
        installDetails.Name = 'FEATURE_FHT';
        installDetails.Is_Active__c = false;
        installDetails.License_Days_Remaining__c = 12;
        
        insert installDetails;
        Test.startTest();
        ViewDataController controllerObj = new ViewDataController();
        system.assertEquals('Your subscription for Ultra FieldHistory Tracker is about to expire in <b>12 day(s)</b>. Please contact <a href="mailto:sales@eternussolutions.com?cc=appsupport@eternussolutions.com">sales@eternussolutions.com</a> for license renewal (<a href="javascript:void(0)" onClick="return renewalLicense();" >Purchase Now</a>)', controllerObj.licenseMessages);
        Test.stopTest();      
    }
    
    /**
      * @Author: Eternus Solutions
      * @Description: Created test method to get notification for a user with invalid license of the app
      * @Param: NA
      * @Return: NA
      * @Date: 01/02/2017
      **/
    static testMethod void getNotificationMethodCase4() {
        
        UFHT__Feature_Installation_Master__c installDetails = new UFHT__Feature_Installation_Master__c();
        
        installDetails.Name = 'FEATURE_FHT';
        installDetails.Is_Active__c = false;
        installDetails.License_Days_Remaining__c = 20;
        
        insert installDetails;
        Test.startTest();
        ViewDataController controllerObj = new ViewDataController();
        system.assertEquals(LMSConstants.MSG_INVALID_LICENSE_NOTIFICATION , controllerObj.licenseMessages);
        Test.stopTest();      
    }
    
    /**
      * @Author: Eternus Solutions
      * @Description: Created test method to get notification for a user with valid license of the app
      * @Param: NA
      * @Return: NA
      * @Date: 01/02/2017
      **/
    static testMethod void getNotificationMethodCase5() {
        
        UFHT__Feature_Installation_Master__c installDetails = new UFHT__Feature_Installation_Master__c();
        
        installDetails.Name = 'FEATURE_FHT';
        installDetails.Is_Active__c = true;
        installDetails.License_Days_Remaining__c = 20;
        
        insert installDetails;
        Test.startTest();
        ViewDataController controllerObj = new ViewDataController();
        system.assertEquals(null, controllerObj.licenseMessages);
        Test.stopTest();      
    }
    
    /**
      * @Author: Eternus Solutions
      * @Description: Created test method to test check the renewal license
      * @Param: NA
      * @Return: NA
      * @Date: 01/02/2017
      **/
    static testMethod void renewalLicenseCheckMethod() {
        ViewDataController controllerObj = new ViewDataController();
        
        Test.startTest();
        controllerObj.renewalLicenseCheck();
        system.assertEquals(LMSConstants.MSG_INVALID_LICENSE_NOTIFICATION ,controllerObj.licenseMessages);
        Test.stopTest();      
    }
}