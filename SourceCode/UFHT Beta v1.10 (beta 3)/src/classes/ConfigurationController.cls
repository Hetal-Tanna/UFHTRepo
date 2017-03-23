/**
 * @Class Name: ConfigurationController
 * @Description: This class is used to get and set configuration setting data from custom setting.
 *               Custom setting data configures display layout of visualforce page "Ultra_Setup".
 * ===================================================================================================
 *   Version   | Date        | Author             | Comments
 * ---------------------------------------------------------------------------------------------------
 *   1.0       | 15/11/2015  | Eternus Solutions  | 1. Created the class for above functionality.
 * ===================================================================================================
**/
public with sharing class ConfigurationController {

    // Variable to display fields in how many columns
    public Integer numberOfColumns                                { get; set; }
    // List to hold the values of picklist "Number oF Columns"
    public list<SelectOption> numberOfColValuesList               { get; set; }
    // Variable to display fields per column
    public Integer numberOfFieldsPerColumns                       { get; set; }
    // List to hold the values of picklist "Number Of Fields Per Columns"
    public list<SelectOption> numberOfFieldsPerColValuesList      { get; set; }
    // Variable to hold count of History Records to display
    public Integer numberOfHistoryRecords                         { get; set; }
    // List to hold the values of picklist "Number of history records to display"
    public list<SelectOption> numberOfHistoryRecordsToDisplayList { get; set; }
    // Variable to hold the fields sorting value
    public String sortFieldsBy                                    { get; set; }
    // List to hold the values of picklist "Sort Fields"
    public list<SelectOption> sortFieldsByValuesList              { get; set; }
    // String to hold salesforce base url to create remote site setting
    // It is used in page "CreateRemoteSiteSetting"
    public String baseURL                                         { get; set; }
    // Boolean variable to check permission to create remote site setting.
    public Boolean isUserHasPermissionToCreateRemoteSiteSetting {get; set;}

    /**
     * @Author: Eternus Solutions
     * @Description: Constructor to set the values of picklist "Number of Columns", "Number of Fields per column",
     *               "Number of history records to be display" and "Sort Fields Alphabetically".
     * @Param:
     * @Return:
     * @Date: 29/02/2016
     **/
    public ConfigurationController() {

        baseURL = UFHTConstants.EMPTY_STRING;
        isUserHasPermissionToCreateRemoteSiteSetting = false;
        
        if(UltraTrackUtility.isAllowDMLForCustomSetting('UFHT__Number_Of_Columns__c','isAccessible')){
            // Call method to set values of picklist "NumberOFColumns"
            numberOfColValuesList = createOptionsFromCustomSetting(Number_Of_Columns__c.getAll().values(), false);
        }
        if(UltraTrackUtility.isAllowDMLForCustomSetting('UFHT__Number_Of_Fields_Per_Column__c','isAccessible')){
            // Call method to set values of picklist "Number of fields per column"
            numberOfFieldsPerColValuesList = createOptionsFromCustomSetting(Number_Of_Fields_Per_Column__c.getAll().values(), false);
        }
        if(UltraTrackUtility.isAllowDMLForCustomSetting('UFHT__Number_Of_Records_Per_Page__c','isAccessible')){
            // Call method to set values of picklist "Number of fields per column"
            numberOfHistoryRecordsToDisplayList = createOptionsFromCustomSetting(Number_Of_Records_Per_Page__c.getAll().values(), true);
        }
        if(UltraTrackUtility.isAllowDMLForCustomSetting('UFHT__Sort_Fields__c','isAccessible')){
            // Call method to set values of picklist "Sort Fields Alphabetically"
            sortFieldsByValuesList = createOptionsFromCustomSetting(Sort_Fields__c.getAll().values(), false);
        }
        if(UltraTrackUtility.isAllowDMLForCustomSetting('UFHT__Configuration__c','isAccessible')){
             Configuration__c configObj = Configuration__c.getInstance(System.Label.ConfigureColsAndFieldsCustomSettingRecordName);
             if(configObj != null && String.isNotBlank(configObj.SalesforceBaseURL__c)) {
                baseURL = configObj.SalesforceBaseURL__c;
             }
             else {
                baseURL = URL.getSalesforceBaseUrl().getHost();
             }
        }
        
        
    }

    /**
     * @Author: Eternus Solutions
     * @Description: Method to create/update the display configuration setting into custom setting.
     *               This Method checks configuration record is present or not in custom setting
     *               if present then update record else it will create. Configuration__c custom setting
     *               will exists single record only.
     * @Param:
     * @Return:
     * @Date: 29/02/2016
     **/
    public void saveConfiguration() {
        
        if(UltraTrackUtility.isAllowDMLForCustomSetting('UFHT__Configuration__c','isAccessible') &&
           UltraTrackUtility.isAllowDMLForCustomSetting('UFHT__Configuration__c','isDeletable') &&
           UltraTrackUtility.isAllowDMLForCustomSetting('UFHT__Configuration__c','isInsert') && 
           UltraTrackUtility.isAllowDMLForCustomSetting('UFHT__Configuration__c','isUpdate') ){
            // Map to hold Configuration__c custom setting records
            map<String, Configuration__c> configMap = Configuration__c.getAll();
    
            numberOfColumns = parseStringToInteger(numberOfColumns, System.Label.DefaultNumberOfColumnValue);
    
            numberOfFieldsPerColumns =
                parseStringToInteger(numberOfFieldsPerColumns, System.Label.DefaultNumberOfFieldsPerColumnValue);
    
            numberOfHistoryRecords =
                parseStringToInteger(numberOfHistoryRecords, System.Label.DefaultNumberOfHistoryRecordsToDisplay);
    
            Configuration__c objConfiguration;
            // If Configuration custom setting is not present then create new custom setting
            if(!configMap.containsKey(System.Label.ConfigureColsAndFieldsCustomSettingRecordName)) {
                // Delete configuration settings other then default
                if(!configMap.values().isEmpty()) {
                    try {
                         delete configMap.values();
                    }
                    catch(DMLException e) {
                        //Unwanted records deleted first and then new record is inserted hence displayed save error message.
                        UltraTrackUtility.displayMessage(ApexPages.Severity.ERROR, System.Label.Settings_Save_Error);
                    }
                }
                objConfiguration = new Configuration__c(Name = System.Label.ConfigureColsAndFieldsCustomSettingRecordName);
            }
            else {
                objConfiguration = configMap.get(System.Label.ConfigureColsAndFieldsCustomSettingRecordName);
            }
            objConfiguration.Number_Of_Columns__c = numberOfColumns;
            objConfiguration.Number_Of_Fields_Per_Column__c = numberOfFieldsPerColumns;
            objConfiguration.Number_Of_Records_Per_Page__c = numberOfHistoryRecords;
            createOrUpdateConfiguration(objConfiguration, sortFieldsBy);
        }else{
            UltraTrackUtility.displayMessage(ApexPages.Severity.ERROR, System.Label.GenericError);
        }
        
    }

    /**
     * @Author: Eternus Solutions
     * @Description: Method takes Configuration instance and field values as parameter and upserts the instance.
     * @Param: 1. pConfigurationInstance: Instance to update or insert. Has Name value initialized.
     *         2. pSortOrder: Value for Sort_Fields_By__c
     * @Return: None.
     * @Date: 18/07/2016
     **/
    @TestVisible
    private void createOrUpdateConfiguration( Configuration__c pConfigurationInstance, String pSortOrder) {
        
        if(UltraTrackUtility.isAllowDMLForCustomSetting('UFHT__Configuration__c','isInsert') && 
           UltraTrackUtility.isAllowDMLForCustomSetting('UFHT__Configuration__c','isUpdate') ){
         
        pConfigurationInstance.Sort_Fields_By__c = (String.isNotBlank(pSortOrder))
                                                 ? pSortOrder
                                                 : System.Label.DefaultFieldSortingOption;

        pConfigurationInstance.SalesforceBaseURL__c = (String.isBlank(pConfigurationInstance.SalesforceBaseURL__c))
                                                    ? URL.getSalesforceBaseUrl().getHost()
                                                    : pConfigurationInstance.SalesforceBaseURL__c;

        try {
           
                upsert pConfigurationInstance;
        }
        catch(DmlException e) {
            UltraTrackUtility.displayMessage(ApexPages.Severity.WARNING, System.Label.Settings_Save_Error);
        }
     }  
    }

    /**
     * @Author: Eternus Solutions
     * @Description: Method takes String as input and converts it to Integer. If there's an exception, returns 0;
     * @Param: pIntegerToStore: Integer to hold parsed value, pStringToParse: String to parse
     * @Return: Returns parsed Integer value
     * @Date: 18/07/2016
     **/
    @TestVisible
    private Integer parseStringToInteger(Integer pIntegerToStore, String pStringToParse) {

        try {
            pIntegerToStore = ((pIntegerToStore == 0 || pIntegerToStore == null) && String.isNotBlank(pStringToParse))
                            ? Integer.valueOf(pStringToParse)
                            : pIntegerToStore;
        }
        catch(TypeException e) {
            UltraTrackUtility.displayMessage(ApexPages.Severity.ERROR, System.Label.Invalid_Number);
        }

        return pIntegerToStore;
    }

    /**
     * @Author: Eternus Solutions
     * @Description: Method takes custom setting records as input and creates picklist values from them.
     * @Param: pCustomSettingData: sObject list to hold custom setting data, pIsIntegerData: Identifier for Integer data
     * @Return: Returns list of SelectOption.
     * @Date: 18/07/2016
     **/
    @TestVisible
    private list<SelectOption> createOptionsFromCustomSetting(list<sObject> pCustomSettingDataList, Boolean pIsIntegerData) {

        // List of SelectOption to hold and return picklist values
        list<SelectOption> picklistOptionsList = new list<SelectOption>{new SelectOption(
                                                    UFHTConstants.EMPTY_STRING,
                                                    System.Label.PicklistDefaultLabel
                                                   )};

        if(pCustomSettingDataList == null) {
            return picklistOptionsList;
        }

        list<Integer> integerDataList = new list<Integer>();
        pIsIntegerData = pIsIntegerData == null ? false : pIsIntegerData;

        if(pIsIntegerData) {
            for(sObject customSettingRecord : pCustomSettingDataList) {
                try {
                    integerDataList.add(Integer.valueOf(customSettingRecord.get(UFHTConstants.SOBJECT_NAME)));
                }
                catch(TypeException e) {
                    UltraTrackUtility.displayMessage(ApexPages.Severity.ERROR, System.Label.Invalid_Number);
                }
            }

            if(!integerDataList.isEmpty()) {

                integerDataList.sort();

                for(Integer integerData : integerDataList) {
                    picklistOptionsList.add(new selectOption(String.valueOf(integerData), String.valueOf(integerData)));
                }
            }
        }

        else if(!pCustomSettingDataList.isEmpty()) {

            pCustomSettingDataList.sort();

            for(sObject customSettingRecord : pCustomSettingDataList) {

                picklistOptionsList.add(new selectOption(
                    String.valueOf(customSettingRecord.get(UFHTConstants.SOBJECT_NAME)),
                    String.valueOf(customSettingRecord.get(UFHTConstants.SOBJECT_NAME))
                ));
            }
        }
        return picklistOptionsList;
    }
    
   /**
     * @Author: Eternus Solutions
     * @Description: Method to check if logged user has permission to create remote site settings.
     * @Param: NA
     * @Return: NA
     * @Date: 21/11/2016
     **/
    public pageReference verifyUserHasPermissionToCreateRemoteSiteSetting() {
    
        list<Profile> profileList = [SELECT Id, 
                                            PermissionsViewSetup,
                                            PermissionsModifyAllData
                                     FROM Profile
                                     WHERE Id =: UserInfo.getProfileId()  
                                    ];
        if(!profileList.isEmpty() && profileList[0] != null) {
            if(profileList[0].PermissionsViewSetup && profileList[0].PermissionsModifyAllData) {

                 isUserHasPermissionToCreateRemoteSiteSetting = true;
            }
            else {
                isUserHasPermissionToCreateRemoteSiteSetting = false;
            }
        }
        return null;
    }
    
    
}