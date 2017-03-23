trigger UFHTAccountHistoryTrackTrigger On Account (after Update) { 
 if(!UFHT.DynamicTriggerGenericHandler.hasAlreadyRun && trigger.isAfter && trigger.isUpdate) {
 UFHT.DynamicTriggerGenericHandler objDataHandler = new UFHT.DynamicTriggerGenericHandler();
 objDataHandler.onUpdateStoreHistoryData(trigger.newMap, trigger.oldMap, 'Account');
UFHT.DynamicTriggerGenericHandler.hasAlreadyRun = true;
}
}