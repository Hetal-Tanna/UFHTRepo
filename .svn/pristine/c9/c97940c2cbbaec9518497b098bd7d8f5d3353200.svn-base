/**
 * Class Name: PostInstallationClassTest
 * @description: Class to test the custom settings data that we are creating after installing package.
 * @author: Eternus Solutions
 * @date:  11-4-2016
 * @revised:   
 */
 @isTest
public class PostInstallationClassTest{
    /**
       * @Author: Eternus Solutions
       * @description : Test Method to test data is creating or not for custom settings "Configuration__c",
                       "Number_Of_Columns__c","Number_Of_Fields_Per_Column__c",
                       "Number_Of_Records_Per_Page__c","View_Field_History_Sharing_Setting__c ","Sort_Fields__c",
                        "Standard_Objects__c","View_Field_History_Date_Filters__c".
       * @Param : 
       * @Return : 
       * @Date:11/04/2016
    */
    static testMethod void onInstallTestCase1(){
        PostInstallationClass objInstall = new PostInstallationClass ();
        Test.testInstall(objInstall, null);
        
        list<Configuration__c> listConfiguration = Configuration__c.getAll().Values();
        system.assertEquals(1,listConfiguration.size());
        system.assertEquals(system.Label.ConfigureColsAndFieldsCustomSettingRecordName,listConfiguration[0].Name);
        system.assertEquals(5,listConfiguration[0].Number_Of_Columns__c);
        system.assertEquals(10,listConfiguration[0].Number_Of_Fields_Per_Column__c);
        system.assertEquals('Ascending',listConfiguration[0].Sort_Fields_By__c);
        
        list<Number_Of_Columns__c> listNumberOfColumns = Number_Of_Columns__c.getAll().Values();
        system.assertEquals(4,listNumberOfColumns.size());
         
        List<Number_Of_Fields_Per_Column__c> listNumberOfFieldsColumns = Number_Of_Fields_Per_Column__c.getAll().Values();
        system.assertEquals(3,listNumberOfFieldsColumns.size());
         
        List<Number_Of_Records_Per_Page__c> listNumberOfHistoryRecords = Number_Of_Records_Per_Page__c.getAll().Values();
        system.assertEquals(4,listNumberOfHistoryRecords.size());
        
        List<Profile> lstProf = [SELECT ID FROM Profile WHERE name='System Administrator' limit 1];
        View_Field_History_Sharing_Setting__c listViewFieldHistorySharingCS = View_Field_History_Sharing_Setting__c.getInstance(lstProf[0].ID);
        system.assertEquals(true,listViewFieldHistorySharingCS.View_All_Data__c);
        system.assertNotEquals(null,listViewFieldHistorySharingCS);
        
        list<Sort_Fields__c> lstSortByOptions = Sort_Fields__c.getAll().Values();
        system.assertEquals(2,lstSortByOptions.size());
        
        list<Standard_Objects__c> lstStandardObjectCS = Standard_Objects__c.getAll().Values();
        system.assertEquals(7,lstStandardObjectCS.size());
        
        list<View_Field_History_Date_Filters__c> lstDateFiltersCSData = View_Field_History_Date_Filters__c.getAll().Values();
        system.assertEquals(9,lstDateFiltersCSData.size());

    }

}