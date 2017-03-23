/**
 * @Class Name: ViewDataServiceHandler  
 * @Description: This is handler of ViewDataService to fetch history records for an selected object, data range and logged in user. 
 * ========================================================================================================================
 *       Version   | Date        | Author             | Comments
 * -------------------------------------------------------------------------------------------------------------------------
 *       1.0       | 28-07-2016  | Eternus Solution   | 1.Created the class for above functionality
 * ========================================================================================================================
 **/
public class ViewDataServiceHandler {
    
    static final string False_Const = 'false';
    static final string True_Const = 'true';
    static final string Contact_Const = 'Contact';
    static final string DefaultAccountAccess_Const = 'DefaultAccountAccess';
    static final string Edit_Const = 'Edit';
    static final string None_Const = 'None';
    static final string Private_Const = 'Private';
    static final string Read_Const = 'Read';
    static final string All_Const = 'All';
    static final string Organization_Const = 'from Organization';
    static final string ControlledByParent_Const = 'ControlledByParent';
    static final string DateFormat1_Const = 'YYYY/MM/dd HH:mm:ss';
    static final string DateFormat2_Const = 'MM/dd/yyyy hh:mm a';
    /**
     * @Author: Eternus Solutions
     * @description : Method returns json string of history records as per parameters.
     * @Param : selectedTrackedFieldList list of tracked fields
     *          ultraTrackWrapperMap map of Ultrac Track wrapper
     *          selectedObjectId Id of Ultra Track Container object.
     *          startDateStr, endDateStr Date range for history records to be fetched
     *          viewUserFilterList to check if logged in user is system admin or not.
     * @Return : 
     * @Date: 28-07-2016
     **/
    public static string getSharedHistroyRecordsForAnObject(list<string> selectedTrackedFieldList, 
                                                            map<string,List<HistoryWrapper>> ultraTrackWrapperMap,
                                                            string selectedObject,
                                                            Date startDate,
                                                            Date endDate,
                                                            boolean viewUserFilterList) {
        
        map<ID,list<FieldNameAndWrapper>> recordIdVsAllUltraTrackWrapperMap = new map<ID,list<FieldNameAndWrapper>>();
        list<DisplayHistoryWrapper> displayAllHistoryWrapperList = new list<DisplayHistoryWrapper>();
        list<DisplayHistoryWrapper> filterHistoryWrapperList = new list<DisplayHistoryWrapper>();
        set<Id> recordIdSet = new set<Id>();
        map<Id, String> IdVsAccountNameMap = new map<Id, String>();
        map<Id, Id> IdVsOwnerIdMap = new map<Id, Id>();
        map<Id, set<string>> recordIdVsFieldNameMap = new map<Id, set<string>>();
        map<String,String> mapFieldsAndLabels = new map<String,String> ();
        map <Id, set<Id>> recordIdVsUserOrGroupIdSetMap = new map <Id, set<Id>>(); 
        map<Id, Set<Id>> userIdVsAllManagerIdMap = new map<Id, Set<Id>>();
        map <Id, User> userIdVsUserMap = new map <Id, User>();
        DateTime newDateTime;
        Date modifiedOnDate;
        UltraTrackUtilityClass utilityObj = new UltraTrackUtilityClass();
        userIdVsUserMap.putAll(UltraTrackUtilityClass.userIdVsUserMap);
        mapFieldsAndLabels = utilityObj.getFieldNamesAndLabels(selectedObject);
        new UltraTrackUtilityClass();

        if(!selectedTrackedFieldList.isEmpty()) {
            
               for(string fieldName : selectedTrackedFieldList){
                   if(ultraTrackWrapperMap.containsKey(fieldName)) {
                         list<HistoryWrapper> historyWrapperList = ultraTrackWrapperMap.get(fieldName);
                         string fieldLabel = mapFieldsAndLabels.get(fieldName);
                         Schema.DisplayType fieldType = UltraTrackUtilityClass.getFieldType(selectedObject, fieldName);
                         historyWrapperList.sort();
                         for(HistoryWrapper objWrapper : historyWrapperList){
                            newDateTime = getDateTimeForUserTimeZone(objWrapper.ModifiedDateTime);
                            if(newDateTime.format().contains(','))  {
                                modifiedOnDate = date.parse(newDateTime.format().split(',')[0]);
                            }
                            else {
                                 modifiedOnDate = date.parse(newDateTime.format().split(' ')[0]);
                            }
                             if(recordIdVsAllUltraTrackWrapperMap.containsKey(objWrapper.parentId)) {
                                if(startDate != null || endDate != null) {
                                    if(checkStartEndDateRange(modifiedOnDate, startDate, endDate)) {
                                        if(fieldType == Schema.DisplayType.Date
                                        || fieldType == Schema.DisplayType.DateTime) {

                                            objWrapper.oldValue =
                                                getFormattedDateFieldValue(objWrapper.oldValue, fieldType);
                                            objWrapper.newValue =
                                                getFormattedDateFieldValue(objWrapper.newValue, fieldType);
                                        }

                                        recordIdVsAllUltraTrackWrapperMap.get(objWrapper.parentId).add(new FieldNameAndWrapper(fieldName, fieldLabel, objWrapper));
                                    }
                                }
                                else {
                                    recordIdVsAllUltraTrackWrapperMap.get(objWrapper.parentId).add(new FieldNameAndWrapper(fieldName, fieldLabel, objWrapper));
                                }
                             }
                             else{
                                if(startDate != null || endDate != null) {
                                    if(checkStartEndDateRange(modifiedOnDate, startDate, endDate)) {
   
                                        recordIdVsAllUltraTrackWrapperMap.put(objWrapper.parentId,
                                                                   new list<FieldNameAndWrapper>{new FieldNameAndWrapper(fieldName, fieldLabel, objWrapper)});
                                    }
                                }
                                else {
                                    recordIdVsAllUltraTrackWrapperMap.put(objWrapper.parentId,
                                                                new list<FieldNameAndWrapper>{new FieldNameAndWrapper(fieldName, fieldLabel, objWrapper)});
                                }
                                 
                             }
                         }
                    }
               }
           }
           if(!recordIdVsAllUltraTrackWrapperMap.isEmpty()) {
               
               string query;
               set<Id> sObjectIdSet = recordIdVsAllUltraTrackWrapperMap.keySet();
               list<sObject> sObjectList = new list<sObject>();
               
               string fieldName = UltraTrackUtilityClass.getNameUniqueField(selectedObject);
               
               query = 'SELECT Id, LastModifiedById, '+fieldName;
               query += ' FROM '+ selectedObject;
               query += ' WHERE Id IN: sObjectIdSet';
               query += ' ORDER by '+fieldName ;
               sObjectList = Database.query(query);
               
               
               if(!sObjectList.isEmpty()) {
                    for(sObject Objct : sObjectList) {
                        IdVsAccountNameMap.put((Id)Objct.get('Id'), (string)Objct.get(fieldName));
                        IdVsOwnerIdMap.put((Id)Objct.get('Id'), (Id)Objct.get('LastModifiedById'));
                    }
               }
               IdVsAccountNameMap.remove(null);
               for(Id recordId : recordIdVsAllUltraTrackWrapperMap.keySet()) {
                    for(FieldNameAndWrapper fieldAndHistoryObj : recordIdVsAllUltraTrackWrapperMap.get(recordId)) {
                        newDateTime = getDateTimeForUserTimeZone(fieldAndHistoryObj.historyWrapperObj.ModifiedDateTime);
                            if(IdVsAccountNameMap.containsKey(Id.valueOf(fieldAndHistoryObj.historyWrapperObj.parentId))) {
                                displayAllHistoryWrapperList.add(new DisplayHistoryWrapper(fieldAndHistoryObj.historyWrapperObj.parentId,
                                                                                           IdVsAccountNameMap.get(Id.valueOf(fieldAndHistoryObj.historyWrapperObj.parentId)),
                                                                                           newDateTime.format(),
                                                                                           newDateTime.format(DateFormat1_Const),
                                                                                           userIdVsUserMap.get(fieldAndHistoryObj.historyWrapperObj.ModifiedById).Name,
                                                                                           fieldAndHistoryObj.historyWrapperObj.ModifiedById,
                                                                                           fieldAndHistoryObj.fieldLabel,
                                                                                           fieldAndHistoryObj.fieldName,
                                                                                           fieldAndHistoryObj.historyWrapperObj.oldValue,
                                                                                           fieldAndHistoryObj.historyWrapperObj.newValue
                                                                                           ));
                           }
                     }
                }

            }
           return (getHistoryRecordsAsPerUser(selectedObject,
                                            viewUserFilterList,
                                            displayAllHistoryWrapperList,
                                            IdVsAccountNameMap,
                                            IdVsOwnerIdMap
                                            ));
     }
     
