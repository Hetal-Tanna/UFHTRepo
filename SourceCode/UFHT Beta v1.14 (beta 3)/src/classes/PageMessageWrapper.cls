/**
 * @Class Name: PageMessagesWrapper
 * @Description: This is a wrapper class used to hold PageMessages along with the type of Message.
 * =================================================================================================
 *       Version   | Date        | Author             | Comments
 * -------------------------------------------------------------------------------------------------
 *       1.0       | 24/01/2017  | Eternus Solutions  | 1. Created class with constructor.
 * =================================================================================================
 **/
 public with sharing class PageMessageWrapper {
         // Holds message
        public String triggerStatusMessage {get;set;}
        // Holds type of message
        public String typeOfMessage {get;set;}

         /**
          * @Author: Eternus Solutions
          * @Description: Parameterized Constructor to set values related to fields.
          * @Param: 1. statusMessage : Actual Error/Success/Warning Message
          *         2. messageType : Indicates type of Message
          * @Date: 24/01/2017 
          **/
        public PageMessageWrapper(String statusMessage,String messageType) {
            triggerStatusMessage = statusMessage;
            typeOfMessage = messageType;
        }
}