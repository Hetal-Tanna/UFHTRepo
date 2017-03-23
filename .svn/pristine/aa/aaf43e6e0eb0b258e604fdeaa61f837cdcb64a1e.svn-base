/*
 * Class Name: ViewDataControllerTest
 * @Description: Test class for ViewDataController class.
  ============================================================================================
        Version   | Date        | Author              | Comments
    ------------------------------------------------------------------------------------------
        1.0       | 29-2-2016    | Eternus Solution   | Test Cases for getObjects, getshowTrackHistory
                                                      | getRendered methods.
   ===========================================================================================
 */
@isTest
private class ViewDataControllerTest {
     /** 
     * @author Eternus Solution
     * @description: getObjects test case
     *               Two object having tracking enabled.
     * Expected Result: Method should return objects who has tracking enabled.
     * @date: 29-02-2016
     */ 
   static testMethod void getObjectsTestCase1() {
       list<Ultra_Track_Container__c> ultraTrackContainerList = new list<Ultra_Track_Container__c>();
        
       PageReference pageRef = Page.ViewData;
       Test.setCurrentPage(pageRef);
        
       ultraTrackContainerList.addAll(TestDataFactory.getUltraTrackContainerList(new list<string> {'Work__c','Opportunity'},
                                                                                  new list<string> {'Work','Opportunity'},
                                                                                  new list<boolean> {true, true},
                                                                                  new list<string> {'Email,Name', 'Name'}
                                                                                  )
                                      );
       if(!ultraTrackContainerList.isEmpty()) {
            insert ultraTrackContainerList;
       }
       ultraTrackContainerList.sort();
        
       UFHT__Configuration__c configObj = new UFHT__Configuration__c(Name = 'NumberOfColumsAndFields',
                                                                     UFHT__Number_Of_Columns__c = 4,
                                                                     UFHT__Number_Of_Fields_Per_Column__c = 15,
                                                                     UFHT__Number_Of_Records_Per_Page__c = 75,
                                                                     UFHT__SalesforceBaseURL__c = 'ap2.salesforce.com',
                                                                     UFHT__Sort_Fields_By__c = 'Ascending');
       insert configObj ;
       
       ViewDataController viewDataObj = new ViewDataController();
       viewDataObj.selectedObject = 'Account';
       test.startTest();
       viewDataObj.getObjects();
       test.StopTest();
       
       List<Ultra_Track_Container__c> lstTrackContainer = [SELECT Object_Label__c, 
                                                                 Tracked_Fields__c, 
                                                                 Object_Name__c
                                                         FROM Ultra_Track_Container__c 
                                                         WHERE Is_Tracking_Enabled__c =: true];
       System.assertEquals(viewDataObj.objectSelectedoptionsList.size(), lstTrackContainer .size()+1); 
    }
    
    /** 
     * @author Eternus Solution
     * @description: getDateFileters test case
     * Expected Result: Default value of filter should be set.
     * @date: 29-02-2016
     */
    static testMethod void getDateFiletersCase1() {
       list<Ultra_Track_Container__c> ultraTrackContainerList = new list<Ultra_Track_Container__c>();
       PageReference pageRef = Page.ViewData;
       Test.setCurrentPage(pageRef);
        
       ultraTrackContainerList.addAll(TestDataFactory.getUltraTrackContainerList(new list<string> {'Work__c','Opportunity'},
                                                                                  new list<string> {'Work','Opportunity'},
                                                                                  new list<boolean> {true, true},
                                                                                  new list<string> {'Email,Name', 'Name'}
                                                                                  )
                                      );
       if(!ultraTrackContainerList.isEmpty()) {
            insert ultraTrackContainerList;
       }
       ultraTrackContainerList.sort();
        
       UFHT__Configuration__c configObj = new UFHT__Configuration__c(Name = 'NumberOfColumsAndFields',
                                                                     UFHT__Number_Of_Columns__c = 4,
                                                                     UFHT__Number_Of_Fields_Per_Column__c = 15,
                                                                     UFHT__Number_Of_Records_Per_Page__c = 75,
                                                                     UFHT__SalesforceBaseURL__c = 'ap2.salesforce.com',
                                                                     UFHT__Sort_Fields_By__c = 'Ascending');
       insert configObj ;
       
       UFHT__View_Field_History_Date_Filters__c Obj = new UFHT__View_Field_History_Date_Filters__c(UFHT__Month_Week_Day_Filter_Category__c = 'Week',
                                                                                                   UFHT__Sr_No__c = 3,
                                                                                                   UFHT__Value__c = '0',
                                                                                                   Name = 'This Week');
        insert Obj;
       
       List<UFHT__View_Field_History_Date_Filters__c > lstCustom = [select Id, Name from UFHT__View_Field_History_Date_Filters__c 
                                                                    where Name = :'This Week'];
                                                                    
       ViewDataController viewDataObj = new ViewDataController();
       System.assertEquals(lstCustom[0].Name,viewDataObj.dateFilterSelectOptionsList[0].getValue());
    }
   
     /** 
     * @author Eternus Solution
     * @description: getDateFileters test case
     *               Set filter value to last N days.
     * Expected Result: value of Start date should be correct.
     * @date: 29-02-2016
     */
    static testMethod void dateFilterCase2() {
        list<Ultra_Track_Container__c> ultraTrackContainerList = new list<Ultra_Track_Container__c>();
        
       PageReference pageRef = Page.ViewData;
       Test.setCurrentPage(pageRef);
        
       ultraTrackContainerList.addAll(TestDataFactory.getUltraTrackContainerList(new list<string> {'Work__c','Opportunity'},
                                                                                  new list<string> {'Work','Opportunity'},
                                                                                  new list<boolean> {true, true},
                                                                                  new list<string> {'Email,Name', 'Name'}
                                                                                  )
                                      );
       if(!ultraTrackContainerList.isEmpty()) {
            insert ultraTrackContainerList;
       }
       ultraTrackContainerList.sort();
        
       UFHT__Configuration__c configObj = new UFHT__Configuration__c(Name = 'NumberOfColumsAndFields',
                                                                     UFHT__Number_Of_Columns__c = 4,
                                                                     UFHT__Number_Of_Fields_Per_Column__c = 15,
                                                                     UFHT__Number_Of_Records_Per_Page__c = 75,
                                                                     UFHT__SalesforceBaseURL__c = 'ap2.salesforce.com',
                                                                     UFHT__Sort_Fields_By__c = 'Ascending');
       insert configObj ;
       
       ViewDataController viewDataObj = new ViewDataController();
       viewDataObj.selectedDateFilter = 'Last N Days';
       viewDataObj.lastNumberOfDays = 0;
       
       test.startTest();
       viewDataObj.dateFilter();
       test.stopTest();
       
       system.assertEquals(viewDataObj.startDateObj.DateHolder__c, Date.Today().addDays(-viewDataObj.lastNumberOfDays));
    }
}