/**
 * @Class Name: TestDataFactory.
 * @Description: This class is used to create test data for multiple Objects.
 * =====================================================================================================================
 *       Version   | Date        | Author             | Comments
 * ---------------------------------------------------------------------------------------------------------------------
 *       1.0       | 25/02/2016  | Eternus Solution   | 1. Created Class to create data for Objects
 * =====================================================================================================================
 **/
 @isTest
public class TestDataFactory {
    /**
     * @Author: Eternus Solutions
     * @Description: Implemented a function to get an instance of Account
     * @Param: Name for account
     * @Return: An instance account record
     * @Date: 26/02/2016
    */
    public static Account getAccount(String accountName) {

        if(accountName == null || String.isBlank(accountName)) {
            return null;
        }
        return (new Account(Name = accountName));
    }

    /**
     * @Author: Eternus Solutions
     * @Description: Implemented a function to get a list of Account.
     * @Param: Number of records to be created for account
     * @Return: A list of account record
     * @Date: 26/02/2016
    */
    public static list<Account> getAccountList(Integer noOfRecords) {

        if(noOfRecords <= 0) {
            return null;
        }
        list<Account> accList = new list<Account>();
        for(Integer index = 0; index < noOfRecords; index++) {
            accList.add(new Account(Name = 'Test' + index));
        }
        return accList;
    }

    /**
     * @Author: Eternus Solutions
     * @Description: Implemented a function to get a list of Attachment
     * @Param: 1. attachmentNameList: list of Attachment name
     *         2. attachmentBodyList: list of Attachment body
     *         3. parentIdList: list of parentId for Attachment
     * @Return: A list of Attachment records
     * @Date: 29/02/2016
    */
    public static list<Attachment> getAttachementList(list<String> attachmentNameList,
                                                      list<Blob> attachmentBodyList,
                                                      list<Id> parentIdList) {

        if((attachmentNameList == null || attachmentNameList.isEmpty()) ||
           (attachmentBodyList == null || attachmentBodyList.isEmpty()) ||
           (parentIdList == null || parentIdList.isEmpty())) {
          return new list<Attachment>();
        }
        list<Attachment> attachmentList = new list<Attachment>();
        for(Integer index = 0; index < attachmentNameList.size(); index++) {
            attachmentList.add(new Attachment (Name = attachmentNameList[index],
                                               Body = attachmentBodyList[index],
                                               ParentId = parentIdList[index]) );
        }
        return attachmentList;
    }

    /**
     * @Author: Eternus Solutions
     * @Description: Implemented a function to get an instance of Configuration
     * @Param: 1. numberOfColumn: Number of column
     *         2. numberOfField: Number of field per column
     *         3. numberOfRecords: Number of records to display
     *         4. fieldsSortBy: Sort order for field.
     * @Return: An instance configuration record
     * @Date: 25/02/2016
    */
    public static Configuration__c getConfiguration(Integer numberOfColumn, Integer numberOfField,
                                                    Integer numberOfRecords, String fieldsSortBy,
                                                    String salesforceBaseUrl) {

        Configuration__c configurationObj = new Configuration__c(Name = System.Label.ConfigureColsAndFieldsCustomSettingRecordName,
                                                                 Number_Of_Columns__c = numberOfColumn == 0 ? 5 : numberOfColumn,
                                                                 Number_Of_Fields_Per_Column__c = numberOfField == 0 ? 10 : numberOfField,
                                                                 Number_Of_Records_Per_Page__c = numberOfRecords == 0 ? 25 : numberOfRecords,
                                                                 Sort_Fields_By__c = String.isBlank(fieldsSortBy) ?
                                                                                     'Ascending' : fieldsSortBy,
                                                                 SalesforceBaseURL__c = String.isBlank(salesforceBaseUrl) ?
                                                                URL.getSalesforceBaseUrl().getHost() : salesforceBaseUrl);
        return configurationObj;
    }

