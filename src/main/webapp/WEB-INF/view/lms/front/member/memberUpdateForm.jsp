<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<script>
$(document).on('ready', function() {
	setTimeout(function(){
		$('#btnUpdatePw').focus();
	}, 500);
	
});
    
	var samePwCheck = false;		//동일 비밀번호 여부 체크
	var bizRegnoCheck = false;		//사업자등록번호 중복검사 체크
	$(document).ready(function(){
		dataLoad();
		$('#btnUpdatePw').click(function() {
			$('#currentPw').val('');
			$('#newPw').val('');
			$('#newPwCheck').val('');
			var $href = $(this).attr('href');
			var cls = "pwdCls";
			var op = $(this);
	        layer_popup($href, cls, op);
		});
		
		//사업자등록번호 중복체크 클릭
		$('#btnBizRegnoCheck').click(function() {
			fncDoubleCheck("BR");
		});
		$('#btnSubmit').click(function() {
			fncUpdatePrivacy();
		});

		//코드검색
		$('#stdClassSrch').click(function() {
			var $href = $(this).attr('href');
			var cls = "stdCls";
			var op = $(this);
	        layer_popup($href, cls, op);
		});
		
		$('#btnUpdatePwd').click(function() {
			fncUpdatePw();
		});

		//연구개발서비스 아이디 검색
		$('#btnBizSearch').click(function(){
			fncCheckRnd();
		});
		
		$.datepicker.setDefaults($.datepicker.regional['ko']); 
        $( "#est_date" ).datepicker({
             changeMonth: true, 
             changeYear: true,
             nextText: '다음 달',
             prevText: '이전 달', 
             dayNames: ['일요일', '월요일', '화요일', '수요일', '목요일', '금요일', '토요일'],
             dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'], 
             monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
             monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
             dateFormat: "yy-mm-dd",
             //maxDate: 0,                       // 선택할수있는 최소날짜, ( 0 : 오늘 이후 날짜 선택 불가)
             onClose: function( selectedDate ) {    
                  //시작일(startDate) datepicker가 닫힐때
                  //종료일(endDate)의 선택할수있는 최소 날짜(minDate)를 선택한 시작일로 지정
                 //$("#endDate").datepicker( "option", "minDate", selectedDate );
             }    

        });

		fncStdCheck();
	});
	
	//[회원가입] - 아이디 및 사업자등록번호 중복확인 -> 2021/04/16 - 추정완
	function fncDoubleCheck(gubun) {
		if(gubun == 'ID') {
			var id = $('#memberId').val();
			console.log('id : ' + id);
			if(id == '') {
				alert_popup('아이디를 입력 후 중복확인 버튼을 클릭해주세요.');
				return false;
			}
			$.ajax({
				type : 'POST',
				url : '/front/memberDoubleCheck.do',
				data : {
					gubun : gubun,
					id : id
				},
				dataType : 'json',
				success : function(transport) {
					var memberCount = transport.memberCount;
					if(memberCount == '1') {
						alert_popup('중복된 아이디가 있습니다. 다른 아이디를 사용해주세요.');
						idCheck = false;
					}
					else{
						alert_popup('사용가능한 아이디 입니다.');
						idCheck = true;
					}					
					
				},
				error : function() {
					
				},
				complete : function() {
					
				}
			});
		}
		else{
			var bizRegno = $('#bizRegno').val();
			console.log('bizRegno : ' + bizRegno);
			if(bizRegno == '') {
				alert_popup_focus('사업자등록번호를 입력 후 중복여부 버튼을 클릭해주세요.','#bizRegno');
				return false;
			}
			$.ajax({
				type : 'POST',
				url : '/front/memberDoubleCheck.do',
				data : {
					gubun : gubun,
					biz_regno : bizRegno
				},
				dataType : 'json',
				success : function(transport) {
					var bizRegnoCount = transport.bizRegnoCount;
					if(bizRegnoCount == '1') {
						alert_popup_focus('중복된 사업자등록번호 입니다. 다시 확인해주세요.','#bizRegno');
						bizRegnoCheck = false;
					}
					else{
						alert_popup_focus('사용 가능한 사업자등록번호 입니다.','#bizRegno');
						bizRegnoCheck = true;
					}
				},
				error : function() {
					
				},
				complete : function() {
					
				}
			});
		}
	}
	
	//[회원가입] - 사업장 주소 -> 2021/04/19 - 추정완
	function fncMemberAddress() {
        new daum.Postcode({
            oncomplete: function(data) {
            	var addr = ''; 		// 주소 변수
            	var zipcode = '';	// 우편번호 변수

                //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
                if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                    addr = data.roadAddress;
                } else { // 사용자가 지번 주소를 선택했을 경우(J)
                    addr = data.jibunAddress;
                }
            	
            	zipcode = data.zonecode;
            	
            	console.log('addr : ' + addr);
            	console.log('zipcode : ' + zipcode);
            	
            	$('#zipcode').val(zipcode);
            	$('#address1').val(addr);
            	setTimeout(function(){
            		$('#address2').focus();
            	}, 500);
            	
            }
        }).open();
    }
	
	//[회원가입] - 회원가입 -> 2021/04/19 - 추정완
	function fncUpdatePrivacy() {
		if(!isBlank('사업자등록번호', '#bizRegno'))
		if(!isBlank('표준산업분류코드_대분류', '#stdClassCd1'))
		if(!isBlank('표준산업분류코드_중분류', '#stdClassCd2'))
		if(!isBlank('표준산업분류코드_소분류', '#stdClassCd3'))	
		if(!isBlank('기업명', '#bizName'))
		if(!isBlank('대표자명', '#owner'))
		if(!isBlank('일반전화번호1', '#telNo1'))
		if(!isBlank('일반전화번호2', '#telNo2'))
		if(!isBlank('일반전화번호3', '#telNo3'))
		if(!isBlank('우편번호', '#zipcode'))
		if(!isBlank('주소', '#address1'))
		if(!isBlank('상세주소', '#address2'))
		if(!isBlank('이름', '#userName'))
		if(!isBlank('휴대전화번호1', '#userMobileNo1'))
		if(!isBlank('휴대전화번호2', '#userMobileNo2'))
		if(!isBlank('휴대전화번호3', '#userMobileNo3'))
		if(!isBlank('이메일주소', '#userEmail1'))
		if(!isBlank('이메일주소2', '#userEmail2'))
		if(!isBlank('부서', '#userDepart'))
		if(!isBlank('직위', '#userRank')){
			$.ajax({
				type : 'POST',
				url : '/front/updatePrivacy.do',
				data : $('#frm').serialize(),
				dataType : 'json',
				beforeSend: function() {
					$('.wrap-loading').css('display', 'block');
				},
				success : function() {
					alert_popup("정상적으로 수정 되었습니다.","/front/memberUpdatePage.do");
					//location.reload();
				},
				error : function() {
					
				},
				complete : function() {
					
				}
			})
		}
	}

	function fncChangeEmail(obj){
		var selValue = obj.value;
		if(selValue == "직접입력" || selValue == ""){
			$('#userEmail2').val("");
		}else{
			$('#userEmail2').val(selValue);
		}
	}
	
    //공급기관 팝업띄우기
    function layer_popup(el, cls,op){
        var $el = $(el);    //레이어의 id를 $el 변수에 저장
        var $op = $(op);    //레이어의 id를 $el 변수에 저장
        var isDim = $el.prev().hasClass('dimBg'); //dimmed 레이어를 감지하기 위한 boolean 변수

        isDim ? $("."+cls).fadeIn() : $el.fadeIn();

        var inputId = $("."+cls).find("input").first().attr('id');
	    setTimeout(function(){
	    	$('#'+inputId).focus();
	        }, 500);
	    
	    var $elWidth = ~~($el.outerWidth()),
	        $elHeight = ~~($el.outerHeight()),
	        docWidth = $(document).width(),
	        docHeight = $(document).height();
	
	    // 화면의 중앙에 레이어를 띄운다.
	    if ($elHeight < docHeight || $elWidth < docWidth) {
	        $el.css({
	            marginTop: -$elHeight /2,
	            marginLeft: -$elWidth/2
	        })
	    } else {
	        $el.css({top: 0, left: 0});
	    }
	    $('#skip_navigation').find("input, a, button").attr('tabindex','-1');
        $('#compaVcHead').find("input, a, button").attr('tabindex','-1');
        $('#compaVcContent').find("input, a, button").attr('tabindex','-1');
        $('#wra-loading').find("input, a, button").attr('tabindex','-1');
        $('#scroll-top').find("input, a, button").attr('tabindex','-1');
	    $('#compaVcFoot').find("input, a, button").attr('tabindex','-1');

	    //esc키 버튼 입력시 통보 없애기
	    $(document).keydown(function(event) {
	        if ( event.keyCode == 27 || event.which == 27 ) {
	        	$('#skip_navigation').find("input, a, button").removeAttr('tabindex');
	            $('#compaVcHead').find("input, a, button").removeAttr('tabindex');
	            $('#compaVcContent').find("input, a, button").removeAttr('tabindex');
	            $('.wrap-loading').find("input, a, button").attr('tabindex','-1');
	            $('.scroll-top').find("input, a, button").removeAttr('tabindex');
	    	    $('#compaVcFoot').find("input, a, button").removeAttr('tabindex');
	        	isDim ? $('.dim-layer').fadeOut() : $el.fadeOut(); // 닫기 버튼을 클릭하면 레이어가 닫힌다.
	        	setTimeout(function(){
	            	$op.focus();
	               }, 500);
	            return false;
	        }
	    });

        $el.find('a.btn-layerClose').click(function(){
            isDim ? $("."+cls).fadeOut() : $el.fadeOut(); // 닫기 버튼을 클릭하면 레이어가 닫힌다.
            $('#skip_navigation').find("input, a, button").removeAttr('tabindex');
            $('#compaVcHead').find("input, a, button").removeAttr('tabindex');
            $('#compaVcContent').find("input, a, button").removeAttr('tabindex');
            $('.wrap-loading').find("input, a, button").attr('tabindex','-1');
            $('.scroll-top').find("input, a, button").removeAttr('tabindex');
    	    $('#compaVcFoot').find("input, a, button").removeAttr('tabindex');
    	    setTimeout(function(){
    	    	$op.focus();
    	    }, 500);
            return false;
        });

        $('.layer .dimBg').click(function(){
            $("."+cls).fadeOut();
            $('#skip_navigation').find("input, a, button").removeAttr('tabindex');
            $('#compaVcHead').find("input, a, button").removeAttr('tabindex');
            $('#compaVcContent').find("input, a, button").removeAttr('tabindex');
            $('.wrap-loading').find("input, a, button").removeAttr('tabindex');
            $('.scroll-top').find("input, a, button").removeAttr('tabindex');
    	    $('#compaVcFoot').find("input, a, button").removeAttr('tabindex');
    	    setTimeout(function(){
    	    	$op.focus();
    	    }, 500);
            return false;
        });
        $('#btnCancel').click(function(){
            $("."+cls).fadeOut();
            $('#skip_navigation').find("input, a, button").removeAttr('tabindex');
            $('#compaVcHead').find("input, a, button").removeAttr('tabindex');
            $('#compaVcContent').find("input, a, button").removeAttr('tabindex');
            $('.wrap-loading').find("input, a, button").removeAttr('tabindex');
            $('.scroll-top').find("input, a, button").removeAttr('tabindex');
    	    $('#compaVcFoot').find("input, a, button").removeAttr('tabindex');
    	    setTimeout(function(){
    	    	$op.focus();
    	    }, 500);
            return false;
        });
        
    }

    function doStdApply(){
        var valSelStdClassCd1 = $('#selStdClassCd1 option:selected').val();
        var valSelStdClassCd2 = $('#selStdClassCd2 option:selected').val();
        var valSelStdClassCd3 = $('#selStdClassCd3 option:selected').val(); 
        var valSelStdClassCd4 = $('#selStdClassCd4 option:selected').val(); 
        var valSelStdClassCd5 = $('#selStdClassCd5 option:selected').val(); 
        var selStdClassCd1 = $('#selStdClassCd1 option:selected').text();
        var selStdClassCd2 = $('#selStdClassCd2 option:selected').text();
        var selStdClassCd3 = $('#selStdClassCd3 option:selected').text();
        var selStdClassCd4 = $('#selStdClassCd4 option:selected').text();
        var selStdClassCd5 = $('#selStdClassCd5 option:selected').text();
        if(selStdClassCd1 == ""){
        	alert_popup('대분류를 선택 해주세요.');
        }else if(selStdClassCd2 == ""){
        	alert_popup('중분류를 선택 해주세요.');
        }else if(selStdClassCd3 == ""){
        	alert_popup('소분류를 선택 해주세요.');
        }else if(selStdClassCd4 == ""){
        	alert_popup('세분류를 선택 해주세요.');
        }else if(selStdClassCd5 == ""){
        	alert_popup('세세분류를 선택 해주세요.');
        }else{
           var code = valSelStdClassCd1+valSelStdClassCd5 ;
            $('#stdClassCd').attr('hiddenVal',code);
            $('#stdClassCd').val(code);
            $('#std_class_cd1').val(valSelStdClassCd1);
       	 	$('#std_class_cd2').val(valSelStdClassCd2);
       		$('#std_class_cd3').val(valSelStdClassCd3);
       		$('#std_class_cd4').val(valSelStdClassCd4);
       		$('#std_class_cd5').val(valSelStdClassCd5);
            $('.dim-layer').fadeOut();
            $('.compaLginCont').find("input, a, button").removeAttr('tabindex');
            $('#compaVcFoot').find("input, a, button").removeAttr('tabindex');
            setTimeout(function(){
            	$('#stdClassSrch').focus();
            }, 500);
        }
    }

	//비밀번호 변경 -> 2021/04/22 - 추정완
	function fncUpdatePw() {
		var cuurentPw = $('#currentPw').val();
		var newPw = $('#newPw').val();
		var newPwCheck = $('#newPwCheck').val();
		
		if(!isBlank('현재비밀번호', '#currentPw'))
		if(!isBlank('새 비밀번호', '#newPw'))
		if(!isBlank('새 비밀번호 확인', '#newPwCheck'))
		
		if(samePwCheck == false) {
			alert_popup('새 비밀번호를 확인해주세요.');
			return false;
		}
		else{
			$('#pw').val(cuurentPw);
		}
		
		$.ajax({
			type : 'POST',
			url : '/front/updatePw.do',
			data : $('#frm').serialize(),
			dataType : 'json',
			success : function(data) {
				var result_code = data.result_code;
				if(result_code == '0') {
					alert_popup('현재 비밀번호를 다시 한번 확인해주세요.');
				}
				else{
					alert_popup('비밀번호 변경 완료 했습니다.');
					$('.pwdCls').fadeOut();
					$('.compaLginCont').find("input, a, button").removeAttr('tabindex');
		            $('#compaVcFoot').find("input, a, button").removeAttr('tabindex');
		            setTimeout(function(){
		            	$('#btnUpdatePw').focus();
		            }, 500);
				}
			},
			error : function() {
				
			}
		});
	}
	
	//새 비밀번호 같은지 체크 -> 2021/04/22 - 추정완
	function fncSamePwCheck() {
		var newPw = $('#newPw').val();
		var newPwCheck = $('#newPwCheck').val();
	
		if(newPw != newPwCheck) {
			samePwCheck = false;
			$('#checkPwMsg').text('※입력하신 새 비밀번호가 서로 다릅니다.');
		}
		else{
			samePwCheck = true;
			$('#checkPwMsg').text('※입력하신 새 비밀번호가 같습니다.');
			$('#pwN').val(newPw);
		}
		
		if(newPw == '' && newPwCheck == '') {
			samePwCheck = false;
			$('#checkPwMsg').html('');
		}
	}

	function fncStdCheck(){
		console.log("어케나와","${userInfo.std_class_cd1}");
		var std1 = "${userInfo.std_class_cd1}";
		var std2 = "${userInfo.std_class_cd2}";
		if(std1 != "" && std1 != "선택"){
			fncChangeStd(std1,'mid');
		}

		if(std2 != "" && std2 != "선택"){
			fncChangeStd(std2,'sub');
		}
	}

    function fncChangeStd(obj, gubun){
		var selValue = obj.value;
		if(selValue == "" || selValue == "선택"){
			if(gubun == "mid"){
				$('#selStdClassCd2').empty();
				$('#selStdClassCd2').append("<option title='표준산업분류코드 중분류' value=''>선택</option>");
				$('#selStdClassCd2').attr('disabled', 'disabled');
				$('#selStdClassCd3').empty();
				$('#selStdClassCd3').append("<option title='표준산업분류코드 소분류' value=''>선택</option>");
				$('#selStdClassCd3').attr('disabled', 'disabled');
				$('#selStdClassCd4').empty();
				$('#selStdClassCd4').append("<option title='표준산업분류코드 소소분류' value=''>선택</option>");
				$('#selStdClassCd4').attr('disabled', 'disabled');
				$('#selStdClassCd5').empty();
				$('#selStdClassCd5').append("<option title='표준산업분류코드 소소소분류' value=''>선택</option>");
				$('#selStdClassCd5').attr('disabled', 'disabled');
			}else if(gubun == "sub"){
				$('#selStdClassCd3').empty();
				$('#selStdClassCd3').append("<option title='표준산업분류코드 소분류' value=''>선택</option>");
				$('#selStdClassCd3').attr('disabled', 'disabled');
				$('#selStdClassCd4').empty();
				$('#selStdClassCd4').append("<option title='표준산업분류코드 소소분류' value=''>선택</option>");
				$('#selStdClassCd4').attr('disabled', 'disabled');
				$('#selStdClassCd5').empty();
				$('#selStdClassCd5').append("<option title='표준산업분류코드 소소소분류' value=''>선택</option>");
				$('#selStdClassCd5').attr('disabled', 'disabled');
			}else if(gubun == "bot"){
				$('#selStdClassCd4').empty();
				$('#selStdClassCd4').append("<option title='표준산업분류코드 소소분류' value=''>선택</option>");
				$('#selStdClassCd4').attr('disabled', 'disabled');
				$('#selStdClassCd5').empty();
				$('#selStdClassCd5').append("<option title='표준산업분류코드 소소소분류' value=''>선택</option>");
				$('#selStdClassCd5').attr('disabled', 'disabled');
			}else if(gubun == "sub_bot"){
				$('#selStdClassCd5').empty();
				$('#selStdClassCd5').append("<option title='표준산업분류코드 소소소분류' value=''>선택</option>");
				$('#selStdClassCd5').attr('disabled', 'disabled');
			}
			console.log("넌왜안떠",$('#std_class_cd1').val);
			
		}else{
			$.ajax({
				type : 'POST',
				url : '/front/doGetStdCodeInfo.do',
				data : {
					parent_code_key : selValue,
					gubun : gubun
				},
				dataType : 'json',
				success : function(res) {
					var codeData = "";
					var aHtml = "";
					if(gubun == "mid"){
						codeData = res.stdCode;
						aHtml += "<option title='표준산업분류코드 중분류' value=''>선택</option>";
						$.each(codeData, function(key, val){
							aHtml += "<option title="+this.code_name+" value="+this.code_key+">"+this.code_name+"</option>";
						});
						
						$('#selStdClassCd2').empty();
						$('#selStdClassCd2').append(aHtml);
						$('#selStdClassCd2').removeAttr("disabled");
						
						aHtml = "<option title='표준산업분류코드 소분류' value=''>선택</option>";
						$('#selStdClassCd3').empty();
						$('#selStdClassCd4').empty();
						$('#selStdClassCd5').empty();
						$('#selStdClassCd3').append(aHtml);
						$('#selStdClassCd4').append(aHtml);
						$('#selStdClassCd5').append(aHtml);
						$('#selStdClassCd3').attr('disabled', 'disabled');
						$('#selStdClassCd4').attr('disabled', 'disabled');
						$('#selStdClassCd5').attr('disabled', 'disabled');
						
					}else if(gubun == "sub"){
						codeData = res.stdCode;

						aHtml += "<option title='표준산업분류코드 소소분류' value=''>선택</option>";
						$.each(codeData, function(key, val){
							aHtml += "<option title="+this.code_name+" value="+this.code_key+">"+this.code_name+"</option>";
						});
						$('#selStdClassCd3').empty();
						$('#selStdClassCd3').append(aHtml);
						$('#selStdClassCd3').removeAttr("disabled");

						aHtml = "<option title='표준산업분류코드 소소분류' value=''>선택</option>";
						$('#selStdClassCd4').empty();
						$('#selStdClassCd5').empty();
						$('#selStdClassCd4').append(aHtml);
						$('#selStdClassCd5').append(aHtml);
						$('#selStdClassCd4').attr('disabled', 'disabled');
						$('#selStdClassCd5').attr('disabled', 'disabled');
					}else if(gubun == "bot"){
						codeData = res.stdCode;

						aHtml += "<option title='표준산업분류코드 소소분류' value=''>선택</option>";
						$.each(codeData, function(key, val){
							aHtml += "<option title="+this.code_name+" value="+this.code_key+">"+this.code_name+"</option>";
						});
						$('#selStdClassCd4').empty();
						$('#selStdClassCd4').append(aHtml);
						$('#selStdClassCd4').removeAttr("disabled");
						aHtml = "<option title='표준산업분류코드 소소소분류' value=''>선택</option>";
						$('#selStdClassCd5').empty();
						$('#selStdClassCd5').append(aHtml);
						$('#selStdClassCd5').attr('disabled', 'disabled');
					}else if(gubun == "sub_bot"){
						codeData = res.stdCode;

						aHtml += "<option title='표준산업분류코드 소소소분류' value=''>선택</option>";
						$.each(codeData, function(key, val){
							aHtml += "<option title="+this.code_name+" value="+this.code_key+">"+this.code_name+"</option>";
						});
						$('#selStdClassCd5').empty();
						$('#selStdClassCd5').append(aHtml);
						$('#selStdClassCd5').removeAttr("disabled");
					}
				},
				error : function() {
					
				},
				complete : function() {
				}
			});
		}
    }
  //연구개발서비스 아이디 검색
    function fncCheckRnd(){
        var rnd_registno = $('#rnd_registno').val().trim();
        if(rnd_registno == ""){
        	alert_popup_focus("연구개발서비스협회 등록번호를 입력해주세요.","#rnd_registno");
            return;
            }
        $.ajax({
			type : 'POST',
			url : '/front/doGetRndBizno.do',
			data : {
				rnd_registno : rnd_registno
			},
			dataType : 'json',
			success : function(res) {
				//console.log(res,"나왓니");
				if(res.result >0){
					alert_popup_focus("사용가능한 연구개발서비스협회번호 입니다.","#rnd_registno");
					$('#sc_detail').css('display','block');
					}
				else if(res.result == 0){
					alert_popup_focus("연구개발서비스협회 등록번호를 다시 한번 확인해주세요.","#rnd_registno");
					}
				
			},
			error : function() {
				
			},
			complete : function() {
				
			}
		});
        }
    
    function popup(){
        var url = "/images/front/example.jpg";
        var name = "example Image";
        var option = "width = 500, height = 500, top = 100, left = 200, location = no "
        window.open(url, name, option);
    }
    function dataLoad(){
		var gubun = "${userInfo.rnd_registno}".trim();
		if(gubun !=""){
			$('#sc_detail').css('display','block');
			}
		var sc_sector = "${userInfo.sc_sector}".trim();
		var dc_sector = "${userInfo.dc_sector}".trim();
		if(sc_sector =='BS'){
			$('#sc_sector1').prop("checked",true);
			}
		else if(sc_sector=='TS'){
			$('#sc_sector2').prop("checked",true);
			}
		if(dc_sector =='BS'){
			$('#dc_sector1').prop("checked",true);	
		}
		else if(dc_sector=='TS'){
			$('#dc_sector2').prop("checked",true);
		}
        }
