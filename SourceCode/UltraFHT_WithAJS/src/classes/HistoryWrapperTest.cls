/**
 * @Class Name: HistoryWrapperTest
 * @Description: Test class for HistoryWrapper class. 
 * ========================================================================================================================
 *       Version   | Date        | Author             | Comments
 * -------------------------------------------------------------------------------------------------------------------------
 *       1.0       | 15-11-2015  | Eternus Solution   | 1.Created the class.
 * ========================================================================================================================
 **/

@isTest
private class HistoryWrapperTest {
    
     /** 
     * @Author: Eternus Solutions
     * @description: History wrapper test
     * Expected Result: Method should assign values to all variables of class.
     * @Date: 26-02-2016
     */ 
     static testMethod void historyTestCase1() {
        
      list<HistoryWrapper> historyList = new list<HistoryWrapper>();
      Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
      User u = TestDataFactory.getUser('User1', 'user1', 'test@user1.come', p.Id );
        
        
        Account accountObj = TestDataFactory.getAccount('TestAccount');
        insert accountObj;
        
        system.runAs(u) {
            
            test.startTest();
            historyList.addAll(TestDataFactory.getHistoryList(new list<string> {'2'},
                                                              new list<string> {'5'},
                                                              string.ValueOf(accountObj.Id),
                                                              UserInfo.getProfileId(),
                                                              new list<DateTime> {DateTime.newInstance(2016, 02, 26, 20, 45, 00)}
                                                              )
                              );
            test.stopTest();
        }
        system.assertEquals(1, historyList.size());
        system.assertEquals('2', historyList[0].oldValue);
        system.assertEquals('5', historyList[0].newValue);
        system.assertEquals(p.Id, historyList[0].ModifiedById);
        system.assertEquals('02/27/2016 04:45:00', historyList[0].ModifiedDateTime);
        system.assertEquals(string.ValueOf(accountObj.Id), historyList[0].parentID);

    }
    
     /** 
     * @Author: Eternus Solutions
     * @description: History wrapper sort test
     * Expected Result: Method should history wrapper record in descending order of ModifiedDatetime.
     * @Date: 26-02-2016
     */
     static testMethod void historySortTestCase2() {
        
      list<HistoryWrapper> historyList = new list<HistoryWrapper>();
      Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
      User u = TestDataFactory.getUser('User2', 'user2', 'test@user2.come', p.Id );
        
        
        Account accountObj = TestDataFactory.getAccount('TestAccount');
        insert accountObj;
        
        system.runAs(u) {
            
            test.startTest();
            historyList.addAll(TestDataFactory.getHistoryList(new list<string> {'2','3','4'},
                                                              new list<string> {'5','6','7'},
                                                              string.ValueOf(accountObj.Id),
                                                              UserInfo.getProfileId(),
                                                              new list<DateTime> {DateTime.newInstance(2016, 02, 26, 20, 45, 00), 
                                                                                  DateTime.newInstance(2016, 02, 27, 20, 45, 00),
                                                                                  DateTime.newInstance(2016, 02, 28, 20, 45, 00)}
                                                              )
                              );
            historyList.sort();
            test.stopTest();
            
            system.assertEquals('02/29/2016 04:45:00', historyList[0].ModifiedDateTime);
            system.assertEquals('02/28/2016 04:45:00', historyList[1].ModifiedDateTime);
            system.assertEquals('02/27/2016 04:45:00', historyList[2].ModifiedDateTime);
            
        }
        
    }
    
    /** 
     * @Author: Eternus Solutions
     * @description: History wrapper sort test
     * Expected Result: Method should history wrapper record in descending order of ModifiedDatetime.
     * @Date: 26-02-2016
     */
    static testMethod void historySortTestCase3() {
        
      list<HistoryWrapper> historyList = new list<HistoryWrapper>();
      Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
      User u = TestDataFactory.getUser('User2', 'user2', 'test@user2.come', p.Id );
        
        
        Account accountObj = TestDataFactory.getAccount('TestAccount');
        insert accountObj;
        
        system.runAs(u) {
            
            test.startTest();
            historyList.addAll(TestDataFactory.getHistoryList(new list<string> {'2','3','4'},
                                                              new list<string> {'5','6','7'},
                                                              string.ValueOf(accountObj.Id),
                                                              UserInfo.getProfileId(),
                                                              new list<DateTime> {DateTime.newInstance(2016, 02, 28, 20, 45, 00),
                                                                                  DateTime.newInstance(2016, 02, 26, 20, 45, 00), 
                                                                                  DateTime.newInstance(2016, 02, 27, 20, 45, 00)
                                                                                  }
                                                              )
                              );
            historyList.sort();
            test.stopTest();
            
            system.assertEquals('02/29/2016 04:45:00', historyList[0].ModifiedDateTime);
            system.assertEquals('02/28/2016 04:45:00', historyList[1].ModifiedDateTime);
            system.assertEquals('02/27/2016 04:45:00', historyList[2].ModifiedDateTime);
            
        }
        
    }
    
}