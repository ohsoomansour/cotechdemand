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
<style>
	.loginContainer {text-align: center; height: 300px; vertical-align: middle; padding-top: 100px;}
	.logo img {padding-right: 120px;}
	.loginWrap {border: none;}
	.inputs {padding: 5px; margin: 5px;}
	p.inputs input {width: 300px; height: 20px; padding: 5px; font-size: 15px;}
	p.submit iuput {width: 300px; height: 20px; padding: 5px; margin: 5px;}
	p.warning {padding: 5px; margin: 5px;}
</style>

<script src="${pageContext.request.contextPath}/plugins/icheck/icheck.min.js"></script>
<script src="/js/lms/control/LocalStorageCtrl.js?ts=<%=tstamp%>"></script>

<script type="text/javascript">
var _lsCtrl		= new LocalStorageCtrl();

var LoginCtrl = {
		
	doLogin : function() {
		console.log($('#userid').val());
		if ($.trim($("#userid").val()) == "") {
			//alert_popup("아이디를 입력해 주세요.");
			alert_popup_focus("아이디를 입력해 주세요.", "#userid");
			return false;
		}
		else if($.trim($("#userpw").val()) == "") {
			//alert_popup('비밀번호를 입력해 주세요.');
			alert_popup_focus('비밀번호를 입력해 주세요.', '#userpw');
			return false;
		}
				
		$.ajax({
			url : "/login/loginx.do",
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
					alert_popup("로그인 되었습니다.");
					location.href = "/admin/mainView.do";
					//parent.location.reload();
					//parent.$('#dialog').dialog('destroy');			
				}
				else {
					alert_popup(resp.result_mesg);
					location.href = "/login/login.do";
				}
			},
			error : function(result) {
				//alert_popup('로그인 통신 오류');
				alert_popup_focus('로그인 통신 오류', '#btnLogin');
			}
		});
		return false;
	},
};

function doLogout() {
	var strLogoutUrl = "/login/logoutx.do";

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
				return false;
			}
		}
	});
	return false;
};


$(document).ready(function() {
	//doLogout();
	
	$("#btnLogin").click(function(e) {
		e.preventDefault();
		LoginCtrl.doLogin();
	});

	$('input').iCheck({
		checkboxClass: 'icheckbox_square-blue',
		radioClass: 'iradio_square-blue',
		increaseArea: '20%' // optional
	});


});
	
</script>

<div class="login-box">
	<div class="login-logo"><b>TTM University</b></div>
	
	<div class="login-box-body">
		<p class="login-box-msg">로그인</p>

		<form id="frm_login" method="post">
			<input type="hidden" id="gourl" name="gourl" value="/" />
			<input type="hidden" id="siteid" name="siteid" value="${siteid}" />
			
			<div class="form-group has-feedback">
				<input type="text" id="userid" name="userid" class="form-control" placeholder="아이디" title="아이디">
				<span class="glyphicon glyphicon-envelope form-control-feedback"></span>
			</div>
			<div class="form-group has-feedback">
				<input type="password" id="userpw" name="userpw" class="form-control" placeholder="비밀번호" title="비밀번호">
				<span class="glyphicon glyphicon-lock form-control-feedback"></span>
			</div>
			<div class="row">
				<div class="col-xs-8">
					<div class="checkbox icheck">
						<label>
							<a href="javascript:void(0);" title="비밀번호 찾기">비밀번호 찾기</a>
						</label>
					</div>
				</div>
				<div class="col-xs-4">
					<button id="btnLogin" class="btn btn-primary btn-block btn-flat" title="로그인">로그인</button>
				</div>
			</div>
		</form>
	</div>
</div>

