/**
 * Class Name: UltraTrackContainerHandler
 * @Description: This is handler class of trigger "UltraTrackContainerTrigger". 
                 It call the method from class DynamicTriggerGenerator to create trigger on sObject. 
  ========================================================================================================================
        Version   | Date        | Author             | Comments
    -------------------------------------------------------------------------------------------------------------------------
        1.0       | 16-11-2015  | Eternus Solution   | 1.Created Trigger handler.
        1.1       | 29-02-2016  | Eternus Solution   | 1.Changed Method Name from createDynamicTrigger to onInsertCreateDynamicTrigger
   ========================================================================================================================
 */
public with sharing class UltraTrackContainerHandler
{
    /**
        * @Author: Eternus Solutions
        * @Description : Method to call the method from helper class to create trigger on sObject.
        * @Param : tigger.new list and user session ID.
        * @Return : 
        * @Date:16/11/2015
    */
    public void onInsertCreateDynamicTrigger(list<Ultra_Track_Container__c > lstUtc,String strSessionId){   
       if(!lstUtc.isEmpty()){
            for(Ultra_Track_Container__c utc : lstUtc){ 
                if(String.isNotBlank(utc.Object_Name__c) && String.isNotBlank(strSessionId)){
                    String strsObjName = utc.Object_Name__c;
                    //Call Method from helper class 
                    DynamicTriggerGenerator.generateDynamicTrigger(strsObjName,strSessionId);
                } 
            }
       }
   }
}