/** 
 * @Class Name: DynamicTriggerGeneratorTest
 * @Description: This class contains unit tests for DynamicTriggerGenerator.cls
 * ========================================================================================================================
 *       Version   | Date        | Author             | Comments
 * ------------------------------------------------------------------------------------------------------------------------
 *       1.0       | 01/03/2016  | Eternus Solutions  | 1.Created the Test Class for DynamicTriggerGenerator
 * ========================================================================================================================
 **/
@isTest(seeAllData=false)
private class DynamicTriggerGeneratorTest {
    
    private class WebServiceMockImpl implements WebServiceMock 
    {
        public void doInvoke(
            Object stub, Object request, Map<String, Object> response,
            String endpoint, String soapAction, String requestName,
            String responseNS, String responseName, String responseType) {
            if(request instanceof MetadataService.checkDeployStatus_element)
                response.put('response_x', new MetadataService.checkDeployStatusResponse_element());
            else if(request instanceof MetadataService.deploy_element)
                response.put('response_x', new MetadataService.deployResponse_element());
            return;
        }
    }   
    /** 
     * @Author: Eternus Solutions
     * @Description: Template method to verify the functionality of method "checkTriggerExistOrNot()".
     * @Param: 1. objectName: Name of an Object.
     *         2. triggerName: Name of the Trigger.
     *         3. isTriggerExist: Boolean value which return true if trigger is present else false.
     * @Date: 01/03/2016
     **/ 
    static void checkTriggerExistOrNotTest(String objectName, String triggerName, Boolean isTriggerExist) {
        Profile profileObj = [SELECT Id 
                              FROM Profile 
                              WHERE Name = 'System Administrator'
                              LIMIT 1];
        User userObj = TestDataFactory.getUser('User1', 'user1', 'test@user1.come', profileObj.Id );
        Boolean triggerExistOrNot;
        System.runAs(userObj) {
            Test.startTest();
            if(String.isNotBlank(triggerName) 
            && triggerName.containsIgnoreCase(UFHTConstants.APEX_TRIGGER_STATUS_INACTIVE)
            && isTriggerExist == null) {
                // Set mock with dummy id as blank to get invalid response.
                Test.setMock(HttpCalloutMock.class, new MockHttpResponseTriggerActivator(''));
                triggerExistOrNot = DynamicTriggerGenerator.checkTriggerExistOrNot(objectName, triggerName, UserInfo.getSessionId());
            }
            else {
                // Set mock with dummy id to get fake response.
                Test.setMock(HttpCalloutMock.class, new MockHttpResponseTriggerActivator('01p28000009uBeR'));
                triggerExistOrNot = DynamicTriggerGenerator.checkTriggerExistOrNot(objectName, triggerName, UserInfo.getSessionId());
             }
            Test.stopTest();
        }
        
        System.assertEquals(isTriggerExist, triggerExistOrNot);
    }
    
