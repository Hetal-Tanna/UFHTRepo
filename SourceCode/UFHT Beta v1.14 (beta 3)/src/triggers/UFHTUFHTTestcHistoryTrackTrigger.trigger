trigger UFHTUFHTTestcHistoryTrackTrigger On UFHT__Test__c (after Update) { 
 if(trigger.isAfter && trigger.isUpdate) { 
 UFHT.DynamicTriggerGenericHandler.verifyRecursiveCallForAnObject('UFHT__Test__c') ;
 new UFHT.DynamicTriggerGenericHandler().onUpdateStoreHistoryData(trigger.newMap, trigger.oldMap, 'UFHT__Test__c'); }

}