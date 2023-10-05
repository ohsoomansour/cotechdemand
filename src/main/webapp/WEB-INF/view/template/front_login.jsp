<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ page import="java.util.Date" %>
<%
	String locale = response.getLocale().toString();
	Date dt = new Date(); long tstamp = dt.getTime();

	session = request.getSession(true);
%>
<!DOCTYPE html>
<html lang="<%=locale%>">
<head>
	<meta charset="UTF-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<title><tiles:getAsString name="title" /></title>
	
	<!-- Bootstrap core CSS -->
    <script src="${pageContext.request.contextPath}/js/jquery-2.2.3.min.js?v=1"></script>
	<script src="${pageContext.request.contextPath}/js/jquery-ui.min.js?v=1" ></script>
	<script src="${pageContext.request.contextPath}/js/jquery.tmpl.min.js?v=1" ></script>

	
	<script src="${pageContext.request.contextPath}/js/lms/control/LocalStorageCtrl.js?ts=<%=tstamp%>"></script>

	<!-- common.js -->
	<script src="/js/lms/common.js?v=1"></script>
	<link href="${pageContext.request.contextPath}/css/front/common.css?v=1" rel="stylesheet">
	<link href="${pageContext.request.contextPath}/css/front/font.css?v=1" rel="stylesheet">

	<!--[if lt IE 9]>
	<script src="${pageContext.request.contextPath}/plugins/html5ie/html5shiv.min.js?v=1"></script>
	<script src="${pageContext.request.contextPath}/plugins/html5ie/respond.min.js?v=1"></script>
	<![endif]-->
	
	<script>
		$(document).ready(function() {
			// family site
			/*
            var titRelation = document.getElementsByClassName('tit_relation')[0];
            if(titRelation.addEventListener) {
                titRelation.addEventListener('click', function (event) {
                    if (this.parentNode.classList.contains('relation_open')) {
                        this.parentNode.classList.remove('relation_open');
                        this.childNodes[0].setAttribute('aria-expanded', 'false');
                    } else {
                        this.parentNode.classList.add('relation_open');
                        this.childNodes[0].setAttribute('aria-expanded', 'true');
                    }
                });
            } else {
                titRelation.attachEvent('onclick', function (event) {
                    if (this.parentNode.classList.contains('relation_open')) {
                        this.parentNode.classList.remove('relation_open');
                        this.childNodes[0].setAttribute('aria-expanded', 'false');
                    } else {
                        this.parentNode.classList.add('relation_open');
                        this.childNodes[0].setAttribute('aria-expanded', 'true');
                    }
                });
            }
*/
		});
	</script>
</head>
<body class="Login">
	<tiles:insertAttribute name="body" />
	<div class="dim-layer-common alertCls">
	    <div class="dimBgg"></div>
	    <div id="layer99" class="pop-layer" style="height:220px">
	        <div class="pop-container">
	        <div class="pop-title"><h3>알림</h3></div>
	            <div id="tap1_1" style="display: block">
					<div class="table2 mTop5">
						<div class="line form-inline alignCenter">
							<div style="margin-top: 30px">
								<label id="alertTxt">ㅅㄷㅌㅅ</label>
							</div>
						</div>
						<div class="tbl_public" >
							<div style="text-align:center;margin-top:20px;">
			                	<button type="button" class="btn_step" id="cancelAlert" name="btnCancel" title="닫기">닫기</button>
		                	</div>
		                </div>
					</div>
				</div>
	        </div>
    	</div>
	</div>
	<!-- 로딩 -->
	<div class="loading_wrap" style="display:none;">
		<div class="loader"></div>
	</div>
</body>
</html>