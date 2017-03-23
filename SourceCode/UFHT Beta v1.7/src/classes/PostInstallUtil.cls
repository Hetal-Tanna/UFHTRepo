/**
  * @Class Name: PostInstallUtil
  * @Description: This class creates the custom setting data after installing the package.
  * ======================================================================================================
  *         Version   | Date        | Author             | Comments
  * ------------------------------------------------------------------------------------------------------
  *         1.0       | 25/04/2016  | Eternus Solutions  | 1. Created the class to create the custom setting
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

        if(context != null && context.previousVersion() == null) {
            createConfigurationCSData();
            createNumberOfColumnsCSData(new list<String> {
                UFHTConstants.NUMERIC_2,
                UFHTConstants.NUMERIC_3,
                UFHTConstants.NUMERIC_4,
                UFHTConstants.NUMERIC_5
            });
            createNumberOfFieldsCSData(new list<String> {
                UFHTConstants.NUMERIC_05,
                UFHTConstants.NUMERIC_10,
                UFHTConstants.NUMERIC_15
            });
            createNumberOfRecordsCSData(new list<String> {
                UFHTConstants.NUMERIC_25,
                UFHTConstants.NUMERIC_50,
                UFHTConstants.NUMERIC_75,
                UFHTConstants.NUMERIC_100
            });
            createRestrictedObjectForFieldTrackingCSData(new list<String> {
                UFHTConstants.RESTRICTED_OBJECT_1,
                UFHTConstants.RESTRICTED_OBJECT_2,
                UFHTConstants.RESTRICTED_OBJECT_3,
                UFHTConstants.RESTRICTED_OBJECT_4
            });
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
            createViewFieldHistoryDateFiltersCSData();
            createEncryptedFieldMaskCSData();
        }
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
            insert new Configuration__c(
            Name = System.Label.ConfigureColsAndFieldsCustomSettingRecordName,
            Number_Of_Columns__c = 5,
            Number_Of_Fields_Per_Column__c = 10,
            Number_Of_Records_Per_Page__c = 50,
            Sort_Fields_By__c = UFHTConstants.ASCENDING,
            SalesforceBaseURL__c = URL.getSalesforceBaseUrl().getHost());
        }
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Method to create data of custom setting "Number_Of_Columns__c".
      * @Param: columnCountList: list of column count
      * @Return: NA
      * @Date: 25/04/2016
      **/
    public void createNumberOfColumnsCSData(list<String> columnCountList) {

        if(columnCountList != null
           && UltraTrackUtility.isAllowDMLForCustomSetting('UFHT__Number_Of_Columns__c','isInsert')) {
            list<Number_Of_Columns__c> numberOfColsList = new list<Number_Of_Columns__c>();
            for(String columnCount : columnCountList) {
                if(String.isNotBlank(columnCount)) {
                    numberOfColsList.add(new Number_Of_Columns__c(Name = columnCount));
                }
            }
            if(!numberOfColsList.isEmpty()) {
                insert numberOfColsList;
            }
        }
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Method to create data of custom setting "Number_Of_Fields_Per_Column__c".
      * @Param: fieldsPerColumnList: list of fields per column
      * @Return: NA
      * @Date: 25/04/2016
      **/
    public void createNumberOfFieldsCSData(list<String> fieldsPerColumnList) {
        if(fieldsPerColumnList != null 
           && UltraTrackUtility.isAllowDMLForCustomSetting('UFHT__Number_Of_Fields_Per_Column__c','isInsert')) {
            list<Number_Of_Fields_Per_Column__c> numberOfFieldsPerColsList = new list<Number_Of_Fields_Per_Column__c>();
            for(String fieldCount : fieldsPerColumnList) {
                if(String.isNotBlank(fieldCount)) {
                    numberOfFieldsPerColsList.add(new Number_Of_Fields_Per_Column__c(Name = fieldCount));
                }
            }
            if(!numberOfFieldsPerColsList.isEmpty()) {
               insert numberOfFieldsPerColsList;
            }
        }
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Method to create data of custom setting "Number_Of_Records_Per_Page__c".
      * @Param: recordsPerPageList: list of records per page
      * @Return: NA
      * @Date: 25/04/2016
      **/
    public void createNumberOfRecordsCSData(list<String> recordsPerPageList) {
        if(recordsPerPageList != null 
           && UltraTrackUtility.isAllowDMLForCustomSetting('UFHT__Number_Of_Records_Per_Page__c','isInsert')) {
            list<Number_Of_Records_Per_Page__c> numberOfRecordsList = new list<Number_Of_Records_Per_Page__c>();
            for(String recordCount : recordsPerPageList) {
                if(String.isNotBlank(recordCount)) {
                    numberOfRecordsList.add(new Number_Of_Records_Per_Page__c(Name = recordCount));
                }
            }
            if(!numberOfRecordsList.isEmpty()) {
               insert numberOfRecordsList;
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
            UFHTConstants.YESTERDAY_STRING => UFHTConstants.VALUE_YESTERDAY
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
            UFHTConstants.YESTERDAY_STRING => UFHTConstants.DAY
        };

        map<String, Integer> filterNameVsSrNoMap = new map<String, Integer> {
            UFHTConstants.CURRENT_PREVIOUS_MONTH => 7,
            UFHTConstants.CUSTOM => 9,
            UFHTConstants.LAST_MONTH_STRING => 6,
            UFHTConstants.DATE_FILTER_LAST_N_DAYS => 8,
            UFHTConstants.LAST_WEEK_STRING => 4,
            UFHTConstants.THIS_MONTH_STRING => 5,
            UFHTConstants.THIS_WEEK_STRING => 3,
            UFHTConstants.TODAY_STRING => 1,
            UFHTConstants.YESTERDAY_STRING => 2
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
            list<UFHT__RestrictedObjectForFieldTracking__c> numberOfRecordsList = new list<UFHT__RestrictedObjectForFieldTracking__c>();
            for(String objectName : restrictedObjectForFieldTrackingList) {
                if(String.isNotBlank(objectName)) {
                    numberOfRecordsList.add(new UFHT__RestrictedObjectForFieldTracking__c(Name = objectName));
                }
            }
            if(!numberOfRecordsList.isEmpty()) {
               insert numberOfRecordsList;
            }
        }
    }
}