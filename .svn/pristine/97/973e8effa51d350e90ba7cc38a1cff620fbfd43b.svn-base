/**
 * @Class Name: DynamicTriggerGenerator
 * @Description: This is Helper class for class "UltraTrackContainerHandler".
 *               This class check whether trigger exists or not for sObject.
 *               If trigger does not exist then generates a trigger.
 * =================================================================================================
 *      Version   | Date        | Author              | Comments
 * -------------------------------------------------------------------------------------------------
 *      1.0       | 16/11/2015  | Eternus Solutions   |  1. Created Class for above functionality.
 * =================================================================================================
 **/
public with sharing class DynamicTriggerGenerator {

    private static Id existingTriggerId;

    /**
     * @Author: Eternus Solutions
     * @Description: Method to create body of trigger in JSON form.
     *               added @future Annotation to call method in asynchronous mode.
     * @Param: It takes object Name for creating the trigger on it and user session ID.
     * @Return:
     * @Date: 16/11/2015
     **/
    @future(callout = true)
    public static void generateDynamicTrigger(String sobjectName, String sessionId) {

        if(String.isNotBlank(sobjectName) && String.isNotBlank(sessionId)) {

            String triggerName = System.Label.Trigger_Name_Prefix + sobjectName.remove(UFHTConstants.CONSECUTIVE_UNDERSCORES)
                               + System.Label.sObjectTriggerName;

            String finalBody = UFHTConstants.TRIGGER_KEYWORD + UFHTConstants.WHITE_SPACE + triggerName + UFHTConstants.WHITE_SPACE + UFHTConstants.ON_KEYWORD + UFHTConstants.WHITE_SPACE + sobjectName + UFHTConstants.WHITE_SPACE;

            //Trigger body
            finalBody += UFHTConstants.BRACKET_OPEN + UFHTConstants.AFTER_UPDATE + UFHTConstants.BRACKET_CLOSE + UFHTConstants.WHITE_SPACE
                       + UFHTConstants.CURLY_BRACE_OPEN + UFHTConstants.WHITE_SPACE + UFHTConstants.LINE_BREAK + UFHTConstants.WHITE_SPACE
                       + UFHTConstants.IF_STATEMENT + UFHTConstants.BRACKET_OPEN
                       + UFHTConstants.NOT_OPERATOR + UFHTConstants.NAMESPACE_PREFIX + UFHTConstants.DOT_OPERATOR + UFHTConstants.HANDLER_CLASS_NAME
                       + UFHTConstants.DOT_OPERATOR + UFHTConstants.HAS_ALREADY_RUN + UFHTConstants.BRACKET_OPEN + UFHTConstants.ESCAPED_SINGLE_QUOTE
                       + sobjectName + UFHTConstants.ESCAPED_SINGLE_QUOTE + UFHTConstants.BRACKET_CLOSE + UFHTConstants.WHITE_SPACE + UFHTConstants.LOGICAL_AND + UFHTConstants.WHITE_SPACE + UFHTConstants.TRIGGER_KEYWORD + UFHTConstants.DOT_OPERATOR + UFHTConstants.TRIGGER_CONDITION_ISAFTER + UFHTConstants.WHITE_SPACE
                       + UFHTConstants.LOGICAL_AND + UFHTConstants.WHITE_SPACE + UFHTConstants.TRIGGER_KEYWORD + UFHTConstants.DOT_OPERATOR + UFHTConstants.TRIGGER_CONDITION_ISUPDATE + UFHTConstants.BRACKET_CLOSE + UFHTConstants.WHITE_SPACE + UFHTConstants.CURLY_BRACE_OPEN + UFHTConstants.LINE_BREAK + UFHTConstants.WHITE_SPACE + UFHTConstants.NAMESPACE_PREFIX + UFHTConstants.DOT_OPERATOR + UFHTConstants.HANDLER_CLASS_NAME + UFHTConstants.WHITE_SPACE
                       + UFHTConstants.HANDLER_CLASS_INSTANCE + UFHTConstants.WHITE_SPACE + UFHTConstants.EQUALS_SIGN + UFHTConstants.WHITE_SPACE + UFHTConstants.NEW_KEYWORD + UFHTConstants.WHITE_SPACE + UFHTConstants.NAMESPACE_PREFIX
                       + UFHTConstants.DOT_OPERATOR + UFHTConstants.HANDLER_CLASS_NAME + UFHTConstants.BRACKET_OPEN + UFHTConstants.BRACKET_CLOSE + UFHTConstants.SEMICOLON + UFHTConstants.LINE_BREAK + UFHTConstants.WHITE_SPACE
                       + UFHTConstants.HANDLER_CLASS_INSTANCE + UFHTConstants.DOT_OPERATOR + UFHTConstants.HANDLER_METHOD_NAME + UFHTConstants.BRACKET_OPEN + UFHTConstants.TRIGGER_KEYWORD + UFHTConstants.DOT_OPERATOR + UFHTConstants.NEWMAP_KEYWORD
                       + UFHTConstants.COMMA + UFHTConstants.WHITE_SPACE + UFHTConstants.TRIGGER_KEYWORD + UFHTConstants.DOT_OPERATOR + UFHTConstants.OLDMAP_KEYWORD + UFHTConstants.COMMA + UFHTConstants.WHITE_SPACE + UFHTConstants.ESCAPED_SINGLE_QUOTE
                       + sobjectName + UFHTConstants.ESCAPED_SINGLE_QUOTE + UFHTConstants.BRACKET_CLOSE + UFHTConstants.SEMICOLON + UFHTConstants.LINE_BREAK
                       + UFHTConstants.CURLY_BRACE_CLOSE + UFHTConstants.LINE_BREAK + UFHTConstants.CURLY_BRACE_CLOSE
                       + UFHTConstants.LINE_BREAK + UFHTConstants.LINE_BREAK;
                       
            system.debug('DD---:'+finalBody );

            String jsonTrigger = UFHTConstants.CURLY_BRACE_OPEN + UFHTConstants.WHITE_SPACE + UFHTConstants.DOUBLE_QUOTE + UFHTConstants.JSON_KEY_NAME + UFHTConstants.DOUBLE_QUOTE + UFHTConstants.WHITE_SPACE + UFHTConstants.COLON
                               + UFHTConstants.WHITE_SPACE + UFHTConstants.DOUBLE_QUOTE
                               + triggerName + UFHTConstants.WHITE_SPACE + UFHTConstants.DOUBLE_QUOTE + UFHTConstants.COMMA + UFHTConstants.DOUBLE_QUOTE + UFHTConstants.JSON_KEY_TABLE_ENUM_ID + UFHTConstants.DOUBLE_QUOTE + UFHTConstants.WHITE_SPACE
                               + UFHTConstants.COLON + UFHTConstants.WHITE_SPACE + UFHTConstants.DOUBLE_QUOTE + sobjectName + UFHTConstants.DOUBLE_QUOTE + UFHTConstants.COMMA + UFHTConstants.DOUBLE_QUOTE + UFHTConstants.JSON_KEY_BODY + UFHTConstants.DOUBLE_QUOTE
                               + UFHTConstants.WHITE_SPACE + UFHTConstants.COLON + UFHTConstants.WHITE_SPACE + UFHTConstants.DOUBLE_QUOTE + UFHTConstants.WHITE_SPACE + finalBody + UFHTConstants.WHITE_SPACE + UFHTConstants.DOUBLE_QUOTE + UFHTConstants.CURLY_BRACE_CLOSE;

            Boolean isTriggerExisting = checkTriggerExistOrNot(sobjectName, triggerName, sessionId);
            if(String.isNotBlank(triggerName)
            && String.isNotBlank(jsonTrigger) ) {

                if(isTriggerExisting == false) {
                    createTrigger(sobjectName, jsonTrigger, sessionId);
                }
            }
            else {
                return;
            }
        }
        else {
            return;
        }
    }

   /**
     * @Author: Eternus Solutions
     * @Description: Method to check trigger exists or not:
     *                  - if a trigger exists and is active, do nothing.
     *                  - if a trigger exists and is inactive, activate it.
     *                  - if trigger does not exist, create a trigger.
     * @Param: 1. sobjectName : name of sObject to create a trigger on
     *         2. triggerName : name of trigger to search
     *         3. sessionId : current session Id (necessary to be pased as it cannot be generated here)
     * @Return: Boolean value
     * @Date: 16/11/2015
     **/
    public static Boolean checkTriggerExistOrNot(String sobjectName, String triggerName, String sessionId) {

        list<ApexTrigger> triggersList = new list<ApexTrigger>();
        Boolean isActiveTrigger = false;
        String testTriggerName = triggerName;
        if(Test.isRunningTest() && String.isNotBlank(triggerName)
              && triggerName.containsIgnoreCase(UFHTConstants.APEX_TRIGGER_STATUS_INACTIVE)) {
                triggerName = triggerName.remove(UFHTConstants.APEX_TRIGGER_STATUS_INACTIVE);
        }
        
        if(String.isNotBlank(triggerName) &&
           String.isNotBlank(sobjectName) &&
           String.isNotBlank(sessionId)) {
            //Check whether the user has access for read and create trigger for new setup details
            if(!UltraTrackUtility.checkObjectAndFieldLevelSecurity('Profile', 
                                                               new list<String> {'Id','Name','PermissionsAuthorApex'},
                                                               'isAccessible')){
                UltraTrackUtility.displayMessage(ApexPages.severity.WARNING, UFHTConstants.WHITE_SPACE + System.Label.UnAuthorizedTriggerAccess);
                return null;
            
            }   
            Boolean authorApexCheck =[SELECT Id,Name,PermissionsAuthorApex  
                                      FROM Profile 
                                      WHERE Id=:UserInfo.getProfileId()].PermissionsAuthorApex;
            //Check whether the user has access for read and create trigger for new setup details
            if(!authorApexCheck){
                UltraTrackUtility.displayMessage(ApexPages.severity.WARNING, UFHTConstants.WHITE_SPACE + System.Label.UnAuthorizedTriggerAccess);
                return null;
            }
            
            triggersList = [SELECT Id,
                                   Name,
                                   Status,
                                   Body
                             FROM ApexTrigger
                             WHERE Name = : triggerName
                               AND TableEnumOrId = : sobjectName
                             LIMIT 1];
               
            if( !triggersList.isEmpty() ) {
                existingTriggerId = triggersList[0].Id;
            }

            if( !triggersList.isEmpty()
            &&  UFHTConstants.APEX_TRIGGER_STATUS_ACTIVE.equalsIgnoreCase(triggersList[0].Status)
            && String.isNotBlank(testTriggerName) 
            && !testTriggerName.containsIgnoreCase(UFHTConstants.APEX_TRIGGER_STATUS_INACTIVE)) {
                isActiveTrigger = true;
            }
            else if( (!triggersList.isEmpty()
                 &&  UFHTConstants.APEX_TRIGGER_STATUS_INACTIVE.equalsIgnoreCase(triggersList[0].Status))
                 || String.isNotBlank(testTriggerName) && testTriggerName.containsIgnoreCase(UFHTConstants.APEX_TRIGGER_STATUS_INACTIVE)) {
             
                String containerId = createMetadataContainer(sessionId);    
                if(String.isNotBlank(containerId)) {
          
                    Boolean isSuccessfulMember = createApexTriggerMember(containerId, triggersList[0].Id, triggersList[0].Body, sessionId);
                    if(isSuccessfulMember == true ) {

                        Boolean isSuccessfulRequest = createContainerAsyncRequest(containerId, sessionId);

                        if(isSuccessfulRequest == true) {
                            isActiveTrigger = true;

                        } else {
                            isActiveTrigger = null;
                        }

                    } else {
                        isActiveTrigger = null;
                    }

                } else {
                    isActiveTrigger = null;
                }
            }
        }

        return isActiveTrigger;
    }

    /**
     * @Author: Eternus Solutions
     * @Description: This method creates a trigger on sObject using REST API.
     * @Param: 1. sobjectName : Name of the sObject to create trigger on
     *         2. jsonTrigger : Body of trigger in JSON format
     *         3. sessionId : Current session Id (necessary to be pased as it cannot be generated here)
     * @Return:
     * @Date: 16/11/2015
     **/
    public static Boolean createTrigger(String sobjectName, String jsonTrigger, String sessionId) {

        String baseUrl = UFHTConstants.EMPTY_STRING;
        //Check configuration record is accessible or not
        if(!UltraTrackUtility.isAllowDMLForCustomSetting('UFHT__Configuration__c','isAccessible')){
            return false;
        }
        map<String, Configuration__c> configurationMap = Configuration__c.getAll();
        if(configurationMap.containsKey(System.Label.ConfigureColsAndFieldsCustomSettingRecordName)) {
            baseUrl = UFHTConstants.PROTOCOL + configurationMap.get(System.Label.ConfigureColsAndFieldsCustomSettingRecordName).SalesforceBaseURL__c;
        }

        if(String.isNotBlank(sobjectName) && String.isNotBlank(jsonTrigger) && String.isNotBlank(sessionId) && String.isNotBlank(baseUrl)) {
            try {

                HttpRequest req = new HttpRequest();
                req.setEndpoint(baseUrl + UFHTConstants.HTTP_ENDPOINT_APEXTRIGGER);
                req.setMethod(UFHTConstants.HTTP_METHOD_POST);
                req.setHeader(UFHTConstants.HTTP_CONTENT_TYPE, UFHTConstants.HTTP_CONTENT_TYPE_JSON);
                req.setHeader(UFHTConstants.HTTP_HEADER_AUTHORIZATION, UFHTConstants.HTTP_HEADER_AUTHORIZATION_BEARER + UFHTConstants.WHITE_SPACE + sessionId);
                req.setBody(jsonTrigger);

                HttpResponse res = new Http().send(req);

                if(res.getStatusCode() == UFHTConstants.HTTP_RESPONSE_SUCCESS_CODE) {
                    return true;
                }

                else {
                    return false;
                }
            }

            catch(Exception e) {
                throw new TriggerGenerationException(System.Label.TriggerGenerationError + UFHTConstants.WHITE_SPACE + sobjectName);
                return false;
            }
        }

        return false;
    }

    /**
     * @Author: Eternus Solutions
     * @Description: Method to create a MetadataContainer for activating trigger.
     * @Param: 1. sessionId : current session Id (necessary to be pased as it cannot be generated here)
     * @Return: String (MetadataContainer Id)
     * @Date: 03/08/2016
     **/
    @TestVisible private static String createMetadataContainer(String sessionId) {

        String containerId = UFHTConstants.EMPTY_STRING;

        if(String.isBlank(sessionId)) {
            return containerId;
        }

        HttpRequest httpReq = new HttpRequest();

        httpReq.setHeader(UFHTConstants.HTTP_CONTENT_TYPE, UFHTConstants.HTTP_CONTENT_TYPE_JSON);
        httpReq.setHeader(UFHTConstants.HTTP_HEADER_AUTHORIZATION, UFHTConstants.HTTP_HEADER_AUTHORIZATION_BEARER + UFHTConstants.WHITE_SPACE + sessionId);
        httpReq.setEndpoint(
            UFHTConstants.PROTOCOL
              + Url.getSalesforceBaseUrl().getHost()
              + UFHTConstants.HTTP_ENDPOINT_METADATACONTAINER);
        httpReq.setMethod(UFHTConstants.HTTP_METHOD_POST);

        // Generated unique Container name using trigger name prefix and timestamp.
        httpReq.setBody(UFHTConstants.CURLY_BRACE_OPEN + UFHTConstants.DOUBLE_QUOTE + UFHTConstants.JSON_KEY_NAME
                      + UFHTConstants.DOUBLE_QUOTE + UFHTConstants.COLON + UFHTConstants.DOUBLE_QUOTE
                      + System.Label.Trigger_Name_Prefix + System.now().getTime() + UFHTConstants.DOUBLE_QUOTE
                      + UFHTConstants.CURLY_BRACE_CLOSE);

        try {

            HttpResponse response = new Http().send(httpReq);
            
            Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeuntyped(response.getBody());
            containerId = responseMap.containsKey(UFHTConstants.ID_FIELD.toLowerCase())
                        ? (String) responseMap.get(UFHTConstants.ID_FIELD.toLowerCase())
                        : UFHTConstants.EMPTY_STRING;

        } catch(CalloutException calloutExcep) {
            
            // @TODO : Nothing
        } catch(TypeException typeExcep) {
            // @TODO : Nothing
            
        }

        return containerId;

    }

    /**
     * @Author: Eternus Solutions
     * @Description: Method to create an ApexTriggerMember to activate the trigger
     * @Param: 1. metadataContainerId : Id of MetadataContainer generated by createMetadataContainer
     *         2. triggerId : Id of trigger to activate
     *         3. triggerBody : Body of the trigger fetched / updated (required for callout)
     *         4. sessionId : current session Id (necessary to be pased as it cannot be generated here)
     * @Return: Boolean
     * @Date: 03/08/2016
     **/
    @TestVisible private static Boolean createApexTriggerMember(String metadataContainerId, String triggerId, String triggerBody, String sessionId) {
        
        Boolean isSuccess = false;

        if(String.isBlank(metadataContainerId)
        || String.isBlank(triggerId)
        || String.isBlank(triggerBody)
        || String.isBlank(sessionId)) {
            return isSuccess;
        }

        HttpRequest httpReq = new HttpRequest();

        httpReq.setHeader(UFHTConstants.HTTP_CONTENT_TYPE, UFHTConstants.HTTP_CONTENT_TYPE_JSON);
        httpReq.setHeader(UFHTConstants.HTTP_HEADER_AUTHORIZATION, UFHTConstants.HTTP_HEADER_AUTHORIZATION_BEARER + UFHTConstants.WHITE_SPACE + sessionId);
        httpReq.setEndpoint(
            UFHTConstants.PROTOCOL
              + Url.getSalesforceBaseUrl().getHost()
              + UFHTConstants.HTTP_ENDPOINT_APEXTRIGGERMEMBER);

        httpReq.setMethod(UFHTConstants.HTTP_METHOD_POST);

        httpReq.setBody(UFHTConstants.CURLY_BRACE_OPEN + UFHTConstants.DOUBLE_QUOTE + UFHTConstants.JSON_KEY_METADATA_CONTAINER_ID
            + UFHTConstants.DOUBLE_QUOTE + UFHTConstants.COLON + UFHTConstants.DOUBLE_QUOTE
            + metadataContainerId + UFHTConstants.DOUBLE_QUOTE + UFHTConstants.COMMA + UFHTConstants.DOUBLE_QUOTE
            + UFHTConstants.JSON_KEY_CONTENT_ENTITY_ID + UFHTConstants.DOUBLE_QUOTE + UFHTConstants.COLON
            + UFHTConstants.DOUBLE_QUOTE + triggerId + UFHTConstants.DOUBLE_QUOTE + UFHTConstants.COMMA
            + UFHTConstants.DOUBLE_QUOTE + UFHTConstants.JSON_KEY_BODY + UFHTConstants.DOUBLE_QUOTE + UFHTConstants.COLON
            + UFHTConstants.DOUBLE_QUOTE + triggerBody.replace(UFHTConstants.LINE_BREAK_VALUE, UFHTConstants.LINE_BREAK)
            + UFHTConstants.DOUBLE_QUOTE + UFHTConstants.COMMA + System.Label.TriggerMetadataInfo + UFHTConstants.CURLY_BRACE_CLOSE);

        try {

            HttpResponse response = new Http().send(httpReq);

            map<String, Object> responseMap = (map<String, Object>) JSON.deserializeuntyped(response.getBody());
            isSuccess = true;

        } catch(CalloutException calloutExcep) {
            // @TODO : Nothing
        } catch(TypeException typeExcep) {
            // @TODO : Nothing
        }
        return isSuccess;
    }

    /**
     * @Author: Eternus Solutions
     * @Description: Method to create an ContainerAsyncRequest to activate the trigger
     * @Param: 1. metadataContainerId : Id of MetadataContainer generated by createMetadataContainer
     *         2. sessionId : current session Id (necessary to be pased as it cannot be generated here)
     * @Return: Boolean
     * @Date: 03/08/2016
     **/
    @TestVisible private static Boolean createContainerAsyncRequest(String metadataContainerId, String sessionId) {
        
        Boolean isSuccess = false;

        if(String.isBlank(metadataContainerId)
        || String.isBlank(sessionId)) {
            return isSuccess;
        }

        HttpRequest httpReq = new HttpRequest();

        httpReq.setHeader(UFHTConstants.HTTP_CONTENT_TYPE, UFHTConstants.HTTP_CONTENT_TYPE_JSON);
        httpReq.setHeader(UFHTConstants.HTTP_HEADER_AUTHORIZATION, UFHTConstants.HTTP_HEADER_AUTHORIZATION_BEARER + UFHTConstants.WHITE_SPACE + sessionId);
        httpReq.setEndpoint(
            UFHTConstants.PROTOCOL
              + Url.getSalesforceBaseUrl().getHost()
              + UFHTConstants.HTTP_ENDPOINT_CONTAINERASYNCREQUEST);
        httpReq.setMethod(UFHTConstants.HTTP_METHOD_POST);

        httpReq.setBody(UFHTConstants.CURLY_BRACE_OPEN + UFHTConstants.DOUBLE_QUOTE
            + UFHTConstants.JSON_KEY_METADATA_CONTAINER_ID + UFHTConstants.DOUBLE_QUOTE + UFHTConstants.COLON
            + UFHTConstants.DOUBLE_QUOTE + metadataContainerId + UFHTConstants.DOUBLE_QUOTE + UFHTConstants.COMMA
            + UFHTConstants.DOUBLE_QUOTE + UFHTConstants.JSON_KEY_IS_CHECK_ONLY + UFHTConstants.DOUBLE_QUOTE
            + UFHTConstants.COLON + UFHTConstants.DOUBLE_QUOTE + UFHTConstants.FALSE_KEYWORD
            + UFHTConstants.DOUBLE_QUOTE + UFHTConstants.CURLY_BRACE_CLOSE);

        try {

            HttpResponse response = new Http().send(httpReq);

            map<String, Object> responseMap = (map<String, Object>) JSON.deserializeuntyped(response.getBody());
            isSuccess = true;
        } catch(CalloutException calloutExcep) {
            // @TODO : Nothing
        } catch(TypeException typeExcep) {
            // @TODO : Nothing
        }
        return isSuccess;
    }
    
}