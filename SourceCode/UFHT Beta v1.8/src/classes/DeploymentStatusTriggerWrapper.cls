/**
 * @Class Name: DeploymentStatusTriggerWrapper
 * @Description: This is a wrapper class used to hold status counter of trigger deployment.
 * =================================================================================================
 *       Version   | Date        | Author             | Comments
 * -------------------------------------------------------------------------------------------------
 *       1.0       | 19/01/2017  | Eternus Solutions  | 1. Created class with constructor.
 * =================================================================================================
 **/
 public with sharing class DeploymentStatusTriggerWrapper {
         //Holds boolean value if Poller enabled
        public Boolean isEnablePollar {get; set;}
        //Holds the counter value of trigger being deployed.
        public Integer progCounter {get; set;}
        //Holds the Id of the trigger for selected object.
        public Id asyncId {get;set;}
        //Holds the list of Page Message wrapper.
        public list<PageMessageWrapper> lstPageMessagesWrapper {get;set;}
       
        /**
          * @Author: Eternus Solutions
          * @Description: Parameterized Constructor to set values related to fields.
          * @Date: 19/01/2017
          **/
        public DeploymentStatusTriggerWrapper(Boolean enablePoll, Integer progresCounter, Id asycId,
                                              list<PageMessageWrapper> lstPageMessage) {
            isEnablePollar = enablePoll;
            progCounter = progresCounter;
            asyncId = asycId;
            lstPageMessagesWrapper = lstPageMessage;
        }
}