/**
 * @Class Name: PostInstallationClass 
 * @Description: This class creates the custom setting data after installing the package. 
======================================================================================================
        Version   | Date        | Author            | Comments
------------------------------------------------------------------------------------------------------
        1.0       | 25-04-2016  | Eternus Solution   | 1.Created the class to create the custom setting 
                                                        data after installing the package.
        1.1       | 04-07-2016  | Eternus Solution   | 1. Created createEncryptedFieldMaskCSData method.
=======================================================================================================
*/

global with sharing class PostInstallationClass implements InstallHandler{
     /**
       * @Author: Eternus Solutions
       * @description : Override interface method to call the methods for creating data of custom
                        settings "Confugurations__c","Number_Of_Columns__c",
                        "Number_Of_Fields_Per_Column__c","Number_Of_Records_Per_Page__c",
                        "View_Field_History_Sharing_Setting__c","Sort_Fields__c",
                        "Standard_Objects__c","View_Field_History_Date_Filters__c".
       * @Param : Current package installation context.
       * @Return : 
       * @Date: 25-04-2016 
    */
    global void onInstall(InstallContext context) {
        List<String> colValues = new List<String>{'2','3','4','5'};
        List<String> fieldValues = new List<String>{'05','10','15'};
        List<String> recordValues = new List<String>{'25','50','75','100'};
        map<String,String> standardObjectsName = new map<String,String>{'Account'=>'DefaultAccountAccess',
                                                                       'Campaign'=>'DefaultCampaignAccess',
                                                                       'Case'=>'DefaultCaseAccess',
                                                                       'Contact'=>'DefaultContactAccess',
                                                                       'Lead'=>'DefaultLeadAccess',
                                                                       'Opportunity'=>'DefaultOpportunityAccess',
                                                                       'Pricebook'=>'DefaultPricebookAccess'
                                                                       };
        if(context.previousVersion() == null) {
          createConfigurationCSData();
          createNumberOfColumnsCSData(colValues);
          createNumberOFFieldsCSData(fieldValues);
          createNumberOFRecordsCSData(recordValues);
          createViewFieldHistoryForSharingCSData();
          createSortFieldsByCSData();
          createStandardObjectsCSData(standardObjectsName);
          createViewFieldHistoryDateFiltersCSData();
          createEncryptedFieldMaskCSData();
        }
    }
    /**
       * @Author: Eternus Solutions
       * @description : Method to create data of custom setting "Confugurations__c".
       * @Param : 
       * @Return : 
       * @Date: 25-04-2016 
    */
    public void createConfigurationCSData(){
        Configuration__c objConfig = new Configuration__c();
        objConfig.name = system.Label.ConfigureColsAndFieldsCustomSettingRecordName;
        objConfig.Number_Of_Columns__c = 5;
        objConfig.Number_Of_Fields_Per_Column__c = 10;
        objConfig.Number_Of_Records_Per_Page__c = 50;
        objConfig.Sort_Fields_By__c = 'Ascending';
        objConfig.SalesforceBaseURL__c = URL.getSalesforceBaseUrl().getHost();
        insert objConfig;
    }
    /**
       * @Author: Eternus Solutions
       * @description : Method to create data of custom setting "Number_Of_Columns__c".
       * @Param : 
       * @Return : 
       * @Date: 25-04-2016 
    */
    public void createNumberOfColumnsCSData(List<String> values){
        List<Number_Of_Columns__c> lstNumberOfCols = new List<Number_Of_Columns__c>();
        for(String value : values){
            lstNumberOfCols.add(new Number_Of_Columns__c(Name=value));
        }
        insert lstNumberOfCols;
    }
    /**
       * @Author: Eternus Solutions
       * @description : Method to create data of custom setting "Number_Of_Fields_Per_Column__c".
       * @Param : 
       * @Return : 
       * @Date: 25-04-2016 
    */
    public void createNumberOFFieldsCSData(List<String> values){
        List<Number_Of_Fields_Per_Column__c> lstNumberOfFieldsPerCols = new List<Number_Of_Fields_Per_Column__c>();
        for(String value : values){
            lstNumberOfFieldsPerCols.add(new Number_Of_Fields_Per_Column__c(Name=value));
        }
        insert lstNumberOfFieldsPerCols; 
    }
    /**
       * @Author: Eternus Solutions
       * @description : Method to create data of custom setting "Number_Of_Records_Per_Page__c".
       * @Param : 
       * @Return : 
       * @Date: 25-04-2016 
    */
    public void createNumberOFRecordsCSData(List<String> values){
        List<Number_Of_Records_Per_Page__c> lstNumberOfRecords = new List<Number_Of_Records_Per_Page__c>();
        for(String value : values){
            lstNumberOfRecords.add(new Number_Of_Records_Per_Page__c(Name=value));
        }
        insert lstNumberOfRecords;
    }
    /**
       * @Author: Eternus Solutions
       * @description : Method to create data of custom setting "View_Field_History_Sharing_Setting__c".
       * @Param : 
       * @Return : 
       * @Date: 25-04-2016 
    */
    public void createViewFieldHistoryForSharingCSData(){
        List<Profile> lstProf = [SELECT ID FROM Profile WHERE name='System Administrator' limit 1];
        if(!lstProf.isEmpty()){
            View_Field_History_Sharing_Setting__c objCS = new View_Field_History_Sharing_Setting__c();
            objCS.View_All_Data__c = true;
            objCS.SetupOwnerId = lstProf[0].ID;
            insert objCS;
        }
    }
    /**
       * @Author: Eternus Solutions
       * @description : Method to create data of custom setting "Sort_Fields__c".
       * @Param : 
       * @Return : 
       * @Date: 25-04-2016 
    */
    public void createSortFieldsByCSData(){
        list<Sort_Fields__c> lstSortByOptions = new list<Sort_Fields__c>();
        lstSortByOptions.add(new Sort_Fields__c(name='Ascending'));
        lstSortByOptions.add(new Sort_Fields__c(name='Descending'));
        insert lstSortByOptions;
    }
    /**
       * @Author: Eternus Solutions
       * @description : Method to create data of custom setting "Standard_Objects__c".
       * @Param : map of object name and default access value.
       * @Return : 
       * @Date: 25-04-2016 
    */
    public void createStandardObjectsCSData(map<String,String> standardObjectsNameValues){
        list<Standard_Objects__c> lstToInsertStandardObjectCS = new list<Standard_Objects__c>();
        for(String strValue : standardObjectsNameValues.keySet()){
            lstToInsertStandardObjectCS.add(new Standard_Objects__c(name=strValue,
                                                                Organization_Field_Name__c=standardObjectsNameValues.get(strValue)
                                                               )
                                        );
        }
        insert lstToInsertStandardObjectCS;
    }
    /**
       * @Author: Eternus Solutions
       * @description : Method to create data of custom setting "View_Field_History_Date_Filters__c".
       * @Param : 
       * @Return : 
       * @Date: 25-04-2016 
    */
    public void createViewFieldHistoryDateFiltersCSData(){
        list<View_Field_History_Date_Filters__c> lstToInsertDateFiltersCSData = new list<View_Field_History_Date_Filters__c>();
        map<String,String> mapfilterNameVSValue = new map<String,String>{'Current and Previous Month'=>'','Custom'=>'',
                                                                         'Last Month'=>'-30','Last N Days'=>'','Last Week'=>'-7',
                                                                         'This Month'=>'0','This Week'=>'0',
                                                                         'Today'=>'0','Yesterday'=>'-1'
                                                                        };
        map<String,String> mapfilterNameVSCategory = new map<String,String>{'Current and Previous Month'=>'Month','Custom'=>'Custom',
                                                                            'Last Month'=>'Month','Last N Days'=>'Day','Last Week'=>'Week',
                                                                            'This Month'=>'Month','This Week'=>'Week',
                                                                            'Today'=>'Day','Yesterday'=>'Day'
                                                                           };
        map<String,Integer> mapfilterNameVSSrNo = new map<String,Integer>{'Current and Previous Month'=>7,'Custom'=>9,
                                                                          'Last Month'=>6,'Last N Days'=>8,'Last Week'=>4,
                                                                          'This Month'=>5,'This Week'=>3,
                                                                          'Today'=>1,'Yesterday'=>2
                                                                         };
        for(String strFilter : mapfilterNameVSValue.keySet()){
            lstToInsertDateFiltersCSData.add(New View_Field_History_Date_Filters__c(name = strFilter, 
                                                Value__c = mapfilterNameVSValue.get(strFilter),
                                                Month_Week_Day_Filter_Category__c = mapfilterNameVSCategory.get(strFilter),
                                                Sr_No__c = mapfilterNameVSSrNo.get(strFilter)
                                            )
                                            );
        }
        insert lstToInsertDateFiltersCSData;
    }

    /**
       * @Author: Eternus Solutions
       * @description : Method to create data of custom setting "UFHT__Encrypted_Field_Mask__c".
       * @Param : 
       * @Return : 
       * @Date: 04-07-2016 
    */
    public void createEncryptedFieldMaskCSData(){
        insert new List<UFHT__Encrypted_Field_Mask__c> {
            new UFHT__Encrypted_Field_Mask__c(name = 'all', UFHT__RegEx__c = '\\p{ASCII}'),
            new UFHT__Encrypted_Field_Mask__c(name = 'creditCard', UFHT__RegEx__c = '[0-9]'),
            new UFHT__Encrypted_Field_Mask__c(name = 'nino', UFHT__RegEx__c = '[^\\ ]'),
            new UFHT__Encrypted_Field_Mask__c(name = 'ssn', UFHT__RegEx__c = '[0-9]'),
            new UFHT__Encrypted_Field_Mask__c(name = 'sin', UFHT__RegEx__c = '[0-9]'),
            new UFHT__Encrypted_Field_Mask__c(name = 'lastFour', UFHT__RegEx__c = '\\p{ASCII}')
        };
    }
}