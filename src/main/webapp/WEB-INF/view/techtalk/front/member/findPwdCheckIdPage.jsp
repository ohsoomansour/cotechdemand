<<<<<<< HEAD
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
				var frm = document.createElement('form'); 
				frm.name = 'frm'; 
				frm.method = 'post'; 
				frm.action = '/techtalk/findPwdPage.do'; 
				var input1 = document.createElement('input'); 
				input1.setAttribute("type", "hidden"); 
				input1.setAttribute("name", "email"); 
				input1.setAttribute("value", data.result); 
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
=======
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
				var frm = document.createElement('form'); 
				frm.name = 'frm'; 
				frm.method = 'post'; 
				frm.action = '/techtalk/findPwdPage.do'; 
				var input1 = document.createElement('input'); 
				input1.setAttribute("type", "hidden"); 
				input1.setAttribute("name", "email"); 
				input1.setAttribute("value", data.result); 
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
>>>>>>> refs/remotes/origin/develop
		</div>