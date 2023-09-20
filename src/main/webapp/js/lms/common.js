
function initDatePicker(tag){

	tag.forEach(function(dataPicker){
		$(dataPicker).datepicker({
			showOn: "button",
			buttonImage: "../images/admin/ico/icon_calendar1.png",
			buttonImageOnly: true, // 버튼에 있는 이미지만 표시한다.
			nextText: '다음 달', // next 아이콘의 툴팁.
			prevText: '이전 달', // prev 아이콘의 툴팁.
			stepMonths: 1, // next, prev 버튼을 클릭했을때 얼마나 많은 월을 이동하여 표시하는가. 
			dateFormat: "yy-mm-dd", // 텍스트 필드에 입력되는 날짜 형식.
			showAnim: "slide", //애니메이션을 적용한다.
			showMonthAfterYear: true, // 월, 년순의 셀렉트 박스를 년,월 순으로 바꿔준다. 
			dayNamesMin: ['일','월', '화', '수', '목', '금', '토'], // 요일의 한글 형식.
			monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'] // 월의 한글 형식.
		});
	});		
}

function openDialog(options){
	
	//console.log('title:' + options.title, ' width:' + options.width, ' height:' + options.height, + 'resizable' + options.resizable, ' url:' + options.url);
	
    $("#dialog").dialog({

    	title:options.title,
        autoOpen:false, //자동으로 열리지않게
        position:{my:"center"}, //x,y  값을 지정
        //"center", "left", "right", "top", "bottom"
        modal:true, //모달대화상자
        resizable:false, //크기 조절 못하게
        width:options.width,
        height:options.height,
        
        open: function() { 
        	$('#popContent').width($(this).width()-10); 
			$('#popContent').height($(this).height()-10); 
			
			if(options.closebtn == 'remove'){
				$(this).dialog().parents(".ui-dialog").find(".ui-dialog-titlebar-close").remove();
			}
		},
		close: function(){
			$('#popContent').attr('src','');
			$('#dialog').dialog('destroy');
		} 
    });
    
    $('#popContent').attr({src: options.url}).show();
    $("#dialog").dialog("open");
}

function validateInputVal(option, tag){
	
	var inputVal = $(tag).val();
	var regex = '';
	
	if(option == 'ko_num'){
		regex = /[^가-힣0-9]/gi;
	}else if(option == 'ko_num_blank'){
		regex = /[^가-힣0-9 ]/gi;
	}else if(option == 'en_num'){
		regex = /[^a-z0-9]/gi;
	}else if(option == 'en_num_blank'){
		regex = /[^a-z0-9 ]/gi;
	}else if(option == 'ko_en_num'){
		regex = /[^가-힣a-z0-9]/gi;
	}else if(option == 'ko_en_num_blank'){
		regex = /[^가-힣a-z0-9 ]/gi;
	}else if(option == 'ko'){
		regex = /[^가-힣]/gi;
	}else if(option == 'en'){
		regex = /[^a-z]/gi;
	}else if(option == 'num'){
		regex = /[^0-9]/gi;
	}else if(option == 'en_num_bar'){
		regex = /[^0-9a-zA-Z\-_]/gi;
	}
	
	$(tag).val(inputVal.replace(regex,''));
}

function isBlank(varName, inputTag){
	
	var inputVal = $(inputTag).val();
	
	if(inputVal == ''){
		alert_popup_focus(varName + '을(를) 입력해주세요.',inputTag);
		//$(inputTag).focus();
		return true;
	}
	return false;
}

function checkUseAuth(useAuth, insertBtnTages, updateBtnTages, deleteBtnTages){
	
	if(useAuth != null){
		
		if(useAuth.insert_yn == 'Y' && insertBtnTages != null){
			insertBtnTages.forEach(function(btn){
				btn.show();
			});					
		}
		
		if(useAuth.update_yn == 'Y' && updateBtnTages != null){
			updateBtnTages.forEach(function(btn){
				btn.show();
			});				
		}
		
		if(useAuth.delete_yn == 'Y' && deleteBtnTages != null){
			deleteBtnTages.forEach(function(btn){
				btn.show();
			});			
		}
	}
}
//연결 리스트
function linkedListNode(value) {
    this.value = value;
    this.next = null;
}

