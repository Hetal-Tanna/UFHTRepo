@isTest(SeeAllData=true)
public class UFHTContactTest {
testmethod static void dynamicTriggerGenenratorTest() {
Integer retryCount = 0;
 String recordUpdateFailError;
list<sObject> objList = Database.query('SELECT Id FROM Contact ORDER BY Id DESC LIMIT 1');
if(!objList.isEmpty() && objList[0] != null) {
do {
try {
recordUpdateFailError = '';
retryCount ++;
update objList[0];
break; 
}
catch(Exception ex) {
 recordUpdateFailError = ex.getMessage(); 
 }
} while(retryCount < 3);
if(retryCount == 3 && String.isNotBlank(recordUpdateFailError)) {
throw new UFHT.UFHTExceptions.DynamicTestClassCreationFailException('Test class creation fails for '+ objList[0].Id + 'due to '+ recordUpdateFailError);
}
else {
System.assert(objList[0].Id != null);
}
}else {throw new UFHT.UFHTExceptions.DynamicTestClassCreationFailException('No Record found for selected object to create test class.');
}
}
}