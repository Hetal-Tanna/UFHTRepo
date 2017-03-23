Trigger Product2HistoryTrackTrigger On Product2 (after Update) { 
 if(trigger.isAfter && trigger.isUpdate){
 UFHT.DynamicTriggerGenericHandler objDataHandler = new UFHT.DynamicTriggerGenericHandler();
 objDataHandler.onUpdateStoreHistoryData(trigger.newMap, trigger.oldMap, 'Product2');
}
}