/**
  * @Class Name: PostUninstallUtil
  * @Description: This class creates the data after installing the package.
  * ======================================================================================================
  *         Version   | Date        | Author             | Comments
  * ------------------------------------------------------------------------------------------------------
  *         1.0       | 27/02/2017  | Eternus Solutions  | 1. Created the class to create
  *                                                           data after installing the package.
  * =======================================================================================================
  **/
global with sharing class PostUninstallUtil implements UninstallHandler  {
    global void onUninstall(UninstallContext  context) {
        if(context != null) {
            LMSConfigManager.onUninstall(); 
        }
    }
}