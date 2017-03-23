/**
  * Class Name: UFHTRecordCountTest 
  * @Description: This class contains unit tests for UFHTRecordCountTest.cls
  * ====================================================================================================================
  *       Version   | Date        | Author             | Comments
  * --------------------------------------------------------------------------------------------------------------------
  *       1.0       | 28/02/2017  | Eternus Solutions  | 1.Initial Draft
  * ====================================================================================================================
  **/
@isTest
public class UFHTRecordCountTest {
     /**
      * @Author: Eternus Solutions
      * @Description: Test method to calculate record count.
      * @Expected Result: Recordcount is sum of UFHT__Must_Have__c & UFHT__Good_To_Have__c
      * @Date: 01/03/2017
      **/
    static testMethod void updateRecordCountTestCase1() {
    
        List<UFHT__Ultra_Track_Container__c > ufhtList= new List<UFHT__Ultra_Track_Container__c >();
       
        ufhtList.add(new UFHT__Ultra_Track_Container__c (UFHT__Object_Label__c = 'Account',
                                                         UFHT__Object_Name__c ='Account',
                                                         UFHT__Is_Tracking_Enabled__c =True,
                                                         UFHT__Must_Have__c = 2,
                                                         UFHT__Good_To_Have__c = 3,
                                                         UFHT__Tracked_Fields__c = 'Name:0,Description:0'));
                                                         
        ufhtList.add(new UFHT__Ultra_Track_Container__c (UFHT__Object_Label__c = 'Case',
                                                         UFHT__Object_Name__c ='Case',
                                                         UFHT__Is_Tracking_Enabled__c =True,
                                                         UFHT__Must_Have__c = 2,
                                                         UFHT__Good_To_Have__c = 3,
                                                         UFHT__Tracked_Fields__c = 'Name:0,Description:0'));
        insert ufhtList;
        Test.startTest();
        UFHTRecordCount.updateRecordCount('Account',2,4);
        
        Integer recordCount;
        List<UFHT__Ultra_Track_Container__c> recordCountList = [SELECT UFHT__Number_of_Records__c
                                 FROM UFHT__Ultra_Track_Container__c
                                WHERE UFHT__Object_Name__c = 'Account'];
        for(UFHT__Ultra_Track_Container__c ufht : recordCountList) {
            recordCount = Integer.valueOf(ufht.UFHT__Number_of_Records__c);
        }
        System.assertEquals(11,recordCount );
        Test.stopTest();
     }
     /**
      * @Author: Eternus Solutions
      * @Description: Test method to calculate record count.
      * @Expected Result: Recordcount is sum of UFHT__Must_Have__c & UFHT__Good_To_Have__c
      * @Date: 01/03/2017
      **/
     static testMethod void updateRecordCountTestCase2() {

        List<UFHT__Ultra_Track_Container__c > ufhtList= new List<UFHT__Ultra_Track_Container__c >();
       
        ufhtList.add(new UFHT__Ultra_Track_Container__c (UFHT__Object_Label__c = 'Account',
                                                         UFHT__Object_Name__c ='Account',
                                                         UFHT__Is_Tracking_Enabled__c =True,
                                                         UFHT__Must_Have__c = null,
                                                         UFHT__Good_To_Have__c = 3,
                                                         UFHT__Tracked_Fields__c = 'Name:0,Description:0'));
                                                         
        ufhtList.add(new UFHT__Ultra_Track_Container__c (UFHT__Object_Label__c = 'Case',
                                                         UFHT__Object_Name__c ='Case',
                                                         UFHT__Is_Tracking_Enabled__c =True,
                                                         UFHT__Must_Have__c = 2,
                                                         UFHT__Good_To_Have__c = 3,
                                                         UFHT__Tracked_Fields__c = 'Name:0,Description:0'));
        insert ufhtList;
        Test.startTest();
        UFHTRecordCount.updateRecordCount('Account',1,4);
        
        
        Integer recordCount;
        List<UFHT__Ultra_Track_Container__c> recordCountList = [SELECT UFHT__Number_of_Records__c
                                 FROM UFHT__Ultra_Track_Container__c
                                WHERE UFHT__Object_Name__c = 'Account'];
        for(UFHT__Ultra_Track_Container__c ufht : recordCountList) {
            recordCount = Integer.valueOf(ufht.UFHT__Number_of_Records__c);
        }
        
        System.assertEquals(8,recordCount );
        Test.stopTest();
     }
     