    /**
     * @Author: Eternus Solutions
     * @Description: Implemented a function to get an instance of Contact.
     * @Param: Lastname and AccountId for Contact
     * @Return: An instance contact record
     * @Date: 30/05/2016
    */
    public static Contact getContact(String lastName, Id accId) {

        if(lastName == null || String.isBlank(lastName)) {
            return null;
        }
        return new Contact(lastName = lastName, AccountId = accId);
    }

    /**
     * @Author: Eternus Solutions
     * @Description: Implemented a function to get an instance of Contact with 5 fields.
     * @Param: FirstName, Lastname, AccountId, HomePhone, LeadSource of Contact
     * @Return: An instance contact record
     * @Date: 30/05/2016
    */
    public static Contact getContact(String firstName, String lastName, String otherPhone,
                                     String homePhone, String leadSource) {

        if(lastName == null || String.isBlank(lastName)) {
            return null;
        }
        return new Contact(firstName = firstName,
                           lastName = lastName,
                           OtherPhone = otherPhone,
                           HomePhone = homePhone,
                           LeadSource = leadSource);
    }

    /**
     * @Author: Eternus Solutions
     * @Description: Implemented a function to get a list of contact instances.
     * @Param: Number of records to be created of Contact
     * @Return: A list of contact instance record
     * @Date: 30/05/2016
    */
    public static list<Contact> getContactList(Integer noOfRecords) {

        if(noOfRecords <= 0) {
          return null;
        }
        list<Contact> conList = new list<Contact>();
        for(Integer index = 0; index < noOfRecords; index++) {
            conList.add(new Contact(LastName = 'Test' + index));
        }
        return conList;
    }

    /**
     * @Author: Eternus Solutions
     * @Description: Implemented a function to get list of DateFilterWrapper
     * @Param: 1. srNumberList: Serial number which is used to sort date filters.
     *         2. nameList: Name of date filters.
     * @Return: An instance of UFHT__Encrypted_Field_Mask.
     * @Date: 25/07/2016
     **/
    public static list<DateFilterWrapper> getDateFilter(list<Integer> srNumberList, list<String> nameList) {
        list<DateFilterWrapper> dateFilterWrapperList = new list<DateFilterWrapper>();
        for(Integer index = 0; index < srNumberList.size(); index++) {
            dateFilterWrapperList.add(new DateFilterWrapper(srNumberList[index],
                                                            nameList[index]));
        }
        return dateFilterWrapperList;
    }

    /**
     * @Author: Eternus Solutions
     * @Description: Implemented a function to share record of Sharing_Purpose.
     * @Param: 1. filterName: Name of filter.
     *         2. value: Value for filter
     *         3. categories: Categories for filter.
     *         4. srNo: Serial number for filter.
     * @Return: A list of View_Field_History_Date_Filters records.
     * @Date: 26/02/2016
    */
    public static list<View_Field_History_Date_Filters__c> getDateFilters(String filterName,
                                                                          String value,
                                                                          String categories,
                                                                          Integer srNo) {
        if(filterName == null || String.isBlank(filterName)) {
            return new list<View_Field_History_Date_Filters__c>();
        }
        return (new list<View_Field_History_Date_Filters__c> {new View_Field_History_Date_Filters__c
                                                             (Name = filterName,
                                                               Value__c = value,
                                                               Month_Week_Day_Filter_Category__c = categories,
                                                               Sr_No__c = srNo)
                                                             }
               );
   }

   /**
     * @Author: Eternus Solutions
     * @Description: Implemented a function to get record of UFHT__Encrypted_Field_Mask.
     * @Param: 1. encryptedFieldTypeName: Name of encrypted Field Type.
     *         2. regex: regular expression for encrypted Field Type.
     * @Return: An instance of UFHT__Encrypted_Field_Mask.
     * @Date: 25/07/2016
     **/
    public static UFHT__Encrypted_Field_Mask__c  getEncryptedFieldMask(String encryptedFieldTypeName,
                                                                        String regex) {
        if(encryptedFieldTypeName == null || String.isBlank(encryptedFieldTypeName) ||
           encryptedFieldTypeName == regex || String.isBlank(regex)) {
          return new UFHT__Encrypted_Field_Mask__c();
        }
        return (new UFHT__Encrypted_Field_Mask__c(Name = encryptedFieldTypeName,
                                                  UFHT__RegEx__c = regex
                                                  )
               );
    }

