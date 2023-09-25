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

//[비밀번호변경] - 2023/09/25 - 박성민
function changePwd(){
	if(!isBlank('현재 비밀번호', '#pw'))
	if(!isBlank('새 비밀번호', '#newPwd'))
	if(!isBlank('새 비밀번호 확인', '#newPwdChk'))
	if($('#newPwd').val() != $('#newPwdChk').val()){
		alert_popup_focus('새 비밀번호와 새비밀번호 확인이 일치하지 않습니다.', '#newPwdChk');
		return false;
		}
	var url = '/techtalk/updatePw2X.do';
	var form = $('#frm')[0];
	var data = new FormData(form);
	$.ajax({
		url : url,
       type: "post",
       processData: false,
       contentType: false,
       data: data,
       dataType: "json",
       success : function(res){
	       if(res.result==0){
	    	   alert_popup_focus('현재 비밀번호가 일치하지 않습니다 비밀번호를 확인해 주세요.', '#pwd');
		       }else if(res.result==1){
			       alert("비밀번호가 변경되었습니다. 다시 로그인 해주세요.");
			       doLogout();
			       }
    	   
       },
       error : function(){
    		alert('실패했습니다.');    
       },
       async:false,
       complete : function(){

       }
	});
}

</script>
<form id="frm">
				<input type="hidden" id="id" name="id" value="${id }"/>
				<input type="hidden" id="member_seqno" name="member_seqno" value="${member_seqno }"/>

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
                           <h2>비밀번호 재설정</h2>
                           <div class="login_form">
                               <label>새로운 비밀번호</label>
                               <div class="login-form-input">
                                   <label><input type="password" class="form-control" id="newPwd" name="new_pwd" placeholder="새로운 비밀번호를 입력해주세요." title="새로운 비밀번호" autofocus></label>
                               </div>
                                <label>새로운 비밀번호 확인</label>
                               <div class="login-form-input">
                                   <label><input type="password" class="form-control" id="newPwdChk" name="new_pwd_chk" placeholder="새로운 비밀번호를 다시 입력해주세요." title="새로운 비밀번호 확인" ></label>
                               </div>
                           </div>
                           <div class="login_util">
                           		<div class="lu_left">
                           			<div class="box_checkinp">
					                </div>
                           		</div>
                           </div>
                           <button type="button" class="btn_login"  id="btnChangePwd" onclick="changePwd();" title="변경하기">변경하기</button>
                           
                       </form>
                       </div>
                   </div>
               </div>
           </div>
		<!-- //compaVcContent e:  -->
		</div>
		</form>