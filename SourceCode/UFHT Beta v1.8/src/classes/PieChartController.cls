/**
 * @Class Name: PieChartController 
 * @Description: This class is used to query on UFHT__Ultra_Track_Container__c and Attachment to 
 *               fetch its value and display in Google Pie Chart .
 * ===================================================================================================
 *   Version   | Date        | Author             | Comments
 * ---------------------------------------------------------------------------------------------------
 *   1.0       | 23/01/2017  | Eternus Solutions  | 1. Created the class for above functionality.
 * ===================================================================================================
**/
global with sharing class PieChartController {
      
    @RemoteAction   
    public static List<Container_Attachment_Wrapper> FetchContainerData() {
       
        List<Container_Attachment_Wrapper> lstWrapper = new List<Container_Attachment_Wrapper>();
        for(UFHT__Ultra_Track_Container__c objContainer : [SELECT UFHT__Object_Name__c,UFHT__Object_Label__c, (SELECT BodyLength FROM Attachments) FROM UFHT__Ultra_Track_Container__c ]){
            if(!objContainer.Attachments.isEmpty()){
                Decimal totalBodylenght = 0;
                
                for(Attachment objAttachment : objContainer.Attachments){
                    totalBodylenght += objAttachment.BodyLength;
                }
                lstWrapper.add(new Container_Attachment_Wrapper(objContainer, totalBodylenght ));
            }
        }
        return lstWrapper;
        
    }
        
        /**
     * @Author: Eternus Solutions
     * @Description: 
     * @Param: 
     * @Return: 
     * @Date: 23/01/2017
     **/
        public class Container_Attachment_Wrapper {
            public UFHT__Ultra_Track_Container__c objContainer ;
            public Decimal bodylength;
            
            public Container_Attachment_Wrapper(UFHT__Ultra_Track_Container__c objContainer, Decimal bodylength){
                this.objContainer = objContainer;
                this.bodylength = bodylength;
            }
        }
        
}