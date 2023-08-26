<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<script>
$(document).on('ready', function() {
	setTimeout(function(){
		$('#id').focus();
	}, 500);
	
});
	var idCheck = false;			//아이디 중복검사 체크
	var bizRegnoCheck = false;		//사업자등록번호 중복검사 체크
	$(document).ready(function(){
		//아이디 중복체크 클릭
		$('#btnIdCheck').click(function() {
			fncDoubleCheck("ID");
		});
		
		//사업자등록번호 중복체크 클릭
		$('#btnBizRegnoCheck').click(function() {
			fncDoubleCheck("BR");
		});
		
		//회원가입
		$('#btnSubmit').click(function() {
			fncMemberJoin();
		});
		
		//이메일 확인 이동
		$('#btnEmailCheck').click(function() {
			fncCheckEmail();
		});

		//코드검색
		$('#stdClassSrch').click(function() {
			var $href = $(this).attr('href');
			var op = $(this);
	        layer_popup($href, op);
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

	});
	
	//[회원가입] - 아이디 및 사업자등록번호 중복확인 -> 2021/04/16 - 추정완
	function fncDoubleCheck(gubun) {
		if(gubun == 'ID') {
			var id = $('#id').val();
			console.log('id : ' + id);
			if(id == '' || id == null) {
				alert_popup_focus('아이디를 입력 후 중복확인 버튼을 클릭해주세요.','#id');
				return false;
			}
			/*if(id.length < 8){
				alert_popup_focus('아이디를 8글자 이상 입력해 주세요.','#id');
				return false;
				}*/
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
						alert_popup_focus('중복된 아이디가 있습니다. 다른 아이디를 사용해주세요.','#id');
						idCheck = false;
					}else if(id.length < 8){
						alert_popup_focus('아이디를 8글자 이상 입력해 주세요.','#id');
						return false;
					}
					else if(id.length >=8){
						alert_popup_focus('사용가능한 아이디 입니다.','#pw');
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
			if(bizRegno == '' || bizRegno == null) {
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
						return false;
					}
					else{
						alert_popup_focus('사용 가능한 사업자등록번호 입니다.','#btnBizRegnoCheck');
						bizRegnoCheck = true;
						fncBizInsert();
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
            	/* $('#zipcode').attr("disabled",true); */
            	$('#zipcode').val(zipcode);
            	$('#address1').val(addr);
            	setTimeout(function(){
            		$('#address2').focus();
            	}, 500);
            }
        }).open();
    }

	function fncSetData(){
		$('#id').val("ozs876");
		$('#pw').val("123123");
		$('#stdClassCd1').val("b1");
		$('#stdClassCd2').val("m2");
		$('#stdClassCd3').val("s3");
		$('#bizRegno').val("123-45-67890");
		$('#bizName').val("기업명");
		$('#owner').val("대표자명");
		$('#telNo1').val("010");
		$('#telNo2').val("8253");
		$('#telNo3').val("2523");
		$('#zipcode').val("08393");
		$('#address1').val("서울 구로구 디지털로32가길 16");
		$('#address2').val("1404호");
		$('#userName').val("이효상");
		$('#userMobileNo1').val("010");
		$('#userMobileNo2').val("8253");
		$('#userMobileNo3').val("2523");
		$('#userEmail1').val("ozs876");
		$('#userEmail2').val("naver.com");
		$('#userDepart').val("부서");
		$('#userRank').val("직위");
		idCheck = true;
		bizRegnoCheck = true;
	}
	
	//[회원가입] - 회원가입 -> 2021/04/19 - 추정완
	   function fncMemberJoin() {
	      if(!isBlank('아이디', '#id'))
	      if(!isBlank('패스워드', '#pw'))
	      if(!isBlank('패스워드', '#passWordCk'))
	      if(!isBlank('사업자등록번호', '#bizRegno'))
	      if(!isBlank('표준산업분류코드', '#stdClassCd'))
	      /* if(!isBlank('표준산업분류코드_중분류', '#stdClassCd2'))
	      if(!isBlank('표준산업분류코드_소분류', '#stdClassCd3'))   */ 
	      if(!isBlank('기업명', '#bizName'))
	      if(!isBlank('대표자명', '#owner'))
	      if(!isBlank('일반전화번호1', '#telNo1'))
	      if(!isBlank('일반전화번호2', '#telNo2'))
	      if(!isBlank('일반전화번호3', '#telNo3'))
	      if(!isBlank('우편번호', '#zipcode'))
	      if(!isBlank('주소', '#address1'))
	      if(!isBlank('상세주소', '#address2'))
	      if(!isBlank('설립일', '#est_date'))
    	  var datatimeRegexp = /[0-9]{4}-(0?[1-9]|1[012])-(0?[1-9]|[12][0-9]|3[01])/;
	      if ( !datatimeRegexp.test($('#est_date').val()) ) {
	    	  alert_popup_focus('날짜는 yyyy-mm-dd 형식으로 입력해주세요.','#est_date');
	          return false;
	      }
	      if(!isBlank('소재지', '#location'))
	      if(!isBlank('업종', '#biz_type'))
	      if(!isBlank('주요제품/서비스', '#biz_item'))
	      if(!isBlank('종업원수', '#employ_count'))
	      if(!isBlank('매출액(직전년도)', '#sales_year'))
	      if(!isBlank('이름', '#userName'))
	      if(!isBlank('휴대전화번호1', '#userMobileNo1'))
	      if(!isBlank('휴대전화번호2', '#userMobileNo2'))
	      if(!isBlank('휴대전화번호3', '#userMobileNo3'))
	      if(!isBlank('이메일주소', '#userEmail1'))
	      if(!isBlank('이메일주소2', '#userEmail2'))
	      if(!isBlank('부서', '#userDepart'))
	      if(!isBlank('직위', '#userRank')){
	    	  $("#bizRegno").val().replace(/-/gi, "");
	         if(idCheck == true && bizRegnoCheck == true) {
		         if($("#pw").val() == $("#passWordCk").val() && $("#stdClassCd")){
			         var id = $("#id").val();
			         var pw = $("#pw").val();
			         if(pw.length >= 8 && id.length >= 8){
				         
			        	 $('#stdClassCd').val($('#stdClassCd').attr('hiddenVal'));
			        	 /* $('#stdClassCd2').val($('#stdClassCd2').attr('hiddenVal'));
			        	 $('#stdClassCd3').val($('#stdClassCd3').attr('hiddenVal')); */
			              
			            $.ajax({
			               type : 'POST',
			               url : '/front/memberJoin.do',
			               data : $('#frm').serialize(),
			               dataType : 'json',
			               beforeSend: function() {
			                  $('.wrap-loading').css('display', 'block');
			               },
			               success : function() {
			                  fncCompeletePage();
			               },
			               error : function() {
			                  
			               },
			               complete : function() {
			                  
			               }
			            });
			         }else if(pw.length <= 7){
			        	 alert_popup_focus('pw를 8자 이상 작성해주세요.','#pw');
		        	 	return false;	
				     }else if(id.length <= 9){
				    	 alert_popup_focus('id를 8자 이상 작성해주세요.','#id');
			        	 return false;
				     }
		         }else{
		        	 alert_popup_focus('비밀번호가 일치하지 않습니다. ','#pw');
		        	 return false;
			         }
	         }
	         else if(idCheck == false) {
	        	 alert_popup_focus('아이디 중복검사를 해주세요.','#btnIdCheck');
	            return false;
	         }
	         else if(bizRegnoCheck == false) {
	        	 alert_popup_focus('사업자등록번호 중복여부를 확인해주세요.','#btnBizRegnoCheck');
	            return false;
	         }
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

	//[회원가입] - 회원가입 완료 화면 이동 -> 2021/06/29 이효상
	function fncCompeletePage() {
		location.href="/front/memberJoinCompletePage.do";
	}

	
    //공급기관 팝업띄우기
    function layer_popup(el,op){

        var $el = $(el);    //레이어의 id를 $el 변수에 저장
        var $op = $(op);    //버튼 id를 $el 변수에 저장
        var isDim = $el.prev().hasClass('dimBg'); //dimmed 레이어를 감지하기 위한 boolean 변수

        isDim ? $('.dim-layer').fadeIn() : $el.fadeIn();

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
        $('.wrap-loading').find("input, a, button").attr('tabindex','-1');
        $('.scroll-top').find("input, a, button").attr('tabindex','-1');
	    $('#compaVcFoot').find("input, a, button").attr('tabindex','-1');

	    //esc키 버튼 입력시 통보 없애기
	    $(document).keydown(function(event) {
	        if ( event.keyCode == 27 || event.which == 27 ) {
	        	 $('#skip_navigation').find("input, a, button").removeAttr('tabindex');
		            $('#compaVcHead').find("input, a, button").removeAttr('tabindex');
		            $('#compaVcContent').find("input, a, button").removeAttr('tabindex');
		            $('.wrap-loading').find("input, a, button").removeAttr('tabindex');
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
            isDim ? $('.dim-layer').fadeOut() : $el.fadeOut(); // 닫기 버튼을 클릭하면 레이어가 닫힌다.
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

        $('.layer .dimBg').click(function(){
            $('.dim-layer').fadeOut();
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
            $('.dim-layer').fadeOut();
            $('#skip_navigation').find("input, a, button").removeAttr('tabindex');
            $('#compaVcHead').find("input, a, button").removeAttr('tabindex');
            $('#compaVcContent').find("input, a, button").removeAttr('tabindex');
            $('.wrap-loading').find("input, a, button").removeAttr('tabindex');
            $('.scroll-top').find("input, a, button").removeAttr('tabindex');
    	    $('#compaVcFoot').find("input, a, button").removeAttr('tabindex');
    	    setTimeout(function(){
    	    	$('#stdClassSrch').focus();
    	    }, 500);
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
						aHtml += "<option title='표준산업분류코드' value=''>선택</option>";
						$.each(codeData, function(key, val){
							aHtml += "<option title="+this.code_name+" value="+this.code_key+">"+this.code_name+"</option>";
						});
						
						$('#selStdClassCd2').empty();
						$('#selStdClassCd2').append(aHtml);
						$('#selStdClassCd2').removeAttr("disabled");
						
						aHtml = "<option title='표준산업분류코드 분류' value=''>선택</option>";
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

						aHtml += "<option title='표준산업분류코드 소분류' value=''>선택</option>";
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
        var name = "popup test";
        var option = "width = 500, height = 500, top = 100, left = 200, location = no "
        window.open(url, name, option);
    }

  //[회원가입] - 사업자번호 입력 시 자동입력
	function fncBizInsert() {
		var bizRegno = $("#bizRegno").val().replace(/-/gi, "");
		//$("#bizRegno").val().replace(/-/gi, "");
		if(bizRegno == '' || bizRegno == null) {
			alert_popup('사업자번호를 입력 후 자동입력 버튼을 클릭해주세요.');
			return false;
		}
		$.ajax({
			type : 'POST',
			url : '/front/memberBizInsert.do',
			data : {
				bizRegno : bizRegno
			},
			dataType : 'json',
			success : function(res) {
				var list = res.memberBizInsert;
				console.log("asd",list)
				if(list != null){
					alert_popup("자동 조회가 완료됐습니다.");
					$('#bizName').val(list.korentrnm);
					$('#employ_count').val(list.empnum);
					
					$('#owner').val(list.korreprnm);
					$('#biz_type').val(list.koridscdnm);
					$('#address1').val(list.koraddr);
					$('#zipcode').val(list.zcd);
					var telNo = list.tel.split('-');
					$('#telNo1').val(telNo[0]);
					$('#telNo2').val(telNo[1]);
					$('#telNo3').val(telNo[2]);
					var est_date = list.etbdate.substring(0,4);
					var est_date1 = est_date + "-";
					console.log(est_date1);
					var est_date = list.etbdate.substring(4,6);
					var est_date2 = est_date + "-";
					console.log(est_date2);
					var est_date3 = list.etbdate.substring(6,8);
					console.log(est_date3);
					var est_date = est_date1+est_date2+est_date3;
					$('#est_date').val(est_date);
				}else{
				}
			},
			error : function() {
			},
			complete : function() {
				
			}
		});
	}
</script>
<!-- compaVcContent s:  -->
<div id="compaVcContent" class="cont_cv">
	<div id="mArticle" class="assig_app">
		<h2 class="screen_out">본문영역</h2>
		<div class="wrap_cont">
            <!-- page_title s:  -->
			<div class="area_tit">
				<h3 class="tit_corp">회원정보입력</h3>
                <div class="wrapper-stepper agree_box">
                    <ul class="stepper">
                        <li class="active">약관동의</li>
                        <li class="active">회원정보입력</li>
                        <li>가입완료</li>
                    </ul>
                </div>
			</div>
			<!-- //page_title e:  -->
			<!-- page_content s:  -->
			<form id="frm">
	            <div class="area_cont ">
	                <div class="subject_corp">
	                    <h4>기본정보</h4>
	                </div>
	                <div class="tbl_view tbl_public">
						<table class="tbl">
							<caption>회원가입 회원 기본정보</caption>
		                    <colgroup>
		                        <col style="width:15%">
		                        <col>
		                    </colgroup>
		                    <thead></thead>
		                    <tbody class="view">
		                        <tr>
		                            <th scope="col">아이디  <span class="red">*</span></th>
		                            <td class="ta_left" >
		                                <div class="form-inline">
		                                    <input type="text" class="form-control form_id" id="id" name="id" onkeyup="this.value=this.value.replace(/[\ㄱ-ㅎㅏ-ㅣ가-힣]/g, '');" title="아이디">
		                                    <a href="javascript:void;" class="btn_step2" title="중복확인" id="btnIdCheck" >중복확인</a>
		                                    <span style="margin-left:10px;">8~20자 이내의 영문자(대,소) / 숫자 / 특수문자(.,_,-,@)만 입력가능합니다. </span>
		                                </div>
		                            </td>
		                        </tr>
		                        <tr>
		                            <th scope="col">비밀번호  <span class="red">*</span></th>
		                            <td class="ta_left">
		                                <div class="form-inline">
		                                    <input type="password" class="form-control form_pw" id="pw" name="pw" title="비밀번호">
		                                    <span style="margin-left:125px;">8~20자 이내의 영문자(대,소) / 숫자 / 특수문자만 입력가능합니다.</span>
		                                </div>
		                            </td>
		                        </tr>
		                        <tr>
		                        	 <th scope="col">비밀번호 확인  <span class="red">*</span></th>
		                            <td class="ta_left">
		                                <div class="form-inline">
		                                    <input type="password" class="form-control form_pw" id="passWordCk" name="passWordCk" title="비밀번호 확인">
		                                </div>
		                            </td>
		                        </tr>
		                    </tbody>
		                    <tfoot></tfoot>
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
							<caption >회원가입 회원 기업정보</caption>
		                    <colgroup>
		                        <col style="width:15%">
		                        <col>
		                        <col>
		                        <col>
		                    </colgroup>
		                    <thead></thead>
		                    <tbody class="view">
		                        <tr>
		                            <th scope="col">표준산업분류코드 <span class="red">*</span></th>
		                            <td class="ta_left">
		                                <div class="form-inline" style="min-width:900px;">
		                                    <!-- <input type="text" class="form-control form_com_num" id="stdClassCd1" name="std_class_cd1" placeholder="대분류" readonly="readonly" hiddenVal="" style="width:30%;">
		                                    <input type="text" class="form-control form_com_num" id="stdClassCd2" name="std_class_cd2" placeholder="중분류" readonly="readonly" hiddenVal="" style="width:30%;">
		                                    <input type="text" class="form-control form_com_num" id="stdClassCd3" name="std_class_cd3" placeholder="소분류" readonly="readonly" hiddenVal="" style="width:30%;"> -->
		                                    <input type="text" class="form-control form_com_num" id="stdClassCd" name="std_class_cd" placeholder="세세분류(코드)" readonly="readonly" style="width:30%;" title="표준산업분류번호">
		                                    <a href="#layer2" class="btn_step2" id="stdClassSrch"  title="코드검색">코드검색</a>
		                                </div>
		                            </td><td></td><td></td>
		                        </tr>		                    
		                        <tr>
		                            <th scope="col">사업자등록번호 <span class="red">*</span></th>
		                            <td class="ta_left" >
		                                <div class="form-inline" style="min-width:900px;">
		                                    <input type="text" class="form-control form_com_num" id="bizRegno" name="biz_regno" title="사업자등록번호">
		                                    <a href="javascript:void(0);" class="btn_step2" id="btnBizRegnoCheck" title="중복여부">중복여부</a>
		                                    <!-- <a href="javascript:void(0);" class="btn_step2">기업인증</a> -->
		                                </div>
		                            </td><td></td><td></td>
		                        </tr>
		                        <tr>
		                        	<th scope="col">기업유형 <span class="red">*</span></th>
		                            <td class="ta_left" >
		                                <div class="form-inline">
											<div class="box_radioinp"><input type="radio" class="inp_radio" name="biz_size" id="r1" value="MD0" title="중소기업" checked /><label for="r1" class="lab_radio"><span class="icon ico_radio"></span>중소기업</label></div>
											<div class="box_radioinp"><input type="radio" class="inp_radio" name="biz_size" id="r2" value="MS0" title="중견기업"/><label for="r2" class="lab_radio"><span class="icon ico_radio"></span>중견기업</label></div>
		                                </div>
		                            </td><td></td><td></td>
		                        </tr>		                        
		                        <tr>
		                            <th scope="col">기업명 <span class="red">*</span></th>
		                            <td class="ta_left" >
		                                <div class="form-inline">
		                                    <input type="text" class="form-control form_com_name" id="bizName" name="biz_name" title="기업명">
		                                </div>
		                            </td><td></td><td></td>
		                        </tr>
		                        <tr>
		                            <th scope="col">대표자명 <span class="red">*</span></th>
		                            <td class="ta_left" >
		                                <div class="form-inline">
		                                    <input type="text" class="form-control form_rep_name" id="owner" name="owner" title="대표자명">
		                                </div>
		                            </td><td></td><td></td>
		                        </tr>
		                        <tr>
		                            <th scope="col">일반전화번호 <span class="red">*</span></th>
		                            <td class="ta_left" >
		                                <div class="form-inline">
		                                    <input type="text" maxLength='3' onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" class="form-control form_tel" id="telNo1" name="tel_no1" title="일반전화번호 지역번호"> 
		                                    - <input type="text" maxLength='4' onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" class="form-control form_tel" id="telNo2" name="tel_no2" title="일반전화번호 가운데자리">
		                                     - <input type="text" maxLength='4' onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" class="form-control form_tel" id="telNo3" name="tel_no3" title="일반전화번호 마지막자리"> 
		                                </div>
		                            </td><td></td><td></td>
		                        </tr>
		                        <tr>
		                            <th scope="col">사업장 주소 <span class="red">*</span></th>
		                            <td class="ta_left" >
		                                <div class="form-inline" style="min-width:900px;">
		                                    <input type="text" class="form-control form_com_addr" id="zipcode" name="zipcode" size="10" placeholder="우편번호" readonly="readonly" title="우편번호">
		                                    <a href="javascript:fncMemberAddress();" class="btn_step2" style="margin-left:0px;margin-top:10px;" title="새창열림 우편번호검색">우편번호검색</a>
		                                </div>
		                                <div class="form-inline">
		                                    <input type="text" class="form-control form_com_addr2" id="address1" name="address1" readonly="readonly" title="사업장 주소">
		                                </div>
		                                <div class="form-inline">
		                                    <input type="text" class="form-control form_com_addr2" id="address2" name="address2" title="사업장 상세 주소">
		                                </div>
		                            </td><td></td><td></td>
		                        </tr>
		                        <tr>
		                        	<th scope="col">설립일 <span class="red">*</span></th>
		                        	<td><input type="text" id="est_date" name = "est_date" style="text-align : center;float:left; "  autocomplete="off"  title="설립일" placeholder="1999-01-23"> </td>
		                        	<th scope="col">소재지 <span class="red">*</span></th>
		                        	<td><input type="text" id="location" name="location" maxlength="20" title="소재지"> </td>
		                        </tr>
		                         <tr>
		                        	<th scope="col">업종 <span class="red">*</span></th>
		                        	<td><input type="text" id="biz_type" name="biz_type" maxlength="50" title="업종 "> </td>
		                        	<th scope="col">주요제품/서비스 <span class="red">*</span></th>
		                        	<td><input type="text" id="biz_item" name="biz_item" maxlength="50" title="주요제품/서비스"> </td>
		                        </tr>
		                         <tr>
		                        	<th scope="col">종업원수 <span class="red">*</span></th>
		                        	<td><input type="text" id="employ_count" name="employ_count" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" style="width:80%;float:left;" title="종업원수"/>명</td>
		                        	<th scope="col">매출액(직전년도) <span class="red">*</span></th>
		                        	<td><input type="text" id="sales_year" name="sales_year" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" style="width:70%;float:left;" title="매출액"/>&nbsp;&nbsp;(백만원)</td>
		                        </tr>
		                    </tbody>
		                    <tfoot></tfoot>
		                </table>
		            </div>
				</div>
	            <div class="area_cont area_cont2">
	                <div class="subject_corp">
	                    <h4>담당자정보 <span class="red">*</span></h4>
	                </div>
	                <div class="tbl_view tbl_public">
						<table class="tbl">
							<caption >회원가입 담당자정보</caption>
		                    <colgroup>
		                        <col style="width:15%">
		                        <col>
		                    </colgroup>
		                    <thead></thead>
		                    <tbody class="view">
		                        <tr>
		                            <th scope="col">이름 <span class="red">*</span></th>
		                            <td class="ta_left" >
		                                <div class="form-inline">
		                                    <input type="text" class="form-control form_man_name" id="userName" name="user_name" maxlength="20" title="담당자 이름">
		                                </div>
		                            </td>
		                        </tr>
		                        <tr>
		                            <th scope="col">휴대전화번호 <span class="red">*</span></th>
		                            <td class="ta_left" >
		                                <div class="form-inline">
		                                    <input type="text" maxlength='3' onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" class="form-control form_tel" id="userMobileNo1" name="user_mobile_no1" title="담당자 휴대전화번호 식별번호"> -
		                                    <input type="text" maxlength='4' onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" class="form-control form_tel" id="userMobileNo2" name="user_mobile_no2" title="담당자 휴대전화번호 가운데번호"> - 
		                                    <input type="text" maxlength='4' onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" class="form-control form_tel" id="userMobileNo3" name="user_mobile_no3" title="담당자 휴대전화번호 마지막번호"> 
		                                </div>
		                            </td>
		                        </tr>
		                        <tr>
		                            <th scope="col">이메일주소 <span class="red">*</span></th>
		                            <td class="ta_left" >
		                                <div class="form-inline">
		                                    <input type="text" class="form-control form_email1" id="userEmail1" name="user_email1" onkeyup="this.value=this.value.replace(/[\ㄱ-ㅎㅏ-ㅣ가-힣]/g, '');" maxlength="30" title="담당자 이메일아이디">@
		                                    <input type="text" class="form-control form_email2" id="userEmail2" name="user_email2" onkeyup="this.value=this.value.replace(/[\ㄱ-ㅎㅏ-ㅣ가-힣]/g, '');" maxlength="30" title="담당자 이메일 도메인 직접입력">
		                                    <select class="form-control form_email3" id="userEmail3" name="user_email3" onChange="fncChangeEmail(this);" title="담당자 이메일주소3">
		                                        <option title="직접입력">직접입력</option>
		                                        <option title="네이버">naver.com</option>
		                                        <option title="G메일">gmail.com</option>
		                                        <option title="다음">daum.net</option>
		                                    </select>
		                                </div>
		                            </td>
		                        </tr>
		                        <tr>
		                            <th scope="col">부서 <span class="red">*</span></th>
		                            <td class="ta_left" >
		                                <div class="form-inline">
		                                    <input type="text" class="form-control form_dept" id="userDepart" name="user_depart" maxlength="50" title="담당자 부서">
		                                </div>
		                            </td>
		                        </tr>
		                        <tr>
		                            <th scope="col">직위 <span class="red">*</span></th>
		                            <td class="ta_left" >
		                                <div class="form-inline">
		                                    <input type="text" class="form-control form_spot" id="userRank" name="user_rank" maxlength="20" title="담당자 직위">
		                                </div>
		                            </td>
		                        </tr>
		                    </tbody>
		                    <tfoot></tfoot>
		                </table>
		            </div>   
				</div>
				<div class="area_cont area_cont2">
	                <div class="subject_corp">
	                    <h4>매칭신청용 정보 (수요기업)</h4>
	                </div>
	                <div class="tbl_view tbl_public">
						<table class="tbl">
							<caption >회원가입 매칭신청용 정보</caption>
		                    <colgroup>
		                        <col style="width:15%">
		                        <col>
		                    </colgroup>
		                    <tbody class="view">
		                        <tr>
		                            <th scope="col">바우처서비스_요청분야</th>
		                            <td class="ta_left" >
		                                <div class="box_radioinp">
											<input type="radio" class="inp_radio" name="sc_sector"   id="sc_sector1" value="BS"  checked="checked" title="사업화 지원">
											<label for="sc_sector1" class="lab_radio"><span class="icon ico_radio"></span>사업화 지원</label>
										</div>
										<div class="box_radioinp">
											<input type="radio" class="inp_radio"  name = "sc_sector" id="sc_sector2" value="TS" title="기술개발 지원">
											<label for="sc_sector2" class="lab_radio"><span class="icon ico_radio"></span>기술개발 지원</label>
										</div>
		                            </td>
		                        </tr>
		                        <%-- 임시제거  21-12-03--%>
		                        <!-- <tr>
		                            <th>바우처서비스_요청내용(요약)</th>
		                            <td class="ta_left" >
		                                <div class="form-inline">
		                                    <textarea id="dc_sector_detail" name="dc_sector_detail"style="width:100%;height:200px;resize:none;" title="바우처서비스 요청내용">제출된 '바우처사업관리시스템 사업신청서' 내 [요약문] 내용을 사용하시면 됩니다.</textarea> 
		                                </div>
		                            </td>
		                        </tr>
		                        <tr>
		                            <th>연구개발내용</th>
		                            <td class="ta_left" >
		                               <div class="form-inline">
		                                    <textarea id="dc_rnd_detail" name="dc_rnd_detail" style="width:100%;height:300px;resize:none;" title="연구개발내용">
□ 대상기술(사업)명 : 

□ 대상기술의 설명 및 연구개발 목표 :

□ 기술(제품) 활용 및 사업화 계획:

□ 기타 요구사항 :

(제출된 '바우처사업관리시스템 사업신청서' 내 [요약문] 내용을 사용하시면 됩니다.)
		                                    </textarea> 
		                                </div>
		                            </td>
		                        </tr> -->
		                    </tbody>
		                    <tfoot></tfoot>
		                </table>
		            </div>   
				</div>
				<div class="area_cont area_cont2">
	                <div class="subject_corp" style="display:inline-block;">
	                    <h4>매칭신청용 정보 (공급기업)</h4><h6> *연구개발 서비스협회 등록번호를 등록하시는 경우 공급기업으로 참여가능합니다.</h6>
	                </div>
	                <div class="tbl_view tbl_public">
						<table class="tbl">
							<caption >회원가입 매칭신청용 정보</caption>
		                    <colgroup>
		                        <col style="width:15%">
		                        <col>
		                        <col>
		                    </colgroup>
		                    <tbody class="view">
		                        <tr>
		                            <th scope="col">연구개발서비스 협회 등록번호 </th>
		                            <td class="ta_left" >
		                                <input type="text" id="rnd_registno" name="rnd_registno" value="" title="연구개발서비스 협회 등록번호">
		                            </td>
		                            <td>
		                            	<a href="javascript:void(0);" class="btn_step2" id="btnBizSearch" style="float:left;" title="연구개발서비스 협회 등록번호 검색">검색</a>
		                            	<!-- <a href="javascript:void(0);" onclick="popup();"class="btn_step2" style="float:left;" title="새창열림 연구개발서비스 협회 등록번호 예시">?</a> -->
		                            </td>
		                        </tr>
		                    </tbody>
		                    <tfoot></tfoot>
		                </table>
		            </div>   
				</div>
				
				 <div class="area_cont area_cont2" id="sc_detail" style="display:none;">
	                <div class="tbl_view tbl_public">
						<table class="tbl">
							<caption >회원가입 서비스 수행기능 분야</caption>
		                    <colgroup>
		                        <col style="width:15%">
		                        <col>
		                    </colgroup>
		                    <thead></thead>
		                    <tbody class="view">
		                        <tr>
		                            <th scope="col">서비스 수행기능 분야</th>
		                            <td class="ta_left" >
		                                <div class="box_radioinp">
											<input type="radio" class="inp_radio" name="dc_sector"   id="dc_sector1" value="BS" title="사업화 지원">
											<label for="dc_sector1" class="lab_radio"><span class="icon ico_radio"></span>사업화 지원</label>
										</div>
										<div class="box_radioinp">
											<input type="radio" class="inp_radio"  name = "dc_sector" id="dc_sector2" value="TS" title="기술개발 지원">
											<label for="dc_sector2" class="lab_radio"><span class="icon ico_radio"></span>기술개발 지원</label>
										</div>
		                            </td>
		                        </tr>
		                        <%-- 임시제거  21-12-03--%>
		                        <%--
		                        <tr>
		                            <th>서비스 수행기능 상세</th>
		                            <td class="ta_left" >
		                                <div class="form-inline">
		                                    <textarea id="sc_sector_detail" name="sc_sector_detail" style="width:100%;height:200px;resize:none;" title="서비스 수행기능">
- 판매(제공) 서비스의 내용 :

- 서비스 판매 사례의 내용 :		                                    
		                                    </textarea> 
		                                </div>
		                            </td>
		                        </tr>
		                        --%>
		                    </tbody>
		                    <tfoot></tfoot>
		                </table>
		            </div>   
				</div> 
			</form>
            <div class="wrap_btn _center">
                <a href="javascript:history.back();" class="btn_cancel" title="취소">취소</a>
                <a href="javascript:fncMemberJoin();" class="btn_confirm" title="회원가입">회원가입 </a>
                <!-- <a href="javascript:fncSetData();" class="btn_confirm">데이터입력 </a> -->
            </div>
			<!-- //page_content e:  -->
		</div>
	</div>
</div>
<!-- //compaVcContent e:  -->
<div class="wrap-loading" style="display:none;">
    <div><img src="/images/loading.gif" alt="로딩"/></div>
</div>
<div class="dim-layer">
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
                <div class="tbl_public">
                	<div style="text-align:center;margin-top:40px;">
                		<button type="button" onClick="doStdApply();" class="btn_step" title="적용버튼">적용</button>
                	</div>
				</div>
            </div>
        </div>
    	</div>
    </div>