function LinkedList() {
	
	this.head = null;
    this.length = 0;
    
    this.append = function(value) {
        var node = new linkedListNode(value);
        var current = this.head;
        if (!current) { // 리스트가 비어있음
            this.head = node;
            this.length++;
            return node;
        } else {
            while (current.next) { //리스트의 끝을 찾아서
                current = current.next;
            }
            current.next = node; //끝에 추가
            this.length++;
            return node;
        }
    }
    
    this.find = function(position) {
    	var current = this.head;
    	var count = 0;
        while (count < position) {
            current = current.next;
            count++;
        }
        return current? current.value : null;
    }
    
    this.remove = function(position) {
    	var current = this.head;
    	var before;
        var remove;
        var count = 0;
        if (position == 0) { //제일 앞 삭제
            remove = this.head;
            this.head = this.head.next;
            this.length--;
            return remove;
        } else {
            while (count < position) {
                before = current;
                count++;
                current = current.next;
            }
            remove = current;
            before.next = remove? remove.next : null;
            this.length--;
            return remove;
        }
    }
}

function alert_popup(mesg, href, form){
	
	var el = "#layer99"
	var cls = "alertCls"
    var $el = $(el);    //레이어의 id를 $el 변수에 저장
    var isDim = $el.prev().hasClass('dimBgg'); //dimmed 레이어를 감지하기 위한 boolean 변수
    isDim ? $("."+cls).fadeIn() : $el.fadeIn();
    
    var lp = $(el);
    var lpObj = lp.children(".pop-container");
    var lpObjClose = lp.find(".btn-layerClose");
    var lpObjTabbable = lpObj.find("button, input:not([type='hidden']), select, iframe, textarea, [href], [tabindex]:not([tabindex='-1'])");
    
    setTimeout(function(){
    $('#cancelAlert').focus();
    },500);
    var lpObjTabbableFirst = lpObjTabbable && lpObjTabbable.first();
    var lpObjTabbableLast = lpObjTabbable && lpObjTabbable.last();
    var lpOuterObjHidden = $("#skip_navigation, #compaVcHead, .cont_cv"); // 레이어 바깥 영역의 요소
    var all = $("#compaVcHead, .foot_cv").add(lp);
    var tabDisable;
    var nowScrollPos = $(window).scrollTop();

    var $elWidth = ~~($el.outerWidth()),
        $elHeight = ~~($el.outerHeight()),
        docWidth = $(document).width(),
        docHeight = $(document).height();
    $("."+cls+" #alertTxt").text("");
    $("."+cls+" #alertTxt").text(mesg);
    // 화면의 중앙에 레이어를 띄운다.
    if ($elHeight < docHeight || $elWidth < docWidth) {
        $el.css({
            marginTop: -$elHeight /2,
            marginLeft: -$elWidth/2
        })
    } else {
        $el.css({top: 0, left: 0});
    }
    
    $el.find('#cancelAlert').click(function(){ // 레이어 닫기 함수
    	if(form !==undefined){
    		form.submit(); 	
    		return false;
    	}
    	else if(href !== undefined ){
    		location.href = href;
    		return false;
    	}else{
    		isDim ? $("."+cls).fadeOut() : $el.fadeOut(); // 닫기 버튼을 클릭하면 레이어가 닫힌다.
            $("body").removeClass("scroll-off").css("top", "").off("scroll touchmove mousewheel");
            $(window).scrollTop(nowScrollPos); // 레이어 닫은 후 화면 최상단으로 이동 방지
            if (tabDisable === true) lpObj.attr("tabindex", "-1");
            all.removeClass("on");
            lpOuterObjHidden.removeAttr("aria-hidden");
            $(document).off("keydown.lp_keydown");
    	}
    });
    
    $el.find('.btn-layerClose').click(function(){ // 레이어 닫기 함수
    	if(form !==undefined){
    		form.submit();
    		return false;
    	}
    	else if(href !== undefined ){
    		location.href = href;
    		return false;
    	}else{
    		isDim ? $("."+cls).fadeOut() : $el.fadeOut(); // 닫기 버튼을 클릭하면 레이어가 닫힌다.
            $("body").removeClass("scroll-off").css("top", "").off("scroll touchmove mousewheel");
            $(window).scrollTop(nowScrollPos); // 레이어 닫은 후 화면 최상단으로 이동 방지
            if (tabDisable === true) lpObj.attr("tabindex", "-1");
            all.removeClass("on");
            lpOuterObjHidden.removeAttr("aria-hidden");
            $(document).off("keydown.lp_keydown");
    	}
    });

    $(this).blur();
    all.addClass("on");        
    lpOuterObjHidden.attr("aria-hidden", "true"); // 레이어 바깥 영역을 스크린리더가 읽지 않게
    lpObjTabbable.length ? lpObjTabbableFirst.focus().on("keydown", function(event) { 
        // 레이어 열리자마자 초점 받을 수 있는 첫번째 요소로 초점 이동
        if (event.shiftKey && (event.keyCode || event.which) === 9) {
            // Shift + Tab키 : 초점 받을 수 있는 첫번째 요소에서 마지막 요소로 초점 이동
            event.preventDefault();
            lpObjTabbableLast.focus();
        }
    }) : lpObj.attr("tabindex", "0").focus().on("keydown", function(event){
        tabDisable = true;
        if ((event.keyCode || event.which) === 9) event.preventDefault();
        // Tab키 / Shift + Tab키 : 초점 받을 수 있는 요소가 없을 경우 레이어 밖으로 초점 이동 안되게
    });

    lpObjTabbableLast.on("keydown", function(event) {
        if (!event.shiftKey && (event.keyCode || event.which) === 9) {
            // Tab키 : 초점 받을 수 있는 마지막 요소에서 첫번째 요소으로 초점 이동
            event.preventDefault();
            lpObjTabbableFirst.focus();
        }
    });
  
/*
    $el.attr("tabindex", 0).focus();
    
    $el.find('.btn-layerClose').click(function(){
    	if(form !==undefined){
    		form.submit(); 	
    	}else{
    		isDim ? $("."+cls).fadeOut() : $el.fadeOut(); // 닫기 버튼을 클릭하면 레이어가 닫힌다.
    	}
    	if(href !==undefined){
    		location.href = href;
    	}else if (href == undefined &&  form !==undefined ){
    		isDim ? $("."+cls).fadeOut() : $el.fadeOut(); // 닫기 버튼을 클릭하면 레이어가 닫힌다.
    	}else{
    		isDim ? $("."+cls).fadeOut() : $el.fadeOut(); // 닫기 버튼을 클릭하면 레이어가 닫힌다.
    	}
        return false;
    });

    $el.find('#cancelAlert').click(function(){
    	if(form !==undefined){
    		form.submit(); 	
    	}else{
    		isDim ? $("."+cls).fadeOut() : $el.fadeOut(); // 닫기 버튼을 클릭하면 레이어가 닫힌다.
    	}
    	if(href !== undefined ){
    		location.href = href;
    	}else if (href == undefined &&  form !==undefined){
    		isDim ? $("."+cls).fadeOut() : $el.fadeOut(); // 닫기 버튼을 클릭하면 레이어가 닫힌다.
    	}else{
    		isDim ? $("."+cls).fadeOut() : $el.fadeOut(); // 닫기 버튼을 클릭하면 레이어가 닫힌다.
    	}
        return false;
    });

    $('.layer .dimBg').click(function(){
        $("."+cls).fadeOut();
        return false;
    });
    */
    
}



