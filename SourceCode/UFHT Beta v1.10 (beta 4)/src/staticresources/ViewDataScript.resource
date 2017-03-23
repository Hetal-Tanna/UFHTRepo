    /**
     * @Resource Name: ViewDataScript.js
     * @Description: This file is used in ViewData.page
     * ===============================================================================================================================
     *       Version   | Date        | Author              | Comments
     *   -----------------------------------------------------------------------------------------------------------------------------
     *       1.0       | 01/06/2016  | Eternus Solutions   | 1. Created static resource for getHistoryRecordsForObject,     
     *                                                          hideDateFormat, typewatch, checkDayValue and other functions.
     *       1.1       | 09/06/2016  | Eternus Solutions   | 1. Added validateDate() function.
     *       1.2       | 09/06/2016  | Eternus Solutions   | 1. Code review changes.
     *  ==============================================================================================================================
     **/
 
    /**
     * @Description: It sets value of selected object, start date and end date to fetch the history
     * @Param: NA
     * @Return: NA
     * @Date: 10/06/2016
     **/
    function getHistoryRecordsForObject() {
        selectedObj = $(".object option:selected").val();
        startDate =  $('.startDate').val();
        endDate = $('.endDate').val();
        selectedObjLabel = $(".object option:selected").text();
        $(".hiddenCls").removeClass("hiddenCls");
        angular.element(document.getElementById('displayHistoryRecord')).scope().getRecords();
    }

    /**
     * @Description: It hides standard date square bracket format with input date field. 
     * @Param: NA
     * @Return: NA
     * @Date: 12/06/2016
     **/
    function hideDateFormat() {
        $(".dateFormat").hide();
    }

    /**
     * @Description: It remove ascending and descending classes to passed DOM of the Table header element
     * @Param: elementId : Table header sorting Id
     * @Return: NA
     * @Date: 13/06/2016
     **/        
    var checkSort = function(elementId) {
        $(".scrollTable th .sort").each(function() {
            if (!($(this).attr("id") == elementId))
                $(this).removeClass("ascending descending");
        });
    }

    /**
     * @Description: It watches user key press in input field related to number of days and 
     *               apply delay (1 sec) till the user adds the input value
     * @Param: NA
     * @Return: NA
     * @Date: 16/06/2016
     **/
    var typewatch = function(){
        var timer = 0;
        return function(callback, ms){
            clearTimeout (timer);
            timer = setTimeout(callback, ms);
        }  
    }();
        
    /**
     * @Description: It evaluates valid or invalid value in number of days 
     * @Param: NA
     * @Return: NA
     * @Date: 18/06/2016
     **/    
    function checkDayValue() {
        if($(".TxtDays").val() == 0 || $(".TxtDays").val() > 1825){
            $("#DayError").html('Invalid Days');
            $(".showMoreButton").hide();
        }
        else{
             $("#DayError").html('');
             $(".showMoreButton").show();
            DateFileter();
        }
    }
      
    /**
     * @Description: It validates the start and end date 
     * @Param: flag: 
     * @Return: NA
     * @Date: 19/06/2016
     **/  
    function validateDate(flag) {
     
        var startDate = $('.startDate').val();
        var endDate = $('.endDate').val();
        var msgs1 = [];
        var msgs2 = [];
        var msgElement1 = $("#dateErrorMessageStartDateDiv");
        var msgElement2 = $("#dateErrorMessageEndDateDiv");
        msgElement1.html('');
        msgElement2.html('');
        $("#DayError").html('');
        if (startDate !== null && 
            startDate !== '' &&
            !isValidDate(startDate)) {
            msgs1.push('Invalid Start Date');
        }
        if (endDate !== null && 
            endDate !== '' && 
            !isValidDate(endDate)) {
            msgs2.push('Invalid End Date');
        }
        if (startDate !== null && 
            startDate !== '' && 
            endDate !== null &&
            endDate !== '' && 
            !msgs1.length &&
            !isValidRange(startDate, endDate)) {
            msgs1.push('Invalid Date Range');
        }
        if (msgs1.length) {
            var msgHtml = '';
            for (i = 0; i < msgs1.length; i++) {
                msgHtml += msgs1[i] + '</br>';
            }
            $(".showMoreButton").hide();
            msgElement1.html(msgHtml);
        }
        if (msgs2.length) {
            var msgHtml = '';
            for (i = 0; i < msgs2.length; i++) {
                msgHtml += msgs2[i] + '</br>';
            }
            msgElement2.html(msgHtml);
            $(".showMoreButton").hide();
        } else if (!msgs1.length && !msgs2.length) {
            if (flag === true) {
                
                DateFileter();
                if ($(".dateRange option:selected").val != 'Custom') {
                    checkIfSelectedFilterIsCustomOrNot();
                }
            }
            $(".showMoreButton").show();
            $(".FromToDate").show();
        } else {
            checkIfSelectedFilterIsCustomOrNot();
        }
        
    }
       
    /**
     * @Description: It checks the selected date range option is custom
     * @Param: NA
     * @Return: NA
     * @Date: 20/06/2016
     **/   
    function checkIfSelectedFilterIsCustomOrNot() {
        
        $(".dateRange option").each(function() {
             if (this.value == 'Custom') {
                 this.selected = true;
             }
        });
    }

    /**
     * @Description: It checks the date range is valid or not
     * @Param: startDate: Start Date
     *         endDate: End Date
     * @Return: NA
     * @Date: 20/06/2016
     **/
    function isValidRange(startDate, endDate) {

        var dateFormatArray = new Array();
        dateFormatArray.push(dateFormatVar);
        dateFormatArray.push(dateFormatVar.replace('DD', 'D').replace('MM', 'M'));
        if (moment(startDate, dateFormatArray, true).isValid() &&
        moment(endDate, dateFormatArray, true).isValid() && 
        moment(startDate, dateFormatArray) > moment(endDate, dateFormatArray)) {
            return false;
        }
        return true;
    }

    /**
     * @Description: It checks the date is valid or not
     * @Param: dateValue: Date Value 
     * @Return: NA
     * @Date: 20/06/2016
     **/
    function isValidDate(dateValue) {
        var dateFormatArray = new Array();
        dateFormatArray.push(dateFormatVar);
        dateFormatArray.push(dateFormatVar.replace('DD', 'D').replace('MM', 'M'));

        
        if(!moment(dateValue, dateFormatArray, true).isValid()) {
            return false;
        }
        return true;
    }

    /**
     * @Description: It clears the start and end date
     * @Param: NA   
     * @Return: NA
     * @Date: 20/06/2016
     **/
    function clearStartAndEndDate() {
        $("#noOfdays").blur();
		$('#noOfdays').val('30');
        $("#noOfdays").attr('disabled', true);		
        var startDate = $('.startDate').val();
        var endDate = $('.endDate').val();
        var dateFormatArray = new Array();
        dateFormatArray.push(dateFormatVar);
        dateFormatArray.push(dateFormatVar.replace('DD', 'D').replace('MM', 'M'));
        if(!moment(startDate, dateFormatArray, true).isValid() || !moment(endDate, dateFormatArray, true).isValid()) {
            $('.startDate').val("")
           $('.endDate').val("");
        }
    }

    /**
     * @Description: It displays dialogue popup
     * @Param: NA
     * @Return: NA
     * @Date: 20/06/2016
     **/
    function showPopup() {
        $("#dialog").dialog({
        modal: true,
        draggable: false,
        resizable: false,
        show: 'blind',
        hide: 'blind',
        width: 723,
        focus: function( event, ui ) {
            $('.ui-dialog-titlebar-close').removeClass('ui-state-focus');
            $('.ui-button.ui-widget.ui-state-default.ui-corner-all.ui-button-icon-only.ui-dialog-titlebar-close.ui-state-focus').css('outline','-webkit-focus-ring-color auto 0px');
        }
        });
        $("body").css("overflow-y", "hidden");
        $('.ui-widget-overlay').css('background', '#101010');
        $('.ui-button.ui-widget.ui-state-default.ui-corner-all.ui-button-icon-only.ui-dialog-titlebar-close.ui-state-focus').css('outline','-webkit-focus-ring-color auto 0px'); 
    }
	
	/**
     * @Description: It displays dialogue popup
     * @Param: NA
     * @Return: NA
     * @Date: 20/06/2016
     **/
    function showPopupForPdf() {
        $("#dialogPdf").dialog({
        modal: true,
        draggable: false,
        resizable: false,
        show: 'blind',
        hide: 'blind',
        width: 723,
        focus: function( event, ui ) {
            $('.ui-dialog-titlebar-close').removeClass('ui-state-focus');
            $('.ui-button.ui-widget.ui-state-default.ui-corner-all.ui-button-icon-only.ui-dialog-titlebar-close.ui-state-focus').css('outline','-webkit-focus-ring-color auto 0px');
        }
        });
        $("body").css("overflow-y", "hidden");
        $('.ui-widget-overlay').css('background', '#101010');
        $('.ui-button.ui-widget.ui-state-default.ui-corner-all.ui-button-icon-only.ui-dialog-titlebar-close.ui-state-focus').css('outline','-webkit-focus-ring-color auto 0px'); 
		
    }

    /**
     * @Description: It disables the date fields 
     * @Param: NA
     * @Return: NA
     * @Date: 25/06/2016
     **/
    function disableDateFields(){

        if ($(".dateRange option:selected").val() && $(".dateRange option:selected").val() != 'Custom') {
                $('.startDate').attr('disabled', true);
                $('.endDate').attr('disabled', true);
            } 
            else {
                $('.startDate').attr('disabled', false);
                $('.endDate').attr('disabled', false);
            }
            if ($(".dateRange option:selected").val() && $(".dateRange option:selected").val() == 'Last N Days') {
                $(".NumberOfDay").show();
                $(".TxtDays").attr('disabled', false);
                if($(".TxtDays").val()==0){
                    $(".TxtDays").val(30);
                }
            }
            else{
                $(".NumberOfDay").hide();
            }
    }
        

    /**
     * @Description: It is used to hide the dialog panel
     * @Param: NA
     * @Return: NA
     * @Date: 25/06/2016
     **/    
    function hideAndShow(){
        $('.DialogPanelClass').hide();
    }
       

    /**
     * @Description: It replaces the Image tag to anchor
     * @Param: str: String which has to be replaced to image tag
     * @Return: NA
     * @Date: 25/06/2016
     **/   
    function replaceImageTagwithAnchor(str){
        if (str != null || str!=undefined ){
            var urlPattern = /(http|ftp|https):\/\/[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:\/~+#-]*[\w@?^=%&amp;\/~+#-])?/gi;
            var imgArr=str.match("<img[^>]+><\/img>");
                while(imgArr!=null && imgArr.length>0){
                var href=imgArr[0].match(urlPattern)[0];
                var selected=str.substr(str.indexOf(imgArr[0]),imgArr[0].length);
                str = str.replace(selected,"<br/><a href='#' class='ImageClass'>Image:</a><a href='"+href+"' target='_blank' class='anchorClass'>"+href+"</a>");
                imgArr=str.match("<img[^>]+><\/img>");
            }                        
        }
        return str;

    }
       
    /**
     * @Description: It prevents to close filter section if clicked inside filter section 
     * @Param: isPropagate: Boolean to apply stop propagation when passed as true 
     * @Return: NA
     * @Date: 10/06/2016
     **/   
    function preventPropagation(isPropagate) {
        if(isPropagate) {
            $('.dropdown-menu').on('click.stopPropagation',function(event){
                event.stopPropagation();
            });
            $('.dropdown-menu').on('dblclick.stopPropagation',function(event){
                event.stopPropagation();
            });
        }
    }
        
    /**
     * @Description: It adds space in continuous words for word wrapping
     * @Param: value: Value in a cell
     *         threshold: Number of character size in a row of table cell in pdf
     * @Return: NA
     * @Date: 10/06/2016
     **/
    function addSpacesContineousWord(value,threshold)  { 
        var strArray = [];
        if(value.length > threshold) {
         var start=0;
         var last=0;  
         if(value == null || value == undefined || value == '') {
            return;
         }
         var splitArray = value.split(' ');
         for(var index =0;index<splitArray.length;index++) {
             if(splitArray[index].length>threshold) {
                 var start=0;
                 var last=0;
                 while(start<splitArray[index].length) {
                     if((start+threshold)>splitArray[index].length)  {
                         last = splitArray[index].length;
                     } else {
                         last =start+threshold;
                     }  
                     strArray.push(splitArray[index].slice(start,last));
                     start+=threshold;  
                 }
             }else{ 
                  strArray.push(splitArray[index]);
             }
         } 
         value='';
         for(index=0;index<strArray.length;index++){   
             strSlice = strArray[index];
             value =value+strSlice+' ';
          }      
        }
        return value;
    }
    
    /**
     * @Description: It checks if the key pressed is 'Enter', if yes prevents default submission of form
     * @Param: event: current keyboard event
     * @Return: NA
     * @Date: 17/01/2017
     **/
    function preventSubmission(event)  {
        if(event.code == "Enter") {
            event.preventDefault();
        }
    }
    
    /**
     * @Description: It navigates to view data tab
     * @Param: event: current keyboard event
     * @Return: NA
     * @Date: 31/01/2017
     **/
    function showMoreRecords() {
        console.log('>>> parentId : ',parentId);
        window.open(LabelViewTab_URL+'&rec='+parentId,'_blank');
    }
    
    /** 
      *Angular Js Code Starts
     **/
    
    /**
     * @Description: app variable defines the app for angular, controller method for the angular app
     * @Param: String name for Controller, actual controller function
     * @Return: NA
     * @Date: 04/06/2016
     **/
    var app = angular.module('myApp', [ "ngSanitize" ]);
    app
            .controller(
                    'fetchDataController',
                    function($scope, $timeout, $window) {
                    
                        $scope.CurrentDate = new Date().toLocaleString()
                                .split(',').join('');
                        $scope.toUTCDate = toUTCDate;
                        $scope.millisToUTCDate = millisToUTCDate;
                        $scope.pageSize = pageSize;
                        $scope.showLoader = true;
                        $scope.loadMoreData = false;
                        $scope.showMoreData = false;
                        $scope.noSelectedObject = false;
                        var i = 0;
                        $scope.reverse = true;
                        $scope.recordLimit;
                        $scope.previousSortField = '';
                        var attachmentCount = 0;
                        var offSet = 0;
                        $scope.noOfPages = 0;
                        $scope.currentPage = 0;
                        $scope.currentPagepdf = 0;
                        $scope.pageSizePdf = 10;
                        var baseUrl = salesforceBaseUrl;
                        $scope.fetchedHistoryData = [];
                        $scope.filteredHistoryData = [];
                        $scope.isDisplayFilter = false;
						$scope.isDisabled = false;
                        $scope.displayAppliedFilterIconRecordName = false;
                        $scope.displayAppliedFilterIconUserName = false;
                        $scope.displayAppliedFilterIconFieldName = false;
                        setInputData();
                        $scope.myFieldFilter = {
                            selected : {}
                        };
                        $scope.myRecordFilter = {
                            selected : {}
                        };
                        $scope.myUserFilter = {
                            selected : {}
                        };
                        $scope.searchStr = '';
                        $scope.allItems = [];
                        $scope.searchMenuData = [{name : LabelVD_SearchUser}, {name : LabelVD_SearchSeverity}, {name : LabelVD_SearchDataType}];
                        $scope.mySearchFilter = {
                            selected : {}
                        };
                        $scope.displayAppliedFilterIconDataTypeName = false;
                        $scope.myTypeFilter = {
                            selected : {}
                        };
                        $scope.displayAppliedFilterIconSeverityName = false;
                        $scope.mySeverityFilter = {
                            selected : {}
                        };
                        $scope.fetchedUserData = [];
                        $scope.dataTypeList = [];
                        $scope.selectedObj = '';
                        $scope.selectedObjLabel = '';
                        $scope.startDate = '';
                        $scope.endDate = '';
                        $scope.isURLParameterized = false;
                        $scope.sortKey = 'modifiedTime';
                        $scope.objKeyPrefix = '';
                        $scope.objParam = '';
                        $scope.isPartialRefresh = false;
						$scope.remotingMessage = '';
						$scope.showRemotingMessage = false;
						$scope.objectNameForRelatedList = relatedListObjectName;
						$scope.isDateRangeSelected = false;
						$scope.isValidLicense = isValidLicense;
						$scope.isSearchBLank = true;
                        if(isRelatedListFlag == true) {
                                $scope.objKeyPrefix = parentId.substring(0,3);
                            }
                        /**
                         * @Description: Escapes the quotea and converts them into html code
                         * @Param: String to be escaped
                         * @Return: NA
                         * @Date: 04/06/2016
                         **/
                        $scope.getHtml = function(html) {
                            if (html != null && html != undefined
                                    && html != '' && html.indexOf("'") >= 0) {
                                return html.split("'").join("&quot;");
                            }
                            return html;
                        };
                
                        /**
                         * @Description: Sets default values and invokes getNumberofAttachment
                         * @Param: NA
                         * @Return: NA
                         * @Date: 06/06/2016
                         **/
                        $scope.getRecords = function() {
                            
                            var parentrecordPrefix = '';
                            // if url contains param
                            if(($window.location.search.indexOf('rec') > -1)) {
                                var recIdstr = $window.location.search.split('&')[1];
                                parentrecordPrefix = recIdstr.substring(recIdstr.indexOf('=')+1, recIdstr.length);
                                parentrecordPrefix = parentrecordPrefix.substring(0,3);
                                $scope.objKeyPrefix = parentrecordPrefix;
                                $scope.selectedObj = selectedObj;
                                $scope.selectedObjLabel = selectedObjLabel;
                            }
                            else if(isRelatedListFlag == true) {
                                $scope.objKeyPrefix = parentId.substring(0,3);
                                $scope.selectedObj = '';
                                $scope.selectedObjLabel = '';
                            }
                            // else url does not contain param
                            else {
                                $scope.objKeyPrefix = '';
                                $scope.selectedObj = selectedObj;
                                $scope.selectedObjLabel = selectedObjLabel;
                            }
                            
                            $scope.startDate = startDate;
                            $scope.endDate = endDate;
                            $scope.searchStr = '';
                            offSet = 0;
                            $scope.fetchedHistoryData = [];
                            $scope.filteredHistoryData = [];
                            $scope.reverse = true;
                            $scope.recordLimit = false;
                            $scope.showMoreData = false;
							$scope.loadMoreData = false;                          
                            
							
                            $scope.noSelectedObject = false;
                            if($scope.isPartialRefresh == false) { 
								$scope.isDisplayFilter = false;
                                $scope.displayAppliedFilterIconRecordName = false;
                                $scope.displayAppliedFilterIconUserName = false;
                                $scope.displayAppliedFilterIconFieldName = false;
                                $scope.displayAppliedFilterIconSeverityName = false;
                                $scope.displayAppliedFilterIconDataTypeName = false;
                            }
                            if($(".dateRange option:selected").val() !=' ') {
                                $scope.isDateRangeSelected = true;
                            }
                            if (selectedObj.length == 1 && $scope.selectedObj != '') {
                                $scope.showLoader = true;
                                $scope.noSelectedObject = true;
                                $timeout(function(result) {
                                    $scope.showLoader = false;
                                }, 100);
                            } else {
                                $scope.getNumberofAttachment();
                            }
                            
                        };

						$scope.closeDialogPdf = function() {
							$("#dialogPdf").dialog("close");
							$("body").css("overflow-y", "visible");
							$scope.downloadPdf();
						}
						
						
                        /**
                         * @Description: Function for generating and downloading pdf
                         * @Param: NA
                         * @Return: NA
                         * @Date: 06/06/2016
                         **/
                        $scope.downloadPdf = function() {
							$scope.isDisabled = true;
                            var contentArray = [];
                            var displayHeader = [ {
                                text : LabelVD_RecordName,
                                style : 'header'
                            }, {
                                text : LabelVD_Modified_Field,
                                style : 'header'
                            }, {
                                text : LabelVD_Old_Value,
                                style : 'header'
                            }, {
                                text : LabelVD_New_Value,
                                style : 'header'
                            }, {
                                text : LabelVD_Modified_on,
                                style : 'header'
                            }, {
                                text : LabelVD_Modified_By,
                                style : 'header'
                            }, {
                                text : LabelVD_Datatype,
                                style : 'header'
                            }, {
                                text : LabelVD_Severity,
                                style : 'header'
                            }]
                            var headerArray = [ LabelVD_JsonRecordName,
                                                LabelVD_JsonfieldLabel,
                                                LabelVD_JsonoldValue,
                                                LabelVD_JsonnewValue,
												LabelVD_JsonModifiedDisplayTime,
												LabelVD_JsonModifiedByName,
                                                LabelVD_JsonFieldType,
                                                LabelVD_JsonFieldSeverity
                                                ];
                           /* angular
                                    .forEach(
                                            $scope.filteredHistoryData,
                                            function(obj) {
                                                var currentPage = 0;
                                                var threshold = 8;
                                                var rowArray = [];
                                                for (var index = 0; index < headerArray.length; index++) {
                                                    var value = angular
                                                            .equals(
                                                                    obj[headerArray[index]],
                                                                    null) ? ''
                                                            : obj[headerArray[index]];
                                                    if (value.length > threshold) {
                                                        value = addSpacesContineousWord(
                                                                value,
                                                                threshold);
                                                    }
                                                    rowArray.push(value);
                                                }
                                                contentArray.push(rowArray);
                                            });*/
                            for(i=0;i<$scope.filteredHistoryData.length;i++) {
												var currentPage = 0;
                                                var threshold = 8;
                                                var rowArray = [];
                                                for (var index = 0; index < headerArray.length; index++) {
                                                    var value = angular
                                                            .equals(
                                                                    $scope.filteredHistoryData[i][headerArray[index]],
                                                                    null) ? ''
                                                            : $scope.filteredHistoryData[i][headerArray[index]];
                                                    if (value.length > threshold) {
                                                        value = addSpacesContineousWord(
                                                                value,
                                                                threshold);
                                                    }
                                                    rowArray.push(value);
                                                }
                                                contentArray.push(rowArray);	
									/*if(i==5000){
										i = $scope.filteredHistoryData.length;	
									}*/	
							}
							//contentArray.unshift(displayHeader);
							if(selectedObjLabel == '') {
								var resultpdf = relatedListObjectName;
							} else {
							var resultpdf = selectedObjLabel.substring(0,
                                    selectedObjLabel.indexOf('('));
							}
							/*var docDefinition = {
                                
								
								
								footer : function(currentPagepdf,
                                        pageSizePdf) {
                                    return {
                                        columns : [
                                                {
                                                    text : LabelExported_by_Label+':'
                                                            + ' '+UserName
                                                            + ' '+LabelVD_on+' '
                                                            + $scope.CurrentDate
                                                            + ', '+LabelVD_powered_by+':',
                                                    fontSize : 9,
                                                    width : 'auto',
                                                    margin : [ 40, 0, 2, 0 ]
                                                },
                                                {
                                                    image : imageDisplay(),
                                                    width : 20,
                                                    height : 9,
                                                    margin : [ 0, 0, 0, 0 ]
                                                },
                                                {
                                                    text : LabelVD_company_name,
                                                    fontSize : 9,
                                                    width : 'auto',
                                                    margin : [ -7, 0, 0, 0 ]
                                                },
                                                {
                                                    text : LabelVD_page
                                                            + ' '
                                                            + currentPagepdf
                                                                    .toString()
                                                            + ' '+LabelVD_Of+' '
                                                            + pageSizePdf,
                                                    width : 'auto',
                                                    margin : [ PDFLeftMargin, 0, 0, 0 ],
                                                    fontSize : 9
                                                } ]
                                    }
                                },
                                content : [
                                        {
                                            text : '' + resultpdf
                                                    + LabelVD_Title,
                                            alignment : 'center',
                                            fontSize : 9,
                                            margin : [ 0, 0, 0, 10 ]
                                        },
                                        {
                                            table : {
                                                headerRows : 1,
                                                widths : [ '12.5%',
                                                        '12.5%', '12.5%',
                                                        '12.5%', '12.5%',
                                                        '12.5%', '12.5%',
                                                         '12.5%'],
                                                body : contentArray
                                            }
                                        } ],
                                styles : {
                                    header : {
                                        color : '#fff',
                                        fillColor : '#1fa5cd',
                                        fontSize : 11,                                        
                                        bold : true
                                    }
                                }
                            };
							
							pdfMake
											.createPdf(docDefinition)
											.download(
													''
															+ resultpdf
															+' Historical Data.pdf');
							*/								
															
                            start1 = 0;end1 = 1;
							records = 1000;// record rows  
							loopCount = (contentArray.length/records);
							if(contentArray.length%records!=0){
								loopCount = loopCount+1;
							}
							doc1 = [];
							for(var i=1;i<=loopCount;i++){
							//slice(start1*records,end1*records);
							
								contenArrayChunk = contentArray.slice(start1*records,end1*records);
								contenArrayChunk.unshift(displayHeader);
							
                            var docDefinition = {
                                
								
								footer : function(currentPagepdf,
                                        pageSizePdf) {
                                    return {
                                        columns : [
                                                {
                                                    text : LabelExported_by_Label+':'
                                                            + ' '+UserName
                                                            + ' '+LabelVD_on+' '
                                                            + $scope.CurrentDate
                                                            + ', '+LabelVD_powered_by+':',
                                                    fontSize : 9,
                                                    width : 'auto',
                                                    margin : [ 40, 0, 2, 0 ]
                                                },
                                                {
                                                    image : imageDisplay(),
                                                    width : 20,
                                                    height : 9,
                                                    margin : [ 0, 0, 0, 0 ]
                                                },
                                                {
                                                    text : LabelVD_company_name,
                                                    fontSize : 9,
                                                    width : 'auto',
                                                    margin : [ -7, 0, 0, 0 ]
                                                },
                                                {
                                                    text : LabelVD_page
                                                            + ' '
                                                            + currentPagepdf
                                                                    .toString()
                                                            + ' '+LabelVD_Of+' '
                                                            + pageSizePdf,
                                                    width : 'auto',
                                                    margin : [ PDFLeftMargin, 0, 0, 0 ],
                                                    fontSize : 9
                                                } ]
                                    }
                                },
                                content : [
                                        {
                                            text : '' + resultpdf
                                                    + LabelVD_Title,
                                            alignment : 'center',
                                            fontSize : 9,
                                            margin : [ 0, 0, 0, 10 ]
                                        },
                                        {
                                            table : {
                                                headerRows : 1,
                                                widths : [ '12.5%',
                                                        '12.5%', '12.5%',
                                                        '12.5%', '12.5%',
                                                        '12.5%', '12.5%',
                                                         '12.5%'],
                                                body : contenArrayChunk
                                            }
                                        } ],
                                styles : {
                                    header : {
                                        color : '#fff',
                                        fillColor : '#1fa5cd',
                                        fontSize : 11,                                        
                                        bold : true
                                    }
                                }
                            };
							doc1.push( angular.copy(docDefinition));
                            
							start1 = start1+1;
							end1 = end1 +1 ;
							
							}
							
							/*for(i=0;i<1;i++){
								
									
									
									pdfMake
                                    .createPdf(angular.copy(doc1[i]))
                                    .download(
                                            ''
                                                    + resultpdf
                                                    +' Historical Data.pdf');
													
							}*/
							
							var index = 0;
							var fileNumber;
							var interval = setInterval(function()
								{
									if (index < doc1.length) { // doc1 here is array of docs contents
										fileNumber = index + 1;
										pdfMake
											.createPdf(doc1[index])
											.download(
													''
															+ resultpdf
															+ fileNumber +' Historical Data.pdf');
										if(index == doc1.length - 1) {
											$scope.isDisabled = false;
											$scope.$apply();
										}											
										index++;
									} 
									/*else if(index == doc1.length) {
										$scope.isDisabled = false;
										$scope.$apply();
									}*/
									else {
										clearInterval(interval);
									}
								},
								200);	
								
                        };


                        function imageDisplay() {
                            
                            var c = document
                                    .getElementById("myCanvas");
                            var ctx = c.getContext("2d");
                            var img = document.getElementById("preview");
                            ctx.drawImage(img, 30, 30);
                            return c.toDataURL();
                        }

                        /**
                         * @Description: Function to generate and export the csv file
                         * @Param: NA
                         * @Return: NA
                         * @Date: 06/06/2016
                         **/
                        $scope.exportData = function() {
                            var tempList = $scope.filteredHistoryData;
                            var displayFooter = {
                                recordName : LabelExported_by_Label+':'
                                        + ' '+UserFirstName+' '+UserLastName
                                        + ' '+LabelVD_on+' '
                                        + $scope.CurrentDate
                                        + ', \n'+LabelVD_powered_by+':'
                                        + ' '+ LabelVD_company_name,
                                modifiedDisplayTime : '',
                                fieldLabel : '',
                                modifiedByName : '',
                                oldValue : '',
                                newValue : '',
                                fieldType : '',
                                fieldSeverity : ''
                            };
                            var insertBlank = {
                                recordName : '',
                                modifiedDisplayTime : '',
                                fieldLabel : '',
                                modifiedByName : '',
                                oldValue : '',
                                newValue : '',
                                fieldType : '',
                                fieldSeverity : ''
                            };
                            var insertBlankData = {
                                recordName : '',
                                modifiedDisplayTime : '',
                                fieldLabel : '',
                                modifiedByName : '',
                                oldValue : '',
                                newValue : '',
                                fieldType : '',
                                fieldSeverity : ''
                            };
                            tempList.push(insertBlank);
                            tempList.push(insertBlankData);
                            tempList.push(displayFooter);
							if(selectedObjLabel == '') {
								var result = relatedListObjectName;
							} else {
								var result = selectedObjLabel.substring(0,
                                    selectedObjLabel.indexOf('('));
							}
                            alasql(
                                    'SELECT recordName AS Name ,fieldLabel AS ModifiedField , '
                                            + 'oldValue AS OldValue, newValue AS NewValue, modifiedDisplayTime AS ModifiedTime, '
                                            + 'modifiedByName AS ModifiedBy, fieldType as DataType, fieldSeverity as Severity INTO CSV("'
                                            + result
                                            + ' Historical Data.csv",{headers:true}) FROM ?',
                                    [ tempList ]);
                            tempList.pop(displayFooter);
                            tempList.pop(insertBlankData); 
                            tempList.pop(insertBlank);
                        };

                        var toUTCDate = function(date) {
                            var _utc = new Date(date.getUTCFullYear(), date
                                    .getUTCMonth(), date.getUTCDate(), date
                                    .getUTCHours(), date.getUTCMinutes(),
                                    date.getUTCSeconds());

                            return _utc;
                        };
                        var millisToUTCDate = function(millis) {
                            return toUTCDate(new Date(millis));
                        };

                        /**
                         * @Description: Gets the total page count based on total data/by page size
                         * @Param: NA
                         * @Return: NA
                         * @Date: 06/06/2016
                         **/
                        $scope.numberOfPages = function() {
                            return Math
                                    .ceil($scope.fetchedHistoryData.length
                                            / $scope.pageSize);
                        }

                        /**
                         * @Description: Returns the upper limit of records shown on the page
                         * @Param: NA
                         * @Return: NA
                         * @Date: 08/06/2016
                         **/
                        $scope.totalNumberOfRecordInPage = function() {
                            return ($scope.currentPage * $scope.pageSize) > ($scope.fetchedHistoryData.length) ? ($scope.fetchedHistoryData.length)
                                    : ($scope.currentPage * $scope.pageSize);
                        }

                        /**
                         * @Description: Sorts the data in the table
                         * @Param: Name of the column according to which data needs to be sorted
                         * @Return: NA
                         * @Date: 08/06/2016
                         **/
                        $scope.sort = function(keyname) {
                            $scope.showLoader = true;
                            var isAllColumnValueSame = true;
                            for (var index = 1; index < $scope.filteredHistoryData.length; index++) {

                                if ($scope.filteredHistoryData[index - 1][keyname] != $scope.filteredHistoryData[index][keyname]) {
                                    isAllColumnValueSame = false;
                                    break;
                                }
                            }
                            if (isAllColumnValueSame === true) {
                                $timeout(function() {
                                    $scope.showLoader = false;

                                    $scope.$apply();
                                }, 100);
                                return;
                            }
                            $scope.sortKey = keyname; //set the sortKey to the param passed
                            if (angular.equals($scope.previousSortField,
                                    keyname)) {
                                $scope.reverse = !$scope.reverse;
                            } else {
                                $scope.reverse = false;
                            }
                            $scope.previousSortField = keyname;
                            $timeout(function() {
                                $scope.showLoader = false;
                                $scope.$apply();
                            }, 100);
                        }

                        /**
                         * @Description: PreApplyFilter Function sets variables on each filter as true
                         * @Param: Coulumn Name
                         * @Return: NA
                         * @Date: 08/06/2016
                         **/
                        $scope.preApplyFilter = function(columnName) {

                            if( columnName == LabelVD_RecordName ) 
                            {
                                $scope.displayAppliedFilterIconRecordName = true;
                            }
                            if(columnName == LabelVD_Modified_By ) 
                            {
                                $scope.displayAppliedFilterIconUserName = true;
                            }
                            if(columnName == LabelVD_Modified_Field ) 
                            {
                                $scope.displayAppliedFilterIconFieldName = true;
                            }
                            if(columnName == LabelVD_DataType ) 
                            {
                                $scope.displayAppliedFilterIconDataTypeName = true;
                            }
                            if(columnName == LabelVD_Severity ) 
                            {
                                $scope.displayAppliedFilterIconSeverityName = true;
                            }
                        };

                        /**
                         * @Description: Filters the records according to the selection
                         * @Param: Coulumn Name
                         * @Return: NA
                         * @Date: 08/06/2016
                         **/
                        $scope.applyFilters = function() {
                            var timer = 100;
							if($scope.isPartialRefresh) {
							  timer = 0;
							}
							
							$scope.showLoader = true;
							
                            $scope.isDisplayFilter = true;
                            $scope.loseFocus();
                            $timeout(
                                    function(result) {
									
                                    $scope.dataHolder = [];
                                    if($scope.searchStr) {
                                        $scope.dataHolder = $scope.filteredHistoryData;
                                    }
                                    else {
                                        $scope.dataHolder = $scope.fetchedHistoryData;
                                    }
                                        $scope.filteredHistoryData = [];
                                        var fieldArray = [];
                                        var recordArray = [];
                                        var userArray = [];
                                        var typeArray = [];
                                        var severityArray = [];
                                        var filterArray = [];
                                        offSet = 0;
                                        var isPushedAlready;
                                        for (var index = 0; index < $scope.dataHolder.length; index++) {
                                            var recordCount = 0;
                                            isPushedAlready = false;

                                            for ( var property in $scope.myFieldFilter.selected) {
                                                if ($scope.myFieldFilter.selected[property]) {
                                                    if(filterArray.indexOf(LabelVD_Modified_Field) <= -1) 
                                                        filterArray.push(LabelVD_Modified_Field);
                                                
                                                    if($scope.myFieldFilter.selected[property] === $scope
                                                                .getHtml($scope.dataHolder[index].fieldName)
                                                        && $scope.displayAppliedFilterIconFieldName) {
                                                        fieldArray.push(index);
                                                    }
                                                    
                                                } else if (!$scope.myFieldFilter.selected[property]) {
                                                    delete $scope.myFieldFilter.selected[property];
                                                }
                                            }
                                            
                                            for ( var property in $scope.myRecordFilter.selected) {
                                                if ($scope.myRecordFilter.selected[property]) {
                                                    if(filterArray.indexOf(LabelVD_RecordName) <= -1) 
                                                        filterArray.push(LabelVD_RecordName);
                                                    if($scope.myRecordFilter.selected[property] === $scope
                                                                .getHtml($scope.dataHolder[index].recordName)
                                                        && $scope.displayAppliedFilterIconRecordName) {
                                                        recordArray.push(index);
                                                    }

                                                } else if (!$scope.myRecordFilter.selected[property]) {
                                                    delete $scope.myRecordFilter.selected[property];
                                                }
                                            }
                                            
                                            for ( var property in $scope.myUserFilter.selected) {
                                                if ($scope.myUserFilter.selected[property]) {
                                                    if(filterArray.indexOf(LabelVD_Modified_By) <= -1) 
                                                        filterArray.push(LabelVD_Modified_By);
                                                    if($scope.myUserFilter.selected[property] === $scope
                                                                .getHtml($scope.dataHolder[index].modifiedByName)
                                                        && $scope.displayAppliedFilterIconUserName) {
                                                        userArray.push(index);
                                                    }

                                                } else if (!$scope.myUserFilter.selected[property]) {
                                                    delete $scope.myUserFilter.selected[property];
                                                }
                                            }
                                            
                                            for ( var property in $scope.myTypeFilter.selected) {
                                                if ($scope.myTypeFilter.selected[property]) {
                                                    if(filterArray.indexOf(LabelVD_DataType) <= -1) 
                                                        filterArray.push(LabelVD_DataType);
                                                    if($scope.myTypeFilter.selected[property] === $scope
                                                                .getHtml($scope.dataHolder[index].fieldType)
                                                        && $scope.displayAppliedFilterIconDataTypeName) {
                                                        typeArray.push(index);
                                                    }

                                                } else if (!$scope.myTypeFilter.selected[property]) {
                                                    delete $scope.myTypeFilter.selected[property];
                                                }
                                            }
                                            
                                            for ( var property in $scope.mySeverityFilter.selected) {
                                                if ($scope.mySeverityFilter.selected[property]) {
                                                    if(filterArray.indexOf(LabelVD_Severity) <= -1) 
                                                        filterArray.push(LabelVD_Severity);
                                                    if($scope.mySeverityFilter.selected[property] === $scope
                                                                .getHtml($scope.dataHolder[index].fieldSeverity)
                                                        && $scope.displayAppliedFilterIconSeverityName) {
                                                        severityArray.push(index);
                                                    }

                                                } else if (!$scope.mySeverityFilter.selected[property]) {
                                                    delete $scope.mySeverityFilter.selected[property];
                                                }
                                            }
                                        }
                                        for (var index = 0; index < $scope.fetchedHistoryData.length; index++) {
                                            if (((fieldArray.indexOf(index) >= 0) || ((fieldArray.length === 0) && (filterArray.indexOf(LabelVD_Modified_Field) <= -1)))
                                                    && ((recordArray
                                                            .indexOf(index) >= 0) || ((recordArray.length === 0) && (filterArray.indexOf(LabelVD_RecordName) <= -1)))
                                                    && ((userArray
                                                            .indexOf(index) >= 0) || ((userArray.length === 0) && (filterArray.indexOf(LabelVD_Modified_By) <= -1)))
                                                    && ((typeArray
                                                            .indexOf(index) >= 0) || ((typeArray.length === 0) && (filterArray.indexOf(LabelVD_DataType) <= -1)))
                                                    && ((severityArray
                                                            .indexOf(index) >= 0) || ((severityArray.length === 0) && (filterArray.indexOf(LabelVD_Severity) <= -1)))) {
                                                $scope.filteredHistoryData
                                                        .push($scope.dataHolder[index]);
                                            }
                                        }
                                        if((fieldArray.length === 0) && (filterArray.indexOf(LabelVD_Modified_Field) <= -1)) {
                                            $scope.displayAppliedFilterIconFieldName = false;
                                        }
                                        if((recordArray.length === 0) && (filterArray.indexOf(LabelVD_RecordName) <= -1)) {
                                            $scope.displayAppliedFilterIconRecordName = false;
                                        }
                                        if((userArray.length === 0) && (filterArray.indexOf(LabelVD_Modified_By) <= -1)) {
                                            $scope.displayAppliedFilterIconUserName = false;
                                        }
                                        if((typeArray.length === 0) && (filterArray.indexOf(LabelVD_DataType) <= -1)) {
                                            $scope.displayAppliedFilterIconDataTypeName = false;
                                        }
                                        if((severityArray.length === 0) && (filterArray.indexOf(LabelVD_Severity) <= -1)) {
                                            $scope.displayAppliedFilterIconSeverityName = false;
                                        }
                                        $scope.currentPage = 0;
                                        $scope.numberOfPages($scope.filteredHistoryData.length);
                                       
										$scope.showLoader = false;
										
                                    }, 100);
                        }

                        /**
                         * @Description: Returns the number of pages
                         * @Param: Total count
                         * @Return: NA
                         * @Date: 08/06/2016
                         **/
                        $scope.numberOfPages = function(totalItemCount) {

                            $scope.noOfPages = Math.ceil(totalItemCount
                                    / $scope.pageSize);
                            if ($scope.noOfPages <= $scope.currentPage) {
                                $scope.currentPage = $scope.noOfPages - 1;
                            }
                            if ($scope.noOfPages === 0) {
                                $scope.currentPage = 0;
                            }
                        }

                        /**
                         * @Description: Removes the filter applied and displays all records
                         * @Param: Name of the Field to clear the filter on
                         * @Return: NA
                         * @Date: 08/06/2016
                         **/
                        $scope.clearFilter = function(filterName) {
                            $scope.showLoader = true;
                            $scope.loseFocus();
                            $timeout(
                                    function(result) {
                                        $scope.searchStr = '';
                                        if (angular.equals(filterName,
                                                'recordName')) {
                                            $scope.myRecordFilter.selected = {};
                                            $scope.displayAppliedFilterIconRecordName = false;
                                            $scope.applyFilters();

                                        } else if (angular.equals(
                                                filterName, 'userName')) {
                                            $scope.myUserFilter.selected = {};
                                            $scope.displayAppliedFilterIconUserName = false;
                                            $scope.applyFilters();


                                        } else if (angular.equals(
                                                filterName, 'fieldName')) {
                                            $scope.myFieldFilter.selected = {};
                                            $scope.displayAppliedFilterIconFieldName = false; 
                                            $scope.applyFilters();
                                        
                                        }else if (angular.equals(
                                                filterName, 'fieldType')) {
                                            $scope.myTypeFilter.selected = {};
                                            $scope.displayAppliedFilterIconDataTypeName = false; 
                                            $scope.applyFilters();
                                            
                                        }else if (angular.equals(
                                                filterName, 'fieldSeverity')) {
                                            $scope.mySeverityFilter.selected = {};
                                            $scope.displayAppliedFilterIconSeverityName = false; 
                                            $scope.applyFilters();
                                            
                                        } else if (angular.equals(
                                                filterName,
                                                'clearAllFilter')) {
                                            $scope.myRecordFilter.selected = {};
                                            $scope.myUserFilter.selected = {};
                                            $scope.myFieldFilter.selected = {};
                                            $scope.myTypeFilter.selected = {};
                                            $scope.mySearchFilter.selected = {};
                                            $scope.mySeverityFilter.selected = {};
                                            $scope.applyFilters();
                                            $scope
                                                    .numberOfPages($scope.filteredHistoryData.length);
                                        }
                                        if (angular
                                                .equals(
                                                        $scope.myFieldFilter.selected,
                                                        {})
                                                && angular
                                                        .equals(
                                                                $scope.myRecordFilter.selected,
                                                                {})
                                                && angular
                                                        .equals(
                                                                $scope.myUserFilter.selected,
                                                                {})
                                                && angular
                                                        .equals(
                                                                $scope.myTypeFilter.selected,
                                                                {})
                                                && angular
                                                        .equals(
                                                                $scope.mySeverityFilter.selected,
                                                                {})) {
                                            $scope.isDisplayFilter = false;
                                            $scope.displayAppliedFilterIconRecordName = false;
                                            $scope.displayAppliedFilterIconUserName = false;
                                            $scope.displayAppliedFilterIconFieldName = false;
                                            $scope.displayAppliedFilterIconDataTypeName = false;
                                            $scope.displayAppliedFilterIconSeverityName = false; 
                                        }
                                    }, 100);
                            $scope.showLoader = false;
                        };

                        /**
                         * @Description: Checks if any filter is applied on the page
                         * @Param: NA
                         * @Return: true/false
                         * @Date: 08/06/2016
                         **/
                        $scope.checkIfFiltersAppliedOrNot = function() {
                            if (angular.equals(
                                    $scope.myFieldFilter.selected, {})
                                    && angular.equals(
                                            $scope.myRecordFilter.selected,
                                            {})
                                    && angular.equals(
                                            $scope.myUserFilter.selected,
                                            {})
                                    && angular.equals(
                                            $scope.myTypeFilter.selected,
                                            {})
                                    && angular.equals(
                                            $scope.mySeverityFilter.selected,
                                            {})) {
                                $scope.isDisplayFilter = false;
                            }
                            if (angular.equals($scope.isDisplayFilter,
                                    false)) {
                                return false;
                            }
                            return true;
                        };

                        /**
                         * @Description: Use to hide the filtered pop-up
                         * @Param: NA
                         * @Return: NA
                         * @Date: 08/06/2016
                         **/
                        $scope.loseFocus = function() {
                            angular.element(document).find('body')
                                    .triggerHandler('click');
                            $('.dropdown-menu')
                                    .off('click.stopPropagation');
                            $('.dropdown-menu open').hide();
                        };

                        /**
                         * @Description: Gets the total number of attachment for the selected range of date
                         * @Param: NA
                         * @Return: NA
                         * @Date: 08/06/2016
                         **/
                        $scope.getNumberofAttachment = function() {
                            $timeout(function(result) {
                                $scope.showLoader = true;
                            }, 100);
                            Visualforce.remoting.Manager
                                    .invokeAction(
                                            remoteActionGetAttachmentCount,
                                            $scope.selectedObj,
                                            $scope.startDate,
                                            $scope.endDate,
                                            $scope.objKeyPrefix,
                                            function(result, event) {
                                                if (event.status) {
                                                    attachmentCount = result;
                                                    $scope.callLoadData();
                                                } else if (event.type == 'exception') {
													document.getElementById("responseErrors").innerHTML = event.message;
													$('#showRemotingMessage').show();
													$('.panel-body').hide();
													$scope.showLoader = false;
                                                    $scope.$apply();
											} else {
                                                    $scope.showLoader = false;
                                                    $scope.$apply();
                                            }
                                            }, {
                                                buffer : false,
                                                escape : false,
                                                timeout : 30000
                                            });
                        }

                        /**
                         * @Description: Returns if there are more than 200 records
                         * @Param: NA
                         * @Return: NA
                         * @Date: 08/06/2016
                         **/
                        $scope.getShowMoreData = function() {
                            if(isRelatedListFlag == true) {
                                return ($scope.showMoreData && ($scope.filteredHistoryData.length == 25 || $scope.filteredHistoryData.length > 25));
                            }
                            else {
                                return ($scope.showMoreData && ($scope.filteredHistoryData.length == 200 || $scope.filteredHistoryData.length > 200));
                            }
                        }

                        /**
                         * @Description: Invokes loadData method for each attchment
                         * @Param: NA
                         * @Return: NA
                         * @Date: 08/06/2016
                         **/
                        $scope.callLoadData = function() {
                        
                        $scope.fetchedHistoryData = [];
                        $scope.filteredHistoryData = [];
                        if($scope.isPartialRefresh == false) { 
                            $scope.myRecordFilter.selected = {};
                            $scope.myUserFilter.selected = {};
                            $scope.myFieldFilter.selected = {};
                            $scope.myTypeFilter.selected = {};
                            $scope.mySeverityFilter.selected = {};
                            $scope.isDisplayFilter = false;
                            $scope.displayAppliedFilterIconRecordName = false;
                            $scope.displayAppliedFilterIconUserName = false;
                            $scope.displayAppliedFilterIconFieldName = false;
                            $scope.displayAppliedFilterIconDataTypeName = false;
                            $scope.displayAppliedFilterIconSeverityName = false;
                        }
                            offSet = 0;

                            if (attachmentCount > 0) {
                                for (i = 0; i < attachmentCount; i++) {
                                    if (!$scope.showMoreData) {
                                        $scope.loadData(i);
                                    } else if ($scope.loadMoreData
                                            && $scope.showMoreData) {
                                        if (!$scope.recordLimit) {
                                            $scope.loadData(i);
                                        }
                                    }
                                }
                            } 
							
							else {
                                $scope.showLoader = false;
                                $scope.$apply();
                            }
                        }

                        /**
                         * @Description: Fetches all the records for the current date range
                         * @Param: NA
                         * @Return: NA
                         * @Date: 08/06/2016
                         **/
                        $scope.loadMoreDataForAnObject = function() {
                            $scope.searchStr = '';
                            $scope.loadMoreData = true;
                            $scope.callLoadData();
                        }

                        /**
                         * @Description: Invokes the method to get the data from the attachment
                         * @Param: Sequence number of attachment to be fetched
                         * @Return: NA
                         * @Date: 08/06/2016
                         **/
                        $scope.loadData = function(offSet1) {
                            $scope.showLoader = true;
                            Visualforce.remoting.Manager
                                    .invokeAction(
                                            remoteActionfetchAttachments,
                                            $scope.selectedObj,
                                            $scope.startDate,
                                            $scope.endDate,
                                            isAllDataAccessible,
                                            offSet1,
                                            $scope.objKeyPrefix,
                                            function(result, event) {												
                                                if (event.status) {
                                                    if (result) { 
														angular.forEach(JSON.parse(result),
                                                            function(item) {																
                                                                if (!$scope.showMoreData) {
                                                                   
																	if(isRelatedListFlag == true && $scope.isURLParameterized == false) {
																		$(".mCustomScrollbar").show();
                                                                        // show upto 25 records for single record
                                                                        $scope.sort('modifiedTime');
                                                                        if ($scope.fetchedHistoryData.length < 25) {
                                                                            if(parentId === item.parentId) {
                                                                                item.newValue = replaceImageTagwithAnchor(item.newValue);
                                                                                item.oldValue = replaceImageTagwithAnchor(item.oldValue);
                                                                                $scope.fetchedHistoryData.push(item);
                                                                            }
                                                                        }else {
                                                                            $scope.showMoreData = true;
                                                                        }
                                                                    }
                                                                    else if(isRelatedListFlag == false && $scope.isURLParameterized == true) {
                                                                        // show upto 200 records for single record id
                                                                        if ($scope.fetchedHistoryData.length < 200) {
                                                                            if(parentId === item.parentId) {
                                                                                item.newValue = replaceImageTagwithAnchor(item.newValue);
                                                                                item.oldValue = replaceImageTagwithAnchor(item.oldValue);
                                                                                $scope.fetchedHistoryData.push(item);
                                                                            }
                                                                        }else {
                                                                            $scope.showMoreData = true;
                                                                        }
                                                                    }
                                                                    else if(isRelatedListFlag == false && $scope.isURLParameterized == false) {
                                                                        // show upto 200 records for all records
                                                                        if ($scope.fetchedHistoryData.length < 200) {
                                                                            item.newValue = replaceImageTagwithAnchor(item.newValue);
                                                                            item.oldValue = replaceImageTagwithAnchor(item.oldValue);
                                                                            $scope.fetchedHistoryData.push(item);
                                                                        }else {
																				$scope.showMoreData = true;
																				if($scope.isPartialRefresh == true && $scope.checkIfFiltersAppliedOrNot()) {
																	
																					$scope.applyFilters();
																					$scope.isPartialRefresh = false;
																				}
                                                                        }
                                                                    }
                                                                } else if ($scope.showMoreData
                                                                && $scope.loadMoreData) {
																	
                                                                    if ($scope.fetchedHistoryData.length < 50000) {
                                                                        item.newValue = replaceImageTagwithAnchor(item.newValue);
                                                                        item.oldValue = replaceImageTagwithAnchor(item.oldValue);
                                                                        $scope.fetchedHistoryData
                                                                                .push(item);
                                                                    } else {
                                                                        $scope.recordLimit = true;
																		if($scope.isPartialRefresh == true && $scope.checkIfFiltersAppliedOrNot()) {
																	
																			$scope.applyFilters();
																			$scope.isPartialRefresh = false;
																		}
                                                                    }
                                                                }
                                                                        });
                                                        $scope.filteredHistoryData = $scope.fetchedHistoryData;
                                                        
														
                                                        $scope.allItems = $scope.fetchedHistoryData;                                                        
                                                        $scope.numberOfPages($scope.filteredHistoryData.length);
														
                                                        /*if($scope.isPartialRefresh == true && $scope.checkIfFiltersAppliedOrNot()) {
                                                            console.log('My Data Vary ::::'+$scope.filteredHistoryData.length);
															$scope.applyFilters();
															$scope.isPartialRefresh = false;
                                                        }*/
                                                        
                                                    }
													else {
														$(".message").show();
													}
                                                    if (offSet == attachmentCount - 1) {
                                                        if ($scope.showMoreData
                                                                && $scope.loadMoreData) {
                                                            $scope.showMoreData = false;
                                                        }
                                                        if($scope.isPartialRefresh == true && $scope.checkIfFiltersAppliedOrNot()) {
																	
															$scope.applyFilters();
															$scope.isPartialRefresh = false;
															
														}
														
														$scope.showLoader = false;														
                                                        $scope.$apply();
                                                    }
                                                    ++offSet;
                                                } 
												else if (event.type == 'exception') {
													document.getElementById("responseErrors").innerHTML = event.message;
													$('#showRemotingMessage').show();
													$('.panel-body').hide();
													$scope.showLoader = false;
                                                    $scope.$apply();
												}
												else {
                                                    $scope.showLoader = false;
                                                    $scope.$apply();
                                                    
                                                }
                                            }, {
                                                buffer : false,
                                                escape : false,
                                                timeout : 50000
                                            });
                        }

                        /**
                         * @Description: For next previous pagination button sets the page and
                         *               shows the loading symbole
                         * @Param: Current page value
                         * @Return: NA
                         * @Date: 30/06/2016
                         **/
                        $scope.paginationForAllButton = function(
                                currentPageValue) {	
							
							$('.font-weight').scrollTop(0);
                            $scope.showLoader = true;
                            $timeout(function(result) {
                                $scope.currentPage = currentPageValue;
                                $scope.showLoader = false;	
                            }, 2000);
                        }
                        
                        /**
                         * @Description: method to iterate over the list of record displayed on page
                         * @Param: keyboard event
                         * @Return: NA
                         * @Date: 13/01/2017
                         **/
                        $scope.search = function()
                        { 
							if($scope.searchStr == '' && $scope.isSearchBlank == false)
                            {
                                $scope.isSearchBlank = true;
								$scope.filteredHistoryData = $scope.fetchedHistoryData;
                                $scope.clearFilter('clearAllFilter');
								
                            }
                            else if($scope.searchStr != ''){
							$scope.isSearchBlank = false;
                            $scope.allItems = $scope.fetchedHistoryData;
                            offSet = 0; 
                            $scope.currentPage = 0;
                            $scope.filteredHistoryData  = _.filter($scope.allItems,
                                     function(item){
                                         
                                         return $scope.searchUtil(item, $scope.searchStr); 
                                     });
                            }
							$scope.numberOfPages($scope.filteredHistoryData.length);
                            
                        }
                        
                        /**
                         * @Description: method to search for in name/old value/new value and auto apply filter
                         * @Param: iterator for the list and a keyword to be searched
                         * @Return: boolean
                         * @Date: 16/01/2017
                         **/
                        $scope.searchUtil = function(item, toSearch)
                        {
                            /* Search Text in 6 fields */
                            return ( item.recordName.toLowerCase().indexOf(toSearch.toLowerCase()) > -1 
                                    || item.modifiedByName.toLowerCase().indexOf(toSearch.toLowerCase()) > -1 
                                    || item.oldValue.toLowerCase().indexOf(toSearch.toLowerCase()) > -1 
                                    || item.newValue.toLowerCase().indexOf(toSearch.toLowerCase()) > -1 
                                    || item.fieldType.toLowerCase().indexOf(toSearch.toLowerCase()) > -1 
                                    || item.fieldSeverity.toLowerCase().indexOf(toSearch.toLowerCase()) > -1 
                                    || item.fieldLabel.toLowerCase().indexOf(toSearch.toLowerCase()) > -1
                                    || item.fieldName.toLowerCase().indexOf(toSearch.toLowerCase()) > -1
                                    || item.modifiedDisplayTime.toLowerCase().indexOf(toSearch.toLowerCase()) > -1 )
                                         ? true : false ;
                            
                        }
                       
                        /**
                         * @Description: Invokes the method to get the list of users
                         * @Param: NA
                         * @Return: NA
                         * @Date: 19/01/2017
                         **/
                        $scope.loadUserData = function() {
                            Visualforce.remoting.Manager
                                    .invokeAction(
                                            remoteActiongetOrgUsers,
                                            function(result, event) {
                                                if (event.status) {
                                                    if (result) {
                                                        angular
                                                            .forEach(
                                                                JSON.parse(JSON.stringify(result)),
                                                                    function(item) {
                                                                        $scope.fetchedUserData.push(item);
                                                                }
                                                            )
                                                    $scope.$apply();
                                                    }
                                                }
												else if (event.type == 'exception') {
													document.getElementById("responseErrors").innerHTML = event.message;
													$('#showRemotingMessage').show();
													$('.panel-body').hide();
													$scope.showLoader = false;
                                                    $scope.$apply();
												}
                                            }
                                    );
                        }

                        /**
                         * @Description: Refresh the history records
                         * @Param: event: NA
                         * @Return: NA
                         * @Date: 17/01/2017
                         **/
                        $scope.refreshContent = function()  
                        {
                            $scope.isPartialRefresh = true;
                            //$('.errorMessageDiv').hide();
							if($scope.loadMoreData) {
								$scope.showMoreData = true;
								$scope.loadMoreDataForAnObject();
							} else {
								$scope.getRecords();
							}
                            
                        }
                        
                        $scope.getRecords();
						$scope.loadUserData();
                    });
    /**
     * @Description: Set the focus back on input field when we enter number of days in N days date range
     * @Param: NA
     * @Return: NA
     * @Date: 8/12/2016
     **/
    angular.module('myApp').directive('showFocus', function($timeout) {
          return function(scope, element, attrs) {
            scope.$watch(attrs.showFocus, 
              function (newValue) { 
            
                $timeout(function() {
                    $(".TxtDays").focus();
                });
              },true);
          };    
    });
  
  
    /**
     * @Description: Angular filter for the first page
     * @Param: NA
     * @Return: NA
     * @Date: 30/06/2016
     **/
    app.filter('firstPage', function() {
        return function(input, start) {
            start = +start;
            return input.slice(start);
        }
    });

    /**
     * @Description: Create the unique filter select options dynamically
     *               based on the column values
     * @Param: NA
     * @Return: NA
     * @Date: 30/06/2016
     **/
    app.filter('unique', function() {
        return function(items, filterOn) {
            if (filterOn === false) {
                return items;
            }
            if ((filterOn || angular.isUndefined(filterOn))
                    && angular.isArray(items)) {
                var hashCheck = {}, newItems = [];
                var extractValueToCompare = function(item) {
                    if (angular.isObject(item)
                            && angular.isString(filterOn)) {
                        return item[filterOn];
                    } else {
                        return item;
                    }
                };
                angular.forEach(items, function(item) {
                    var valueToCheck, isDuplicate = false;
                    for (var i = 0; i < newItems.length; i++) {
                        if (angular.equals(
                                extractValueToCompare(newItems[i]),
                                extractValueToCompare(item))) {
                            isDuplicate = true;
                            break;
                        }
                    }
                    if (!isDuplicate) {
                        newItems.push(item);
                    }
                });
                items = newItems;
            }
            return items;
        };
    });