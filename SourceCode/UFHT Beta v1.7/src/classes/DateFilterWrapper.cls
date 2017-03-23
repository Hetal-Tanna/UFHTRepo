/* @Class Name: DateFilterWrapper
 * @Description: This is the wrapper class used to store date filters and to sort date filters on basis on serial number.
 * ========================================================================================================================
 *       Version   | Date        | Author             | Comments
 * ------------------------------------------------------------------------------------------------------------------------
 *       1.0       | 13/11/2015  | Eternus Solution   | 1. Created the class to store date filters and 
 *                                                         to sort date filters on basis on serial number.
 * ========================================================================================================================
 **/

public with sharing class DateFilterWrapper implements Comparable {

        public Integer srNo { get; set; }
        public String name { get; set; }

        public DateFilterWrapper(Integer srNo, String name) {

            this.srNo = srNo != null ? srNo : 0;
            this.name = String.isBlank(name) ? UFHTConstants.EMPTY_STRING : name;

        }

        /**
         * @Author: Eternus Solutions
         * @Description: Method to sort wrapper records base on serial number.
         * @Param: compareToObj object for wrapper to compare
         * @Return: Return If its greater than current instance then it will return -1
         *          If its smaller than current instance then it will return 1
         *          If both are equal then it will return 0
         * @Date: 13/11/2015
         **/
        public Integer compareTo(Object compareToObj) {

            Integer returnValue = 0;

            if(compareToObj != null) {

                DateFilterWrapper dateWrapperObj = (DateFilterWrapper)compareToObj;
                returnValue = (this.srNo < dateWrapperObj.srNo) 
                            ? -1 
                            : (this.srNo == dateWrapperObj.srNo 
                                ? 0
                                : 1);

            }
            else {

                returnValue = -1;

            }
            return returnValue;
        }
    }