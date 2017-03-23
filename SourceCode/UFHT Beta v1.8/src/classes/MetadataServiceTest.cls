/**
 * @Class Name: MetadataServiceTest 
 * @Description: Test Class for MetadataService class
 * ===================================================================================================
 *   Version   | Date        | Author             | Comments
 * ---------------------------------------------------------------------------------------------------
 *   1.0       | 15/11/2016  | Eternus Solutions  | 1. Created the class.
 * ===================================================================================================
**/
@isTest  
private class MetadataServiceTest {    
    /**
     * Dummy Metadata API web service mock class (see MetadataCreateJobTest.cls for a better example)
     **/
    private class WebServiceMockImpl implements WebServiceMock {
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
        
    @IsTest
    private static void coverGeneratedCodeCRUDOperations() {   
        // Null Web Service mock implementation
        System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        // Only required to workaround a current code coverage bug in the platform
        MetadataService metaDataService = new MetadataService();
        // Invoke operations         
        MetadataService.MetadataPort metaDataPort = new MetadataService.MetadataPort();
        System.assertEquals(URL.getSalesforceBaseUrl().toExternalForm() + '/services/Soap/m/37.0', metaDataPort.endpoint_x);
        System.assert(metaDataPort.outputHttpHeaders_x == null);
        System.assert(metaDataPort.clientCertName_x == null);
        System.assert(metaDataPort.clientCert_x == null);
        System.assert(metaDataPort.clientCertPasswd_x == null);
        System.assert(metaDataPort.timeout_x == null);
        System.assert(metaDataPort.SessionHeader == null);
    }
    
    @IsTest
    private static void coverGeneratedCodeFileBasedOperations1() {       
        // Null Web Service mock implementation
        System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        // Only required to workaround a current code coverage bug in the platform
        MetadataService metaDataService = new MetadataService();
        // Invoke operations         
        MetadataService.MetadataPort metaDataPort = new MetadataService.MetadataPort();
        
        MetadataService.checkDeployStatusResponse_element response_x = new MetadataService.checkDeployStatusResponse_element();
        MetadataService.deployResponse_element response_x2 = new MetadataService.deployResponse_element();
       // metaDataPort.retrieve(null);
        response_x.result = metaDataPort.checkDeployStatus(null, false);
        
        System.assertEquals(null, response_x.result);
        
        response_x2.result = metaDataPort.deploy(null, null);
        
        System.assertEquals(null, response_x2.result);
        
        response_x.result = metaDataPort.checkDeployStatus(null, false);
        System.assertEquals(null, response_x.result);
    }

    @IsTest
    private static void coverGeneratedCodeTypes() {              
        // Reference types
        new MetadataService();
        
        MetadataService.checkDeployStatus_element checkStatsDeployObj = new MetadataService.checkDeployStatus_element();
        System.assert(checkStatsDeployObj.asyncProcessId == null);
        
        MetadataService.CodeCoverageWarning codeWarningObj = new MetadataService.CodeCoverageWarning();
        System.assert(codeWarningObj.id == null);
        System.assert(codeWarningObj.name == null);
        System.assert(codeWarningObj.message == null);
        
        MetadataService.AsyncResult asyncResultObj = new MetadataService.AsyncResult();
        System.assert(asyncResultObj.id == null);
        System.assert(asyncResultObj.message == null);
        System.assert(asyncResultObj.done == null);
        
        MetadataService.RunTestFailure runTestFailObj = new MetadataService.RunTestFailure();
        System.assert(runTestFailObj.id == null);
        System.assert(runTestFailObj.name == null);
        System.assert(runTestFailObj.message == null);

        MetadataService.SessionHeader_element sessionHeaderObj = new MetadataService.SessionHeader_element();
        System.assert(sessionHeaderObj.sessionId == null);
        
        MetadataService.DeployOptions deployOptionsObj = new MetadataService.DeployOptions();
        System.assert(deployOptionsObj.allowMissingFiles == null);
        System.assert(deployOptionsObj.autoUpdatePackage == null);
        System.assert(deployOptionsObj.checkOnly == null);
        System.assert(deployOptionsObj.ignoreWarnings == null);
            
        MetadataService.deploy_element deployEleObj = new MetadataService.deploy_element();
        System.assert(deployEleObj.ZipFile == null);
        
        MetadataService.DeployResult deployResultObj = new MetadataService.DeployResult();
        System.assert(deployResultObj.canceledBy == null);
        System.assert(deployResultObj.canceledByName == null);
        System.assert(deployResultObj.checkOnly == null);
        System.assert(deployResultObj.completedDate == null);
        
        MetadataService.DeployDetails deployDetailsObj = new MetadataService.DeployDetails();
        System.assert(deployDetailsObj.componentFailures == null);
        System.assert(deployDetailsObj.componentSuccesses == null);
        System.assert(deployDetailsObj.runTestResult == null);
    }
}