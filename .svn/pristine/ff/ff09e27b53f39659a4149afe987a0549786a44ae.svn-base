/**
 * Class Name: ViewDataController1 
 * @Description: This is the main controller for ViewData1 page.
 *               It sets the filter options in the top section of the page.
 *==================================================================================================
 *       Version   | Date        | Author             | Comments
 *--------------------------------------------------------------------------------------------------
 *       1.0       | 04-07-2016  | Eternus Solution   | 1.Created the class for above functionality.
 *===================================================================================================
 **/

public class ViewDataController {

    // Holds the Ultra Track Container Id for the selected object.
    public string selectedObject {get;set;}
    // Instance for keeping track of start date selected in filters.
    public Ultra_Track_Container__c startDateObj {get;set;} 
    // Instance for keeping track of end date selected in filters.
    public Ultra_Track_Container__c endDateObj {get;set;} 
    // Holds a list of objects for which field history tracking is set up.
    public list<SelectOption> objectSelectedoptionsList {get;set;}
    // Holds a list of options for the date filter
    public list<SelectOption> dateFilterSelectOptionsList {get;set;}
    // Boolean to check if it is necessary to show the User filter list.
    public boolean viewUserFilterList {get;set;}
    // Holds the type of the filter selected for date.
    public string selectedDateFilter {get;set;}
    // Integer varible to hold number fields to display on single page.
    public integer lastNumberOfDays {get; set;}
    // Holds the number of records to display on the page.
    public Integer pageSize { get; set; }
    // Holds the base URL for current salesforce instance (necessary for callouts)
    public string salesforceBaseUrl {get;set;}
    // Holds the start date selected by user on the page.
    public string startDate {get;set;}
    // Holds the end date selected by user on the page.
    public string endDate {get;set;}
    
    public string sessionId { get {
        return UserInfo.getSessionId();
    } set; }
    

    // Added constant strings to avoid hardcoding.
    private final static String DATE_FILTER_CUSTOM = 'Custom';
    private final static String PROTOCOL = 'https://';
    private final static String COLUMN_FIELD_NUMBER = 'NumberOfColumsAndFields';
    private final static String WHITE_SPACE = '  ';
    private final static String NONE_OPTION_LABEL = '----NONE----';
    private final static String EMPTY_STRING = '';
    private final static String DATE_FILTER_LAST_N_DAYS = 'Last N Days';

