function getHistoryRecordsForObject() {
            selectedObj = $(".object option:selected").val();
            startDate =  $('.startDate').val();
            endDate = $('.endDate').val();
            selectedObjLabel = $(".object option:selected").text();
            angular.element(document.getElementById('displayHistoryRecord')).scope().getRecords();
        }
        function hideDateFormat() {
            $(".dateFormat").hide();
        }
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
                    if($(".TxtDays").val()==0){
                        $(".TxtDays").val(30);
                    }
                }
                else{
                    $(".NumberOfDay").hide();
                }
        }
        function checkDayValue() {
        
            if($(".TxtDays").val()==0){
                $("#DayError").html('Invalid Day');
            }
            else{
                 $("#DayError").html('');
                DateFileter();
            }
        }
        function validateDate(flag) {

            var startDate = $('.startDate').val();
            var endDate = $('.endDate').val();
            var msgs1 = [];
            var msgs2 = [];
            var msgElement1 = $("#dateErrorMessageStartDateDiv");
            var msgElement2 = $("#dateErrorMessageEndDateDiv");
            msgElement1.html('');
            msgElement2.html('');
            if (startDate !== null && startDate !== ''
                    && !isValidDate(startDate)) {
                msgs1.push('Invalid Start Date');
            }
            if (endDate !== null && endDate !== '' && !isValidDate(endDate)) {
                msgs2.push('Invalid End Date');
            }
            if (startDate !== null && startDate !== '' && endDate !== null
                    && endDate !== '' && !msgs1.length
                    && !isValidRange(startDate, endDate)) {
                msgs1.push('Invalid Date Range');
            }
            if (msgs1.length) {
                var msgHtml = '';
                for (i = 0; i < msgs1.length; i++) {
                    msgHtml += msgs1[i] + '</br>';
                }
                msgElement1.html(msgHtml);
            }
            if (msgs2.length) {
                var msgHtml = '';
                for (i = 0; i < msgs2.length; i++) {
                    msgHtml += msgs2[i] + '</br>';
                }
                msgElement2.html(msgHtml);
            } else if (!msgs1.length && !msgs2.length) {
                if (flag == true) {
                    DateFileter();
                    if ($(".dateRange option:selected").val != 'Custom') {
                        $(".dateRange option").each(function() {

                            if (this.value == 'Custom') {
                                this.selected = true;
                            }
                        });
                    }
                }
            } else {
                $(".dateRange option").each(function() {
                    if (this.value == 'Custom') {
                        this.selected = true;
                    }
                });
            }
        }
        function isValidRange(startDate, endDate) {
            if (Date.parse(startDate) > Date.parse(endDate)) {
                return false;
            }
            return true;
        }
        function isValidDate(dateValue) {
            if(dateValue.length > 10) {
                return false;
            }
             return true;
        }
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
			}
         });
		  $("body").css("overflow-y", "hidden");
         $('.ui-widget-overlay').css('background', '#101010');
         return false; 
       }
       function hideAndShow(){
         $('.DialogPanelClass').hide();
       }
       
        function replaceImageTagwithAnchor(str){
            if (str != null || str!=undefined ){                    
                var urlPattern = /(http|ftp|https):\/\/[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:\/~+#-]*[\w@?^=%&amp;\/~+#-])?/gi;
                var imgArr=str.match("<img[^>]+><\/img>");
                    while(imgArr!=null && imgArr.length>0){
                    var href=imgArr[0].match(urlPattern)[0];
                    var selected=str.substr(str.indexOf(imgArr[0]),imgArr[0].length);
                   // str= str.replace(selected,"<b style=font-style: normal;display: block;">Image</b>:<a href='"+href+"' target='_blank' style='font-style: normal;'>"+href+"</a>");
					str= str.replace(selected,"<br/><b class='boldTag'>Image</b>:<a class='anchorLink' href='"+href+"' target='_blank' style='font-style: normal !important;'>"+href+"</a>");
                    imgArr=str.match("<img[^>]+><\/img>");
                }                        
            }
            return str;
	
        }
    
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
    