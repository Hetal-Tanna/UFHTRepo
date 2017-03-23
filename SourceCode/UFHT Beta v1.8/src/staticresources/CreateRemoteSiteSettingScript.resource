/**
 * @Resource Name: CreateRemoteSiteSettingScript.js
 * @Description: This file is used in CreateRemoteSiteSetting.page
 * =========================================================================================================================
 *       Version   | Date        | Author              | Comments
 * -------------------------------------------------------------------------------------------------------------------------
 *       1.0       | 13/11/2015  | Eternus Solutions   | 1. Created static resource for accessing java script functions in 
															visual force page CreateRemoteSiteSetting.
 *       1.1       | 17/11/2015  | Eternus Solutions   | 1. Added addRemoteSiteSetting() function.
 *       1.2       | 29/07/2016  | Eternus Solutions   | 1. Added method level logs and comments.
 * ==========================================================================================================================
 **/
  
/**
  *@Description: Method to create remote site setting after installation of package.
  *@Param: 1. remoteSiteName: Name of remote site setting.
  *        2. url: Salesforce base url.
  *        3. calloutUrl: Callout url.
  *        4. sessionId:  Session Id of User.
  *@Return: NA
  *@Date: 13/05/2016
  **/ 
function addRemoteSiteSetting(remoteSiteName1, remoteSiteName2, url, calloutUrl, sessionId, successMsg){
        var binding = new XMLHttpRequest();
        var request =
         '<?xml version="1.0" encoding="utf-8"?>' +
         '<env:Envelope xmlns:env="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'+
             '<env:Header>' +
                 '<urn:SessionHeader xmlns:urn="http://soap.sforce.com/2006/04/metadata">' +
                     '<urn:sessionId>'+sessionId+'</urn:sessionId>' +
                 '</urn:SessionHeader>' +
             '</env:Header>' +
             '<env:Body>' +
                 '<createMetadata xmlns="http://soap.sforce.com/2006/04/metadata">' +
                     '<metadata xsi:type="RemoteSiteSetting">' +
                         '<fullName>' + remoteSiteName2 +'</fullName>' +
                         '<description>Metadata API Remote Site Setting for UFHT </description>' +
                         '<disableProtocolSecurity>false</disableProtocolSecurity>' +
                         '<isActive>true</isActive>' +
                         '<url>https://'+url+'</url>' +
                     '</metadata>' +
					  '<metadata xsi:type="RemoteSiteSetting">' +
                         '<fullName>' + remoteSiteName1 +'</fullName>' +
                         '<description>Metadata API Remote Site Setting for UFHT </description>' +
                         '<disableProtocolSecurity>false</disableProtocolSecurity>' +
                         '<isActive>true</isActive>' +
                         '<url>https://'+calloutUrl+'</url>' +
                     '</metadata>' +
                 '</createMetadata>' +
             '</env:Body>' +
         '</env:Envelope>';
       binding.open('POST', 'https://'+calloutUrl+'/services/Soap/m/31.0',true);
       binding.setRequestHeader('SOAPAction','""');
       
       binding.setRequestHeader('Content-Type', 'text/xml');
       binding.onreadystatechange =
         function() {
             if(this.readyState==4) {
                 var parser = new DOMParser();
                 var doc  = parser.parseFromString(this.response, 'application/xml');
                 var errors = doc.getElementsByTagName('errors');
                 var messageText = '';
                 for(var errorIdx = 0; errorIdx < errors.length; errorIdx++)
                     messageText+= errors.item(errorIdx).getElementsByTagName('message').item(0).innerHTML + '\n';
					 
                 if(messageText != null && messageText != '') {
					if(messageText.includes('Remote Site Name already exists')) {
						document.getElementById('successOrErrorMessage').innerHTML  = successMsg;
					}
					else {
						document.getElementById('successOrErrorMessage').innerHTML  = messageText;
					}
                 }
                 else {
                    document.getElementById('successOrErrorMessage').innerHTML  = successMsg;
                 }
             }
         }
       binding.send(request);
}