    /**
     * @Author: Eternus Solutions
     * @Description: Function to get an instance of Group
     * @Param: 1. pGroupname: Name for group
     *         2. developerName: DeveloperName for group
     * @Return: An instance group record
     * @Date: 25/02/2016
    */
    public static Group getGroup(String pGroupname, String developerName) {

        if((pGroupname == null || String.isBlank(pGroupname)) ||
         (developerName == null || String.isBlank(developerName))) {
            return new Group();
        }
        return new Group(Name = pGroupname, DeveloperName = developerName);
    }

    /**
     * @Author: Eternus Solutions
     * @Description: Implemented a function to get an list of GroupMembers
     * @Param: 1. groupId: Id of group
     *         2. userIdSet: Set of user Id.
     * @Return: An instance list of groupmembers
     * @Date: 25/02/2016
    */
    public static list<GroupMember> getGroupMemeber(Id groupId, Set<Id> userIdSet) {

        if(groupId == null ||
          (userIdSet == null || userIdSet.isEmpty())) {
            return new list<GroupMember>();
        }
        list<GroupMember> listGroupMember = new list<GroupMember>();
        GroupMember objGroupMember;
        // loop the users that have been created
        for (Id userId : userIdSet) {
            objGroupMember = new GroupMember();
            objGroupMember.GroupId = groupId;
            objGroupMember.UserOrGroupId = userId;
            listGroupMember.add(objGroupMember);
        }
        return listGroupMember;
    }

    /**
     * @Author: Eternus Solutions
     * @Description: Implemented a function to get a instance of History
     * @Param: 1. oldValue: old value for field
     *         2. newValue: new value for field
     *         3. parentId: record Id
     *         4. userId: user Id
     *         5. modifiedDateList: modified dateTime
     * @Return: An instance of history records
     * @Date: 21/07/2016
    */
    public static HistoryWrapper getHistoryInstance(String oldValue,
                                                    String newValue,
                                                    String parentId,
                                                    String userId,
                                                    DateTime modifiedDate
                                                   ) {
        if(String.isBlank(parentId) &&
           String.isBlank(userId)) {
             return null;
         }
            return new HistoryWrapper(oldValue, newValue, parentId, userId, modifiedDate);
    }

    /**
     * @Author: Eternus Solutions
     * @Description: Implemented a function to get a list of History
     * @Param: 1. oldValueList: list of old value for field
     *         2. newValueList: list of new value for field
     *         3. parentIdList: record Id
     *         4. userIdList: user Id
     *         5. userNameList: user name.
     *         6. modifiedDateList: list of modified dateTime
     *         7. ActionList: list of actions
     * @Return: A list of history records
     * @Date: 25/02/2016
    */
    public static list<HistoryWrapper> getHistoryList(list<String> oldValueList,
                                                      list<String> newValueList,
                                                      Id parentId,
                                                      Id userId,
                                                      list<DateTime> modifiedDateList
                                                      ) {
        if((oldValueList == null || oldValueList.isEmpty()) ||
           (newValueList == null || newValueList.isEmpty()) ||
            (modifiedDateList == null || modifiedDateList.isEmpty())) {
             return new list<HistoryWrapper>();
        }
        list<HistoryWrapper> historyList = new list<HistoryWrapper>();
        for(Integer index = 0; index < oldValueList.size(); index++) {
            historyList.add(new HistoryWrapper(oldValueList[index],
                                           newValueList[index],
                                           parentId,
                                           userId,
                                           modifiedDateList[index]
                                              )
                           );
        }
        return historyList;
    }