    public ViewDataController() {
        
        dateFilterSelectOptionsList = new list<SelectOption>();
       
        startDateObj = new Ultra_Track_Container__c();
        endDateObj = new Ultra_Track_Container__c();
        
        viewUserFilterList = false;
        selectedDateFilter = DATE_FILTER_CUSTOM;
        startDateObj.DateHolder__c = Date.Today();
        endDateObj.DateHolder__c = Date.Today();
        salesforceBaseUrl = PROTOCOL + Configuration__c.getAll().get(COLUMN_FIELD_NUMBER).SalesforceBaseURL__c;
        View_Field_History_Sharing_Setting__c viewDataSharingObj = View_Field_History_Sharing_Setting__c.getInstance(UserInfo.getProfileId());
        if(viewDataSharingObj != null && viewDataSharingObj.View_All_Data__c) {
            viewUserFilterList = true;
        }
        map<String,Configuration__c> mapConfig = Configuration__c.getAll();
       
        if(mapConfig.containsKey(system.Label.ConfigureColsAndFieldsCustomSettingRecordName)){
              Configuration__c objCofig = mapConfig.get(system.Label.ConfigureColsAndFieldsCustomSettingRecordName);
              pageSize = Integer.valueOf(objCofig.Number_Of_Records_Per_Page__c);
        }
        else{
              pageSize = 5;
        }
        startDate = startDateObj.DateHolder__c.format();
        endDate = endDateObj.DateHolder__c.format();
        getObjects();
        getDateFilters();
    } 
     /**
      * @Author: Eternus Solutions
      * @description : Method to get objects for which history traking is enabled.
      * @Param :
      * @Return : list of selectOption.
      * @Date:15/11/2015
      **/
    public void getObjects() {
        
        objectSelectedoptionsList = new list<SelectOption>();
        
        objectSelectedoptionsList.add(new SelectOption(WHITE_SPACE,
                                                      NONE_OPTION_LABEL
                                     )); 
        
        for(Ultra_Track_Container__c trackContainerObj : [SELECT Object_Label__c, 
                                                                 Tracked_Fields__c, 
                                                                 Object_Name__c
                                                         FROM Ultra_Track_Container__c 
                                                         WHERE Is_Tracking_Enabled__c =: true
                                                         order by Object_Label__c]) {
                                    
            objectSelectedoptionsList.add(new SelectOption(trackContainerObj.Id,
                                                           trackContainerObj.Object_Label__c
                                         ));
        }
        objectSelectedoptionsList.sort();
        if(String.isBlank(selectedObject)) {
            if(!objectSelectedoptionsList.isEmpty() && objectSelectedoptionsList.size() > 1) {
                 if(objectSelectedoptionsList[1] != null){
                  selectedObject = objectSelectedoptionsList[1].getValue();
                 }
            }
            else {
                selectedObject = WHITE_SPACE;
            }
        }
    }  
    /**
      * @Author: Eternus Solutions
      * @description :  Method to get dateFilters from custom setting.
      * @Param :
      * @Return : list of selectOption.
      * @Date:15/11/2015
      **/
    public void getDateFilters() {
        
        list<DateFilterWrapper> dateFilterWrapperList = new list<DateFilterWrapper>();
        for(View_Field_History_Date_Filters__c obj : View_Field_History_Date_Filters__c.getAll().values()) {
            dateFilterWrapperList.add(new DateFilterWrapper(integer.valueOf(obj.Sr_No__c), obj.name));
        }
        dateFilterWrapperList.sort();
        for(DateFilterWrapper dateFilter : dateFilterWrapperList) {
            
            dateFilterSelectOptionsList.add(new SelectOption(dateFilter.name,
                                                             dateFilter.name
                                           ));
        }
    }
    
    /**
      * @Author: Eternus Solutions
      * @description : DateFilterWrapper class to dateFilter records.
      * @Param :  
      * @Return :  
      * @Date:15/11/2015
      **/ 
    public class DateFilterWrapper implements comparable {
        
        public integer srNo {get;set;}
        public string name {get;set;}
        
        public DateFilterWrapper(integer srNo, string name) {
            this.srNo = srNo;
            this.name = name;
        } 
        
        public Integer compareTo(Object ObjToCompare) {
            Integer returnValue = 0;
            if(ObjToCompare != Null){
                DateFilterWrapper that = (DateFilterWrapper)ObjToCompare;  
                returnValue = (this.srNo < that.srNo) ? -1 : 1;
            }
            else{
                returnValue = -1;
            }
            return returnValue;
        }
            
    }
    
    /**
      * @Author: Eternus Solutions
      * @description : 1.Method to get start and end date for selected dateFilter.
      * @Param :  
      * @Return :  
      * @Date:15/11/2015
      **/ 
    public void dateFilter() {
        list<Ultra_Track_Container__c> startEndDateList = new list<Ultra_Track_Container__c>();
        if(selectedDateFilter != DATE_FILTER_CUSTOM && selectedDateFilter != DATE_FILTER_LAST_N_DAYS) {
             startEndDateList = UltraTrackUtilityClass.getStartAndEndDateForFilter(selectedDateFilter);
             startDateObj.DateHolder__c = startEndDateList[0].DateHolder__c;
             endDateObj.DateHolder__c = startEndDateList[1].DateHolder__c;
        }
        if(selectedDateFilter == DATE_FILTER_LAST_N_DAYS){
             lastNumberOfDays = (lastNumberOfDays == 0)? 30: lastNumberOfDays;
             startDateObj.DateHolder__c = Date.Today().addDays(-lastNumberOfDays);
             endDateObj.DateHolder__c = Date.Today();
        }
        if(startDateObj.DateHolder__c != null)
            startDate = startDateObj.DateHolder__c.format();
        else
            startDate = null;
        if(endDateObj.DateHolder__c != null)
            endDate = endDateObj.DateHolder__c.format();
        else
            endDate = null;
    }
}