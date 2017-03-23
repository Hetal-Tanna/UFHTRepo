/**
 * @Class Name: DynamicTriggerGenerator
 * @Description: This is Helper class for class "UltraTrackContainerHandler".
 *               This class check whether trigger exists or not for sObject.
 *               If trigger does not exist then generates a trigger.
                 remove code for recurssion method call from if condition when trigger is created 
                 Also added the same recurssion method call code inside if condition
 * =================================================================================================
 *      Version   | Date        | Author              | Comments
 * -------------------------------------------------------------------------------------------------
 *      1.0       | 01/03/2017  | Eternus Solutions   |  1. Created Class for above functionality.
 * =================================================================================================
 **/
public with sharing class DynamicTriggerGenerator {

    private static Id existingTriggerId;

    /**
     * @Author: Eternus Solutions
     * @Description: Method to create body of trigger in JSON form.
     *               added @future Annotation to call method in asynchronous mode.
                                      remove code for recurssion method call from if condition when trigger is created 
                 Also added the same recurssion method call code inside if condition
     * @Param: It takes object Name for creating the trigger on it and user session ID.
     * @Return:
     * @Date: 16/11/2015
     **/
    public static Id generateDynamicTrigger(String sobjectName, String sessionId) {
        Id asynResultId;
        if(String.isNotBlank(sobjectName) && String.isNotBlank(sessionId)) {

            String triggerName = System.Label.Trigger_Name_Prefix + sobjectName.remove(UFHTConstants.CONSECUTIVE_UNDERSCORES)
                               + System.Label.sObjectTriggerName;

            String finalBody = UFHTConstants.TRIGGER_KEYWORD + UFHTConstants.WHITE_SPACE + triggerName + UFHTConstants.WHITE_SPACE + UFHTConstants.ON_KEYWORD + UFHTConstants.WHITE_SPACE + sobjectName + UFHTConstants.WHITE_SPACE;
 
            //Trigger body
            finalBody += UFHTConstants.BRACKET_OPEN + UFHTConstants.AFTER_UPDATE + UFHTConstants.BRACKET_CLOSE + UFHTConstants.WHITE_SPACE
                       + UFHTConstants.CURLY_BRACE_OPEN + UFHTConstants.WHITE_SPACE + UFHTConstants.FILE_LINE_BREAK + UFHTConstants.WHITE_SPACE
                       + UFHTConstants.IF_STATEMENT + UFHTConstants.BRACKET_OPEN 
                       + UFHTConstants.TRIGGER_KEYWORD + UFHTConstants.DOT_OPERATOR + UFHTConstants.TRIGGER_CONDITION_ISAFTER 
                       + UFHTConstants.WHITE_SPACE + UFHTConstants.LOGICAL_AND + UFHTConstants.WHITE_SPACE + UFHTConstants.TRIGGER_KEYWORD
                       + UFHTConstants.DOT_OPERATOR + UFHTConstants.TRIGGER_CONDITION_ISUPDATE + UFHTConstants.BRACKET_CLOSE + UFHTConstants.WHITE_SPACE 
                       + UFHTConstants.CURLY_BRACE_OPEN + UFHTConstants.WHITE_SPACE 
                       //code to add recursive method starts in if block on 22-02-2017
                       + UFHTConstants.FILE_LINE_BREAK + UFHTConstants.WHITE_SPACE 
                       + UFHTConstants.NAMESPACE_PREFIX + UFHTConstants.DOT_OPERATOR + UFHTConstants.HANDLER_CLASS_NAME
                       + UFHTConstants.DOT_OPERATOR + UFHTConstants.HAS_ALREADY_RUN 
                       + UFHTConstants.BRACKET_OPEN + UFHTConstants.ESCAPED_SINGLE_QUOTE
                       + sobjectName 
                       + UFHTConstants.ESCAPED_SINGLE_QUOTE + UFHTConstants.BRACKET_CLOSE 
                       + UFHTConstants.WHITE_SPACE + UFHTConstants.SEMICOLON
                       + UFHTConstants.FILE_LINE_BREAK + UFHTConstants.WHITE_SPACE 
                       //code to add recursive method ends on 22-02-2017

                       + UFHTConstants.NEW_KEYWORD + UFHTConstants.WHITE_SPACE
                       + UFHTConstants.NAMESPACE_PREFIX + UFHTConstants.DOT_OPERATOR + UFHTConstants.HANDLER_CLASS_NAME + UFHTConstants.BRACKET_OPEN 
                       + UFHTConstants.BRACKET_CLOSE + UFHTConstants.DOT_OPERATOR + UFHTConstants.HANDLER_METHOD_NAME + UFHTConstants.BRACKET_OPEN 
                       + UFHTConstants.TRIGGER_KEYWORD + UFHTConstants.DOT_OPERATOR + UFHTConstants.NEWMAP_KEYWORD + UFHTConstants.COMMA 
                       + UFHTConstants.WHITE_SPACE + UFHTConstants.TRIGGER_KEYWORD + UFHTConstants.DOT_OPERATOR + UFHTConstants.OLDMAP_KEYWORD 
                       + UFHTConstants.COMMA + UFHTConstants.WHITE_SPACE + UFHTConstants.ESCAPED_SINGLE_QUOTE + sobjectName + UFHTConstants.ESCAPED_SINGLE_QUOTE 
                       + UFHTConstants.BRACKET_CLOSE + UFHTConstants.SEMICOLON + UFHTConstants.WHITE_SPACE 
                       
                       + UFHTConstants.CURLY_BRACE_CLOSE + UFHTConstants.FILE_LINE_BREAK 
                       + UFHTConstants.FILE_LINE_BREAK + UFHTConstants.CURLY_BRACE_CLOSE + UFHTConstants.FILE_LINE_BREAK + UFHTConstants.FILE_LINE_BREAK;

            Boolean isTriggerExisting = checkTriggerExistOrNot(sobjectName, triggerName, sessionId);
            if( String.isNotBlank(triggerName) 
                && String.isNotBlank(finalBody)  
                && (isTriggerExisting == false)) 
            {

                asynResultId = createTrigger(sobjectName, finalBody, sessionId, triggerName);
                return asynResultId;
            }
        }
        return asynResultId; 
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
          
                    if(createApexTriggerMember(containerId, triggersList[0].Id, triggersList[0].Body, sessionId)) {

                        if(createContainerAsyncRequest(containerId, sessionId)) 
                        {
                            isActiveTrigger = true;
                        }
                    }
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
    public static Id createTrigger(String sobjectName, String triggerBody, String sessionId, String triggerName) {

        String baseUrl = UFHTConstants.EMPTY_STRING;
        String testClassName;
        MetadataService.AsyncResult AsyncResult;
        Integer METADATA_API_VERSION =  Integer.valueOf(new MetadataService.MetadataPort().endpoint_x.substringAfterLast(UFHTConstants.DATE_SEPARATOR_SLASH));
        //Check configuration record is accessible or not
        if(String.isNotBlank(sobjectName) && 
           String.isNotBlank(triggerBody) && 
           String.isNotBlank(sessionId) && 
           String.isNotBlank(triggerName)) {
           
            testClassName = UFHTConstants.NAMESPACE_PREFIX +  
                            (sobjectName.contains(UFHTConstants.CUSTOM_OBJECT_KEYWORD) ? 
                            sobjectName.subString(0,sobjectName.indexOf(UFHTConstants.CUSTOM_OBJECT_KEYWORD) + 1) : sobjectName) + 
                            UFHTConstants.TEST_KEYWORD ;
            testClassName = testClassName.replaceAll(UFHTConstants.CONSECUTIVE_UNDERSCORES, UFHTConstants.EMPTY_STRING);
            testClassName = testClassName.subString(0, testClassName.length() > 40 ? 39 : testClassName.length());
            
            Blob packageXml = Blob.valueOf(
            UFHTConstants.XML_VERSION +
                UFHTConstants.PACKAGE_XML_METADATA +
                    UFHTConstants.PACKAGE_TYPE_OPENING_TAG +
                        UFHTConstants.PACKAGE_MEMBER_OPENING_TAG + triggerName + UFHTConstants.PACKAGE_MEMBER_CLOSING_TAG +
                        UFHTConstants.PACKAGE_APEX_TRIGGER_TAG +
                    UFHTConstants.PACKAGE_TYPE_CLOSING_TAG +
                    UFHTConstants.PACKAGE_TYPE_OPENING_TAG +
                        UFHTConstants.PACKAGE_MEMBER_OPENING_TAG + testClassName + UFHTConstants.PACKAGE_MEMBER_CLOSING_TAG +
                        UFHTConstants.PACKAGE_APEX_CLASSES_TAG +
                        UFHTConstants.PACKAGE_TYPE_CLOSING_TAG +
                    UFHTConstants.PACKAGE_VERSION_OPENING_TAG + METADATA_API_VERSION + UFHTConstants.PACKAGE_VERSION_CLOSING_TAG +
                UFHTConstants.PACKAGE_CLOSING_TAG);

            Blob triggerCode = Blob.valueOf(triggerBody);
            Blob triggerMeta = Blob.valueOf(
                UFHTConstants.XML_VERSION +
                    UFHTConstants.APEX_TRIGGER_OPENING_TAG  +
                        UFHTConstants.APEX_TRIGGER_VERSION_OPENING_TAG + METADATA_API_VERSION + UFHTConstants.APEX_TRIGGER_VERSION_CLOSING_TAG +
                        UFHTConstants.APEX_TRIGGER_STATUS_TAG +
                     UFHTConstants.APEX_TRIGGER_CLOSING_TAG); 
             
            Blob triggerTestClass = Blob.valueOf(UltraTrackUtility.createDynamicTestClassForAnObject(sobjectName, testClassName));
            
            Blob triggerTestClassMeta = Blob.valueOf(
                UFHTConstants.XML_VERSION +
                     UFHTConstants.APEX_CLASSE_OPENING_TAG +
                       UFHTConstants.APEX_TRIGGER_VERSION_OPENING_TAG + METADATA_API_VERSION + UFHTConstants.APEX_TRIGGER_VERSION_CLOSING_TAG +
                       UFHTConstants.APEX_TRIGGER_STATUS_TAG +
                    UFHTConstants.APEX_CLASS_CLOSING_TAG);
            
            Zippex deployTriggerZip = new Zippex();
            deployTriggerZip.addFile(UFHTConstants.PACKAGE_XML_KEYWORD, packageXml, null);
            deployTriggerZip.addFile(UFHTConstants.TRIGGERS_KEYWORD + triggerName + UFHTConstants.DOT_OPERATOR + 
                                     UFHTConstants.TRIGGER_KEYWORD, 
                                     triggerCode, 
                                     null);
            deployTriggerZip.addFile(UFHTConstants.TRIGGERS_KEYWORD + triggerName + UFHTConstants.DOT_OPERATOR + 
                                     UFHTConstants.TRIGGER_METADATA_XML_KEYWORD , 
                                     triggerMeta, 
                                     null);
            deployTriggerZip.addFile(UFHTConstants.CLASSES_KEYWORD + testClassName + UFHTConstants.DOT_OPERATOR + 
                                     UFHTConstants.CLASSE_EXTENSION_KEYWORD, 
                                     triggerTestClass, 
                                     null);
            deployTriggerZip.addFile(UFHTConstants.CLASSES_KEYWORD + testClassName + UFHTConstants.DOT_OPERATOR + 
                                     UFHTConstants.CLASSES_METADATA_XML_KEYWORD, 
                                     triggerTestClassMeta, 
                                     null);
    
            String deployZipData = EncodingUtil.base64Encode(deployTriggerZip.getZipArchive());
            
            MetadataService.MetadataPort service = new MetadataService.MetadataPort();
            service.SessionHeader = new MetadataService.SessionHeader_element();
            service.SessionHeader.sessionId = sessionId;
            
            MetadataService.DeployOptions deployOptions = new MetadataService.DeployOptions();
            deployOptions.allowMissingFiles = false;
            deployOptions.autoUpdatePackage = false;
            deployOptions.checkOnly = false;
            deployOptions.ignoreWarnings = false;
            deployOptions.performRetrieve = false;
            deployOptions.purgeOnDelete = false;
            deployOptions.rollbackOnError = true;
            deployOptions.testLevel = UFHTConstants.RUN_SPECIFIEDTEST_KEYWORD;
            deployOptions.singlePackage = true;
            deployOptions.runTests = new list<String>{testClassName};
            AsyncResult = service.deploy(deployZipData, DeployOptions);
            return AsyncResult != null ? AsyncResult.Id : null;
        }
        return null;
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