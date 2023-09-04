<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<%@ page import="java.util.Date" %>
<%@ page import="java.net.*" %>
<%
	Date date = new Date();
	long tstamp =  date.getTime();
%>

<%-- <script src="${pageContext.request.contextPath}/plugins/icheck/icheck.min.js"></script> --%>
<script src="/js/lms/control/LocalStorageCtrl.js?ts=<%=tstamp%>"></script>

<script>
var _lsCtrl		= new LocalStorageCtrl();

var LoginCtrl = {
		
	doLogin : function() {
		if ($.trim($("#id").val()) == "") {
			alert_popup_focus("아이디를 입력해 주세요.","#id");
			return false;
		}
		else if($.trim($("#pw").val()) == "") {
			alert_popup_focus('비밀번호를 입력해 주세요.',"#pw");
			return false;
		}
				
		$.ajax({
			url : "/techtalk/loginx.do",
			type : "POST",
			data : $("#frm_login").serialize(),
			dataType : "json",
			success : function(resp) {
					
				if (resp.result_code == "0") {
					if ($("#idsave").is(":checked")) {
						_lsCtrl.setProperty("SAVEID", $("#userid").val().toLowerCase());
					}
					else {
						_lsCtrl.setProperty("SAVEID", "");
					}
					var gourl = $.trim($("#gourl").val());
					//alert("로그인 되었습니다.");
					//location.href = "/admin/mainView.do";
					location.href = "/techtalk/mainView.do";
					//parent.location.reload();
					//parent.$('#dialog').dialog('destroy');			
				}
				else {
					var msg = resp.result_mesg;
					alert_popup(msg,"/techtalk/login.do");
					//location.href = "/tecktalk/login.do";
				}
			},
			error : function(result) {
				alert_popup_focus('로그인 통신 오류',"#btnLogin");
			}
		});
		return false;
	},
};

function doLogout() {
	var strLogoutUrl = "/techtalk/logoutx.do";

	$.ajax({
		url : strLogoutUrl,
		type : "POST",
		dataType : "json",
		success : function(resp) {
			if (resp.result_code == "0") {
				var gourl = "/login/login.do";
//				location.href = gourl;
			}
			else {
				alert_popup(resp.result_mesg);
			}
		}
	});
	return false;
};


$(document).ready(function() {
	//doLogout();
	$("#id").keyup(function(e){
		if(e.keyCode == 13){
			e.preventDefault();
			LoginCtrl.doLogin();
		}
	 });
	$("#pw").keyup(function(e){
		if(e.keyCode == 13){
			e.preventDefault();
			LoginCtrl.doLogin();
		}
	 });
	$("#btnLogin").click(function(e) {
		e.preventDefault();
		LoginCtrl.doLogin();
	});
/* 
	$('input').iCheck({
		checkboxClass: 'icheckbox_square-blue',
		radioClass: 'iradio_square-blue',
		increaseArea: '20%' // optional 
	}); */
	
	$('#buttonFindId').click(function() {
		var $href = $(this).attr('href');
		var cls = "idCls";
		var op = $(this);
	    layer_popup($href, cls, op);
	});
	
	$('#cancelId').click(function() {
		var $href = $(this).attr('href');
		var cls = "idCls";
		var op = $(this);
	    layer_popup($href, cls, op);
	});
	$('#cancelPw').click(function() {
		var $href = $(this).attr('href');
		var cls = "idCls";
		var op = $(this);
	    layer_popup($href, cls, op);
	});
	$('#cancelId2').click(function() {
		var $href = $(this).attr('href');
		var cls = "idCls";
		var op = $(this);
	    layer_popup($href, cls, op);
	});
	$('#cancelPw2').click(function() {
		var $href = $(this).attr('href');
		var cls = "idCls";
		var op = $(this);
	    layer_popup($href, cls, op);
	});
	
	$('#buttonFindPw').click(function() {
		var $href = $(this).attr('href');
		var cls = "pwdCls";
		var op = $(this);
	    layer_popup($href, cls, op);
	});

	$('#btnGetId').click(function() {
		fncGetEmailToId()();
	});
	
	$('#btnEmailCheck').click(function() {
		fncCheckEmail();
	});

	$('#btnFindId').click(function() {
		fncFindId();
	});
	$('#btnGetPw').click(function() {
		fncFindPw();
	})

});

