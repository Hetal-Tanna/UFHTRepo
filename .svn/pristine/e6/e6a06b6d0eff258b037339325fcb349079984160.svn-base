/**
  * @Class Name: DataProviderForViewData
  * @Description: This is a helper (provider) class of visualforce page "ViewData".
  *               It fetches the attachment count and attachments one by one, using remote actions.
  *               It makes use of ViewDataServiceHandler and UltraTrackUtility for performing these operations.
  * ====================================================================================================================
  *       Version   | Date        | Author             | Comments
  * --------------------------------------------------------------------------------------------------------------------
  *       1.0       | 08/07/2016  | Eternus Solutions  | 1. Created the class for above functionality.
  * ====================================================================================================================
  **/

public with sharing class DataProviderForViewData {

    public DataProviderForViewData(ViewDataController controller) {

    }

    /**
      * @Author: Eternus Solutions
      * @Description: Fetches the total attachment count for selected sObject.
      * @Param: UltraTrackContainer Id for selected sObject, startDate and endDate in string format
      * @Return: Attachment count
      * @Date: 08/07/2016
      **/
    @RemoteAction
    public static Integer getAttachmentCount(Id selectedObjectId, String startDateStr, String endDateStr) {

        Integer attachmentRecordCount = 0;

        // Note: startDateStr and endDateStr do not need to be checked for null or empty. If they are null,
        //       default values are generated in the UltraTrackUtility.getAttachmentRecordCount() method.
        if(!String.isBlank(selectedObjectId)) {
            attachmentRecordCount = UltraTrackUtility.getAttachmentRecordCount(selectedObjectId, startDateStr, endDateStr);
        }
        return attachmentRecordCount;
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Fetches body of one attachment for selected sObject.
      * @Param: UltraTrackContainer Id for selected sObject, startDate and endDate, offset in string
      *         format and userFlag
      * @Return: Attachment body
      * @Date: 08/07/2016
      **/
    @RemoteAction
    public static String fetchAttachments(Id selectedObjectId,
                                          String startDateStr,
                                          String endDateStr,
                                          Boolean userFlag,
                                          String offSetStr) {

        String jsonResult = UFHTConstants.EMPTY_STRING;
        if(String.isBlank(selectedObjectId) || String.isBlank(offSetstr)) {
            return jsonResult;
        }

        userFlag = userFlag == null ? false : userFlag;
        map<String, list<HistoryWrapper>> ultraTrackWrapperMap =
            new map<String, list<HistoryWrapper>>();

        list<String> selectedFieldsForTrackingFieldList = new list<String>();
		if(!UltraTrackUtility.checkObjectAndFieldLevelSecurity('UFHT__Ultra_Track_Container__c', 
															   new list<String> {'Id','UFHT__Tracked_Fields__c','UFHT__Object_Name__c'},
															   'isAccessible')){
			return jsonResult;
		}
        map<Id, Ultra_Track_Container__c> ultraTrackContainerMap =
            new map<Id, Ultra_Track_Container__c>([SELECT Id,
                                                          Tracked_Fields__c,
                                                          Object_Name__c
                                                   FROM   Ultra_Track_Container__c
                                                   WHERE  Id = : selectedObjectId]);
        Date startDate;
        Date endDate;
        if(String.isNotBlank(startDateStr) && startDateStr != UFHTConstants.EMPTY_STRING) {
            startDateStr.trim();
            try {
                startDate = Date.parse(startDateStr);
            } catch(Exception e) {
                startDate = null;
                startDateStr = null;
            }
        }

        if(String.isNotBlank(endDateStr) && endDateStr != UFHTConstants.EMPTY_STRING) {
            endDateStr.trim();
            try {
                endDate =  Date.parse(endDateStr);
            } catch(Exception e) {
                endDateStr = null;
                endDate = null;
            }
        }
        
        Attachment attachObj = UltraTrackUtility.getAttachment(selectedObjectId,
                                                                    startDateStr,
                                                                    endDateStr,
                                                                    offSetStr);
        if(attachObj.body != null) {
            ultraTrackWrapperMap.putAll((map<String, list<HistoryWrapper>>)System.JSON.deserialize(
                                                                           attachObj.body.toString(),
                                                                           map<String, list<HistoryWrapper>>.class));
        }
        if(ultraTrackContainerMap.containsKey(selectedObjectId)
           && String.isNotBlank(ultraTrackContainerMap.get(selectedObjectId).Tracked_Fields__c)) {
            Ultra_Track_Container__c fhtDataHolderObj = ultraTrackContainerMap.get(selectedObjectId);
            if(fhtDataHolderObj.Tracked_Fields__c.contains(UFHTConstants.COMMA)) {
                selectedFieldsForTrackingFieldList = fhtDataHolderObj.Tracked_Fields__c.split(UFHTConstants.COMMA);
            } else {
               selectedFieldsForTrackingFieldList.add(fhtDataHolderObj.Tracked_Fields__c);
                
            }
        }
        if(!ultraTrackWrapperMap.isEmpty() && ultraTrackContainerMap.containsKey(selectedObjectId)
           && String.isNotBlank(ultraTrackContainerMap.get(selectedObjectId).Object_Name__c)) {
             jsonResult = ViewDataServiceHandler.getSharedHistoryRecordsForAnObject(selectedFieldsForTrackingFieldList,
                                                                                    ultraTrackWrapperMap,
                                                                                    ultraTrackContainerMap.get(selectedObjectId).Object_Name__c,
                                                                                    startDate,
                                                                                    endDate,
                                                                                    userFlag
                                                                                    );
        }
        return jsonResult;
    }
}