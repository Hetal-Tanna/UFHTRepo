/**
 * @Class Name: AggregatePieChartController 
 * @Description: This class is used to query on UFHT__Ultra_Track_Container__c and Attachment to 
 *               fetch its value and display in Google Pie Chart .
 * ===================================================================================================
 *   Version   | Date        | Author             | Comments
 * ---------------------------------------------------------------------------------------------------
 *   1.0       | 23/01/2017  | Eternus Solutions  | 1. Created the class for above functionality.
 * ===================================================================================================
**/
public with sharing class AggregatePieChartController {

  /**
     * @Author: Eternus Solutions
     * @Description: Remote action class, called from page to find the body length and create data of pie chart. 
     * @Param: none
     * @Return: UltraTrackContainerAttachmentWrapper List
     * @Date: 23/01/2017
     **/
    @RemoteAction 
    public static List<UltraTrackContainerAttachmentWrapper> fetchContainerData() {
        List<UltraTrackContainerAttachmentWrapper> ultraTrackContainerAttachmentWrapperList = new List<UltraTrackContainerAttachmentWrapper>();
        List<UFHT__Ultra_Track_Container__c> ultraTrackContainerOtherList = new List<UFHT__Ultra_Track_Container__c>();
        Map<Id, Decimal> parentIdVsBodyLength = new Map<Id, Decimal>();
        Decimal othersBodyLength = 0;
        Decimal totalBodyLength = 0;
        if(UltraTrackUtility.checkObjectAndFieldLevelSecurity('Attachment', 
                                                               new List<String> {'Id',
                                                                                  'BodyLength',
                                                                                  'ParentId'},
                                                               'isAccessible')) {
      if(UltraTrackUtility.checkObjectAndFieldLevelSecurity('UFHT__Ultra_Track_Container__c', 
                                                                  new List<String> {'Id',
                                                                                    'UFHT__Object_Name__c',
                                                                                    'UFHT__Object_Label__c',
                                                                                    'UFHT__Must_Have__c',
                                                                                    'UFHT__Good_To_Have__c',
                                                                                    'UFHT__Number_of_Records__c',
                                                                                    'UFHT__Is_Tracking_Enabled__c'},
                                                                  'isAccessible')) {
            for(AggregateResult  ar : [SELECT SUM(BodyLength) bodyLength,
                                              ParentId
                                         FROM Attachment
                                        WHERE parent.Type = 'UFHT__Ultra_Track_Container__c'
                                     GROUP BY parentID
                                     ORDER BY SUM(BodyLength) DESC
                                        LIMIT 5]) {
                parentIdVsBodyLength.put((Id)ar.get('ParentId'), (Decimal)(ar.get('bodyLength')));
            }
            
            for(UFHT__Ultra_Track_Container__c ultraTrackContainerObj : [SELECT Id,
                                                                                UFHT__Object_Name__c,
                                                                                UFHT__Object_Label__c,
                                                                                UFHT__Must_Have__c,
                                                                                UFHT__Good_To_Have__c,
                                                                                UFHT__Number_of_Records__c,
                                                                                UFHT__Is_Tracking_Enabled__c
                                                                           FROM UFHT__Ultra_Track_Container__c
                                                                          WHERE Id IN :parentIdVsBodyLength.keySet()]) {
                ultraTrackContainerAttachmentWrapperList.add(new UltraTrackContainerAttachmentWrapper(ultraTrackContainerObj.UFHT__Object_Name__c,
                                                                                                      ultraTrackContainerObj.UFHT__Object_Label__c,
                                                                                                      ultraTrackContainerObj.UFHT__Must_Have__c,
                                                                                                      ultraTrackContainerObj.UFHT__Good_To_Have__c,
                                                                                                      ultraTrackContainerObj.UFHT__Number_of_Records__c,
                                                                                                      ultraTrackContainerObj.UFHT__Is_Tracking_Enabled__c,
                                                                                                      parentIdVsBodyLength.get(ultraTrackContainerObj.Id)));
            }
            
            for(AggregateResult  ar : [SELECT SUM(BodyLength) bodyLength, ParentId
                                         FROM Attachment
                                        WHERE parent.Type = 'UFHT__Ultra_Track_Container__c'
                                          AND ParentId NOT IN :parentIdVsBodyLength.keySet()
                                     GROUP BY ParentId]) {
                othersBodyLength += (Decimal)(ar.get('bodyLength'));
                
            }
            
            List<AggregateResult> arList = [SELECT sum(UFHT__Number_of_Records__c) numberOfRecords,
                                                   sum(UFHT__Must_Have__c) Must_Have,
                                                   sum(UFHT__Good_To_Have__c) Good_To_Have 
                                              FROM UFHT__Ultra_Track_Container__c 
                                             WHERE Id NOT IN :parentIdVsBodyLength.keySet()];
            if(!arList.isEmpty()) {
                Decimal recordCount = (Decimal)(arList.get(0).get('numberOfRecords'));
                for(Integer i = 0; i < ultraTrackContainerAttachmentWrapperList.size(); i++) {
                    if(ultraTrackContainerAttachmentWrapperList.get(i).Number_of_Records > recordCount) {
              ultraTrackContainerAttachmentWrapperList.add(i, (new UltraTrackContainerAttachmentWrapper('Others',
                                                                                                                   'Others',
                                                                                                                   (Decimal)(arList.get(0).get('Must_Have')),
                                                                                                                   (Decimal)(arList.get(0).get('Good_To_Have')),
                                                                                                                   (Decimal)(arList.get(0).get('numberOfRecords')),
                                                                                                                   false,
                                                                                                                   othersBodyLength)));
                        break;
                    }
                }
            }
      }
    }
        return ultraTrackContainerAttachmentWrapperList;
    }
     /**
     * @Author: Eternus Solutions
     * @Description: Wrapper class that contains wrapper of UFHT__Ultra_Track_Container__c and Attachment Bodylength
     * @Param: none
     * @Return: none
     * @Date: 23/01/2017
     **/
  public class UltraTrackContainerAttachmentWrapper {

    public String Object_Name; 
    public String Object_Label;
    public Decimal Must_Have;
    public Decimal Good_To_Have;
    public Decimal Number_of_Records;
    public Boolean Is_Tracking_Enabled; 
    public Decimal bodylength;
    
    public UltraTrackContainerAttachmentWrapper(String Object_Name,
                                                 String Object_Label,
                                                 Decimal Must_Have,
                                                 Decimal Good_To_Have,
                                                 Decimal Number_of_Records,
                                                 Boolean Is_Tracking_Enabled,
                                                 Decimal bodylength) {
      this.Object_Name = Object_Name;
      this.Object_Label = Object_Label;
      this.Must_Have= Must_Have;
      this.Good_To_Have= Good_To_Have;
      this.Number_of_Records = Number_of_Records;
      this.Is_Tracking_Enabled = Is_Tracking_Enabled;
      this.bodylength = bodylength;
    }
  }
}