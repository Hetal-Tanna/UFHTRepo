@isTest
global class MockHttpResponseForSetupController implements HttpCalloutMock {

    global HTTPResponse respond(HTTPRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"encoding" : "UTF-8","maxBatchSize" : 200,"sobjects" : [ {"activateable" : false,"createable" : true,"custom" : false,"customSetting" : false,"deletable" : true,"deprecatedAndHidden" : false,"feedEnabled" : true,"keyPrefix" : "001","label" : "Account","labelPlural" : "Accounts","layoutable" : true,"mergeable" : true,"name" : "Account","queryable" : true,"replicateable" : true,"retrieveable" : true,"searchable" : true,"triggerable" : true,"undeletable" : true,"updateable" : true,"urls" : {"compactLayouts" : "/services/data/v34.0/sobjects/Account/describe/compactLayouts","rowTemplate" : "/services/data/v34.0/sobjects/Account/{ID}","approvalLayouts" : "/services/data/v34.0/sobjects/Account/describe/approvalLayouts","listviews" : "/services/data/v34.0/sobjects/Account/listviews","describe" : "/services/data/v34.0/sobjects/Account/describe","quickActions" : "/services/data/v34.0/sobjects/Account/quickActions","layouts" : "/services/data/v34.0/sobjects/Account/describe/layouts","sobject" : "/services/data/v34.0/sobjects/Account"}}]}');
        res.setStatusCode(200);
        return res;
    }
}