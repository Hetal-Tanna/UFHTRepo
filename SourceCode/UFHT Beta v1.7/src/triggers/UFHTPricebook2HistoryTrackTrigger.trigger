trigger UFHTPricebook2HistoryTrackTrigger On Pricebook2 (after Update) { 
 if(!UFHT.DynamicTriggerGenericHandler.hasAlreadyRun && trigger.isAfter && trigger.isUpdate) {
 UFHT.DynamicTriggerGenericHandler objDataHandler = new UFHT.DynamicTriggerGenericHandler();
 objDataHandler.onUpdateStoreHistoryData(trigger.newMap, trigger.oldMap, 'Pricebook2');
UFHT.DynamicTriggerGenericHandler.hasAlreadyRun = true;
}
}