trigger UFHTContentVersionHistoryTrackTrigger On ContentVersion (after Update) { 
 if(!UFHT.DynamicTriggerGenericHandler.verifyRecursiveCallForAnObject('ContentVersion') && trigger.isAfter && trigger.isUpdate) {
 UFHT.DynamicTriggerGenericHandler objDataHandler = new UFHT.DynamicTriggerGenericHandler();
 objDataHandler.onUpdateStoreHistoryData(trigger.newMap, trigger.oldMap, 'ContentVersion');
}
}