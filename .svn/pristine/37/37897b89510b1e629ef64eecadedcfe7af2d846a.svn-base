/* @Class Name: DynamicTriggerGeneratorTest
 * @Description: Test class for DynamicTriggerGenerator class.
 * ========================================================================================================================
 *       Version   | Date        | Author             | Comments
 * -------------------------------------------------------------------------------------------------------------------------
 *       1.0       | 1-3-2016    | Eternus Solution     | 1.Created the class
 * ========================================================================================================================
 **/
@isTest
private class DynamicTriggerGeneratorTest {
    
    /** 
     * @Author: Eternus Solutions
     * @description: checkTriggerExistOrNot test
     *               pass triggerName which are already present in org.
     * Expected Result: Method should check if trigger if already present or not.
     * @Date: 1-03-2016
     */ 
    static testMethod void checkTriggerExistOrNotTestCase1() {
        
        test.startTest();
        boolean triggerExistOrNot = DynamicTriggerGenerator.checkTriggerExistOrNot('UltraTrackContainerTrigger');
        test.stopTest();
        
        system.assertEquals(true, triggerExistOrNot);
    }
    
    /** 
     * @Author: Eternus Solutions
     * @description: checkTriggerExistOrNot test
     *               pass triggerName which are not present in org.
     * Expected Result: Method should check if trigger if already present or not.
     * @Date: 1-03-2016
     */ 
    static testMethod void checkTriggerExistOrNotTestCase2() {
        
        test.startTest();
        boolean triggerExistOrNot = DynamicTriggerGenerator.checkTriggerExistOrNot('abc');
        test.stopTest();
        
        system.assertEquals(false, triggerExistOrNot);
    }
    
    /** 
     * @Author: Eternus Solutions
     * @description: generateDynamicTrigger test
     *               pass triggerName which are already present in org.
     * Expected Result: Method should check if trigger is created or not.
     * @Date: 1-03-2016
     */ 
    static testMethod void generateDynamicTriggerTestCase1() {
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseDyanamicTriggerGenrator());
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = TestDataFactory.getUser('User1', 'user1', 'test@user1.come', p.Id );
        
        system.runAs(u) {
            test.startTest();
            DynamicTriggerGenerator.generateDynamicTrigger('Account', UserInfo.getSessionId());
            test.stopTest();
        }
    }
    
    /** 
     * @Author: Eternus Solutions
     * @description: generateDynamicTrigger test
     *               pass triggerName which are not present in org.
     * Expected Result: Method should check if trigger is created or not.
     * @Date: 1-03-2016
     */ 
    static testMethod void generateDynamicTriggerTestCase2() {
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseDyanamicTriggerGenrator());
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = TestDataFactory.getUser('User2', 'user2', 'test@user212.com', p.Id );
        
        system.runAs(u) {
            test.startTest();
            DynamicTriggerGenerator.generateDynamicTrigger('Product2', UserInfo.getSessionId());
            test.stopTest();
        }
            
    }
    
    /** 
     * @Author: Eternus Solutions
     * @description: createTrigger test
     *               pass triggerName and session id as null.
     * Expected Result: Method should check if trigger is created or not.
     * @Date: 1-03-2016
     */ 
    static testMethod void createTriggerTestCase1() {
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseDyanamicTriggerGenrator());
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = TestDataFactory.getUser('User1', 'user1', 'test@user1.come', p.Id );
        
        system.runAs(u) {
            test.startTest();
            DynamicTriggerGenerator.createTrigger(null, null);
            test.stopTest();
        }    
    }
}