/**
 * Class Name: ConfigurationController 
 * @Description: This is Controller of Configuration Visual force page. 
 *   It is update the setting into custom settings for NumberOfColumn 
 *   and NumberOfFieldsPerColumn to display data on setup Page. 
 *==================================================================================================
 *       Version   | Date        | Author             | Comments
 *--------------------------------------------------------------------------------------------------
 *       1.0       | 15-11-2015  | Eternus Solution   | 1.Created the class for above functionality.
 *       1.1       | 22-02-2016  | Eternus Solution   | 1.Code review changes. 
 *       1.2       | 29-02-2016  | Eternus Solution   | 1.store Configuration data into custom setting
 *                                                    |   instead of custom object.
 *       1.3       | 01-03-2016  | Eternus Solution   | 1.added doCancel method. 
 *===================================================================================================
 **/

/**
 * with sharing keyword allows you to specify that the sharing rules for the 
 * current user be taken into account for a class.
 **/
public with sharing class ConfigurationController {

    //To display fields in how many columns 
    public Integer numberOfColumns {get;set;}
    //to display fields per column
    public Integer numberOfFieldsPerColumns {get;set;} 
    //to hold number of History Records to display
    public Integer numberOfHistoryRecords {get;set;}
    //to hold the field sorting value
    public string sortFieldsBy {get;set;}
    //List to hold the values of picklist number of columns
    public list<selectOption> numberOfColValues{get;set;}
    //List to hold the values of picklist number of fields per columns
    public list<selectOption> numberOfFieldsPerColValues{get;set;}
    //List to hold the values of picklist Number of history records to display
    public list<selectOption> numberOfHistoryRecordsToDisplay{get;set;}
    //list to hold the values of picklist sort fields
    public list<selectOption> sortFieldsByValues{get;set;}
    //Utility class object to call methods
    public UltraTrackUtilityClass objUtility {get;set;}
    //String to hold salesforce base url to create remote site setting
    public string strBaseURL {get;set;}

    // Added constant strings to avoid hardcoding.
    private final static String EMPTY_STRING = '';

    /**
     * @Author: Eternus Solutions
     * @description : Constructor to set the values of picklist "Number of Columns" and "Number of Fields per column"
     * @Param :
     * @Return : 
     * @Date:29/02/2016
     **/
    public ConfigurationController(){

        objUtility = new UltraTrackUtilityClass();
        //call method to set values of picklist "NumberOFColumns"
        numberOfColValues = getNumberOfcolumsPicklistValues();
        //call method to set values of pciklist "Number of fields per column"
        numberOfFieldsPerColValues = getNumberOfFieldsPerColumnPicklistValues();
        //Call method to set values of picklist "Number of History Records to display"
        numberOfHistoryRecordsToDisplay = getNumberOfHistoryRecordsToDisplayPicklistValues();
        //call method to set values of picklist "sort fields by"

        sortFieldsByValues = getFiledSortingOptions();
        strBaseURL ='';

        Configuration__c config = Configuration__c.getInstance(system.Label.ConfigureColsAndFieldsCustomSettingRecordName);
        if(config != null){
            strBaseURL = config.SalesforceBaseURL__c;
        }
    }
    
    /**
       * @Author: Eternus Solutions
       * @description : Method to update the configuration setting into custom setting
       * @Param :
       * @Return : 
       * @Date:29/02/2016
    */
    public void saveConfiguration(){
        map<String,Configuration__c> mapConfig = new map<String,Configuration__c>();
        mapConfig = Configuration__c.getAll();
        if(mapConfig.containsKey(system.Label.ConfigureColsAndFieldsCustomSettingRecordName)){
            Configuration__c objCofig = mapConfig.get(system.Label.ConfigureColsAndFieldsCustomSettingRecordName);
            
            objCofig.Number_Of_Columns__c = (numberOfColumns == 0)
                                            ?decimal.valueOf(system.label.DefaultNumberOfColumnValue)
                                            :numberOfColumns;
            objCofig.Number_Of_Fields_Per_Column__c = (numberOfFieldsPerColumns == 0)
                                            ?decimal.valueOf(system.label.DefaultNumberOfFieldsPerColumnValue)
                                            :numberOfFieldsPerColumns;
            objCofig.Number_Of_Records_Per_Page__c = (numberOfHistoryRecords == 0)
                                            ?decimal.valueOf(system.label.DefaultNumberOfHistoryRecordsToDisplay)
                                            :numberOfHistoryRecords;
            objCofig.Sort_Fields_By__c = (string.isNotEmpty(sortFieldsBy))
                                            ?sortFieldsBy:system.label.DefaultFieldSortingOption;
            try{
                update objCofig;
            }
            catch(Exception e){
            objUtility.displayMessage(ApexPages.severity.WARNING,
                            e.getMessage());
            }
        }
    }
    /**
       * @Author: Eternus Solutions
       * @description : 1.To the values of picklist Number of columns.
       * @Param :  
       * @Return :  
       * @Date:1/3/2016
    */
    public list<selectOption> getNumberOfcolumsPicklistValues(){
        list<selectOption> ColValues = new list<selectOption>();
        colValues.add(new selectOption(
                                EMPTY_STRING,
                                system.label.PicklistDefaultLabel)
                             );
        list<Number_Of_Columns__c> listNumberOfColumns = Number_Of_Columns__c.getAll().Values();
        listNumberOfColumns.sort();
        if(!listNumberOfColumns.isEmpty()){
            for(Number_Of_Columns__c obj : listNumberOfColumns ){
                colValues.add(new selectOption(obj.Name,obj.Name));
            }
        }
        return colValues;
    }
    /**
       * @Author: Eternus Solutions
       * @description : 1.To set the values of picklist Number of fields per column values.
       * @Param :  
       * @Return : returns selectOptions list which contains number of fileds per colums values 
       * @Date:1/3/2016
    */
    public list<selectOption> getNumberOfFieldsPerColumnPicklistValues(){
        list<selectOption> fieldsPerColValues = new list<selectOption>(); 
        fieldsPerColValues.add(new selectOption(
                                        EMPTY_STRING,
                                        system.label.PicklistDefaultLabel)
                                       );
        list<Number_Of_Fields_Per_Column__c> listNumberOfFieldsColumns = Number_Of_Fields_Per_Column__c.getAll().Values();
        listNumberOfFieldsColumns.sort(); 
        if(!listNumberOfFieldsColumns.isEmpty()){
            for(Number_Of_Fields_Per_Column__c obj : listNumberOfFieldsColumns ){
                fieldsPerColValues.add(new selectOption(obj.Name,obj.Name));
            }
        }
        return fieldsPerColValues;
    }
    /**
       * @Author: Eternus Solutions
       * @description : 1.Method get the values of picklist Number of History Records to Display.
       * @Param :   
       * @Return : Returns list of selectOptions which contains picklist values 
       * @Date:1/4/2016
    */
    public list<selectOption> getNumberOfHistoryRecordsToDisplayPicklistValues(){
        list<selectOption> historyRecordToDisplay = new list<selectOption>(); 
        list<integer> lstInt = new list<integer>();
        historyRecordToDisplay.add(new selectOption(
                                        EMPTY_STRING,
                                        system.label.PicklistDefaultLabel)
                                       );
        for(Number_Of_Records_Per_Page__c numberOfRecords : Number_Of_Records_Per_Page__c.getAll().Values()){
            if(string.isNotBlank(numberOfRecords.name)){
                lstInt.add(integer.valueOf(numberOfRecords.name));
            }
        }
        lstInt.sort();
        if(!lstInt.isEmpty()){
            for(integer value : lstInt ){
                historyRecordToDisplay.add(new selectOption(string.valueOf(value),string.valueOf(value)));
            }
        }
        return historyRecordToDisplay;
    }
    /**
       * @Author: Eternus Solutions
       * @description : 1.Method to get the values of picklist "sort fields".
       * @Param :   
       * @Return : Returns list of selectOptions which contains picklist values 
       * @Date: 21/4/2016
    */
    public list<selectOption> getFiledSortingOptions(){
        list<selectOption> lstSortOptions = new list<selectOption>(); 
        lstSortOptions.add(new selectOption(
                                        EMPTY_STRING,
                                        system.label.PicklistDefaultLabel)
                                       );
        list<Sort_Fields__c> lstSortOptionsFromCS = Sort_Fields__c.getAll().Values();
        lstSortOptionsFromCS.sort();
        if(!lstSortOptionsFromCS.isEmpty()){
            for(Sort_Fields__c obj : lstSortOptionsFromCS ){
                lstSortOptions.add(new selectOption(obj.Name,obj.Name));
            }
        }
        return lstSortOptions;
    }
}