/**
 * @Class Name: FieldHistoryWrapper
 * @Description: This is a wrapper class used to hold History record along with Field Name.
 * =================================================================================================
 *       Version   | Date        | Author             | Comments
 * -------------------------------------------------------------------------------------------------
 *       1.0       | 19/07/2016  | Eternus Solutions  | 1. Created class with constructor.
 * =================================================================================================
 **/
public with sharing class FieldHistoryWrapper {

    // Holds the label of the field.
    public String fieldLabel;
    // Holds the API name of the field.
    public String fieldName;
    // Holds history data for the field.
    public HistoryWrapper historyWrapperObject;

    /**
     * @Author: Eternus Solutions
     * @Description: Constructor to initialize fieldName, fieldLabel and historyWrapperObj.
     * @Param:
     * @Return:
     * @Date: 19/07/2016
     **/
    public FieldHistoryWrapper(String fieldName, String fieldLabel, HistoryWrapper historyWrapperObj) {

        this.fieldName = String.isNotBlank(fieldName) ? fieldName : UFHTConstants.WHITE_SPACE;
        this.fieldLabel = String.isNotBlank(fieldLabel) ? fieldLabel : UFHTConstants.WHITE_SPACE;
        this.historyWrapperObject = historyWrapperObj;
    }
}