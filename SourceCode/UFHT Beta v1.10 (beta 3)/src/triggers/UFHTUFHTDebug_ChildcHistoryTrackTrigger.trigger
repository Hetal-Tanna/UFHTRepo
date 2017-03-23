trigger UFHTUFHTDebug_ChildcHistoryTrackTrigger On UFHT__Debug_Child__c (after Update) { 
 if(trigger.isAfter && trigger.isUpdate) { 
 UFHT.DynamicTriggerGenericHandler.verifyRecursiveCallForAnObject('UFHT__Debug_Child__c') ;
 new UFHT.DynamicTriggerGenericHandler().onUpdateStoreHistoryData(trigger.newMap, trigger.oldMap, 'UFHT__Debug_Child__c'); }

}