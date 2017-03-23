Trigger AccountHistoryTrackTrigger On Account (after Update) { 
 if(trigger.isAfter && trigger.isUpdate){
 UFHT.DynamicTriggerGenericHandler objDataHandler = new UFHT.DynamicTriggerGenericHandler();
 objDataHandler.onUpdateStoreHistoryData(trigger.newMap, trigger.oldMap, 'Account');
}
}