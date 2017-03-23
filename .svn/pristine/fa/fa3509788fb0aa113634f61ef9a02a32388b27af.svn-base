/**
 * @Class Name: ViewDataNumberOfAttachmentWebSerive 
 * @Description: This webservice return number of attchement for selected Object Id. 
 * ========================================================================================================================
 *       Version   | Date        | Author             | Comments
 * -------------------------------------------------------------------------------------------------------------------------
 *       1.0       | 27-07-2016  | Eternus Solution   | 1.Created the class for above functionality
 * ========================================================================================================================
 **/
@RestResource(urlMapping='/getNumberOfAttachmentPerObject/*')
global class ViewDataNumberOfAttachmentWebSerive {
    
   /**
     * @Author: Eternus Solutions
     * @description : Method return number of attchment for passed Id.
     * @Param : Id of Ultra Track Container object.
     * @Return : Number of attchments for an object Id.
     * @Date: 27-07-2016
     **/
    @HttpPost
    global static Integer doPost(String selectedObjectId) {
        
        integer recordCount = 0;
        
        List<Attachment> attachmentList = new List<Attachment>();
        if(string.isNotBlank(selectedObjectId)) {
            
            attachmentList =  [SELECT Id
                               FROM Attachment
                               WHERE parentID =: selectedObjectId
                               AND Name like :system.Label.AttachmentFileName+'%' 
                               order by LastModifiedDate Desc
                              ] ;
            
        }
        if(!attachmentList.isEmpty())
            recordCount = attachmentList.size();
        return recordCount;
    }
}