<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>오류 페이지</title>
<style type="text/css">
	body {
		font-size: 62.5%;
	}
	body {
		font-family: Trebuchet MS, Helvetica, Arial,  Verdana, sans-serif;
	}
</style>

</head>
<body>
	<h3>오류 발생 [${result_code}]</h3>
	<hr/>
	${result_mesg}
	<%

	Throwable exception = (Throwable) request.getAttribute("exception");
	exception.printStackTrace();

	%>
</body>
</html>