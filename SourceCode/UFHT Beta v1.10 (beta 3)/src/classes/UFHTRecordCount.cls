/**
 * @Class Name: UFHTRecordCount .
 * @Description: UFHTRecordCount class has a method updateRecordCount that accepts mustHaveCount, goodToHaveCount and 
 *               selected object as three parameters and update the record count in the UFHT__Ultra_Track_Container__c Object.
 * ====================================================================================================================
 *       Version   | Date        | Author             | Comments
 *   ------------------------------------------------------------------------------------------------------------------
 *       1.0       | 01/02/2017  | Eternus Solutions   | 1. Created Class for above functionality.
 * ====================================================================================================================
**/
public class UFHTRecordCount {
    
    
    /**
     * @Author: Eternus Solutions
     * @Description: Method to accept mustHaveCount, goodToHaveCount and Selected Object to update recordCount based on severity.
     * @Param: It takes mustHaveCount, goodToHaveCount as long and objectName as string.
     * @Return: None
     * @Date: 07/02/2017
     **/       
    public static void updateRecordCount(String objectName, long mustHaveCount, long goodToHaveCount) {
        integer maxThreeEntry = 1;
        while(maxThreeEntry <= 3) {
             
            if(String.isNotBlank(objectName) && mustHaveCount != null && goodToHaveCount != null) {
                
                try{
                    if(UltraTrackUtility.checkObjectAndFieldLevelSecurity('UFHT__Ultra_Track_Container__c', 
                                 new list<String> {'Id','UFHT__Object_Name__c','UFHT__Must_Have__c','UFHT__Good_To_Have__c',
                                                    'UFHT__Number_of_Records__c'},
                                 'isAccessible')) {
                        //UFHTList Fetches the selected Object Name
                        list<UFHT__Ultra_Track_Container__c>  ultraFieldHistoryList = [SELECT Id,
                                                                                              UFHT__Object_Name__c,
                                                                                              UFHT__Must_Have__c,
                                                                                              UFHT__Good_To_Have__c,
                                                                                              UFHT__Number_of_Records__c
                                                                                       FROM   UFHT__Ultra_Track_Container__c
                                                                                       WHERE  UFHT__Object_Name__c =: objectName
                                                                                       LIMIT 1
                                                                                       FOR UPDATE];
                       system.debug('ultraFieldHistoryList '+ultraFieldHistoryList  );       
                       if(ultraFieldHistoryList  != null && !ultraFieldHistoryList.isEmpty()) {
                        
                        //Updates field UFHT__No_Of_Records__c  in UFHT__Ultra_Track_Container__c                                                                               
                        //If Musthave count and GoodToHave count both are null
                        if(ultraFieldHistoryList[0].UFHT__Must_Have__c == null && ultraFieldHistoryList[0].UFHT__Good_To_Have__c == null) {
                            ultraFieldHistoryList[0].UFHT__Good_To_Have__c = 0;
                            ultraFieldHistoryList[0].UFHT__Must_Have__c = 0;
                        }
                        //If Musthave count is null
                        else if(ultraFieldHistoryList[0].UFHT__Must_Have__c == null && ultraFieldHistoryList[0].UFHT__Good_To_Have__c != null) {
                            ultraFieldHistoryList[0].UFHT__Must_Have__c = 0;
                        }
                        //If GoodToHave count is null
                        else if(ultraFieldHistoryList[0].UFHT__Must_Have__c != null && ultraFieldHistoryList[0].UFHT__Good_To_Have__c == null) {
                            ultraFieldHistoryList[0].UFHT__Good_To_Have__c = 0;
                        }
                        
                        ultraFieldHistoryList[0].UFHT__Must_Have__c += mustHaveCount;
                        ultraFieldHistoryList[0].UFHT__Good_To_Have__c += goodToHaveCount;
                         if (UFHT__Ultra_Track_Container__c.sObjectType.getDescribe().isUpdateable()) {
                            update ultraFieldHistoryList;
                         }
                       }
                    break; 
                                 }
                }
                catch(DMLException e) {
                    maxThreeEntry++;
                }
                catch(QueryException e) {
                    maxThreeEntry++;
                }        
            }
        }      
    }
}