</script>
<!-- compaVcContent s:  -->
<div id="compaVcContent" class="cont_cv">
	<div id="mArticle" class="assig_app">
		<h2 class="screen_out">본문영역</h2>
		<div class="wrap_cont">
            <!-- page_title s:  -->
			<div class="area_tit">
				<h3 class="tit_corp">회원정보관리</h3>
			</div>
			<!-- //page_title e:  -->
			<!-- page_content s:  -->
			<form id="frm">
				<!-- 기업정보 필수 데이터-->
				<input type="hidden" name="biz_seqno" value="${userInfo.biz_seqno}">
				
				<!-- 담당자정보 필수 데이터 -->
				<input type="hidden" name="member_seqno" value="${userInfo.member_seqno}">
				<input type="hidden" name="id" value="${userInfo.id}">
				<input type="hidden" id="pw" name="pw">
				<input type="hidden" id="pwN" name="pw_n" >			
	            <div class="area_cont ">
	                <div class="subject_corp">
	                    <h4>기본정보</h4>
	                </div>
	                <div class="tbl_view tbl_public">
						<table class="tbl">
							<caption>개인정보변경 회원 기본정보</caption>
		                    <colgroup>
		                        <col style="width:15%">
		                        <col>
		                    </colgroup>
		                    <tbody class="view">
		                        <tr>
		                            <th>아이디</th>
		                            <td class="ta_left">
		                                ${userInfo.id}
		                            </td>
		                        </tr>
		                        <tr>
		                            <th>비밀번호</th>
		                            <td class="ta_left">
		                                <div class="form-inline">
		                                     <a href="#layer3" class="btn_step2" id="btnUpdatePw" title="비밀번호 변경">비밀번호변경</a>
		                                </div>
		                            </td>
		                        </tr>
		                    </tbody>
		                </table>
		            </div>
				</div>
	            <div class="area_cont area_cont2">
	                <div class="subject_corp w_top">
	                    <h4>기업정보</h4>
	                    <p class="es">* 표시는 필수 입력 사항입니다.</p>
	                </div>
	                <div class="tbl_view tbl_public">
						<table class="tbl">
							<caption >개인정보변경 회원 기업정보</caption>
		                    <colgroup>
		                        <col style="width:15%">
		                        <col>
		                        <col style="width:15%">
		                        <col>
		                    </colgroup>
		                    <tbody class="view">
		                        <tr>
		                            <th>표준산업분류코드 <span class="red">*</span></th>
		                            <td class="ta_left" colspan="3">
		                                <div class="form-inline" style="min-width:900px;">
		                                    <input type="text" class="form-control form_com_num" id="stdClassCd" name="std_class_cd" placeholder="세세분류(코드)" readonly="readonly" style="width:30%;" value="${userInfo.std_class_cd1 }${userInfo.std_class_cd5 }" title="표준산업분류코드">
		                                    <input type="hidden" id="std_class_cd1" name="std_class_cd1" value="${userInfo.std_class_cd1 }" title="표준산업분류코드1"/>
		                                    <input type="hidden" id="std_class_cd2" name="std_class_cd2" value="${userInfo.std_class_cd2 }" title="표준산업분류코드2"/>
		                                    <input type="hidden" id="std_class_cd3" name="std_class_cd3" value="${userInfo.std_class_cd3 }" title="표준산업분류코드3"/>
		                                    <input type="hidden" id="std_class_cd4" name="std_class_cd4" value="${userInfo.std_class_cd4 }" title="표준산업분류코드4"/>
		                                    <input type="hidden" id="std_class_cd5" name="std_class_cd5" value="${userInfo.std_class_cd5 }" title="표준산업분류코드5"/>
		                                    <a href="#layer2" class="btn_step2" id="stdClassSrch" title="표준산업분류코드 코드검색">코드검색</a>
		                                </div>
		                            </td>
		                        </tr>		                    
		                        <tr>
		                            <th>사업자등록번호</th>
		                            <td class="ta_left"  colspan="3">
		                                <div class="form-inline">
		                                    <input type="text" class="form-control form_com_num" id="bizRegno" name="biz_regno" value="${userInfo.biz_regno}" title="사업자등록번호">
		                                    <a href="javascript:void(0);" class="btn_step2" id="btnBizRegnoCheck" title="사업자등록번호 중복여부">중복여부</a>
		                                    <!-- <a href="javascript:void(0);" class="btn_step2">기업인증</a> -->
		                                </div>
		                            </td>
		                        </tr>
		                        <tr>
		                        	<th>기업유형</th>
		                            <td class="ta_left"   colspan="3">
		                                <div class="form-inline">
											<div class="box_radioinp">
												<input type="radio" class="inp_radio" name="biz_size" id="r1" value="MD0" title="중소기업" <c:if test="${userInfo.biz_size eq 'MD0'}">checked</c:if> />
												<label for="r1" class="lab_radio" title="중소기업">
													<span class="icon ico_radio"></span>중소기업
												</label>
											</div>
											<div class="box_radioinp">
												<input type="radio" class="inp_radio" name="biz_size" id="r2" value="MS0" title="중견기업" <c:if test="${userInfo.biz_size eq 'MS0'}">checked</c:if> />
												<label for="r2" class="lab_radio" title="중견기업">
													<span class="icon ico_radio"></span>중견기업
												</label>
											</div>
		                                </div>
		                            </td>
		                        </tr>		                        
		                        <tr>
		                            <th>기업명</th>
		                            <td class="ta_left"   colspan="3">
		                                <div class="form-inline">
		                                    <input type="text" class="form-control form_com_name" id="bizName" name="biz_name" size="30" value="${userInfo.biz_name}" title="기업명">
		                                </div>
		                            </td>
		                        </tr>
		                        <tr>
		                            <th>대표자명</th>
		                            <td class="ta_left"   colspan="3">
		                                <div class="form-inline">
		                                    <input type="text" class="form-control form_rep_name" id="owner" name="owner" size="30" value="${userInfo.owner}" title="대표자명">
		                                </div>
		                            </td>
		                        </tr>
		                        <tr>
		                            <th>일반전화번호</th>
		                            <td class="ta_left"   colspan="3">
		                                <div class="form-inline">
		                                	<c:set var="telNo" value="${fn:split(userInfo.tel_no, '-')}" />
		                                    <input type="text" class="form-control form_tel" id="telNo1" name="tel_no1"  size="3" value="${telNo[0]}" title="일반전화번호지역번호" > - <input type="text" class="form-control form_tel" id="telNo2" name="tel_no2" size="4" value="${telNo[1]}" title="일반전화번호 가운데자리"> - <input type="text" class="form-control form_tel" id="telNo3" name="tel_no3" size="4" value="${telNo[2]}" title="일반전화번호 마지막자리"> 
		                                </div>
		                            </td>
		                        </tr>
		                        <tr>
		                            <th>사업장 주소</th>
		                            <td class="ta_left"   colspan="3">
		                                <div class="form-inline">
		                                    <input type="text" class="form-control form_com_addr" id="zipcode" name="zipcode" size="10" placeholder="우편번호" value="${userInfo.zipcode}" title="우편번호">
		                                    <a href="javascript:fncMemberAddress();" class="btn_step2" title="새창 열림 우편번호 검색">우편번호검색</a>
		                                </div>
		                                <div class="form-inline">
		                                    <input type="text" class="form-control form_com_addr2" id="address1" name="address1" size="50" placeholder="주소" value="${userInfo.address1}" title="주소">
		                                </div>
		                                <div class="form-inline">
		                                    <input type="text" class="form-control form_com_addr2" id="address2" name="address2" size="50" placeholder="상세주소" value="${userInfo.address2}" title="상세주소">
		                                </div>
		                            </td>
		                        </tr>
		                        <tr>
		                        	<th>설립일 <span class="red">*</span></th>
		                        	<td><input type="text" id="est_date" name = "est_date" value="${userInfo.est_date }"  style="text-align : center;float:left; " hiddenVal="2021-04-13" autocomplete="off"  title="설립일"/> </td>
		                        	<th>소재지 <span class="red">*</span></th>
		                        	<td><input type="text" id="location" name="location" maxlength="20" value="${userInfo.location }" title="소재지"/> </td>
		                        </tr>
		                        <tr>
		                        	<th>업종 <span class="red">*</span></th>
		                        	<td><input type="text" id="biz_type" name="biz_type" maxlength="50" value="${userInfo.biz_type }" title="업종"/> </td>
		                        	<th>주요제품/서비스 <span class="red">*</span></th>
		                        	<td><input type="text" id="biz_item" name="biz_item" maxlength="50" value="${userInfo.biz_item }" title="주요제품/서비스"/> </td>
		                        </tr>
		                         <tr>
		                        	<th>종업원수 <span class="red">*</span></th>
		                        	<td><input type="text" id="employ_count" name="employ_count"  value="${userInfo.employ_count }" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" style="width:80%;float:left;" title="종업원수"/>명</td>
		                        	<th>매출액(직전년도) <span class="red">*</span></th>
		                        	<td><input type="text" id="sales_year" name="sales_year" value="${userInfo.sales_year }" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" style="width:70%;float:left;" title="매출액(직전년도)"/>&nbsp;&nbsp;(백만원) </td>
		                        </tr>
		                    </tbody>
		                </table>
		            </div>
				</div>
	            <div class="area_cont area_cont2">
	                <div class="subject_corp">
	                    <h4>담당자정보</h4>
	                </div>
	                <div class="tbl_view tbl_public">
						<table class="tbl">
							<caption >개인정보변경 담당자정보</caption>
		                    <colgroup>
		                        <col style="width:15%">
		                        <col>
		                    </colgroup>
		                    <tbody class="view">
		                        <tr>
		                            <th>이름</th>
		                            <td class="ta_left" >
		                                <div class="form-inline">
		                                    <input type="text" class="form-control form_man_name" id="userName" name="user_name" value="${userInfo.user_name}" title="담당자 이름">
		                                </div>
		                            </td>
		                        </tr>
		                        <tr>
		                            <th>휴대전화번호</th>
		                            <td class="ta_left" >
		                                <div class="form-inline">
		                                	<c:set var="mobileNo" value="${fn:split(userInfo.user_mobile_no, '-')}" />
		                                    <input type="text" class="form-control form_tel" id="userMobileNo1" name="user_mobile_no1" size="3" value="${mobileNo[0]}" title="담당자 휴대전화번호 식별번호"> - <input type="text" class="form-control form_tel" id="userMobileNo2" name="user_mobile_no2" size="4" value="${mobileNo[1]}" title="담당자 휴대전화번호 가운데자리"> - <input type="text" class="form-control form_tel" id="userMobileNo3" name="user_mobile_no3" size="4" value="${mobileNo[2]}"  title="담당자 휴대전화번호 마지막자리"/> 
		                                </div>
		                            </td>
		                        </tr>
		                        <tr>
		                            <th>이메일주소</th>
		                            <td class="ta_left" >
		                                <div class="form-inline">
		                                	<c:set var="userEmail" value="${fn:split(userInfo.user_email, '@')}" />
		                                    <input type="text" class="form-control form_email1" id="userEmail1" name="user_email1" value="${userEmail[0]}" title="담당자 이메일아이디">@<input type="text" class="form-control form_email2" id="userEmail2" name="user_email2" value="${userEmail[1]}" title="담당자 이메일도메인 직접입력">
		                                    <select class="form-control form_email3" id="userEmail3" name="user_email3" onChange="fncChangeEmail(this);" title="담당자 이메일도메인 선택">
		                                        <option title="직접입력">직접입력</option>
		                                        <option title="네이버">naver.com</option>
		                                        <option title="G메일">gmail.com</option>
		                                        <option title="다음">daum.net</option>
		                                    </select>
		                                </div>
		                            </td>
		                        </tr>
		                        <tr>
		                            <th>부서</th>
		                            <td class="ta_left" >
		                                <div class="form-inline">
		                                    <input type="text" class="form-control form_dept" id="userDepart" name="user_depart" value="${userInfo.user_depart}" title="담당자 부서">
		                                </div>
		                            </td>
		                        </tr>
		                        <tr>
		                            <th>직위</th>
		                            <td class="ta_left" >
		                                <div class="form-inline">
		                                    <input type="text" class="form-control form_spot" id="userRank" name="user_rank" value="${userInfo.user_rank}" title="담당자 직위">
		                                </div>
		                            </td>
		                        </tr>
		                    </tbody>
		                </table>
		            </div>   
				</div>
				<div class="area_cont area_cont2">
	                <div class="subject_corp">
	                    <h4>매칭신청용 정보 (수요기업)</h4>
	                </div>
	                <div class="tbl_view tbl_public">
						<table class="tbl">
							<caption>개인정보변경 매칭신청용 정보 (수요기업)</caption>
		                    <colgroup>
		                        <col style="width:15%">
		                        <col>
		                    </colgroup>
		                    <tbody class="view">
		                        <tr>
		                            <th>바우처서비스_요청분야</th>
		                            <td class="ta_left" >
		                                <div class="box_radioinp">
											<input type="radio" class="inp_radio" name="sc_sector"   id="sc_sector1" value="BS" title="사업화 지원">
											<label for="sc_sector1" class="lab_radio" title="사업화 지원"><span class="icon ico_radio"></span>사업화 지원</label>
										</div>
										<div class="box_radioinp">
											<input type="radio" class="inp_radio"  name = "sc_sector" id="sc_sector2" value="TS" title="기술개발 지원">
											<label for="sc_sector2" class="lab_radio" title="기술개발 지원"><span class="icon ico_radio"></span>기술개발 지원</label>
										</div>
		                            </td>
		                        </tr>
		                        <tr>
		                            <th>바우처서비스_요청상세</th>
		                            <td class="ta_left" >
		                                <div class="form-inline">
		                                    <textarea id="dc_sector_detail" name="dc_sector_detail" style="width:100%;height:200px;resize:none;" title="바우처서비스_요청상세">${userInfo.dc_sector_detail }</textarea> 
		                                </div>
		                            </td>
		                        </tr>
		                        <tr>
		                            <th>연구개발내용</th>
		                            <td class="ta_left" >
		                               <div class="form-inline">
		                                    <textarea id="dc_rnd_detail" name="dc_rnd_detail" style="width:100%;height:300px;resize:none;" title="연구개발내용">${userInfo.dc_rnd_detail }</textarea> 
		                                </div>
		                            </td>
		                        </tr>
		                    </tbody>
		                </table>
		            </div>   
				</div>
				<div class="area_cont area_cont2">
	                <div class="subject_corp" style="display:inline-block;">
	                    <h4>매칭신청용 정보 (공급기업)</h4><h6> *연구개발 서비스협회 등록번호를 등록하시는 경우 공급기업으로 참여가능합니다.</h6>
	                </div>
	                <div class="tbl_view tbl_public">
						<table class="tbl">
							<caption>개인정보변경 매칭신청용 정보 (공급기업)</caption>
		                    <colgroup>
		                        <col style="width:15%">
		                        <col>
		                    </colgroup>
		                    <tbody class="view">
		                        <tr>
		                            <th>연구개발서비스 협회 등록번호 </th>
		                            <td class="ta_left" >
		                                <input type="text" id="rnd_registno" name="rnd_registno" value="${userInfo.rnd_registno }" title="연구개발서비스 협회 등록번호 "/>
		                            </td>
		                            <td>
		                            	<!-- <button class="btn_step2" id="btnBizSearch" style="float:left;">검색</button>
		                            	<button onclick="popup();" class="btn_step2" style="float:left;" title="새창 열림2">?</button> -->
		                            	<a href="javascript:void(0);" class="btn_step2" id="btnBizSearch" style="float:left;" title="연구개발서비스 협회 등록번호 검색">검색</a>
		                            	<!-- <a href="javascript:void(0);" onclick="popup();"class="btn_step2" style="float:left;" title="새창열림 연구개발서비스 협회 등록번호 예시">?</a> -->
		                            </td>
		                        </tr>
		                    </tbody>
		                </table>
		            </div>   
				</div>
				<div class="area_cont area_cont2" id="sc_detail" style="display:none;">
	                <div class="tbl_view tbl_public">
						<table class="tbl">
							<caption>개인정보변경 서비스 수행기능</caption>
		                    <colgroup>
		                        <col style="width:15%">
		                        <col>
		                    </colgroup>
		                    <tbody class="view">
		                        <tr>
		                            <th>서비스 수행기능 분야</th>
		                            <td class="ta_left" >
		                                <div class="box_radioinp">
											<input type="radio" class="inp_radio" name="dc_sector"   id="dc_sector1" value="BS" title="사업화 지원">
											<label for="dc_sector1" class="lab_radio" title="사업화 지원"><span class="icon ico_radio"></span>사업화 지원</label>
										</div>
										<div class="box_radioinp">
											<input type="radio" class="inp_radio"  name = "dc_sector" id="dc_sector2" value="TS" title="기술개발 지원">
											<label for="dc_sector2" class="lab_radio" title="기술개발 지원"><span class="icon ico_radio"></span>기술개발 지원</label>
										</div>
		                            </td>
		                        </tr>
		                        <tr>
		                            <th>서비스 수행기능 상세</th>
		                            <td class="ta_left" >
		                                <div class="form-inline">
		                                    <textarea id="sc_sector_detail" name="sc_sector_detail" style="width:100%;height:200px;resize:none;" title="서비스 수행기능 상세">${userInfo.sc_sector_detail }</textarea> 
		                                </div>
		                            </td>
		                        </tr>
		                    </tbody>
		                </table>
		            </div>   
				</div>
			</form>
            <div class="wrap_btn _center">
                <a href="javascript:history.back();" class="btn_cancel" title="취소">취소</a>
                <a href="javascript:void(0);" id="btnSubmit" class="btn_confirm" title="저장">저장</a>
            </div>
			<!-- //page_content e:  -->
		</div>
	</div>
