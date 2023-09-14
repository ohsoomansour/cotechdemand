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

$(document).ready(function() {
	
	//doLogout();
	$("#id").keyup(function(e){
		if(e.keyCode == 13){
			e.preventDefault();
			LoginCtrl.doLogin();
		}
	 });
	
	$('#btnFindId').click(function() {
		location.href="/techtalk/completeFindId.do";
	});
});

//[아이디 찾기] - 아이디 찾기 -> 2021/04/19 - 추정완
function fncFindId() {
	var user_name = $('#userName').val();
	var user_email = $('#userEmail1').val()+"@"+$('#userEmail2').val();
	if(!isBlank('이름', '#userName'))
	if(!isBlank('이메일', '#userEmail1'))
	if(!isBlank('이메일도메인', '#userEmail2')){
		$.ajax({
			type : 'POST',
			url : '/tecktalk/findId.do',
			data : {
				user_name : user_name,
				user_email : user_email
			},
			dataType : 'json',
			success : function(data) {
				var result_check = data.result_check;
				if(result_check == '0') {
					alert_popup_focus('이름 및 이메일을 확인해주세요.',"#userName");
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
		success : function() {
			alert_popup('해당 이메일로 전송 완료 되었습니다.');
		},
		error : function() {
			
		},
		complete : function() {
		}
	})
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
                           <h2>아이디 찾기</h2>
                           <h2 style="font-size:20px; margin-top:20px;">본인확인 이메일로 인증</h2>
                            <label>본인확인 이메일 주소와 입력한 이메일 주소가 같아야 인증번호를 받을 수 있습니다.</label>
                           <div class="login_form">
                               <label>이름</label>
                               <div class="login-form-input">
                                   <label><input type="text" class="form-control" id="userName" name="user_name" placeholder="이름을 입력해주세요." title="이름" autofocus></label>
                               </div>
                           </div>
                           <div class="login_form">
                               <label>이메일 주소</label>
                               <div class="login-form-input" style="display:inline-block;">
                                   <input type="text" class="form-control" id="userEmail1" name="user_email1"  title="이메일1" style="width:43%;">
                                   @
                                  <input type="text" class="form-control" id="userEmail2" name="user_email2"  title="이메일2" style="width:43%;">
                               </div>
                           </div>
                           <div class="login_util">
                           		<div class="lu_left">
                           			<div class="box_checkinp">
					                </div>
                           		</div>
                           </div>
                           <button type="button" class="btn_login"  id="btnFindId" title="로그인">인증번호 전송</button>
                       </form>
                       </div>
                   </div>
               </div>
           </div>
		<!-- //compaVcContent e:  -->
		</div>