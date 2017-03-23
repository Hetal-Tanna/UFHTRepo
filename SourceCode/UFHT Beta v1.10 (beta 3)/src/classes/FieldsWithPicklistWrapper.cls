/**
 * @Class Name: FieldsWithPicklistWrapper
 * @Description: This is a wrapper class used to hold fields related to that object also 
 *               checks if OWD is present for the selected object.
 * =================================================================================================
 *       Version   | Date        | Author             | Comments
 * -------------------------------------------------------------------------------------------------
 *       1.0       | 16/01/2017  | Eternus Solutions  | 1. Created class with constructor.
 * =================================================================================================
 **/
 public with sharing class FieldsWithPicklistWrapper {
 	//Holds all fields of selected object
    public list<UltraTrackWrapper> allFieldswrapperList {get;set;}
    //Holds the boolean value if OWD present for selected object
    public Boolean showOWDPicklist {get;set;}
    //Holds Ultra_Track_Container__c object. 
    public Ultra_Track_Container__c ultraTrackContainerObj {get;set;}
    //Holds the list of Page Message wrapper.
    public list<PageMessageWrapper> lstPageMessagesWrapper {get;set;}
    
    /**
	  * @Author: Eternus Solutions
	  * @Description: Parameterized Constructor to set values related to fields.
	  * @Date: 16/01/2017
	**/
    public FieldsWithPicklistWrapper(list<UltraTrackWrapper> lstWrapper, 
                                    Boolean showPicklist,Ultra_Track_Container__c ultraTrackObj,
                                    list<PageMessageWrapper> lstPageMessage) {
        allFieldswrapperList = lstWrapper;
        showOWDPicklist = showPicklist;
        ultraTrackContainerObj = ultraTrackObj;
        lstPageMessagesWrapper = lstPageMessage;
    }
}