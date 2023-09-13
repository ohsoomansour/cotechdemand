<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>엑셀 데모 페이지</title>

</head>
<body>
	<h1>엑셀 데모 페이지</h1>

  <form method="post" action="/demo/excel" enctype="multipart/form-data">
    <input type="file" name="uploadFile" />
    <button type="submit">업로드</button>
  </form>
</body>
</html>