//[아이디 찾기] - 아이디 찾기 -> 2021/04/19 - 추정완
function fncFindId() {
	var bizNo_ID = $('#bizNo_ID').val();
	var email_ID = $('#email_ID').val();
	$('.compaLginCont').find("input, a, button").removeAttr('tabindex');
    $('#compaVcFoot').find("input, a, button").removeAttr('tabindex');
	if(!isBlank('사업자등록번호', '#bizNo_ID'))
	if(!isBlank('이메일', '#email_ID')){
		$.ajax({
			type : 'POST',
			url : '/tecktalk/findId.do',
			data : {
				biz_regno : bizNo_ID,
				user_email : email_ID
			},
			dataType : 'json',
			success : function(data) {
				var result_check = data.result_check;
				if(result_check == '0') {
					alert_popup_focus('사업자등록번호 및 담당자 이메일을 다시 확인해주세요.',"#bizNo_ID");
					return false;
				}
				else{
					var userInfo = data.userInfo;
					
					$('#tap1_1').css('display', 'none');
					$('#tap1_2').css('display', 'block');
					
					var memberId = userInfo.id;		//memberid 셋팅필요
					
					$('#saveId').val(memberId);
					$('#saveEmail').val(email_ID);
					
					var idLength = memberId.length;
					memberId = memberId.substr(0, 2) + Array(idLength - 1).join("*");
					$('#findId').append(memberId);
				}
			},
			error : function() {
				
			},
			complete : function() {
				
			}
		})
	}
}
//[아이디 찾기] - 이메일로 완전한 아이디 받기
function fncGetEmailToId() {
	var saveId = $('#saveId').val();
	var saveEmail = $('#saveEmail').val();	
	
	$.ajax({
		type : 'POST',
		url : '/techtalk/getEmailToId.do',
		data : {
			saveId : saveId,
			saveEmail : saveEmail
		},
		dataType : 'json',
		beforeSend: function() {
			$('.wrap-loading').removeClass('display-none');
		},
		success : function() {
			alert_popup('해당 이메일로 전송 완료 되었습니다.');
			$('#bizNo_PW').val("");
	        $('#popId').val("");
	        $('#email_PW').val("");
	        $('#bizNo_ID').val("");
	        $('#email_ID').val("");
		},
		error : function() {
			
		},
		complete : function() {
			$('.wrap-loading').addClass('display-none');
		}
	})
}
//[비밀번호 찾기] - 비밀번호 찾기 -> 2021/04/21 - 추정완
function fncFindPw() {
	var bizNo_PW = $('#bizNo_PW').val();
	var id = $('#popId').val();
	var email_PW = $('#email_PW').val();
	$('.compaLginCont').find("input, a, button").removeAttr('tabindex');
    $('#compaVcFoot').find("input, a, button").removeAttr('tabindex');
	if(!isBlank('사업자등록번호', '#bizNo_PW'))
	if(!isBlank('아이디', '#popId'))
	if(!isBlank('이메일', '#email_PW')) {
		$.ajax({
			type : 'POST',
			url : '/techtalk/getEmailToPw.do',
			data : {
				biz_regno : bizNo_PW,
				id : id,
				user_email : email_PW
			},
			dataType : 'json',
			beforeSend: function() {
				$('.wrap-loading').removeClass('display-none');
			},
			success : function(data) {
				var result_check =  data.result_check;
				if(result_check == 0) {
					alert_popup('정보를 다시 확인해주세요.');
					return false;
				}
				else{
					$('.wrap-loading').addClass('display-none');
					$('#emailUrl').val(email_PW);
					$('#tap2_1').css('display', 'none');
					$('#tap2_2').css('display', 'block');
					$('#bizNo_PW').val("");
			        $('#popId').val("");
			        $('#email_PW').val("");
			        $('#bizNo_ID').val("");
			        $('#email_ID').val("");
				}
			},
			error : function() {
				
			}
		})
	}
}
//[비밀번호 찾기] - 이메일 확인 이동 -> 2021/04/21 추정완
function fncCheckEmail() {
	var email = $('#emailUrl').val();
	var emailUrl = email.split('@')[1];
	window.open('https://www.' + emailUrl);
}

