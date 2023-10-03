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
					if ($("#c4").is(":checked")) {
						_lsCtrl.setProperty("rememberId", $("#id").val().toLowerCase());
					}
					else {
						_lsCtrl.setProperty("rememberId", "");
					}
					var gourl = $.trim($("#gourl").val());
					location.href = "/techtalk/mainView.do";
				}
				else {
					var msg = resp.result_mesg;
					alert_popup(msg,"/techtalk/login.do");
				}
			},
			error : function(result) {
				alert_popup_focus('로그인 통신 오류',"#btnLogin");
			}
		});
		return false;
	},
};

//쿠키 값 가져오는 함수
function getCookie(name) {
    var value = document.cookie.match('(^|;) ?' + name + '=([^;]*)(;|$)');
    return value? value[2] : null;
}

function setCookie(){
	var id = $("#id").val();
	console.log("id값나옴?"+id);
	$.ajax({
		type : 'POST',
		url : '/techtalk/createCookieX.do',
		data : {
			id : id,
		},
		dataType : 'json',
		success : function(res) {
			console.log(res);
		},
		error : function() {
		},
		complete : function() {
		}
	})
}

$(document).ready(function() {
	var rememberId = getCookie("rememberId");
	if(rememberId !=null){
		$('#c4').prop('checked', true);
	  $('#id').val(rememberId);
	}
	
	$("#rememberId").click(function(e) {
		e.preventDefault();
		//setCookie();
	});
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

});


//회원가입화면 이동 2023/09/13 박성민
function memberJoin() {
	location.href="/techtalk/memberJoinFormPage.do";
} 

</script>
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
					            		<input type="checkbox" class="inp_check" name="rememberId" id="c4"  title="아이디 기억하기">
					            		<label for="c4" class="lab_check">
					            			<span class="icon ico_check"></span>아이디 기억하기
					            		</label>
					                </div>
                           		</div>
                           		<div class="lu_right">
	                           		<a href="/techtalk/findIdPage.do" class="btn_file_pw" id="buttonFindId" title="아이디 찾기">아이디 찾기</a>
	                           		<a href="/techtalk/findPwdCheckIdPage.do" class="btn_file_pw" id="buttonFindPw" title="패스워드 찾기">패스워드 찾기</a>
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