     /**
     * @Author: Eternus Solutions
     * @description : Method returns json string of history records as per parameters.
     * @Param : selectedObjectId Id of Ultra Track Container object.
     *          viewUserFilterList to check if logged in user is system admin or not.
     *          displayAllHistoryWrapperList list of all history records
     *          IdVsAccountNameMap map of record Id Vs record name 
     *          IdVsOwnerIdMap map of record Id Vs record owner Id
     * @Return : Json string
     * @Date: 28-07-2016
     **/
     public static string getHistoryRecordsAsPerUser(string selectedObject,
                                               boolean viewUserFilterList,
                                               list<DisplayHistoryWrapper> displayAllHistoryWrapperList,
                                               map<Id, String> IdVsAccountNameMap,
                                               map<Id, Id> IdVsOwnerIdMap
                                               ) {
        list<DisplayHistoryWrapper> filterHistoryWrapperList = new list<DisplayHistoryWrapper>();
        map <Id, set<Id>> recordIdVsUserOrGroupIdSetMap = new map <Id, set<Id>>(); 
        map<Id, Set<Id>> userIdVsAllManagerIdMap = new map<Id, Set<Id>>();
        string JsonResult;
        if(string.isNotBlank(selectedObject)) {
            if(viewUserFilterList) {
                filterHistoryWrapperList.addAll(displayAllHistoryWrapperList);
            }
            else {
                new UltraTrackUtilityClass();
                string objectOwd, objectAccess;
                objectOwd = '';
                map<boolean, list<string>> owdMap = UltraTrackUtilityClass.getOwdForAnObject(selectedObject);
                if(owdMap.containsKey(true)) {
                    recordIdVsUserOrGroupIdSetMap = UltraTrackUtilityClass.getSharing(owdMap.get(true), IdVsAccountNameMap.keySet());
                    if(owdMap.get(true)[2] == False_Const) {
                        if(Standard_Objects__c.getValues(selectedObject) != null) {
                            string organiztionFieldName = Standard_Objects__c.getValues(selectedObject).Organization_Field_Name__c;
                            string query;
                            query = 'select Id, ';
                            if(selectedObject.contains(Contact_Const)) {
                                query += DefaultAccountAccess_Const +', '+organiztionFieldName + ' '+Organization_Const ;
                            }
                            else 
                                query += organiztionFieldName +' ' + Organization_Const ;
                            sobject organizationObj = database.query(query);
                            objectAccess = (string)organizationObj.get(organiztionFieldName);
   
                            if(objectAccess.contains(ControlledByParent_Const)) {
                                objectOwd = (string)organizationObj.get(DefaultAccountAccess_Const);
                                if(objectOwd.contains(Edit_Const))
                                   objectOwd = Edit_Const;
                                else if(objectOwd.contains(None_Const))
                                   objectOwd = Private_Const;
                                else
                                   objectOwd = Read_Const;
                            }
                            else if(objectAccess.contains(Edit_Const) || objectAccess.contains(All_Const)) {
                                objectOwd = Edit_Const;
                            }
                            else if(objectAccess.contains(None_Const)) {
                                objectOwd = Private_Const;
                            }
                            else 
                                objectOwd = Read_Const;
                        }
                    }
                    if(owdMap.get(true)[2] == True_Const || (objectOwd.contains(Private_Const) && UltraTrackUtilityClass.objMap.get(selectedObject).getDescribe().isAccessible())) {
                        set<Id> ownerIdSet = new set<Id> (IdVsOwnerIdMap.values());
                        userIdVsAllManagerIdMap = UltraTrackUtilityClass.getAllManagerForUser(ownerIdSet);
                        if(!userIdVsAllManagerIdMap.isEmpty()) {
                            for(Id recordId : IdVsOwnerIdMap.keySet()) {
                                if(recordIdVsUserOrGroupIdSetMap.containsKey(recordId)) {
                                    recordIdVsUserOrGroupIdSetMap.get(recordId).addAll(userIdVsAllManagerIdMap.get(IdVsOwnerIdMap.get(recordId)));
                                }
                                else {
                                    recordIdVsUserOrGroupIdSetMap.put(recordId, userIdVsAllManagerIdMap.get(IdVsOwnerIdMap.get(recordId)));
                                }
                            }
                        }
                        for(DisplayHistoryWrapper obj : displayAllHistoryWrapperList) {
                            if(UserInfo.getUserId() == IdVsOwnerIdMap.get(obj.parentId)) {
                                filterHistoryWrapperList.add(obj);
                            }
                            else if(recordIdVsUserOrGroupIdSetMap.get(obj.parentId) != null &&
                                    recordIdVsUserOrGroupIdSetMap.get(obj.parentId).contains(UserInfo.getUserId())) {
                                 filterHistoryWrapperList.add(obj);
                            }
                        }
                        
                    }
                }
                if((owdMap.containsKey(false) && owdMap.get(false)[0] == True_Const  ) || 
                   ((objectOwd.contains(Edit_Const) ||  objectOwd.contains(Read_Const)) &&
                    UltraTrackUtilityClass.objMap.get(selectedObject).getDescribe().isAccessible())) {
                        for (DisplayHistoryWrapper obj : displayAllHistoryWrapperList) {
                             filterHistoryWrapperList.add(obj);
                        }
                }
                
            }      
           }
           if(!filterHistoryWrapperList.isEmpty()) {
                JsonResult = JSON.serialize(filterHistoryWrapperList);
           }
           return JsonResult;
    }

