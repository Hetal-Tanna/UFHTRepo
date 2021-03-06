@isTest(SeeAllData=true)
public class UFHTCaseTest {
testmethod static void dynamicTriggerGenenratorTest() {
Integer retryCount = 0;
 String recordUpdateFailError;
list<sObject> objList = Database.query('SELECT Id FROM Case ORDER BY Id DESC LIMIT 1');
if(!objList.isEmpty() && objList[0] != null) {
do {
try {
recordUpdateFailError = '';
retryCount ++;
update objList[0];
break; 
}
catch(DMLException ex) {
 recordUpdateFailError = ex.getDmlMessage(0); 
 }
} while(retryCount < 3);
if(retryCount == 3 && String.isNotBlank(recordUpdateFailError)) {
throw new UFHT.UFHTExceptions.DynamicTestClassCreationFailException('Please modify the data for specified record to comply with the mentioned validation: '+ recordUpdateFailError + '. Click <a href="/' + objList[0].Id + '"' + ' target=\'_balnk \'>here</a> to edit the record.');
}
else {
System.assert(objList[0].Id != null);
}
}else {throw new UFHT.UFHTExceptions.DynamicTestClassCreationFailException('No Record found for selected object to create test class.');
}
}
}