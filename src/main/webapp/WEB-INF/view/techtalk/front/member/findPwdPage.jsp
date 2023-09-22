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
	
});

//[패스워드 찾기] - 패스워드 찾기 -> 2023/09/21 - 박성민
function fncFindPwd() {
	var id = $('#id').val();
	if(id ==''){
		alert_popup_focus('아이디를 입력해주세요.',"#id");
		}
		$.ajax({
			type : 'POST',
			url : '/techtalk/findPwd1X.do',
			data : {
				id : id
			},
			dataType : 'json',
			success : function(data) {
				var result_count = data.result_count;
				if(result_count == '0') {
					alert_popup_focus('존재하지 않는 회원 아이디 입니다. 회원가입을 진행해 주세요.',"#id");
					return false;
				}else{
					$('#btnFindPwd').css('display','none');
					$('#emailDiv').css('display','block');
					$('#btnSubmitNum').css('display','block');
					}
			},
			error : function() {
				
			},
			complete : function() {
				
			}
		});
}

//[패스워드 찾기] - 인증번호보내기 -> 2023/09/21 - 박성민
function fncFindPwdToEmail() {
	var id = $('#id').val();
	var user_email = $('#userEmail1').val()+"@"+$('#userEmail2').val();
	if(!isBlank('아이디', '#id'))
	if(!isBlank('이메일', '#userEmail1'))
	if(!isBlank('이메일도메인', '#userEmail2')){
		$.ajax({
			type : 'POST',
			url : '/techtalk/findPwd2X.do',
			data : {
				id : id,
				user_email : user_email
			},
			dataType : 'json',
			success : function(data) {
				var result_count = data.result_count;
				if(result_count == '0') {
					alert_popup_focus('이메일 주소를 확인해 주세요.',"#id");
					return false;
				}else{
					$('#btnFindPwd').css('display','none');
					$('#emailDiv').css('display','block');
					$('#btnSubmitNum').css('display','block');
					}
			},
			error : function() {
				
			},
			complete : function() {
				
			}
		});
	}
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
                           <h2>비밀번호 찾기</h2>
                            <label>비밀번호를 찾고자하는 아이디를 입력해 주세요.</label>
                           <div class="login_form">
                               <label>아이디</label>
                               <div class="login-form-input">
                                   <label><input type="text" class="form-control" id="id" name="id" placeholder="아이디를 입력해주세요." title="아이디" autofocus></label>
                               </div>
                           </div>
                           <div class="login_form" id="emailDiv" style="display:block;">
                               <label>이메일 주소</label>
                               <div class="login-form-input" style="display:inline-block;">
                                   <input type="text" class="form-control" id="userEmail1" name="user_email1"  title="이메일1" style="width:30%;">
                                   @
                                  <input type="text" class="form-control" id="userEmail2" name="user_email2"  title="이메일2" style="width:30%;">
                                  <button type="button" class="btn_login"  id="btnSubmitNum" title="인증번호 전송" style="width:30%; display:inline-block;">인증번호 전송</button>
                               </div>
                           </div>
                           
                           <div class="login_util">
                           		<div class="lu_left">
                           			<div class="box_checkinp">
					                </div>
                           		</div>
                           </div>
                           <button type="button" class="btn_login"  id="btnFindPwd" onclick="fncFindPwd();" title="다음">다음</button>
                           
                       </form>
                       </div>
                   </div>
               </div>
           </div>
		<!-- //compaVcContent e:  -->
		</div>