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

