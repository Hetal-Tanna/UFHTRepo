/**
 * Copyright (c) 2012, FinancialForce.com, inc
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification, 
 *   are permitted provided that the following conditions are met:
 *
 * - Redistributions of source code must retain the above copyright notice, 
 *      this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright notice, 
 *      this list of conditions and the following disclaimer in the documentation 
 *      and/or other materials provided with the distribution.
 * - Neither the name of the FinancialForce.com, inc nor the names of its contributors 
 *      may be used to endorse or promote products derived from this software without 
 *      specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
 *  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES 
 *  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL 
 *  THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, 
 *  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 *  OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 *  OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 *  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**/

/**
 * This is a dummy test class to obtain 100% coverage for the generated WSDL2Apex code, it is not a funcitonal test class
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
        new MetadataService.checkDeployStatus_element();
        new MetadataService.CodeCoverageWarning();
        new MetadataService.AsyncResult();
        new MetadataService.RunTestFailure();
        new MetadataService.Metadata();
        new MetadataService.SessionHeader_element();
        new MetadataService.DeployOptions();
        new MetadataService.ApexTrigger();
        new MetadataService.deploy_element();
        new MetadataService.DeployResult();
        new MetadataService.DeployDetails();
    }
}