//[로그인] - 
function fncTest() {
	setTimeout("location.reload()", 5000);
}

function layer_popup(el, cls, op){

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
    $('.compaLginCont').find("input, a, button").attr('tabindex','-1');
    $('#compaVcFoot').find("input, a, button").attr('tabindex','-1');

    //esc키 버튼 입력시 통보 없애기
    $(document).keydown(function(event) {
        if ( event.keyCode == 27 || event.which == 27 ) {
            $('.compaLginCont').find("input, a, button").removeAttr('tabindex');
            $('#compaVcFoot').find("input, a, button").removeAttr('tabindex');
        	isDim ? $('.dim-layer').fadeOut() : $el.fadeOut(); // 닫기 버튼을 클릭하면 레이어가 닫힌다.
        	setTimeout(function(){
            	$op.focus();
               }, 500);
            return false;
        }
    });

    $el.find('.btn-layerClose').click(function(){
        isDim ? $("."+cls).fadeOut() : $el.fadeOut(); // 닫기 버튼을 클릭하면 레이어가 닫힌다.
        $('#bizNo_PW').val("");
        $('#popId').val("");
        $('#email_PW').val("");
        $('#bizNo_ID').val("");
        $('#email_ID').val("");
        $('.compaLginCont').find("input, a, button").removeAttr('tabindex');
        $('#compaVcFoot').find("input, a, button").removeAttr('tabindex');
        return false;
    });

    $el.find('#cancelId').click(function(){
        isDim ? $("."+cls).fadeOut() : $el.fadeOut(); // 닫기 버튼을 클릭하면 레이어가 닫힌다.
        $('#bizNo_PW').val("");
        $('#popId').val("");
        $('#email_PW').val("");
        $('#bizNo_ID').val("");
        $('#email_ID').val("");
        $('.compaLginCont').find("input, a, button").removeAttr('tabindex');
        $('#compaVcFoot').find("input, a, button").removeAttr('tabindex');
        setTimeout(function(){
        	$op.focus();
           }, 500);
        return false;
    });
    
    $el.find('#cancelPw').click(function(){
        isDim ? $("."+cls).fadeOut() : $el.fadeOut(); // 닫기 버튼을 클릭하면 레이어가 닫힌다.
        $('#bizNo_PW').val("");
        $('#popId').val("");
        $('#email_PW').val("");
        $('#bizNo_ID').val("");
        $('#email_ID').val("");
        $('.compaLginCont').find("input, a, button").removeAttr('tabindex');
        $('#compaVcFoot').find("input, a, button").removeAttr('tabindex');
        setTimeout(function(){
        	$op.focus();
           }, 500);
        return false;
    });
    
    $el.find('#cancelId2').click(function(){
        isDim ? $("."+cls).fadeOut() : $el.fadeOut(); // 닫기 버튼을 클릭하면 레이어가 닫힌다.
        $('#bizNo_PW').val("");
        $('#popId').val("");
        $('#email_PW').val("");
        $('#bizNo_ID').val("");
        $('#email_ID').val("");
        $('.compaLginCont').find("input, a, button").removeAttr('tabindex');
        $('#compaVcFoot').find("input, a, button").removeAttr('tabindex');
        setTimeout(function(){
        	$op.focus();
           }, 500);
        return false;
    });
    
    $el.find('#cancelPw2').click(function(){
        isDim ? $("."+cls).fadeOut() : $el.fadeOut(); // 닫기 버튼을 클릭하면 레이어가 닫힌다.
        $('#bizNo_PW').val("");
        $('#popId').val("");
        $('#email_PW').val("");
        $('#bizNo_ID').val("");
        $('#email_ID').val("");
        $('.compaLginCont').find("input, a, button").removeAttr('tabindex');
        $('#compaVcFoot').find("input, a, button").removeAttr('tabindex');
        setTimeout(function(){
        	$op.focus();
           }, 500);
        return false;
    });

    $('.layer .dimBg').click(function(){
        $("."+cls).fadeOut();
        return false;
    });
    
   
}

