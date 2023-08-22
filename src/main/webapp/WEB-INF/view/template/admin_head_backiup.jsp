<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<script>
function doLogout() {
	$.ajax({
		url : "/login/logoutx.do",
		type : "POST",
		dataType : "json",
		success : function(resp) {
			if (resp.result_code == "0") {
				alert_popup('로그아웃 되었습니다.')
				location.href = "/login/login.do";
			}
			else {
				alert_popup(resp.result_mesg);
			}
		}
	});
	return false;
};
$(document).ready(function() {
	$("#btnLogout").click(function() {
		doLogout();
	});
});
</script>
<nav class="navbar navbar-inverse navbar-fixed-top">
   <div class="container-fluid">
     <div class="navbar-header">
       <a class="navbar-brand" href="/admin/mainView.do" title="메인화면"><img src="${pageContext.request.contextPath}/images/admin/logo/main_logo.png"><!-- 역량통합관리시스템 --></a>
     </div>
     <div class="navbar-user">
       <ul >
         <li><a href="#" id="btnLogout" style="text-decoration: none;" title="로그아웃">로그아웃</a></li>
       </ul>
     </div>
     <div class="navbar-user">
       <ul >
         <li>관리자님 반갑습니다.</li>
       </ul>
     </div>
   </div>
 </nav>