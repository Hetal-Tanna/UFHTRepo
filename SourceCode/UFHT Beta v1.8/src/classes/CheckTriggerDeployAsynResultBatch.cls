global class CheckTriggerDeployAsynResultBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {
    
    String objectName;
    String deploymentErrorMessage = '';
    Boolean isDeployed;
    String sessionId;
    global CheckTriggerDeployAsynResultBatch(String objectName, String sessionId) {
        this.objectName = objectName;
        this.sessionId = sessionId;
    }
    global Database.QueryLocator start(Database.BatchableContext BC){
       return Database.getQueryLocator('SELECT Id' + 
                                        ' FROM Ultra_Track_Container__c' + 
                                        ' WHERE Object_Name__c = : objectName');
    }
    global void execute(Database.BatchableContext BC, List<UFHT__Ultra_Track_Container__c> scope) {
        
      /*  system.debug('I am executing---');
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = UserInfo.getSessionId();
        MetadataService.DeployResult deployResult = service.checkDeployStatus(scope[0].UFHT__AsynResult_Id__c, true);
        
        do {
            if(deployResult.done) {
                
                System.debug('Deployment complete');
                System.debug('Deployment complete:--'+ deployResult.details);
                if(deployResult.details!= null && deployResult.details.componentFailures != null) {
                    for(MetadataService.DeployMessage deployMessage : deployResult.details.componentFailures) {
                        if(deployMessage.problem != null) {
                            
                            deploymentErrorMessage += deployMessage.fileName +
                                                     ' (Line: ' + deployMessage.lineNumber + ': Column:' + deployMessage.columnNumber + ') : ' +
                                                     deployMessage.problem;
                            System.debug('Errror---: '+ deploymentErrorMessage);
                        }
                    }
                }
                else if(deployResult.details!= null && deployResult.details.runTestResult != null && 
                        deployResult.details.runTestResult.codeCoverageWarnings != null) {
                     for(MetadataService.CodeCoverageWarning CodeCoveragMessage : deployResult.details.runTestResult.codeCoverageWarnings) {
                        if(CodeCoveragMessage.message != null) {
                            deploymentErrorMessage += CodeCoveragMessage.message;
                            System.debug('Errror---: '+ deploymentErrorMessage);
                        }
                        
                     }
                }
                isDeployed = true;
            }
            else {
                isDeployed = false;
                 System.debug('Deployment inprocess');
            }
        } while(!isDeployed && Limits.getLimitCpuTime() < Limits.getCpuTime());*/
        
        
    }

   global void finish(Database.BatchableContext BC) {
    
        /*if(isDeployed && String.isBlank(deploymentErrorMessage)) {
           System.debug('Success Deployed---:');
           
        }
        else if(isDeployed && String.isNotBlank(deploymentErrorMessage)){
             System.debug('Errrroorrr---:');
             
        }
        else if(!isDeployed){
            
            //Database.executeBatch(new CheckTriggerDeployAsynResultBatch(objectName));
        }*/
   }
}