     /**
        * @Author: Eternus Solutions
        * @description :  Method to get datetime for passed string in user tiemzone.
        * @Param :
        * @Return : DateTime.
        * @Date:26/05/2016
    */
    public static DateTime getDateTimeForUserTimeZone(string dateTimeString) {
        if(String.isBlank(dateTimeString)) {
            return null;
        }
        List<string> sliptStr = dateTimeString.split(' ');
        if(sliptStr.size() == 2) {
            list<string> dateStr = sliptStr[0].contains('/') ? sliptStr[0].split('/') : sliptStr[0].split('-');
            list<string> timeStr = sliptStr[1].split(':');
            DateTime newDateTime;
            if(sliptStr[0].contains('/')) {
                newDateTime = DateTime.newInstanceGmt(Integer.valueOf(dateStr[2]), 
                                                   Integer.valueOf(dateStr[0]), 
                                                   Integer.valueOf(dateStr[1]), 
                                                   Integer.valueOf(timeStr[0]), 
                                                   Integer.valueOf(timeStr[1]), 
                                                   0);
            } else if(sliptStr[0].contains('-')) {
                newDateTime = DateTime.newInstanceGmt(Integer.valueOf(dateStr[0]), 
                                                   Integer.valueOf(dateStr[1]), 
                                                   Integer.valueOf(dateStr[2]), 
                                                   Integer.valueOf(timeStr[0]), 
                                                   Integer.valueOf(timeStr[1]), 
                                                   0);
            }
            return newDateTime;
        }
        return null;
    }
    
