/**
 * Class Name: ViewDataController
 * @Description: Class to display historical data for all object records.   
  ========================================================================================================================
        Version   | Date        | Author             | Comments
    -------------------------------------------------------------------------------------------------------------------------
        1.0       | 22-02-2016  | Eternus Solution   | 1. Created getObjects, getshowTrackHistoryData, getRendered  
                                                     |    redirectToUser, checkStartEndDateRange methods.
   ========================================================================================================================
 */
public without sharing class ViewDataControllerClone {
    
    public string selectedObject {get;set;}
    public list<DisplayHistoryWrapper> displayHistoryWrapperList {get;set;}
    public map<Id, String> IdVsAccountNameMap {get;set;}
    public Ultra_Track_Container__c startDateObj {get;set;}
    public Ultra_Track_Container__c endDateObj {get;set;} 
    public UltraTrackUtilityClass objUtility {get;set;}
    public list<SelectOption> objectSelectedoptionsList {get;set;}
    public list<SelectOption> userSelectOptionList {get;set;}
    public list<SelectOption> dateFilterSelectOptionsList {get;set;}
    public boolean viewUserFilterList {get;set;}
    public string selectedUser {get;set;}
    public string selectedDateFilter {get;set;}
     //int varible to hold number fields to display on single page.
    public Integer pageSize { get; set; }
    
    public Integer pageNumber { get; set; }
    //int variable to hold total number of fields for sObject
    public Integer totalSize ;
    //int variable for holding page size for pagination
    public Integer counter = 0;
    //int variable to show total number of records
    public Integer totalNumberOfRecords{get;set;}
    public integer showMoreData {get;set;}
    public integer offsetSize ;

    map<string,Ultra_Track_Container__c> ultraTrackContainerMap = new map<string,Ultra_Track_Container__c>();
    public String strDateTime{get;set;}
    transient list<DisplayHistoryWrapper> displayAllHistoryWrapperList ;
    public list<DisplayHistoryWrapper> filterHistoryWrapperList {get;set;}
    //list to export
    //public Transient list<DisplayHistoryWrapper> displayAllHistoryWrapperToExportList {get;set;}
    @TestVisible Date startDate;
    @TestVisible Date endDate;
  
    public ViewDataControllerClone() {
        objUtility = new UltraTrackUtilityClass();
        IdVsAccountNameMap = new map<Id, String>();
       
        displayAllHistoryWrapperList = new list<DisplayHistoryWrapper>();
        userSelectOptionList = new list<SelectOption>();
        dateFilterSelectOptionsList = new list<SelectOption>();
        startDateObj = new Ultra_Track_Container__c();
        endDateObj = new Ultra_Track_Container__c();
        filterHistoryWrapperList = new list<DisplayHistoryWrapper>();
        viewUserFilterList = false;
        selectedDateFilter = 'Custom';
        startDateObj.DateHolder__c = Date.Today();
        endDateObj.DateHolder__c = Date.Today();
        View_Field_History_Sharing_Setting__c viewDataSharingObj = View_Field_History_Sharing_Setting__c.getInstance(UserInfo.getProfileId());
        if(viewDataSharingObj != null && viewDataSharingObj.View_All_Data__c) {
            viewUserFilterList = true;
            getUsers();
        }
        getObjects();
        getDateFileters();
        getRecord();
    } 
    /**
        * @Author: Eternus Solutions
        * @description : Method to get users.
        * @Param :
        * @Return : list of selectOption.
        * @Date:15/11/2015
    */
    public void getUsers() {
        
        userSelectOptionList.add(new SelectOption('',
                                                  'All User'
                                 ));                 
        for(User userObj : [select Id, Name, Profile.UserLicense.Name
                           from User
                           where Profile.UserLicense.Name = 'Salesforce']) {
                            
           userSelectOptionList.add(new SelectOption(userObj.Id,
                                                     userObj.Name
                                   ));                      
        }
    }
     /**
        * @Author: Eternus Solutions
        * @description : Method to get objects for which history traking is enabled.
        * @Param :
        * @Return : list of selectOption.
        * @Date:15/11/2015
    */
    public void getObjects() {
        
        objectSelectedoptionsList = new list<SelectOption>();
        
        objectSelectedoptionsList.add(new SelectOption('  ',
                                                      '----NONE----'
                                     )); 
        
        for(Ultra_Track_Container__c trackContainerObj : [SELECT Object_Label__c, 
                                                                 Tracked_Fields__c, 
                                                                 Object_Name__c
                                                         FROM Ultra_Track_Container__c 
                                                         WHERE Is_Tracking_Enabled__c =: true]) {
                                    
            ultraTrackContainerMap.put(trackContainerObj.Object_Name__c,trackContainerObj);
            objectSelectedoptionsList.add(new SelectOption(trackContainerObj.Object_Name__c,
                                                           trackContainerObj.Object_Label__c
                                         ));
        }
        objectSelectedoptionsList.sort();
        if(selectedObject == '' || selectedObject == null) {
            if(!objectSelectedoptionsList.isEmpty() && objectSelectedoptionsList.size() > 1) {
                 if(objectSelectedoptionsList[1] != null){
                  selectedObject = objectSelectedoptionsList[1].getValue();
                 }
            }
            else {
                selectedObject = '  ';
            }
        }
    }  
    /**
        * @Author: Eternus Solutions
        * @description :  Method to get dateFilters from custom setting.
        * @Param :
        * @Return : list of selectOption.
        * @Date:15/11/2015
    */
    public void getDateFileters() {
        
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
        * @description :  Method to get historical data for perticular object.
        * @Param :
        * @Return : PageReference object..
        * @Date:15/11/2015
    */
    public PageReference getshowTrackHistoryData() {
        list<string> selectedFieldsForTrackingField = new list<string>(); 
        map<ID,list<FieldNameAndWrapper>> recordIdVsAllUltraTrackWrapperMap = new map<ID,list<FieldNameAndWrapper>>();
        displayAllHistoryWrapperList = new list<DisplayHistoryWrapper>();
        filterHistoryWrapperList = new list<DisplayHistoryWrapper>();
        set<Id> recordIdSet = new set<Id>();
        IdVsAccountNameMap = new map<Id, String>();
        map<Id, Id> IdVsOwnerIdMap = new map<Id, Id>();
        map<string,List<HistoryWrapper>> ultraTrackWrapperMap = new map<string,List<HistoryWrapper>>();
        list<Attachment> jsonAttachmentForObjectList = new list<Attachment>();
        map<Id, set<string>> recordIdVsFieldNameMap = new map<Id, set<string>>();
        map<String,String> mapFieldsAndLabels = new map<String,String> ();
        map <Id, set<Id>> recordIdVsUserOrGroupIdSetMap = new map <Id, set<Id>>(); 
        map<Id, Set<Id>> userIdVsAllManagerIdMap = new map<Id, Set<Id>>();
        map <Id, User> userIdVsUserMap = new map <Id, User>();
        new UltraTrackUtilityClass();
        totalSize = 0;
        pageNumber = 0;
        DateTime newDateTime;
        Date modifiedDate;
        getObjects();
       
        userIdVsUserMap.putAll(UltraTrackUtilityClass.userIdVsUserMap);
        
        map<String,Configuration__c> mapConfig = Configuration__c.getAll();
       
        if(mapConfig.containsKey(system.Label.ConfigureColsAndFieldsCustomSettingRecordName)){
              Configuration__c objCofig = mapConfig.get(system.Label.ConfigureColsAndFieldsCustomSettingRecordName);
              pageSize = Integer.valueOf(objCofig.Number_Of_Records_Per_Page__c);
        }
        else{
              pageSize = 5;
        }
        
        if(string.isNotBlank(selectedObject) && ultraTrackContainerMap.containsKey(selectedObject)) {
            mapFieldsAndLabels = objUtility.getFieldNamesAndLabels(selectedObject);
            
            jsonAttachmentForObjectList = [SELECT body, LastModifiedDate  
                                           FROM Attachment
                                           WHERE parentID =: ultraTrackContainerMap.get(selectedObject).ID 
                                           AND Name like :system.Label.AttachmentFileName+'%' 
                                           AND (LastModifiedDate >= :datetime.newInstance(startDate, Time.newInstance(0,0,0,0))
			                               AND LastModifiedDate <= :datetime.newInstance(endDate, Time.newInstance(23,59,59,59)))
			                               order by LastModifiedDate Desc
			                               limit 1
			                               offset :offsetSize];
            if(jsonAttachmentForObjectList.size() > 0 ) {
                ultraTrackWrapperMap = new map<string,List<HistoryWrapper>>();
                   
                ultraTrackWrapperMap =(map<string,List<HistoryWrapper>>)System.JSON.deserialize(
                                                                        jsonAttachmentForObjectList[0].body.toString(), 
                                                                        map<string,List<HistoryWrapper>>.class);
                system.debug('DDDDDD'+ultraTrackWrapperMap);
            }
            if(ultraTrackContainerMap.containsKey(selectedObject) && 
               string.isNotBlank(ultraTrackContainerMap.get(selectedObject).Tracked_Fields__c)) {
                Ultra_Track_Container__c fhtDataHolderObj = ultraTrackContainerMap.get(selectedObject);
                if(fhtDataHolderObj.Tracked_Fields__c.contains(',')) {
                    
                    selectedFieldsForTrackingField = fhtDataHolderObj.Tracked_Fields__c.split(',');
                }
               else {
                   selectedFieldsForTrackingField.add(fhtDataHolderObj.Tracked_Fields__c);
               }
            }
            
           if(!selectedFieldsForTrackingField.isEmpty()){
               for(string fieldName : selectedFieldsForTrackingField){
                   if(ultraTrackWrapperMap.containsKey(fieldName)) {
                         list<HistoryWrapper> historyWrapperList = ultraTrackWrapperMap.get(fieldName);
                         string fieldLabel = mapFieldsAndLabels.get(fieldName);
                         historyWrapperList.sort();
                         for(HistoryWrapper objWrapper : historyWrapperList){
                            newDateTime = getDateTimeForUserTimeZone(objWrapper.ModifiedDateTime);
                            if(newDateTime.format().contains(','))  {
                                modifiedDate = date.parse(newDateTime.format().split(',')[0]);
                            }
                            else {
                                 modifiedDate = date.parse(newDateTime.format().split(' ')[0]);
                            }
                             if(recordIdVsAllUltraTrackWrapperMap.containsKey(objWrapper.parentId)) {
                                if(startDate != null || endDate != null) {
                                    if(checkStartEndDateRange(modifiedDate)) {
                                        recordIdVsAllUltraTrackWrapperMap.get(objWrapper.parentId).add(new FieldNameAndWrapper(fieldLabel, objWrapper));
                                    }
                                }
                                else {
                                    recordIdVsAllUltraTrackWrapperMap.get(objWrapper.parentId).add(new FieldNameAndWrapper(fieldLabel, objWrapper));
                                }
                             }
                             else{
                                if(startDate != null || endDate != null) {
                                    if(checkStartEndDateRange(modifiedDate)) {
                                        recordIdVsAllUltraTrackWrapperMap.put(objWrapper.parentId,
                                                                   new list<FieldNameAndWrapper>{new FieldNameAndWrapper(fieldLabel, objWrapper)});
                                    }
                                }
                                else {
                                    recordIdVsAllUltraTrackWrapperMap.put(objWrapper.parentId,
                                                                new list<FieldNameAndWrapper>{new FieldNameAndWrapper(fieldLabel, objWrapper)});
                                }
                                 
                             }
                             
                             //-------------------------------
                         }
                    }
               }
           }
           if(!recordIdVsAllUltraTrackWrapperMap.isEmpty()) {
               
               string query;
               set<Id> sObjectIdSet = recordIdVsAllUltraTrackWrapperMap.keySet();
               list<sObject> sObjectList = new list<sObject>();
               
               string fieldName = UltraTrackUtilityClass.getNameUniqueField(selectedObject);
               
               query = 'SELECT Id, LastModifiedById, '+fieldName;
               query += ' FROM '+ selectedObject;
               query += ' WHERE Id IN: sObjectIdSet';
               query += ' ORDER by '+fieldName ;
               sObjectList = Database.query(query);
               
               
               if(!sObjectList.isEmpty()) {
                    for(sObject Objct : sObjectList) {
                        IdVsAccountNameMap.put((Id)Objct.get('Id'), (string)Objct.get(fieldName));
                        IdVsOwnerIdMap.put((Id)Objct.get('Id'), (Id)Objct.get('LastModifiedById'));
                    }
               }
               
               for(Id recordId : recordIdVsAllUltraTrackWrapperMap.keySet()) {
                    for(FieldNameAndWrapper fieldAndHistoryObj : recordIdVsAllUltraTrackWrapperMap.get(recordId)) {
                        newDateTime = getDateTimeForUserTimeZone(fieldAndHistoryObj.historyWrapperObj.ModifiedDateTime);
                        if(selectedUser != null) {
                            if(selectedUser == fieldAndHistoryObj.historyWrapperObj.ModifiedById) {
                                displayAllHistoryWrapperList.add(new DisplayHistoryWrapper(fieldAndHistoryObj.historyWrapperObj.parentId, 
                                                                                           fieldAndHistoryObj.historyWrapperObj, 
                                                                                           newDateTime.format(), 
                                                                                           userIdVsUserMap.get(fieldAndHistoryObj.historyWrapperObj.ModifiedById).Name,
                                                                                           fieldAndHistoryObj.fieldName));
                            }
                        }
                        else if(selectedUser == null) {
                            displayAllHistoryWrapperList.add(new DisplayHistoryWrapper(fieldAndHistoryObj.historyWrapperObj.parentId, 
                                                                                       fieldAndHistoryObj.historyWrapperObj, 
                                                                                       newDateTime.format(), 
                                                                                       userIdVsUserMap.get(fieldAndHistoryObj.historyWrapperObj.ModifiedById).Name,
                                                                                       fieldAndHistoryObj.fieldName));
                        }
                    }
               }
               totalSize = displayAllHistoryWrapperList.size();
            }
        }
        
        totalNumberOfRecords = displayAllHistoryWrapperList.size();

        if(string.isNotBlank(selectedObject)) {
            if(viewUserFilterList) {
               
                filterHistoryWrapperList.addAll(displayAllHistoryWrapperList);
            }
            else {
                    new UltraTrackUtilityClass();
                    string objectOwd, objectAccess;
                    objectOwd = '';
                    map<boolean, list<string>> owdMap = UltraTrackUtilityClass.getOwdForAnObject(selectedObject);
                    if(owdMap.containsKey(true)) {
                        recordIdVsUserOrGroupIdSetMap = UltraTrackUtilityClass.getSharing(owdMap.get(true), IdVsAccountNameMap.keySet());
                        if(owdMap.get(true)[2] == 'false') {
                            if(Standard_Objects__c.getValues(selectedObject) != null) {
                                string organiztionFieldName = Standard_Objects__c.getValues(selectedObject).Organization_Field_Name__c;
                                string query;
                                query = 'select Id, ';
                                if(selectedObject.contains('Contact')) {
                                    query += 'DefaultAccountAccess, '+organiztionFieldName + ' from Organization';
                                }
                                else 
                                    query += organiztionFieldName +' from Organization';
                                sobject organizationObj = database.query(query);
                                objectAccess = (string)organizationObj.get(organiztionFieldName);
                                 system.debug('objectAccess++'+objectAccess);
                                if(objectAccess.contains('ControlledByParent')) {
                                    objectOwd = (string)organizationObj.get('DefaultAccountAccess');
                                    if(objectOwd.contains('Edit'))
                                       objectOwd = 'Edit';
                                    else if(objectOwd.contains('None'))
                                       objectOwd = 'Private';
                                    else
                                       objectOwd = 'Read';
                                }
                                else if(objectAccess.contains('Edit') || objectAccess.contains('All')) {
                                    objectOwd = 'Edit';
                                }
                                else if(objectAccess.contains('None')) {
                                    objectOwd = 'Private';
                                }
                                else 
                                    objectOwd = 'Read';
                            }
                        }
                        if(owdMap.get(true)[2] == 'true' || (objectOwd.contains('Private') && UltraTrackUtilityClass.objMap.get(selectedObject).getDescribe().isAccessible())) {
                            set<Id> ownerIdSet = new set<Id> (IdVsOwnerIdMap.values());
                            userIdVsAllManagerIdMap = UltraTrackUtilityClass.getAllManagerForUser(ownerIdSet);
                            if(!userIdVsAllManagerIdMap.isEmpty()) {
                                for(Id recordId : IdVsOwnerIdMap.keySet()) {
                                    if(recordIdVsUserOrGroupIdSetMap.containsKey(recordId)) {
                                        recordIdVsUserOrGroupIdSetMap.get(recordId).addAll(userIdVsAllManagerIdMap.get(IdVsOwnerIdMap.get(recordId)));
                                    }
                                    else {
                                        recordIdVsUserOrGroupIdSetMap.put(recordId, userIdVsAllManagerIdMap.get(IdVsOwnerIdMap.get(recordId)));
                                    }
                                }
                            }
                            for(DisplayHistoryWrapper obj : displayAllHistoryWrapperList) {
                                if(UserInfo.getUserId() == IdVsOwnerIdMap.get(obj.parentId)) {
                                    filterHistoryWrapperList.add(obj);
                                }
                                else if(recordIdVsUserOrGroupIdSetMap.get(obj.parentId) != null &&
                                        recordIdVsUserOrGroupIdSetMap.get(obj.parentId).contains(UserInfo.getUserId())) {
                                    filterHistoryWrapperList.add(obj); 
                                }
                            }
                            
                        }
                    }
                    if((owdMap.containsKey(false) && owdMap.get(false)[0] == 'true' ) || 
                       ((objectOwd.contains('Edit') ||  objectOwd.contains('Read')) &&
                        UltraTrackUtilityClass.objMap.get(selectedObject).getDescribe().isAccessible())) {
                            for (DisplayHistoryWrapper obj : displayAllHistoryWrapperList) {
                                filterHistoryWrapperList.add(obj);
                            }
                    }
                    totalSize = totalNumberOfRecords = filterHistoryWrapperList.size();
                }        
           }
        system.debug('Heap Size in Main method='+Limits.getHeapSize());
        system.debug('Heap Size in Main method='+Limits.getLimitHeapSize());
       return null;
    }
    
    /**
        * @Author: Eternus Solutions
        * @description :  Method to get total number of attachment for selected object.
        * @Param :
        * @Return : boolean.
        * @Date:26/05/2016
    */
    public integer checkNumberOfAttachmentForAnObject() {
    	list<Attachment> jsonAttachmentForObjectList = new list<Attachment>();
    	if(startDate == null)
    	   startDate = date.today();
    	if(endDate == null)
    	   endDate = date.today();
    	if(string.isNotBlank(selectedObject)) {
	    	jsonAttachmentForObjectList = [SELECT Id
	                                       FROM Attachment
	                                       WHERE Name like :system.Label.AttachmentFileName+'%'
	                                       AND  parentID =: ultraTrackContainerMap.get(selectedObject).ID 
	                                       AND (LastModifiedDate >= :datetime.newInstance(startDate, Time.newInstance(0,0,0,0))
	                                       AND LastModifiedDate <= :datetime.newInstance(endDate, Time.newInstance(23,59,59,59)))
	                                       order by LastModifiedDate Desc
				                           ];
    	}
	    if(jsonAttachmentForObjectList.size() > 1)
	       return jsonAttachmentForObjectList.size();
	    return 1;
    }
    
    public void getShowMoredata() {
    	++ offsetSize;
    	--showMoreData;
    	getshowTrackHistoryData();
    	first();
    }

    /**
        * @Author: Eternus Solutions
        * @description : Method to check modified date of record should be in range.
        * @Param :
        * @Return : boolean
        * @Date:15/11/2015
    */
    @TestVisible private boolean checkStartEndDateRange(Date modifiedDateTime) {
        boolean flag = false;
        if(startDate != null && endDate != null) {
            if(modifiedDateTime >= startDate && modifiedDateTime <= endDate) {
                flag = true;
            }
        }
        else if(startDate != null && endDate == null) {
            if(modifiedDateTime >= startDate) {
                flag = true;
            }
        }
        else if(startDate == null && endDate != null) {
            if(modifiedDateTime <= endDate) {
                flag = true;
           }
        }
        return flag;
    }
    
    
    /**
        * @Author: Eternus Solutions
        * @description : 1.method to call to methods getshowTrackHistoryData on load and when user click on view data button .
                         2.Method first() will get fields for first page (pagination)
        * @Param :
        * @Return : 
        * @Date:15/11/2015
    */
     public PageReference getRecord() {
     	    startDate = startDateObj.DateHolder__c;
            endDate = endDateObj.DateHolder__c;
            offsetSize = 0;
            showMoreData = checkNumberOfAttachmentForAnObject();
            getshowTrackHistoryData();
            first();
        return null;
     }
     
     /**
        * @Author: Eternus Solutions
        * @description : 1.set the pagination page data as per page number.
                         2. Create list to display records as per user access.
        * @Param :  
        * @Return :  
        * @Date:15/11/2015
    */
    public void initializeHistoryList () {
        //totalNumberOfRecords = displayAllHistoryWrapperList.size();
        //list<DisplayHistoryWrapper> filterHistoryWrapperList = new list<DisplayHistoryWrapper>();
        displayHistoryWrapperList = new list<DisplayHistoryWrapper>();
       // map <Id, set<Id>> recordIdVsUserOrGroupIdSetMap = new map <Id, set<Id>>(); 
        //map<Id, Set<Id>> userIdVsAllManagerIdMap = new map<Id, Set<Id>>();
        Integer startIndex, endIndex;
           if (counter > 0) {
               startIndex = counter;
               endIndex = totalSize - (counter+pageSize) > 0 ? counter+pageSize : totalSize;
           } 
           else {
              startIndex = 0;
              endIndex = totalSize < pageSize ? totalSize : pageSize;
           }
           
           for (Integer index = startIndex; index < endIndex; index++) {
            
               displayHistoryWrapperList.add(filterHistoryWrapperList[index]);
           }
     }
     /**
        * @Author: Eternus Solutions
        * @description : 1.method to reach at first page of pagination
        * @Param :  
        * @Return :  
        * @Date:15/11/2015
    */
     public PageReference first() {
      counter = 0;
      pageNumber = 1;
      initializeHistoryList();
      return null;
    }

    /**
        * @Author: Eternus Solutions
        * @description : 1.Method to reach at previous page from current page
        * @Param :  
        * @Return :  
        * @Date:15/11/2015
    */
    public PageReference previous() {
      counter -= pageSize;
       --pageNumber;
      initializeHistoryList();
      return null;
    }

    
     /**
        * @Author: Eternus Solutions
        * @description : 1.Method to reach on next page from current page
        * @Param :  
        * @Return :  
        * @Date:15/11/2015
    */
    public PageReference next() {
      counter += pageSize;
       ++pageNumber;
      initializeHistoryList();
     return null;
    }

    
    /**
        * @Author: Eternus Solutions
        * @description : 1.Method to reach at last page
        * @Param :  
        * @Return :  
        * @Date:15/11/2015
    */ 
    public PageReference last() {
        
        
        if(math.mod(totalSize, pageSize) == 0) {
            pageNumber = totalNumberOfRecords/pageSize;
            counter =  totalSize - (totalNumberOfRecords/pageSize);
        } 
        else {
            pageNumber = math.round(totalNumberOfRecords/pageSize) + 1;
            counter = totalSize - math.mod(totalSize, pageSize);
        }
        initializeHistoryList();
        return null;
    }
    
    /**
        * @Author: Eternus Solutions
        * @description : 1.Method to enable or disable the pagination's previous button.
        * @Param :  
        * @Return :  
        * @Date:15/11/2015
    */ 
    public boolean getHasPrevious() { 
        return (counter>0) ? false : true;
    }
    
    /**
        * @Author: Eternus Solutions
        * @description : 1.Method to enable or disable the pagination's Next button.
        * @Param :  
        * @Return :  
        * @Date:15/11/2015
    */ 
    public boolean getHasNext() {
        return (counter + pageSize < totalSize) ? false : true;
    }
    
     /**
        * @Author: Eternus Solutions
        * @description : 1.Method to get start and end date for selected dateFilter.
        * @Param :  
        * @Return :  
        * @Date:15/11/2015
    */ 
    public void dateFilter() {
        list<Ultra_Track_Container__c> startEndDateList = new list<Ultra_Track_Container__c>();
        if(selectedDateFilter != 'Custom') {
             startEndDateList = UltraTrackUtilityClass.getStartAndEndDateForFilter(selectedDateFilter);
             startDateObj.DateHolder__c = startEndDateList[0].DateHolder__c;
             endDateObj.DateHolder__c = startEndDateList[1].DateHolder__c;
        }
        getRecord();
    }
    
     /**
        * @Author: Eternus Solutions
        * @description :  Method to get records if start and end date is null.
        * @Param :
        * @Return : 
        * @Date:26/05/2016
    */
    public void dateFileterWhenStartEndDateNull() {
        
        selectedDateFilter = 'Custom';
        getRecord();
    }
    
    /**
        * @Author: Eternus Solutions
        * @description :  Method to get datetime for passed string in user tiemzone.
        * @Param :
        * @Return : DateTime.
        * @Date:26/05/2016
    */
    public DateTime getDateTimeForUserTimeZone(string dateTimeString) {
        
        List<string> sliptStr = dateTimeString.split(' ');
        list<string> dateStr = sliptStr[0].split('/');
        list<string> timeStr = sliptStr[1].split(':');
        DateTime newDateTime = DateTime.newInstance(Integer.valueOf(dateStr[2]), 
                                                    Integer.valueOf(dateStr[0]), 
                                                    Integer.valueOf(dateStr[1]), 
                                                    Integer.valueOf(timeStr[0]), 
                                                    Integer.valueOf(timeStr[1]), 
                                                    0);
        return newDateTime;
    }
     /**
        * @Author: Eternus Solutions
        * @description : DisplayHistoryWrapper class to display records.
        * @Param :  
        * @Return :  
        * @Date:15/11/2015
    */ 
    public class DisplayHistoryWrapper {
        
        public Id parentId {get;set;}
        public HistoryWrapper historyWrapperObj {get;set;}
        public string modifiedTime {get;set;}
        public string modifiedByName {get;set;}
        public string action {get;set;}
        
        public DisplayHistoryWrapper(Id parentId, HistoryWrapper historyWrapperObj, string modifiedTime, string modifiedByIdName, string fieldLabel) {
            this.parentId = parentId;
            this.historyWrapperObj = historyWrapperObj;
            this.modifiedTime = modifiedTime;
            this.modifiedByName = modifiedByIdName;
            this.action = 'Changed <b>'+ fieldLabel +'</b>'+' From <b>';
            this.action += historyWrapperObj.oldValue+ '</b> To <b>' + historyWrapperObj.newValue + '</b>';
        } 
        
    }
    
     /**
        * @Author: Eternus Solutions
        * @description : FieldNameAndWrapper wrapper class to hold History record along with Fieldname. 
        * @Param :
        * @Return : 
        * @Date:26/05/2016
    */
    public class FieldNameAndWrapper {
        
        public string fieldName;
        public HistoryWrapper historyWrapperObj;
        
        public FieldNameAndWrapper(string fieldName, HistoryWrapper historyWrapperObj) {
            this.fieldName = fieldName;
            this.historyWrapperObj = historyWrapperObj;
        }
    }
    /**
        * @Author: Eternus Solutions
        * @description : DateFilterWrapper class to dateFileter records.
        * @Param :  
        * @Return :  
        * @Date:15/11/2015
    */ 
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
        * @description : Method open csv file for displayed records.
        * @Param :  
        * @Return :  
        * @Date:15/11/2015
    */ 
    public PageReference exportAsCSVFile(){
        PageReference pageCSV = new PageReference('/apex/GenerateCsvFilePage');
        pageCSV.setRedirect(false); 
        system.debug('Heap Size='+Limits.getHeapSize());
        //Display date on PDF and CSV page
        strDateTime = String.valueOf(System.Now().format());
        return pageCSV;
    }
    
    /**
        * @Author: Eternus Solutions
        * @description : Method open pdf file for displayed records.
        * @Param :  
        * @Return :  
        * @Date:15/11/2015
    */ 
    public PageReference exportAsPDFFile(){
        PageReference pagePDF = new PageReference('/apex/GeneratePdfFilePage');
        pagePDF.setRedirect(false); 
        system.debug('Heap Size='+Limits.getHeapSize());
        //Display date on PDF and CSV page
        strDateTime = String.valueOf(System.Now().format());
        return pagePDF;
    }

}