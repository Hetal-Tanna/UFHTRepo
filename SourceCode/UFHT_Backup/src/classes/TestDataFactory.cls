/**
 * Class Name: TestDataFactory
 * @description: Class having getter function for test data for various entities in SF Org
 * @author: Amruta Kumbhakarn
 * @date:  25-2-2016
 * @revised:   
 */
 @isTest
public class TestDataFactory {
    
   /**
     * @author Amruta Kumbhakarn
     * @description  Function to get an list of UltraTrackWrapper record.
     * @param 1. fieldApiNameList list of field api name
     *        2. fieldLabelList list of field label name.
     *        3. list<list<History>> list of list history.
     *        4. list<boolean> list of isSelected.
     * @return an list of UltraTrackWrapper records
     * @date 25-2-2016
    */ 
    public static List<UltraTrackWrapper> getUltraTrackList(list<string> fieldApiNameList,
                                                            list<string> fieldLabelList,
                                                            list<list<HistoryWrapper>> listHistoryList,
                                                            list<boolean> isSelectedList
                                               ) {
        list<UltraTrackWrapper> ultraTrackWrapperList = new list<UltraTrackWrapper>();
        if(!listHistoryList.isEmpty()) {
            for(integer index = 0; index < fieldApiNameList.size(); index ++) {
                ultraTrackWrapperList.add(new UltraTrackWrapper(fieldApiNameList[index],
                                                                fieldLabelList[index], 
                                                                listHistoryList[index]
                                                               )
                                         );             
            }
        }
        
        else if(!isSelectedList.isEmpty()) {
            for(integer index = 0; index < fieldApiNameList.size(); index ++) {
                ultraTrackWrapperList.add(new UltraTrackWrapper(fieldApiNameList[index],
                                                                fieldLabelList[index], 
                                                                isSelectedList[index]
                                                               )
                                         );              
            }
            
        }
        return ultraTrackWrapperList ;
    } 
    
     /**
     * @author Amruta Kumbhakarn
     * @description  Function to get an instance of Account
     * @param 1. name for account
     * @return an instance account record
     * @date 26-2-2016
    */ 
    public static Account getAccount(string name){
        Account accountObj = new Account(Name = name);
        return accountObj;
    }
    
    /**
     * @author Amruta Kumbhakarn
     * @description  Function to get an list of Account
     * @param 1. noOfRecords for account
     * @return an list account record
     * @date 26-2-2016
    */ 
    public static list<Account> getAccountList(integer noOfRecords){
        list<Account> accList = new list<Account>();
        for(integer index = 0; index < noOfRecords; index++) {
            accList.add(new Account(Name = 'Test'+index));
        }
        return accList;
    }

    /**
     * @author Certification Candidate
     * @description  Function to get an instance of User
     * @date 3-2-2016
     */ 
    public static User getUser(String lastName, String alias, String userName, String ProfileId ){
        return new User(
                        Alias = alias,
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
                        ProfileID = ProfileId);
    }
    
    /**
     * @author Certification Candidate
     * @description  Function to get an instance of User
     * @date 3-2-2016
     */ 
    public static User getUser(String lastName, String alias, String userName, String ProfileId, string roleId ){
        return new User(
                        Alias = alias,
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
                        ProfileID = ProfileId,
                        UserRoleId  = roleId);
    }
    
    /**
     * @author Certification Candidate
     * @description  Function to get an instance of User
     * @date 3-2-2016
     */ 
    public static User getUser(String lastName, String alias, String userName, String ProfileId, Id managerId ){
        return new User(
                        Alias = alias,
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
                        ProfileID = ProfileId,
                        ManagerId = managerId);
    }
    /**
     * @author Amruta Kumbhakarn
     * @description  Function to get an list of History
     * @param 1. oldValueList list of old value for field
     *        2. newValueList list of new value for field
     *        3. parentIdList record Id
     *        4. userIdList user Id
     *        5. userNameList user name.
     *        6. modifiedDateList list of modified dateTime
     *        7. ActionList list of actions
     * @return an list of history records
     * @date 25-2-2016
    */ 
    public static List<HistoryWrapper> getHistoryList(list<string> oldValueList,
                                               list<string> newValueList,
                                               string parentId,
                                               string userId,
                                               string userName,
                                               list<DateTime> modifiedDateList,
                                               list<string> ActionList
                                               ) {
        list<HistoryWrapper> historyList = new list<HistoryWrapper>();
        for(integer index = 0; index < oldValueList.size(); index ++) {
            historyList.add(new HistoryWrapper(oldValueList[index],
                                        newValueList[index], 
                                        parentId,
                                        userId,
                                        userName,
                                        modifiedDateList[index],
                                        ActionList[index]
                                        )
                           );
        }
        
        return historyList;
    } 
    
