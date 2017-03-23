/**
  * @Class Name: UltraSetupController
  * @Description: This is Controller class of visual force page "UltraSetup".
  *               It saves and update the setting for sObjects to track the history of fields.
  *               Display the triggerable object's list and their updateabale fields in row and column.
  *               Implemented pagination for showing fields.
  * ========================================================================================================================
  *       Version   | Date        | Author             | Comments
  * -------------------------------------------------------------------------------------------------------------------------
  *       1.0       | 15/11/2015  | Eternus Solution   | 1.Created the class for above functionality
  * ========================================================================================================================
  **/

public with sharing class UltraSetupController {

    @TestVisible set<String> selectedFieldSet = new set<String>();

    // Wrapper class list to hold all fields of selected object
    public list<UltraTrackWrapper> allFieldswrapperClassList;
    // Holds the current salesforce instance base URL fetched from configObj / Configuration custom setting.
    public String baseURL = UFHTConstants.EMPTY_STRING;
    // Integer variable for holding page size for pagination
    public Integer counter = 0;
    // Wrapperclass list for to add elements into list of list.
    public list<UltraTrackWrapper> wrapList = new list<UltraTrackWrapper>();
    // To store how many number of columns to display the fields
    public Integer numberOfColumns;
    // To store how many fields per column to be displayed
    public Integer numberOfFieldsPerColumns;
    // Holds the list of fields to be tracked.
    Ultra_Track_Container__c ultraContainerObj;
    // Wrapper class list to display fields on page
    public list<UltraTrackWrapper> wrapperClassList = new list<UltraTrackWrapper>();
    // Configuration class object for utilization
    public ConfigurationController configObj { get; set; }
    // Boolean variable to check object's all fields are selected or not
    public Boolean isAllSelected { get; set; }
    // Boolean variable to mak visible or invisible field section
    public Boolean isObject { get; set; }
    // Boolean variable to check remote site settings present or not.
    public Boolean isRemoteSiteSettings { get; set; }
    // List of list for display data dynamically in grid format
    public list<list<UltraTrackWrapper>> lstWrapperClassList { get; set; }
    // Holds the number of columns fetched from configObj / Configuration custom setting.
    public Integer numberOfColumnsPicklistValue { get; set; }
    // Holds the number of fields per column fetched from configObj / Configuration custom setting.
    public Integer numberOfFieldsPerColumnsPicklistValue { get; set; }
    // Holds the number of records per page fetched from configObj / Configuration custom setting.
    public Integer numberOfRecordToDisplayPicklistValue { get; set; }
    // Objects variable for holding selected object name
    public String objects { get; set; }
    // To hold all editable sobject list
    public list<String> objList { get; set; }
    // Integer variable to hold current page number
    public Integer pageNumber { get; set; }
    // Integer variable to hold number fields to display on single page.
    public Integer pageSize { get; set; }
    // Holds the fields by which sorting is performed, fetched from configObj / Configuration custom setting.
    public String sortFieldsValue { get; set; }
    // Integer variable to hold total number of fields for sObject
    public Integer totalSize { get; set; }
    // Trigger deployment AsynResult Id
    public Id asynResultId;
    // Variable is used to check if deployment is completed or not.
    public Boolean enablePollar {get; set;}
    
    public Integer progressCounter {get; set;}

   /** 
     * @Author: Eternus Solutions
     * @Description: Constructor to Configure the number of columns and number of fields per column to display
     * @Param:
     * @Return:
     * @Date: 24/02/2016
     **/
    public UltraSetupController() {
        isObject = false;
        isAllSelected = false; 
        pageNumber = 0;
        isRemoteSiteSettings = false;
        enablePollar = false;
        getConfigurationSettingData();
        progressCounter = 0;
        pageSize = numberOfFieldsPerColumns * numberOfColumns;

        // Call the method to get all objects list
        getObjectList();
        configObj = new ConfigurationController();
        allFieldswrapperClassList = new list<UltraTrackWrapper>();
    }

   /**
     * @Author: Eternus Solutions
     * @Description: Method to get configuration setting for displaying layout
     * @Param:
     * @Return:
     * @Date: 6/05/2016
     **/
    public void getConfigurationSettingData() {
    if(!UltraTrackUtility.isAllowDMLForCustomSetting('UFHT__Configuration__c','isAccessible')){
      UltraTrackUtility.displayMessage(ApexPages.Severity.ERROR, System.Label.GenericError);
          return;
    }
    map<String, Configuration__c> configurationMap = Configuration__c.getAll();
        if(configurationMap.containsKey(System.Label.ConfigureColsAndFieldsCustomSettingRecordName)) {

            Configuration__c configObj = configurationMap.get(System.Label.ConfigureColsAndFieldsCustomSettingRecordName);

            setConfigurationSettingData(String.valueOf(configObj.Number_Of_Columns__c),
                                        String.valueOf(configObj.Number_Of_Fields_Per_Column__c),
                                        String.valueOf(configObj.Number_Of_Records_Per_Page__c),
                                        configObj.Sort_Fields_By__c,
                                        UFHTConstants.PROTOCOL + configObj.SalesforceBaseURL__c);
        }
        else {

            setConfigurationSettingData(System.Label.DefaultNumberOfColumnValue,
                                        System.Label.DefaultNumberOfFieldsPerColumnValue,
                                        System.Label.DefaultNumberOfHistoryRecordsToDisplay,
                                        System.Label.DefaultFieldSortingOption,
                                        UFHTConstants.PROTOCOL + URL.getSalesforceBaseUrl().getHost());
        }
    }

   /**
     * @Author: Eternus Solutions
     * @Description: Method to set values of configuration setting for displaying layout
     * @Param: 1. numberOfColumn: Number of column need to be disply on setup page.
     *         2. numberOfFieldsPerColumn: Number of fields per column to be disply on setup page.
     *         3. numberOfRecordToDisplay: Number of record to be display on view data page.
     *         4. sortFieldValue: Field sort order.
     *         5. baseUrl: Base url.
     * @Return:
     * @Date: 21/07/2016
     **/
    @testvisible void setConfigurationSettingData(String numberOfColumn,
                                     String numberOfFieldsPerColumn,
                                     String numberOfRecordToDisplay,
                                     String sortFieldValue,
                                     String baseUrl) {

        try {
            numberOfColumns = numberOfColumnsPicklistValue = Integer.valueOf(numberOfColumn);
        }
        catch(Exception e) {
            numberOfColumns = numberOfColumnsPicklistValue = 5;
        }
        try {
            numberOfFieldsPerColumns = numberOfFieldsPerColumnsPicklistValue = Integer.valueOf(numberOfFieldsPerColumn);
        }
        catch(Exception e) {
            numberOfFieldsPerColumns = numberOfFieldsPerColumnsPicklistValue = 10;
        }
        try {
            numberOfRecordToDisplayPicklistValue = Integer.valueOf(numberOfRecordToDisplay);
        }
        catch(Exception e) {
            numberOfRecordToDisplayPicklistValue = 25;
        }
        sortFieldsValue = String.isNotBlank(sortFieldValue) ? sortFieldValue : System.Label.DefaultFieldSortingOption;

        this.baseURL = String.isNotBlank(baseUrl) ? baseUrl : URL.getSalesforceBaseUrl().toExternalForm();

    }
    /**
     * @Author: Eternus Solutions
     * @Description: Method to get the all triggerable and updateable objects from org
     * @Param:
     * @Return:
     * @Date: 24/02/2016
     **/
    public void getObjectList() {

        map<String, Object> responseMap = new map<String, Object>();
        map<String, UFHT__RestrictedObjectForFieldTracking__c> restrictedObjectForFieldTrackingMap = new map<String, UFHT__RestrictedObjectForFieldTracking__c>();
        objList = new list<String>();
        isRemoteSiteSettings = false;

        try {

            Httprequest req = new HttpRequest();

            req.setEndpoint(baseURL + UFHTConstants.SOBJECT_ENDPOINT);
            req.setMethod(UFHTConstants.HTTP_GET_METHOD);
            req.setHeader(UFHTConstants.HTTP_CONTENT_TYPE, UFHTConstants.HTTP_CONTENT_TYPE_JSON);
            req.setHeader(UFHTConstants.HTTP_HEADER_AUTHORIZATION, UFHTConstants.HTTP_HEADER_AUTHORIZATION_BEARER + userInfo.getSessionId());

            HttpResponse res = new HttpResponse ();
            res = new Http().send(req);

            responseMap = (map<String, Object>) JSON.deserializeUntyped(res.getBody());
            map<String, Object> objectInformationMap;
            
            if(!responseMap.values().isEmpty()) {

                list<object> sObjectList = (list<object>)responseMap.get(UFHTConstants.SOBJECTS);
                restrictedObjectForFieldTrackingMap = UFHT__RestrictedObjectForFieldTracking__c.getAll();
                if(sObjectList != null) {

                    for(object infoObj : sObjectList ) {

                        objectInformationMap = (map<String, Object>)infoObj;
                        system.debug('Map-----: '+objectInformationMap);
                        if(UFHTConstants.TRUE_KEYWORD.equalsIgnoreCase(String.valueOf(objectInformationMap.get(UFHTConstants.TRIGGERABLE))) &&
                          UFHTConstants.TRUE_KEYWORD.equalsIgnoreCase(String.valueOf(objectInformationMap.get(UFHTConstants.UPDATEABLE))) &&
                          !UFHTConstants.ATTACHMNET_API_NAME.equalsIgnoreCase(String.valueOf(objectInformationMap.get(UFHTConstants.SOBJECT_NAME))) &&
                          (restrictedObjectForFieldTrackingMap != null && !restrictedObjectForFieldTrackingMap.containsKey(String.valueOF(objectInformationMap.get(UFHTConstants.SOBJECT_NAME)))
                          )) {

                            objList.add(String.valueOf(objectInformationMap.get(UFHTConstants.SOBJECT_LABEL))
                                   + UFHTConstants.WHITE_SPACE + UFHTConstants.BRACKET_OPEN
                                   + String.valueOF(objectInformationMap.get(UFHTConstants.SOBJECT_NAME)) + UFHTConstants.BRACKET_CLOSE);
                        }
                    }
                }
            }
        }

        catch(System.CalloutException e) {

            if(e.getMessage().contains(UFHTConstants.UNAUTHORIZED_ENDPOINT)) {
                isRemoteSiteSettings = true;
            }
            else {
                UltraTrackUtility.displayMessage(ApexPages.severity.ERROR, e.getMessage());
            }
        }

        catch(System.JSONException e) {
            if(Limits.getCallouts() >= Limits.getLimitCallouts()) {
                UltraTrackUtility.displayMessage(ApexPages.severity.ERROR, System.Label.JSON_Error);
            }
        }
    }

    /**
     * @Author: Eternus Solutions
     * @Description: Method to get selected object's all editable field's label with isSelected status.
     * @Param:
     * @Return:
     * @Date: 15/11/2015
     **/
    public void getFieldsList() {

        allFieldswrapperClassList = new list<UltraTrackWrapper>();

        if(String.isNotBlank(objects)) {
            objects = objects.trim();
            map<String, String> fieldsAndLabelsMap = new map<String, String>();
            set<String> selectedFieldsSet = new set<String>();
            
            isObject = UltraTrackUtility.sobjectMap.containsKey(
                       objects.substringAfterLast(UFHTConstants.BRACKET_OPEN).remove(UFHTConstants.BRACKET_CLOSE));
            
            if( !isObject ) {
                UltraTrackUtility.displayMessage(ApexPages.severity.WARNING, UFHTConstants.WHITE_SPACE + System.Label.Object_Not_Found);
                return;
            }
            
            fieldsAndLabelsMap = UltraTrackUtility.getFieldNamesAndLabels(
                objects.substringAfterLast(UFHTConstants.BRACKET_OPEN).remove(UFHTConstants.BRACKET_CLOSE)
            );

            isObject = (fieldsAndLabelsMap!= null && !fieldsAndLabelsMap.values().isEmpty());
            
            if( !isObject ) {
            	
            	UltraTrackUtility.displayMessage(ApexPages.severity.WARNING, UFHTConstants.WHITE_SPACE + 
            	                                 System.Label.No_Updatable_Fields_Found.replace(
            	                                 '<obj name>', 
            	                                 objects.subStringBefore(UFHTConstants.WHITE_SPACE + UFHTConstants.BRACKET_OPEN)
            	                                 ));
                return;
            }
            
      //Check whether the user has access for read access for Ultra Track Container
        if(!UltraTrackUtility.checkObjectAndFieldLevelSecurity('UFHT__Ultra_Track_Container__c', 
                                 new list<String> {'Id','UFHT__Object_Name__c','UFHT__Tracked_Fields__c','UFHT__Is_Tracking_Enabled__c'},
                                 'isAccessible')){
        UltraTrackUtility.displayMessage(ApexPages.severity.WARNING, UFHTConstants.WHITE_SPACE + System.Label.GenericError);
        return;
      
      }        
            try {
                ultraContainerObj = [SELECT Id,
                                          Object_Name__c,
                                          Tracked_Fields__c,
                                          Is_Tracking_Enabled__c
                                     FROM Ultra_Track_Container__c
                                     WHERE Object_Name__c = : objects.substringAfterLast(UFHTConstants.BRACKET_OPEN).remove(UFHTConstants.BRACKET_CLOSE)
                                     LIMIT 1];
            }
            catch(QueryException ex) {
            ultraContainerObj = null;
            }
            if(ultraContainerObj != null && String.isNotBlank(ultraContainerObj.Tracked_Fields__c) ) {
                selectedFieldsSet = new Set<String>(ultraContainerObj.Tracked_Fields__c.split(UFHTConstants.COMMA));
            }
            for(String field : fieldsAndLabelsMap.keySet()) {
                if(selectedFieldsSet.contains(field)) {
                    allFieldswrapperClassList.add(new UltraTrackWrapper(field,
                                                        fieldsAndLabelsMap.get(field),
                                                        true));
                }
                else {
                    allFieldswrapperClassList.add(new UltraTrackWrapper(field,
                                                        fieldsAndLabelsMap.get(field),
                                                        false));
                }
            }
            if( !allFieldswrapperClassList.isEmpty() ) {
                allFieldswrapperClassList.sort();
            }
        }
    }

    /**
     * @Author: Eternus Solutions
     * @Description: 1.Method to find all selected fields for selected sObject.
     *               2.this method calls the saveSetting and updateSetting methods for saving the setting.
     * @Param:
     * @Return:
     * @Date: 15/11/2015
     **/
    public void selectedFieldsName () {
        if(String.isNotBlank(objects)){
            objects = objects.trim();
        }
        set<String> objectNamesSet = new set<String>(objList);
        //Object contains check for triggerrable object
        if( !objectNamesSet.contains(objects)) {
            UltraTrackUtility.displayMessage(ApexPages.severity.WARNING, UFHTConstants.WHITE_SPACE + System.Label.Object_Not_Found);
            return;
        }
        
    if(!UltraTrackUtility.checkObjectAndFieldLevelSecurity('Profile', 
                                 new list<String> {'Id','Name','PermissionsAuthorApex'},
                                 'isAccessible')){
      UltraTrackUtility.displayMessage(ApexPages.severity.WARNING, UFHTConstants.WHITE_SPACE + System.Label.UnAuthorizedTriggerAccess);
      return;
      
    }  
    Boolean authorApexCheck =[SELECT Id,Name,PermissionsAuthorApex  
                  FROM Profile 
                  WHERE Id=:UserInfo.getProfileId()].PermissionsAuthorApex ;                           
        //Check whether the user has access for read and create trigger for new setup details
    if(!authorApexCheck){
      UltraTrackUtility.displayMessage(ApexPages.severity.WARNING, UFHTConstants.WHITE_SPACE + System.Label.UnAuthorizedTriggerAccess);
      return;
    }
        selectedFieldSet = new set<String>();

        if (allFieldswrapperClassList != null) {

            for(UltraTrackWrapper wrapperObj : allFieldswrapperClassList) {

                if (wrapperObj.isSelected != null && wrapperObj.isSelected) {
                    selectedFieldSet.add(wrapperObj.fieldApiName);
                }
            }
        }

        if(ultraContainerObj != null) {
        	
            updateSetting(selectedFieldSet);
        }

        else {
            saveSetting(selectedFieldSet);
        }

    }

   /**
     * @Author: Eternus Solutions
     * @Description: 1. Method to call to methods when user select object.
     *               2. Method getFieldsList() will be called to get fields
     *               3. Method first() will get fields for first page (pagination)
     * @Param:
     * @Return:
     * @Date: 15/11/2015
     **/
    public PageReference refresh() {
        getFieldsList();
        first();
        return null;
    }

    /**
     * @Author: Eternus Solutions
     * @Description: 1.Method to set the selectAll checkbox value if all fields was selected.
     * @Param:
     * @Return:
     * @Date: 15/11/2015
     **/
    public void selectAllCheckboxes(list<UltraTrackWrapper> wrapperClassList) {

        if(wrapperClassList == null || wrapperClassList.isEmpty()) {
            return;
        }

        isAllSelected = true;

        for(UltraTrackWrapper wrapperIterator : wrapperClassList) {

            if(wrapperIterator.isSelected == null || !wrapperIterator.isSelected) {
                isAllSelected = false;
                break;
            }
        }
     }

    /**
     * @Author: Eternus Solutions
     * @Description: Method to select all checkbox when click on select all button
     * @Param:
     * @Return:
     * @Date: 31/3/2015
     **/
    public void selectAllCheckboxes() {

        if(allFieldswrapperClassList != null) {

            for(UltraTrackWrapper wrapperIterator : allFieldswrapperClassList) {
                wrapperIterator.isSelected = isAllSelected;
            }

        }
    }
    
    /**
     * @Author: Eternus Solutions
     * @Description: Method to select all and deselect all checkbox when any field is selected or deselected
     * @Param:
     * @Return:
     * @Date: 17/8/2016
     **/
    public void setSelectOrDeselectAll() {
    	system.debug('Iam here---Callll');
        if(allFieldswrapperClassList != null) {
            isAllSelected = true;      
            for(UltraTrackWrapper wrapperIterator : allFieldswrapperClassList) {
                if(!wrapperIterator.isSelected){
                  isAllSelected = false;
                  break;
                }
            }
            

        }
    }

    /**
     * @Author: Eternus Solutions
     * @Description: 1. Method to Save the setting into custom object for
     *                  respected object's respected fields
     * @Param: set of string which holds the name of fields.
     * @Return:
     * @Date: 15/11/2015
     **/
    public void saveSetting(set<String> selectedFieldSet) {
    	
        enablePollar = false;
        if(selectedFieldSet == null) {
            return ;
        }

        try {
	        if(ultraContainerObj == null && !selectedFieldSet.isEmpty() && String.isNotBlank(objects)) {
	
	            list<Ultra_Track_Container__c> saveSettingList = new list<Ultra_Track_Container__c>();
	            String commaSeprated = getCommaSepratedFields(selectedFieldSet);
	
	            if(UltraTrackUtility.checkObjectAndFieldLevelSecurity('UFHT__Ultra_Track_Container__c',
	                                                                  new list<String> {'UFHT__Object_Name__c', 'UFHT__Object_Label__c',
	                                                                  'UFHT__Tracked_Fields__c', 'UFHT__Is_Tracking_Enabled__c'},
	                                                                  'isInsert')) {
	                                                                  	
	                // Method to check if trigger for selected object is present or not, if not deploy trigger for the same.
	                asynResultId = DynamicTriggerGenerator.generateDynamicTrigger(objects.substringAfterLast(UFHTConstants.BRACKET_OPEN).remove(UFHTConstants.BRACKET_CLOSE), UserInfo.getSessionId());
	                if(asynResultId != null) {
	                	progressCounter = 25;
	                    enablePollar = true;
	                }
	                else {
	                	progressCounter = 50;
	                }
	                saveSettingList.add(new Ultra_Track_Container__c(
	                    Object_Name__c = objects.substringAfterLast(UFHTConstants.BRACKET_OPEN).remove(UFHTConstants.BRACKET_CLOSE),
	                    Object_Label__c = objects,
	                    Tracked_Fields__c = commaSeprated,
	                    Is_Tracking_Enabled__c = true
	                    //AsynResult_Id__c = asynResultId
	                ));

	                // insert saveSettingList contains 1 record;
	                for(Database.SaveResult saveRes : Database.insert(saveSettingList, false)) {

	                    if (saveRes.isSuccess()) {
	                        isObject = true;
	                        if(asynResultId == null) {
	                        	UltraTrackUtility.displayMessage(
                                                    ApexPages.severity.Confirm, UFHTConstants.WHITE_SPACE
                                                    + System.Label.Ultra_Track_Container_Save_Message1
                                                    + UFHTConstants.WHITE_SPACE + objects.subStringBefore(UFHTConstants.WHITE_SPACE + UFHTConstants.BRACKET_OPEN)
                                                    + UFHTConstants.WHITE_SPACE + System.Label.Ultra_Track_Container_Save_Message2 );
	                        }
	                    } 
	                    else {
	                    	UltraTrackUtility.displayMessage(ApexPages.Severity.ERROR, System.Label.GenericError);
	                    }
	                }
	            } 
	            else{
	                 UltraTrackUtility.displayMessage(ApexPages.Severity.ERROR, System.Label.GenericError);
	            }
	        }
	        else {
	            UltraTrackUtility.displayMessage(ApexPages.severity.WARNING, System.Label.Field_Not_Selected);
	        }
        }
        catch(System.CalloutException e) {

            if(e.getMessage().contains(UFHTConstants.UNAUTHORIZED_ENDPOINT)) {
                isRemoteSiteSettings = true;
            }
            else {
                UltraTrackUtility.displayMessage(ApexPages.severity.ERROR, e.getMessage());
            }
        }
    }

    /**
     * @Author: Eternus Solutions
     * @description: 1.Method to update the setting of sObject and their fields
     * @Param: Set of string which holds the name of fields.
     * @Return:
     * @Date: 15/11/2015
     **/
     public void updateSetting(set<String> selectedFieldSet) {

        enablePollar = false;
        if(selectedFieldSet == null) {
            return;
        }

        String fieldvalue = UFHTConstants.EMPTY_STRING;
        try {
	        if(ultraContainerObj != null) {
	
	            if(!selectedFieldSet.isEmpty()) {
	                fieldvalue = getCommaSepratedFields(selectedFieldSet);
	            }
	
	            if(String.isBlank(fieldvalue) && String.isBlank(ultraContainerObj.UFHT__Tracked_Fields__c)) {
	                UltraTrackUtility.displayMessage(ApexPages.severity.WARNING, System.Label.Field_Not_Selected);
	                return;
	            }
	
	            if(UltraTrackUtility.checkObjectAndFieldLevelSecurity('UFHT__Ultra_Track_Container__c',
	                                                                  new list<String> {'UFHT__Tracked_Fields__c', 'UFHT__Is_Tracking_Enabled__c'},
	                                                                  'isUpdate')){
	
	                ultraContainerObj.Is_Tracking_Enabled__c = (String.isBlank(fieldvalue)) ? false : true;
	
	                ultraContainerObj.Tracked_Fields__c = (ultraContainerObj.Tracked_Fields__c == null)
	                                                     ? UFHTConstants.EMPTY_STRING
	                                                     : ultraContainerObj.Tracked_Fields__c;
	                                                     
                    // Method to check if trigger for selected object is present or not, if not deploy trigger for the same.
                    asynResultId = DynamicTriggerGenerator.generateDynamicTrigger(objects.substringAfterLast(UFHTConstants.BRACKET_OPEN).remove(UFHTConstants.BRACKET_CLOSE), UserInfo.getSessionId());
                        
	                if((ultraContainerObj.Tracked_Fields__c != fieldvalue) ||
	                    (ultraContainerObj.Tracked_Fields__c == fieldvalue && asynResultId != null) ) {
	                    ultraContainerObj.Tracked_Fields__c = fieldvalue;
                        //ultraContainerObj.AsynResult_Id__c = asynResultId;
	                    if(asynResultId != null) {
	                    	progressCounter = 25;
	                        enablePollar = true;
	                    }
	                    // Update ultraContainerObj which contains 1 record
	                    Database.SaveResult saveRes  = Database.update(ultraContainerObj, false);
	                    if(asynResultId == null) {
	                        if (saveRes.isSuccess()) {
	                            progressCounter = 100;
	                            UltraTrackUtility.displayMessage(
	                                                ApexPages.severity.Confirm, UFHTConstants.WHITE_SPACE
	                                                + System.Label.Ultra_Track_Container_Save_Message1
	                                                + UFHTConstants.WHITE_SPACE + objects.subStringBefore(UFHTConstants.WHITE_SPACE + UFHTConstants.BRACKET_OPEN)
	                                                + UFHTConstants.WHITE_SPACE + System.Label.Ultra_Track_Container_Save_Message2 );
	                            isObject = true;
	                        }
	                        else {
	                               
	                               UltraTrackUtility.displayMessage(ApexPages.severity.WARNING,
	                                                                      System.Label.Settings_Save_Error);
	                        }
	                    }
	                }
	                else {
	                    UltraTrackUtility.displayMessage(
	                    ApexPages.severity.Confirm,
	                    System.Label.Ultra_Track_Container_Save_Message1 + UFHTConstants.WHITE_SPACE
	                    + objects.subStringBefore(UFHTConstants.WHITE_SPACE + UFHTConstants.BRACKET_OPEN) + UFHTConstants.WHITE_SPACE
	                    + System.Label.Ultra_Track_Container_Save_Message2 );
	                }
	            }
	            else {
	                UltraTrackUtility.displayMessage(ApexPages.Severity.ERROR, System.Label.GenericError);
	            }
	        }
        }
        
        catch(System.CalloutException e) {
    
            if(e.getMessage().contains(UFHTConstants.UNAUTHORIZED_ENDPOINT)) {
                isRemoteSiteSettings = true;
            }
            else {
                UltraTrackUtility.displayMessage(ApexPages.severity.ERROR, e.getMessage());
            }
        }
    }

    /**
     * @Author: Eternus Solutions
     * @Description: 1.Method to create the comma Seprated string from set of selectedFields
     * @Param: Set of string which holds the name of fields.
     * @Return: Comma separated string
     * @Date: 15/11/2015
     **/
    public String getCommaSepratedFields(set<String> selectedFieldsSet) {
        if(selectedFieldsSet == null) {
            return UFHTConstants.EMPTY_STRING;
        }

        String commaSeprated = UFHTConstants.EMPTY_STRING;

        for(String selectedField : selectedFieldsSet) {
            commaSeprated += selectedField + UFHTConstants.COMMA ;
        }

        commaSeprated = String.isNotBlank(commaSeprated) ?
                        commaSeprated.subString(0, commaSeprated.length() - 1):
                        commaSeprated ;
        return commaSeprated;
     }

    /**
     * @Author: Eternus Solutions
     * @Description: 1. Set the pagination page data as per page number.
     *               2. Method creates the 2D list for displaying data in grid view on page.
     * @Param:
     * @Return:
     * @Date: 15/11/2015
     **/
    public void initializeFieldList () {

        totalSize = allFieldswrapperClassList == null ? 0 :allFieldswrapperClassList.size();
        wrapperClassList = new list<UltraTrackWrapper>();
        Integer startIndex, endIndex;

        if (counter != null && counter > 0) {
            startIndex = counter;
            endIndex = totalSize - (counter + pageSize) > 0 ? counter + pageSize : totalSize;
        }

        else {
            startIndex = 0;
            endIndex = totalSize < pageSize ? totalSize : pageSize;
        }

        for(Integer index = startIndex; index < endIndex; index++) {
            wrapperClassList.add(allFieldswrapperClassList[index]);
        }
        // create 2D list to display fields in grid
        lstWrapperClassList = new list<list<UltraTrackWrapper>>();
        Integer k;

        for(Integer index = 0; index < wrapperClassList.size(); index++) {
            k = index;

            for(Integer j = 0; j < Integer.valueOf(numberOfColumns); j++) {

                if(k < wrapperClassList.size()) {
                    wrapList.add(wrapperClassList[k]);
                    k++;
                }
            }

            index = --k;
            lstWrapperClassList.add(wrapList.clone());
            wrapList.clear();
        }
    }

    /**
     * @Author: Eternus Solutions
     * @Description: 1.method to reach at first page of pagination
     * @Param:
     * @Return:
     * @Date: 15/11/2015
     **/

    public PageReference first() {

        counter = 0;
        pageNumber = 1;
        initializeFieldList();

        if(!allFieldswrapperClassList.isEmpty()) {
            // method to set selectAllCheckBox value
            selectAllCheckboxes(allFieldswrapperClassList);
        }

        return null;
    }

    /**
     * @Author: Eternus Solutions
     * @Description: 1.Method to reach at previous page from current page
     * @Param:
     * @Return:
     * @Date: 15/11/2015
     **/
    public PageReference previous() {

        counter -= pageSize;
        --pageNumber;
        initializeFieldList();

        if(!allFieldswrapperClassList.isEmpty()) {
            // method to set selectAllCheckBox value
            selectAllCheckboxes(allFieldswrapperClassList);
        }

        return null;
    }


    /**
     * @Author: Eternus Solutions
     * @Description: 1.Method to reach on next page from current page
     * @Param:
     * @Return:
     * @Date: 15/11/2015
     **/
    public PageReference next() {

        counter += pageSize;
        ++pageNumber;
        initializeFieldList();

        if(!allFieldswrapperClassList.isEmpty()) {
            // method to set selectAllCheckBox values
            selectAllCheckboxes(allFieldswrapperClassList);
        }

        return null;
    }


    /**
     * @Author: Eternus Solutions
     * @Description: 1.Method to reach at last page
     * @Param:
     * @Return:
     * @Date: 15/11/2015
     **/
    public PageReference last() {

        Integer reminder = Math.mod(totalSize, pageSize);
        if(reminder == 0) {
            pageNumber = totalSize / pageSize;
            counter = totalSize - (totalSize / pageSize);
        }

        else {
            pageNumber = Math.round(totalSize / pageSize) + 1;
            counter = totalSize - reminder;
        }

        initializeFieldList();

        if(!allFieldswrapperClassList.isEmpty()) {
            // method to set selectAllCheckBox value
            selectAllCheckboxes(allFieldswrapperClassList);
        }

        return null;
    }

    /**
     * @Author: Eternus Solutions
     * @Description: 1.Method to enable or disable the pagination's previous button.
     * @Param:
     * @Return:
     * @Date: 15/11/2015
     **/
    public boolean getHasPrevious() {
        return !(counter > 0);
    }

    /**
     * @Author: Eternus Solutions
     * @Description: 1.Method to enable or disable the pagination's Next button.
     * @Param:
     * @Return:
     * @Date: 15/11/2015
     **/
    public boolean getHasNext() {
        return !( (counter + pageSize) < totalSize);
    }

   /**
     * @Author: Eternus Solutions
     * @Description: Update the changes made to the Configuration custom setting record.
     * @Param:
     * @Return:
     * @Date: 15/11/2015
     **/
    public pageReference saveAndUpdateConfigurationSetting(){

        configObj.numberOfColumns = numberOfColumnsPicklistValue;
        configObj.numberOfFieldsPerColumns = numberOfFieldsPerColumnsPicklistValue;
        configObj.sortFieldsBy = sortFieldsValue;
        configObj.numberOfHistoryRecords = numberOfRecordToDisplayPicklistValue;
        configObj.saveConfiguration();
        
        getConfigurationSettingData();
    
        pageSize = Integer.valueOf(numberOfFieldsPerColumns) * Integer.valueOf(numberOfColumns);
        configObj = new ConfigurationController();
        
        if(!allFieldswrapperClassList.isEmpty()){
            allFieldswrapperClassList.sort();
            first();
        }
        
        return null;
    }
    
    /**
      * @Author: Eternus Solutions
      * @Description: Method to check if status of trigger deployment. 
      * @Param: NA
      * @Return: NA
      * @Date: 15/11/2015
      **/
    public PageReference checkTriggerDeploymentStatus() {
        if(asynResultId != null) {
            MetadataService.MetadataPort service = new MetadataService.MetadataPort();
            service.SessionHeader = new MetadataService.SessionHeader_element();
            service.SessionHeader.sessionId = UserInfo.getSessionId();
            if(!Test.isRunningTest()) {
                MetadataService.DeployResult deployResult = service.checkDeployStatus(asynResultId, true);
                deployStatusHelper(deployResult.done, deployResult);
            }
            else {
                deployStatusHelper(true, null);
            }
        }    
        return null;
    }
    
    /**
      * @Author: Eternus Solutions
      * @Description: Helper method to check status of trigger deployment.
      * @Param: Boolean deployResultStatus: Deployment status
      *         MetadataService.DeployResult deployResult: Object of DeployResult
      * @Return: NA
      * @Date: 15/11/2015
      **/
    public void deployStatusHelper(Boolean deployResultStatus, MetadataService.DeployResult deployResult){
        Boolean isDeployed;
        String deploymentErrorMessage;
        String objectPrefix;
        String objectCreateNewRecordUrl;
        String objectApiName = objects.substringAfterLast(UFHTConstants.BRACKET_OPEN).remove(UFHTConstants.BRACKET_CLOSE);
        if(progressCounter == 100){
            enablePollar = false;
        }
        
        if(deployResultStatus) {
            deploymentErrorMessage = '';
            progressCounter = 100;
            if(deployResult != null && deployResult.details != null && deployResult.details.componentFailures != null) {
                for(MetadataService.DeployMessage deployMessage : deployResult.details.componentFailures) {
                    if(deployMessage.problem != null) {
                        
                        deploymentErrorMessage += deployMessage.fileName +
                                                 ' (Line: ' + deployMessage.lineNumber + ': Column:' + 
                                                  deployMessage.columnNumber + ') : ' +
                                                  deployMessage.problem;
                        isDeployed = false;
                        //enablePollar = false;
                    }
                }
            }
            else if(deployResult != null && deployResult.details != null && deployResult.details.runTestResult != null && 
                    deployResult.details.runTestResult.failures != null) {
                 for(MetadataService.RunTestFailure runTestFailureMessage : deployResult.details.runTestResult.failures) {
                    if(runTestFailureMessage.message != null) {
                    	if(runTestFailureMessage.message.contains(System.Label.DeploymentTestClassFailureError)) {
                    		objectPrefix = UltraTrackUtility.sobjectMap.containsKey(objectApiName) ?
                                           UltraTrackUtility.sobjectMap.get(objectApiName).getDescribe().getKeyPrefix():
                                           '';
                            objectCreateNewRecordUrl = '/' + objectPrefix + '/e';
                    		deploymentErrorMessage += System.Label.DeploymentErrorMessage.replace
                    		                          ('<object name>', 
                    		                          objects.subStringBefore(UFHTConstants.WHITE_SPACE + 
                    		                                                  UFHTConstants.BRACKET_OPEN)
                    		                          ) +
                    		                          ' To do so, please click' +
                    		                          UFHTConstants.WHITE_SPACE +
                    		                          '<a href='+ objectCreateNewRecordUrl +' target=\'_balnk\'>' + 'here' + '</a>' +
                    		                          UFHTConstants.WHITE_SPACE + 
                    		                          System.Label.DeploymentErrorMessage_1;       
                    	} 
                    	else {
                            deploymentErrorMessage += System.Label.DeploymentErrorMessage.replace
                                                      ('<object name>', 
                                                      objects.subStringBefore(UFHTConstants.WHITE_SPACE + 
                                                                              UFHTConstants.BRACKET_OPEN)
                                                      ) +
                                                      runTestFailureMessage.message.replace('UFHT.UFHTExceptions.DynamicTestClassCreationFailException: ', 
                                                                                            UFHTConstants.WHITE_SPACE
                                                                                            );
                    	}
                        isDeployed = false;
                        //enablePollar = false;
                    }
                    
                 }
            }
            else if(deployResult != null && deployResult.details != null && deployResult.details.runTestResult != null && 
                    deployResult.details.runTestResult.codeCoverageWarnings != null) {
                 for(MetadataService.CodeCoverageWarning CodeCoveragMessage : deployResult.details.runTestResult.codeCoverageWarnings) {
                    if(CodeCoveragMessage.message != null) {
                        deploymentErrorMessage += CodeCoveragMessage.message;
                        isDeployed = false;
                        //enablePollar = false;
                    }
                    
                 }
            }
            else {
                isDeployed = true;
                //enablePollar = false;
                deploymentErrorMessage = UFHTConstants.DEPLOYMENT_SUCCESS_MSG;
            }
        }
        else { 
             isDeployed = false;
             if(progressCounter < 90)
                progressCounter = progressCounter + 20 > 90 ? progressCounter :  progressCounter + 20;
        }
        if(String.isNotBlank(deploymentErrorMessage) && !enablePollar) {
        	
            list<Ultra_Track_Container__c> containerList = [SELECT Id, 
                                                                   Trigger_Status__c, 
                                                                   Trigger_Deploy_Error__c, 
                                                                   Is_Tracking_Enabled__c,
                                                                   AsynResult_Id__c
                                                            FROM Ultra_Track_Container__c
                                                            WHERE Object_Name__c = :objects.substringAfterLast(UFHTConstants.BRACKET_OPEN).remove(UFHTConstants.BRACKET_CLOSE)
                                                            ];                                               
            if(!containerList.isEmpty() && containerList[0] != null) {

                if(isDeployed) {
                  containerList[0].Trigger_Status__c = UFHTConstants.DEPLOYED_KEYWORD;
                  containerList[0].Is_Tracking_Enabled__c = true;
                  UltraTrackUtility.displayMessage(
                                ApexPages.severity.Confirm, UFHTConstants.WHITE_SPACE
                                + System.Label.Ultra_Track_Container_Save_Message1
                                + UFHTConstants.WHITE_SPACE + objects.subStringBefore(UFHTConstants.WHITE_SPACE + UFHTConstants.BRACKET_OPEN)
                                + UFHTConstants.WHITE_SPACE + System.Label.Ultra_Track_Container_Save_Message2 );
                }
                else {
                   containerList[0].Trigger_Status__c = UFHTConstants.NOT_DEPLOYED_KEYWORD;
                   containerList[0].Is_Tracking_Enabled__c = false;
                   UltraTrackUtility.displayMessage(ApexPages.Severity.ERROR, deploymentErrorMessage);
                }
                containerList[0].Trigger_Deploy_Error__c = deploymentErrorMessage;
                //containerList[0].AsynResult_Id__c = '';
                Database.update(containerList[0], false);
            }
        
        }
    }
}