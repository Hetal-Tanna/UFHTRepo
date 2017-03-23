/**
 * Class Name: UltraTrackUtilityClass
 * @Description: Utility class for describe call.   
 * ============================================================================================
 *       Version   | Date        | Author             | Comments
 *   ------------------------------------------------------------------------------------------
 *       1.0       | 29-02-2016  | Eternus Solution   | 1.added getFieldNamesAndLabels, 
 *                                                    | getFieldNamesAndLabels, displayMessages Method
 * --------------------------------------------------------------------------------------------
 *       2.0       | 06-04-2016  | Eternus Solution   | 1. Added getOwdForAnObject, getSharing,
 *                                                    | getSubGroupDetails, getAllSubRoleIds, 
 *                                                    | getAllManagerForUser, getStartAndEndDateForFilter
 *                                                    | getNameUniqueField method    
 *  ===========================================================================================
 **/
 public without sharing class UltraTrackUtilityClass{
    //Map to hold the object name and it's sobject Type
    public static map<String, Schema.SObjectType> objMap {get{if(objMap == null) 
                                                       objMap =  Schema.getGlobalDescribe();
                                                       return objMap;} private set;}
    public static map <Id, User> userIdVsUserMap = new map <Id, User>();
    private static  Map<String, Schema.SObjectField>  sobjectSchemaMap;
    static final string Parent_ID_Const = 'ParentId';
    static final string Share_Const = 'share';
    static final string UserORGroupId_Const = 'UserOrGroupId';
    static final string True_Const = 'true';
    static final string False_Const = 'false';
    static final string RoleAndSubordinate_Const = 'RoleAndSubordinatesInternal';
    static final string Role_Const = 'Role';
    static final string LastMonth_Const = 'Last Month';
    static final string ThisMonth_Const = 'This Month';
    static final string ThisWeek_Const = 'This Week';
    static final string LastWeek_Const = 'Last Week';
    static final string Today_Const = 'Today';
    static final string CurrentPreviousMonth_Const = 'Current and Previous Month';
    static final string Yesterday_Const = 'Yesterday';
    static final string Last_Const = 'Last';
    static final string Day_Const = 'Day';
    static final string MASK_TYPE_ALL = 'all';
    static final string MASK_TYPE_LASTFOUR = 'lastFour';
    static final string MASK_TYPE_CREDIT = 'creditCard';
    static final string MASK_TYPE_NINO = 'nino';
    static final string MASK_TYPE_SSN = 'ssn';
    static final string MASK_TYPE_SIN = 'sin';
    static final string ID = 'Id';
    static final string QUERY_SELECT = 'SELECT';
    static final string COMMA = ',';
    static final string WHITE_SPACE = ' ';
    static final string USER_OR_GROUP_ID = 'UserOrGroupId';
    static final string QUERY_FROM = 'FROM';
    static final string QUERY_WHERE = 'WHERE';
    static final string QUERY_IN = 'IN';
    static final string COLON = ':';
    static final string VAR_SOBJECTIDSET = 'sObjectIdSet';
    static final string ATTRIBUTES = 'attributes';
    static final string PERCENT_SIGN = '%';
    static final string CURRENCY_ISO_CODE = 'CurrencyIsoCode';
    
    public UltraTrackUtilityClass() {
        objMap = Schema.getGlobalDescribe();
        for(User userObj : [select Id, ManagerId, Name
                           from User]) {
             userIdVsUserMap.put(userObj.Id, userObj);                
        }
    }
    
    /**
      * @Author: Eternus Solutions
      * @description : Method to get OWD for an object
      * @Param : selectedObject object for which method return OWD.
      * @Return : map<boolean, list<string>> 
      * @Date:6/4/2016
      **/ 
   public static map<boolean, list<string>> getOwdForAnObject(String selectedObject) {
        map<boolean, list<string>> result = new map<boolean, list<string>>();
        string objectShareName, parentCustomStandard;
        if( !objMap.containsKey(selectedObject) ) {
            return result;
        }
        Schema.DescribeSObjectResult describeSObjectResultObj = objMap.get(selectedObject).getDescribe();
        boolean isCustom = describeSObjectResultObj.isCustom();
        if(isCustom){
           objectShareName = selectedObject.substring(0, selectedObject.length() - 1) + Share_Const;
           parentCustomStandard = Parent_ID_Const;
        }
        else{ 
            objectShareName = selectedObject + Share_Const;
            parentCustomStandard = selectedObject + ID;    
        }  
        if(objMap.containsKey(objectShareName)) {
            result.put(true , new list<string> {objectShareName, parentCustomStandard, isCustom ? True_Const : False_Const});
        }
        else {
            result.put(false , new list<string> {describeSObjectResultObj.isAccessible() ? True_Const : False_Const});
        }
        return result;
    }
    
    /**
     * @Author: Eternus Solutions
     * @description : Method to get users who access to a records.
     * @Param : objectDetails details regarding objects
     *          sObjectIdSet records Id
     * @Return :  map <Id, set<Id> allUsers who have access to record Id
     * @Date: 6/4/2016
     **/ 
    public static map <Id, set<Id>> getSharing(list<string> objectDetails, set<Id> sObjectIdSet) {
        
        map<Id, set<Id>> recordIdVsUserOrGroupIdSetMap = new map<Id, set<Id>>();
        set<Id> groupIdSet = new set<Id>();
        String userType = Schema.SObjectType.User.getKeyPrefix(); 
        String groupType = Schema.SObjectType.Group.getKeyPrefix();
        string query;
        map<Id, set<Id>> recordIdVsUserIdSetDummyMap = new map<Id, set<Id>>();
        
        if( !(objectDetails.size() >= 3) ) {
            return recordIdVsUserIdSetDummyMap;
        }
        string objectShareName = objectDetails[0];
        string parentCustomStandard = objectDetails[1];
        boolean isCustom = True_Const.equalsIgnoreCase(objectDetails[2]) ? true : false;
        
        query = QUERY_SELECT + WHITE_SPACE + ID + COMMA + WHITE_SPACE + USER_OR_GROUP_ID + COMMA + WHITE_SPACE + parentCustomStandard;
        query += WHITE_SPACE + QUERY_FROM + WHITE_SPACE + objectShareName;
        query += WHITE_SPACE + QUERY_WHERE + WHITE_SPACE + parentCustomStandard + WHITE_SPACE + QUERY_IN
               + COLON + WHITE_SPACE + VAR_SOBJECTIDSET;
        
        for(sObject Objct : Database.query(query)) {
            Id parentId;
            if(isCustom) {
               parentId = (Id)Objct.get(Parent_ID_Const);
            }
            else {
               parentId = (Id)Objct.get(parentCustomStandard);
            }
            string userOrGroupId = (Id)Objct.get(UserORGroupId_Const);
            if(recordIdVsUserOrGroupIdSetMap.containsKey(parentId)) {
               recordIdVsUserOrGroupIdSetMap.get(parentId).add(userOrGroupId);
            }       
            else {
               recordIdVsUserOrGroupIdSetMap.put(parentId, new set<Id>{userOrGroupId});
            }
            if(((string)userOrGroupId).startsWith(groupType)) {
               groupIdSet.add(userOrGroupId);
            }
        }
        
        map <Id, set<Id>> groupDetailMap = getSubGroupDetails(groupIdSet);

        for(Id parentRecordId : recordIdVsUserOrGroupIdSetMap.keySet()) {
        //substitute with respective values here  
            set<Id> userOrGroupId = new set<Id>();
            for(Id idObj : recordIdVsUserOrGroupIdSetMap.get(parentRecordId)) {
                if(((string)idObj).startsWith(groupType)){
                    userOrGroupId.addAll(groupDetailMap.get(idObj));
                }
                else {
                    userOrGroupId.add(idObj);
                }
            }
            recordIdVsUserIdSetDummyMap.put(parentRecordId, userOrGroupId);
        }

        return recordIdVsUserIdSetDummyMap;
    }
    
    /**
     * @Author: Eternus Solutions
     * @description : Method to get all users belongs to group.
     * @Param : groupIdSet Id's of group
     * @Return :  map <Id, set<Id>> allUsers belongs to a Group
     * @Date:6/4/2016
     **/ 
    @testVisible static map <Id, set<Id>> getSubGroupDetails(set<Id> groupIdSet) {
        
        map <Id, set<Id>> groupIdVsUserIdSetMap = new map <Id, set<Id>>();
        Set<Id> groupIdProxys = new Set<Id>();
        map<Id, set<Id>> groupIdVsSubGroupMap = new map<Id, set<Id>>(); 
        String userType = Schema.SObjectType.User.getKeyPrefix();
        String groupType = Schema.SObjectType.Group.getKeyPrefix();
        String roleType = Schema.SObjectType.UserRole.getKeyPrefix();
        map <Id, list<GroupMember>> groupIdVsGroupMemberMap = new map <Id, list<GroupMember>>();
        Set <Id> groupWithRole = new Set<Id>();
        set<Id> groupWithRoleNSub = new set<Id>();
        map<Id, set<Id>> groupIdVsRoleIdMap = new map<Id, set<Id>>();
        
        
        map<Id, Group> groupDetails = new map<Id, Group> ([select Id, RelatedId, Type
                                                           from Group
                                                           where Id IN : groupIdSet]);                       
        for(GroupMember memberObj : [Select Id, UserOrGroupId, GroupId, Group.type 
                                     From GroupMember 
                                     Where GroupId IN : groupIdSet]) {
                                        
            if(groupIdVsGroupMemberMap.containsKey(memberObj.GroupId)) {
                groupIdVsGroupMemberMap.get(memberObj.GroupId).add(memberObj);
            }
            else
                groupIdVsGroupMemberMap.put(memberObj.GroupId, new list<GroupMember>{memberObj});
        }
                                    
        for(Id groupId : groupIdSet) {
            
            if(groupIdVsGroupMemberMap.containsKey(groupId)) {
                for(GroupMember memberObj: groupIdVsGroupMemberMap.get(groupId)) {
                    if(((String)memberObj.UserOrGroupId).startsWith(userType)) {
                        if(groupIdVsUserIdSetMap.containsKey(memberObj.GroupId)) {
                            groupIdVsUserIdSetMap.get(memberObj.GroupId).add(memberObj.UserOrGroupId);
                        }
                        else {
                            groupIdVsUserIdSetMap.put(memberObj.GroupId, new set<Id> {memberObj.UserOrGroupId});
                        }
                    }
                  
                  //Processing for Nested Group
                    else if (((String)memberObj.UserOrGroupId).startsWith(groupType)) {                   
                    // Call this function again but pass in the group found within this group
                        groupIdProxys.add(memberObj.UserOrGroupId);
                        if(groupIdVsSubGroupMap.containsKey(memberObj.GroupId)) {
                            groupIdVsSubGroupMap.get(memberObj.GroupId).add(memberObj.UserOrGroupId);
                        }
                        else {
                            groupIdVsSubGroupMap.put(memberObj.GroupId, new set<Id> {memberObj.UserOrGroupId});
                        }
                    }
                 } 
            }
            else {
                if(groupDetails.get(groupId) != null && 
                   (groupDetails.get(groupId).relatedid !=null && 
                   ((String)groupDetails.get(groupId).RelatedId).startsWith(roleType) )) {
                    
                    if(groupDetails.get(groupId).type.Contains(Role_Const)) {  
                        groupWithRole.add(groupDetails.get(groupId).RelatedId);
                    }
                    else if(groupDetails.get(groupId).type.contains(RoleAndSubordinate_Const)) {
                        groupWithRoleNSub.add(groupDetails.get(groupId).RelatedId); 
                    }  
                    if(groupIdVsRoleIdMap.containsKey(groupId)) {
                        groupIdVsRoleIdMap.get(groupId).add(groupDetails.get(groupId).RelatedId);
                    }    
                    else {
                        groupIdVsRoleIdMap.put(groupId, new set<Id> {groupDetails.get(groupId).RelatedId});
                    }
               }
          }
        }
        if( !groupWithRoleNSub.isEmpty() ) {
            groupWithRoleNSub.addALL(getAllSubRoleIds(groupWithRoleNSub));
        }
        else if(!groupIdVsRoleIdMap.isEmpty()) {
            Map<Id, set<Id>> users = new Map<Id, set<ID>>();
            for(User obj : [Select Id, Name, UserRoleId
                            From User 
                            where (UserRoleId IN :groupWithRole 
                            OR UserRoleId IN :groupWithRoleNSub)
                            AND isActive = true]) {
                if(users.containsKey(obj.UserRoleId)) {
                    users.get(obj.UserRoleId).add(obj.Id);
                }   
                else {
                    users.put(obj.UserRoleId, new set<Id>{obj.Id});
                }             
            }
            for(Id groupId : groupIdVsRoleIdMap.keySet()) {
                for(Id roleId : groupIdVsRoleIdMap.get(groupId)) {
                    if(users.containsKey(roleId)) {
                        if(groupIdVsUserIdSetMap.containsKey(groupId)) {
                            groupIdVsUserIdSetMap.get(groupId).addAll(users.get(roleId));
                        }
                        else {
                            groupIdVsUserIdSetMap.put(groupId, new set<Id> (users.get(roleId)));
                        }
                    }
                }
            }
        }
        if(!groupIdProxys.isEmpty()) {
            map <Id, set<Id>> subGroupDetails = getSubGroupDetails(groupIdProxys);
            for(Id groupId : groupIdVsSubGroupMap.KeySet()) {
                for(Id memberId : groupIdVsSubGroupMap.get(groupId)){
                    if(groupIdVsUserIdSetMap.containsKey(groupId)) {
                        groupIdVsUserIdSetMap.get(groupId).addAll(subGroupDetails.get(memberId));
                    }
                    else if(subGroupDetails.containsKey(memberId)){
                        groupIdVsUserIdSetMap.put(groupId, new set<Id> (subGroupDetails.get(memberId)));
                    }  
                }
            }
        }
        return groupIdVsUserIdSetMap;
     }
     
    /**
     * @Author: Eternus Solutions
     * @description : Method to get all sub roles related to role.
     * @Param : roleIds Id's of role
     * @Return :  map <Id, set<Id>> sub roles Id belongs to a Role
     * @Date:6/4/2016
     **/ 
    @testvisible static Set<ID> getAllSubRoleIds(Set<ID> roleIds) {

        Set<ID> currentRoleIds = new Set<ID>();
    
        // get all of the roles underneath the passed roles
        for(UserRole userRole :[select Id 
                                from UserRole
                                where ParentRoleId IN :roleIds 
                                AND ParentRoleID != null 
                                limit 40000])
            currentRoleIds.add(userRole.Id);
    
        // go fetch some more roles!
        if(currentRoleIds.size() > 0)
          currentRoleIds.addAll(getAllSubRoleIds(currentRoleIds));
    
        return currentRoleIds;

     }
     
    /**
     * @Author: Eternus Solutions
     * @description : Method to get all managers related to single user.
     * @Param : userIdSet Id's of user
     * @Return :  map <Id, set<Id>> all managers Id related to single user.
     * @Date: 6/4/2016
     **/ 
     public static map<Id, Set<ID>> getAllManagerForUser(set<Id> userIdSet) {
        set<Id> userIDProxySet = new set<Id>();
        map<Id, Set<ID>> userIdVsAllManagerIdMap = new map<Id, Set<ID>>();
        for(Id userId : userIdSet) {
            integer countVar = 1;
            Id ManagerId = userId;
            do {
                if(userIdVsUserMap.containsKey(ManagerId) && userIdVsUserMap.get(ManagerId).ManagerId != null) {
                    if(userIdVsAllManagerIdMap.containsKey(userId)) {
                        userIdVsAllManagerIdMap.get(userId).add(userIdVsUserMap.get(ManagerId).ManagerId);
                    }
                    else {
                        userIdVsAllManagerIdMap.put(userId, new set<Id>{userIdVsUserMap.get(ManagerId).ManagerId});
                    }
                    ManagerId = userIdVsUserMap.get(ManagerId).ManagerId;
                }
                else if(userIdVsUserMap.containsKey(ManagerId) && userIdVsUserMap.get(ManagerId).ManagerId == null) {
                     break;
                }
            } while(ManagerId != userId);
        }
        return userIdVsAllManagerIdMap;
     }
     
    /**
     * @Author: Eternus Solutions
     * @description : Method to get start and end date for selected date fileter
     * @Param : dateFilter date filter
     * @Return : list<Ultra_Track_Container__c> startDate and endDate objects for selected filter.
     * @Date:6/4/2016
     **/ 
    public static list<Ultra_Track_Container__c> getStartAndEndDateForFilter(string dateFilter) {
         
        list<Ultra_Track_Container__c> startEndDateList = new list<Ultra_Track_Container__c>();
        View_Field_History_Date_Filters__c dateFilterObj = View_Field_History_Date_Filters__c.getValues(dateFilter);
        if(dateFilterObj != null) {
            Ultra_Track_Container__c startDateObj = new Ultra_Track_Container__c();
            Ultra_Track_Container__c endDateObj = new Ultra_Track_Container__c();
            if(dateFilterObj.Name.equals(LastMonth_Const)) {
                Date lastMonthDate = Date.Today().addMonths(-1);
                integer dayOfMonth = Date.daysInMonth(lastMonthDate.year(), lastMonthDate.month());
                startDateObj.DateHolder__c = lastMonthDate.toStartOfMonth();
                endDateObj.DateHolder__c = lastMonthDate.toStartOfMonth().addDays(dayOfMonth - 1);
            }
            else if(dateFilterObj.Name.equals(ThisMonth_Const)) {
                Date currentMonthDate = Date.Today();
                integer dayOfMonth = Date.daysInMonth(currentMonthDate.year(), currentMonthDate.month());
                startDateObj.DateHolder__c = currentMonthDate.toStartOfMonth();
                endDateObj.DateHolder__c = currentMonthDate.toStartOfMonth().addDays(dayOfMonth - 1);
            }
            else if(dateFilterObj.Name.equals(CurrentPreviousMonth_Const)) {
                Date currentMonthDate = Date.Today();
                Date lastMonthDate = Date.Today().addMonths(-1);
                integer dayOfMonth = Date.daysInMonth(currentMonthDate.year(), currentMonthDate.month()) ;
                startDateObj.DateHolder__c = lastMonthDate.toStartOfMonth();
                endDateObj.DateHolder__c = currentMonthDate.toStartOfMonth().addDays(dayOfMonth - 1);
            }
            else if(dateFilterObj.Name.equals(LastWeek_Const)) {
                Date lastWeekDate = Date.Today().addDays(-7);
                startDateObj.DateHolder__c = lastWeekDate.toStartofWeek();
                endDateObj.DateHolder__c = lastWeekDate.toStartofWeek().addDays(6);
            }
            else if(dateFilterObj.Name.equals(ThisWeek_Const)) {
                Date CurrentWeekDate = Date.Today();
                startDateObj.DateHolder__c = CurrentWeekDate.toStartofWeek();
                endDateObj.DateHolder__c = CurrentWeekDate.toStartofWeek().addDays(6);
            }
            else if(dateFilterObj.Name.equals(Today_Const)) {
                startDateObj.DateHolder__c = Date.Today();
                endDateObj.DateHolder__c = Date.Today();
            }
            else if(dateFilterObj.Name.equals(Yesterday_Const)) {
                startDateObj.DateHolder__c = Date.Today().addDays(-1);
                endDateObj.DateHolder__c = Date.Today().addDays(-1);
            }
            else if(dateFilterObj.Month_Week_Day_Filter_Category__c.equals(Day_Const)) {
                if(dateFilterObj.Name.contains(Last_Const)) {
                    startDateObj.DateHolder__c = Date.Today().addDays(Integer.valueOf(dateFilterObj.Value__c));
                    endDateObj.DateHolder__c = Date.Today();
                }
            }

            startEndDateList.add(startDateObj);
            startEndDateList.add(endDateObj);
        }
        
        return startEndDateList;
     }
    
    /**
     * @Author: Eternus Solutions
     * @description : Method to get name field for an object
     * @Param : objectName objectName
     * @Return : return name field for an object
     * @Date:6/4/2016
     **/  
    public static String getNameUniqueField(string objectName) {
        
        String strResult = null;
        if(String.isBlank(objectName) || !objMap.containsKey(objectName)) {
            return strResult;
        }
        Map<String, Schema.SObjectField> mapFields = objMap.get(objectName).getDescribe().Fields.getMap();
        for(Schema.SObjectField objField : mapFields.values()) {
            
            Schema.DescribeFieldResult fieldResult = objField.getDescribe();
            if(fieldResult.isNameField()) {
                strResult = fieldResult.getName();
                break;
            }
        }
        
        if(strResult != null)
            return strResult;
        return strResult;
    }
    /**
     * @Author: Eternus Solutions
     * @description : Method to get the sObject's field names and field labels
     * @Param : it takes string sObject Name as param
     * @Return : It returns map of field name as key and field label as value
     * @Date:29/2/2016
     **/
    public map<String,String> getFieldNamesAndLabels(String sObjectName){
        map<String,String> mapFieldNameAndLabel  = new map<String,String>();
        if(String.isNotBlank(sObjectName) && objMap.containsKey(sObjectName)){
           for(Schema.SObjectField fieldType : objMap.get(sObjectName).getDescribe().fields.getMap().values()){
               if(fieldType.getDescribe().isUpdateable()) {
                   mapFieldNameAndLabel.put(fieldtype.getDescribe().getName(),fieldtype.getDescribe().getLabel());
               }
           }
        }
        return mapFieldNameAndLabel;
    }

    /**
     * @Author: Eternus Solutions
     * @description : Method to get the Schema.DisplayType of specified field
     * @Param : it takes string sObject Name and string Field Name as param
     * Return : It returns Schema.DisplayType of specified field
     * Date:29/2/2016
     **/
    public static Schema.DisplayType getFieldType(String sObjectName, String fieldName){

        if(String.isNotBlank(sObjectName) && objMap.containsKey(sObjectName) && String.isNotBlank(fieldName)){
            if(objMap.get(sObjectName).getDescribe().fields.getMap().get(fieldName) != NULL) {
                return objMap.get(sObjectName).getDescribe().fields.getMap().get(fieldName).getDescribe().getType();
            }
        }
        return null;
    }

    /**
     * @Author: Eternus Solutions
     * @description : Method to update encrypted field to mask hidden characters.
     * @Param : String sObjectName, String fieldName, String oldValue, String newValue.
     * @Return : Array of Strings (array[0] : updatedOldValue, array[1] : updatedNewValue)
     * @Date: 01/07/2016
     **/
    public static List<String> maskEncryptedData(Schema.DescribeFieldResult fieldDescribe, String oldValue, String newValue) {

        Map<String, UFHT__Encrypted_Field_Mask__c> mapMaskType = UFHT__Encrypted_Field_Mask__c.getAll();
        if(fieldDescribe != NULL){

            if(fieldDescribe.getMaskType().equalsIgnoreCase(MASK_TYPE_ALL)) {

                // mask logic for all characters [MAX = ?, Format = <XXX>]
                oldValue = String.isNotBlank(oldValue)
                         ? oldValue.replaceAll(mapMaskType.get(fieldDescribe.getMaskType()).UFHT__RegEx__c, fieldDescribe.getMask())
                         : oldValue;
                newValue = String.isNotBlank(newValue)
                         ? newValue.replaceAll(mapMaskType.get(fieldDescribe.getMaskType()).UFHT__RegEx__c, fieldDescribe.getMask())
                         : newValue;

            } else if(fieldDescribe.getMaskType().equalsIgnoreCase(MASK_TYPE_LASTFOUR)) {

                // mask logic for characters excluding last 4 [MAX = ?, Format = <XXX>12AB]
                oldValue = String.isNotBlank(oldValue)
                         ?   oldValue.substring(0, oldValue.length() - 4).replaceAll(mapMaskType.get(fieldDescribe.getMaskType()).UFHT__RegEx__c, fieldDescribe.getMask())
                           + oldValue.substring(oldValue.length() - 4, oldValue.length())
                         : oldValue;
                newValue = String.isNotBlank(newValue)
                         ?   newValue.substring(0, newValue.length() - 4).replaceAll(mapMaskType.get(fieldDescribe.getMaskType()).UFHT__RegEx__c, fieldDescribe.getMask())
                           + newValue.substring(newValue.length() - 4, newValue.length())
                         : newValue;

            } else if(fieldDescribe.getMaskType().equalsIgnoreCase(MASK_TYPE_CREDIT)) {

                // mask logic for all numbers excluding last 4 [MAX = 16, Format = XXXX-XXXX-XXXX-1111]
                oldValue = String.isNotBlank(oldValue)
                         ?   oldValue.substring(0, oldValue.length() - 4).replaceAll(mapMaskType.get(fieldDescribe.getMaskType()).UFHT__RegEx__c, fieldDescribe.getMask())
                           + oldValue.substring(oldValue.length() - 4, oldValue.length())
                         : oldValue;
                newValue = String.isNotBlank(newValue)
                         ?   newValue.substring(0, newValue.length() - 4).replaceAll(mapMaskType.get(fieldDescribe.getMaskType()).UFHT__RegEx__c, fieldDescribe.getMask())
                           + newValue.substring(newValue.length() - 4, newValue.length())
                         : newValue;

            } else if(fieldDescribe.getMaskType().equalsIgnoreCase(MASK_TYPE_NINO)) {

                // mask logic for all characters [MAX = 9, Format = XX XX XX XX X]
                oldValue = String.isNotBlank(oldValue)
                         ? oldValue.replaceAll(mapMaskType.get(fieldDescribe.getMaskType()).UFHT__RegEx__c, fieldDescribe.getMask())
                         : oldValue;
                newValue = String.isNotBlank(newValue) 
                         ? newValue.replaceAll(mapMaskType.get(fieldDescribe.getMaskType()).UFHT__RegEx__c, fieldDescribe.getMask())
                         : newValue;

            } else if(fieldDescribe.getMaskType().equalsIgnoreCase(MASK_TYPE_SSN)) {

                // mask logic for all numbers excluding last 4 [MAX = 9, Format = XXX-XX-1111]
                oldValue = String.isNotBlank(oldValue)
                         ?   oldValue.substring(0, oldValue.length() - 4).replaceAll(mapMaskType.get(fieldDescribe.getMaskType()).UFHT__RegEx__c, fieldDescribe.getMask())
                           + oldValue.substring(oldValue.length() - 4, oldValue.length())
                         : oldValue;
                newValue = String.isNotBlank(newValue)
                         ?   newValue.substring(0, newValue.length() - 4).replaceAll(mapMaskType.get(fieldDescribe.getMaskType()).UFHT__RegEx__c, fieldDescribe.getMask())
                           + newValue.substring(newValue.length() - 4, newValue.length())
                         : newValue;

            } else if(fieldDescribe.getMaskType().equalsIgnoreCase(MASK_TYPE_SIN)) {

                // mask logic for all numbers excluding last 3 [MAX = 9, Format = XXX-XXX-111]
                oldValue = String.isNotBlank(oldValue)
                         ?   oldValue.substring(0, oldValue.length() - 3).replaceAll(mapMaskType.get(fieldDescribe.getMaskType()).UFHT__RegEx__c, fieldDescribe.getMask())
                           + oldValue.substring(oldValue.length() - 3, oldValue.length())
                         : oldValue;
                newValue = String.isNotBlank(newValue)
                         ?   newValue.substring(0, newValue.length() - 3).replaceAll(mapMaskType.get(fieldDescribe.getMaskType()).UFHT__RegEx__c, fieldDescribe.getMask())
                           + newValue.substring(newValue.length() - 3, newValue.length())
                         : newValue;
            }

            return new List<String> {oldValue, newValue};
        }
        return null;
    }
    

    /**
     * @Author: Eternus Solutions
     * @description : Method to display message on Pages
     * @Param : it takes string Message that to be displyed on page.
     * @Return :
     * @Date:29/2/2016
     **/
    public void displayMessage(ApexPages.severity severity,String message){
        ApexPages.AddMessage(new ApexPages.Message(severity,message));
    }
    /**
     * @Author: Eternus Solutions
     * @description : Method to get fields from record
     * @Param : Method have 2 parameters 
     *          1.record of trigger.new
     *          2.record of trigger.old.
     * @Return : returns set of fields. 
     * @Date: 06/06/2016
     **/
    public static set<string> getFields(SObject newRecord, SObject oldRecord){
        set<string> setPresentFields = new set<string>();
        String strNewRecords = JSON.serialize(newRecord);
        String strOldRecords = JSON.serialize(oldRecord);
        
        Map<String,Object> mapNewRecordsFields = (Map<String,Object>) JSON.deserializeUntyped(strNewRecords);
        Map<String,Object> mapOldRecordsFields = (Map<String,Object>) JSON.deserializeUntyped(strOldRecords);
        
        setPresentFields.addAll(mapNewRecordsFields.keyset().clone());
        setPresentFields.addAll(mapOldRecordsFields.keyset().clone());
        
        setPresentFields.remove(ATTRIBUTES);
        return setPresentFields;
    }
    
    /**
     * @Description : A method set value if field type is currency, percent or encrypted text.
     * @Input       : 
     * @Output      :
     **/
    public static List<String> checkCurrencyOrPercentField(string ObjectName, String sObjectFieldName, String oldValue, String newValue){
    
         sobjectSchemaMap = getFieldType(ObjectName);
         sObject sObjectName = Schema.getGlobalDescribe().get(ObjectName).newSObject() ;
         List<String> updatedValues = new List<String>();

         if(sobjectSchemaMap.containsKey(sObjectFieldName)) {

             Schema.DescribeFieldResult fieldDescribe = sobjectSchemaMap.get(sObjectFieldName).getDescribe();

             if(fieldDescribe.getType() == Schema.DisplayType.Currency) {
                  updatedValues.add(String.isNotBlank(oldValue) ? getCurrencySymbol(sObjectName) + WHITE_SPACE + oldValue : oldValue);
                  updatedValues.add(String.isNotBlank(newValue) ? getCurrencySymbol(sObjectName) + WHITE_SPACE + newValue : newValue);

             } else if(fieldDescribe.getType() == Schema.DisplayType.Percent) {
                  updatedValues.add(String.isNotBlank(oldValue) ? oldValue + PERCENT_SIGN : oldValue);
                  updatedValues.add(String.isNotBlank(newValue) ? newValue + PERCENT_SIGN : newValue);

             } else if(fieldDescribe.getType() == Schema.DisplayType.EncryptedString) {
                  updatedValues = maskEncryptedData(fieldDescribe, oldValue, newValue);
             }
             return updatedValues;
         } else {
            return null;
         }
    }

    /**
     * @Description : A method get the Map of Field for specific sObject
     * @Input       :
     * @Output      :
     **/
    public static Map<String, Schema.SObjectField>  getFieldType(string sObjectName){
        if(String.isNotBlank(sObjectName) && Schema.getGlobalDescribe().containsKey(sObjectName)) {
            return Schema.getGlobalDescribe().get(sObjectName).getDescribe().fields.getMap();
        }
        return null;
   }
    /**
     * @Description : A method to get the Currency Code 
     * @Input       :
     * @Output      :
     **/
    public static String getCurrencyIsoCode(SObject genericSObject){
        String currencyIso = UserInfo.isMultiCurrencyOrganization() ? (String) genericSObject.get(CURRENCY_ISO_CODE) : UserInfo.getDefaultCurrency();
        return currencyIso;
    } 
    /**
     * @Description : A method to get the Currency Symbol
     * @Input       :
     * @Output      :
     **/
    public static String getCurrencySymbol(SObject genericSObject) {
        return getCurrencyIsoCode(genericSObject);
    }

    /***** UtilityFetchAttachment class *****/
    /**
     * @description:     Method that returns string in 'MM/DD/YYYY' format for date that is provided as parameter 
     * @author:          Eternus Solutions
     * @date(mm-dd-yy):  07-07-2016
     * @revised:   
     */
    public static String getStringDate(Date paramDate){
        
        String strReturnDate = '';
        
        // Check if date input is not null if true then convert date to 'mm/dd/yyyy' format
        if(paramDate != null){
            strReturnDate = String.valueOf(paramDate.month()+100).right(2)+'/'
                          + String.valueOf(paramDate.day()+100).right(2)+'/'
                          + String.valueOf(paramDate.year());
        }
        
        return strReturnDate;
    }    
    
    /**
     * @description:     Method returns list of attachments for selected object's id and date critera being passed
     * @author:          Eternus Solutions
     * @date(mm-dd-yy):  07-07-2016
     * @revised:   
     */
    public static Attachment getAttachments(String selectedObjectId, String strStartDate, 
                                                 String strEndDate, String strOffset){
        
        List<Attachment> attachmentList = new List<Attachment>();
        Attachment attachmentObj = new Attachment();                                                       
        
        Set<String> setStringAttachmentName = new Set<String>();
        
        if(String.isNotBlank(selectedObjectId) && String.isNotBlank(strOffset)){
            Date startDate;
            Date endDate ;  
            
            if(String.isBlank(strStartDate)){
                startDate = getDateOfFirstCreatedAttachment(selectedObjectId);
                endDate = String.isNotBlank(strEndDate)? Date.parse(strEndDate) : endDate;
            } 
                
            if(String.isBlank(strEndDate)){
                endDate = getDateOfLatestCreatedAttachment(selectedObjectId);
                startDate = String.isNotBlank(strStartDate)? Date.parse(strStartDate) : startDate;
            } 
            
            if(String.isNotBlank(strStartDate) && String.isNotBlank(strEndDate) ){
                startDate = Date.parse(strStartDate);
                endDate = Date.parse(strEndDate);
            }
            
            if(startDate <= endDate){
                
                // Convert start date in 'mm/dd/yy' format
                strStartDate = getStringDate(startDate);
                strEndDate = getStringDate(endDate); 
                
                // Get all Attachments whose names are similar to the the names in the set
                attachmentList = [SELECT   Id,body, LastModifiedDate, Name
                                  FROM     Attachment
                                  WHERE    parentID =: selectedObjectId
                                  Order By LastModifiedDate Desc offset :Integer.valueOf(strOffset)];
                if(!attachmentList.isEmpty()){
                   attachmentObj = attachmentList[0];
                }
            }
        }
        
        return attachmentObj;
    }
    
    /**
     * @description:     Method returns list of attachments for selected object's id and date critera being passed
     * @author:          Eternus Solutions
     * @date(mm-dd-yy):  07-07-2016
     * @revised:   
     */
    public static Integer getAttachmentRecordCount(String selectedObjectId, String strStartDate, String strEndDate){
        
        Integer intCount;
                 
        if(String.isNotBlank(selectedObjectId)){
            Date startDate;
            Date endDate ;  
            
            if(String.isBlank(strStartDate)){
                startDate = getDateOfFirstCreatedAttachment(selectedObjectId);
                endDate = String.isNotBlank(strEndDate)? Date.parse(strEndDate) : endDate;
            } 
                
            if(String.isBlank(strEndDate)){
                endDate = getDateOfLatestCreatedAttachment(selectedObjectId);
                startDate = String.isNotBlank(strStartDate)? Date.parse(strStartDate) : startDate;
            } 
            
            if(String.isNotBlank(strStartDate) && String.isNotBlank(strEndDate) ){
                startDate = Date.parse(strStartDate);
                endDate = Date.parse(strEndDate);
            }
            
            if(startDate <= endDate){
               
                // Get count of all Attachments whose names are similar to the the names in the set
                intCount = [SELECT   Count()
                            FROM     Attachment
                            WHERE    parentID =: selectedObjectId                                     
                           ];
                
            }else{
                intCount = 0;
            }                
                        
        }
        
        return intCount;
    }
    
    /**
     * @description:     Method returns date of first created attachment
     * @author:          Eternus Solutions
     * @date(mm-dd-yy):  07-07-2016
     * @revised:   
     */
    public static Date getDateOfFirstCreatedAttachment(String selectedObjectId){
        
        Date createdDate;
        List<Attachment> attachmentList = new List<Attachment>();
        
        if(String.isNotBlank(selectedObjectId)){
            attachmentList = [SELECT   CreatedDate
                              FROM     Attachment
                              WHERE    parentID =: selectedObjectId
                              Order By CreatedDate Asc
                              Limit    1];
            
            if(!attachmentList.isEmpty()){
                createdDate = date.newinstance(attachmentList[0].CreatedDate.year(), 
                                               attachmentList[0].CreatedDate.month(), 
                                               attachmentList[0].CreatedDate.day());
            }
        }
        
        return createdDate;
    }
    
    /**
     * @description:     Method returns date of latest created attachment
     * @author:          Eternus Solutions
     * @date(mm-dd-yy):  07-07-2016
     * @revised:   
     */
    public static Date getDateOfLatestCreatedAttachment(String selectedObjectId){
        
        Date createdDate;
        List<Attachment> attachmentList = new List<Attachment>();
        
        if(String.isNotBlank(selectedObjectId)){
            attachmentList = [SELECT   CreatedDate
                              FROM     Attachment
                              WHERE    parentID =: selectedObjectId
                              Order By CreatedDate Desc
                              Limit    1];
            
            if(!attachmentList.isEmpty()){
                createdDate = date.newinstance(attachmentList[0].CreatedDate.year(), 
                                               attachmentList[0].CreatedDate.month(), 
                                               attachmentList[0].CreatedDate.day());
            }
        }
        return createdDate;
    }
 }