    /**
     * @author Amruta Kumbhakarn
     * @description  Function to get an list of Ultra_Track_Container__c
     * @param 1. objectNameList list of object name
     *        2. objectLabelList list of object label
     *        3. isSelectedObjectList list of isSelectedObject field
     *        4. selectedFieldList list of selected fields for object
     * @return an list of FieldHistoryTrackingSetting records
     * @date 25-2-2016
    */ 
    public static list<Ultra_Track_Container__c> getUltraTrackContainerList(list<string> objectNameList,
                                                                            list<string> objectLabelList,
                                                                            list<boolean> isSelectedObjectList,
                                                                            list<string> selectedFieldList) {
                                                                                        
        list<Ultra_Track_Container__c> ultraTrackContainerList = new list<Ultra_Track_Container__c>();
        for(integer index = 0; index <objectNameList.size(); index ++) {
            ultraTrackContainerList.add(new Ultra_Track_Container__c (Object_Name__c = objectNameList[index],
                                                                      Object_Label__c = objectLabelList[index],
                                                                      Is_Tracking_Enabled__c = isSelectedObjectList[index],
                                                                      Tracked_Fields__c = selectedFieldList.isEmpty() ? null : selectedFieldList[index]
                                                                      ) 
                                       );
        }
        return ultraTrackContainerList;   
    }
    
    /**
     * @author Amruta Kumbhakarn
     * @description  Function to get an list of Attachment
     * @param 1. attachmentNameList list of Attachment name
     *        2. attachmentBodyList list of Attachment body
     *        3. parentIdList list of parentId for Attachment
     * @return an list of Attachment records
     * @date 29-2-2016
    */ 
    public static list<Attachment> getAttachementList(list<string> attachmentNameList, 
                                                      list<blob> attachmentBodyList, 
                                                      list<Id> parentIdList) {
        list<Attachment> attachmentList = new list<Attachment>();
        for(integer index = 0; index <attachmentNameList.size(); index ++) {
            attachmentList.add(new Attachment (Name = attachmentNameList[index],
                                               Body = attachmentBodyList[index],
                                               ParentId = parentIdList[index]
                                              ) 
                              );
        }
        return attachmentList;
    }
    
    /**
     * @author Amruta Kumbhakarn
     * @description  Function to get an list of Number_Of_Columns__c
     * @param 1. numberOfColumnList list of number of columns
     * @return an list of Number_Of_Columns__c records
     * @date 29-2-2016
    */ 
    public static list<Number_Of_Columns__c> getNumberOfColumnList(list<string> numberOfColumnList) {
        list<Number_Of_Columns__c> numberOfColumnsList = new list<Number_Of_Columns__c>();
        for(integer index = 0; index <numberOfColumnList.size(); index ++) {
            numberOfColumnsList.add(new Number_Of_Columns__c (Name = numberOfColumnList[index]
                                                              ) 
                              );
        }
        return numberOfColumnsList;
    }
    
    /**
     * @author Amruta Kumbhakarn
     * @description  Function to get an list of Number_Of_Columns__c
     * @param 1. numberOfColumnList list of number of columns
     * @return an list of Number_Of_Columns__c records
     * @date 29-2-2016
    */ 
    public static list<Number_Of_Fields_Per_Column__c> getNumberOfFieldPerColumnList(list<string> numberOfFieldPerColumnList) {
        list<Number_Of_Fields_Per_Column__c> numberOfFieldPerColumnsList = new list<Number_Of_Fields_Per_Column__c>();
        for(integer index = 0; index <numberOfFieldPerColumnList.size(); index ++) {
            numberOfFieldPerColumnsList.add(new Number_Of_Fields_Per_Column__c (Name = numberOfFieldPerColumnList[index]
                                                                               ) 
                                           );
        }
        return numberOfFieldPerColumnsList;
    }
    
