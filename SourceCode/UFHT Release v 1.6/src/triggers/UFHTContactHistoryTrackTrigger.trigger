trigger UFHTContactHistoryTrackTrigger On Contact (after Update) { 
 if(!UFHT.DynamicTriggerGenericHandler.verifyRecursiveCallForAnObject('Contact') && trigger.isAfter && trigger.isUpdate) {
 UFHT.DynamicTriggerGenericHandler objDataHandler = new UFHT.DynamicTriggerGenericHandler();
 objDataHandler.onUpdateStoreHistoryData(trigger.newMap, trigger.oldMap, 'Contact');
}
}