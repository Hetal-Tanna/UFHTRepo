trigger UFHTUFHTSharing_PurposecHistoryTrackTrigger On UFHT__Sharing_Purpose__c (after Update) { 
 if(!UFHT.DynamicTriggerGenericHandler.hasAlreadyRun && trigger.isAfter && trigger.isUpdate) {
 UFHT.DynamicTriggerGenericHandler objDataHandler = new UFHT.DynamicTriggerGenericHandler();
 objDataHandler.onUpdateStoreHistoryData(trigger.newMap, trigger.oldMap, 'UFHT__Sharing_Purpose__c');
UFHT.DynamicTriggerGenericHandler.hasAlreadyRun = true;
}
}