    /**
     * @Author: Eternus Solutions
     * @Description: Implemented a function to get a list of Number_Of_Columns__c
     * @Param: Number Of Columns in list
     * @Return: A list of Number_Of_Columns__c records
     * @Date: 29/02/2016
    */

    public static list<Number_Of_Columns__c> getNumberOfColumnList(list<String> numberOfColumnList) {

        if(numberOfColumnList == null || numberOfColumnList.isEmpty()) {
            return new list<Number_Of_Columns__c>();
        }
        list<Number_Of_Columns__c> numberOfColumnsList = new list<Number_Of_Columns__c>();
        for(Integer index = 0; index < numberOfColumnList.size(); index++) {
            numberOfColumnsList.add(new Number_Of_Columns__c (Name = numberOfColumnList[index]));
        }
        return numberOfColumnsList;
    }

    /**
     * @Author: Eternus Solutions
     * @Description: Implemented a function to get a list of Number_Of_Columns__c
     * @Param:  Number of columns per field list
     * @Return: A list of Number_Of_Columns__c records
     * @Date: 29/02/2016
    */
    public static list<Number_Of_Fields_Per_Column__c> getNumberOfFieldPerColumnList(list<String> numberOfFieldPerColumnList) {

        if(numberOfFieldPerColumnList == null || numberOfFieldPerColumnList.isEmpty()) {
            return new list<Number_Of_Fields_Per_Column__c>();
        }
        list<Number_Of_Fields_Per_Column__c> numberOfFieldPerColumnsList = new list<Number_Of_Fields_Per_Column__c>();
        for(Integer index = 0; index < numberOfFieldPerColumnList.size(); index++) {
            numberOfFieldPerColumnsList.add(new Number_Of_Fields_Per_Column__c (Name = numberOfFieldPerColumnList[index]));
        }
        return numberOfFieldPerColumnsList;
    }

    /**
     * @Author: Eternus Solutions
     * @Description: Implemented a function to get an instance of Sharing_Purpose
     * @Param: Name for record
     * @Return: An instance Sharing_Purpose.
     * @Date: 26/02/2016
    */
    public static Sharing_Purpose__c getSharing_Purpose(String sharingName) {
        // It will return null in case of invalid data. Please handle this condition in test code
        if(String.isNotBlank(sharingName)) {
            return new Sharing_Purpose__c(Name = sharingName);
        }
        else {
            return null;
        }
   }

   /**
     * @Author: Eternus Solutions
     * @Description: Implemented a function to share record of Sharing_Purpose.
     * @Param: 1. UserOrGroupId: User or group Id.
     *         2. ParentId: Id of Sharing_Purpose.
     *         3. AccessLevel: Accesslevel for Sharing_Purpose for passed UserOrGroupId.
     * @Return: An instance share object of Sharing_Purpose.
     * @Date: 26/02/2016
    */
    public static Sharing_Purpose__share getSharing_PurposeSharing(String UserOrGroupId,
                                                                  String ParentId,
                                                                  String AccessLevel) {
        // It will return null in case of invalid data. Please handle this condition in test code
        if(String.isNotBlank(UserOrGroupId) && String.isNotBlank(ParentId) && String.isNotBlank(AccessLevel)) {
            return new Sharing_Purpose__share(UserOrGroupId = UserOrGroupId, ParentId = ParentId, AccessLevel = AccessLevel);
        }
        else {
            return null;
        }
    }

