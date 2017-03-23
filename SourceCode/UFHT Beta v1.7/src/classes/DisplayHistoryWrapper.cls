/**
 * @Class Name: DisplayHistoryWrapper
 * @Description: This is wrapper class used to display records in View Data page.
 * =================================================================================================
 *       Version   | Date        | Author             | Comments
 * -------------------------------------------------------------------------------------------------
 *       1.0       | 19/07/2016  | Eternus Solutions   | 1. Created class with constructor.
 * =================================================================================================
 **/
public with sharing class DisplayHistoryWrapper {
  
    public String fieldLabel;
    public String fieldName;
    public Id modifiedById;
    public String modifiedByName;
    public String modifiedDisplayTime;
    public String modifiedTime;
    public String newValue;
    public String oldValue;
    public Id parentId;
    public String recordName;

    public DisplayHistoryWrapper(Id parentId,
                                 String recordName,
                                 String modifiedDisplayTime,
                                 String modifiedTime,
                                 String modifiedByName,
                                 Id modifiedById,
                                 String fieldLabel,
                                 String fieldName,
                                 String oldValue,
                                 String newValue
                                 ) {
        this.parentId = parentId ;

        this.recordName = String.isNotBlank(recordName) ? recordName : UFHTConstants.WHITE_SPACE;

        this.modifiedDisplayTime = String.isNotBlank(modifiedDisplayTime) ? modifiedDisplayTime : UFHTConstants.WHITE_SPACE;

        this.modifiedTime = String.isNotBlank(modifiedTime) ? modifiedTime : UFHTConstants.WHITE_SPACE;

        this.modifiedByName = String.isNotBlank(modifiedByName) ? modifiedByName : UFHTConstants.WHITE_SPACE;

        this.modifiedById = modifiedById;

        this.fieldLabel = String.isNotBlank(fieldLabel) ? fieldLabel : UFHTConstants.WHITE_SPACE;

        this.fieldName = String.isNotBlank(fieldName) ? fieldName : UFHTConstants.WHITE_SPACE ;

        this.oldValue = String.isNotBlank(oldValue) ? oldValue : UFHTConstants.WHITE_SPACE;

        this.newValue = String.isNotBlank(newValue) ? newValue : UFHTConstants.WHITE_SPACE;
    }
}