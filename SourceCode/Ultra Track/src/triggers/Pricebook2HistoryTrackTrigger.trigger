Trigger Pricebook2HistoryTrackTrigger On Pricebook2 (after Update) { 
 if(trigger.isAfter && trigger.isUpdate){
 UFHT.DynamicTriggerGenericHandler objDataHandler = new UFHT.DynamicTriggerGenericHandler();
 objDataHandler.onUpdateStoreHistoryData(trigger.newMap, trigger.oldMap, 'Pricebook2');
}
}