    /**
     * @Author: Eternus Solutions
     * @Description: Implemented a function to get a list of Ultra_Track_Container__c
     * @Param: 1. objectNameList: list of object name
     *         2. objectLabelList: list of object label
     *         3. isSelectedObjectList: list of isSelectedObject field
     *         4. selectedFieldList: list of selected fields for object
     * @Return: A list of FieldHistoryTrackingSetting records
     * @Date: 25/02/2016
    */
    public static list<Ultra_Track_Container__c> getUltraTrackContainerList(list<String> objectNameList,
                                                                            list<String> objectLabelList,
                                                                            list<Boolean> isSelectedObjectList,
                                                                            list<String> selectedFieldList) {

        list<Ultra_Track_Container__c> ultraTrackContainerList = new list<Ultra_Track_Container__c>();
        if(objectNameList != null && !objectNameList.isEmpty()) {
            for(Integer index = 0; index < objectNameList.size(); index++) {
                ultraTrackContainerList.add(new Ultra_Track_Container__c (Object_Name__c = objectNameList[index],
                                                                        Object_Label__c = (objectLabelList.isEmpty() || objectLabelList == null) ?
                                                                        null : objectLabelList[index],
                                                                        Is_Tracking_Enabled__c = (isSelectedObjectList.isEmpty() || isSelectedObjectList == null) ?
                                                                        null : isSelectedObjectList[index],
                                                                        Tracked_Fields__c = (selectedFieldList.isEmpty() || selectedFieldList == null) ?
                                                                        null : selectedFieldList[index]));
            }
        }
        return ultraTrackContainerList;
    }

    /**
     * @Author: Eternus Solutions
     * @Description: Implemented a function to get a list of UltraTrackWrapper record.
     * @Param: 1. fieldApiNameList list of field api name
     *         2. fieldLabelList list of field label name.
     *         3. list<list<HistoryWrapper>> list of list HistoryWrapper.
     *         4. list<boolean> list of isSelected.
     * @Return: A list of UltraTrackWrapper records
     * @Date: 25/02/2016
     **/
    public static list<UltraTrackWrapper> getUltraTrackList(list<String> fieldApiNameList,
                                                            list<String> fieldLabelList,
                                                            list<list<HistoryWrapper>> listHistoryList,
                                                            list<Boolean> isSelectedList) {

        list<UltraTrackWrapper> ultraTrackWrapperList = new list<UltraTrackWrapper>();
        if(listHistoryList != null && !listHistoryList.isEmpty()) {
            for(Integer index = 0; index < fieldApiNameList.size(); index++) {
                ultraTrackWrapperList.add(new UltraTrackWrapper(fieldApiNameList[index],
                                                                fieldLabelList[index],
                                                                listHistoryList[index]));
            }
        }
        else if(isSelectedList != null && !isSelectedList.isEmpty()) {
            for(Integer index = 0; index < fieldApiNameList.size(); index++) {
                ultraTrackWrapperList.add(new UltraTrackWrapper(fieldApiNameList[index],
                                                                fieldLabelList[index],
                                                                isSelectedList[index]));
            }
        }
        return ultraTrackWrapperList;
    }
    /**
     * @Author: Eternus Solutions
     * @Description: Implemented a function to get a list of UltraTrackWrapper record.
     *               Used constructor which have two parameters.
     * @Param: 1. fieldApiNameList list of field api name
     *         2. fieldLabelList list of field label name.
     * @Return: A list of UltraTrackWrapper records
     * @Date: 25/07/2016
     **/
    public static list<UltraTrackWrapper> getUltraTrackList(list<String> fieldApiNameList,
                                                            list<String> fieldLabelList
                                                           ) {

        list<UltraTrackWrapper> ultraTrackWrapperList = new list<UltraTrackWrapper>();
        if((fieldApiNameList == null || fieldApiNameList.isEmpty())
            || (fieldLabelList == null || fieldLabelList.isEmpty())) {
            return ultraTrackWrapperList;
        }
        for(Integer index = 0; index < fieldApiNameList.size(); index++) {
            ultraTrackWrapperList.add(new UltraTrackWrapper(fieldApiNameList[index],
                                                            fieldLabelList[index]
                                                            )
                                     );
        }
        return ultraTrackWrapperList;
    }

