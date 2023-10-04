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
	$('#btnSubmitNum').click(function() {
		fncFindPwdToEmail();
	});
	$('#btnCheckCerti').click(function() {
		checkCerti();
	});
});

//[비밀번호 찾기] - 인증번호 보내기 -> 2023/09/21 - 박성민
function fncFindPwdToEmail() {
	var user_name = $('#userName').val();
	var user_email = $('#userEmail1').val()+"@"+$('#userEmail2').val();
	if(!isBlank('이름', '#userName'))
	if(!isBlank('이메일', '#userEmail1'))
	if(!isBlank('이메일도메인', '#userEmail2')){
		$('.loading_wrap').css('display','block');
		$.ajax({
			type : 'POST',
			url : '/techtalk/findIdX.do',
			data : {
				user_name : user_name,
				user_email : user_email
			},
			dataType : 'json',
			success : function(data) {
				$('.loading_wrap').css('display','none');
				var result_count = data.result_count;
				if(result_count == '0') {
					alert_popup_focus('이름 및 이메일을 확인해주세요.',"#userName");
					return false;
				}
				else if(result_count =='1'){
					$('#divCerti').css('display','block');
				}
			},
			error : function() {
				$('.loading_wrap').css('display','none');
			},
			complete : function() {
				$('.loading_wrap').css('display','none');
			}
		});
	}
}
//[아이디 찾기] - 인증번호 검증 -> 2023/09/21 - 박성민
function checkCerti() {
	var user_name = $('#userName').val();
	var user_email = $('#userEmail1').val()+"@"+$('#userEmail2').val();
	var certification_no = $('#certificationNo').val();
	if(!isBlank('인증번호', '#certificationNo')){
		$.ajax({
			type : 'POST',
			url : '/techtalk/doGetCertificationX.do',
			data : {
				user_name : user_name,
				certification_no : certification_no,
				user_email : user_email
			},
			dataType : 'json',
			success : function(data) {
				console.log(data.result);
				var result = data.result;
				if(result == null) {
					alert_popup_focus('인증번호를 확인하시거나 5분이내에 입력해주세요.',"#userName");
					return false;
				}
				else if(result != null){
					//alert("성공");
					console.log(data);
					var frm = document.createElement('form'); 
					frm.name = 'frm'; 
					frm.method = 'post'; 
					frm.action = '/techtalk/completeFindPwd.do'; 
					var input1 = document.createElement('input');
					var input2 = document.createElement('input'); 
					input1.setAttribute("type", "hidden"); 
					input1.setAttribute("name", "id"); 
					input1.setAttribute("value", data.result.id); 
					input2.setAttribute("type", "hidden"); 
					input2.setAttribute("name", "member_seqno"); 
					input2.setAttribute("value", data.result.member_seqno); 
					frm.appendChild(input1); 
					frm.appendChild(input2);
					document.body.appendChild(frm); 
					console.log(frm);
					console.log(data);
					console.log(data.result);
					frm.submit();
					
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
                           <h3 class="mgt20">본인확인 이메일로 인증( ${email} )</h3>
                           <p class="mgt10">비밀번호를 찾고자하는 아이디를 입력해 주세요.</p>
                           <div class="login_form">
                               <label>이름</label>
                               <div class="login-form-input">
                                   <label><input type="text" class="form-control" id="userName" name="user_name" placeholder="이름을 입력해주세요." title="이름" autofocus></label>
                               </div>
                           </div>
                           <div class="login_form" id="emailDiv" style="display:block;">
                               <label>이메일 주소</label>
                               <div class="login-form-input  d-flex g5" >
                                   <input type="text" class="form-control" id="userEmail1" name="user_email1"  title="이메일1" style="width:25%;">
                                   <span>@</span>
                                  <input type="text" class="form-control" id="userEmail2" name="user_email2"  title="이메일2">
                                  <button type="button" class="btn_default2 btn_nu"  id="btnSubmitNum" title="인증번호 전송" style="font-size:11px;">인증번호 전송</button>
                               </div>
                           </div>
                           <div class="login_form" style="display:none" id="divCerti">
                               <label>인증번호</label>
	                               <div class="d-flex g5">
	                                   <input type="text" class="form-control" id="certificationNo" name="certification_no"  title="인증번호" style="width:60%;">
	                                   <button type="button" class="btn_default btn_nu"  id="btnCheckCerti" title="인증번호 확인" style="font-size:12px;">인증번호 확인</button>
                                   </div>
                               </div>
                           <div class="login_util">
                           		<div class="lu_left">
                           			<div class="box_checkinp">
					                </div>
                           		</div>
                           </div>
                           
                       </form>
                       </div>
                   </div>
               </div>
           </div>
		<!-- //compaVcContent e:  -->
		</div>