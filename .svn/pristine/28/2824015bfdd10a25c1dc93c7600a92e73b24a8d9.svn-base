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
      *Angular Js Code Starts
     **/
    
    /**
     * @Description: app variable defines the app for angular, controller method for the angular app
     * @Param: String name for Controller, actual controller function
     * @Return: NA
     * @Date: 01/01/2017
     **/
var isFiltered = false;
var app = angular.module('app',[]);
            //app.constant('NUMBEROFCOLUMNS', '4');
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
            app.controller('ctrl',function($scope,$timeout) {
                $scope.orderByField = 'fieldLabel';
                $scope.reverseSort = false;
                $scope.objectName = '';
                $scope.selectedObject = '';
                $scope.currentPage = 0;
				$scope.totalResult = '';
                $scope.noOfPages = 0;
                $scope.isCheckboxSelected = true;
				$scope.displayAppliedFilterIconDataTypeName = false;
                $scope.OWDSelected = '';
                $scope.showOwdPicklist;
                $scope.pageSize =  pageSize;
                $scope.lstObjectFields = [];
                $scope.dataTypeList = [];
                $scope.selectedFields = [];
				$scope.searchResult = [];
                $scope.FieldToggleObject = [];
               
                $scope.selectedOWDValue = '';
                $scope.statusMessage = '';
				$scope.searchStr = "";
                $scope.data = '';
                $scope.typeStatusMessage  = '';
                $scope.showSuccessPanel = false;
                $scope.showErrorPanel = false;
                $scope.resultedProgressCounter;
                $scope.enablePoller = false;
                $scope.showLoader = false;
                $scope.asyncId;
                $scope.isEnablePoller;
                $scope.progressCounter;
                $scope.ultraTrackObject = {};
                $scope.dataTypeSelected = {
                    selected : {}
                }
                $scope.removeSquareBracket = objectList;
                $scope.removeEndSquareBracket = $scope.removeSquareBracket.replace("]","");
                $scope.removeQuotes = $scope.removeEndSquareBracket.replace(/["]+/g, "");
                $scope.availableTags = $scope.removeQuotes.split(',');
				$scope.itemsDB = [];
                
             
                 $scope.selectedOWDValue = 'History changes visible to?';

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
							  $scope.$apply();
                              $("input[id$='tags']").val(ui.item.value);
							  
                             /* $(".owdForAnObjectClass option").each(function() {
                                     if (this.value == '') {
                                         this.selected = true;
                                     }
                              });*/
                              $scope.objectName = $("input[id$='tags']").val();
							  $scope.getFields();
							  $scope.loadDataTypes();
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
								$scope.loadDataTypes();
	                        }
                        }
                    });
                    
                    $scope.selectedObject = $scope.availableTags[0];
                    if($("input[id$='tags']").val() == '' || ($event.key == 'Backspace' || $event.key == 'Delete')) {
                          $('.owdForObject1').hide();
                          $('.showDatatype').hide();
                          $('.searchPanel').hide();
                          $('.sortPanel').hide();
                          $('.checkBoxPanel').hide();
                          $(".outputclass").hide();
                          $scope.showSuccessPanel = false;
                          $scope.showErrorPanel = false;
                          $scope.showWarningPanel = false;
                    }
                    
                    $scope.getValue = function() {
						   $("#owdError").hide();
                          //$scope.OWDSelected = $(".owdForAnObjectClass option:selected").val();
                          $scope.OWDSelected = $scope.selectedOWDValue;
                          //$scope.resultTest = $scope.selectedOWDValue;
                          console.log('$$ OWD Value',$scope.OWDSelected);
                   }
                }
				
				
				
				$scope.countDatatype = function() {
					
					console.log('>>> myTypeFilter.selected : ',$scope.dataTypeSelected.selected);
					$scope.totalCount = 0;
					for(var a in $scope.dataTypeSelected.selected) {
						
						if($scope.dataTypeSelected.selected[a] != "") {
							$scope.totalCount = $scope.totalCount + 1;
							
						}
					}
					
					$scope.totalResult = 'Selected' + ' '+ $scope.totalCount;
				}
				
                /**
                 * @Description: Invokes the method to get the list of datatypes for selected objects
                 * @Param: Id of selected object
                 * @Return: NA
                 * @Date: 01/2/2017
                 **/
                $scope.loadDataTypes = function() {
				$scope.dataTypeList = [];
                    Visualforce.remoting.Manager
                       .invokeAction(
                         remoteActiongetDatatypes,
                          $scope.objectName,
                          function(result, event) {
                              if (event.status) {
                                  if (result) {
                                      angular.forEach(JSON.parse(JSON.stringify(result)),
                                                      function(item) {
                                                          console.log('>>> item : ',item);
                                                          $scope.dataTypeList.push(item);
														  console.log('>>> $scope.dataTypeList : ',$scope.dataTypeList);
                                                       }
                                                  )
                                      $scope.$apply();
                                  }
                              }
                          }
                    );
                 }
                
                /**
                 * @Description: Gets the selected object related fields
                 * @Param: Object Name
                 * @Return: NA
                 * @Date: 01/16/2017
                **/
                $scope.getFields = function() {
					$scope.showLoader = true;
                     $('.owdForObject1').hide();
                     $('.showDatatype').hide();
                     $('.searchPanel').hide();
                     $('.sortPanel').hide();
                     $('.checkBoxPanel').hide();
                     $(".outputclass").hide();
                       
                        Visualforce.remoting.Manager.invokeAction(
                         remoteActiongetFields,
                         $scope.objectName,
                            function(result, event) {
                                if (event.status) {
                                    $scope.showSuccessPanel = false;
                                    $scope.showErrorPanel = false;
                                    $scope.showWarningPanel = false;
									
                                    $scope.itemsDB = result.allFieldswrapperList;
									console.log('%%% initial',$scope.itemsDB);
                                    $scope.lstObjectFields = result.allFieldswrapperList;
                                    $scope.showOwdPicklist = result.showOWDPicklist;
                                    $scope.ultraTrackObject = result.ultraTrackContainerObj;
                                    
                                    if($scope.lstObjectFields.length > 0) {
										$scope.searchStr = '';
                                        $('.owdForObject1').show();
		                                $('.showDatatype').show();
		                                $('.searchPanel').show();
		                                $('.sortPanel').show();
		                                $('.checkBoxPanel').show();
		                                $(".outputclass").show();
	                                    angular.forEach($scope.lstObjectFields, function(value, key){
	                                        if(value.isSelected != true) {
	                                            $scope.isCheckboxSelected = false;
	                                        }
	                                    });
                                    }
                                    
                                    if(result.lstPageMessagesWrapper != null) {
	                                    angular.forEach(result.lstPageMessagesWrapper, function(value, key) {
	                                       $scope.typeStatusMessage = value.typeOfMessage;
	                                       if(value.typeOfMessage == 'Confirm') {
	                                           $scope.statusMessage = value.triggerStatusMessage;
	                                           $scope.showSuccessPanel = true;
	                                       } else if(value.typeOfMessage == 'Error') {
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
                                    $scope.$apply();
                                } else {
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
                console.log('%% checkbox',$scope.isCheckboxSelected);
                    if($scope.lstObjectFields != null) {
                        angular.forEach($scope.lstObjectFields, function(value, key) {
                            value.isSelected = $scope.isCheckboxSelected;
                            console.log('%% Selected Value',value.isSelected);
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
					//console.log('%% this value ::',checkboxvalue);
					debugger;
					/*if(checkboxvalue == true) {
						$(".base-checkbox").addClass("highlight");
					}*/
                    $scope.selectedFields = [];
                        if($scope.lstObjectFields != null) {
                            $scope.isCheckboxSelected = true;
                            console.log('%% Selected Value',$scope.selectedFields);
                            angular.forEach($scope.lstObjectFields, function(value, key) {
                                if(value.isSelected == false){
                                    $scope.isCheckboxSelected = false;
                                    console.log('%% Selected Value',$scope.isCheckboxSelected);
                                }
                                if (value.isSelected != null && value.isSelected) {
                                      $scope.selectedFields.push(value.fieldApiName);
                                      console.log('%% Selected Fields',$scope.selectedFields);
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
					debugger;
                    $scope.showLoader = true;
                   // $timeout(function(result) {
                        $scope.currentPage = currentPageValue;
                        $scope.showLoader = false;
                   // }, 2000);

                }
                
				
				 /**
                  * @Description: Filters the records according to the selection
                  * @Param: 
                  * @Return: NA
                  * @Date: 02/08/2017
                **/
				$scope.applyFilters = function() {
					$scope.allItems = $scope.itemsDB;
						$scope.lstObjectFields  = _.filter($scope.allItems,
								 function(item){  
									 return $scope.searchUtil(item, $scope.searchStr); 
								 });
						if($scope.searchStr == '')
						{
							$scope.lstObjectFields = $scope.itemsDB;
							$scope.clearFilter('clearAllFilter');
						}
					$scope.numberOfPages($scope.lstObjectFields.length);
					$scope.setSelectOrDeselectAll();
				}
				
				
				 /**
				 * @Description: Removes the filter applied and displays all records
				 * @Param: Name of the Field to clear the filter on
				 * @Return: NA
				 * @Date: 08/06/2016
				 **/
				$scope.clearFilter = function() {
					$scope.showLoader = true;
					$scope.loseFocus();
					$timeout(
                        function(result) {
								$scope.dataTypeSelected.selected = {};
								$scope.applyFilters();
						}, 100);
                        $scope.showLoader = false;	
						
				}

				/**
				 * @Description: method to search for in name/old value/new value and auto apply filter
				 * @Param: iterator for the list and a keyword to be searched
				 * @Return: boolean
				 * @Date: 16/01/2017
				 **/
				$scope.searchUtil = function(item, toSearch)
				{
					/* Search Text fields */
					return ( item.fieldApiName.toLowerCase().indexOf(toSearch.toLowerCase()) > -1 
							|| item.fieldLabel.toLowerCase().indexOf(toSearch.toLowerCase()) > -1 
							
							)
								 ? true : false ;
					
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
                debugger;
                    if($scope.showOwdPicklist && $(".owdForAnObjectClass option:selected").val() == 'History changes visible to?'){
                        $("#owdError").html('Please select OWD for an selected object');
                        $("#owdError").show();
                    }
                    else{
                        $("#owdError").hide();
                        $scope.checkOWDAndSaveTracking();
                        $scope.enablePoller = true;
                    }
                }

                $scope.checkOWDAndSaveTracking = function() {
                    if($scope.ultraTrackObject == undefined) {
                        $scope.ultraTrackObject = null;
                    }
                    $scope.data = '';
                    $scope.selectedFields = [];
                    angular.forEach($scope.lstObjectFields, function(value, key){
                        if(value.isSelected != true) {
                            $scope.isCheckboxSelected = false;
                        } else {
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
                                    $scope.showSuccessPanel = false;
                                    $scope.showErrorPanel = false;
                                    $scope.showWarningPanel = false;
                                    $scope.asyncId = result.asyncId;
                                    $scope.isEnablePoller = result.isEnablePollar;
                                    $scope.progressCounter = result.progCounter;
                                    if($scope.asyncId != null) {
                                         $scope.checkTriggerDeploymentStatus($scope.progressCounter);
                                    }
                                    if(result.lstPageMessagesWrapper != null) {
                                        angular.forEach(result.lstPageMessagesWrapper, function(value, key) {
                                               $scope.typeStatusMessage = value.typeOfMessage;
                                               if(value.typeOfMessage == 'Confirm') {
                                                   $scope.statusMessage = value.triggerStatusMessage;
                                                   $scope.enablePoller = false;
                                                   $scope.showSuccessPanel = true;
                                               } else if(value.typeOfMessage == 'Error') {
                                                   $scope.statusMessage = value.triggerStatusMessage;
                                                   $scope.enablePoller = false;
                                                   $scope.showErrorPanel = true;
                                                   console.log('$scope.statusMessage',$scope.statusMessage);
                                               } else if(value.typeOfMessage == 'Warning') {
                                                   $scope.statusMessage = value.triggerStatusMessage;
                                                   $scope.enablePoller = false;
                                                   $scope.showWarningPanel = true;
                                               }
                                            });
                                    }
                                }
                                $scope.$apply();
                            } 
                        }, {
                            escape: false
                           }
                    );
                }

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
                                console.log('$$$$ result',result);
                                $scope.showSuccessPanel = false;
                                $scope.showErrorPanel = false;
                                $scope.showWarningPanel = false;
                                $scope.resultedProgressCounter = result.progCounter;
                                
                                if($scope.resultedProgressCounter != 100) {
                                    $scope.enablePoller = true;
                                    $scope.checkTriggerDeploymentStatus($scope.resultedProgressCounter);
                                } else if($scope.resultedProgressCounter == 100) {
                                    $scope.enablePoller = false;
                                }
                                
                                if(result.lstPageMessagesWrapper != null) {
                                    angular.forEach(result.lstPageMessagesWrapper, function(value, key) {
                                       $scope.typeStatusMessage = value.typeOfMessage;
                                       if(value.typeOfMessage == 'Confirm') {
                                           $scope.statusMessage = value.triggerStatusMessage;
                                           $scope.showSuccessPanel = true;
                                       } else if(value.typeOfMessage == 'Error') {
                                           $scope.statusMessage = value.triggerStatusMessage;
                                           $scope.showErrorPanel = true;
                                       } else if(value.typeOfMessage == 'Warning') {
                                           $scope.statusMessage = value.triggerStatusMessage;
                                           $scope.showWarningPanel = true;
                                       }
                                       
                                    });
                                }
                                $scope.$apply();
                            }
                        }, {
                            escape: false
                           }
                    );
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
            