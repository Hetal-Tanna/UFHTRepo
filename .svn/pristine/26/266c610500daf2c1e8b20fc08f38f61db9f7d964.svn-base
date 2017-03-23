/**
  * @Class Name: UltraTrackWrapper
  * @Description: This wrapper provides a structure for holding the history data temporarily while it is
  *               manipulated.
  *               This wrapper class used in Classes
  *               1. "UltraSetupController" to display the Fields Label with checkboxes.
  *               2. "DynamicTriggerGenericHandler" to store history Data into Attachments.
  *               3. "ViewDataController" to retrieve data from attachment.
  *               4. Implemented comparable interface to compare objects on the basis of Field Label.
  * ====================================================================================================================
  *       Version   | Date        | Author             | Comments
  *   ------------------------------------------------------------------------------------------------------------------
  *       1.0       | 22/02/2016  | Eternus Solutions  | 1. Created 3 parameterized constructor and compareTo method.
  * ====================================================================================================================
  **/
public with sharing class UltraTrackWrapper implements Comparable {

    // Holds label of field.
    public String fieldLabel {get;set;}
    // Holds API name of field.
    public String fieldApiName {get;set;}
    // Hold a list of history wrapper objects.
    public list<HistoryWrapper> historyList;
    // Holds value to specify field is selected or not.
    public Boolean isSelected {
        get;
        set {
            isSelected = value == null ? false : value ;
        }
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Parameterized Constructor to set values related to fields.
      * @Param: 1. FieldApiName : API name of field
      *         2. FieldLabel : Label of field
      * @Date: 22/02/2015
      **/
    public UltraTrackWrapper(String fieldApiName, String fieldLabel) {

        this.fieldApiName = String.isNotBlank(fieldApiName) ? fieldApiName : UFHTConstants.WHITE_SPACE;
        this.fieldLabel = String.isNotBlank(fieldLabel) ? fieldLabel : UFHTConstants.WHITE_SPACE;
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Parameterized Constructor to set values related to fields along with history.
      * @Param: 1. FieldApiName : API name of field
      *         2. FieldLabel : Label of field
      *         3. pHistoryList : of history wrapper
      * @Date: 22/02/2015
      **/
    public UltraTrackWrapper(String fieldApiName, String fieldLabel, List<HistoryWrapper> pHistoryList) {

        this(fieldApiName, fieldLabel);

        this.historyList = (pHistoryList != null) ? new List<HistoryWrapper>(pHistoryList) : new List<HistoryWrapper>();
    }

    /**
      * @Author: Eternus Solutions
      * @Description: parameterized Constructor to set values related to fields along with history.
      * @Param: 1. FieldApiName : API name of field
      *         2. FieldLabel : Label of field
      *         3. isSelected : to check field tracking enabled for field.
      * @Date: 22/02/2015
      **/
    public UltraTrackWrapper(String fieldName, String fieldLabel, Boolean isSelected) {

        this(fieldName, fieldLabel);
        this.isSelected = isSelected != null ? isSelected : false;
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Method to sort wrapper records based on field label.
      * @Param: ObjToCompare : object for wrapper to compare
      * @Return: Return If its greater than current instance then it will return -1
      *          If its smaller than current instance then it will return 1
      *          If both are equal then it will return 0
      * @Date: 22/02/2015
      **/
    public Integer compareTo(Object objToCompare) {
    Integer returnValue = 0;
        if(objToCompare != null) {
        	if(!UltraTrackUtility.isAllowDMLForCustomSetting('UFHT__Configuration__c','isAccessible')){
				UltraTrackUtility.displayMessage(ApexPages.Severity.ERROR, System.Label.GenericError);
	        	return returnValue;
			}
            map<String,Configuration__c> configMap = Configuration__c.getAll();
            String sortBy;
            if(configMap.containsKey(System.Label.ConfigureColsAndFieldsCustomSettingRecordName) &&
            String.isNotBlank(configMap.get(System.Label.ConfigureColsAndFieldsCustomSettingRecordName).Sort_Fields_By__c)) {
                sortBy = configMap.get(System.Label.ConfigureColsAndFieldsCustomSettingRecordName).Sort_Fields_By__c;
            }
            else {
                sortBy = System.Label.DefaultFieldSortingOption;
            }
            UltraTrackWrapper wrapperObj = (UltraTrackWrapper)objToCompare;
            if(UFHTConstants.ASCENDING.equalsIgnoreCase(sortBy)) {
               returnValue = this.fieldLabel.toUpperCase().compareTo(wrapperObj.fieldLabel.toUpperCase());
            }
            else {
                returnValue = wrapperObj.fieldLabel.toUpperCase().compareTo(this.fieldLabel.toUpperCase());
            }
        }
        else {
            returnValue = -1;
        }
    return returnValue;
    }
}