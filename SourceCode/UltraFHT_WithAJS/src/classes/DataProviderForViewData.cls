public with sharing class DataProviderForViewData {

    public DataProviderForViewData(ViewDataController controller) {
        // @ToDo: Nothing
    }

    @RemoteAction
    public static Integer getAttachmentCount(String selectedObjectId, string startDateStr, string endDateStr) {

        Integer recordCount = 0;

        List<Attachment> attachmentList = new List<Attachment>();

        if(string.isNotBlank(selectedObjectId)) {
            recordCount =  UltraTrackUtilityClass.getAttachmentRecordCount(selectedObjectId, startDateStr, endDateStr);
        }
        return recordCount;
    }

    @RemoteAction
    public static String fetchAttachments(String selectedObjectId, string startDateStr, string endDateStr, boolean userFlag , string offSetStr) {

        string jsonResult;

        Map<string,List<HistoryWrapper>> ultraTrackWrapperMap = new Map<string,List<HistoryWrapper>>();

        List<string> selectedFieldsForTrackingField = new List<string>(); 

        Map<Id,Ultra_Track_Container__c> ultraTrackContainerMap =
            new Map<Id,Ultra_Track_Container__c>([SELECT Id,
                                                         Tracked_Fields__c,
                                                         Object_Name__c
                                                    FROM Ultra_Track_Container__c]);

        Date stratDate;
        Date endDate;
        DateTime newDateTime;
        Date attchementStartDate;
        Date attchementEndDate; 
        String attchementStartDateStr;
        String attchementEndDateStr;
        List<string> splitStrtDate;
        List<string> splitEndDate;
        Date newstrDate;
        Date newEndDate;

        Integer offSetForAttachment = integer.valueOf(offSetStr);
        Boolean isAttchmentValid = false;

        if(startDateStr != null && string.isNotBlank(startDateStr) && startDateStr != ''){
            startDateStr.trim();
            stratDate = Date.parse(startDateStr);
        }

        if(endDateStr != null && string.isNotBlank(endDateStr) && endDateStr != '')
            endDate =  Date.parse(endDateStr);

        if(string.isNotBlank(selectedObjectId)) {

            Attachment attaObj = UltraTrackUtilityClass.getAttachments(selectedObjectId, startDateStr, 
                                                                            endDateStr, offSetStr);

            if(attaObj.body!=null){
                ultraTrackWrapperMap.putAll((map<string,List<HistoryWrapper>>)System.JSON.deserialize(
                                                                                attaObj.body.toString(), 
                                                                                map<string,List<HistoryWrapper>>.class));
            }
        }

        if(ultraTrackContainerMap.containsKey(selectedObjectId)
        && string.isNotBlank(ultraTrackContainerMap.get(selectedObjectId).Tracked_Fields__c)) {

            Ultra_Track_Container__c fhtDataHolderObj = ultraTrackContainerMap.get(selectedObjectId);

            if(fhtDataHolderObj.Tracked_Fields__c.contains(',')) {
                selectedFieldsForTrackingField = fhtDataHolderObj.Tracked_Fields__c.split(',');

            } else {
               selectedFieldsForTrackingField.add(fhtDataHolderObj.Tracked_Fields__c);
           }
        }

        if(ultraTrackWrapperMap.size() > 0)
             jsonResult = ViewDataServiceHandler.getSharedHistroyRecordsForAnObject(selectedFieldsForTrackingField,
                                                                                      ultraTrackWrapperMap,
                                                                                      ultraTrackContainerMap.get(selectedObjectId).Object_Name__c,
                                                                                      stratDate,
                                                                                      endDate,
                                                                                      userFlag 
                                                                                    );
        return jsonResult;
    }
}