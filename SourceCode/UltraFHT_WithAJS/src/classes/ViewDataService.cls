/* @Class Name: ViewDataService
 * @Description: This webservice returns history records as json string for selected object, 
 *               Data range and offSet. 
 * ========================================================================================================================
 *       Version   | Date        | Author             | Comments
 * -------------------------------------------------------------------------------------------------------------------------
 *       1.0       | 28-07-2016  | Eternus Solution   | 1.Created the class for above functionality
 * ========================================================================================================================
 **/
@RestResource(urlMapping='/getRecordsForAnSelectedObject/*')
global class ViewDataService {
    
    /**
     * @Author: Eternus Solutions
     * @description : Method returns json string of history records as per parameters.
     * @Param : selectedObjectId Id of Ultra Track Container object.
     *          startDateStr, endDateStr Date range for history records to be fetched
     *          userisAttchmentValid isAttchmentValid to check if logged in user is system admin or not.
     *          offSetStr offSet for attchment to be fetched.
     * @Return : 
     * @Date: 28-07-2016
     **/
    @HttpPost
    global static String doPost(String selectedObjectId, string startDateStr, string endDateStr, boolean userFlag , string offSetStr) {
        
        string jsonResult;
        map<string,List<HistoryWrapper>> ultraTrackWrapperMap = new map<string,List<HistoryWrapper>>();
        list<string> selectedFieldsForTrackingField = new list<string>(); 
        map<Id,Ultra_Track_Container__c> ultraTrackContainerMap = new map<Id,Ultra_Track_Container__c>
                                                                ([select Id, Tracked_Fields__c, Object_Name__c
                                                                 from Ultra_Track_Container__c
                                                                 ]);
       
        Date stratDate;
        Date endDate;
        DateTime newDateTime;
        Date attchementStartDate;
        Date attchementEndDate; 
        string attchementStartDateStr;
        string attchementEndDateStr;
        list<string> splitStrtDate;
        list<string> splitEndDate;
        Date newstrDate;
        Date newEndDate;
        integer offSetForAttachment = integer.valueOf(offSetStr);
        boolean isAttchmentValid = false;
        system.debug('DDDDDD'+offSetForAttachment );
        if(startDateStr != null && string.isNotBlank(startDateStr) && startDateStr != ''){
            startDateStr.trim();
            stratDate = Date.parse(startDateStr);
        }
            
        if(endDateStr != null && string.isNotBlank(endDateStr) && endDateStr != '')
            endDate =  Date.parse(endDateStr);

        if(string.isNotBlank(selectedObjectId)) {
            
            for(Attachment attaObj : [SELECT body, LastModifiedDate, Name  
                                     FROM Attachment
                                     WHERE parentID =: selectedObjectId
                                     AND Name like :system.Label.AttachmentFileName+'%' 
                                     order by LastModifiedDate Desc
                                     limit 1
                                     offset :offSetForAttachment
                                     ] ) {
                isAttchmentValid = false;
                if(stratDate == null && endDate == null) {
                    isAttchmentValid = true;
                }
                else {
                    attchementStartDateStr = attaObj.Name.substring(attaObj.Name.indexOf('SD')+2, attaObj.Name.indexOf('SD')+12);
                    if(attaObj .Name.contains('ED'))
                        attchementEndDateStr = attaObj.Name.substring(attaObj.Name.indexOf('ED')+2, attaObj.Name.length()-4);
                    if(attchementStartDateStr != null) {
                        splitStrtDate = attchementStartDateStr.split('/');
                        newstrDate = Date.newInstance(integer.valueOf(splitStrtDate[2]), integer.valueOf(splitStrtDate[0]), integer.valueOf(splitStrtDate[1]));
                        attchementStartDate = Date.parse(newstrDate.format());
                    }
                    if(attchementEndDateStr != null) {
                        splitEndDate = attchementEndDateStr.split('/');
                        newEndDate = Date.newInstance(integer.valueOf(splitEndDate[2]), integer.valueOf(splitEndDate[0]), integer.valueOf(splitEndDate[1]));
                        attchementEndDate = Date.parse(newEndDate.format());
                    }
                    if(attchementStartDate != null && attchementEndDate == null) {
                        if(stratDate == null) {
                            if(attchementStartDate <= endDate) {
                                isAttchmentValid = true;
                            }
                        }
                        else if(endDate == null) {
                           if(attchementStartDate >= stratDate)
                               isAttchmentValid = true;
                        }
                        else { 
                            if(attchementStartDate >= stratDate && attchementStartDate <= endDate)
                               isAttchmentValid = true;
                        }
                    }
                    else if(attchementStartDate != null && attchementEndDate != null) {
                        
                        if(stratDate == null) {
                            if(attchementEndDate <= endDate) {
                                isAttchmentValid = true;
                            }
                        }
                        else if(endDate == null) {
                           if(attchementStartDate >= stratDate)
                               isAttchmentValid = true;
                        }
                        else {
                            if(attchementStartDate >= stratDate && attchementEndDate <= endDate)
                               isAttchmentValid = true;
                        }
                    }
                }

                if(isAttchmentValid) {
                    ultraTrackWrapperMap.putAll((map<string,List<HistoryWrapper>>)System.JSON.deserialize(
                                                                        attaObj.body.toString(), 
                                                                        map<string,List<HistoryWrapper>>.class));
                }
            }
             
        }
        if(ultraTrackContainerMap.containsKey(selectedObjectId) && 
           string.isNotBlank(ultraTrackContainerMap.get(selectedObjectId).Tracked_Fields__c)) {
            Ultra_Track_Container__c fhtDataHolderObj = ultraTrackContainerMap.get(selectedObjectId);
            if(fhtDataHolderObj.Tracked_Fields__c.contains(',')) {
                
                selectedFieldsForTrackingField = fhtDataHolderObj.Tracked_Fields__c.split(',');
            }
           else {
               selectedFieldsForTrackingField.add(fhtDataHolderObj.Tracked_Fields__c);
           }
        }
         if(ultraTrackWrapperMap.size() > 0)
             jsonResult = ViewDataServiceHandler.getSharedHistroyRecordsForAnObject(selectedFieldsForTrackingField,
                                                                                      ultraTrackWrapperMap,
                                                                                      ultraTrackContainerMap.get(selectedObjectId).Object_Name__c,
                                                                                      stratDate,
                                                                                      endDate,
                                                                                      userFlag 
                                                                                    );
                                                                                    system.debug('jsonResult'+jsonResult);
        return jsonResult;
    }
    
}