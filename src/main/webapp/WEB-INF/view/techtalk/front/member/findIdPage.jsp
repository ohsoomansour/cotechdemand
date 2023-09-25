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
	$("#user_email2").keyup(function(e){
		if(e.keyCode == 13){
			e.preventDefault();
			LoginCtrl.doLogin();
		}
	 });
	
	$('#btnFindId').click(function() {
		fncFindId();
	});
	$('#btnCheckCerti').click(function() {
		checkCerti();
	});
});

//[아이디 찾기] - 인증번호 보내기 -> 2023/09/21 - 박성민
function fncFindId() {
	var user_name = $('#userName').val();
	var user_email = $('#userEmail1').val()+"@"+$('#userEmail2').val();
	if(!isBlank('이름', '#userName'))
	if(!isBlank('이메일', '#userEmail1'))
	if(!isBlank('이메일도메인', '#userEmail2')){
		$('#btnFindId').prop('disabled','true');
		$('#btnFindId').css('background-color','grey');
		$('.wrap-loading').removeClass('display-none');
		$.ajax({
			type : 'POST',
			url : '/techtalk/findIdX.do',
			data : {
				user_name : user_name,
				user_email : user_email
			},
			dataType : 'json',
			success : function(data) {
				$('.wrap-loading').addClass('display-none');
				var result_count = data.result_count;
				if(result_count == '0') {
					alert_popup_focus('이름 및 이메일을 확인해주세요.',"#userName");
					return false;
				}
				else if(result_count =='1'){
					$('#divCerti').css('display','inline-block');
					alert_popup_focus('인증번호를 발송했습니다. 인증번호가 오지 않으면 입력하신 정보가 회원정보와 일치하는지 확인해 주세요..',"#certificationNo");
				}
			},
			error : function() {
				$('.wrap-loading').addClass('display-none');
				$('#btnFindId').prop('disabled','false');
				$('#btnFindId').css('background-color','#5f24e2');
			},
			complete : function() {
				
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
					
					var frm = document.createElement('form'); 
					frm.name = 'frm'; 
					frm.method = 'post'; 
					frm.action = '/techtalk/completeFindId.do'; 
					var input1 = document.createElement('input'); 
					input1.setAttribute("type", "hidden"); 
					input1.setAttribute("name", "id"); 
					input1.setAttribute("value", data.result.id); 
					frm.appendChild(input1); 
					document.body.appendChild(frm); 
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
                                   <input type="text" class="form-control" id="userEmail1" name="user_email1"  title="이메일1" style="width:31%;">
                                   @
                                  <input type="text" class="form-control" id="userEmail2" name="user_email2"  title="이메일2" style="width:31%;">
                                  <button type="button" class="btn_login"  id="btnFindId" title="인증번호 전송" style="width:30%;">인증번호 전송</button>
                               </div><br/>
                               
                               <div class="login-form-input" style="display:none;" id="divCerti">
                               <label>인증번호</label>
                                   <input type="text" class="form-control" id="certificationNo" name="certification_no"  title="인증번호" style="width:60%;">
                                   <button type="button" class="btn_login"  id="btnCheckCerti" title="인증번호 확인" style="width:30%;">인증번호 확인</button>
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
		<div class="wrap-loading" style="display-none">
    	<div><img src="/images/loading.gif"/></div>
		</div>