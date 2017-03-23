trigger UFHTMacroHistoryTrackTrigger On Macro (after Update) { 
 if(!UFHT.DynamicTriggerGenericHandler.verifyRecursiveCallForAnObject('Macro') && trigger.isAfter && trigger.isUpdate) {
 new UFHT.DynamicTriggerGenericHandler().onUpdateStoreHistoryData(trigger.newMap, trigger.oldMap, 'Macro'); }

}