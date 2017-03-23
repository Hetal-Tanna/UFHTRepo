/**
 * Class Name: DynamicTriggerGenericHandler.
 * @Description: This class is generic handler for all dynamically generated triggers.
 *                This stores the History data in attachment under Ultra_Track_Container__c object in JSON Format.  
 * ===============================================================================================================================
 *       Version   | Date        | Author             | Comments
 *   -----------------------------------------------------------------------------------------------------------------------------
 *       1.0       | 16-11-2015  | Eternus Solution   | 1.Created Class for above functionality.
 *       1.1       | 23-02-2016  | Eternus Solution   | 1.added code review changes.
 *       1.2       | 26-02-2015  | Eternus Solution   | 1.store history data in attachment under object "Ultra_Track_Container__c"
 *                                                        instead of "FieldHistoryTrackSetting" object
 *       1.3       | 29-02-2015  | Eternus Solution   | 1.Removed describe call methods and added utility class for that.
 *       1.4       | 03-03-2015  | Eternus Solution   | 1.added generateActionString,getHistoryWrapperInstance Method.
 *  ==============================================================================================================================
 **/

global with sharing class DynamicTriggerGenericHandler{
    //Map of wrapper class "UltraTrackWrapper" to de serialize and serialize History data
    public map<String,List<UFHT.HistoryWrapper>> mapFieldVsHistoryWapper;
    //List to hold the history data and insert into Attachment file.
    list<UFHT.HistoryWrapper> listHistoryWrapper;
    //Attachment object to create or update the attachment.
    Attachment objAtt;
    //List ID of Container record id's to query against Attachment.
    list<ID> utcIdList = new list<ID>();
    //List of Ultra_Track_Container__c to get selected field list
    list<UFHT__Ultra_Track_Container__c> listUltraTrackContainer;
    // Map to hold the object name and Ultra_Track_Container__c object
    public map<String,UFHT__Ultra_Track_Container__c> mapSavedObjectFields;
    //List of Attachment to insert or update the attachments
    public List<Attachment> lstAttachmentToUpsert;
    //Map to hold objects name and sOject types
    public static map<String, Schema.SObjectType> mapObjects = Schema.getGlobalDescribe();
    //Map to hold the fields name and describe data
    public static map<String, Schema.SObjectField> mapFields;
    //Set to store relationship fields name
    public static set<String> setRelationshipFields;
    //set to store the ids of parent relationship field
    public static set<ID> setParentIds;
    //Map to store record id vs record name
    public static map<ID,String> mapIdVsRecordName ;
    // integer variable to store Attachment file size
    public integer intFileSize;
    //map to hold the record id vs Set of fields from record
    public static map<ID,set<String>> mapIdVsRecordFields;

    //string variables to store constant values.
    private static final String ID_FIELD = 'ID';
    private static final String LAST_MODIFIED_BY_FIELD = 'LastModifiedById';
    private static final String LAST_MODIFIED_DATE_FIELD ='LastModifiedDate';
    private static final String CONTENT_TYPE_TEXT = 'text/plain;charset=UTF-8';
    private static final String COMMA =',';
    private static final String START_DATE_PREFIX ='SD';
    private static final String DATE_FORMAT = 'MM/dd/YYYY';
    private static final String FILE_EXTENSION_TXT = '.txt';
    private static final String END_DATE_PREFIX = 'ED';
    private static final String ESCAPED_RETURN = '\r';
    private static final String ESCAPED_LINE_BREAK = '\n';
    private static final String PERCENT_SIGN = '%';
    private static final Integer MAX_BODY_LENGTH = 2097000;
    private static final Integer MAX_RECORD_COUNT = 1000;
    private static final String EMPTY_STRING = '';
    private static final String QUERY_SELECT = 'SELECT';
    private static final String WHITE_SPACE = ' ';
    private static final String QUERY_FROM = 'FROM';
    private static final String COLON = ':';
    private static final String QUERY_SET_PARENTIDS = 'setParentId';
    private static final String QUERY_IN = 'IN';
    private static final String QUERY_WHERE = 'WHERE';

    global DynamicTriggerGenericHandler(){
        listUltraTrackContainer = new list<UFHT__Ultra_Track_Container__c>();
        setRelationshipFields = New set<String>();
        setParentIds = new set<ID>();
        mapIdVsRecordName = new map<ID,String> ();
        mapIdVsRecordFields = New map<ID,set<String>>();
        mapFields = new Map<String, Schema.SObjectField>();
        intFileSize = 0;
    }
     /**
      * @Author: Eternus Solutions
      * @description : Method to create or update Attachment file on update of Sobject record.
      * @Param : It takes trigger.newMap,trigger.oldMap and strObjectName as string.
      * @Return :
      * @Date:29/2/2016
      **/
    global void onUpdateStoreHistoryData(map<id,SObject> mapNewRecords,
                                         map<id,SObject> mapOldRecords,
                                         String strObjectName)
    {
        list<String> listSelectedFields = new list<String>();
        date todayDate;
        list<string> currencyOrPercentEncryptedFieldvalue = new list<string>();
        mapSavedObjectFields = new map<String,UFHT__Ultra_Track_Container__c>();
        map<ID,Attachment> mapIdAttachment = new map<ID,Attachment>();
        lstAttachmentToUpsert = new List<Attachment>();
        string oldValue;
        string newValue;
        boolean checkPercentCurrencyEncrpted;
        if(string.isNotBlank(strObjectName)){
            listUltraTrackContainer = [SELECT 
                                       UFHT__Tracked_Fields__c,
                                       UFHT__Is_Tracking_Enabled__c,
                                       UFHT__Object_Name__c
                                       FROM UFHT__Ultra_Track_Container__c
                                       WHERE UFHT__Object_Name__c=:strObjectName
                                       limit 1];
                                     
            //process only if Is_Tracking_Enabled__c is enabled 
        if(!listUltraTrackContainer.isEmpty() && listUltraTrackContainer[0].UFHT__Is_Tracking_Enabled__c)
        {    
            mapSavedObjectFields.put(listUltraTrackContainer[0].UFHT__Object_Name__c,listUltraTrackContainer[0]); 
            utcIdList.add(listUltraTrackContainer[0].ID);
            if(string.isNotBlank(listUltraTrackContainer[0].UFHT__Tracked_Fields__c)){
                
                listSelectedFields = listUltraTrackContainer[0].UFHT__Tracked_Fields__c.split(COMMA);
            }
            //get Fields of records from trigger.new and trigger.old
            mapIdVsRecordFields = getFieldsFromRecords(mapNewRecords, mapOldRecords);
            // Get relationship fields from trigger.new record and trigger.old
            setRelationshipFields = getRelationshipFields(strObjectName,listSelectedFields);
            
            // Get parentID's from relationship fields.
            setParentIds = (!setRelationshipFields.isEmpty())?
             getAllParentRecordIds(setRelationshipFields, mapNewRecords, mapOldRecords):setParentIds;
            
            //Get Record Name from ParentID 
            mapIdVsRecordName = (!setParentIds.isEmpty())? getIdVsRecordNameMap(setParentIds): mapIdVsRecordName;
            
            //Call method to get attachments related to Ultra_Track_Container__c object
            mapIdAttachment = (!utcIdList.isEmpty())? getAttachmentsRelatedToUTC(utcIdList): mapIdAttachment;
            
            currencyOrPercentEncryptedFieldvalue = new list<string>();
            // if attachment is present for Container record
            if(mapSavedObjectFields.containsKey(strObjectName) 
                    && mapIdAttachment.containsKey(mapSavedObjectFields.get(strObjectName).ID))
            {
                objAtt = new Attachment();
                objAtt = mapIdAttachment.get(mapSavedObjectFields.get(strObjectName).ID); 
                intFileSize = objAtt.bodyLength;
                mapFieldVsHistoryWapper = new map<String,List<UFHT.HistoryWrapper>>();
                mapFieldVsHistoryWapper = (map<String,List<UFHT.HistoryWrapper>>)System.JSON.deserialize(
                       objAtt.body.toString(), map<String,List<UFHT.HistoryWrapper>>.class);
                //iterate all selected fields
                for(String selectedField : listSelectedFields) { 
                    listHistoryWrapper = new list<UFHT.HistoryWrapper>();
                    checkPercentCurrencyEncrpted = false;
                    //iterate all trigger.new records
                    Schema.DisplayType checkFlg = UltraTrackUtilityClass.getFieldType(strObjectName, selectedField);
                    if(checkFlg != null &&(checkFlg == Schema.DisplayType.Currency || 
                       checkFlg == Schema.DisplayType.Percent ||
                       checkFlg == Schema.DisplayType.EncryptedString) ) {
                        checkPercentCurrencyEncrpted = true;
                    }
                    for(SObject record : mapNewRecords.values()) {
                        //Check old and new values of field is different
                        if(mapIdVsRecordFields.containsKey(record.ID) && mapIdVsRecordFields.get(record.ID).contains(selectedField)
                            && mapOldRecords.containsKey(record.id) && isFieldValueChanged(string.valueOf(record.get(selectedField)),
                                string.valueOf(mapOldRecords.get(record.id).get(selectedField)))) {
                           if(checkPercentCurrencyEncrpted) {
                            currencyOrPercentEncryptedFieldvalue = UltraTrackUtilityClass.checkCurrencyOrPercentField(strObjectName, 
                                                                                                                      selectedField,
                                                                                                                      string.valueOf(mapOldRecords.get(record.id).get(selectedField)),
                                                                                                                      string.valueOf(record.get(selectedField)));
                            if( !currencyOrPercentEncryptedFieldvalue.isEmpty() && currencyOrPercentEncryptedFieldvalue.size() >= 2) {
                                oldValue = currencyOrPercentEncryptedFieldvalue[0];
                                newValue = currencyOrPercentEncryptedFieldvalue[1];
                            }
                           }
                           else if(mapOldRecords.containsKey(record.id)) {
                             oldValue = string.valueOf(mapOldRecords.get(record.id).get(selectedField));
                             newValue = string.valueOf(record.get(selectedField));
                           }
                           HistoryWrapper objHW = getHistoryWrapperInstance(selectedField,
                                                  oldValue,
                                                  newValue,
                                                  String.valueOf(record.get(ID_FIELD)),
                                                  String.valueOF(record.get(LAST_MODIFIED_BY_FIELD)),
                                                  (DateTime)record.get(LAST_MODIFIED_DATE_FIELD));
                           if(objHW != Null) {
                                listHistoryWrapper.add(objHW);
                           }
                       }
                   }
                   if(!listHistoryWrapper.isEmpty()){
                      //check attachment length exceeds or not for every record
                      createOrUpdateAttachment(listHistoryWrapper, selectedField, strObjectName);
                   }
               }
               if(objAtt.body != null)
                   lstAttachmentToUpsert.add(objAtt);
               // update or insert attachment
                if( !lstAttachmentToUpsert.isEmpty()) {
                    upsert lstAttachmentToUpsert;
                }
         }
         // if attachment is not present for Container record
         else if(mapSavedObjectFields.containsKey(strObjectName) 
            && !mapIdAttachment.containsKey(mapSavedObjectFields.get(strObjectName).id)) 
         {
            mapFieldVsHistoryWapper = new map<String,List<UFHT.HistoryWrapper>>();
            todayDate = system.today();
            objAtt = new Attachment();
            objAtt.parentId = mapSavedObjectFields.get(strObjectName).ID;
            objAtt.Name = system.Label.AttachmentFileName + START_DATE_PREFIX + DateTime.newInstance(todayDate.year(),todayDate.month(),todayDate.day()).format(DATE_FORMAT)+FILE_EXTENSION_TXT;
            objAtt.contentType = CONTENT_TYPE_TEXT;
            objAtt.isPrivate = false;
            //iterate all selected fields
            for(String selectedField : listSelectedFields) {
                listHistoryWrapper = new list<UFHT.HistoryWrapper>();
                checkPercentCurrencyEncrpted = false;
                //iterate all trigger.new records
                
                 Schema.DisplayType checkFlg = UltraTrackUtilityClass.getFieldType(strObjectName, selectedField);
                 if(checkFlg != null &&(checkFlg == Schema.DisplayType.Currency || 
                       checkFlg == Schema.DisplayType.Percent ||
                       checkFlg == Schema.DisplayType.EncryptedString) ) {
                        checkPercentCurrencyEncrpted = true;
                 }
                for(SObject record: mapNewRecords.values()) {
                    //Check old and new values of field is different
                    if(mapIdVsRecordFields.containsKey(record.ID) && mapIdVsRecordFields.get(record.ID).Contains(selectedField) 
                        && mapOldRecords.containsKey(record.id) && isFieldValueChanged(string.valueOf(record.get(selectedField)),string.valueOf(mapOldRecords.get(record.id).get(selectedField)))) 
                    {
                       if(checkPercentCurrencyEncrpted) {
                        currencyOrPercentEncryptedFieldvalue = UltraTrackUtilityClass.checkCurrencyOrPercentField(strObjectName, 
                                                                                                                  selectedField,
                                                                                                                  string.valueOf(mapOldRecords.get(record.id).get(selectedField)),
                                                                                                                  string.valueOf(record.get(selectedField)));
                        if( !currencyOrPercentEncryptedFieldvalue.isEmpty() && currencyOrPercentEncryptedFieldvalue.size() >= 2) {
                            oldValue = currencyOrPercentEncryptedFieldvalue[0];
                            newValue = currencyOrPercentEncryptedFieldvalue[1];
                        }
                       }
                       else if(mapOldRecords.containsKey(record.id)) {
                         oldValue = string.valueOf(mapOldRecords.get(record.id).get(selectedField));
                         newValue = string.valueOf(record.get(selectedField));
                       }
                       UFHT.HistoryWrapper objHW = getHistoryWrapperInstance(selectedField,
                                                   oldValue,
                                                   newValue,
                                                   String.valueOf(record.get(ID_FIELD)),
                                                   String.valueOF(record.get(LAST_MODIFIED_BY_FIELD)),
                                                   (DateTime)record.get(LAST_MODIFIED_DATE_FIELD));
                       if(objHW != Null) {
                            listHistoryWrapper.add(objHW);
                       }
                    }
               }
               if(!listHistoryWrapper.isEmpty()){
                   createOrUpdateAttachment(listHistoryWrapper, selectedField, strObjectName);
               }
          }
          if(objAtt.body != null)
              lstAttachmentToUpsert.add(objAtt);
            if( !lstAttachmentToUpsert.isEmpty()) {
                insert lstAttachmentToUpsert;
            }
       } 
     }
    }
   }
   
    /**
     * @Author: Eternus Solutions
     * @description : Method to check attachment size and create new attachments if size exceeded.
     * @Param : it takes 3 paramiters hisoryWrapper class's list and field and object name as string
     * @Return :
     * @Date: 27/05/2016
     **/
   public void createOrUpdateAttachment(List<UFHT.HistoryWrapper> lstHstWrapper, String strSelectedField, String strObjName){
        date todayDate;
        if(!lstHstWrapper.isEmpty()){
            integer recordCount = 0;
            for(list<UFHT.HistoryWrapper> wrapperList : mapFieldVsHistoryWapper.values()) {
                recordCount += wrapperList.size();
            }
            for(UFHT.HistoryWrapper wrapperObj : lstHstWrapper){
                if(intFileSize <= MAX_BODY_LENGTH && recordCount < MAX_RECORD_COUNT){
                    if(mapFieldVsHistoryWapper.containsKey(strSelectedField)){
                        mapFieldVsHistoryWapper.get(strSelectedField).add(wrapperObj);
                    }
                    else{
                        mapFieldVsHistoryWapper.put(strSelectedField,new List<UFHT.HistoryWrapper>{wrapperObj});
                    }
                    intFileSize = intFileSize + JSON.serialize(wrapperObj).length();
                    ++ recordCount;
                }
                else{ 
                    todayDate = system.today();
                    objAtt.body=blob.valueOf(JSON.serialize(mapFieldVsHistoryWapper));
                    if(!objAtt.Name.contains(END_DATE_PREFIX)) {
                        objAtt.Name = objAtt.Name.substring(0, objAtt.Name.indexOf(FILE_EXTENSION_TXT)) + END_DATE_PREFIX+ DateTime.newInstance(todayDate.year(),todayDate.month(),todayDate.day()).format(DATE_FORMAT)+FILE_EXTENSION_TXT;
                    }
                    intFileSize = 0;
                    recordCount = 0;
                    if(objAtt.body != null)
                        lstAttachmentToUpsert.add(objAtt);
                    mapFieldVsHistoryWapper = new map<String,List<UFHT.HistoryWrapper>>();
                    mapFieldVsHistoryWapper.put(strSelectedField,new List<UFHT.HistoryWrapper>{wrapperObj});
                    
                    objAtt = new Attachment();
                    
                    objAtt.parentId = mapSavedObjectFields.get(strObjName).ID;
                    objAtt.Name = system.Label.AttachmentFileName + START_DATE_PREFIX + DateTime.newInstance(todayDate.year(),todayDate.month(),todayDate.day()).format(DATE_FORMAT)+FILE_EXTENSION_TXT;
                    objAtt.contentType = CONTENT_TYPE_TEXT;
                    objAtt.isPrivate = false;
                    ++ recordCount; 
               }
             }
             if( !mapFieldVsHistoryWapper.isEmpty()) {
                objAtt.body = blob.valueOf(JSON.serialize(mapFieldVsHistoryWapper));
            }
        }
    }
    
    /**
     * @Author: Eternus Solutions
     * @description : Method to get the all fields from trigger.new and trigger.old records
     * @Param : trigger.newMap and trigger,oldMap
     * @Return : It returns record id vs Set of fields.
     * @Date: 6/6/2016
     **/
    public static map <ID, set<String>> getFieldsFromRecords(map<id,SObject> mapNewRecords, map<id,SObject> mapOldRecords){
        map <ID, set<String>> recordIdVsFields = new map <ID, set<String>>();
        if(!mapNewRecords.values().isEmpty() && !mapOldRecords.values().isEmpty()){
            for(sObject record : mapNewRecords.values()){
                recordIdVsFields.put(record.ID,UltraTrackUtilityClass.getFields(record, mapOldRecords.get(record.id)));
            }
        }
        return recordIdVsFields;
    }

    /**
     * @Author: Eternus Solutions
     * @description : Method to check old field value and new field values are diffrent.
     * @Param : it takes old value and new value as string
     * @Return : It returns boolean value
     * @Date:17/05/2016
     **/
    public boolean isFieldValueChanged(string newFieldValue, string oldFieldValue){
        newFieldValue = (string.isNotBlank(newFieldValue))? newFieldValue.Replace(ESCAPED_RETURN + ESCAPED_LINE_BREAK, ESCAPED_LINE_BREAK).Replace(ESCAPED_RETURN, ESCAPED_LINE_BREAK):newFieldValue;
        oldFieldValue = (string.isNotBlank(oldFieldValue))? oldFieldValue.Replace(ESCAPED_RETURN + ESCAPED_LINE_BREAK, ESCAPED_LINE_BREAK).Replace(ESCAPED_RETURN, ESCAPED_LINE_BREAK):oldFieldValue;
        if(string.isNotBlank(newFieldValue) && string.isNotBlank(oldFieldValue) && !newFieldValue.equals(oldFieldValue)){
            return true;
        }
        else if(newFieldValue != oldFieldValue){
            return true;
        }
        else
        return false;
    }

    /**
     * @Author: Eternus Solutions
     * @description : Method to create and return Instance of HistoryWrapper Class.
     * @Param : it takes updated field's old value and new value,record Id,
     *         ModifiedById, userName, Action as string And ModifiedDate as DateTime.
     * @Return : It returns HistoryWrapper Class's instance.
     * @Date:3/3/2016
     **/
    public static UFHT.HistoryWrapper getHistoryWrapperInstance(String selectedField, String oldValue, String newValue,
                                                    String recordID, String ModifiedById, dateTime modifiedDate)
    {
        UFHT.HistoryWrapper objHW;
        if(setRelationshipFields.contains(selectedField)){
                oldValue = (mapIdVsRecordName.containsKey(oldValue))?mapIdVsRecordName.get(oldValue) : oldValue;
                NewValue = (mapIdVsRecordName.containsKey(NewValue))?mapIdVsRecordName.get(NewValue) : NewValue;
                objHW = new HistoryWrapper(oldValue, newValue, recordID, ModifiedById, modifiedDate);
        }
        else{
            objHW = new UFHT.HistoryWrapper(oldValue, newValue, recordID, ModifiedById, modifiedDate);
        }
        return objHW;
    }
    
    /**
     * @Author: Eternus Solutions
     * @description : Method to get Attachments related to Ultra Track Container records .
     * @Param : it take the id list of Ultra Track Container object.
     * @Return :  it returns map of ID and attachment.
     * @Date:3/3/2016
     **/
    public map<Id,Attachment> getAttachmentsRelatedToUTC(List<ID> utcIdList){
       map<ID,Attachment> mapIdAttachment = new map<ID,Attachment>();
       if(!utcIdList.isEmpty()){
           for(Attachment a : [SELECT id, parentid, body, bodyLength, Name 
                               FROM Attachment 
                               WHERE parentid 
                               IN :utcIdList 
                               AND Name like :system.Label.AttachmentFileName + PERCENT_SIGN
                               AND bodyLength < : MAX_BODY_LENGTH
                               order by LastModifiedDate Desc])
           {
               if(!a.Name.contains(END_DATE_PREFIX)) {
                  mapIdAttachment.put(a.parentid,a);
                  break;
                }
           }
       }
       return mapIdAttachment;
    }
    /**
     * @Author: Eternus Solutions
     * @description : Method to find relationship fields and related objects.
     * @Param : String as object name and list of tracking enabled fileds.
     * @Return : It returns map of relationship field name VS list of related object.
     * @Date:11/05/2016
     **/
    public static set<String> getRelationshipFields(String strObjectName, list<String> listSelectedFields){
        set<String> setRelationshipFieldsName = new set<String>();
        if(String.isNotBlank(strObjectName) && !listSelectedFields.isEmpty()){
            if(mapObjects.containsKey(strObjectName)){
                mapFields = mapObjects.get(strObjectName).getDescribe().Fields.getMap();
                for(String selectedField : listSelectedFields){
                   if(mapFields.containsKey(selectedField) && !mapFields.get(selectedField).getDescribe().getReferenceTo().isEmpty()){
                       setRelationshipFieldsName.add(selectedField);
                   } 
                }
             }
         }
        return setRelationshipFieldsName;
     }
    /**
     * @Author: Eternus Solutions
     * @description : Method to get Parent id's  of relationship fields from trigger.new and trigger.old. 
     * @Param : map of relationship field name VS list of related objects, trigger.new, trigger.old
     * @Return : It returns set of all parentID's.
     * @Date:11/05/2016
     **/
    public static set<ID> getAllParentRecordIds(set<String> setRelationshipFieldsName,
                                                map<id,SObject> mapNewRecords,
                                                map<id,SObject> mapOldRecords){
        set<ID> setParentID = new set<ID>();
        if(!setRelationshipFieldsName.isEmpty()){
            for(String strRelationshipField : setRelationshipFieldsName){
                for (sObject record : mapNewRecords.values()){
                    if(mapIdVsRecordFields.containsKey(record.ID) && mapIdVsRecordFields.get(record.ID).Contains(strRelationshipField)
                       && mapOldRecords.containsKey(record.id)
                       && record.get(strRelationshipField) != mapOldRecords.get(record.id).get(strRelationshipField))
                    {
                       if(String.isNotBlank(String.valueOf(record.get(strRelationshipField)))){
                           setParentID.add(String.valueOf(record.get(strRelationshipField))); // add new parent id
                       }
                       if(String.isNotBlank(String.valueOf(mapOldRecords.get(record.id).get(strRelationshipField)))){
                           setParentID.add(String.valueOf(mapOldRecords.get(record.id).get(strRelationshipField))); //add old parent id
                       }
                   }
                }
            }
        }
        return setParentID;
    }
     /**
      * @Author: Eternus Solutions
      * @description : Method to get the ID VS recordName to display Lookup field name instead of ID. 
      * @Param : set of parentId's.
      * @Return : It returns the map of ID VS recordName.
      * @Date:11/05/2016
      **/
    public static map<ID,String> getIdVsRecordNameMap(set<ID> setParentId){
        map<String,String> mapRequiredKeyPrefix = new map<String,String>();
        List<sObject> lstSobj = new List<sObject>();
        map<ID,String> mapRecordIdVsName = new map<ID,String>();
        String query=EMPTY_STRING;
        
        if(!setParentId.isEmpty()){
            for(String parentId : setParentId){
                if(String.isNotBlank(parentId)){
                    mapRequiredKeyPrefix.put(parentId.substring(0,3),parentId);
                }
            }
            if(!mapRequiredKeyPrefix.values().isEmpty()){
                for(String strKeyPrefix : mapRequiredKeyPrefix.values()){
                   ID parentID = strKeyPrefix;
                   String sObjName = parentID.getSObjectType().getDescribe().getName();
                   string fieldName = UltraTrackUtilityClass.getNameUniqueField(sObjName);
                   query = QUERY_SELECT + WHITE_SPACE + ID_FIELD + COMMA + WHITE_SPACE + fieldName + WHITE_SPACE + QUERY_FROM + WHITE_SPACE + sObjName + WHITE_SPACE + QUERY_WHERE + WHITE_SPACE + ID_FIELD + WHITE_SPACE + QUERY_IN + COLON + WHITE_SPACE + QUERY_SET_PARENTIDS;
                   try{
                      lstSobj =  Database.query(query);
                   }
                   catch(Exception e){
                   }
                   if(!lstSobj.isEmpty()){
                       for(sObject sObj : lstSobj){
                           mapRecordIdVsName.put((ID)sObj.get(ID_FIELD),String.valueOf(sObj.get(fieldName)));
                       }
                   }
                }
            }
        }
        return mapRecordIdVsName;
    }
}