    /** 
     * @Author: Eternus Solutions
     * @Description: Template method to verify the functionality of method "generateDynamicTrigger()".
     * @Param: 1. objectName: Object name to generate trigger
     *         2. triggerName: To store the trigger name
     *         3. scenario: To indicate value scenario of test method
     *         4. noOfTriggers: To verify the expected result
     * @Return: NA
     * @Date: 27/07/2016
     **/ 
    public static void generateDynamicTriggerTest(String objectName, String triggerName, 
                                                      String scenario, Integer noOfTriggers) {
        Profile profileObj = [SELECT Id 
                              FROM Profile 
                              WHERE Name = 'Standard User' 
                              LIMIT 1];
        User userObj = TestDataFactory.getUser('User1', 'user1', 'test@user1.come', profileObj.Id );
        
        UFHT__Configuration__c configObj = TestDataFactory.getConfiguration(5, 10, 100, 'Ascending', URL.getSalesforceBaseUrl().getHost());
        insert configObj;
        TestUtil.checkAssertsForSetupData('UFHT__Configuration__c', 1);
        
        System.runAs(userObj) {
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseDyanamicTriggerGenerator());
            if(scenario.equalsIgnoreCase('validSessionId')) {
                DynamicTriggerGenerator.generateDynamicTrigger(objectName, UserInfo.getSessionId());
            }
            else{
                DynamicTriggerGenerator.generateDynamicTrigger(objectName, '');
            }
            Test.stopTest();
        }
        list<ApexTrigger> triggersList = [SELECT Id,
                                                 Name 
                                          FROM ApexTrigger 
                                          WHERE Name =: triggerName
                                          AND TableEnumOrId =: objectName];
        System.assertEquals(noOfTriggers, triggersList.size());
    }
    
    /** 
     * @Author: Eternus Solutions
     * @Description: Method to create trigger body
     * @Param: sObjectName: Name of an Object
     * @Date: 26/07/2016
     **/ 
    public static String createTriggerBody(String sObjectName) {
        
        String triggerName = 'testTrigger';
            
        String finalBody = UFHTConstants.TRIGGER_KEYWORD + UFHTConstants.WHITE_SPACE + triggerName + UFHTConstants.WHITE_SPACE + UFHTConstants.ON_KEYWORD + UFHTConstants.WHITE_SPACE + sobjectName + UFHTConstants.WHITE_SPACE; 

        //Trigger body
        finalBody += UFHTConstants.BRACKET_OPEN + UFHTConstants.AFTER_UPDATE + UFHTConstants.BRACKET_CLOSE + UFHTConstants.WHITE_SPACE
                       + UFHTConstants.CURLY_BRACE_OPEN + UFHTConstants.WHITE_SPACE + '\r\n'+ UFHTConstants.WHITE_SPACE
                       + UFHTConstants.IF_STATEMENT + UFHTConstants.BRACKET_OPEN
                       + UFHTConstants.NOT_OPERATOR + UFHTConstants.NAMESPACE_PREFIX + UFHTConstants.DOT_OPERATOR + UFHTConstants.HANDLER_CLASS_NAME
                       + UFHTConstants.DOT_OPERATOR + UFHTConstants.HAS_ALREADY_RUN + UFHTConstants.WHITE_SPACE + UFHTConstants.LOGICAL_AND + UFHTConstants.WHITE_SPACE + UFHTConstants.TRIGGER_KEYWORD + UFHTConstants.DOT_OPERATOR + UFHTConstants.TRIGGER_CONDITION_ISAFTER + UFHTConstants.WHITE_SPACE
                       + UFHTConstants.LOGICAL_AND + UFHTConstants.WHITE_SPACE + UFHTConstants.TRIGGER_KEYWORD + UFHTConstants.DOT_OPERATOR + UFHTConstants.TRIGGER_CONDITION_ISUPDATE + UFHTConstants.BRACKET_CLOSE + UFHTConstants.WHITE_SPACE + UFHTConstants.CURLY_BRACE_OPEN + + '\r\n'+ UFHTConstants.WHITE_SPACE + UFHTConstants.NAMESPACE_PREFIX + UFHTConstants.DOT_OPERATOR + UFHTConstants.HANDLER_CLASS_NAME + UFHTConstants.WHITE_SPACE
                       + UFHTConstants.HANDLER_CLASS_INSTANCE + UFHTConstants.WHITE_SPACE + UFHTConstants.EQUALS_SIGN + UFHTConstants.WHITE_SPACE + UFHTConstants.NEW_KEYWORD + UFHTConstants.WHITE_SPACE + UFHTConstants.NAMESPACE_PREFIX
                       + UFHTConstants.DOT_OPERATOR + UFHTConstants.HANDLER_CLASS_NAME + UFHTConstants.BRACKET_OPEN + UFHTConstants.BRACKET_CLOSE + UFHTConstants.SEMICOLON + '\r\n' + UFHTConstants.WHITE_SPACE
                       + UFHTConstants.HANDLER_CLASS_INSTANCE + UFHTConstants.DOT_OPERATOR + UFHTConstants.HANDLER_METHOD_NAME + UFHTConstants.BRACKET_OPEN + UFHTConstants.TRIGGER_KEYWORD + UFHTConstants.DOT_OPERATOR + UFHTConstants.NEWMAP_KEYWORD
                       + UFHTConstants.COMMA + UFHTConstants.WHITE_SPACE + UFHTConstants.TRIGGER_KEYWORD + UFHTConstants.DOT_OPERATOR + UFHTConstants.OLDMAP_KEYWORD + UFHTConstants.COMMA + UFHTConstants.WHITE_SPACE + UFHTConstants.ESCAPED_SINGLE_QUOTE
                       + sobjectName + UFHTConstants.ESCAPED_SINGLE_QUOTE + UFHTConstants.BRACKET_CLOSE + UFHTConstants.SEMICOLON + + '\r\n'+ 
                       + UFHTConstants.NAMESPACE_PREFIX + UFHTConstants.DOT_OPERATOR + UFHTConstants.HANDLER_CLASS_NAME + UFHTConstants.DOT_OPERATOR + UFHTConstants.HAS_ALREADY_RUN
                       + UFHTConstants.WHITE_SPACE + UFHTConstants.EQUALS_SIGN + UFHTConstants.WHITE_SPACE + UFHTConstants.TRUE_KEYWORD
                       + UFHTConstants.SEMICOLON + + '\r\n'+ UFHTConstants.CURLY_BRACE_CLOSE + + '\r\n'+ UFHTConstants.CURLY_BRACE_CLOSE
                       + '\r\n' + '\r\n';
        
        return finalBody;
    }
    
    /** 
     * @Author: Eternus Solutions
     * @Description: Template method to verify the functionality of method "createTrigger()".
     * @Param: 1. sObjectName: Object name on which trigger to be created
     *         2. sessionId: String variable to identify value of parameter session Id.
     *         3. jsonTrigger: Trigger body in Json format
     *         4. isTriggerCreated: Boolean value to test expected result in assert statement
     * @Date: 26/07/2016
     **/ 
    static void createTriggerTest(String sObjectName, String sessionId, String triggerBody, String triggerName, Boolean isTriggerCreated) {
        Profile profileObj = [SELECT Id 
                              FROM Profile 
                              WHERE Name = 'Standard User' 
                              LIMIT 1];
        User userObj = TestDataFactory.getUser('User1', 'user1', 'test@user1.come', profileObj.Id );
        
        UFHT__Configuration__c configObj = TestDataFactory.getConfiguration(5, 10, 100, 'Ascending', URL.getSalesforceBaseUrl().getHost());
        insert configObj;
        TestUtil.checkAssertsForSetupData('UFHT__Configuration__c', 1);
        
        Id isCreateTriggerIsInProgress;
        System.runAs(userObj) {
            Test.startTest();
            System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
            
            if(sessionId == null && triggerBody == null && triggerName == null) {
                isCreateTriggerIsInProgress = DynamicTriggerGenerator.createTrigger(sObjectName, null, null, null);
            }
            else if(sessionId != null && sessionId.equalsIgnoreCase('validSessionId') && triggerBody == null && triggerName != null) {
                isCreateTriggerIsInProgress = DynamicTriggerGenerator.createTrigger(sObjectName, null, UserInfo.getSessionId(), triggerName);
            }
            else if(sessionId == null && triggerBody != null && triggerBody.containsIgnoreCase('testTrigger') && triggerName != null) {
                isCreateTriggerIsInProgress = DynamicTriggerGenerator.createTrigger(sObjectName, triggerBody, null, triggerName);
            }
            else if(sessionId != null && triggerBody != null && triggerBody.containsIgnoreCase('testTrigger') 
                && sessionId.equalsIgnoreCase('validSessionId') &&
                triggerName == null) {
            	isCreateTriggerIsInProgress = DynamicTriggerGenerator.createTrigger(sObjectName, triggerBody, UserInfo.getSessionId(), null);
            }
            else if(sessionId != null && triggerBody != null && triggerBody.containsIgnoreCase('testTrigger') 
                && sessionId.equalsIgnoreCase('validSessionId') &&
                triggerName != null) {
                isCreateTriggerIsInProgress = DynamicTriggerGenerator.createTrigger(sObjectName, triggerBody, UserInfo.getSessionId(), triggerName);
            }
            
            Test.stopTest();
        }
        System.assertEquals(!isTriggerCreated, isCreateTriggerIsInProgress == null);
    }
    
    /** 
     * @Author: Eternus Solutions
     * @Description: Test template method to verify the method "createMetadataContainer()".
     * @Param: 1. SessionId: To make call out to create metadata Container record.
     *         2. assertValue: Expected value to check in assert. 
     * @Return: NA 
     * @Date: 04/08/2016
     **/
    static void createMetadataContainerTest(String SessionId, String assertValue) {
        Profile profileObj = [SELECT Id 
                              FROM Profile 
                              WHERE Name = 'Standard User' 
                              LIMIT 1];
        User userObj = TestDataFactory.getUser('User1', 'user1', 'test@user1.come', profileObj.Id );
        String containerId;
        System.runAs(userObj) {
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseTriggerActivator('01p28000009uBeR'));
            if(String.isBlank(SessionId) || SessionId == null) {
                containerId = DynamicTriggerGenerator.createMetadataContainer(null);
            }
            else if(SessionId.equalsIgnoreCase('ValidSessionId')){ 
                containerId = DynamicTriggerGenerator.createMetadataContainer(UserInfo.getSessionId());
            }
        }
        Test.stopTest();
        if(String.isBlank(SessionId)) {
            System.assertEquals(containerId, assertValue);
        }
        else if(SessionId.equalsIgnoreCase('ValidSessionId')){
            System.assertNotEquals(containerId, assertValue);
        }
    }
    
    /** 
     * @Author: Eternus Solutions
     * @Description: Test template method to verify functionality of method "createApexTriggerMember()".
     * @Param: 1. MetadataContainerId: Holds the MetadataContainer object's id.
     *         2. TriggerId: Holds apex trigger id.
     *         3. TriggerBody: Holds the apex string body.
     *         4. SessionId: Holds session Id.
     * @Return: NA.
     * @Date: 05/08/2016
     **/
    static void createApexTriggerMemberTest(String pMetadataContainerId,
                                                   String pTriggerId, 
                                                   String pTriggerBody,
                                                   String pSessionId,
                                                   Boolean assertValue) {
        Boolean isSucess;
        Profile profileObj = [SELECT Id 
                              FROM Profile 
                              WHERE Name = 'Standard User' 
                              LIMIT 1];
        User userObj = TestDataFactory.getUser('User1', 'user1', 'test@user1.come', profileObj.Id );
        
        list<ApexTrigger> triggersList = [SELECT 
                                          Id,
                                          Name,
                                          Body
                                          FROM ApexTrigger 
                                          WHERE Name = 'UFHTSharing_PurposecHistoryTrackTrigger' 
                                          AND TableEnumOrId = 'UFHT__Sharing_Purpose__c'
                                          LIMIT 1];
        System.runAs(userObj) {
            Test.startTest();
            if(String.isNotBlank(pMetadataContainerId) 
            && (pMetadataContainerId.equalsIgnoreCase('Valid') || pMetadataContainerId.equalsIgnoreCase('Invalid'))) {
                // Set mock with dummy id to get fake response.
                Test.setMock(HttpCalloutMock.class, new MockHttpResponseTriggerActivator('01p28000009uBeR'));
                pMetadataContainerId = pMetadataContainerId.equalsIgnoreCase('Valid')
                                     ? DynamicTriggerGenerator.createMetadataContainer(UserInfo.getSessionId())
                                     : '';
            }
            
            if(String.isNotBlank(pTriggerId) && 
            (pTriggerId.equalsIgnoreCase('Valid') || pTriggerId.equalsIgnoreCase('Invalid')) && 
            triggersList != null && 
            !triggersList.isEmpty()){
                 pTriggerId = pTriggerId.equalsIgnoreCase('Valid')
                              ? triggersList[0].Id 
                              : null;
            }
            
            if(String.isNotBlank(pTriggerBody) && 
            ( pTriggerBody.equalsIgnoreCase('Valid') || pTriggerBody.equalsIgnoreCase('Invalid')) && 
            triggersList != null && 
            !triggersList.isEmpty()){
                pTriggerBody = pTriggerBody.equalsIgnoreCase('Valid') 
                             ? triggersList[0].Body
                             : ' ';
            }
            
            if(String.isNotBlank(pSessionId) 
            && (pSessionId.equalsIgnoreCase('Valid') || pSessionId.equalsIgnoreCase('Invalid'))){
                pSessionId = pSessionId.equalsIgnoreCase('Valid')
                           ? UserInfo.getSessionId()
                           : ' ';
            }
            
            // Set mock with dummy id to get fake response.
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseTriggerActivator('01p28000009uBeR'));
            isSucess = DynamicTriggerGenerator.createApexTriggerMember(pMetadataContainerId,
                                                                       pTriggerId,
                                                                       pTriggerBody,
                                                                       pSessionId);
            Test.stopTest();
        }
        System.assertEquals(isSucess, assertValue);
    }
    
    /** 
     * @Author: Eternus Solutions
     * @Description: Test template method to verify method "createContainerAsyncRequest()".
     * @Param: 1. pMetadataContainerId: To identify the value of parameter MetadataContainerId.
     *         2. pSessionId: To identify the value of parameter sessionId.
     *         3. pAssertValue: Boolean value to check expected result in assert statement.
     * @Return: NA.
     * @Date: 05/08/2016
     **/
    static void createContainerAsyncRequestTest(String pMetadataContainerId, String pSessionId, Boolean pAssertValue) {
        Boolean isSucess;
        Profile profileObj = [SELECT Id 
                              FROM Profile 
                              WHERE Name = 'Standard User'
                              LIMIT 1];
        User userObj = TestDataFactory.getUser('User1', 'user1', 'test@user1.come', profileObj.Id );
       
        System.runAs(userObj) {
            Test.startTest();
            if(String.isNotBlank(pMetadataContainerId) && 
            pMetadataContainerId.equalsIgnoreCase('Valid') ) {
                // Set mock with dummy id to get fake response.
                Test.setMock(HttpCalloutMock.class, new MockHttpResponseTriggerActivator('01p28000009uReR'));
                pMetadataContainerId = DynamicTriggerGenerator.createMetadataContainer(UserInfo.getSessionId());
            }
            else if(String.isNotBlank(pMetadataContainerId) && 
            pMetadataContainerId.equalsIgnoreCase('Invalid')) {
                pMetadataContainerId = '';
            }
            
            
            if(String.isNotBlank(pSessionId) &&
            pSessionId.equalsIgnoreCase('Valid')) {
                pSessionId = UserInfo.getSessionId();
            }
            else if(String.isNotBlank(pSessionId) &&
            pSessionId.equalsIgnoreCase('Invalid')){
                pSessionId = '';
            }
            // Set mock with dummy id to get fake response.
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseTriggerActivator('01p28000009UReR'));
            isSucess = DynamicTriggerGenerator.createContainerAsyncRequest(pMetadataContainerId, pSessionId);
            Test.stopTest();
        }
        System.assertEquals(isSucess, pAssertValue);
    }
     
    /** 
     * @Author: Eternus Solutions
     * @Description: Method to verify trigger name is present in Org or not by passing valid trigger name.
     * @Expected Result: Method should check if trigger is already present or not.
     * @Date: 01/03/2016
     **/ 
    static testMethod void checkTriggerExistOrNotTestCase1() {
        checkTriggerExistOrNotTest('UFHT__Sharing_Purpose__c', 'UFHTUFHTSharing_PurposecHistoryTrackTrigger', true);
    }
    
    /** 
     * @Author: Eternus Solutions
     * @Description: Method to verify trigger name is present in Org or not by passing invalid trigger name.
     * @Expected Result: Method should check if trigger is already present or not.
     * @Date: 01/03/2016
     **/ 
    static testMethod void checkTriggerExistOrNotTestCase2() {
        checkTriggerExistOrNotTest('Account', 'abc abc', false);
    }
    
    /** 
     * @Author: Eternus Solutions
     * @Description: Method to verify trigger name is present in Org or not by passing blank trigger name.
     * @Expected Result: Method should check if trigger is already present or not.
     * @Date: 26/07/2016
     **/ 
    static testMethod void checkTriggerExistOrNotTestCase3() {
        checkTriggerExistOrNotTest('Account', '', false);
    }
    
    /** 
     * @Author: Eternus Solutions
     * @Description: Method to verify trigger name is present in Org or not by passing blank Object name.
     * @Expected Result: Method should check if trigger is already present or not.
     * @Date: 26/07/2016
     **/ 
    static testMethod void checkTriggerExistOrNotTestCase4() {
        checkTriggerExistOrNotTest('', 'abc', false);
    }
    
    /** 
     * @Author: Eternus Solutions
     * @Description: Method to verify trigger name is present in Org or not 
     *               by passing invalid Object name and invalid trigger name.
     * @Expected Result: Method should check if trigger is already present or not.
     * @Date: 26/07/2016
     **/ 
    static testMethod void checkTriggerExistOrNotTestCase5() { 
        checkTriggerExistOrNotTest('testObject Invalid', 'Invalid Trigger', false);
    }
    
    /** 
     * @Author: Eternus Solutions
     * @Description: Method to verify trigger name is present in Org or not
     *               following scenario: blank Object name and blank trigger name.
     * @Expected Result: Method should check if trigger is already present or not.
     * @Date: 26/07/2016
     **/ 
    static testMethod void checkTriggerExistOrNotTestCase6() {
        checkTriggerExistOrNotTest('', '', false);
    }
        
    /** 
     * @Author: Eternus Solutions
     * @Description: Method to test functionality of method "checkTriggerExistOrNot()" with the
     *               following scenario: trigger is exist and it active. Passed valid object 
     *               name and trigger name.
     * @Expected Result: Method should return true if trigger exist and it is active.
     * @Date: 04/08/2016
     **/ 
    static testMethod void checkTriggerExistOrNotTestCase7() {
       checkTriggerExistOrNotTest('UFHT__Sharing_Purpose__c', 'UFHTUFHTSharing_PurposecHistoryTrackTrigger', true);
    }
    
    /** 
     * @Author: Eternus Solutions
     * @Description: Method to test the functionality of method "checkTriggerExistOrNot()" with the
     *               following scenario: trigger is exist and it is deactive.
     * @Expected Result: Method should return true if trigger exist and it is activated.
     * @Date: 08/08/2016
     **/ 
    static testMethod void checkTriggerExistOrNotTestCase8() {
       checkTriggerExistOrNotTest('UFHT__Sharing_Purpose__c', 'InactiveUFHTUFHTSharing_PurposecHistoryTrackTrigger', true);
    }
    
    /** 
     * @Author: Eternus Solutions
     * @Description: Method to test the functionality of method "checkTriggerExistOrNot()" with the
     *               following scenario: trigger is exist and it is deactive.
     * @Expected Result: Method should return null if fail to deactivate trigger as active trigger.
     * @Date: 08/08/2016
     **/ 
    static testMethod void checkTriggerExistOrNotTestCase9() {
       checkTriggerExistOrNotTest('UFHT__Sharing_Purpose__c', 'InactiveUFHTUFHTSharing_PurposecHistoryTrackTrigger', null);
    }
    
    /** 
     * @Author: Eternus Solutions
     * @Description: Method to verify trigger is getting created or not
     *               by passing valid standard Object and valid sessionId.
     * @Expected Result: Method should check if trigger is created or not.
     * @Date: 01/03/2016
     **/ 
    static testMethod void generateDynamicTriggerTestCase1() {
        
        // This method will not create a trigger as trigger already exists on Account
        generateDynamicTriggerTest('Account', 'AccountTrigger', 'validSessionId', 0);
    }
    
    /** 
     * @Author: Eternus Solutions
     * @Description: Method to verify trigger is getting created or not
     *               by passing valid custom Object and sessionId.
     * @Expected Result: Method should check if trigger is created or not.
     * @Date: 26/07/2016
     **/ 
    static testMethod void generateDynamicTriggerTestCase2() {
        generateDynamicTriggerTest('UFHT__Sharing_Purpose__c', 'UFHTUFHTSharing_PurposecHistoryTrackTrigger', 'validSessionId', 1);
    }
    
    /** 
     * @Author: Eternus Solutions
     * @Description: Method to verify trigger is getting created or not
     *               by passing blank objectName and valid sessionId.
     * @Expected Result: Method should check if trigger is created or not.
     * @Date: 26/07/2016
     **/ 
    static testMethod void generateDynamicTriggerTestCase3() {
        generateDynamicTriggerTest('', 'Trigger', 'validSessionId', 0);
    }
    
    /** 
     * @Author: Eternus Solutions
     * @Description: Method to verify trigger is getting created or not
     *               by passing blank sessionId.
     * @Expected Result: Method should check if trigger is created or not.
     * @Date: 26/07/2016
     **/ 
    static testMethod void generateDynamicTriggerTestCase4() {
        generateDynamicTriggerTest('UFHTUFHTSharing_PurposecHistoryTrackTrigger', 'UFHT__Sharing_Purpose__c', 'blankSessionId', 0);
    }
    
    /** 
     * @Author: Eternus Solutions
     * @Description: Method to verify trigger is getting created or not
     *               by passing blank object name and blank sessionId.
     * @Expected Result: Method should check if trigger is created or not.
     * @Date: 26/07/2016
     **/ 
    static testMethod void generateDynamicTriggerTestCase5() {
        generateDynamicTriggerTest('', 'Trigger', 'blankSessionId', 0);
     }
    
    /** 
     * @Author: Eternus Solutions
     * @Description: Mmethod to verify trigger is getting created or not
     *               on non triggerable Object: PricebookEntry.
     * @Expected Result: Method should check if trigger is created or not.
     * @Date: 26/07/2016
     **/ 
    static testMethod void generateDynamicTriggerTestCase6() {
        generateDynamicTriggerTest('PricebookEntry', 'PricebookEntryTrigger', 'validSessionId', 0);
    }
    
    
   /** 
     * @Author: Eternus Solutions
     * @Description: Method to create a trigger with all valid parameters
     * @Expected Result: Method should check if trigger is created or not.
     * @Date: 26/07/2016
     **/ 
    static testMethod void createTriggerTestCase1() {
        createTriggerTest('Account', 'validSessionId', createTriggerBody('Account'), 'testTrigger', false);
    }
    
    /** 
     * @Author: Eternus Solutions
     * @Description: Method to create a trigger passing valid sessionId, null sObjectName and blank jsonTrigger 
     * @Expected Result: Method should check if trigger is created or not.
     * @Date: 26/07/2016
     **/ 
    static testMethod void createTriggerTestCase2() {
        createTriggerTest(null, 'validSessionId', createTriggerBody(''), 'testTrigger', false);
    }
    
    /** 
     * @Author: Eternus Solutions
     * @Description: Method to create a trigger passing valid sObjectName, valid sessionId and null jsonTrigger
     * @Expected Result: Method should check if trigger is created or not.
     * @Date: 26/07/2016
     **/ 
    static testMethod void createTriggerTestCase3() {
        createTriggerTest('Account', 'validSessionId', null, 'testTrigger', false);
    }
    
    /** 
     * @Author: Eternus Solutions
     * @Description: Method to create a trigger passing valid sObjectName, null sessionId and valid jsonTrigger
     * @Expected Result: Method should check if trigger is created or not.
     * @Date: 26/07/2016
     **/ 
    static testMethod void createTriggerTestCase4() {
        createTriggerTest('Account', null, createTriggerBody('Account'), 'testTrigger', false);
    }
    
    /** 
     * @Author: Eternus Solutions
     * @Description: Method to create a trigger passing null sObjectName and null sessionId
     * @Expected Result: Method should check if trigger is created or not.
     * @Date: 26/07/2016
     **/ 
    static testMethod void createTriggerTestCase5() {
        createTriggerTest(null, null, createTriggerBody('Account'), 'testTrigger' , false);
    }
    
    /** 
     * @Author: Eternus Solutions
     * @Description: Method to create a trigger passing null jsonTrigger and null sessionId
     * @Expected Result: Method should check if trigger is created or not.
     * @Date: 26/07/2016
     **/ 
    static testMethod void createTriggerTestCase6() {
        createTriggerTest('Account', null, null, null, false);
    }
    
    /** 
     * @Author: Eternus Solutions
     * @Description: Method to create a trigger passing null sObjectName, valid sessionId and null jsonTrigger
     * @Expected Result: Method should check if trigger is created or not.
     * @Date: 26/07/2016
     **/ 
    static testMethod void createTriggerTestCase7() {
        createTriggerTest(null, 'validSessionId', null, null, false);
    }
    
    /** 
     * @Author: Eternus Solutions
     * @Description: Method to create a trigger by passing all parameters as null
     * @Expected Result: Method should check if trigger is created or not.
     * @Date: 26/07/2016
     **/ 
    static testMethod void createTriggerTestCase8() {
        createTriggerTest(null, null, null, null, false);
    }
    
    /** 
     * @Author: Eternus Solutions
     * @Description: Method to create a trigger with trigger name is null.
     * @Expected Result: Method should check if trigger is created or not.
     * @Date: 26/07/2016
     **/ 
    static testMethod void createTriggerTestCase9() {
        createTriggerTest('Account', 'validSessionId', createTriggerBody('Account'), null, false);
    }
    
    /** 
     * @Author: Eternus Solutions
     * @Description: Test functionality of method "createMetadataContainer()" with the following 
     *               scenario: Passed valid value for parameter sessionId. 
     * @Expected Result: Method should create returns the id of metadata container object's record.
     * @Date: 04/08/2016
     **/
    static testMethod void createMetadataContainerTestCase1() {
        createMetadataContainerTest('ValidSessionId', null);
    }
    
    /** 
     * @Author: Eternus Solutions
     * @Description: Test functionality of method "createMetadataContainer()" with the following 
     *               scenario: Passed invalid value as blank for parameter sessionId. 
     * @Expected Result: Method should returns empty string.
     * @Date: 04/08/2016
     **/
    static testMethod void createMetadataContainerTestCase2() {
        createMetadataContainerTest('InvalidSessionId', UFHTConstants.EMPTY_STRING);
    }
    
    /** 
     * @Author: Eternus Solutions
     * @Description: Test functionality of method "createMetadataContainer()" with the following 
     *               scenario: Passed invalid value as null for parameter sessionId.
     * @Expected Result: Method should returns empty string.
     * @Date: 04/08/2016
     **/
    static testMethod void createMetadataContainerTestCase3() {
        createMetadataContainerTest('InvalidSessionId', UFHTConstants.EMPTY_STRING);
    }
    
    /** 
     * @Author: Eternus Solutions
     * @Description: Test method to test the functionality of method "createApexTriggerMember()" with
     *               the following scenario: Passed all parameters metadataContainerId, triggerId,
     *               triggerBody, sessionId with valid values.
     * @Expected Result: Method should return true value.
     * @Date: 05/08/2016
     **/ 
    static testMethod void createApexTriggerMemberTestCase1() {
        createApexTriggerMemberTest('Valid', 'Valid', 'Valid', 'Valid', true);
    }
    
    /** 
     * @Author: Eternus Solutions
     * @Description: Test method to test the functionality of method "createApexTriggerMember()" with
     *               the following scenario: Passed all parameters metadataContainerId, triggerId,
     *               triggerBody, sessionId with invalid values.
     * @Expected Result: Method should return false value.
     * @Date: 05/08/2016
     **/ 
    static testMethod void createApexTriggerMemberTestCase2() {
        createApexTriggerMemberTest('Invalid', 'Invalid', 'Invalid', 'Invalid', false);
    }
    
    /** 
     * @Author: Eternus Solutions
     * @Description: Test method to test the functionality of method "createApexTriggerMember()" with
     *               the following scenario: Passed first all parameters metadataContainerId, triggerId,
     *               triggerBody, sessionId with null values.
     * @Expected Result: Method should return false value.
     * @Date: 05/08/2016
     **/ 
    static testMethod void createApexTriggerMemberTestCase3() {
        createApexTriggerMemberTest(null, null, null, null, false);
    }
    
    /** 
     * @Author: Eternus Solutions
     * @Description: Test method to test the functionality of method "createApexTriggerMember()" with
     *               the following scenario: Passed first all parameters metadataContainerId, triggerId,
     *               triggerBody, sessionId with blank values.
     * @Expected Result: Method should return false value.
     * @Date: 05/08/2016
     **/ 
    static testMethod void createApexTriggerMemberTestCase4() {
        createApexTriggerMemberTest('', '', '', '', false);
    }
    
    /** 
     * @Author: Eternus Solutions
     * @Description: Test method to test the functionality of method "createApexTriggerMember()" with
     *               the following scenario: Passed first param metadataContainerId as null and triggerId,
     *               triggerBody, sessionId with valid values.
     * @Expected Result: Method should return false value.
     * @Date: 05/08/2016
     **/ 
    static testMethod void createApexTriggerMemberTestCase5() {
        createApexTriggerMemberTest(null, 'Valid', 'Valid', 'Valid', false);
    }
    
    /** 
     * @Author: Eternus Solutions
     * @Description: Test method to test the functionality of method "createApexTriggerMember()" with
     *               the following scenario: Passed first param metadataContainerId as blank and triggerId,
     *               triggerBody, sessionId with valid values.
     * @Expected Result: Method should return false value.
     * @Date: 05/08/2016
     **/ 
    static testMethod void createApexTriggerMemberTestCase6() {
        createApexTriggerMemberTest('', 'Valid', 'Valid', 'Valid', false);
    }
    
    /** 
     * @Author: Eternus Solutions
     * @Description: Test method to test the functionality of method "createApexTriggerMember()" with
     *               the following scenario: Passed first param metadataContainerId as invalid value and triggerId,
     *               triggerBody, sessionId with valid values.
     * @Expected Result: Method should return false value.
     * @Date: 05/08/2016
     **/ 
    static testMethod void createApexTriggerMemberTestCase7() {
        createApexTriggerMemberTest('Invalid', 'Valid', 'Valid', 'Valid', false);
    }
    
    /** 
     * @Author: Eternus Solutions
     * @Description: Test method to test the functionality of method "createApexTriggerMember()" with
     *               the following scenario: Passed second parameter triggerId as null and metadataContainerId,
     *               triggerBody, sessionId with valid values.
     * @Expected Result: Method should return false value.
     * @Date: 05/08/2016
     **/ 
    static testMethod void createApexTriggerMemberTestCase8() {
        createApexTriggerMemberTest('Valid', null, 'Valid', 'Valid', false);
    }
    
    /** 
     * @Author: Eternus Solutions
     * @Description: Test method to test the functionality of method "createApexTriggerMember()" with
     *               the following scenario: Passed second parameter triggerId as blank and metadataContainerId,
     *               triggerBody, sessionId with valid values.
     * @Expected Result: Method should return false value.
     * @Date: 05/08/2016
     **/ 
    static testMethod void createApexTriggerMemberTestCase9() {
        createApexTriggerMemberTest('Valid', '', 'Valid', 'Valid', false);
    }
    
    /** 
     * @Author: Eternus Solutions
     * @Description: Test method to test the functionality of method "createApexTriggerMember()" with
     *               the following scenario: Passed second parameter triggerId as invalid and metadataContainerId,
     *               triggerBody, sessionId with valid values.
     * @Expected Result: Method should return false value.
     * @Date: 05/08/2016
     **/ 
    static testMethod void createApexTriggerMemberTestCase10() {
        createApexTriggerMemberTest('Valid', 'Invalid', 'Valid', 'Valid', false);
    }
    
    /** 
     * @Author: Eternus Solutions
     * @Description: Test method to test the functionality of method "createApexTriggerMember()" with
     *               the following scenario: Passed third parameter triggerBody as null and metadataContainerId, triggerId,
     *               sessionId with valid values.
     * @Expected Result: Method should return false value.
     * @Date: 05/08/2016
     **/ 
    static testMethod void createApexTriggerMemberTestCase11() {
        createApexTriggerMemberTest('Valid', 'Valid', null, 'Valid', false);
    }
    
    /** 
     * @Author: Eternus Solutions
     * @Description: Test method to test the functionality of method "createApexTriggerMember()" with
     *               the following scenario: Passed third parameter triggerBody as blank and metadataContainerId, triggerId,
     *               sessionId with valid values.
     * @Expected Result: Method should return false value.
     * @Date: 05/08/2016
     **/ 
    static testMethod void createApexTriggerMemberTestCase12() {
        createApexTriggerMemberTest('Valid', 'Valid', '', 'Valid', false);
    }
    
    /** 
     * @Author: Eternus Solutions
     * @Description: Test method to test the functionality of method "createApexTriggerMember()" with
     *               the following scenario: Passed third parameter triggerBody as invalid value 
     *               and metadataContainerId, triggerId, sessionId with valid values.
     * @Expected Result: Method should return false value.
     * @Date: 05/08/2016
     **/ 
    static testMethod void createApexTriggerMemberTestCase13() {
        createApexTriggerMemberTest('Valid', 'Valid', 'Invalid', 'Valid', false);
    }
    
    /** 
     * @Author: Eternus Solutions
     * @Description: Test method to test the functionality of method "createApexTriggerMember()" with
     *               the following scenario: Passed fourth parameter sessionId as null and metadataContainerId, triggerId,
     *               triggerBody with valid values.
     * @Expected Result: Method should return false value.
     * @Date: 05/08/2016
     **/ 
    static testMethod void createApexTriggerMemberTestCase14() {
        createApexTriggerMemberTest('Valid', 'Valid', 'Valid', null, false);
    }
    
    /** 
     * @Author: Eternus Solutions
     * @Description: Test method to test the functionality of method "createApexTriggerMember()" with
     *               the following scenario: Passed fourth parameter sessionId as blank and metadataContainerId, triggerId,
     *               triggerBody with valid values.
     * @Expected Result: Method should return false value.
     * @Date: 05/08/2016
     **/ 
    static testMethod void createApexTriggerMemberTestCase15() {
        createApexTriggerMemberTest('Valid', 'Valid', 'Valid', '', false);
    }
    
    /** 
     * @Author: Eternus Solutions
     * @Description: Test method to test the functionality of method "createApexTriggerMember()" with
     *               the following scenario: Passed fourth parameter sessionId as invalid value 
     *               and metadataContainerId, triggerId, triggerBody with valid values.
     * @Expected Result: Method should return false value.
     * @Date: 05/08/2016
     **/ 
    static testMethod void createApexTriggerMemberTestCase16() {
        createApexTriggerMemberTest('Valid', 'Valid', 'Valid', 'Invalid', false);
    }
    
    /** 
     * @Author: Eternus Solutions
     * @Description: Test method to test the functionality of method "createContainerAsyncRequest()" with
     *               the following scenario: Passed all parameters metadataContainerId, sessionId with valid values.
     * @Expected Result: Method should return true value.
     * @Date: 05/08/2016
     **/ 
    static testMethod void createContainerAsyncRequestTestCase1() {
        createContainerAsyncRequestTest('Valid', 'Valid', true);
    }
    
    /** 
     * @Author: Eternus Solutions
     * @Description: Test method to test the functionality of method "createContainerAsyncRequest()" with
     *               the following scenario: Passed first param metadataContainerId as valid and second
     *               param sessionId with invalid value.
     * @Expected Result: Method should return false value.
     * @Date: 05/08/2016
     **/ 
    static testMethod void createContainerAsyncRequestTestCase2() {
        createContainerAsyncRequestTest('valid', 'Invalid', false);
    }
    
    /** 
     * @Author: Eternus Solutions
     * @Description: Test method to test the functionality of method "createContainerAsyncRequest()" with
     *               the following scenario: Passed first param metadataContainerId as valid and second
     *               param sessionId as null value.
     * @Expected Result: Method should return false value.
     * @Date: 05/08/2016
     **/ 
    static testMethod void createContainerAsyncRequestTestCase3() {
        createContainerAsyncRequestTest('Valid', null, false);
    }
    
    /** 
     * @Author: Eternus Solutions
     * @Description: Test method to test the functionality of method "createContainerAsyncRequest()" with
     *               the following scenario: Passed first param metadataContainerId as valid and second
     *               param sessionId as blank value.
     * @Expected Result: Method should return false value.
     * @Date: 05/08/2016
     **/ 
    static testMethod void createContainerAsyncRequestTestCase4() {
        createContainerAsyncRequestTest('Valid', '', false);
    }
    
    /** 
     * @Author: Eternus Solutions
     * @Description: Test method to test the functionality of method "createContainerAsyncRequest()" with
     *               the following scenario: Passed first param metadataContainerId as Invalid value and 
     *               second param sessionId as valid value.
     * @Expected Result: Method should return false value.
     * @Date: 05/08/2016
     **/ 
    static testMethod void createContainerAsyncRequestTestCase5() {
        createContainerAsyncRequestTest('Invalid', 'Valid', false);
    }
    
    /** 
     * @Author: Eternus Solutions
     * @Description: Test method to test the functionality of method "createContainerAsyncRequest()" with
     *               the following scenario: Passed first param metadataContainerId with Invalid value and 
     *               second param sessionId  as Invalid.
     * @Expected Result: Method should return false value.
     * @Date: 05/08/2016
     **/ 
    static testMethod void createContainerAsyncRequestTestCase6() {
        createContainerAsyncRequestTest('Invalid', 'Invalid', false);
    }
    
    /** 
     * @Author: Eternus Solutions
     * @Description: Test method to test the functionality of method "createContainerAsyncRequest()" with
     *               the following scenario: Passed first param metadataContainerId with Invalid value and 
     *               second param sessionId as null value.
     * @Expected Result: Method should return false value.
     * @Date: 05/08/2016
     **/ 
    static testMethod void createContainerAsyncRequestTestCase7() {
        createContainerAsyncRequestTest('Invalid', null, false);
    }
    
    /** 
     * @Author: Eternus Solutions
     * @Description: Test method to test the functionality of method "createContainerAsyncRequest()" with
     *               the following scenario: Passed first param metadataContainerId with Invalid value and 
     *               second param sessionId as blank value.
     * @Expected Result: Method should return false value.
     * @Date: 05/08/2016
     **/ 
    static testMethod void createContainerAsyncRequestTestCase8() {
        createContainerAsyncRequestTest('Invalid', '', false);
    }
    
    /** 
     * @Author: Eternus Solutions
     * @Description: Test method to test the functionality of method "createContainerAsyncRequest()" with
     *               the following scenario: Passed first param metadataContainerId as null and 
     *               second param sessionId as valid value.
     * @Expected Result: Method should return false value.
     * @Date: 05/08/2016
     **/ 
    static testMethod void createContainerAsyncRequestTestCase9() {
        createContainerAsyncRequestTest(null, 'valid', false);
    }
    
    /** 
     * @Author: Eternus Solutions
     * @Description: Test method to test the functionality of method "createContainerAsyncRequest()" with
     *               the following scenario: Passed first param metadataContainerId as null and 
     *               second param sessionId as invalid value.
     * @Expected Result: Method should return false value.
     * @Date: 05/08/2016
     **/ 
    static testMethod void createContainerAsyncRequestTestCase10() {
        createContainerAsyncRequestTest(null, 'invalid', false);
    }
    
    /** 
     * @Author: Eternus Solutions
     * @Description: Test method to test the functionality of method "createContainerAsyncRequest()" with
     *               the following scenario: Passed first param metadataContainerId as null and 
     *               second param sessionId as null.
     * @Expected Result: Method should return false value.
     * @Date: 05/08/2016
     **/ 
    static testMethod void createContainerAsyncRequestTestCase11() {
        createContainerAsyncRequestTest(null, null, false);
    }
    
    /** 
     * @Author: Eternus Solutions
     * @Description: Test method to test the functionality of method "createContainerAsyncRequest()" with
     *               the following scenario: Passed first param metadataContainerId as null and 
     *               second param sessionId as blank.
     * @Expected Result: Method should return false value.
     * @Date: 05/08/2016
     **/ 
    static testMethod void createContainerAsyncRequestTestCase12() {
        createContainerAsyncRequestTest(null, '', false);
    }
    
    /** 
     * @Author: Eternus Solutions
     * @Description: Test method to test the functionality of method "createContainerAsyncRequest()" with
     *               the following scenario: Passed first param metadataContainerId as blank and 
     *               second param sessionId as valid value.
     * @Expected Result: Method should return false value.
     * @Date: 05/08/2016
     **/ 
    static testMethod void createContainerAsyncRequestTestCase13() {
        createContainerAsyncRequestTest('', 'Valid', false);
    }
    
    /** 
     * @Author: Eternus Solutions
     * @Description: Test method to test the functionality of method "createContainerAsyncRequest()" with
     *               the following scenario: Passed first param metadataContainerId as blank and 
     *               second param sessionId as Invalid value.
     * @Expected Result: Method should return false value.
     * @Date: 05/08/2016
     **/ 
    static testMethod void createContainerAsyncRequestTestCase14() {
        createContainerAsyncRequestTest('', 'Invalid', false);
    }
    
    /** 
     * @Author: Eternus Solutions
     * @Description: Test method to test the functionality of method "createContainerAsyncRequest()" with
     *               the following scenario: Passed first param metadataContainerId as blank and 
     *               second param sessionId as null value.
     * @Expected Result: Method should return false value.
     * @Date: 05/08/2016
     **/ 
    static testMethod void createContainerAsyncRequestTestCase15() {
        createContainerAsyncRequestTest('', null, false);
    }
    
    /** 
     * @Author: Eternus Solutions
     * @Description: Test method to test the functionality of method "createContainerAsyncRequest()" with
     *               the following scenario: Passed first param metadataContainerId as blank and 
     *               second param sessionId as blank value.
     * @Expected Result: Method should return false value.
     * @Date: 05/08/2016
     **/ 
    static testMethod void createContainerAsyncRequestTestCase16() {
        createContainerAsyncRequestTest('', '', false);
    }
    
}