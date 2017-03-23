/**
 * @Class Name: UserInfoWrapper
 * @Description: This is wrapper class used to display User records in View Data page.
 * =================================================================================================
 *       Version   | Date        | Author             | Comments
 * -------------------------------------------------------------------------------------------------
 *       1.0       | 19/01/2017  | Eternus Solutions   | 1. Created class with constructor.
 * =================================================================================================
 **/
 
public with sharing class UserInfoWrapper {
    
    public Id userId;
    public String userName;
    
    public UserInfoWrapper(Id userId,
                           String userName) {
        this.userId = userId;

        this.userName = String.isNotBlank(userName) ? userName : UFHTConstants.WHITE_SPACE;
    }
}