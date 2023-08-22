<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%
	String locale = response.getLocale().toString();
%>
<!DOCTYPE html>
<html lang="<%=locale%>">
<head>
	<title><tiles:getAsString name="title" /></title>
	<meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">
    <title>관리자</title>
    <!-- Bootstrap core CSS -->
    <script src="${pageContext.request.contextPath}/js/jquery-2.2.3.min.js?v=1"></script>
    <script>
		jQuery.curCSS = function(element, prop, val) {
			return jQuery(element).css(prop, val);
		} 
		
	    jQuery.browser = {};
	    (function () {
	        jQuery.browser.msie = false;
	        jQuery.browser.version = 0;
	        if (navigator.userAgent.match(/MSIE ([0-9]+)\./)) {
	            jQuery.browser.msie = true;
	            jQuery.browser.version = RegExp.$1;
	        }
	    })();
    </script>
    <script src="${pageContext.request.contextPath}/plugins/bootstrap/js/bootstrap.min.js?v=1"></script>
    <link href="${pageContext.request.contextPath}/plugins/bootstrap/css/bootstrap.min.css?v=1" rel="stylesheet">
    <!-- jqGrid -->
    <script src="${pageContext.request.contextPath}/plugins/jqgrid/jquery.jqgrid.min.js?v=1"></script>
    <script src="${pageContext.request.contextPath}/plugins/jqgrid/i18n/grid.locale-kr.js?v=1"></script>  
    <link href="${pageContext.request.contextPath}/plugins/jqgrid/ui.jqgrid.css?v=1" rel="stylesheet" type="text/css"/>
	<!-- Jquery Datepicker -->
	<script src="${pageContext.request.contextPath}/js/jquery-ui-1.12.1/jquery-ui.js?v=1"></script>
	<link href="${pageContext.request.contextPath}/js/jquery-ui-1.12.1/jquery-ui.css?v=1" rel="stylesheet"/>
	<!-- ckeditor -->
	<script src="${pageContext.request.contextPath}/plugins/ckeditor/ckeditor.js?v=1" ></script>
	<script src="${pageContext.request.contextPath}/plugins/multifile-master/jquery.MultiFile.js?v=1"></script>
	<!-- mcdropdown -->
	<script type="text/javascript" src="${pageContext.request.contextPath}/plugins/jquery.mcdropdown/lib/jquery.mcdropdown.js?v=1"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/plugins/jquery.mcdropdown/lib/jquery.bgiframe.js?v=1"></script>
	<link type="text/css" href="${pageContext.request.contextPath}/plugins/jquery.mcdropdown/css/jquery.mcdropdown.css?v=1" rel="stylesheet" media="all" />
	<!-- common.js -->
	<script src="/js/lms/common.js?v=1"></script>
	<link href="${pageContext.request.contextPath}/css/front/fontawesome.css?v=1" rel="stylesheet">	
	<link href="${pageContext.request.contextPath}/css/front/common.css?v=1" rel="stylesheet">	
	<!-- chart.js -->
	<script src="${pageContext.request.contextPath}/plugins/chart/Chart.min.js?v=1"></script>
	<!-- login skin -->
	<link rel="stylesheet" href="${pageContext.request.contextPath}/theme/skin/css/AdminLTE.css?v=1">
</head>
<body class="pop_layout">
<tiles:insertAttribute name="body" />
</body>
</html>