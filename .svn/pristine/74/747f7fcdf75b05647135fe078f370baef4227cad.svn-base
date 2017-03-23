trigger UFHTUFHTErrorLogcHistoryTrackTrigger On UFHT__ErrorLog__c (after Update) { 
 if(!UFHT.DynamicTriggerGenericHandler.verifyRecursiveCallForAnObject('UFHT__ErrorLog__c') && trigger.isAfter && trigger.isUpdate) {
 UFHT.DynamicTriggerGenericHandler objDataHandler = new UFHT.DynamicTriggerGenericHandler();
 objDataHandler.onUpdateStoreHistoryData(trigger.newMap, trigger.oldMap, 'UFHT__ErrorLog__c');
}
}