    /**
     * @Author: Eternus Solutions
     * @Description: Implemented a function to get an instance of User.
     * @Param: Lastname, Alias, Username and profileId to create user
     * @Return: An instance of User.
     * @Date: 26/02/2016
     */
    public static User getUser(String lastName, String alias, String userName, String profileId ) {
        // It will return null in case of invalid data. Please handle this condition in test code
        if(String.isNotBlank(lastName) && String.isNotBlank(alias) && String.isNotBlank(userName)) {
            return new User(Alias = alias,
                            LastName = lastName,
                            Email = 'test@test.com',
                            EmailEncodingKey = 'UTF-8',
                            languagelocalekey = 'en_US',
                            localesidkey = 'hi_IN',
                            timezonesidkey = 'Asia/Kolkata',
                            CompanyName = 'Test Company',
                            Username = userName,
                            CommunityNickname = alias,
                            IsActive = true,
                            ProfileID = profileId);
        }
        return null;
    }

    /**
     * @Author: Eternus Solutions
     * @Description: Implemented a function to get an instance of User
     * @Param: Lastname, Alias, Username, profileId and RoleId to create user
     * @Return: An instance of User.
     * @Date: 26/02/2016
     */
    public static User getUser(String lastName, String alias, String userName, String profileId, String roleId ) {
        // It will return null in case of invalid data. Please handle this condition in test code
        if(String.isNotBlank(lastName) && String.isNotBlank(alias) && String.isNotBlank(userName)) {
            return new User(Alias = alias,
                            LastName = lastName,
                            Email = 'test@test.com',
                            EmailEncodingKey = 'UTF-8',
                            languagelocalekey = 'en_US',
                            localesidkey = 'en_US',
                            timezonesidkey = 'America/Los_Angeles',
                            CompanyName = 'Test Company',
                            Username = userName,
                            CommunityNickname = alias,
                            IsActive = true,
                            ProfileID = profileId,
                            UserRoleId  = roleId);
        }
        else {
            return null;
        }
    }

    /**
     * @Author: Eternus Solutions
     * @Description: Implemented a function to get an instance of User
     * @Param: Lastname, Alias, Username, profileId and ManagerId to create user
     * @Return: An instance of User.
     * @Date: 26/02/2016
     */
    public static User getUser(String lastName, String alias, String userName, String profileId, Id managerId ) {
        // It will return null in case of invalid data. Please handle this condition in test code
        if(String.isNotBlank(lastName) && String.isNotBlank(alias) && String.isNotBlank(userName)) {
            return new User(Alias = alias,
                            LastName = lastName,
                            Email = 'test@test.com',
                            EmailEncodingKey = 'UTF-8',
                            languagelocalekey = 'en_US',
                            localesidkey = 'en_US',
                            timezonesidkey = 'America/Los_Angeles',
                            CompanyName = 'Test Company',
                            Username = userName,
                            CommunityNickname = alias,
                            IsActive = true,
                            ProfileID = profileId,
                            ManagerId = managerId);
        }
        else{
            return null;
        }
    }

    /**
     * @Author: Eternus Solutions
     * @Description: Implemented a function to get an instance of User
     * @Param: Lastname, Alias, Username, locale and profileId to create user
     * @Return: An instance of User.
     * @Date: 28/02/2016
     **/
    public static User getUserWithLocale(String lastName,
                                         String alias,
                                         String userName,
                                         String locale,
                                         String profileId) {
        User userObj;
        // It will return null in case of invalid data. Please handle this condition in test code
        if(String.isNotBlank(lastName) && String.isNotBlank(alias) && String.isNotBlank(userName) && String.isNotBlank(locale)) {
            userObj = new User(Alias = alias,
                            LastName = lastName,
                            Email = 'test@test.com',
                            EmailEncodingKey = 'UTF-8',
                            languagelocalekey = 'en_US',
                            localesidkey = locale,
                            timezonesidkey = 'Asia/Kolkata',
                            CompanyName = 'Test Company',
                            Username = userName,
                            CommunityNickname = alias,
                            IsActive = true,
                            ProfileID = profileId);
            System.assertNotEquals(null, userObj);
            return userObj;
        }
        System.assertEquals(null, userObj);
        return null;
    }
}