     /**
      * @Author: Eternus Solutions
      * @Description: Test method to calculate record count.
      * @Expected Result: Recordcount is sum of UFHT__Must_Have__c & UFHT__Good_To_Have__c
      * @Date: 01/03/2017
      **/
     static testMethod void updateRecordCountTestCase3() {

        List<UFHT__Ultra_Track_Container__c > ufhtList= new List<UFHT__Ultra_Track_Container__c >();
       
        ufhtList.add(new UFHT__Ultra_Track_Container__c (UFHT__Object_Label__c = 'Account',
                                                         UFHT__Object_Name__c ='Account',
                                                         UFHT__Is_Tracking_Enabled__c =True,
                                                         UFHT__Must_Have__c = 2,
                                                         UFHT__Good_To_Have__c = null,
                                                         UFHT__Tracked_Fields__c = 'Name:0,Description:0'));
                                                         
        ufhtList.add(new UFHT__Ultra_Track_Container__c (UFHT__Object_Label__c = 'Case',
                                                         UFHT__Object_Name__c ='Case',
                                                         UFHT__Is_Tracking_Enabled__c =True,
                                                         UFHT__Must_Have__c = 2,
                                                         UFHT__Good_To_Have__c = 3,
                                                         UFHT__Tracked_Fields__c = 'Name:0,Description:0'));
        insert ufhtList;
        Test.startTest();
        UFHTRecordCount.updateRecordCount('Account',1,4);
        Test.stopTest();
        
        Integer recordCount;
        List<UFHT__Ultra_Track_Container__c> recordCountList = [SELECT UFHT__Number_of_Records__c
                                 FROM UFHT__Ultra_Track_Container__c
                                WHERE UFHT__Object_Name__c = 'Account'];
        for(UFHT__Ultra_Track_Container__c ufht : recordCountList) {
            recordCount = Integer.valueOf(ufht.UFHT__Number_of_Records__c);
        }
        
        System.assertEquals(7,recordCount );
     }
     
     /**
      * @Author: Eternus Solutions
      * @Description: Test method to calculate record count.
      * @Expected Result: Recordcount is sum of UFHT__Must_Have__c & UFHT__Good_To_Have__c 
      * @Date: 01/03/2017
      **/
     static testMethod void updateRecordCountTestCase4() {

        List<UFHT__Ultra_Track_Container__c > ufhtList= new List<UFHT__Ultra_Track_Container__c >();
       
        ufhtList.add(new UFHT__Ultra_Track_Container__c (UFHT__Object_Label__c = 'Account',
                                                         UFHT__Object_Name__c ='Account',
                                                         UFHT__Is_Tracking_Enabled__c =True,
                                                         UFHT__Must_Have__c = null,
                                                         UFHT__Good_To_Have__c = null,
                                                         UFHT__Tracked_Fields__c = 'Name:0,Description:0'));
                                                         
        ufhtList.add(new UFHT__Ultra_Track_Container__c (UFHT__Object_Label__c = 'Case',
                                                         UFHT__Object_Name__c ='Case',
                                                         UFHT__Is_Tracking_Enabled__c =True,
                                                         UFHT__Must_Have__c = 2,
                                                         UFHT__Good_To_Have__c = 3,
                                                         UFHT__Tracked_Fields__c = 'Name:0,Description:0'));
        insert ufhtList;
        Test.startTest();
        UFHTRecordCount.updateRecordCount('Account',1,4);
        Test.stopTest();
        
        Integer recordCount;
        List<UFHT__Ultra_Track_Container__c> recordCountList = [SELECT UFHT__Number_of_Records__c
                                 FROM UFHT__Ultra_Track_Container__c
                                WHERE UFHT__Object_Name__c = 'Account'];
        for(UFHT__Ultra_Track_Container__c ufht : recordCountList) {
            recordCount = Integer.valueOf(ufht.UFHT__Number_of_Records__c);
        }
        
        System.assertEquals(5,recordCount );
     }
     
}