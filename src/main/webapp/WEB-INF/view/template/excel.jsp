<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page import="java.net.URLEncoder"%>
<%
response.setContentType("application/x-ms-excel");
response.setCharacterEncoding("UTF-8");
response.setHeader("Content-Disposition", "attachment;filename=" + URLEncoder.encode(request.getAttribute("title").toString(), "UTF-8")+".xls");
//response.setHeader("Content-Disposition", "attachment;filename=" + URLEncoder.encode(request.getAttribute("title").toString(), "iso-8859-1")+".xls");
response.setHeader("Content-Transfer-Encoding", "binary");
response.setHeader("Pragma", "no-cache;");
response.setHeader("Expires", "-1;");
%>
<html>
<meta charset="utf-8">
<h2> ${title } </h2>
<table border="1" >
<tr>
<c:forEach items="${excelHeader }" var="head">
	<th> ${head} </th>
</c:forEach>
</tr>

<c:forEach items="${excelBody }" var="body">
<tr>
	<c:forEach items="${body }" var="item">
	<td> ${item} </td>
	</c:forEach>
</tr>	
</c:forEach>	
</table>
</html>