    /**
        * @Author: Eternus Solutions
        * @description : Method to check modified date of record should be in range.
        * @Param :
        * @Return : boolean
        * @Date:15/11/2015
    */
    @TestVisible private static boolean checkStartEndDateRange(Date modifiedDateTime, Date startDate, Date endDate) {
        boolean flag = false;
        if(startDate != null && endDate != null) {
            if(modifiedDateTime >= startDate && modifiedDateTime <= endDate) {
                flag = true;
            }
        }
        else if(startDate != null && endDate == null) {
            if(modifiedDateTime >= startDate) {
                flag = true;
            }
        }
        else if(startDate == null && endDate != null) {
            if(modifiedDateTime <= endDate) {
                flag = true;
           }
        }
        return flag;
    }
    
     /**
        * @Author: Eternus Solutions
        * @description : DisplayHistoryWrapper class to display records.
        * @Param :  
        * @Return :  
        * @Date:15/11/2015
    */ 

    public class DisplayHistoryWrapper {
        
        public Id parentId;
        public string recordName ;
        public string modifiedDisplayTime ;
        public string modifiedTime ;
        public string modifiedByName ;
        public string modifiedById;
        public string fieldLabel ;
        public string fieldName ;
        public string oldValue ;
        public string newValue ;
        
        public DisplayHistoryWrapper(Id parentId,
                                     string recordName, 
                                     string modifiedDisplayTime,
                                     string modifiedTime, 
                                     string modifiedByName, 
                                     string modifiedById, 
                                     string fieldLabel, 
                                     string fieldName,
                                     string oldValue,
                                     string newValue 
                                     ) {
            this.parentId = parentId;
            this.recordName = recordName;
            this.modifiedDisplayTime = modifiedDisplayTime;
            this.modifiedTime = modifiedTime;
            this.modifiedByName = modifiedByName;
            this.modifiedById = modifiedById;
            this.fieldLabel = fieldLabel;
            this.fieldName =fieldName ;
            this.oldValue = oldValue;
            this.newValue = newValue;
        } 
    }
    
