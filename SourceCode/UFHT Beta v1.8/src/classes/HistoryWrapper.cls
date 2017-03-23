/**
 * @Class Name: HistoryWrapper
 * @Description: Wrapper class to store information regarding historical data 
 *               into the Attachments. This class is used in class "DynamicTriggerGenericHandler" to
 *               store data in attachments and also used in class "ViewDataController" to read data
 *               from Attachments.   
 * =====================================================================================================================
 *       Version   | Date        | Author             | Comments
 *   -------------------------------------------------------------------------------------------------------------------
 *       1.0       | 22/02/2016  | Eternus Solution   | 1. Created constructor and compareTo method.
 *  ====================================================================================================================
 **/

 /**
  * Implemented comparable interface to compare objects on the basis of modifiedDateTime
 **/
public with sharing class HistoryWrapper implements Comparable {

    public Id modifiedById { get; set; }
    public String modifiedDateTime { get; set; }
    public String newValue { get; set; }
    public String oldValue { get; set; }
    public String parentId { get; set; }

    /**
     * @Author: Eternus Solutions
     * @Description : Parameterized Constructor to set values related to history data.
     * @Parameter  : 1.oldValue: old value for field
     *               2.newValue: new value for field
     *               3.parentId: record Id for record
     *               4.modifiedById: user Id who modified the record
     *               5.modifiedDateTime: DateTime when user modified the record
     **/
    public HistoryWrapper(String oldValue, String newValue, Id parentId, Id modifiedById, 
                          DateTime modifiedDateTime) {
          
          this.oldValue         = (String.isNotBlank(oldValue)) ? oldValue : UFHTConstants.EMPTY_STRING;
          this.newValue         = (String.isNotBlank(newValue)) ? newValue : UFHTConstants.EMPTY_STRING;
          this.parentId         = parentId;
          this.modifiedById     = modifiedById;
          this.modifiedDateTime = (modifiedDateTime != null) ? modifiedDateTime.formatGMT(UFHTConstants.DATE_TIME_FORMAT) : UFHTConstants.EMPTY_STRING;
    }
    
    /**
     * @Author: Eternus Solutions
     * @Description: Method to sort wrapper base on modifiedDateTime.
     * @Parameter: objToCompare: object for wrapper to compare.
     * @Return: Return If its greater than current instance then it will return -1
     *          If its smaller than current instance then it will return 1 
     *          If both are equal then it will return 0
     **/    
    public Integer compareTo(Object objToCompare) {
        Integer returnValue = 0;
        if(objToCompare != null) {
            HistoryWrapper objHistoryWrapper = (HistoryWrapper)objToCompare;
            if(String.isNotBlank(objHistoryWrapper.modifiedDateTime) && String.isNotBlank(this.modifiedDateTime)) {
                returnValue = objHistoryWrapper.modifiedDateTime.compareTo(this.modifiedDateTime);
            }
            else {
                returnValue = 0;
            }
        }
        else {
            returnValue = 1;
        }
        return returnValue;
    }
}