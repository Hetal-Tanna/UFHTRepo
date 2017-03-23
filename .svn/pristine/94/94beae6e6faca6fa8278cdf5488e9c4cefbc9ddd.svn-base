/**
  * Class Name: LicenseMgmtCalloutsMock 
  * @Description: Class for providing mock callouts for LMA requests
  * ====================================================================================================================
  *       Version   | Date        | Author             | Comments
  * --------------------------------------------------------------------------------------------------------------------
  *       1.0       | 01/02/2017  | Eternus Solutions  | 1.Initial Draft
  * ====================================================================================================================
  **/
@isTest
global class LicenseMgmtCalloutsMock implements HttpCalloutMock {
    
    // Endpoint URL constants
    static final String LOGIN_REQUEST_ENDPOINT = '/services/oauth2/token';
    static final String ENDPOINT_LICENSE_MANAGEMENT = LMSConstants.LMS_ENDPOINT;

    /**
     * @Author: Eternus Solutions
     * @Description: Implement the interface method
     * @Param: HttpRequest request
     * @Return: response
     * @Date: 01/02/2017
     **/
    global HttpResponse respond(HttpRequest req) {

        HttpResponse response = new HttpResponse();
        response.setStatus('OK');
        response.setStatusCode(200);

        // Check for the endpoint
        // If it is the LMA endpoint
        if (req.getEndpoint().containsIgnoreCase(ENDPOINT_LICENSE_MANAGEMENT)) {
            // Check for the method type
            if (req.getMethod().equalsIgnoreCase('GET')) {
                // If it is a GET request
                response.setBody(doGet());
            } else if (req.getMethod().equalsIgnoreCase('POST')) {
                // If it is a POST request
                response.setBody(doPost());
            }
        
        } else if (req.getEndpoint().containsIgnoreCase(LOGIN_REQUEST_ENDPOINT)) {
            response.setBody(doLogin());
        }
        system.assert(String.valueOf(response) != '','LicenseMgmtCalloutsMock.respond - Response is empty');
        system.assert(response.getStatus() == 'OK','LicenseMgmtCalloutsMock.respond - Response status not set as OK');
        // Return the response
        return response;

    }

    /**
     * @Author: Eternus Solutions
     * @Description: Method to provide response for login
     * @Param: none
     * @Return: serialized loginInfo
     * @Date: 01/02/2017
     **/
    static String doLogin() {
        LmaCommunicationManager.LoginInformation loginInfo = new LmaCommunicationManager.LoginInformation();
        loginInfo.token_type = 'Bearer';
        loginInfo.issued_at = '' + System.now();
        loginInfo.signature = '+Nbl5EOl/DlsvUZ4NbGDno6vn935XsWGVbwoKyXHayo=';
        loginInfo.access_token = 'TEST_ACCESS_TOKEN';
        loginInfo.instance_url = 'https://na1.salesforce.com';

        return JSON.serialize(loginInfo);
    }

    /**
     * @Author: Eternus Solutions
     * @Description:  Method to provide response for GET callout to LMA
     * @Param: isSuccess
     * @Return: serialized licenseInfo
     * @Date: 01/02/2017
     **/
    static String doGet(Boolean isSuccess) {
        LmaCommunicationManager.LicenseInformation licenseInfo
            = new LmaCommunicationManager.LicenseInformation();
        licenseInfo.status = isSuccess ? 'Active' : 'Expired';
        licenseInfo.expiryDate = String.valueOf(System.today().addDays(15));
        licenseInfo.licenseId = 'a06N000000BuEN3';
        licenseInfo.isValid = isSuccess;

        return JSON.serialize(licenseInfo);
    }

     /**
     * @Author: Eternus Solutions
     * @Description:  Method to provide response for GET callout to LMA
     * @Param: isSuccess
     * @Return: true
     * @Date: 01/02/2017
     **/
    static String doGet() {
        return doGet(true);
    }

    /**
     * @Author: Eternus Solutions
     * @Description: Method to provide response for POST callout to LMA
     * @Param: isSuccess
     * @Return: Serialized JSON updatedResponse
     * @Date: 01/02/2017
     **/
    static String doPost(Boolean isSuccess) {
        LmaCommunicationManager.LicenseUpdateResponse updateResponse
            = new LmaCommunicationManager.LicenseUpdateResponse();

        updateResponse.message = isSuccess ? null : 'Error';
        updateResponse.isSuccess = '' + isSuccess;
        updateResponse.licenseId = 'a06N000000BuEN3';

        return JSON.serialize(updateResponse);
    }

    // Method to provide response for POST callout to LMA
    static String doPost() {
        return doPost(true);
    }

}