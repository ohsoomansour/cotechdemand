<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>엑셀 데모 페이지</title>
<style>
  .wrap {
    width: 100%;
  }

  .wrap tr {
    background: #e7e7e7;
  }

  .wrap th {
    background: #5f5f5f;
    color: #fff;
  }
</style>
</head>
<body>
	<h1>엑셀 데모 결과 페이지</h1>

  <div class="wrap">
    <table>
      <thead>
        <tr>
        <c:forEach var="headers" items="${result.headers}">
          <th>${headers}</th>
        </c:forEach>
        </tr>
      </thead>
      <tbody>
        <c:forEach var="data" items="${result.data}">
          <tr>
          <c:forEach var="headers" items="${result.headers}">
            <td>${data[headers]}</td>
          </c:forEach>
          </tr>
        </c:forEach>
      </tbody>
    </table>
  </div>

</body>
</html>