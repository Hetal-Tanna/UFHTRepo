/**
  * @Class Name: PostInstallUtil
  * @Description: This class creates the custom setting data after installing the package.
  * ======================================================================================================
  *         Version   | Date        | Author             | Comments
  * ------------------------------------------------------------------------------------------------------
  *         1.0       | 16/01/2017  | Eternus Solutions  | 1. Created the class to create the custom setting
  *                                                           data after installing the package.
  * =======================================================================================================
  **/

global with sharing class PostInstallUtil implements InstallHandler {

    /**
      * @Author: Eternus Solutions
      * @Description: Override interface method to call the methods for creating data of custom
      *                settings "Confugurations__c", "Number_Of_Columns__c",
      *                "Number_Of_Fields_Per_Column__c", "Number_Of_Records_Per_Page__c",
      *                "View_Field_History_Sharing_Setting__c", "Sort_Fields__c",
      *                "Standard_Objects__c", "View_Field_History_Date_Filters__c".
      * @Param: Current package installation context.
      * @Return: NA
      * @Date: 25/04/2016
      **/
    global void onInstall(InstallContext context) {
        if(context == null) {
            return;
        }
        if(context.isUpgrade() && context.previousVersion() != null) {
            Map<String, UFHT__View_Field_History_Date_Filters__c> dateFiltermap = UFHT__View_Field_History_Date_Filters__c.getAll();
            
            List<UFHT__View_Field_History_Date_Filters__c> dateFilterlist = new  List<UFHT__View_Field_History_Date_Filters__c>();
            for(String datefilterinstance: dateFiltermap.keySet()) {
                dateFilterlist.add(dateFiltermap.get(datefilterinstance));  
            }
            if(!dateFilterlist.isEmpty()) {
                if(Schema.sObjectType.UFHT__View_Field_History_Date_Filters__c.isDeletable()) {
                delete dateFilterlist;
                }
            }
            doinsertUpdateMethods();
            
        } else {
            
            createViewFieldHistoryForSharingCSData();
            createSortFieldsByCSData();
            createStandardObjectsCSData( new map<String, String> {
                UFHTConstants.ACCOUNT_STRING => UFHTConstants.DEFAULT_ACCOUNT_ACCESS,
                UFHTConstants.CAMPAIGN_STRING => UFHTConstants.DEFAULT_CAMPAIGN_ACCESS,
                UFHTConstants.CASE_STRING => UFHTConstants.DEFAULT_CASE_ACCESS,
                UFHTConstants.CONTACT_STRING => UFHTConstants.DEFAULT_CONTACT_ACCESS,
                UFHTConstants.LEAD_STRING => UFHTConstants.DEFAULT_LEAD_ACCESS,
                UFHTConstants.OPPORTUNITY_STRING => UFHTConstants.DEFAULT_OPPORTUNITY_ACCESS,
                UFHTConstants.PRICEBOOK_STRING => UFHTConstants.DEFAULT_PRICEBOOK_ACCESS
            });
            createEncryptedFieldMaskCSData();
            doinsertUpdateMethods();
            
        }
    }     
           
    public void doinsertUpdateMethods() {
        createConfigurationCSData();
        createViewFieldHistoryDateFiltersCSData();
        createRestrictedObjectForFieldTrackingCSData(new list<String> {
            UFHTConstants.RESTRICTED_OBJECT_1,
            UFHTConstants.RESTRICTED_OBJECT_2,
            UFHTConstants.RESTRICTED_OBJECT_3,
            UFHTConstants.RESTRICTED_OBJECT_4,
            UFHTConstants.RESTRICTED_OBJECT_5,
            UFHTConstants.RESTRICTED_OBJECT_6
        });
        
        createObjectForWhichCreateRecordNotWork(new list<String> {
            UFHTConstants.RESTRICTED_OBJECT_1,
            UFHTConstants.RESTRICTED_OBJECT_2,
            UFHTConstants.RESTRICTED_OBJECT_3,
            UFHTConstants.RESTRICTED_OBJECT_4,
            UFHTConstants.RESTRICTED_OBJECT_5,
            UFHTConstants.RESTRICTED_OBJECT_6,
            UFHTConstants.CREATE_RECORD_NOT_SUPPORTED_OBJECT_1,
            UFHTConstants.CREATE_RECORD_NOT_SUPPORTED_OBJECT_2,
            UFHTConstants.CREATE_RECORD_NOT_SUPPORTED_OBJECT_3,
            UFHTConstants.CREATE_RECORD_NOT_SUPPORTED_OBJECT_4,
            UFHTConstants.CREATE_RECORD_NOT_SUPPORTED_OBJECT_5,
            UFHTConstants.CREATE_RECORD_NOT_SUPPORTED_OBJECT_6,
            UFHTConstants.CREATE_RECORD_NOT_SUPPORTED_OBJECT_7,
            UFHTConstants.CREATE_RECORD_NOT_SUPPORTED_OBJECT_8,
            UFHTConstants.CREATE_RECORD_NOT_SUPPORTED_OBJECT_9,
            UFHTConstants.CREATE_RECORD_NOT_SUPPORTED_OBJECT_10,
            UFHTConstants.CREATE_RECORD_NOT_SUPPORTED_OBJECT_11,
            UFHTConstants.CREATE_RECORD_NOT_SUPPORTED_OBJECT_12,
            UFHTConstants.CREATE_RECORD_NOT_SUPPORTED_OBJECT_13,
            UFHTConstants.CREATE_RECORD_NOT_SUPPORTED_OBJECT_14,
            UFHTConstants.CREATE_RECORD_NOT_SUPPORTED_OBJECT_15,
            UFHTConstants.CREATE_RECORD_NOT_SUPPORTED_OBJECT_16,
            UFHTConstants.CREATE_RECORD_NOT_SUPPORTED_OBJECT_17,
            UFHTConstants.CREATE_RECORD_NOT_SUPPORTED_OBJECT_18,
            UFHTConstants.CREATE_RECORD_NOT_SUPPORTED_OBJECT_19,
            UFHTConstants.CREATE_RECORD_NOT_SUPPORTED_OBJECT_20
        });
       
        createObjectForWhichOWDIsNeeded(new list<String> {
            UFHTConstants.ACCOUNT_STRING, 
            UFHTConstants.CAMPAIGN_STRING,
            UFHTConstants.CASE_STRING,
            UFHTConstants.CONTACT_STRING,
            UFHTConstants.LEAD_STRING,
            UFHTConstants.OPPORTUNITY_STRING,
            UFHTConstants.OBJECT_HAVING_OWD1,
            UFHTConstants.OBJECT_HAVING_OWD2,
            UFHTConstants.OBJECT_HAVING_OWD3,
            UFHTConstants.OBJECT_HAVING_OWD4,
            UFHTConstants.OBJECT_HAVING_OWD5,
            UFHTConstants.OBJECT_HAVING_OWD6,
            UFHTConstants.OBJECT_HAVING_OWD7,
            UFHTConstants.OBJECT_HAVING_OWD8,
            UFHTConstants.OBJECT_HAVING_OWD9,
            UFHTConstants.OBJECT_HAVING_OWD10,
            UFHTConstants.OBJECT_HAVING_OWD11,
            UFHTConstants.OBJECT_HAVING_OWD12
        });
        
        updateContainerObject();
         
        LMSConfigManager.createEndpoint();
        
        if (!Test.isRunningTest() && UltraTrackUtility.getCanSchedule()) {
            LMSConfigManager.kickoffLmsScheduler();
        }
        
        UltraTrackUtility.validateLicenseFuture();
    }
    

    /**
      * @Author: Eternus Solutions
      * @Description: Method to create data of custom setting "Configuration__c".
      * @Param: NA
      * @Return: NA
      * @Date: 25/04/2016
      **/
    public void createConfigurationCSData() {
        
        if(UltraTrackUtility.isAllowDMLForCustomSetting('UFHT__Configuration__c','isInsert')) {
            if(UltraTrackUtility.isAllowDMLForCustomSetting('UFHT__Configuration__c','isAccessible')) {
                    if(Configuration__c.getInstance(System.Label.ConfigureColsAndFieldsCustomSettingRecordName) == null) {  
                        insert new Configuration__c(
                        Name = System.Label.ConfigureColsAndFieldsCustomSettingRecordName,
                        SalesforceBaseURL__c = URL.getSalesforceBaseUrl().getHost());
                    }
            }
        }
    }

   
    /**
      * @Author: Eternus Solutions
      * @Description: Method to create data of custom setting "View_Field_History_Sharing_Setting__c".
      * @Param: NA
      * @Return: NA
      * @Date: 25/04/2016
      **/
    public void createViewFieldHistoryForSharingCSData() {

        list<Profile> profileList = [SELECT Id
                                       FROM Profile
                                      WHERE Name = : UFHTConstants.PROFILE_SYS_ADMIN
                                      LIMIT 1];
        if(!profileList.isEmpty()) {

            try{
                if(UltraTrackUtility.isAllowDMLForCustomSetting('UFHT__View_Field_History_Sharing_Setting__c','isInsert')) {
                    insert new View_Field_History_Sharing_Setting__c(View_All_Data__c = true,
                                                                     SetupOwnerId = profileList[0].ID);
                }
            }catch(Exception e){
                UltraTrackUtility.displayMessage(ApexPages.Severity.ERROR, System.Label.GenericError);
            }
        }
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Method to create data of custom setting "Sort_Fields__c".
      * @Param: NA
      * @Return: NA
      * @Date: 25/04/2016
      **/
    public void createSortFieldsByCSData() {

        if(UltraTrackUtility.isAllowDMLForCustomSetting('UFHT__Sort_Fields__c','isInsert')) {
            insert new list<Sort_Fields__c>{
                new Sort_Fields__c(name = UFHTConstants.ASCENDING),
                new Sort_Fields__c(name = UFHTConstants.DESCENDING)
            };
        }
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Method to create data of custom setting "Standard_Objects__c".
      * @Param: map of object name and default access value.
      * @Return: NA
      * @Date: 25/04/2016
      **/
    public void createStandardObjectsCSData(map<String, String> objectNameVsDefaultAccessMap) {

        if(objectNameVsDefaultAccessMap == null || objectNameVsDefaultAccessMap.isEmpty()) {
            return;
        }

        list<Standard_Objects__c> insertStandardObjectCSList = new list<Standard_Objects__c>();
        if(UltraTrackUtility.isAllowDMLForCustomSetting('UFHT__Standard_Objects__c','isInsert')) {
            for(String value : objectNameVsDefaultAccessMap.keySet()) {
                insertStandardObjectCSList.add(new Standard_Objects__c(
                    Name = value,
                    Organization_Field_Name__c = objectNameVsDefaultAccessMap.get(value)
                ));
            }
        
            insert insertStandardObjectCSList;
        }
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Method to create data of custom setting "View_Field_History_Date_Filters__c".
      * @Param: NA
      * @Return: NA
      * @Date: 25/04/2016
      **/
    public void createViewFieldHistoryDateFiltersCSData() {

        list<View_Field_History_Date_Filters__c> dateFiltersToInsertList = new list<View_Field_History_Date_Filters__c>();

        map<String, String> filterNameVsValueMap = new map<String, String> {
            UFHTConstants.CURRENT_PREVIOUS_MONTH => UFHTConstants.EMPTY_STRING,
            UFHTConstants.CUSTOM => UFHTConstants.EMPTY_STRING,
            UFHTConstants.LAST_MONTH_STRING => UFHTConstants.VALUE_LAST_MONTH,
            UFHTConstants.DATE_FILTER_LAST_N_DAYS => UFHTConstants.EMPTY_STRING,
            UFHTConstants.LAST_WEEK_STRING => UFHTConstants.VALUE_LAST_WEEK,
            UFHTConstants.THIS_MONTH_STRING => UFHTConstants.VALUE_ZERO,
            UFHTConstants.THIS_WEEK_STRING => UFHTConstants.VALUE_ZERO,
            UFHTConstants.TODAY_STRING => UFHTConstants.VALUE_ZERO,
            UFHTConstants.YESTERDAY_STRING => UFHTConstants.VALUE_YESTERDAY,
            UFHTConstants.TODAY_AND_YESTERDAY_STRING => UFHTConstants.VALUE_YESTERDAY,
            UFHTConstants.CURRENT_AND_PREVIOUS_WEEK_STRING => UFHTConstants.VALUE_ZERO
        };

        map<String, String> filterNameVsCategoryMap = new map<String, String> {
            UFHTConstants.CURRENT_PREVIOUS_MONTH => UFHTConstants.CATEGORY_MONTH,
            UFHTConstants.CUSTOM => UFHTConstants.CUSTOM,
            UFHTConstants.LAST_MONTH_STRING => UFHTConstants.CATEGORY_MONTH,
            UFHTConstants.DATE_FILTER_LAST_N_DAYS => UFHTConstants.DAY,
            UFHTConstants.LAST_WEEK_STRING => UFHTConstants.CATEGORY_WEEK,
            UFHTConstants.THIS_MONTH_STRING => UFHTConstants.CATEGORY_MONTH,
            UFHTConstants.THIS_WEEK_STRING => UFHTConstants.CATEGORY_WEEK,
            UFHTConstants.TODAY_STRING => UFHTConstants.DAY,
            UFHTConstants.YESTERDAY_STRING => UFHTConstants.DAY,
            UFHTConstants.TODAY_AND_YESTERDAY_STRING => UFHTConstants.DAY,
            UFHTConstants.CURRENT_AND_PREVIOUS_WEEK_STRING => UFHTConstants.CATEGORY_WEEK
        };

        map<String, Integer> filterNameVsSrNoMap = new map<String, Integer> {
            UFHTConstants.CURRENT_PREVIOUS_MONTH => 9,
            UFHTConstants.CUSTOM => 11,
            UFHTConstants.LAST_MONTH_STRING => 8,
            UFHTConstants.DATE_FILTER_LAST_N_DAYS => 10,
            UFHTConstants.LAST_WEEK_STRING => 5,
            UFHTConstants.THIS_MONTH_STRING => 7,
            UFHTConstants.THIS_WEEK_STRING => 4,
            UFHTConstants.TODAY_STRING => 1,
            UFHTConstants.YESTERDAY_STRING => 2,
            UFHTConstants.TODAY_AND_YESTERDAY_STRING => 3,
            UFHTConstants.CURRENT_AND_PREVIOUS_WEEK_STRING => 6
        };
        if(UltraTrackUtility.isAllowDMLForCustomSetting('UFHT__View_Field_History_Date_Filters__c','isInsert')) {
            for(String filter : filterNameVsValueMap.keySet()) {
    
                dateFiltersToInsertList.add(new View_Field_History_Date_Filters__c(
                    Name = filter,
                    Value__c = filterNameVsValueMap.get(filter),
                    Month_Week_Day_Filter_Category__c = filterNameVsCategoryMap.get(filter),
                    Sr_No__c = filterNameVsSrNoMap.get(filter)
                ));
            }
            insert dateFiltersToInsertList;
        }
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Method to create data of custom setting "UFHT__Encrypted_Field_Mask__c".
      * @Param: NA
      * @Return: NA
      * @Date: 04/07/2016
      **/
    public void createEncryptedFieldMaskCSData() {
        if(UltraTrackUtility.isAllowDMLForCustomSetting('UFHT__Encrypted_Field_Mask__c','isInsert')) {
             if(Schema.sObjectType.UFHT__Encrypted_Field_Mask__c.fields.Name.isCreateable() && 
                Schema.sObjectType.UFHT__Encrypted_Field_Mask__c.fields.UFHT__RegEx__c.isCreateable() ) {
                insert new list<UFHT__Encrypted_Field_Mask__c> {
                    new UFHT__Encrypted_Field_Mask__c(Name = UFHTConstants.ALL, UFHT__RegEx__c = UFHTConstants.REGEX_ASCII),
                    new UFHT__Encrypted_Field_Mask__c(Name = UFHTConstants.MASK_TYPE_CREDIT, UFHT__RegEx__c = UFHTConstants.REGEX_ASCII),
                    new UFHT__Encrypted_Field_Mask__c(Name = UFHTConstants.MASK_TYPE_NINO, UFHT__RegEx__c = UFHTConstants.REGEX_NO_WHITE_SPACE),
                    new UFHT__Encrypted_Field_Mask__c(Name = UFHTConstants.MASK_TYPE_SSN, UFHT__RegEx__c = UFHTConstants.REGEX_ASCII),
                    new UFHT__Encrypted_Field_Mask__c(Name = UFHTConstants.MASK_TYPE_SIN, UFHT__RegEx__c = UFHTConstants.REGEX_ASCII),
                    new UFHT__Encrypted_Field_Mask__c(Name = UFHTConstants.MASK_TYPE_LASTFOUR, UFHT__RegEx__c = UFHTConstants.REGEX_ASCII)
                };
             }
        }
    }
    
    /**
      * @Author: Eternus Solutions
      * @Description: Method to create data of custom setting "UFHT__RestrictedObjectForFieldTracking__c".
      * @Param: recordsPerPageList: list of records per page
      * @Return: NA
      * @Date: 1/12/2016
      **/
    public void createRestrictedObjectForFieldTrackingCSData(list<String> restrictedObjectForFieldTrackingList) {
        if(restrictedObjectForFieldTrackingList != null 
           && UltraTrackUtility.isAllowDMLForCustomSetting('UFHT__RestrictedObjectForFieldTracking__c','isInsert')) {
           
            if(UltraTrackUtility.isAllowDMLForCustomSetting('UFHT__RestrictedObjectForFieldTracking__c','isAccessible')) {
            
                Map<String, UFHT__RestrictedObjectForFieldTracking__c> existRecord =  UFHT__RestrictedObjectForFieldTracking__c.getAll();
                
                list<UFHT__RestrictedObjectForFieldTracking__c> numberOfRecordsList = new list<UFHT__RestrictedObjectForFieldTracking__c>();
                for(String objectName : restrictedObjectForFieldTrackingList) {
                    if(String.isNotBlank(objectName)) {
                        if(Schema.sObjectType.UFHT__RestrictedObjectForFieldTracking__c.fields.Name.isCreateable()) {
                            if(!existRecord.containsKey(objectName)) {
                                numberOfRecordsList.add(new UFHT__RestrictedObjectForFieldTracking__c(Name = objectName));
                            }
                        }
                    }
                }
                if(!numberOfRecordsList.isEmpty()) {
                   insert numberOfRecordsList;
                }
            }
        }
    }
    
    /**
      * @Author: Eternus Solutions
      * @Description: Method to create data of custom setting "UFHT__ObjectNotProvidedToCreateRecord__c".
      * @Param: objectForWhichCreateRecordNotWorList: Object to be not supported
      * @Return: NA
      * @Date: 23/12/2016
      **/
    public void createObjectForWhichCreateRecordNotWork(list<String> objectForWhichCreateRecordNotWorList) {
        if(objectForWhichCreateRecordNotWorList != null 
           && UltraTrackUtility.isAllowDMLForCustomSetting('UFHT__ObjectNotProvidedToCreateRecord__c','isInsert')) {
           
            if(UltraTrackUtility.isAllowDMLForCustomSetting('UFHT__ObjectNotProvidedToCreateRecord__c','isAccessible')) {
                
                Map<String, UFHT__ObjectNotProvidedToCreateRecord__c> existRecord =  UFHT__ObjectNotProvidedToCreateRecord__c.getAll();
                
                list<UFHT__ObjectNotProvidedToCreateRecord__c> numberOfRecordsList = new list<UFHT__ObjectNotProvidedToCreateRecord__c>();
                for(String objectName : objectForWhichCreateRecordNotWorList) {
                    if(String.isNotBlank(objectName)) {
                        if(Schema.sObjectType.UFHT__ObjectNotProvidedToCreateRecord__c.fields.Name.isCreateable()) {
                            if(!existRecord.containsKey(objectName)) {
                                numberOfRecordsList.add(new UFHT__ObjectNotProvidedToCreateRecord__c(Name = objectName));
                            }
                        } 
                    }
                }
                if(!numberOfRecordsList.isEmpty()) {
                   insert numberOfRecordsList;
                }
            }
        }
    }
    
    /** @Author: Eternus Solutions
      * @Description: Method to create data of custom setting "UFHT__Standard_Objects_Having_OWD__c".
      * @Param: ObjectForWhichOWDIsNeededList: Object having OWD.
      * @Return: NA
      * @Date: 30/12/2016
      **/
    public void createObjectForWhichOWDIsNeeded(list<String> ObjectForWhichOWDIsNeededList) {
        if(ObjectForWhichOWDIsNeededList != null 
           && UltraTrackUtility.isAllowDMLForCustomSetting('UFHT__Standard_Objects_Having_OWD__c','isInsert')) {
           
            
            if(UltraTrackUtility.isAllowDMLForCustomSetting('UFHT__Standard_Objects_Having_OWD__c','isAccessible')) {           
                Map<String, UFHT__Standard_Objects_Having_OWD__c> existRecord =  UFHT__Standard_Objects_Having_OWD__c.getAll();
                
                list<UFHT__Standard_Objects_Having_OWD__c> numberOfRecordsList = new list<UFHT__Standard_Objects_Having_OWD__c>();
                for(String objectName : ObjectForWhichOWDIsNeededList) {
                    if(String.isNotBlank(objectName)) {
                        if(Schema.sObjectType.UFHT__Standard_Objects_Having_OWD__c.fields.Name.isCreateable()) {
                            if(!existRecord.containsKey(objectName)) {
                                numberOfRecordsList.add(new UFHT__Standard_Objects_Having_OWD__c(Name = objectName));
                            }
                        }
                    }
                }
                if(!numberOfRecordsList.isEmpty()) {
                   insert numberOfRecordsList;
                }
            }
        }
    }
    
    /** @Author: Eternus Solutions
      * @Description: Method to create data of object "Ultra_Track_Container__c".
      * @Param: 
      * @Return: NA
      * @Date: 16/01/2017
      **/
     public void updateContainerObject() {
        if(UltraTrackUtility.checkObjectAndFieldLevelSecurity('UFHT__Ultra_Track_Container__c', 
                                 new list<String> {'Id','UFHT__Tracked_Fields__c','UFHT__Is_Tracking_Enabled__c'},
                                 'isUpdateable')){
            list<Ultra_Track_Container__c> lstUltraTrackContainer = new list<Ultra_Track_Container__c>();
            list<Ultra_Track_Container__c> lstUpdateSeverityField = new list<Ultra_Track_Container__c>();
            list<String> lstTrackedFields = new list<String>();
            String severityTrackedFields = '';
            String strTrackedFields;
            Boolean result;
            lstUltraTrackContainer = [SELECT Id,
                                        Object_Name__c,
                                        Tracked_Fields__c,
                                        Is_Tracking_Enabled__c,
                                        OWD_for_an_Object__c
                                   FROM Ultra_Track_Container__c
                                   LIMIT 50000];
            if(!lstUltraTrackContainer.isEmpty()) {
                for(Ultra_Track_Container__c objContainer : lstUltraTrackContainer) {
                    if(objContainer.Tracked_Fields__c != '' && objContainer.Tracked_Fields__c != null ) {
                        strTrackedFields = '';
                        strTrackedFields = objContainer.Tracked_Fields__c;
                        result = strTrackedFields.contains(':');
                        if(!result) {
                            lstTrackedFields = strTrackedFields.split(',');
                            severityTrackedFields = '';
                            for(String strTrackField : lstTrackedFields) {
                                severityTrackedFields +=  strTrackField + ':' + 0 +',';
                            }
                            severityTrackedFields = severityTrackedFields.removeEnd(',');
                            if(!String.isBlank(severityTrackedFields)) {
                               objContainer.Tracked_Fields__c = severityTrackedFields;
                               lstUpdateSeverityField.add(objContainer);
                            }
                        }
                    }
                }
                if(!lstUpdateSeverityField.isEmpty()) {
                    update lstUltraTrackContainer;
                }
            }
        }
    }
}