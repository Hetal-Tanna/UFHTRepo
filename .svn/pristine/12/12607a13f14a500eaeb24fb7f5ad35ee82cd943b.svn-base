/**
 * Class Name: DynamicTriggerGenerator 
 * @Description: This is Helper class for class "UltraTrackContainerHandler".
 *                This class check the trigger is exist or not for sObject.if trigger is not exist then generate the trigger.
 * 
 *  =======================================================================================================================
 *       Version   | Date        | Author             | Comments
 *   ----------------------------------------------------------------------------------------------------------------------
 *       1.0       | 16-11-2015  | Eternus Solution   | 1.Created Class
 *       1.2       | 29-11-2015  | Eternus Solution   | 1.removed UpdateTrigger method
 *  =======================================================================================================================
 */

public with sharing class DynamicTriggerGenerator {

    // Added constant strings to avoid hardcoding.
    private final static String CONSECUTIVE_UNDERSCORES = '__';
    private final static String AFTER_UPDATE = '(after Update)';
    private final static String WHITE_SPACE = ' ';
    private final static String CURLY_BRACE_OPEN = '{';
    private final static String LINE_BREAK = '\\n';
    private final static String IF_STATEMENT = 'if';
    private final static String BRACKET_OPEN = '(';
    private final static String TRIGGER_KEYWORD = 'trigger';
    private final static String DOT_OPERATOR = '.';
    private final static String TRIGGER_CONDITION_ISAFTER = 'isAfter';
    private final static String LOGICAL_AND = '&&';
    private final static String TRIGGER_CONDITION_ISUPDATE = 'isUpdate';
    private final static String BRACKET_CLOSE = ')';
    private final static String NAMESPACE_PREFIX = 'UFHT';
    private final static String HANDLER_CLASS_NAME = 'DynamicTriggerGenericHandler';
    private final static String HANDLER_CLASS_INSTANCE = 'objDataHandler';
    private final static String EQUALS_SIGN = '=';
    private final static String NEW_KEYWORD = 'new';
    private final static String SEMICOLON = ';';
    private final static String HANDLER_METHOD_NAME = 'onUpdateStoreHistoryData';
    private final static String NEWMAP_KEYWORD = 'newMap';
    private final static String OLDMAP_KEYWORD = 'oldMap';
    private final static String COMMA = ',';
    private final static String ESCAPED_SINGLE_QUOTE = '\'';
    private final static String CURLY_BRACE_CLOSE = '}';
    private final static String ON_KEYWORD = 'On';
    private final static String DOUBLE_QUOTE = '"';
    private final static String JSON_KEY_NAME = 'Name';
    private final static String COLON = ':';
    private final static String JSON_KEY_TABLE_ENUM_ID = 'TableEnumOrId';
    private final static String JSON_KEY_BODY = 'Body';
    private final static String EMPTY_STRING = '';
    private final static String PROTOCOL = 'https://';
    private final static String HTTP_ENDPOINT_APEXTRIGGER = '/services/data/v34.0/sobjects/ApexTrigger';
    private final static String HTTP_METHOD_POST = 'POST';
    private final static String HTTP_CONTENT_TYPE = 'Content-Type';
    private final static String HTTP_CONTENT_TYPE_JSON = 'application/json';
    private final static String HTTP_HEADER_AUTHORIZATION = 'Authorization';
    private final static String HTTP_AUTHORIZATION_BEARER = 'Bearer';


    /**
     * @Author: Eternus Solutions
     * @Description : Method to create body of trigger in JSON form.
     *                added @Future Annotation to call method asynchronous mode.
     * @Param : it takes object Name for creating the trigger on it and user session ID.
     * @Return : 
     * @Date: 16/11/2015
     **/ 
    @future(callout=true)
    public static void generateDynamicTrigger(String strSobjName,String strSessionId){

        if(String.isNotBlank(strSobjName) && String.isNotBlank(strSessionId)){
            
            String strTriggerName = strSobjName.remove(CONSECUTIVE_UNDERSCORES)+system.Label.sObjectTriggerName;
            
            String strTriggerBody = AFTER_UPDATE + WHITE_SPACE + CURLY_BRACE_OPEN + WHITE_SPACE + LINE_BREAK + WHITE_SPACE 
                                  + IF_STATEMENT + BRACKET_OPEN + TRIGGER_KEYWORD + DOT_OPERATOR + TRIGGER_CONDITION_ISAFTER + WHITE_SPACE
                                  + LOGICAL_AND + WHITE_SPACE + TRIGGER_KEYWORD + DOT_OPERATOR + TRIGGER_CONDITION_ISUPDATE + BRACKET_CLOSE + WHITE_SPACE
                                  + CURLY_BRACE_OPEN + LINE_BREAK + WHITE_SPACE;
            
            strTriggerBody += NAMESPACE_PREFIX + DOT_OPERATOR + HANDLER_CLASS_NAME + WHITE_SPACE + HANDLER_CLASS_INSTANCE + WHITE_SPACE
                            + EQUALS_SIGN + WHITE_SPACE + NEW_KEYWORD + WHITE_SPACE + NAMESPACE_PREFIX + DOT_OPERATOR + HANDLER_CLASS_NAME
                            + BRACKET_OPEN + BRACKET_CLOSE + SEMICOLON + LINE_BREAK + WHITE_SPACE;
            
            strTriggerBody += HANDLER_CLASS_INSTANCE + DOT_OPERATOR + HANDLER_METHOD_NAME + BRACKET_OPEN + TRIGGER_KEYWORD + DOT_OPERATOR
                            + NEWMAP_KEYWORD + COMMA + WHITE_SPACE + TRIGGER_KEYWORD + DOT_OPERATOR + OLDMAP_KEYWORD + COMMA + WHITE_SPACE
                            + ESCAPED_SINGLE_QUOTE + strSobjName + ESCAPED_SINGLE_QUOTE + BRACKET_CLOSE + SEMICOLON + LINE_BREAK;
            
            strTriggerBody += CURLY_BRACE_CLOSE + LINE_BREAK + CURLY_BRACE_CLOSE + LINE_BREAK + LINE_BREAK;
           
            String finalBody = TRIGGER_KEYWORD + WHITE_SPACE + strTriggerName + WHITE_SPACE + ON_KEYWORD + WHITE_SPACE + strSobjName + WHITE_SPACE
                             + strTriggerBody; 
                             
            String strJson = CURLY_BRACE_OPEN + WHITE_SPACE + DOUBLE_QUOTE + JSON_KEY_NAME + DOUBLE_QUOTE + WHITE_SPACE + COLON + WHITE_SPACE + DOUBLE_QUOTE
                           + strTriggerName + WHITE_SPACE + DOUBLE_QUOTE + COMMA + DOUBLE_QUOTE + JSON_KEY_TABLE_ENUM_ID + DOUBLE_QUOTE + WHITE_SPACE 
                           + COLON + WHITE_SPACE + DOUBLE_QUOTE + strSobjName + DOUBLE_QUOTE + COMMA + DOUBLE_QUOTE + JSON_KEY_BODY + DOUBLE_QUOTE + WHITE_SPACE
                           + COLON + WHITE_SPACE + DOUBLE_QUOTE + WHITE_SPACE + finalBody + WHITE_SPACE + DOUBLE_QUOTE + CURLY_BRACE_CLOSE;

            System.debug('****** finalBody ****** : ' + finalBody);
            System.debug('****** strJson ****** : ' + strJson);
            if(!checkTriggerExistOrNot(strTriggerName)){
                CreateTrigger(strJson,strSessionId);
            }

        }
    }
    
    /**
     * @Author: Eternus Solutions
     * @Description : Method to check tigger exist or not.
     * @Param : it takes trigger Name as string.
     * @Return : boolean value
     * @Date:16/11/2015
     **/ 
    public static Boolean checkTriggerExistOrNot(String strTriggerName){
        list<ApexTrigger> lstTrigger = new list<ApexTrigger>();
        if(String.isNotBlank(strTriggerName)){
            lstTrigger = [select ID,
                                 Name 
                            FROM ApexTrigger 
                           WHERE Name =:strTriggerName]; 
        }
        return (!lstTrigger.isEmpty()) ? true : false;
    } 
   
    /**
     * @Author: Eternus Solutions
     * @Description :Method will create trigger on sObject using REST API.
     * @Param : it takes trigger body in JSON Format as string and user session ID.
     * @Return :
     * @Date:16/11/2015
     **/ 
    public static Void createTrigger(String strJson,String strSessionId)
    {  
        String baseURL = EMPTY_STRING;
        map<String,Configuration__c> mapConfig = Configuration__c.getAll();
        if(mapConfig.containsKey(system.Label.ConfigureColsAndFieldsCustomSettingRecordName)){
            Configuration__c objCofig = mapConfig.get(system.Label.ConfigureColsAndFieldsCustomSettingRecordName);
            baseURL = PROTOCOL + objCofig.SalesforceBaseURL__c;
        }
        if(String.isNotBlank(strJson) && String.isNotBlank(strSessionId) && String.isNotBlank(baseURL)){
            try {
                HttpRequest req = new HttpRequest();
                req.setEndpoint(baseURL + HTTP_ENDPOINT_APEXTRIGGER);
                req.setMethod(HTTP_METHOD_POST);
                req.setHeader(HTTP_CONTENT_TYPE, HTTP_CONTENT_TYPE_JSON);
                req.setHeader(HTTP_HEADER_AUTHORIZATION, HTTP_AUTHORIZATION_BEARER + WHITE_SPACE + strSessionId);
                req.setBody(strJson);          
               
                Http httpReq = new Http();
                HttpResponse res = httpReq.send(req);
                System.debug(res.getBody());
            }
            catch(Exception e){
                // TODO : Nothing
            }
        }
    }
}