//팝업 포커스문제로 인해서 함수 추가
function alert_popup_focus(mesg,op){
	
	var el = "#layer99"
	var cls = "alertCls"
    var $el = $(el);    //레이어의 id를 $el 변수에 저장
    var isDim = $el.prev().hasClass('dimBgg'); //dimmed 레이어를 감지하기 위한 boolean 변수
    isDim ? $("."+cls).fadeIn() : $el.fadeIn();
    
    var lp = $(el);
    var lpObj = lp.children(".pop-container");
    var lpObjClose = lp.find(".btn-layerClose");
    var lpObjTabbable = lpObj.find("button, input:not([type='hidden']), select, iframe, textarea, [href], [tabindex]:not([tabindex='-1'])");
    var lpObjTabbableFirst = lpObjTabbable && lpObjTabbable.first();
    var lpObjTabbableLast = lpObjTabbable && lpObjTabbable.last();
    var lpOuterObjHidden = $("#skip_navigation, #compaVcHead, .cont_cv"); // 레이어 바깥 영역의 요소
    var all = $("#compaVcHead, .foot_cv").add(lp);
    var tabDisable;
    var nowScrollPos = $(window).scrollTop();
   
    var $elWidth = ~~($el.outerWidth()),
    $elHeight = ~~($el.outerHeight()),
    docWidth = $(document).width(),
    docHeight = $(document).height();
	$("."+cls+" #alertTxt").text("");
	$("."+cls+" #alertTxt").text(mesg);
	// 화면의 중앙에 레이어를 띄운다.
	if ($elHeight < docHeight || $elWidth < docWidth) {
	    $el.css({
	        marginTop: -$elHeight /2,
	        marginLeft: -$elWidth/2
	    })
	} else {
	    $el.css({top: 0, left: 0});
	}
    $el.find('#cancelAlert').click(function(){ // 레이어 닫기 함수
    	isDim ? $("."+cls).fadeOut() : $el.fadeOut(); // 닫기 버튼을 클릭하면 레이어가 닫힌다.
        $("body").removeClass("scroll-off").css("top", "").off("scroll touchmove mousewheel");
        $(window).scrollTop(nowScrollPos); // 레이어 닫은 후 화면 최상단으로 이동 방지
        if (tabDisable === true) lpObj.attr("tabindex", "-1");
        all.removeClass("on");
        lpOuterObjHidden.removeAttr("aria-hidden");
     	setTimeout(function(){
        	$(op).focus();
           }, 500);// 레이어 닫은 후 원래 있던 곳으로 초점 이동
        $(document).off("keydown.lp_keydown");
    });
    
    function lpClose() { // 레이어 닫기 함수
    	isDim ? $("."+cls).fadeOut() : $el.fadeOut(); // 닫기 버튼을 클릭하면 레이어가 닫힌다.
        $("body").removeClass("scroll-off").css("top", "").off("scroll touchmove mousewheel");
        $(window).scrollTop(nowScrollPos); // 레이어 닫은 후 화면 최상단으로 이동 방지
        if (tabDisable === true) lpObj.attr("tabindex", "-1");
        all.removeClass("on");
        lpOuterObjHidden.removeAttr("aria-hidden");
        setTimeout(function(){
        	$(op).focus();
           }, 500);// 레이어 닫은 후 원래 있던 곳으로 초점 이동
        $(document).off("keydown.lp_keydown");
    }

    $(this).blur();
    all.addClass("on");        
    lpOuterObjHidden.attr("aria-hidden", "true"); // 레이어 바깥 영역을 스크린리더가 읽지 않게
    lpObjTabbable.length ? lpObjTabbableFirst.focus().on("keydown", function(event) { 
        // 레이어 열리자마자 초점 받을 수 있는 첫번째 요소로 초점 이동
        if (event.shiftKey && (event.keyCode || event.which) === 9) {
            // Shift + Tab키 : 초점 받을 수 있는 첫번째 요소에서 마지막 요소로 초점 이동
            event.preventDefault();
            setTImeout(function(){
            	lpObjTabbableLast.focus();
            },500);
        }
    }) : lpObj.attr("tabindex", "0").focus().on("keydown", function(event){
        tabDisable = true;
        if ((event.keyCode || event.which) === 9) event.preventDefault();
        // Tab키 / Shift + Tab키 : 초점 받을 수 있는 요소가 없을 경우 레이어 밖으로 초점 이동 안되게
    });

    lpObjTabbableLast.on("keydown", function(event) {
        if (!event.shiftKey && (event.keyCode || event.which) === 9) {
            // Tab키 : 초점 받을 수 있는 마지막 요소에서 첫번째 요소으로 초점 이동
            event.preventDefault();
            setTImeout(function(){
            	lpObjTabbableFirst.focus();
            },500);
        }
    });
  
    lpObjClose.on("click", lpClose); // 닫기 버튼 클릭 시 레이어 닫기
    
    $(document).on("keydown.lp_keydown", function(event) {
        // Esc키 : 레이어 닫기
        var keyType = event.keyCode || event.which;
      
        if (keyType === 27 && lp.hasClass("on")) {
          lpClose();
        }
    });
}