</div>
<!-- //compaVcContent e:  -->
<div class="wrap-loading" style="display:none;">
    <div><img src="/images/loading.gif" alt="로딩중"></div>
</div>
	<div class="dim-layer stdCls">
	    <div class="dimBg"></div>
	    <div id="layer2" class="pop-layer" style="height:500px">
	        <div class="pop-container">
	        <div class="pop-title"><h3>표준산업분류코드 검색</h3><a href="javascript:void(0);" class="btn-layerClose" title="표준산업분류코드 검색"><span class="icon ico_close" title="팝업닫기">팝업닫기</span></a></div>
	            <div class="pop-conts">
                <!--content //-->
				<p class="pop-info">표준산업분류코드를 선택하세요.</p>
				<div class="form-inline pop-search-box">
					<select class="form-control form_email3" id="selStdClassCd1" name="selStdClassCd1" onChange="fncChangeStd(this, 'mid');" style="max-width:340px;" title="표준산업분류코드">
						<option title="표준산업분류코드 대분류" value="">선택</option>
						<c:forEach var="data" items="${stdMainCode}" varStatus="status">
							<option title="${data.code_name}" value="${data.code_key}">${data.code_name}</option>
						</c:forEach>
					</select>
					<br />
					<select class="form-control form_email3" id="selStdClassCd2" name="selStdClassCd2" onChange="fncChangeStd(this, 'sub');" disabled style="min-width:340px; max-width:340px;" title="표준산업분류코드1">
						<option title="표준산업분류코드 중분류" value="">선택</option>
					</select>
					<br />
					<select class="form-control form_email3" id="selStdClassCd3" name="selStdClassCd3" onChange="fncChangeStd(this, 'bot');" disabled style="min-width:340px; max-width:340px;" title="표준산업분류코드2">
						<option title="표준산업분류코드 소분류" value="">선택</option>
					</select>
					<select class="form-control form_email3" id="selStdClassCd4" name="selStdClassCd4" onChange="fncChangeStd(this, 'sub_bot');" disabled style="min-width:340px; max-width:340px;" title="표준산업분류코드3">
						<option title="표준산업분류코드 소소분류" value="">선택</option>
					</select>
					<select class="form-control form_email3" id="selStdClassCd5" name="selStdClassCd5" disabled style="min-width:340px; max-width:340px;" title="표준산업분류코드4">
						<option title="표준산업분류코드 소소소분류" value="">선택</option>
					</select>
				</div>	
                <!--// content-->
                <div class="tbl_public" >
                	<div style="text-align:center;margin-top:40px;">
                		<button type="button" onClick="doStdApply();" class="btn_step" title="적용버튼">적용</button>
                	</div>
                </div>
				</div>
	        </div>
    	</div>
	</div>
	<div class="dim-layer pwdCls">
	    <div class="dimBg"></div>
	    <div id="layer3" class="pop-layer" style="height:500px">
	        <div class="pop-container">
	        <div class="pop-title"><h3>비밀번호 변경</h3></div>
	            <div class="pop-conts">
	                <!--content //-->
					<p class="pop-info" id="checkPwMsg"></p>
					<table>
						<caption>개인정보변경 비밀번호 변경</caption>
						<colgroup>
							<col style="width:30%"/><col style="width:70%"/>
						</colgroup>
						<tbody class="line">
							<tr>
								<th>현재비밀번호</th>
								<td class="left form-inline"><input type="password" id="currentPw" class="form-control" title="현재비밀번호"></td>
							</tr>
							<tr>
								<th>새 비밀번호</th>
								<td class="left form-inline"><input type="password" id="newPw" class="form-control" onkeyup="fncSamePwCheck()" title="새 비밀번호"></td>
							</tr>
							<tr>
								<th>새 비밀번호 확인</th>
								<td class="left form-inline"><input type="password" id="newPwCheck" class="form-control" onkeyup="fncSamePwCheck()" title="새 비밀번호 확인"></td>
							</tr>
						</tbody>
					</table>
	                <!--// content-->
	                <!-- <div class="tbl_comm tbl_public" style="margin-top:10px" >
	                	<button type="button" id="btnUpdatePwd" class="btn_step" title="변경 버튼">번경</button></div>
					</div> -->
					<div class="tbl_public" >
						<div style="text-align:center;margin-top:40px;">
	                		<button type="button" id="btnUpdatePwd" class="btn_step" title="변경 버튼">번경</button>
	                		<button type="button" id="btnCancel" class="btn_step" title="닫기 버튼">닫기</button>
	                	</div>
                	</div>
                </div>
	            </div>
	        </div>
    	</div>
