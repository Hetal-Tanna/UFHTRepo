trigger UFHTContractHistoryTrackTrigger On Contract (after Update) { 
 if(!UFHT.DynamicTriggerGenericHandler.hasAlreadyRun && trigger.isAfter && trigger.isUpdate) {
 UFHT.DynamicTriggerGenericHandler objDataHandler = new UFHT.DynamicTriggerGenericHandler();
 objDataHandler.onUpdateStoreHistoryData(trigger.newMap, trigger.oldMap, 'Contract');
UFHT.DynamicTriggerGenericHandler.hasAlreadyRun = true;
}
}