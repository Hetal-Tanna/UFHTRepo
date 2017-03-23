/**
  * @Class Name: DataProviderForViewData_QA_Clone
  * @Description: This is a helper (provider) class of visualforce page "ViewData".
  *               It fetches the attachment count and attachments one by one, using remote actions.
  *               It makes use of ViewDataServiceHandler_QA_Clone and UltraTrackUtility for performing these operations.
  * ====================================================================================================================
  *       Version   | Date        | Author             | Comments
  * --------------------------------------------------------------------------------------------------------------------
  *       1.0       | 08/07/2016  | Eternus Solutions  | 1. Created the class for above functionality.
  * ====================================================================================================================
  **/

global with sharing class DataProviderForViewData_QA_Clone{

    global static List<UserInfoWrapper> userWrapperList;
    global static List<String> datatypeList;
    
    public DataProviderForViewData_QA_Clone(ViewDataController_QA_Clone controller) {

    }

    /**
      * @Author: Eternus Solutions
      * @Description: Fetches the total attachment count for selected sObject.
      * @Param: UltraTrackContainer Id for selected sObject, startDate and endDate in string format
      * @Return: Attachment count
      * @Date: 08/07/2016
      **/
    @RemoteAction
    global static Integer getAttachmentCount(Id selectedObjectId, String startDateStr, String endDateStr,
                                             String objKeyPrefix) {

        Integer attachmentRecordCount = 0;
        Id objContainerId = UltraTrackUtility_QA_Clone.getObjectNameFromPrefix(objKeyPrefix);
        system.debug('>>> objContainerId : '+objContainerId);
        if(String.isBlank(selectedObjectId) && objKeyPrefix != null) {
            // use keyprefix object
            attachmentRecordCount = UltraTrackUtility_QA_Clone.getAttachmentRecordCount(objContainerId, startDateStr, endDateStr);
        }
        else {
            // use selected obj id
            attachmentRecordCount = UltraTrackUtility_QA_Clone.getAttachmentRecordCount(selectedObjectId, startDateStr, endDateStr);
        }
        // Note: startDateStr and endDateStr do not need to be checked for null or empty. If they are null,
        //       default values are generated in the UltraTrackUtility_QA_Clone.getAttachmentRecordCount() method.
        /*if(!String.isBlank(selectedObjectId)) {
            attachmentRecordCount = UltraTrackUtility_QA_Clone.getAttachmentRecordCount(selectedObjectId, startDateStr, endDateStr);
        }*/
        system.debug('>>> attachmentRecordCount : '+attachmentRecordCount);
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
    global static String fetchAttachments(Id selectedObjectId,
                                          String startDateStr,
                                          String endDateStr,
                                          Boolean userFlag,
                                          String offSetStr,
                                          String objKeyPrefix ) {

        String jsonResult = UFHTConstants.EMPTY_STRING;
        map<String, String> fieldNameAndSeverityMap = new map<String, String>();
        Id objSelected;
        if(String.isBlank(selectedObjectId) && objKeyPrefix != null) {
            // use keyprefix object
            objSelected = UltraTrackUtility_QA_Clone.getObjectNameFromPrefix(objKeyPrefix);
        }
        else {
            // use selected obj id
            objSelected = selectedObjectId;
        }
        if(String.isBlank(objSelected) || String.isBlank(offSetstr)) {
            return jsonResult;
        }

        userFlag = userFlag == null ? false : userFlag;
        map<String, list<HistoryWrapper>> ultraTrackWrapperMap =
            new map<String, list<HistoryWrapper>>();

        list<String> selectedFieldsForTrackingFieldList = new list<String>();
    if(!UltraTrackUtility_QA_Clone.checkObjectAndFieldLevelSecurity('UFHT__Ultra_Track_Container__c', 
                                 new list<String> {'Id','UFHT__Tracked_Fields__c','UFHT__Object_Name__c'},
                                 'isAccessible')){
      return jsonResult;
    }
        map<Id, Ultra_Track_Container__c> ultraTrackContainerMap =
            new map<Id, Ultra_Track_Container__c>([SELECT Id,
                                                          Tracked_Fields__c,
                                                          Object_Name__c,
                                                          Severity_of_Tracked_fields__c
                                                   FROM   Ultra_Track_Container__c
                                                   WHERE  Id = : objSelected]);
                                                   
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
        
        Attachment attachObj = UltraTrackUtility_QA_Clone.getAttachment(objSelected,
                                                                    startDateStr,
                                                                    endDateStr,
                                                                    offSetStr);
        if(attachObj.body != null) {
            ultraTrackWrapperMap.putAll((map<String, list<HistoryWrapper>>)System.JSON.deserialize(
                                                                           attachObj.body.toString(),
                                                                           map<String, list<HistoryWrapper>>.class));
        }
        if(ultraTrackContainerMap.containsKey(objSelected)
           && String.isNotBlank(ultraTrackContainerMap.get(objSelected).Tracked_Fields__c)) {
            Ultra_Track_Container__c fhtDataHolderObj = ultraTrackContainerMap.get(objSelected);
            if(fhtDataHolderObj.Tracked_Fields__c.contains(UFHTConstants.COMMA)) {
                selectedFieldsForTrackingFieldList = fhtDataHolderObj.Tracked_Fields__c.split(UFHTConstants.COMMA);
            } else {
               selectedFieldsForTrackingFieldList.add(fhtDataHolderObj.Tracked_Fields__c);
                
            }
            if(fhtDataHolderObj.Severity_of_Tracked_fields__c.contains(UFHTConstants.COMMA)) {
                fieldNameAndSeverityMap = UltraTrackUtility_QA_Clone.getfieldSeverityMap(fhtDataHolderObj.Severity_of_Tracked_fields__c);
            }
        }
        if(!ultraTrackWrapperMap.isEmpty() && ultraTrackContainerMap.containsKey(objSelected)
           && String.isNotBlank(ultraTrackContainerMap.get(objSelected).Object_Name__c)) {
             jsonResult = ViewDataServiceHandler_QA_Clone.getSharedHistoryRecordsForAnObject(selectedFieldsForTrackingFieldList,
                                                                                    ultraTrackWrapperMap,
                                                                                    ultraTrackContainerMap.get(objSelected).Object_Name__c,
                                                                                    startDate,
                                                                                    endDate,
                                                                                    userFlag,
                                                                                    fieldNameAndSeverityMap
                                                                                    );
        }
        return jsonResult;
    }
    
    /**
      * @Author: Eternus Solutions
      * @Description: Fetches the all the users in the org(max 50,000)
      * @Param: NA
      * @Return:String of List of Users
      * @Date: 19/01/2017 
      **/
    @RemoteAction
    global static List<UserInfoWrapper> getOrgUsers() {
        userWrapperList = new List<UserInfoWrapper>();
            for(User userObj :[SELECT id,
                                      Name
                               FROM User
                               LIMIT 50000]) {
                userWrapperList.add(new UserInfoWrapper(userObj.Id, userObj.Name));
            }
            //userWrapperList.sort();
            return userWrapperList;
    }
    
    /**
      * @Author: Eternus Solutions
      * @Description: Fetches the all the datatypes for selected object
      * @Param: String of name of selected object
      * @Return: Json String of List of data types
      * @Date: 20/01/2017
      **/
    @RemoteAction
    global static List<String> getDataTypesForObject(String selectedObjectName) {
        datatypeList = new List<String>();
        
        selectedObjectName = selectedObjectName.substringbetween(UFHTConstants.BRACKET_OPEN, UFHTConstants.BRACKET_CLOSE);
        for(String fieldType : UltraTrackUtility_QA_Clone.getFieldNamesAndDataType(selectedObjectName).values()) {
            //String fieldTypeStr = fieldType;
            
            datatypeList.add(UltraTrackUtility_QA_Clone.convertFieldToTitleCase(fieldType));
        }
        datatypeList.sort();
        return datatypeList;
    }
    

}