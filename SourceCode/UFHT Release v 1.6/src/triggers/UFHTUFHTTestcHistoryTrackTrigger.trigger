trigger UFHTUFHTTestcHistoryTrackTrigger On UFHT__Test__c (after Update) { 
 if(!UFHT.DynamicTriggerGenericHandler.hasAlreadyRun && trigger.isAfter && trigger.isUpdate) {
 UFHT.DynamicTriggerGenericHandler objDataHandler = new UFHT.DynamicTriggerGenericHandler();
 objDataHandler.onUpdateStoreHistoryData(trigger.newMap, trigger.oldMap, 'UFHT__Test__c');
UFHT.DynamicTriggerGenericHandler.hasAlreadyRun = true;
}
}