    /**
     * @author Amruta Kumbhakarn
     * @description  Function to get an list of Number_Of_Records_Per_Page__c
     * @param 1. numberHistorRecordsList list of number of history records to display
     * @return an list of Number_Of_Records_Per_Page__c records
     * @date 29-2-2016
    */ 
    public static list<Number_Of_Records_Per_Page__c> getNumberOfHistoryRecordsList(list<string> numberOfHistoryRecordsList) {
        list<Number_Of_Records_Per_Page__c> numberOfRecordsList = new list<Number_Of_Records_Per_Page__c>();
        for(integer index = 0; index <numberOfHistoryRecordsList.size(); index ++) {
            numberOfRecordsList .add(new Number_Of_Records_Per_Page__c(Name = numberOfHistoryRecordsList[index]
                                                              ) 
                              );
        }
        return numberOfRecordsList ;
    }
    
    /**
     * @author Amruta Kumbhakarn
     * @description  Function to get an instance of Configuration
     * @param 1. numberOfColumn number of column
     *        2. numberOfField number of field per column
              3. number of records to display.
     * @return an instance configuration record
     * @date 25-2-2016
    */ 
    public static Configuration__c getConfiguration(integer numberOfColumn, integer numberOfField, integer numberOfRecords, String fieldsSortBy){
        Configuration__c configurationObj = new Configuration__c(Name = system.Label.ConfigureColsAndFieldsCustomSettingRecordName,
                                                                 Number_Of_Columns__c = numberOfColumn,
                                                                 Number_Of_Fields_Per_Column__c = numberOfField,
                                                                 Number_Of_Records_Per_Page__c = numberOfRecords,
                                                                 Sort_Fields_By__c = fieldsSortBy);
        return configurationObj;
    }
    
    public static Group getGroup(string name, string developerName) {
        return new Group(Name = name,
                         DeveloperName = developerName);
    }
    
    public static list<GroupMember> getGroupMemeber(Id groupId, set<Id> userIdSet) {
        List<GroupMember>listGroupMember =new List<GroupMember>();  
        system.debug('DDDD'+userIdSet);
        // loop the users that have been created
         for (Id userId : userIdSet){
              GroupMember gm= new GroupMember(); 
              gm.GroupId= groupId;
              gm.UserOrGroupId = userId;
              listGroupMember.add(gm);   
         } 
         system.debug('DDDD'+listGroupMember);
        return listGroupMember;
    }
   public static View_Field_History_Sharing_Setting__c getViewFieldHistorySharingSetting(){
       List<Profile> lstProf = [SELECT ID FROM Profile WHERE name='System Administrator' limit 1];
       View_Field_History_Sharing_Setting__c objCS = new View_Field_History_Sharing_Setting__c();
       if(!lstProf.isEmpty()){
           objCS.View_All_Data__c = true;
           objCS.SetupOwnerId = lstProf[0].ID;
      }
      return objCS;
   }
   
   /**
     * @author Amruta Kumbhakarn
     * @description  Function to get an instance of Account
     * @param 1. name for account
     * @return an instance account record
     * @date 26-2-2016
    */ 
    public static Sharing_Purpose__c getSharing_Purpose(string name){
        Sharing_Purpose__c Obj = new Sharing_Purpose__c(Name = name);
        return Obj;
   }
   
   public static Sharing_Purpose__share getSharing_PurposeSharing(string UserOrGroupId, string ParentId, string AccessLevel){
        Sharing_Purpose__share Obj = new Sharing_Purpose__share(UserOrGroupId = UserOrGroupId, ParentId= ParentId, AccessLevel = AccessLevel);
        return Obj;
   }
   
   public static list<View_Field_History_Date_Filters__c> getDateFileters(string name, string value, string categories, integer no) {
        return (new list<View_Field_History_Date_Filters__c> {new View_Field_History_Date_Filters__c(Name = name,
                                                                                             Value__c = value,
                                                                                             Month_Week_Day_Filter_Category__c = categories,
                                                                                             Sr_No__c = no)});
   }
   
   public static list<Standard_Objects__c> getStandardObjects(map<string, string> stadardObjectMap) {
   	    list<Standard_Objects__c> objectList = new list<Standard_Objects__c>();
   	    for(string str : stadardObjectMap.keySet()) {
   	    	objectList.add(new Standard_Objects__c(Name = str, Organization_Field_Name__c = stadardObjectMap.get(str)));
   	    }
   	    return objectList;
   }
}