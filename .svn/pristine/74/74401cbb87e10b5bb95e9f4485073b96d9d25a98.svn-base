/**
  * @Class Name: AggregatePieChartControllerTest
  * @Description: This class contains unit tests for AggregatePieChartController.cls
  * ====================================================================================================================
  *       Version   | Date        | Author             | Comments
  * --------------------------------------------------------------------------------------------------------------------
  *       1.0       | 07/02/2017  | Eternus Solutions  | 1. Created test class for AggregatePieChartController.
  * ====================================================================================================================
  **/
@isTest
public with sharing class AggregatePieChartControllerTest {
    
    private static String BLANKSTRING       = '';
    private static String ABCSTRING         = 'abc';
    private static String CASESTRING        = 'Case';
    private static String ACCOUNTSTRING     = 'Account';
    private static String CAMPAIGNSTRING    = 'Campaign';
    private static String OPPORTUNITYSTRING = 'Opportunity';
    private static String LEADSTRINGSTRING  = 'Lead';
    private static String CONTRACTSTRING    = 'Contract';
    private static String ATTACHSTRING      = 'Unit Test Attachment';
    
    /**
     * @Author: Eternus Solutions
     * @Description: Template method to verify the functionality with valid data.
     * @Param: NA
     * @Date: 07/02/2017
     **/
    public static testMethod void AggregatePieChartControllerTestOne() {
        
        List<UFHT__Ultra_Track_Container__c> UFHTList = new List<UFHT__Ultra_Track_Container__c>();
        
        UFHTList.add(new UFHT__Ultra_Track_Container__c(        UFHT__Object_Name__c = CASESTRING,
                                                               UFHT__Object_Label__c = CASESTRING,
                                                        UFHT__Is_Tracking_Enabled__c = true,
                                                                  UFHT__Must_Have__c = 2,
                                                               UFHT__Good_To_Have__c = 2));
        
        UFHTList.add(new UFHT__Ultra_Track_Container__c(        UFHT__Object_Name__c = ACCOUNTSTRING,
                                                               UFHT__Object_Label__c = ACCOUNTSTRING,
                                                        UFHT__Is_Tracking_Enabled__c = true,
                                                                  UFHT__Must_Have__c = 3,
                                                               UFHT__Good_To_Have__c = 2));
        
        UFHTList.add(new UFHT__Ultra_Track_Container__c(        UFHT__Object_Name__c = CAMPAIGNSTRING,
                                                               UFHT__Object_Label__c = CAMPAIGNSTRING,
                                                        UFHT__Is_Tracking_Enabled__c = true,
                                                                  UFHT__Must_Have__c = 5,
                                                               UFHT__Good_To_Have__c = 2));
        
        UFHTList.add(new UFHT__Ultra_Track_Container__c(        UFHT__Object_Name__c = OPPORTUNITYSTRING,
                                                               UFHT__Object_Label__c = OPPORTUNITYSTRING,
                                                        UFHT__Is_Tracking_Enabled__c = true,
                                                                  UFHT__Must_Have__c = 4,
                                                               UFHT__Good_To_Have__c = 2));
        
        UFHTList.add(new UFHT__Ultra_Track_Container__c(        UFHT__Object_Name__c = LEADSTRINGSTRING,
                                                               UFHT__Object_Label__c = LEADSTRINGSTRING,
                                                        UFHT__Is_Tracking_Enabled__c = true,
                                                                  UFHT__Must_Have__c = 5,
                                                               UFHT__Good_To_Have__c = 2));
        
        UFHTList.add(new UFHT__Ultra_Track_Container__c(        UFHT__Object_Name__c = CONTRACTSTRING,
                                                               UFHT__Object_Label__c = CONTRACTSTRING,
                                                        UFHT__Is_Tracking_Enabled__c = true,
                                                                  UFHT__Must_Have__c = 6,
                                                               UFHT__Good_To_Have__c = 2));
        
        insert UFHTList;
        
        List<UFHT__Ultra_Track_Container__c> UFHTQueryList = [SELECT Id FROM UFHT__Ultra_Track_Container__c];
        for(UFHT__Ultra_Track_Container__c ufhtObj : UFHTList) {
            System.assertNotEquals(null, ufhtObj.Id);
        }
        System.assertEquals(6, UFHTQueryList.size());
        
        List<Attachment> attachList = new List<Attachment>();
        
        for(UFHT__Ultra_Track_Container__c ufhtObj : UFHTList) {
            attachList.add(new Attachment(    Name = ATTACHSTRING,
                                              body = Blob.valueOf(ATTACHSTRING),
                                          parentId = ufhtObj.Id));
        }
        
        insert attachList;
        
        List<Attachment> attachQueryList = [SELECT Id FROM Attachment];
        for(Attachment attachObj : attachQueryList) {
            System.assertNotEquals(null, attachObj.Id);
        }
        System.assertEquals(6, attachQueryList.size());
        
        List<UFHT.AggregatePieChartController.UltraTrackContainerAttachmentWrapper> wrapperListObj = AggregatePieChartController.fetchContainerData();
        System.assertEquals(6, wrapperListObj.size());
        
    }
    
    /**
     * @Author: Eternus Solutions
     * @Description: Template method to verify the functionality with null data.
     * @Param: NA.
     * @Date: 07/02/2017
     **/
    public static testMethod void AggregatePieChartControllerTestTestTwo() {
        
        List<UFHT__Ultra_Track_Container__c> UFHTList = new List<UFHT__Ultra_Track_Container__c>();
        
        UFHTList.add(new UFHT__Ultra_Track_Container__c(        UFHT__Object_Name__c = CASESTRING,
                                                               UFHT__Object_Label__c = CASESTRING,
                                                        UFHT__Is_Tracking_Enabled__c = true,
                                                                  UFHT__Must_Have__c = 2,
                                                               UFHT__Good_To_Have__c = 2));
        
        UFHTList.add(new UFHT__Ultra_Track_Container__c(        UFHT__Object_Name__c = ACCOUNTSTRING,
                                                               UFHT__Object_Label__c = ACCOUNTSTRING,
                                                        UFHT__Is_Tracking_Enabled__c = true,
                                                                  UFHT__Must_Have__c = 3,
                                                               UFHT__Good_To_Have__c = 2));
        
        UFHTList.add(new UFHT__Ultra_Track_Container__c(        UFHT__Object_Name__c = CAMPAIGNSTRING,
                                                               UFHT__Object_Label__c = CAMPAIGNSTRING,
                                                        UFHT__Is_Tracking_Enabled__c = true,
                                                                  UFHT__Must_Have__c = null,
                                                               UFHT__Good_To_Have__c = null));
        
        UFHTList.add(new UFHT__Ultra_Track_Container__c(        UFHT__Object_Name__c = OPPORTUNITYSTRING,
                                                               UFHT__Object_Label__c = OPPORTUNITYSTRING,
                                                        UFHT__Is_Tracking_Enabled__c = true,
                                                                  UFHT__Must_Have__c = 4,
                                                               UFHT__Good_To_Have__c = 2));
        
        UFHTList.add(new UFHT__Ultra_Track_Container__c(        UFHT__Object_Name__c = LEADSTRINGSTRING,
                                                               UFHT__Object_Label__c = LEADSTRINGSTRING,
                                                        UFHT__Is_Tracking_Enabled__c = true,
                                                                  UFHT__Must_Have__c = 5,
                                                               UFHT__Good_To_Have__c = 2));
        
        UFHTList.add(new UFHT__Ultra_Track_Container__c(        UFHT__Object_Name__c = CONTRACTSTRING,
                                                               UFHT__Object_Label__c = CONTRACTSTRING,
                                                        UFHT__Is_Tracking_Enabled__c = true,
                                                                  UFHT__Must_Have__c = 6,
                                                               UFHT__Good_To_Have__c = 2));
        
        insert UFHTList;
        
        List<UFHT__Ultra_Track_Container__c> UFHTQueryList = [SELECT Id FROM UFHT__Ultra_Track_Container__c];
        for(UFHT__Ultra_Track_Container__c ufhtObj : UFHTList) {
            System.assertNotEquals(null, ufhtObj.Id);
        }
        System.assertEquals(6, UFHTQueryList.size());
        
        List<Attachment> attachList = new List<Attachment>();
        
        for(UFHT__Ultra_Track_Container__c ufhtObj : UFHTList) {
            attachList.add(new Attachment(    Name = ATTACHSTRING,
                                              body = Blob.valueOf(ATTACHSTRING),
                                          parentId = ufhtObj.Id));
        }
        
        insert attachList;
        
        List<Attachment> attachQueryList = [SELECT Id FROM Attachment];
        for(Attachment attachObj : attachQueryList) {
            System.assertNotEquals(null, attachObj.Id);
        }
        System.assertEquals(6, attachQueryList.size());
        
        List<UFHT.AggregatePieChartController.UltraTrackContainerAttachmentWrapper> wrapperListObj = AggregatePieChartController.fetchContainerData();
       
        
        
    }
    
   
    
    /**
     * @Author: Eternus Solutions
     * @Description: Template method to verify the functionality with all possible data in wrapper.
     * @Param: NA.
     * @Date: 07/02/2017
     **/
    public static testMethod void AggregatePieChartControllerTestThree() {
        
        Set<Decimal> integerSet = new Set<Decimal>{0, 1, 2, 3, 4, null};
        Set<String>  stringSet  = new Set<String> {BLANKSTRING, ABCSTRING, null};
        
        List<String>  Object_NameList         = new List<String> { BLANKSTRING, null, ABCSTRING};
        List<String>  Object_LabelList        = new List<String> { BLANKSTRING, null, ABCSTRING};
        List<Decimal> Must_HaveList           = new List<Decimal>{ 0, null, 1 };
        List<Decimal> Good_To_HaveList        = new List<Decimal>{ 0, null, 2 };
        List<Decimal> Number_of_RecordsList   = new List<Decimal>{ 0, null, 3 };
        List<Boolean> Is_Tracking_EnabledList = new List<Boolean>{ false, null, true };
        List<Decimal> bodylengthList          = new List<Decimal>{ 0, null, 4 };
        
        for(String loopOne : Object_NameList) {
            for(String loopTwo : Object_LabelList) {
                for(Decimal loopThree : Must_HaveList) {
                    for(Decimal loopFour : Good_To_HaveList) {
                        for(Decimal loopFive : Number_of_RecordsList) {
                            for(Boolean loopSix : Is_Tracking_EnabledList) {
                                for(Decimal loopSeven : bodylengthList) {
                                    UFHT.AggregatePieChartController.UltraTrackContainerAttachmentWrapper wrapperObj = 
                                    new UFHT.AggregatePieChartController.UltraTrackContainerAttachmentWrapper(loopOne,
                                                                                                              loopTwo,
                                                                                                              loopThree,
                                                                                                              loopFour,
                                                                                                              loopFive,
                                                                                                              loopSix,
                                                                                                              loopSeven);
                                    
                                    System.assertEquals(true, stringSet.contains(wrapperObj.Object_Name));
                                    System.assertEquals(true, stringSet.contains(wrapperObj.Object_Label));
                                    System.assertEquals(true, integerSet.contains(wrapperObj.Must_Have));
                                    System.assertEquals(true, integerSet.contains(wrapperObj.Good_To_Have));
                                    System.assertEquals(true, integerSet.contains(wrapperObj.Number_of_Records));
                                    System.assertEquals(true, integerSet.contains(wrapperObj.bodylength));
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}