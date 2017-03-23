/**
 * @Class Name: UltraSetupController 
 * @Description: This is Controller class of visual force page "UltraSetup". 
 *   It saves and update the setting for sObjects to track the history of fields.
 *   display the triggerable object's list and their updateabale fields in row and column.
 *   Implemented pagination for showing fields.  
 * ========================================================================================================================
 *       Version   | Date        | Author             | Comments
 * -------------------------------------------------------------------------------------------------------------------------
 *       1.0       | 15-11-2015  | Eternus Solution   | 1.Created the class for above functionality
 *       1.1       | 2-01-2016   | Eternus Solution   | 1.Added Pagination for fileds 
 *       1.2       | 26-02-2016  | Eternus Solution   | 1.Code review changes
 *       1.3       | 07-07-2016  | Eternus Solution   | 1.Code review changes
 * ========================================================================================================================
 **/
public with sharing class UltraSetupController {
    // objects variable for holding selected object name
    public String objects{get;set;}
    //set for holding the selected fields of selected object
    public Set<String>  selectedFieldSet ;
    //boolean varible to check object's all fields are selected or not  
    public boolean isAllSelected{get;set;}
    //int variable for holding page size for pagination
    public Integer counter = 0;
    //int varible to hold number fields to display on single page.
    public Integer pageSize { get; set; }
    //int variable to hold total number of fields for sObject
    public Integer totalSize { get; set; }
    public Integer pageNumber { get; set; }
    //display field count on page
    public Integer displayFieldCount{get;set;}
    //Wrapper class list to hold all fields of selected object
    public list<UltraTrackWrapper> allFieldswrapperClassList;
    //To hold all editable sobject list  
    public list<String> objList{get;set;}
    //boolean variable to mak visible or invisible field section
    public boolean isObject{get;set;} 
    // to store how many number of columns to display the fields
    public Integer numberOfColumns;
    // to store how many fields per column to be displayed
    public Integer numberOfFieldsPerColumns;
    //Wrapper class list to display fields on page
    public list<UltraTrackWrapper> wrapperClassList = new list<UltraTrackWrapper>();
    list<Ultra_Track_Container__c> savedFieldsList = new list<Ultra_Track_Container__c>();
    //list of list for display data dynamicaly in grid format 
    public list<list<UltraTrackWrapper>> lstOfLstWrapperClass {get;set;}
    //wrapperclass list for to add elements into list of list.
    public list<UltraTrackWrapper> lstWrap = new list<UltraTrackWrapper>();
    //Utility class object to call methods
    public UltraTrackUtilityClass objUtility {get;set;}
    public ConfigurationController configObj{get;set;}
    //Boolean variable to check remote site settings present or not.
    public boolean isRemoteSiteSettings {get;set;}
    
    public Integer numberOfColumnsPicklistValue{get;set;}
    public Integer numberOfFieldsPerColumnsPicklistValue{get;set;}
    public Integer numberOfRecordToDisplayPicklistValue{get;set;}
    public String sortFieldsValue{get;set;}
    public String baseURL='';

    // Added constant strings to avoid hardcoding.
    private final static String PROTOCOL = 'https://';
    private final static String SOBJECT_ENDPOINT = '/services/data/v36.0/sobjects/';
    private final static String HTTP_GET_METHOD = 'GET';
    private final static String HTTP_CONTENT_TYPE = 'Content-Type'; 
    private final static String HTTP_CONTENT_TYPE_JSON = 'application/json';
    private final static String HTTP_HEADER_AUTHORIZATION = 'Authorization';
    private final static String HTTP_HEADER_AUTHORIZATION_BEARER = 'Bearer ';
    private final static String SOBJECTS = 'sobjects';
    private final static String TRIGGERABLE = 'triggerable';
    private final static String STRING_TRUE = 'true';
    private final static String UPDATEABLE = 'updateable';
    private final static String SOBJECT_LABEL = 'label';
    private final static String SOBJECT_NAME = 'name';
    private final static String BRACKET_OPEN = '(';
    private final static String BRACKET_CLOSE = ')';
    private final static String UNAUTHORIZED_ENDPOINT = 'Unauthorized endpoint';
    private final static String WHITE_SPACE = ' ';
    private final static String COMMA = ',';
    private final static String EMPTY_STRING = '';
     
    /**
     * @Author: Eternus Solutions
     * @description : Constuctor to Configure the number of columns and number of fields per column to display
     * @Param :
     * @Return : 
     * @Date:24/02/2016
     **/
    public UltraSetupController() {
        isObject = false;
        isAllSelected = false;
        pageNumber =0;
        isRemoteSiteSettings = false;
        getConfigurationSettingData();
        pageSize = integer.valueOf(numberOfFieldsPerColumns)*integer.valueOf(numberOfColumns);
        //Call the method to get all objects list
        getObjectList();
        objUtility = new UltraTrackUtilityClass();
        configObj = new ConfigurationController();
        allFieldswrapperClassList = new list<UltraTrackWrapper>();
    }
    /**
     * @Author: Eternus Solutions
     * @description : Method to get configuration setting for displaying layout
     * @Param :
     * @Return :  
     * @Date:6/05/2016
     **/
    public void getConfigurationSettingData(){
        map<String,Configuration__c> mapConfig = Configuration__c.getAll();
        if(mapConfig.containsKey(system.Label.ConfigureColsAndFieldsCustomSettingRecordName)){
              Configuration__c objCofig = mapConfig.get(system.Label.ConfigureColsAndFieldsCustomSettingRecordName);
              numberOfColumns = numberOfColumnsPicklistValue = Integer.valueOf(objCofig.Number_Of_Columns__c);
              numberOfFieldsPerColumns = numberOfFieldsPerColumnsPicklistValue = Integer.valueOf(objCofig.Number_Of_Fields_Per_Column__c);
              numberOfRecordToDisplayPicklistValue =  Integer.valueOf(objCofig.Number_Of_Records_Per_Page__c);
              sortFieldsValue = objCofig.Sort_Fields_By__c;
              baseURL= PROTOCOL + objCofig.SalesforceBaseURL__c;
        }
        else{
              numberOfColumns = numberOfColumnsPicklistValue= Integer.valueOf(system.label.DefaultNumberOfColumnValue);
              numberOfFieldsPerColumns = numberOfFieldsPerColumnsPicklistValue = Integer.valueOf(system.label.DefaultNumberOfFieldsPerColumnValue);
              numberOfRecordToDisplayPicklistValue = Integer.valueOf(system.label.DefaultNumberOfHistoryRecordsToDisplay);
              sortFieldsValue = system.label.DefaultFieldSortingOption;
        } 
    }
    /**
     * @Author: Eternus Solutions
     * @description : Method to get the all triggerable and updateable objects from org
     * @Param :
     * @Return :it will return the list of object names 
     * @Date:24/02/2016
     **/
    public void getObjectList(){
        map<String,Object> mapResp = new map<String,Object>(); 
        list<object> sObjectList = new list<object>();
        objList = new list<String>();
        String sessionId = userInfo.getSessionId();
        isRemoteSiteSettings = false;
        try{
            Httprequest req = new HttpRequest();
            HttpResponse res = new HttpResponse ();
            req.setEndpoint(baseURL + SOBJECT_ENDPOINT);
            req.setMethod(HTTP_GET_METHOD);
            req.setHeader(HTTP_CONTENT_TYPE, HTTP_CONTENT_TYPE_JSON);
            req.setHeader(HTTP_HEADER_AUTHORIZATION, HTTP_HEADER_AUTHORIZATION_BEARER +sessionId);
            Http httpReq = new Http();
            res = httpReq.send(req);
            
            mapResp = (map<String,Object>) JSON.deserializeUntyped(res.getBody());
            if(!mapResp.values().isEmpty()){
                sObjectList = (list<object>)mapResp.get(SOBJECTS);
                if(!sObjectList.isEmpty()){
                    for(object objInfo : sObjectList )
                    {
                        map<String,Object> mapObjInfo = (map<String,Object>)objInfo;
                        if(STRING_TRUE.equalsIgnoreCase(string.valueOf(mapObjInfo.get(TRIGGERABLE)))
                        && STRING_TRUE.equalsIgnoreCase(string.valueOf(mapObjInfo.get(UPDATEABLE))))
                        {
                            objList.add(String.valueOf(mapObjInfo.get(SOBJECT_LABEL))
                                      + WHITE_SPACE + BRACKET_OPEN +String.valueOF(mapObjInfo.get(SOBJECT_NAME))+BRACKET_CLOSE);
                        }
                    }
                }
            }
        }
        catch(System.CalloutException e){
            if(e.getMessage().contains(UNAUTHORIZED_ENDPOINT)){
                isRemoteSiteSettings = true;
            }
        }
    }
    /**
     * @Author: Eternus Solutions
     * @description : Method to get selected object's all editable field's label with isSelected status.
     * @Param :
     * @Return : 
     * @Date:15/11/2015
     **/
    public void getFieldsList(){
        allFieldswrapperClassList = new list<UltraTrackWrapper>();
        map<String,String> mapFieldsAndLabels = new map<String,String>();
        Set<String> setOfSelectedFields = new Set<String>();
        if(String.isNotBlank(objects)) {
            mapFieldsAndLabels = objUtility.getFieldNamesAndLabels(objects.substringAfterLast(BRACKET_OPEN).remove(BRACKET_CLOSE));
            isObject = (!mapFieldsAndLabels.values().isEmpty()) ? true : false;
            if(!isObject){
                objUtility.displayMessage(ApexPages.severity.WARNING,system.label.Object_Not_Found);
            }
        
        savedFieldsList = [SELECT Id,
                                  Object_Name__c,
                                  Tracked_Fields__c,
                                  Is_Tracking_Enabled__c 
                           FROM Ultra_Track_Container__c
                           WHERE Object_Name__c =: objects.substringAfterLast(BRACKET_OPEN).remove(BRACKET_CLOSE) 
                           limit 1];
        if(!savedFieldsList.isEmpty() && String.isNotBlank(savedFieldsList[0].Tracked_Fields__c) ){
            setOfSelectedFields = 
                new Set<String>(savedFieldsList[0].Tracked_Fields__c.split(COMMA));
        }
        if(!mapFieldsAndLabels.values().isEmpty()){
            for (String field : mapFieldsAndLabels.keySet()) {
               if(!setOfSelectedFields.isEmpty() && setOfSelectedFields.contains(field)){
                   allFieldswrapperClassList.add(new UltraTrackWrapper(field,
                                                        mapFieldsAndLabels.get(field),
                                                        true)); 
               }  
               else{
                allFieldswrapperClassList.add(new UltraTrackWrapper(field,
                                                    mapFieldsAndLabels.get(field),
                                                    false));
               }   
           } 
       }
       allFieldswrapperClassList.sort();
       }
    }
   
    /**
     * @Author: Eternus Solutions
     * @description : 1.Method to find all selected fields for selected sObject.
     *                2.this method calls the saveSetting and updateSetting methods for saving the setting. 
     * @Param :
     * @Return : 
     * @Date:15/11/2015
     **/
    public void selectedFieldsName () {
          selectedFieldSet = new set<String>();
          if (!allFieldswrapperClassList.isEmpty()) {
             for(UltraTrackWrapper wrapperObj : allFieldswrapperClassList) {
                if (wrapperObj.isSelected != null && wrapperObj.isSelected) {
                   selectedFieldSet.add(wrapperObj.fieldApiName);
                }
             }
          }
        if(!savedFieldsList.isEmpty()){
            updateSetting(selectedFieldSet);
        }
        else{
            saveSetting(selectedFieldSet);
        }
     }

    /**
     * @Author: Eternus Solutions
     * @description : 1.method to call to methods when user select object.
     *                2.Method getFieldsList() will be call to get fileds 
     *                3.Method first() will get fields for first page (pagination)
     * @Param :
     * @Return : 
     * @Date:15/11/2015
     **/
    public PageReference refresh() {
        getFieldsList();
        first();
        return null;
    }
 
    /**
     * @Author: Eternus Solutions
     * @description : 1.Method to set the selectAll checkbox value if all fields was selected.
     * @Param :
     * @Return : 
     * @Date:15/11/2015
     **/
    public void setSelectAllCheckboxValue(List<UltraTrackWrapper> wrapperClassList) {
        if(!wrapperClassList.isEmpty()){
            isAllSelected = true;
            for(UltraTrackWrapper obj: wrapperClassList) {
                if(obj.isSelected == null ||(obj.isSelected != null && !obj.isSelected)){
                    isAllSelected = false;
                    break;
                }
            }
        }
     }

    /**
     * @Author: Eternus Solutions
     * @description : Method to select all checkbox when click on select all button
     * @Param : 
     * @Return : 
     * @Date:31/3/2015
     **/
    public void selectAllCheckboxes(){
        if(!allFieldswrapperClassList.isEmpty()){
            if(isAllSelected){
                for( UltraTrackWrapper obj : allFieldswrapperClassList){
                    obj.isSelected=true;
                }       
            }else{
                for( UltraTrackWrapper obj : allFieldswrapperClassList){
                    obj.isSelected=false;
                }    
            }
        }
    }

    /**
     * @Author: Eternus Solutions
     * @description : 1. Method to Save the setting into custom object for 
     *                   respected object's respected fields
     * @Param : set of string which holds the name of fields.
     * @Return : 
     * @Date:15/11/2015
     **/
    public void saveSetting(Set<String> selectedFieldSet) 
    {
        list<Ultra_Track_Container__c> listToSaveSetting =
                                    new list<Ultra_Track_Container__c>();
        String commaSepratedString = EMPTY_STRING;
        if(savedFieldsList.isEmpty() && !selectedFieldSet.isEmpty()) {
            commaSepratedString = getCommaSepratedFields(selectedFieldSet);
            listToSaveSetting.add(new Ultra_Track_Container__c 
                        (Object_Name__c = objects.substringAfterLast(BRACKET_OPEN).remove(BRACKET_CLOSE),
                        Object_Label__c = objects,
                        Tracked_Fields__c = commaSepratedString,
                        Is_Tracking_Enabled__c = true));
            //insert listToSaveSetting contains 1 record; 
            for(Database.SaveResult sr : Database.insert(listToSaveSetting,false)) { 
                if (sr.isSuccess())  {
                    objUtility.displayMessage(ApexPages.severity.Confirm,
                        system.label.Ultra_Track_Container_Save_Message1+WHITE_SPACE+objects.subStringBefore(WHITE_SPACE + BRACKET_OPEN)+WHITE_SPACE+
                        +system.label.Ultra_Track_Container_Save_Message2);
                    isObject = false;
                }
            }
       }
       else{
           objUtility.displayMessage(ApexPages.severity.WARNING,system.label.Field_Not_Selected);
       }
    }
 
      /**
        * @Author: Eternus Solutions
        * @description : 1.Method to update the setting of sObject and their fields
        * @Param : Set of string which holds the name of fields.
        * @Return : 
        * @Date:15/11/2015
    */
     public void updateSetting(set<String> selectedFieldSet){
        String fieldvalue = '';
        if(!savedFieldsList.isEmpty()) {
             if(!selectedFieldSet.isEmpty()){
                fieldvalue = getCommaSepratedFields(selectedFieldSet);
            }
            savedFieldsList[0].Is_Tracking_Enabled__c = (String.isBlank(fieldvalue)) ? false : true;
            savedFieldsList[0].Tracked_Fields__c = (savedFieldsList[0].Tracked_Fields__c == Null)? 
                                                    savedFieldsList[0].Tracked_Fields__c=EMPTY_STRING: savedFieldsList[0].Tracked_Fields__c;
            if(savedFieldsList[0].Tracked_Fields__c != fieldvalue){
                savedFieldsList[0].Tracked_Fields__c = fieldvalue;
                //Update savedFieldsList which contains 1 record
                for(Database.SaveResult sr : Database.update(savedFieldsList,false)) {
                    if (sr.isSuccess())  {
                        objUtility.displayMessage(ApexPages.severity.Confirm,
                        system.label.Ultra_Track_Container_Save_Message1+WHITE_SPACE+objects.subStringBefore(WHITE_SPACE + BRACKET_OPEN)+WHITE_SPACE+
                        +system.label.Ultra_Track_Container_Save_Message2);
                        isObject = false;
                    }
                }
            }
            else{
                objUtility.displayMessage(ApexPages.severity.Confirm,
                            system.label.Ultra_Track_Container_Save_Message1+WHITE_SPACE+objects.subStringBefore(WHITE_SPACE + BRACKET_OPEN)+WHITE_SPACE+
                            +system.label.Ultra_Track_Container_Save_Message2);
            }
        }    
    }
    
     /**
        * @Author: Eternus Solutions
        * @description : 1.Method to create the comma Seprated string from set of selectedFields
        * @Param : set of string which holds the name of fields.
        * @Return : comma seprated string
        * @Date:15/11/2015
    */
     public String getCommaSepratedFields(set<string> selectedFieldsSet){
         String commaSepratedString = EMPTY_STRING;
         if(!selectedFieldsSet.isEmpty()){
             for(String str : selectedFieldsSet) {
                commaSepratedString += str + COMMA ;
             }
           commaSepratedString = commaSepratedString.subString(0,
                                            commaSepratedString.length()-1); 
         }
         return commaSepratedString;
     }
     
    /**
        * @Author: Eternus Solutions
        * @description : 1.set the pagination page data as per page number.
        *                2.method creates the 2D list for displaying data in grid view on page.
        * @Param :  
        * @Return :  
        * @Date:15/11/2015
    */
    public void initializeFieldList (){
        totalSize = allFieldswrapperClassList.size();
        wrapperClassList = new list<UltraTrackWrapper>();
        
        Integer startIndex, endIndex;
        if (counter > 0) {
            wrapperClassList = new list<UltraTrackWrapper>();
            startIndex = counter;
            endIndex = totalSize - (counter+pageSize) > 0 ? counter+pageSize : totalSize;
        } 
        else {
            startIndex = 0;
            endIndex = totalSize < pageSize ? totalSize : pageSize;
        }
        for (Integer index = startIndex; index < endIndex; index++) {
            wrapperClassList.add(allFieldswrapperClassList[index]);
        }
        displayFieldCount = wrapperClassList.size();
        // create 2D list to display fields in grid
        lstOfLstWrapperClass = new list<list<UltraTrackWrapper>>();
        if(!wrapperClassList.isEmpty()){
            for(Integer index=0;index<wrapperClassList.size();index++){
                Integer k = index;
                for(Integer j=0; j < Integer.valueof(numberOfColumns); j++){
                    if(k < wrapperClassList.size()){
                        lstWrap.add(wrapperClassList[k]);
                        k++;
                    }
                }
                index = --k;
                lstOfLstWrapperClass.add(lstWrap);
                lstWrap = new list<UltraTrackWrapper>();
            }
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
      initializeFieldList();
      if(!wrapperClassList.isEmpty()) { 
          //method to set selectAllCheckBox value
          setSelectAllCheckboxValue(wrapperClassList);   
        }
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
      initializeFieldList();
      if(!wrapperClassList.isEmpty()) { 
          //method to set selectAllCheckBox value
          setSelectAllCheckboxValue(wrapperClassList);
        }
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
      initializeFieldList();
      if(!wrapperClassList.isEmpty()) { 
          //method to set selectAllCheckBox values
          setSelectAllCheckboxValue(wrapperClassList);
        }
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
       // counter = totalSize - math.mod(totalSize, pageSize);
        if(math.mod(totalSize, pageSize) == 0) {
            pageNumber = totalSize/pageSize;
            counter =  totalSize - (totalSize/pageSize);
        } 
        else {
            pageNumber = math.round(totalSize/pageSize) + 1;
            counter = totalSize - math.mod(totalSize, pageSize);
        }
        initializeFieldList();
        if(!wrapperClassList.isEmpty()) { 
            //method to set selectAllCheckBox value
            setSelectAllCheckboxValue(wrapperClassList);
        }
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
    public pageReference saveAndUpdateConfigurationSetting(){
        configObj.numberOfColumns = numberOfColumnsPicklistValue;
        configObj.numberOfFieldsPerColumns = numberOfFieldsPerColumnsPicklistValue;
        configObj.sortFieldsBy = sortFieldsValue;
        configObj.numberOfHistoryRecords = numberOfRecordToDisplayPicklistValue;
        configObj.saveConfiguration();
        getConfigurationSettingData();
        pageSize = integer.valueOf(numberOfFieldsPerColumns)*integer.valueOf(numberOfColumns);
        configObj = new ConfigurationController();
        if(!allFieldswrapperClassList.isEmpty()){
            allFieldswrapperClassList.sort();
            first();
        }
        return null;
    }
    
}