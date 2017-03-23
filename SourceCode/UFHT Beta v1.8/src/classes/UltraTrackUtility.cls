/**
  * @Class Name: UltraTrackUtility
  * @Description: This class contains utility methods used across application.
  * ============================================================================================
  *       Version   | Date        | Author              | Comments
  *   ------------------------------------------------------------------------------------------
  *       1.0       | 29/02/2016  | Eternus Solutions   | 1. Created Class for above functionality.
  *  ===========================================================================================
  **/

public without sharing class UltraTrackUtility {

    // Map to hold field schema information per object.
    private static map<String, Schema.sObjectField> sObjectSchemaMap;
    
    // Map to hold User record and map them to UserIds.
    public static map<Id, User> userIdVsUserMap = new map<Id, User>();

    // Map to hold the object name and it's sObject Type
    public static map<String, Schema.sObjectType> sobjectMap {
        get {
            if(sobjectMap == null) {
                sobjectMap = Schema.getGlobalDescribe();
            }
            return sobjectMap;
        }
        private set;
    }
    
    // Map to hold the data type and it's force.com equivalent
    public static map<String, String> dataTypesMap {
        get {
            dataTypesMap = new Map<String, String> ();
            dataTypesMap.put(UFHTConstants.INTEGER_STR, UFHTConstants.NUMBER_STR);
            dataTypesMap.put(UFHTConstants.DOUBLE_STR, UFHTConstants.NUMBER_STR);
            dataTypesMap.put(UFHTConstants.REFERENCE_STR, UFHTConstants.RELATIONSHIP_STR);
            dataTypesMap.put(UFHTConstants.ENCRYPTEDSTRING_STR, UFHTConstants.ENCRYPTEDTEXT_STR);
            dataTypesMap.put(UFHTConstants.STRING_STR, UFHTConstants.TEXT_STR);
            return dataTypesMap;
        }
        public set;
    }

   /**
     * @Author: Eternus Solutions
     * @Description: Constructor. Initializes sobjectMap and userIdVsUserMap.
     * @Param:
     * @Return:
     * @Date: 24/02/2016
     **/
    public UltraTrackUtility() {

        userIdVsUserMap = new map<Id, User>();
        //Check whether the user has access for read for users
        if(UltraTrackUtility.checkObjectAndFieldLevelSecurity('User', 
                                                           new list<String> {'Id','ManagerId','Name'},
                                                           'isAccessible')){
            userIdVsUserMap = new map<Id, User>([SELECT Id,
                                                    ManagerId,
                                                    Name
                                                FROM User
                                                LIMIT 50000]);
        
        }   
    }

   /**
     * @Author: Eternus Solutions
     * @Description: Method to get OWD for an object
     * @Param: selectedObject API name of object for which method return OWD.
     * @Return: map<Boolean, set<String>>
     * @Date: 6/4/2016
     **/
    public static map<Boolean, list<String>> getOwdForAnObject(String selectedObject) {

        map<Boolean, list<String>> result = new map<Boolean, list<String>>();

        if(String.isBlank(selectedObject) || sobjectMap == null || !sobjectMap.containsKey(selectedObject)) {
            return result;
        }

        String objectShareName, parentCustomStandard;
        Schema.DescribesObjectResult describesObjectResultObj = sobjectMap.get(selectedObject).getDescribe();
        Boolean isCustom = describesObjectResultObj.isCustom();

        if(isCustom) {
           objectShareName = selectedObject.subString(0, selectedObject.length() - 1) + UFHTConstants.SHARE_STRING;
           parentCustomStandard = UFHTConstants.PARENT_ID;
        }

        else {
            objectShareName = selectedObject + UFHTConstants.SHARE_STRING;
            parentCustomStandard = selectedObject + UFHTConstants.ID_FIELD;
        }

        if(sobjectMap.containsKey(objectShareName)) {
            result.put(true, new list<String> {objectShareName, parentCustomStandard, isCustom ? UFHTConstants.TRUE_KEYWORD : UFHTConstants.FALSE_KEYWORD});
        }

        else {
            result.put(false, new list<String> {describesObjectResultObj.isAccessible() ? UFHTConstants.TRUE_KEYWORD : UFHTConstants.FALSE_KEYWORD});
        }

        return result;
    }

    /**
     * @Author: Eternus Solutions
     * @Description: Method to get users who access a records.
     * @Param: objectDetailsList details regarding objects
     *         sObjectIdSet records Id
     * @Return: map<Id, set<Id> allUsers who have access to record Id
     * @Date: 6/4/2016
     **/
    public static map<Id, set<Id>> getSharing(list<String> objectDetailsList, set<Id> sObjectIdSet) {

        map<Id, set<Id>> recordIdVsUserOrGroupIdSetMap = new map<Id, set<Id>>();

        if(objectDetailsList == null || sObjectIdSet == null || !(objectDetailsList.size() >= 3) || sObjectIdSet.isEmpty()) {
           return recordIdVsUserOrGroupIdSetMap;
        }

        set<Id> groupIdSet = new set<Id>();
        String groupType = Schema.sObjectType.Group.getKeyPrefix();
        map<Id, set<Id>> recordIdVsUserIdSetDummyMap = new map<Id, set<Id>>();

        Id parentId;
        String userOrGroupId;

        map<Id, set<Id>> groupDetailMap = new map<Id, set<Id>>();
        set<Id> userOrGroupIdSet;

        String parentCustomStandard = objectDetailsList[1];

        for(sObject objectIterator : Database.query(UFHTConstants.QUERY_SELECT + UFHTConstants.WHITE_SPACE + UFHTConstants.ID_FIELD + UFHTConstants.COMMA
                                     + UFHTConstants.WHITE_SPACE + UFHTConstants.USER_OR_GROUP_ID + UFHTConstants.COMMA + UFHTConstants.WHITE_SPACE
                                     + parentCustomStandard + UFHTConstants.WHITE_SPACE + UFHTConstants.QUERY_FROM + UFHTConstants.WHITE_SPACE
                                     + objectDetailsList[0] + UFHTConstants.WHITE_SPACE + UFHTConstants.QUERY_WHERE + UFHTConstants.WHITE_SPACE + parentCustomStandard
                                     + UFHTConstants.WHITE_SPACE + UFHTConstants.QUERY_IN + UFHTConstants.COLON + UFHTConstants.WHITE_SPACE + UFHTConstants.VAR_SOBJECTIDSET)) {

            parentId = (Id)objectIterator.get(parentCustomStandard);

            userOrGroupId = (Id)objectIterator.get(UFHTConstants.USER_OR_GROUP_ID);

            if(recordIdVsUserOrGroupIdSetMap.containsKey(parentId)) {
                recordIdVsUserOrGroupIdSetMap.get(parentId).add(userOrGroupId);
            }

            else {
               recordIdVsUserOrGroupIdSetMap.put(parentId, new set<Id>{userOrGroupId});
            }

            if(((String)userOrGroupId).startsWith(groupType)) {
               groupIdSet.add(userOrGroupId);
            }
        }
        if(!groupIdSet.isEmpty()) {
            groupDetailMap = getSubGroupDetails(groupIdSet);
        }

        for(Id parentRecordId : recordIdVsUserOrGroupIdSetMap.keySet()) {
            //substitute with respective values here
            userOrGroupIdSet = new set<Id>();

            for(Id recordId : recordIdVsUserOrGroupIdSetMap.get(parentRecordId)) {

                if(((String)recordId).startsWith(groupType) &&
                   groupDetailMap.containsKey(recordId)) {
                    userOrGroupIdSet.addAll(groupDetailMap.get(recordId));
                }

                else {
                    userOrGroupIdSet.add(recordId);
                }
            }

            recordIdVsUserIdSetDummyMap.put(parentRecordId, userOrGroupIdSet);
        }

        return recordIdVsUserIdSetDummyMap;
    }

    /**
     * @Author: Eternus Solutions
     * @Description: Method to get all users belonging to group.
     * @Param: groupIdSet: Id's of group
     * @Return: AllUsers belongs to passed group Id's.
     * @Date: 6/4/2016
     **/
    @testVisible static map<Id, set<Id>> getSubGroupDetails(set<Id> groupIdSet) {

        map<Id, set<Id>> groupIdVsUserIdSetMap = new map<Id, set<Id>>();

        if(groupIdSet == null || groupIdSet.isEmpty()) {
            return groupIdVsUserIdSetMap;
        }

        set<Id> groupIdProxysSet = new set<Id>();
        map<Id, set<Id>> groupIdVsSubGroupMap = new map<Id, set<Id>>();

        //Check whether the user has access for read for users, group and group member
        if(!(UltraTrackUtility.checkObjectAndFieldLevelSecurity('User', 
                                                           new list<String> {'Id','UserRoleId','Name'},
                                                           'isAccessible')
             && UltraTrackUtility.checkObjectAndFieldLevelSecurity('Group', 
                                                           new list<String> {'Id','RelatedId','Type'},
                                                           'isAccessible')
             && UltraTrackUtility.checkObjectAndFieldLevelSecurity('GroupMember', 
                                                           new list<String> {'Id','UserOrGroupId','GroupId'},
                                                           'isAccessible'))){
             UltraTrackUtility.displayMessage(ApexPages.Severity.ERROR, System.Label.GenericError);
             return groupIdVsUserIdSetMap;
                                                            
        }
        String userType = Schema.sObjectType.User.getKeyPrefix();
        String groupType = Schema.sObjectType.Group.getKeyPrefix();
        String roleType = Schema.sObjectType.UserRole.getKeyPrefix();

        map<Id, list<GroupMember>> groupIdVsGroupMemberMap = new map<Id, list<GroupMember>>();
        set<Id> groupWithRoleSet = new set<Id>();
        set<Id> groupWithRoleNSubSet = new set<Id>();
        map<Id, set<Id>> groupIdVsRoleIdMap = new map<Id, set<Id>>();

        map<Id, Group> groupDetailsMap = new map<Id, Group> ([SELECT Id,
                                                                     RelatedId,
                                                                     Type
                                                             FROM Group
                                                             WHERE Id IN : groupIdSet]);
        for(GroupMember memberObj : [SELECT Id,
                                            UserOrGroupId,
                                            GroupId,
                                            Group.type
                                       FROM GroupMember
                                      WHERE GroupId IN : groupIdSet]) {

            if(groupIdVsGroupMemberMap.containsKey(memberObj.GroupId)) {
                groupIdVsGroupMemberMap.get(memberObj.GroupId).add(memberObj);
            }
            else {
                groupIdVsGroupMemberMap.put(memberObj.GroupId, new list<GroupMember>{memberObj});
            }
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
                    else if(((String)memberObj.UserOrGroupId).startsWith(groupType)) {

                    // Call this function again but pass in the group found within this group
                        groupIdProxysSet.add(memberObj.UserOrGroupId);

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
                if(groupDetailsMap.get(groupId) != null &&
                   (groupDetailsMap.get(groupId).RelatedId != null &&
                   ((String)groupDetailsMap.get(groupId).RelatedId).startsWith(roleType) )) {

                    if(groupDetailsMap.get(groupId).type.Contains(UFHTConstants.ROLE_STRING)) {
                        groupWithRoleSet.add(groupDetailsMap.get(groupId).RelatedId);
                    }

                    else if(groupDetailsMap.get(groupId).type.contains(UFHTConstants.ROLE_AND_SUBORDINATE)) {
                        groupWithRoleNSubSet.add(groupDetailsMap.get(groupId).RelatedId);
                    }

                    if(groupIdVsRoleIdMap.containsKey(groupId)) {
                        groupIdVsRoleIdMap.get(groupId).add(groupDetailsMap.get(groupId).RelatedId);
                    }

                    else {
                        groupIdVsRoleIdMap.put(groupId, new set<Id> {groupDetailsMap.get(groupId).RelatedId});
                    }
               }
            }
        }

        if( !groupWithRoleNSubSet.isEmpty() ) {
            groupWithRoleNSubSet.addAll(getAllSubRoleIds(groupWithRoleNSubSet));
        }

        if(!groupIdVsRoleIdMap.isEmpty()) {

            map<Id, set<Id>> usersMap = new map<Id, set<Id>>();
            set<Id> roleIdsSet = new set<Id>();
            roleIdsSet.addAll(groupWithRoleSet);
            roleIdsSet.addAll(groupWithRoleNSubSet);

            for(User userObj : [SELECT Id,
                                       Name,
                                       UserRoleId
                               FROM User
                               WHERE UserRoleId IN : roleIdsSet
                               AND isActive = true]) {

                if(usersMap.containsKey(userObj.UserRoleId)) {
                    usersMap.get(userObj.UserRoleId).add(userObj.Id);
                }

                else {
                    usersMap.put(userObj.UserRoleId, new set<Id>{userObj.Id});
                }
            }

            for(Id groupId : groupIdVsRoleIdMap.keySet()) {
                for(Id roleId : groupIdVsRoleIdMap.get(groupId)) {

                    if(usersMap.containsKey(roleId)) {

                        if(groupIdVsUserIdSetMap.containsKey(groupId)) {
                            groupIdVsUserIdSetMap.get(groupId).addAll(usersMap.get(roleId));
                        }

                        else {
                            groupIdVsUserIdSetMap.put(groupId, new set<Id> (usersMap.get(roleId)));
                        }
                    }
                }
            }
        }

        if(!groupIdProxysSet.isEmpty()) {

            map<Id, set<Id>> subGroupDetailsMap = getSubGroupDetails(groupIdProxysSet);

            for(Id groupId : groupIdVsSubGroupMap.KeySet()) {

                for(Id memberId : groupIdVsSubGroupMap.get(groupId)) {

                    if(groupIdVsUserIdSetMap.containsKey(groupId)) {
                        groupIdVsUserIdSetMap.get(groupId).addAll(subGroupDetailsMap.get(memberId));
                    }

                    else if(subGroupDetailsMap.containsKey(memberId)) {
                        groupIdVsUserIdSetMap.put(groupId, new set<Id> (subGroupDetailsMap.get(memberId)));
                    }
                }
            }
        }

        return groupIdVsUserIdSetMap;
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Method to get all sub roles related to role.
      * @Param: roleIds Id's of role
      * @Return: map<Id, set<Id>> sub roles Id belongs to a Role
      * @Date: 6/4/2016
      **/
    @testvisible static set<Id> getAllSubRoleIds(set<Id> roleIdSet) {

        set<Id> currentRoleIdsSet = new set<Id>();

        if(roleIdSet == null || roleIdSet.isEmpty()) {
            return currentRoleIdsSet;
        }
        //Check whether the user has access for read for User Role
        if(!UltraTrackUtility.checkObjectAndFieldLevelSecurity('UserRole', 
                                                               new list<String> {'Id','ParentRoleId'},
                                                               'isAccessible')){
             UltraTrackUtility.displayMessage(ApexPages.Severity.ERROR, System.Label.GenericError);
             return currentRoleIdsSet;
                                                            
        }

        roleIdSet.remove(null);

        // get all of the roles underneath the passed roles
        currentRoleIdsSet = new map<Id, UserRole>([SELECT Id
                                                   FROM UserRole
                                                   WHERE ParentRoleId IN : roleIdSet
                                                   LIMIT 40000]).keySet();

        // go fetch some more roles!
        if(!currentRoleIdsSet.isEmpty()) {
            currentRoleIdsSet.addAll(getAllSubRoleIds(currentRoleIdsSet));
        }

        return currentRoleIdsSet;
    }

   /**
     * @Author: Eternus Solutions
     * @Description: Method to get all managers related to single user.
     * @Param: userIdSet Id's of user
     * @Return: map<Id, set<Id>> all managers Id related to single user.
     * @Date: 6/4/2016
     **/
    public map<Id, set<Id>> getAllManagersForUser(set<Id> userIdSet) {

        map<Id, set<Id>> userIdVsAllManagerIdMap = new map<Id, set<Id>>();

        if(userIdSet == null || userIdSet.isEmpty()) {
            return userIdVsAllManagerIdMap;
        }

        Id managerId;
        Integer countVar;

        for(Id userId : userIdSet) {

            countVar = 1;
            managerId = userId;

            do {

                if(userIdVsUserMap.containsKey(managerId)) {
                    if(userIdVsUserMap.get(managerId).managerId != null) {

                        if(userIdVsAllManagerIdMap.containsKey(userId)) {
                            userIdVsAllManagerIdMap.get(userId).add(userIdVsUserMap.get(managerId).managerId);
                        }

                        else {
                            userIdVsAllManagerIdMap.put(userId, new set<Id>{userIdVsUserMap.get(managerId).managerId});
                        }
                        managerId = userIdVsUserMap.get(managerId).managerId;
                    }

                    else {
                         break;
                    }
                }

            } while(managerId != userId);
        }

        return userIdVsAllManagerIdMap;
    }

    /**
     * @Author: Eternus Solutions
     * @Description: Method to get start and end date for selected date filter
     * @Param: dateFilter date filter
     * @Return: list<Ultra_Track_Container__c> startDate and endDate objects for selected filter.
     * @Date: 6/4/2016
     **/
    public static list<Ultra_Track_Container__c> getStartAndEndDateForFilter(String dateFilter) {

        list<Ultra_Track_Container__c> startEndDateList = new list<Ultra_Track_Container__c>();

        if(String.isBlank(dateFilter)) {
            return startEndDateList;
        }
        if(!(UltraTrackUtility.isAllowDMLForCustomSetting('UFHT__View_Field_History_Date_Filters__c','isAccessible') &&
             UltraTrackUtility.checkObjectAndFieldLevelSecurity('UFHT__Ultra_Track_Container__c', 
                                                               new list<String> {'UFHT__DateHolder__c'},
                                                               'isAccessible'))){
             UltraTrackUtility.displayMessage(ApexPages.Severity.ERROR, System.Label.GenericError);
             return startEndDateList;
        }
        View_Field_History_Date_Filters__c dateFilterObj = View_Field_History_Date_Filters__c.getValues(dateFilter);

        if(dateFilterObj != null) {

            Ultra_Track_Container__c startDateObj = new Ultra_Track_Container__c();
            Ultra_Track_Container__c endDateObj = new Ultra_Track_Container__c();
            Date todayDate = Date.Today();

            if(dateFilterObj.Name.equals(UFHTConstants.LAST_MONTH_STRING)) {
                Date lastMonthDate = todayDate.addMonths(-1);
                integer dayOfMonth = Date.daysInMonth(lastMonthDate.year(), lastMonthDate.month());
                startDateObj.DateHolder__c = lastMonthDate.toStartOfMonth();
                endDateObj.DateHolder__c = lastMonthDate.toStartOfMonth().addDays(dayOfMonth - 1);
            }

            else if(dateFilterObj.Name.equals(UFHTConstants.THIS_MONTH_STRING)) {
                Date currentMonthDate = todayDate;
                integer dayOfMonth = Date.daysInMonth(currentMonthDate.year(), currentMonthDate.month());
                startDateObj.DateHolder__c = currentMonthDate.toStartOfMonth();
                endDateObj.DateHolder__c = currentMonthDate.toStartOfMonth().addDays(dayOfMonth - 1);
            }

            else if(dateFilterObj.Name.equals(UFHTConstants.CURRENT_PREVIOUS_MONTH)) {
                Date currentMonthDate = todayDate;
                Date lastMonthDate = todayDate.addMonths(-1);
                integer dayOfMonth = Date.daysInMonth(currentMonthDate.year(), currentMonthDate.month()) ;
                startDateObj.DateHolder__c = lastMonthDate.toStartOfMonth();
                endDateObj.DateHolder__c = currentMonthDate.toStartOfMonth().addDays(dayOfMonth - 1);
            }

            else if(dateFilterObj.Name.equals(UFHTConstants.LAST_WEEK_STRING)) {
                Date lastWeekDate = todayDate.addDays(-7);
                startDateObj.DateHolder__c = lastWeekDate.toStartofWeek();
                endDateObj.DateHolder__c = lastWeekDate.toStartofWeek().addDays(6);
            }

            else if(dateFilterObj.Name.equals(UFHTConstants.THIS_WEEK_STRING)) {
                Date currentWeekDate = todayDate;
                startDateObj.DateHolder__c = currentWeekDate.toStartofWeek();
                endDateObj.DateHolder__c = currentWeekDate.toStartofWeek().addDays(6);
            }

            else if(dateFilterObj.Name.equals(UFHTConstants.TODAY_STRING)) {
                startDateObj.DateHolder__c = endDateObj.DateHolder__c = todayDate;
            }

            else if(dateFilterObj.Name.equals(UFHTConstants.YESTERDAY_STRING)) {
                startDateObj.DateHolder__c = endDateObj.DateHolder__c = todayDate.addDays(-1);
            }
            startEndDateList.add(startDateObj);
            startEndDateList.add(endDateObj);
        }

        return startEndDateList;
    }

   /**
     * @Author: Eternus Solutions
     * @Description: Method to get name field for an object
     * @Param: objectName: ApiName of object.
     * @Return: Return name field for an object
     * @Date: 6/4/2016
     **/
    public static String getNameUniqueField(String objectName) {

        String objectNameField = UFHTConstants.EMPTY_STRING;

        if(!sobjectMap.containsKey(objectName)) {
            return objectNameField;
        }

        Schema.DescribeFieldResult fieldResult;

        for(Schema.sObjectField objField : sobjectMap.get(objectName).getDescribe().Fields.getMap().values()) {

            fieldResult = objField.getDescribe();

            if(fieldResult.isNameField()) {
                objectNameField = fieldResult.getName();
                break;
            }
        }

        return objectNameField;
    }

   /**
     * @Author: Eternus Solutions
     * @Description: Method to get the sObject's field names and field labels
     * @Param: It takes String sObject Name as param
     * @Return: It returns map of field name as key and field label as value
     * @Date: 9/2/2016
     **/
    public static map<String, String> getFieldNamesAndLabels(String sObjectName) {

        map<String, String> fieldNameAndLabelMap = new map<String, String>();

        if(String.isBlank(sObjectName)) {
            return fieldNameAndLabelMap;
        }

        if(sobjectMap.containsKey(sObjectName)) {
            for(Schema.sObjectField fieldType : sobjectMap.get(sObjectName).getDescribe().fields.getMap().values()) {
                if(((fieldType.getDescribe().isUpdateable() || fieldType.getDescribe().isCreateable()) && fieldType.getDescribe().isAccessible()) ||
                   fieldType.getDescribe().getCalculatedFormula() != null) {
                    fieldNameAndLabelMap.put(fieldtype.getDescribe().getName(), fieldtype.getDescribe().getLabel());
                }
            }
        }
        return fieldNameAndLabelMap;
    }

    /**
     * @Author: Eternus Solutions
     * @Description: Method to get the field type for field.
     * @Param: It takes String sObject Name and String Field Name as param
     * @Return: It returns Schema.DisplayType of specified field
     * @Date: 9/2/2016
     **/
    public static Schema.DisplayType getFieldType(String sObjectName, String fieldName) {
        if(sobjectMap.containsKey(sObjectName) && String.isNotBlank(fieldName)) {
            if(sobjectMap.get(sObjectName).getDescribe().fields.getMap().get(fieldName) != null) {
                return sobjectMap.get(sObjectName).getDescribe().fields.getMap().get(fieldName).getDescribe().getType();
            }
        }

        return null;
    }

    /**
     * @Author: Eternus Solutions
     * @Description: Method to update encrypted field to mask hidden characters.
     * @Param: String sObjectName, String fieldName, String oldValue, String newValue.
     * @Return: Array of Strings (array[0] : updatedOldValue, array[1] : updatedNewValue)
     * @Date: 01/07/2016
     **/
    public static list<String> maskEncryptedData(Schema.DescribeFieldResult fieldDescribe, String oldValue, String newValue) {
        if(!UltraTrackUtility.isAllowDMLForCustomSetting('UFHT__Encrypted_Field_Mask__c','isAccessible')){
            UltraTrackUtility.displayMessage(ApexPages.Severity.ERROR, System.Label.GenericError);
            return null;
        }
        map<String, UFHT__Encrypted_Field_Mask__c> maskTypeMap = UFHT__Encrypted_Field_Mask__c.getAll();
        if(fieldDescribe != null && maskTypeMap.containsKey(fieldDescribe.getMaskType())) {

            String replacementMaskCharacter = fieldDescribe.getMask();
            String regexPattern = maskTypeMap.get(fieldDescribe.getMaskType()).UFHT__RegEx__c;

            if(fieldDescribe.getMaskType().equalsIgnoreCase(UFHTConstants.ALL)) {

                // mask logic for all characters [MAX = ?, Format = <XXX>]
                oldValue = String.isNotBlank(oldValue)
                         ? replaceString(oldValue, regexPattern, replacementMaskCharacter)
                         : oldValue;
                newValue = String.isNotBlank(newValue)
                         ? replaceString(newValue, regexPattern, replacementMaskCharacter)
                         : newValue;

            }
            else if(fieldDescribe.getMaskType().equalsIgnoreCase(UFHTConstants.MASK_TYPE_LASTFOUR)) {

                // mask logic for characters excluding last 4 [MAX = ?, Format = <XXX>12AB]
                oldValue = (String.isNotBlank(oldValue) && oldValue.length() > 4)
                         ? replaceString(oldValue.subString(0, oldValue.length() - 4), regexPattern, replacementMaskCharacter)
                           + oldValue.subString(oldValue.length() - 4, oldValue.length())
                         : oldValue;
                newValue = (String.isNotBlank(newValue) && newValue.length() > 4)
                         ? replaceString(newValue.subString(0, newValue.length() - 4), regexPattern, replacementMaskCharacter)
                           + newValue.subString(newValue.length() - 4, newValue.length())
                         : newValue;

            }
            else if(fieldDescribe.getMaskType().equalsIgnoreCase(UFHTConstants.MASK_TYPE_CREDIT)) {

                // mask logic for all numbers excluding last 4 [MAX = 16, Format = XXXX-XXXX-XXXX-1111]
                oldValue = (String.isNotBlank(oldValue) && oldValue.length() > 4)
                         ? replaceString(oldValue.subString(0, oldValue.length() - 4), regexPattern, replacementMaskCharacter)
                           + oldValue.subString(oldValue.length() - 4, oldValue.length())
                         : oldValue;
                newValue = (String.isNotBlank(newValue) && newValue.length() > 4)
                         ? replaceString(newValue.subString(0, newValue.length() - 4), regexPattern, replacementMaskCharacter)
                           + newValue.subString(newValue.length() - 4, newValue.length())
                         : newValue;

            }
            else if(fieldDescribe.getMaskType().equalsIgnoreCase(UFHTConstants.MASK_TYPE_NINO)) {

                // mask logic for all characters [MAX = 9, Format = XX XX XX XX X]
                oldValue = String.isNotBlank(oldValue)
                         ? replaceString(oldValue, regexPattern, replacementMaskCharacter)
                         : oldValue;
                newValue = String.isNotBlank(newValue)
                         ? replaceString(newValue, regexPattern, replacementMaskCharacter)
                         : newValue;

            }
            else if(fieldDescribe.getMaskType().equalsIgnoreCase(UFHTConstants.MASK_TYPE_SSN)) {

                // mask logic for all numbers excluding last 4 [MAX = 9, Format = XXX-XX-1111]
                oldValue = (String.isNotBlank(oldValue) && oldValue.length() > 4)
                         ?   replaceString(oldValue.subString(0, oldValue.length() - 4), regexPattern, replacementMaskCharacter)
                           + oldValue.subString(oldValue.length() - 4, oldValue.length())
                         : oldValue;
                newValue = (String.isNotBlank(newValue) && newValue.length() > 4)
                         ?   replaceString(newValue.subString(0, newValue.length() - 4), regexPattern, replacementMaskCharacter)
                           + newValue.subString(newValue.length() - 4, newValue.length())
                         : newValue;

            }
            else if(fieldDescribe.getMaskType().equalsIgnoreCase(UFHTConstants.MASK_TYPE_SIN)) {

                // mask logic for all numbers excluding last 3 [MAX = 9, Format = XXX-XXX-111]
                oldValue = (String.isNotBlank(oldValue) && oldValue.length() > 3)
                         ?   replaceString(oldValue.subString(0, oldValue.length() - 3), regexPattern, replacementMaskCharacter)
                           + oldValue.subString(oldValue.length() - 3, oldValue.length())
                         : oldValue;
                newValue = (String.isNotBlank(newValue) && newValue.length() > 3)
                         ?   replaceString(newValue.subString(0, newValue.length() - 3), regexPattern, replacementMaskCharacter)
                           + newValue.subString(newValue.length() - 3, newValue.length())
                         : newValue;
            }

            return new list<String> {oldValue, newValue};
        }
        return null;
    }

    /**
     * @Author: Eternus Solutions
     * @Description: Method to perform replacement matching characters in provided string.
     * @Param: String pInputString, String pRegexPattern, String pReplacementCharacter.
     * @Return: String replacedString
     * @Date: 20/07/2016
     **/
    @testvisible private static String replaceString(String pInputString, String pRegexPattern, String pReplacement) {

        String replacedString = UFHTConstants.EMPTY_STRING;

        if(String.isNotBlank(pInputString) &&
           String.isNotBlank(pRegexPattern) &&
           pReplacement != null) {
            replacedString = pInputString.replaceAll(pRegexPattern, pReplacement);
        }

        return replacedString;
    }

    /**
     * @Author: Eternus Solutions
     * @Description: Method to display message on Pages
     * @Param: severity, String Message
     * @Return: None
     * @Date: 01/07/2016
     **/
    public static void displayMessage(ApexPages.Severity severity, String message) {
        if(String.isBlank(message) || severity == null ) {
            return;
        }
        if(!Trigger.isExecuting){
            ApexPages.AddMessage(new ApexPages.Message(severity, message));
        }
    }

   /**
     * @Author: Eternus Solutions
     * @Description: Method to get fields from new and old records.
     * @Param: 1. Record of trigger.new
     *         2. Record of trigger.old
     * @Return: Returns set of fields.
     * @Date: 06/06/2016
     **/
    public static set<String> getFields(sObject newRecord, sObject oldRecord) {

        if(newRecord == null || oldRecord == null) {
            return new set<String>();
        }

        set<String> presentFieldsSet = new set<String>();

        map<String, Object> newRecordsFieldsMap = (map<String, Object>) JSON.deserializeUntyped(JSON.serialize(newRecord));
        map<String, Object> oldRecordsFieldsMap = (map<String, Object>) JSON.deserializeUntyped(JSON.serialize(oldRecord));

        presentFieldsSet.addAll(newRecordsFieldsMap.keySet());
        presentFieldsSet.addAll(oldRecordsFieldsMap.keySet());

        presentFieldsSet.remove(UFHTConstants.ATTRIBUTES);
        return presentFieldsSet;
    }

   /**
     * @Author: Eternus Solutions
     * @Description: A method set value if field type is currency, percent or encrypted text.
     * @Param: objectName, fieldName, oldValue, newValue
     * @Return: Returns set of fields.
     * @Date: 06/06/2016
     **/
    public static list<String> checkCurrencyOrPercentField(String ObjectName, 
                                                           Sobject newSobject, 
                                                           Sobject oldSobject, 
                                                           String sObjectFieldName, 
                                                           String oldValue, 
                                                           String newValue) {

        list<String> updatedValuesList = new list<String>();

        if(String.isBlank(ObjectName) || String.isBlank(sObjectFieldName)) {
            return updatedValuesList;
        }

        try {
            sObjectSchemaMap = getFieldType(ObjectName);

            if(sObjectSchemaMap.containsKey(sObjectFieldName)) {

               Schema.DescribeFieldResult fieldDescribe = sObjectSchemaMap.get(sObjectFieldName).getDescribe();

               if(fieldDescribe.getType() == Schema.DisplayType.Currency) {
                    updatedValuesList.add(String.isNotBlank(oldValue) ? getCurrencySymbol(oldSobject) + UFHTConstants.WHITE_SPACE + oldValue : oldValue);
                    updatedValuesList.add(String.isNotBlank(newValue) ? getCurrencySymbol(newSobject) + UFHTConstants.WHITE_SPACE + newValue : newValue);

               } else if(fieldDescribe.getType() == Schema.DisplayType.Percent) {
                    updatedValuesList.add(String.isNotBlank(oldValue) ? oldValue + UFHTConstants.PERCENT_SIGN : oldValue);
                    updatedValuesList.add(String.isNotBlank(newValue) ? newValue + UFHTConstants.PERCENT_SIGN : newValue);

               } else if(fieldDescribe.getType() == Schema.DisplayType.EncryptedString) {
                    updatedValuesList = maskEncryptedData(fieldDescribe, oldValue, newValue);
               }
               return updatedValuesList;
           }
        }
        catch(NullPointerException ex) {

        }

        return updatedValuesList;

    }

    /**
     * @Author: Eternus Solutions
     * @Description: A method get the Map of Field for specific sObject
     * @Param: objectName
     * @Return: Returns map of fieldname to its field description info.
     * @Date: 06/06/2016
     **/
    public static map<String, Schema.sObjectField> getFieldType(String sObjectName) {

        try {
            if(String.isNotBlank(sObjectName) && sobjectMap.containsKey(sObjectName)) {
                return sobjectMap.get(sObjectName).getDescribe().fields.getMap();
            }
        }
        catch(NullPointerException ex) {

        }
        return null;
   }

    /**
     * @Author: Eternus Solutions
     * @Description: A method to get the Currency Code
     * @Param: objectName
     * @Return: Returns CUrrency Code for the record provided.
     * @Date: 06/06/2016
     **/
    public static String getCurrencyIsoCode(sObject genericsObject) {

        return genericsObject == null
               ? UFHTConstants.EMPTY_STRING
               : UserInfo.isMultiCurrencyOrganization()
               ? (String) genericsObject.get(UFHTConstants.CURRENCY_ISO_CODE)
               : UserInfo.getDefaultCurrency();
    }

    /**
     * @Author: Eternus Solutions
     * @Description: A method to get the Currency Symbol
     * @Param: objectName
     * @Return: Returns map of fieldname to its field description info.
     * @Date: 06/06/2016
     **/
    public static String getCurrencySymbol(sObject genericsObject) {


        return genericsObject == null
               ? UFHTConstants.EMPTY_STRING
               : getCurrencyIsoCode(genericsObject);
    }

    /**
     * @Author: Eternus Solutions
     * @Description: Method that returns String in 'MM/DD/YYYY' format for date that is provided as parameter
     * @Param: objectName
     * @Return: Returns map of fieldname to its field description info.
     * @Date: 07/07/2016
     **/
    public static String getStringDate(Date paramDate) {

        String strReturnDate = UFHTConstants.EMPTY_STRING;

        // Check if date input is not null if true then convert date to 'mm/dd/yyyy' format
        if(paramDate != null) {
            strReturnDate = String.valueOf(paramDate.month() + 100).right(2) + '/'
                          + String.valueOf(paramDate.day() + 100).right(2) + '/'
                          + String.valueOf(paramDate.year());
        }

        return strReturnDate;
    }

    /**
     * @Author: Eternus Solutions
     * @Description: Method returns list of attachments for selected object's id and date criteria being passed
     * @Param: objectName
     * @Return: Returns map of fieldname to its field description info.
     * @Date: 07/07/2016
     **/
    public static Attachment getAttachment(Id selectedObjectId, String strStartDate,
                                                 String strEndDate, String strOffset) {

        Attachment attachmentObj = new Attachment();
        //Check whether the user has access for read for attachment
        if(!UltraTrackUtility.checkObjectAndFieldLevelSecurity('Attachment', 
                                                               new list<String> {'Id','Body','LastModifiedDate','Name'},
                                                               'isAccessible')){
             UltraTrackUtility.displayMessage(ApexPages.Severity.ERROR, System.Label.GenericError);
             return attachmentObj;
                                                            
        }
        if(String.isNotBlank(selectedObjectId) && String.isNotBlank(strOffset)) {

            Date startDate = String.isBlank(strStartDate)
                           ? getAttachmentCreatedDate(selectedObjectId, UFHTConstants.QUERY_ASC)
                           : Date.parse(strStartDate);

            Date endDate = String.isBlank(strEndDate)
                         ? getAttachmentCreatedDate(selectedObjectId, UFHTConstants.QUERY_DESC)
                         : Date.parse(strEndDate);

            if(startDate <= endDate) {

                // Convert start date in 'mm/dd/yy' format
                strStartDate = getStringDate(startDate);
                strEndDate = getStringDate(endDate);

                Integer offsetValue = 0;
                try {
                    offsetValue = Integer.valueOf(strOffset);
                } catch(Exception e) {
                    return attachmentObj;
                }

                if(offsetValue > 2000) {
                    return attachmentObj;
                }



                // Get all Attachments whose names are similar to the the names in the set
                try {
                    attachmentObj = [SELECT Id,
                                            Body,
                                            LastModifiedDate,
                                            Name
                                     FROM Attachment
                                     WHERE ParentId = : selectedObjectId
                                     ORDER BY LastModifiedDate desc OFFSET : offsetValue];
                }
                catch(QueryException ex){

                }

            }
        }

        return attachmentObj;
    }

    /**
     * @Author: Eternus Solutions
     * @Description: Method returns list of attachments for selected object's id and date criteria being passed
     * @Param: selectedObjectId, strStartDate, strEndDate
     * @Return: Attachment count
     * @Date: 07/07/2016
     **/
    public static Integer getAttachmentRecordCount(Id selectedObjectId, String startDateStr, String endDateStr) {

        Integer intCount = 0;
        //Check whether the user has access for read for attachment
        if(!UltraTrackUtility.checkObjectAndFieldLevelSecurity('Attachment', 
                                                               new list<String> {'Id','ParentId'},
                                                               'isAccessible')){
             UltraTrackUtility.displayMessage(ApexPages.Severity.ERROR, System.Label.GenericError);
             return intCount;
                                                            
        }
        if(String.isNotBlank(selectedObjectId)) {

            Date startDate = String.isBlank(startDateStr)
                           ? getAttachmentCreatedDate(selectedObjectId, UFHTConstants.QUERY_ASC)
                           : Date.parse(startDateStr);

            Date endDate = String.isBlank(endDateStr)
                         ? getAttachmentCreatedDate(selectedObjectId, UFHTConstants.QUERY_DESC)
                         : Date.parse(endDateStr);
            system.debug('>>> startDate : '+startDate);
            system.debug('>>> endDate : '+endDate);
            if(startDate <= endDate) {

                // Get count of all Attachments whose names are similar to the the names in the set
                intCount = [SELECT Count()
                              FROM Attachment
                             WHERE parentId =: selectedObjectId];

            }
        }

        return intCount;
    }

    /**
     * @Author: Eternus Solutions
     * @Description: Returns the CreatedDate for first or last attachment.
     * @Param: selectedObjectId
     * @Return: Returns the CreatedDate for first or last attachment based on order.
     * @Date: 19/07/2016
     **/
    public static Date getAttachmentCreatedDate(Id selectedObjectId, String sortOrder) {

        Date createdDate;

        if(String.isNotBlank(selectedObjectId) && String.isNotBlank(sortOrder)) {

            String queryString = UFHTConstants.QUERY_SELECT + UFHTConstants.WHITE_SPACE + UFHTConstants.CREATED_DATE_FIELD + UFHTConstants.WHITE_SPACE
                               + UFHTConstants.QUERY_FROM + UFHTConstants.WHITE_SPACE + UFHTConstants.ATTACHMENT_STRING + UFHTConstants.WHITE_SPACE
                               + UFHTConstants.QUERY_WHERE + UFHTConstants.WHITE_SPACE + UFHTConstants.PARENT_ID + UFHTConstants.WHITE_SPACE
                               + UFHTConstants.EQUALS_SIGN + UFHTConstants.WHITE_SPACE + UFHTConstants.COLON + UFHTConstants.WHITE_SPACE
                               + UFHTConstants.VAR_SELECTEDOBJECTID + UFHTConstants.WHITE_SPACE + UFHTConstants.QUERY_ORDER + UFHTConstants.WHITE_SPACE
                               + UFHTConstants.QUERY_BY + UFHTConstants.WHITE_SPACE + UFHTConstants.CREATED_DATE_FIELD + UFHTConstants.WHITE_SPACE + sortOrder
                               + UFHTConstants.WHITE_SPACE + UFHTConstants.QUERY_LIMIT + UFHTConstants.WHITE_SPACE + 1;

            try {
                //Check whether the user has access for read for attachment
                if(!UltraTrackUtility.checkObjectAndFieldLevelSecurity('Attachment', 
                                                                       new list<String> {UFHTConstants.CREATED_DATE_FIELD,UFHTConstants.PARENT_ID},
                                                                       'isAccessible')){
                     UltraTrackUtility.displayMessage(ApexPages.Severity.ERROR, System.Label.GenericError);
                     createdDate = System.Today();
                                                                    
                }else{
                    list<Attachment> attachmentList = Database.query(queryString);

                    if(!attachmentList.isEmpty()) {
                        createdDate = date.newInstance(attachmentList[0].CreatedDate.year(),
                                                       attachmentList[0].CreatedDate.month(),
                                                       attachmentList[0].CreatedDate.day());
                    }
                }
                
            } catch(QueryException e) {
                createdDate = System.Today();
            }
        }

        return createdDate;
    }

    /**
     * @Author: Eternus Solutions
     * @Description: Method to evaluate that the upsert is allowed for container and Attachment
     * @Param: NA.
     * @Return: It results the boolean for allow DML for container and Attachment
     * @Date: 02/08/2016
     **/
    public static Boolean isAllowDML() {
        Boolean isAllow = true;
        if( !Schema.sObjectType.UFHT__Ultra_Track_Container__c.isCreateable() ||
            !Schema.sObjectType.UFHT__Ultra_Track_Container__c.isUpdateable() ||
            !Schema.sObjectType.Attachment.isCreateable() ||
            !Schema.sObjectType.Attachment.isUpdateable() ||
            !Schema.sObjectType.Attachment.fields.Body.isCreateable() ||
            !Schema.sObjectType.Attachment.fields.Body.isUpdateable() ||
            !Schema.sObjectType.Attachment.fields.Name.isCreateable() ||
            !Schema.sObjectType.Attachment.fields.Name.isUpdateable()) {

            isAllow = false;
        }
        return isAllow;
    }

    /**
      * @Author: Eternus Solutions
      * @Description: Method to evaluate that the Insert/Update is allowed for Custom Setting object and fields
      * @Param: 1. objectName: Name of the Object
      *         2. checkDML: String to identify Insert/Update check
      * @Return: It results the boolean for allow Insert/Update DML for Custom Setting object and fields
      * @Date: 08/08/2016
      **/
    public static Boolean isAllowDMLForCustomSetting(String objectName, String checkDML) {

        if(String.isNotBlank(objectName) && sobjectMap.containsKey(objectName) && String.isNotBlank(checkDML)) {
            Schema.DescribesObjectResult describesObjectResultObj = sobjectMap.get(objectName).getDescribe();
            sObjectSchemaMap = getFieldType(objectName);
            list<String> customSettingFieldsList = new list<String>{'Name'};

            for (String sObjField : sObjectSchemaMap.keySet()) {
                if (sObjectSchemaMap.get(sObjField).getDescribe().isCustom()){
                    customSettingFieldsList.add(sObjField);
                }
            }
            if(!customSettingFieldsList.isEmpty()) {
                return checkObjectAndFieldLevelSecurity(objectName, customSettingFieldsList, checkDML);
            }
            else {
                return false;
            }
        }
        else {
            return false;
        }
    }

    /**
     * @Author: Eternus Solutions
     * @Description: Method to evaluate that the Insert/Update access is allowed for object and fields
     * @Param: 1. objectName: Name of the Object
     *         2. fieldNameList: List of fields
     *         3. checkDML: String to identify Insert/Update check
     * @Return: It results the boolean for allow Insert/Update access for object and fields
     * @Date: 08/08/2016
     **/
    public static Boolean checkObjectAndFieldLevelSecurity(String objectName , list<String> fieldNameList, String checkAccess) {
        
        if( String.isNotBlank(objectName) && sobjectMap.containsKey(objectName)
            && String.isNotBlank(checkAccess) && fieldNameList != null) {

            Schema.DescribesObjectResult describesObjectResultObj = sobjectMap.get(objectName).getDescribe();
            sObjectSchemaMap = getFieldType(objectName);
            if(checkAccess.equalsIgnoreCase('isUpdate')) {
                if(!describesObjectResultObj.isUpdateable()) {
                    return false;
                }
                for (String sObjField : fieldNameList) {
                    if ( !sObjectSchemaMap.containsKey(sObjField) ||
                         !sObjectSchemaMap.get(sObjField).getDescribe().isUpdateable()){

                            return false;
                    }
                }
            }
            else if(checkAccess.equalsIgnoreCase('isInsert')) {
                if(!describesObjectResultObj.isCreateable()) {
                    return false;
                }
                for (String sObjField : fieldNameList) {
                    if ( !sObjectSchemaMap.containsKey(sObjField) ||
                         !sObjectSchemaMap.get(sObjField).getDescribe().isCreateable()){

                            return false;
                    }
                }
            }
            else if(checkAccess.equalsIgnoreCase('isAccessible')) {
                //Check the Object Level access for Accessible
                if(!describesObjectResultObj.isAccessible()) {
                    return false;
                }
                 //Check the FLS access for Accessible
                for (String sObjField : fieldNameList) {
                    if ( !sObjectSchemaMap.containsKey(sObjField) ||
                         !sObjectSchemaMap.get(sObjField).getDescribe().isAccessible()){
                            return false;
                    }
                }
            }
            else if(checkAccess.equalsIgnoreCase('isDeletable')) {
                //Check the Object Level access for Delete
                if(!describesObjectResultObj.isDeletable()) {
                    return false;
                }
            }
            else {
                return false;
            }

            return true;
        }
        else {
            return false;
        }
    }

    /**
     * @Author: Eternus Solutions
     * @Description: Method to get objects for which history tracking is enabled in a sorted order.
     * @Param: NA.
     * @Return: objectSelectedOptionsList - List of Objects in sorted order.
     * @Date: 08/08/2016
     **/
     public static list<SelectOption> getTrackedObjects() {
        list<SelectOption> objectSelectedOptionsList = new list<SelectOption>();

        objectSelectedOptionsList.add( new SelectOption(UFHTConstants.WHITE_SPACE,
                                                        UFHTConstants.NONE_OPTION_LABEL
                                                        ) );
        //Check whether the user has access for read for Ultra Track Container
        if(!UltraTrackUtility.checkObjectAndFieldLevelSecurity('UFHT__Ultra_Track_Container__c', 
                                                               new list<String> {'UFHT__Object_Label__c','UFHT__Tracked_Fields__c',
                                                                                 'UFHT__Object_Name__c', 'UFHT__Is_Tracking_Enabled__c'},
                                                               'isAccessible')){
             UltraTrackUtility.displayMessage(ApexPages.Severity.ERROR, System.Label.GenericError);
             return objectSelectedOptionsList;
                                                            
        }
        /*for(Ultra_Track_Container__c trackContainerObj : [SELECT Object_Label__c,
                                                          Tracked_Fields__c,
                                                          Object_Name__c
                                                          FROM Ultra_Track_Container__c
                                                          WHERE Is_Tracking_Enabled__c = : true
                                                                                         ORDER BY Object_Label__c]) {*/
        for(Ultra_Track_Container__c trackContainerObj : fetchContainerRecordsFromDB()) {

            objectSelectedOptionsList.add( new SelectOption(trackContainerObj.Id,
                                                            trackContainerObj.Object_Label__c
                                                            ) );
        }
        return objectSelectedOptionsList;
    }

    /**
     * @Author: Eternus Solutions
     * @Description: Method to get first object name of the list of which history tracking is enabled in a sorted order.
     * @Param: selectedObjectList - List of selected Objects.
     * @Return: selectedObject - Name of the first Object of the list.
     * @Date: 08/08/2016
     **/
    public static String getFirstObject(list<SelectOption> selectedObjectList) {
        String selectedObject;

        if( String.isBlank(selectedObject) && selectedObjectList != null ) {
            if(selectedObjectList.size() > 1
               && selectedObjectList[1] != null) {
                selectedObject = selectedObjectList[1].getValue();
            }
            else {
                selectedObject = UFHTConstants.WHITE_SPACE;
            }
        }
        return selectedObject;
    }
    
   /**
     * @Author: Eternus Solutions
     * @Description: Method to create Dynamic Test Class For An Object.
     * @Param: objectName - selected Object.
     * @Return: Return test class as string.
     * @Date: 11/17/2016
     **/
    public static String createDynamicTestClassForAnObject(String objectName, String className) {
        
        String testClassString = '';
        if(String.isNotBlank(objectName) && String.isNotBlank(className)) {
            
            if(objectName.equalsIgnoreCase('CollaborationGroupRecord')) {
                
            }
            String query = 'SELECT Id' + 
                           ' FROM ' + objectName + 
                           ' ORDER BY Id DESC' +
                           ' LIMIT 1'; 
            testClassString = '@isTest(SeeAllData=true)\n' + 
                          'public class '+ className + ' {\n' +
                          'testmethod static void dynamicTriggerGenenratorTest() {\n' + 
                          'Integer retryCount = 0;\n String recordUpdateFailError;\n' +
                          'list<sObject> objList = Database.query(\''+ query + '\');\n' + 
                          'if(!objList.isEmpty() && objList[0] != null) {\n' +
                          'do {\n' + 'try {\n' + 'recordUpdateFailError = \'\';\n' + 
                          'retryCount ++;\n' + 'update objList[0];\n'  + 'break; \n}\n' + 
                          'catch(DMLException ex) {\n recordUpdateFailError = ex.getDmlMessage(0); \n }\n' +
                          '} while(retryCount < 3);\n' + 
                          'if(retryCount == 3 && String.isNotBlank(recordUpdateFailError)) {\n' +
                          'throw new UFHT.UFHTExceptions.DynamicTestClassCreationFailException(\'Please modify the data for specified record to comply with the mentioned validation: \'' +
                           '+ recordUpdateFailError + \'. Click <a href="/\' + objList[0].Id + \'"\' + \' target=\\\'_balnk \\\'>here</a> to edit the record.\');\n}\n'+
                          'else {\nSystem.assert(objList[0].Id != null);\n}\n}' +
                          'else {throw new UFHT.UFHTExceptions.DynamicTestClassCreationFailException(\'No Record found for selected object to create test class.\');\n}\n' +
                          '}\n}';
        }                
        return testClassString;
    }
    
    /**
     * @Author: Eternus Solutions
     * @Description: Method to get the sObject's field names and field data type
     * @Param: It takes String sObject Name as param
     * @Return: It returns map of field name as key and data type as value
     * @Date: 18/1/2017
     **/
    public static map<String, String> getFieldNamesAndDataType(String sObjectName) {
    	system.debug('$$$ sObjectName'+sObjectName);
        map<String, String> fieldNameAndDataTypeMap = new map<String, String>();
        String typeStr = '';
        if(String.isBlank(sObjectName)) {
        	system.debug('$$$ inside if'+sObjectName);
            return fieldNameAndDataTypeMap;
        }
        if(sobjectMap.containsKey(sObjectName)) {
        	system.debug('$$$ inside actual value '+sObjectName);
            for(Schema.sObjectField fieldType : sobjectMap.get(sObjectName).getDescribe().fields.getMap().values()) {
                if(((fieldType.getDescribe().isUpdateable() || fieldType.getDescribe().isCreateable()) && fieldType.getDescribe().isAccessible())
                    || fieldType.getDescribe().getCalculatedFormula() != null) {
                    typeStr = String.valueOf(fieldtype.getDescribe().getType());
                    system.debug('$$$ typeStr'+typeStr);
                    if(UltraTrackUtility.dataTypesMap.containsKey(typeStr)) {
                        typeStr = UltraTrackUtility.dataTypesMap.get(typeStr);
                        system.debug('$$$ typeStr^^^'+typeStr);
                    }
                    fieldNameAndDataTypeMap.put(fieldtype.getDescribe().getName(), typeStr);
                    system.debug('$$$ fieldNameAndDataTypeMap^^^'+fieldNameAndDataTypeMap);
                }
            }
        }
        return fieldNameAndDataTypeMap;
    }
    
    /**
     * @Author: Eternus Solutions
     * @Description: Method to get the Field data type converted to title case
     * @Param: It takes String data type as param
     * @Return: It returns String in title case
     * @Date: 18/1/2017
     **/
    public static String convertFieldToTitleCase(String fieldName) {
        system.debug('%% fieldName'+fieldName);
        String titleCaseStr = ''; 
        if(String.isBlank(fieldName)) {
        	system.debug('%% inside if'+fieldName);
            return titleCaseStr;
        }
        else {
            titleCaseStr = (fieldName.toLowerCase()).capitalize();
            system.debug('%% inside else '+titleCaseStr);
        }
        
        return titleCaseStr;
    }
    
    
    /**
     * @Author: Eternus Solutions
     * @Description: Method to get map of field name as key and severity as value
     * @Param: String value of field Severity_of_Tracked_fields__c of container record
     * @Return: objectSelectedOptionsList - List of Objects in sorted order.
     * @Date: 19/01/2017
     **/
     public static map<String, String> getfieldSeverityMap(String severityFieldStr) {
        map<String, String> fieldSeverityMap = new map<String, String>();
        String severStr ='';
        List<String> fieldSeverityList = new List<String>();
        fieldSeverityList = severityFieldStr.split(UFHTConstants.COMMA);

        for(String fieldInstance : fieldSeverityList) {
            if(!fieldSeverityMap.containsKey(fieldInstance.substringBefore(UFHTConstants.COLON))) {
                severStr = fieldInstance.substringAfter(UFHTConstants.COLON).replaceAll(UFHTConstants.VALUE_ONE, UFHTConstants.MUST_HAVE_SEVERITY);
                severStr = severStr.replaceAll(UFHTConstants.VALUE_ZERO, UFHTConstants.GOOD_TO_HAVE_SEVERITY);
                fieldSeverityMap.put(fieldInstance.substringBefore(UFHTConstants.COLON), severStr);
            }
        }
        return fieldSeverityMap;
    }
    
    /**
     * @Author: Eternus Solutions
     * @Description: Method to get List of Ultra_Track_Container__c records
     * @Param: NA
     * @Return: List<Ultra_Track_Container__c>
     * @Date: 01/02/2017
     **/
     public static List<Ultra_Track_Container__c> fetchContainerRecordsFromDB() {
        List<Ultra_Track_Container__c> containerRecordList = new List<Ultra_Track_Container__c>();
        containerRecordList = [SELECT Id,
                                      Object_Label__c,
                                      Tracked_Fields__c,
                                      Object_Name__c
                                      FROM Ultra_Track_Container__c
                                      WHERE Is_Tracking_Enabled__c = : true
                                                                     ORDER BY Object_Label__c];
        if(!containerRecordList.isEmpty()) {
            return containerRecordList;
        }
        return null;
    }
    
    public static String getObjectNameFromPrefix(String pObjPrefix) {
        String objName = '';
        
        for(Schema.SObjectType objectInstance : sobjectMap.values()) {
            if(objectInstance.getDescribe().getKeyPrefix() == pObjPrefix) {
                objName = objectInstance.getDescribe().getName();
            }
        }
        return objName;
    }
    
    public static Id getContainerRecordIdForObj(String pObjName) {
        Id objContainerId;
         
        for(Ultra_Track_Container__c containerInstance : fetchContainerRecordsFromDB()) {
            if(String.valueOf(containerInstance.Object_Name__c).EqualsIgnoreCase(pObjName)) {
                objContainerId = containerInstance.Id;
            }
        }
        return objContainerId;
    }
    
    /**
     * @Author: Eternus Solutions
     * @Description: Method to get first object name of the list of which history tracking is enabled in a sorted order.
     * @Param: selectedObjectList - List of selected Objects.
     * @Return: selectedObject - Name of the first Object of the list.
     * @Date: 08/08/2016
     **/
    public static String getObjectNameForRecordId(list<SelectOption> selectedObjectList, Id pObjectSelectedContainerId) {
        String selectedObject;
        if(selectedObjectList != null && pObjectSelectedContainerId != null) {
               selectedObject = pObjectSelectedContainerId; 
        }
        else if(selectedObjectList != null && pObjectSelectedContainerId == null) {
            selectedObject = selectedObjectList[1].getValue();
        }
        else {
            selectedObject = UFHTConstants.WHITE_SPACE;
        }
        
        return selectedObject;
    }
}