//공지사항 상세보기 화면
function moveDetail(bitem_seq) {
	$('#bitemSeq').val(bitem_seq);
	var frm = document.frm2;
	frm.submit();
}    

function memberJoin() {
	var frm = document.frm3;
	frm.submit();
} 

function moveBoard(board_seq){
	var action="/techtalk/listBoardItem.do"
	
	var form = document.createElement('form');

	form.setAttribute('method', 'post');

	form.setAttribute('action', action);

	document.charset = "utf-8";

		var hiddenField = document.createElement('input');
		hiddenField.setAttribute('type', 'hidden');
		hiddenField.setAttribute('name', 'board_seq');
		hiddenField.setAttribute('value', board_seq);
		
		form.appendChild(hiddenField);
	document.body.appendChild(form);

	form.submit(); 	
}
</script>
<form action="/techtalk/memberJoinAgreePage.do" id="frm3" name="frm3" method="post">
</form>
<form action="/techtalk/viewBoardItem.do" id="frm2" name="frm2" method="post">
	<input type="hidden" id="bitemSeq" name="bitem_seq" value=""/>
	<input type="hidden" id="boardSeq" name="board_seq" value="100"/>
</form>
	<div id="compaLogin">
		<!-- compaVcContent s:  -->
        <div class="compaLginBg"></div>
		<div class="compaLginCont">
               <div class="compaLginHeader">
                   <h1 class="login_logo"><img src="${pageContext.request.contextPath}/css/images/common/logo_header.png" alt="TECHTALK"></h1>
               </div>
               <div class="compaLginBox">
                   <div class="login_form_box">
                       <div class="login_form_box_inner">
                       <form id="frm_login" method="post">
                           <h2>로그인</h2>
                           <div class="login_form">
                               <label>아이디</label>
                               <div class="login-form-input">
                                   <label><input type="text" class="form-control" id="id" name="id" placeholder="아이디를 입력해주세요." onkeyup="this.value=this.value.replace(/[\ㄱ-ㅎㅏ-ㅣ가-힣]/g, '');" title="아이디" autofocus></label>
                               </div>
                           </div>
                           <div class="login_form">
                               <label>비밀번호</label>
                               <div class="login-form-input">
                                   <label><input type="password" class="form-control" id="pw" name="pw" placeholder="비밀번호를 입력해주세요." title="비밀번호" ></label>
                               </div>
                           </div>
                           <div class="login_util">
                           		<div class="lu_left">
                           			<div class="box_checkinp">
					            		<input type="checkbox" class="inp_check" name="checkbox" id="c4"  title="아이디 기억하기">
					            		<label for="c4" class="lab_check">
					            			<span class="icon ico_check"></span>아이디 기억하기
					            		</label>
					                </div>
                           		</div>
                           		<div class="lu_right">
	                           		<a href="#layer2" class="btn_file_pw" id="buttonFindId" title="아이디 찾기">아이디 찾기</a>
	                           		<a href="#layer3" class="btn_file_pw" id="buttonFindPw" title="패스워드 찾기">패스워드 찾기</a>
                           		</div>
                           </div>
                           
                           <button type="button" class="btn_login"  id="btnLogin" title="로그인">로그인</button>
                           <div class="join_ad_box">
                               <span>아직 계정이 없으신가요?</span> <a href="javascript:void(0);" onclick="memberJoin();" title="회원가입">회원가입</a>
                           </div>
                       </form>
                       </div>
                   </div>
               </div>
           </div>
		<!-- //compaVcContent e:  -->
			<div class="dim-layer idCls">
			    <div class="dimBg"></div>
			    <div id="layer2" class="pop-layer" style="height:300px">
			        <div class="pop-container">
			        <div class="pop-title"><h3>아이디 찾기</h3></div>
			            <div id="tap1_1" style="display: block">
							<div class="table2 mTop5">
								<table>
									<caption style="position:absolute !important;  width:1px;  height:1px; overflow:hidden; clip:rect(1px, 1px, 1px, 1px);">아이디찾기 정보입력 테이블</caption>
									<colgroup>
										<col style="width:30%"/><col style="width:70%"/>
									</colgroup>
									<thead></thead>
									<tbody class="line">
										<tr>
											<th scope="col">사업자등록번호</th>
											<td class="left form-inline"><label><input type="text" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" id="bizNo_ID" class="form-control" placeholder="('-'없이 입력)" title="사업자등록번호" ></label></td>
										</tr>
										<tr>
											<th scope="col">담당자 이메일</th>
											<td class="left form-inline"><label><input type="text" id="email_ID" onkeyup="this.value=this.value.replace(/[\ㄱ-ㅎㅏ-ㅣ가-힣]/g, '');" class="form-control" title="담당자 이메일"></label></td>
										</tr>
									</tbody>
									<tfoot></tfoot>
								</table>
								<div class="tbl_public" >
									<div style="text-align:center;margin-top:40px;">
					                	<button type="button" class="btn_step" id="btnFindId" title="확인">확인</button>
					                	<button type="button" class="btn_step" id="cancelId"  name="btnCancel" title="닫기">닫기</button>
				                	</div>
				                </div>
							</div>
						</div>
						<div id="tap1_2" style="display: none">
							<div class="line form-inline alignCenter">
								<div style="margin-top: 30px">
									<label>가입하신 아이디는</label>
									<label id="findId"></label>
									<label>입니다.</label>
								</div>
								<label style="color: red">완전한 아이디 정보는 이메일로 요청 시 확인가능합니다.</label>
							</div>
							<div class="tbl_public" style="margin-top:10px" >
								<div style="text-align:center;margin-top:40px;">
				                	<button type="button" class="btn_step" id="btnGetId" title="확인">확인</button>
				                	<button type="button" class="btn_step" id="cancelId2"  name="btnCancel" title="닫기">닫기</button>
			                	</div>
			                </div>
						</div>
			        </div>
		    	</div>
			</div>
			<div class="dim-layer pwdCls">
			    <div class="dimBg"></div>
			    <div id="layer3" class="pop-layer" style="height:300px">
			        <div class="pop-container">
			        <div class="pop-title"><h3>패스워드 찾기</h3></div>
			     		<div id="tap2_1" style="display: block">
							<div class="table2 mTop5">
								<table>
									<caption style="position:absolute !important;  width:1px;  height:1px; overflow:hidden; clip:rect(1px, 1px, 1px, 1px);">패스워드 찾기</caption>
									<colgroup>
										<col style="width:30%"/><col style="width:70%"/>
									</colgroup>
									<thead></thead>
									<tbody class="line">
										<tr>
											<th scope="col">사업자등록번호</th>
											<td class="left form-inline"><label><input type="text" id="bizNo_PW"  onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" class="form-control" placeholder="('-'없이 입력)"  title="사업자등록번호"></label></td>
										</tr>
										<tr>
											<th scope="col">아이디</th>
											<td class="left form-inline"><label><input type="text" id="popId"  onkeyup="this.value=this.value.replace(/[\ㄱ-ㅎㅏ-ㅣ가-힣]/g, '');" class="form-control" title="아이디"></label></td>
										</tr>
										<tr>
											<th scope="col">담당자 이메일</th>
											<td class="left form-inline"><label><input type="text" id="email_PW" onkeyup="this.value=this.value.replace(/[\ㄱ-ㅎㅏ-ㅣ가-힣]/g, '');" class="form-control" title="담당자 이메일"></label></td>
										</tr>
									</tbody>
									<tfoot></tfoot>
								</table>
								<div class="tbl_public" style="margin-top:10px" >
									<div style="text-align:center;margin-top:40px;">
					                	<button type="button" class="btn_step" id="btnGetPw" title="확인">확인</button>
					                	<button type="button" class="btn_step" id="cancelPw" name="btnCancel" title="닫기">닫기</button>
				                	</div>
				                </div>
							</div>
						</div>
						<div id="tap2_2" style="display: none">
							<input type="hidden" id="emailUrl">
							<div class="line form-inline alignCenter">
								<div style="margin-top: 30px">
									<label>가입하신 이메일로 임시비밀번호를 발급했습니다.</label>
								</div>
							</div>
							<div class="tbl_public" style="margin-top:10px" >
								<div style="text-align:center;margin-top:40px;">
				                	<button type="button" class="btn_step" id="btnEmailCheck" title="새 창 열림 이메일로이동">이메일로 이동</button>
				                	<button type="button" class="btn_step" id="cancelPw2" name="btnCancel" title="확인">확인</button>
			                	</div>
			                </div>
						</div>      
			        </div>
		    	</div>
			</div>	
		<!-- compaVcFooter s:  -->
          <footer id="compaVcFoot" class="foot_cv">
            <div class="wrap_copyright">
            	<div class="ckwrap">
	            	<div class="inner_ckwrap">
	            		<a href="/techtalk/terms.do" class="txt_addr" title="이용약관">이용약관</a> 
						<a href="/techtalk/policy.do" class="txt_addr"  title="개인정보처리방침">개인정보처리방침</a>
						<div class="relation_svc">
	                        <strong class="tit_relation"><a href="javascript:void(0);" class="link_tit" aria-haspopup="true" aria-expanded="false" title="Family Site">관련사이트<span class="icon ico_arr"></span></a></strong>
	                        <ul class="list_relation">
	                            <li><a href="www.keywert.com" target="_blank" class="link_relation" title="키워드 링크 새창열림">키워드 링크</a></li>
	                        </ul>
	                   	</div>
	            	</div>
            	</div>
                <div class="inner_copyright">
					<div class="foot_logo">
						<div style="display:inline-block">
						<span><img src="${pageContext.request.contextPath}/css/images/common/footer_logo.png" alt="바우처사업관리시스템"></span>
						</div>
					</div>
					<div class="dim-layer-common alertCls">
					    <div class="dimBgg"></div>
					    <div id="layer99" class="pop-layer" style="height:220px">
					        <div class="pop-container">
					        <div class="pop-title"><h3>알림</h3></div>
					            <div id="tap1_1" style="display: block">
									<div class="table2 mTop5">
										<div class="line form-inline alignCenter">
											<div style="margin-top: 30px">
												<label id="alertTxt">ㅅㄷㅌㅅ</label>
											</div>
										</div>
										<div class="tbl_public" >
											<div style="text-align:center;margin-top:20px;">
							                	<button type="button" class="btn_step" id="cancelAlert" name="btnCancel" title="닫기">닫기</button>
						                	</div>
						                </div>
									</div>
								</div>
					        </div>
				    	</div>
					</div>
                    <div class="info_copyright">
						<div class="info_addr">
							<ul>
								<li><span class="at_title">주소</span>서울특별시 강남구 테헤란로 10길 18, 6층 (역삼동, 하나빌딩)</li>
								<li><span class="at_title">이메일</span>tbiz@tbizip.com</li>
								<li><span class="at_title">전화</span>02-6405-3271</li>
								<li><span class="at_title">팩스</span>02-6405-3277</li>
							</ul>
				
						
						</div>
						<p class="tx">주식회사 티비즈의 특허 전문가와 워트인텔리전스가 함께  만들었습니다.</p>
						<small class="txt_copyright">Copyright©2023 TBIZ All Right Reserved.</small>
						
					</div>
                        
                </div>
            </div>
        </footer>
		<!-- //compaVcCFooter e:  -->
	</div>


