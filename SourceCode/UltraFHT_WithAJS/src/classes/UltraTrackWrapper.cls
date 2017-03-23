/**
 * @Class Name: UltraTrackWrapper
 * @Description: Wrapper class to store information regarding history related to fields.
 *               This wrapper class used in Classes
 *               1. "UltraSetupController" to display the Fields Label wiht Checkboxes.
 *               2."DynamicTriggerGenericHandler" to store history Data into Attachments. 
 *               3."ViewDataController" to retrive data from attachment.
 * ========================================================================================================================
 *       Version   | Date        | Author             | Comments
 *   -------------------------------------------------------------------------------------------------------------------------
 *       1.0       | 22-02-2016  | Eternus Solution   | 1. Created 3 paramterized constructor and campareTo method.
 *  ========================================================================================================================
 **/
 
 /**
  * Implemented comparable interface to compare objects on the basis of Field Label.
  **/
public with sharing class UltraTrackWrapper implements comparable {

    //String variables to store fieldName and Labels.
    public String fieldApiName;
    public String fieldLabel {get;set;}
    //Histore wrapper class List to store history data.
    public list<HistoryWrapper> lstHistory;
    //Boolean variable to specify field is selected or not.
    public boolean isSelected{get;
                              set { 
                                    isSelected = value == null ? false : value ;
                                  }
                              }

    private final static String DESCENDING = 'Descending';
    /**
     * @Description : Parameterised Constructor to set values related to fields.
     * @Parameter   : 1. fieldApiName API name of field
     *                2. fieldLabel Label of field
     **/
    public UltraTrackWrapper(String fieldApiName,String fieldLabel) {
        if(String.isNotBlank(fieldApiName) && String.isNotBlank(fieldLabel)){
          this.fieldApiName = fieldApiName;
          this.fieldLabel = fieldLabel;
        }
    }
    
    /**
     * @Description : Parameterised Constructor to set values related to fields along with history.
     * @Parameter   : 1. fieldApiName API name of field
     *               2. fieldLabel Label of field
     *               3. history list of history wrapper
     **/
    public UltraTrackWrapper(String fieldApiName,String fieldLabel,List<HistoryWrapper> history){
        if(String.isNotBlank(fieldApiName) && String.isNotBlank(fieldLabel)){
            this(fieldApiName, fieldLabel);
        }
        if(!history.isEmpty()){
          this.lstHistory = new List<HistoryWrapper>();
          this.lstHistory = history;
        }
    }
    
     /**
     * @Description : Parameterised Constructor to set values related to fields along with history.
     * @Parameter   : 1. fieldApiName API name of field
     *               2. fieldLabel Label of field
     *               3. isSelected to check field tracking enabled for field.
     **/
    public UltraTrackWrapper(String fieldName,String fieldLabel,boolean isSelected) {
        if(String.isNotBlank(fieldName) && String.isNotBlank(fieldLabel)){
            this(fieldName, fieldLabel);
        }
        this.isSelected = isSelected;
    }
    
    /**
     * @Description : Method to sort wrapper base on field label.
     * @Parameter   : ObjToCompare object for wrapper to campare
     * @Return      : Return 1 in case of desending order or -1 in asending order.
     *                 if compare object is null then return -1.
     **/
    public Integer compareTo(Object ObjToCompare) {
       map<String,Configuration__c> mapConfig = Configuration__c.getAll();
       string sortBy;
      if(mapConfig.containsKey(system.Label.ConfigureColsAndFieldsCustomSettingRecordName)){
            Configuration__c objCofig = mapConfig.get(system.Label.ConfigureColsAndFieldsCustomSettingRecordName);
            sortBy = objCofig.Sort_Fields_By__c;
        }
        else{
            sortBy = system.label.DefaultFieldSortingOption;
        }
      Integer returnValue = 0;
      if(ObjToCompare != Null){
        UltraTrackWrapper that = (UltraTrackWrapper)ObjToCompare;
        if(sortBy==DESCENDING){
        returnValue = (this.fieldLabel < that.fieldLabel) ? 1 : -1;
        }
        else{
            returnValue = (this.fieldLabel > that.fieldLabel) ? 1 : -1;
        }
      }
      else{
          returnValue = -1;
      }
      return returnValue;
    } 

}