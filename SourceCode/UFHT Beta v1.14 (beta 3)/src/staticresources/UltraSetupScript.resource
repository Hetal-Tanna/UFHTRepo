 /**
	 * @Description: It prevents to close filter section if clicked inside filter section 
	 * @Param: isPropagate: Boolean to apply stop propagation when passed as true 
	 * @Return: NA
	 * @Date: 18/01/2017
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
 * @Description: Function to open the visualforce page to create remote site setting.
 * @Param: NA
 * @Return: NA
 * @Date: 17/11/2015
 **/
	function popupRemotesiteSettingPage() {
		var res = encodeURI("apex/CreateRemoteSiteSetting");
		var win = window.open(res,'myWindow','height=300,width=400,status=0,toolbar=0');

		var timer = setInterval(function() {
			if(win.open) {
				clearInterval(timer);
				win.close();
				window.location.reload();
			}
		}, 5000);
	}

/** 
    *Angular Js Code Starts
**/  
/**
	 * @Description: app variable defines the app for angular, controller method for the angular app
	 * @Param: String name for Controller, actual controller function
	 * @Return: NA
	 * @Date: 01/01/2017
 **/
 
var app = angular.module('app',[ "ngSanitize" ]);

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

	app.controller('ctrl',function($scope,$timeout,$sce) {
		$scope.orderByField = 'fieldLabel';
		$scope.reverseSort = false;
		$scope.objectName = '';
		$scope.selectedObject = '';
		$scope.currentPage = 0;
		$scope.totalResult = '';
		$scope.noOfPages = 0;
		$scope.isCheckboxSelected = false;
		$scope.isRemoteSiteSetting = false;
		$scope.isHTTPCalloutFail = false;
		$scope.OWDSelected = '';
		$scope.showOwdPicklist;
		$scope.pageSize =  pageSize;
		$scope.lstObjectFields = [];
		$scope.dataTypeList = [];
		$scope.selectedFields = [];
		$scope.selectedOWDValue = '';
		$scope.statusMessage = '';
		$scope.searchStr = "";
		$scope.data = '';
		$scope.typeStatusMessage  = '';
		$scope.showSuccessPanel = false;
		$scope.showErrorPanel = false;
		$scope.showDeployMessage = false;
		$scope.resultedProgressCounter;
		$scope.enablePoller = false;
		$scope.showLoader = false;
		$scope.asyncId;
		$scope.isEnablePoller;
		$scope.progressCounter;
		$scope.ultraTrackObject = {};
		$scope.isValidLicense = isValidLicense;
		$scope.dataTypeSelected = {
			selected : {}
		}
		$scope.availableTags = resultedObject;
		$scope.itemsDB = [];
		
		$scope.selectedOWDValue = 'Field changes visible to?';
		if(remoteSiteSetting == 'true') {
			$scope.isRemoteSiteSetting = true;
		} else {
			$scope.isRemoteSiteSetting = false;
		}
		if(isHTTPCalloutFail == 'true') {
			$scope.isHTTPCalloutFail = true;
		} else {
			$scope.isHTTPCalloutFail = false;
		}
/**
	* @Description: Function to get the triggerable object from contoller to autocomplete object name.
	* @Param: Object Name
	* @Return: NA
	* @Date: 1/16/2016
**/
		$scope.complete=function($event) {
			$( "#tags" ).autocomplete({
				source: $scope.availableTags,
				select: function( event, ui ) {

				$scope.showLoader = true;
				$scope.hideError();
				$scope.$apply();
				$("input[id$='tags']").val(ui.item.value);
				$scope.objectName = $("input[id$='tags']").val();
				$scope.getFields();
				},
				autoFocus : true
			});

			$("input[id$='tags']").keypress(function(e){
				var key = e.key ;
				if (key == 'Enter'){
					$scope.objectName = $("input[id$='tags']").val();
					if($("input[id$='tags']").val() == '') {
						return false;
					}
					if($("input[id$='tags']").val()) {
						$scope.getFields();
					}
				}
			});

			//$scope.selectedObject = $scope.availableTags[0];
			if($("input[id$='tags']").val() == '' || ($event.key == 'Backspace' || $event.key == 'Delete')) {
				$scope.objectName = $("input[id$='tags']").val();
				$("#owdError").hide();
				$('.owdForObject1').hide();
				$('.showFilters').hide();
				$(".outputclass").hide();
				$('.iconClass').hide();
				$scope.hideError();
			}
		}
		
/**
	* @Description: HIdes the error and get the value selected 
	* @Param: 
	* @Return: NA
	* @Date: 1/16/2016
 **/
		$scope.getValue = function() {
			$scope.hideError();
			$("#owdError").hide();
			$scope.OWDSelected = $scope.selectedOWDValue;
		}
		

/**
	* @Description: Method hiding the panels
	* @Param: 
	* @Return: NA
	* @Date: 1/16/2016
 **/
 
		$scope.hideError = function() {
			$scope.showSuccessPanel = false;
			$scope.showErrorPanel = false;
			$scope.showWarningPanel = false;
		}
		
/**
	 * @Description: Escapes 
	 * @Param: String to be escaped html tags.
	 * @Return: NA
	 * @Date: 04/06/2016
 **/
		$scope.getHtml = function(str) {
			return $sce.trustAsHtml(str);	
		};	

                
/**
	* @Description: Gets the selected object related fields
	* @Param: Object Name
	* @Return: NA
	* @Date: 01/16/2017
**/
		$scope.getFields = function() {
			$scope.selectedOWDValue = 'Field changes visible to?';
			$scope.showLoader = true;
			$('.owdForObject1').hide();
			$('.showFilters').hide();
			$(".outputclass").hide();
			Visualforce.remoting.Manager.invokeAction(
				 remoteActiongetFields,
				 $scope.objectName,
					function(result, event) {
						
						if (event.status) {
							if(result != null) {
								$scope.hideError();
								$scope.itemsDB = result.allFieldswrapperList;
								$scope.lstObjectFields = result.allFieldswrapperList;

								$scope.showOwdPicklist = result.showOWDPicklist;
								$scope.ultraTrackObject = result.ultraTrackContainerObj;
								if(result.ultraTrackContainerObj != undefined) {
									if(result.ultraTrackContainerObj.UFHT__OWD_for_an_Object__c == undefined) {
										$scope.selectedOWDValue = 'Field changes visible to?';
									} else {
										$scope.selectedOWDValue = result.ultraTrackContainerObj.UFHT__OWD_for_an_Object__c;
									}
								}
								if($scope.lstObjectFields.length > 0) {
									$scope.searchStr = '';
									$('.owdForObject1').show();
									$('.showFilters').show();
									$(".outputclass").show();	
									$('.iconClass').show();
									angular.forEach($scope.lstObjectFields, function(value, key){
										if(value.isSelected != true) {
											$scope.isCheckboxSelected = false;
										} else {
											$scope.isCheckboxSelected = true;
										}
									});
								}
								
								if(result.lstPageMessagesWrapper.length > 0) {
									angular.forEach(result.lstPageMessagesWrapper, function(value, key) {
										$scope.typeStatusMessage = value.typeOfMessage;
										if(value.typeOfMessage == 'Confirm') {
											$scope.statusMessage = value.triggerStatusMessage;
											$scope.showSuccessPanel = true;
										} else if (value.typeOfMessage == 'Error') {
											$scope.statusMessage = value.triggerStatusMessage;
											$scope.showErrorPanel = true;
									   } else if(value.typeOfMessage == 'Warning') {
											$scope.statusMessage = value.triggerStatusMessage;
											$scope.showWarningPanel = true;
									   }
									   
									});
								}
								$scope.showLoader = false;
								$scope.numberOfPages($scope.lstObjectFields.length);
								$scope.setSelectOrDeselectAll();
								$scope.$apply();
							}
						}	else if (event.type == 'exception') {
								document.getElementById("responseErrors").innerHTML = event.message;
								$('#showRemotingMessage').show();
								$scope.showLoader = false;
							}
					}, {
						escape: false
					   }
			);
		}

/**
	* @Author: Eternus Solutions
	* @Description: Method to select all checkbox when click on select all button
	* @Param:
	* @Return:
	* @Date: 01/17/2016
**/
		$scope.selectAllCheckbox = function() {
			$scope.selectedFields = [];
			$scope.showSuccessPanel = false;
			$scope.showErrorPanel = false;
			$scope.showWarningPanel = false;
			if($scope.lstObjectFields.length > 0) {
				angular.forEach($scope.lstObjectFields, function(value, key) {
					value.isSelected = $scope.isCheckboxSelected;
					if(value.isSelected == true){
						$scope.selectedFields.push(value.fieldApiName);
					}
				});
				
				
			}
		};

/**
	* @Author: Eternus Solutions
	* @Description: Method to select all and deselect all checkbox when any field is selected or deselected
	* @Param:
	* @Return:
	* @Date: 01/17/2017
 **/
		$scope.setSelectOrDeselectAll = function() {
			//$scope.showSuccessPanel = false;
			//$scope.showErrorPanel = false;
			//$scope.showWarningPanel = false;
			$scope.selectedFields = [];
				if($scope.lstObjectFields.length > 0) {
					$scope.isCheckboxSelected = true;
					angular.forEach($scope.lstObjectFields, function(value, key) {
						if(value.isSelected == false){
							$scope.isCheckboxSelected = false;
							value.fieldToggle = false;
						}
						if (value.isSelected != null && value.isSelected) {
							  $scope.selectedFields.push(value.fieldApiName);
						}
					});
				}
		}
               
/**
	* @Description: For next previous pagination button sets the page and
	*               shows the loading symbole
	* @Param: Current page value
	* @Return: NA
	* @Date: 1/16/2017
 **/
		$scope.paginationForAllButton = function(
				currentPageValue) {
				$('.field-table-container').scrollTop(0);
				//$(document).tooltip('hide');
				$scope.showLoader = true;
				$scope.currentPage = currentPageValue;
				$scope.showLoader = false;
		}
                
				
/**
	* @Description: Filters the records according to the selection
	* @Param: 
	* @Return: NA
	* @Date: 02/08/2017
**/
		$scope.applyFilters = function() {
			$scope.hideError();
			$scope.allItems = $scope.itemsDB;
			$scope.lstObjectFields  = _.filter($scope.allItems,
					 function(item){  
						 return $scope.searchUtil(item, $scope.searchStr); 
					 });
			if($scope.searchStr == '') {
				$scope.lstObjectFields = $scope.itemsDB;
			}
			$scope.numberOfPages($scope.lstObjectFields.length);
			$scope.setSelectOrDeselectAll();
		}
				
				
/**
	* @Description: method to search for in name/old value/new value and auto apply filter
	* @Param: iterator for the list and a keyword to be searched
	* @Return: boolean
	* @Date: 16/01/2017
**/
		$scope.searchUtil = function(item, toSearch) {
			/* Search Text fields */
			return ( item.fieldApiName.toLowerCase().indexOf(toSearch.toLowerCase()) > -1 
					|| item.fieldLabel.toLowerCase().indexOf(toSearch.toLowerCase()) > -1 
					) ? true : false ;
			
		}
				
/**
	* @Description: Returns the number of pages
	* @Param: Total count
	* @Return: NA
	* @Date: 01/19/2017
**/
		$scope.numberOfPages = function(totalItemCount) {
			$scope.noOfPages = Math.ceil(totalItemCount/$scope.pageSize);
			if ($scope.noOfPages <= $scope.currentPage) {
				$scope.currentPage = $scope.noOfPages - 1;
			}
			if ($scope.noOfPages === 0) {
				$scope.currentPage = 0;
			}
		}
		
/**
	* @Description: Use to hide the filtered pop-up
	* @Param: NA
	* @Return: NA
	* @Date: 01/02/2017
**/
		$scope.loseFocus = function() {
			angular.element(document).find('body')
					.triggerHandler('click');
			$('.dropdown-menu')
					.off('click.stopPropagation');
			$('.dropdown-menu open').hide();
		};

/**
	* @Description: Returns the value of OWD selected
	* @Param: 
	* @Return: NA
	* @Date: 01/16/2017
**/
		$scope.checkOWDValue = function() {
			$scope.showSuccessPanel = false;
				$scope.showErrorPanel = false;
				$scope.showWarningPanel = false;
			if($scope.showOwdPicklist && $(".owdForAnObjectClass option:selected").val() == 'Field changes visible to?'){
				$("#owdError").html('Please select a valid option for the above field.');
				$("#owdError").show();
			}
			else{
				$("#owdError").hide();
				$scope.checkOWDAndSaveTracking();
			}
		}
		
/**
	* @Description: Save/Update the selected fields of selected object.
	* @Param: 
	* @Return: NA
	* @Date: 01/16/2017
**/
		$scope.checkOWDAndSaveTracking = function() {
			$scope.hideError();
			$scope.resultedProgressCounter = 0;
			$scope.showDeployMessage = true;
			if($scope.ultraTrackObject == undefined) {
				$scope.ultraTrackObject = null;
			}
			$scope.data = '';
			$scope.selectedFields = [];
			angular.forEach($scope.itemsDB, function(value, key) {
				if(value.isSelected == true) {
					$scope.selectedFields.push(value.fieldApiName);
					if(value.fieldToggle == true) {
						$scope.data +=  value.fieldApiName + ':' + 1 +',';
					} else {
						$scope.data +=  value.fieldApiName + ':' + 0 +',';
					}
				}
			});
			Visualforce.remoting.Manager.invokeAction(
				remoteActiongetSelectedFields,
				$scope.objectName,
				$scope.availableTags,
				$scope.selectedFields,
				$scope.selectedOWDValue,
				$scope.ultraTrackObject,
				$scope.data,
				function(result, event) {
					if (event.status) {
						if(result != null) {
							$scope.asyncId = result.asyncId;
							$scope.isEnablePoller = result.isEnablePollar;
							$scope.progressCounter = result.progCounter;
							if(result.isRemoteSiteSettings == true){
								$scope.isRemoteSiteSetting = true;
								$scope.showDeployMessage = false;
								
							} else {
								if($scope.asyncId != null) {
									 $scope.checkTriggerDeploymentStatus($scope.progressCounter);	 
								}
								if(result.lstPageMessagesWrapper.length > 0) {
									angular.forEach(result.lstPageMessagesWrapper, function(value, key) {
											
										   $scope.typeStatusMessage = value.typeOfMessage;
										   if(value.typeOfMessage == 'Confirm') {
											   $scope.statusMessage = value.triggerStatusMessage;											  
											   $scope.enablePoller = false;
											   $scope.showDeployMessage = false;
											   $scope.showSuccessPanel = true;
										   } else if(value.typeOfMessage == 'Error') {
											   $scope.statusMessage = value.triggerStatusMessage;
											   $scope.enablePoller = false;
											   $scope.showDeployMessage = false;
											   $scope.showErrorPanel = true;
											  
										   } else if(value.typeOfMessage == 'Warning') {
											   $scope.statusMessage = value.triggerStatusMessage;
											   $scope.enablePoller = false;
											   $scope.showDeployMessage = false;
											   $scope.showWarningPanel = true;
										   }
										});
								}
							}
						}
						$scope.$apply();
					} else if (event.type == 'exception') {
						document.getElementById("responseErrors").innerHTML = event.message;
						$('#showRemotingMessage').show();
						$scope.showLoader = false;
					}
				}, {
					escape: false
				   }
			);
		}
		
/**
	* @Description: Checks the deployment status for the selected object.
	* @Param: 
	* @Return: NA
	* @Date: 01/16/2017
**/
		$scope.checkTriggerDeploymentStatus = function(progressValue) {
			Visualforce.remoting.Manager.invokeAction(
				remoteActiongetDeploymentStatus,
				$scope.asyncId,
				$scope.isEnablePoller,
				progressValue,
				$scope.objectName,
				$scope.selectedOWDValue,
				function(result, event) {
					if (event.status) {
						$scope.hideError();
						$scope.resultedProgressCounter = result.progCounter;
						
						if($scope.resultedProgressCounter != 100) {
							$scope.enablePoller = true;
							$scope.checkTriggerDeploymentStatus($scope.resultedProgressCounter);
						} else if($scope.resultedProgressCounter == 100) {
							$scope.enablePoller = false;
						}
						
						if(result.lstPageMessagesWrapper.length > 0) {
							angular.forEach(result.lstPageMessagesWrapper, function(value, key) {
							   $scope.typeStatusMessage = value.typeOfMessage;
							   if(value.typeOfMessage == 'Confirm') {
								   $scope.statusMessage = value.triggerStatusMessage;
								   $scope.showDeployMessage = false;
								   $scope.showSuccessPanel = true;
							   } else if(value.typeOfMessage == 'Error') {
								   $scope.statusMessage = value.triggerStatusMessage;
								   $scope.showErrorPanel = true;
								   $scope.showDeployMessage = false;
							   } else if(value.typeOfMessage == 'Warning') {
								   $scope.statusMessage = value.triggerStatusMessage;
								   $scope.showWarningPanel = true;
								   $scope.showDeployMessage = false;
							   }
							   
							});
						}
						$scope.$apply();
					} else if (event.type == 'exception') {
						document.getElementById("responseErrors").innerHTML = event.message;
						$('#showRemotingMessage').show();
						$scope.showLoader = false;
					}
				}, {
					escape: false
				   }
			);
		}
	}); //app ends