     /**
        * @Author: Eternus Solutions
        * @description : FieldNameAndWrapper wrapper class to hold History record along with Fieldname. 
        * @Param :
        * @Return : 
        * @Date:26/05/2016
    */
    public class FieldNameAndWrapper {
        
        public string fieldLabel;
        public string fieldName;
        public HistoryWrapper historyWrapperObj;
        
        public FieldNameAndWrapper(string fieldName, string fieldLabel, HistoryWrapper historyWrapperObj) {
            this.fieldName = fieldName;
            this.fieldLabel = fieldLabel;
            this.historyWrapperObj = historyWrapperObj;
        }
    }
    /**
        * @Author: Eternus Solutions
        * @description :  Method to format date / date-time value.
        * @Param :
        * @Return : DateTime.
        * @Date:26/05/2016
    */
    public static String getFormattedDateFieldValue(string fieldValue, Schema.DisplayType fieldType) {

        DateTime temp_DateTimeInstance = getDateTimeForUserTimeZone(fieldValue);
        String formattedDate;
        if (temp_DateTimeInstance == null)
            return fieldValue;

        if(fieldType == Schema.DisplayType.Date) {
            formattedDate = temp_DateTimeInstance.date().format();
        } else if(fieldType == Schema.DisplayType.DateTime) {
            formattedDate = temp_DateTimeInstance.format(DateFormat2_Const , UserInfo.getTimeZone().getId());
        }

        return formattedDate;
    }
}