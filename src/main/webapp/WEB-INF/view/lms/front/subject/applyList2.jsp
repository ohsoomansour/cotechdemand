<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<script>
$(document).ready(function(){
	setParam();
});

function setParam(){
	var yearVal = '${paraMap.project_year}';
	var nameVal = '${paraMap.project_name}';
	var statusVal = '${paraMap.process_status}';
	$('#project_year').val(yearVal);
	$('#project_name').val(nameVal);
	$('#process_status').val(statusVal);
}

function doSearch(e){
	$('#page').val(1);
	$('#frm').submit();
}

//페이징
function fncList(page) {
	$('#page').val(page);
	$('#frm').submit();
}
</script>
<form action="#" id="frm" name="frm" method="get">
<input type="hidden" name="page" id="page" value="${paraMap.page}" />
<%-- <input type="hidden" name="rows" id="rows" value="${paraMap.rows}" /> --%>
<input type="hidden" name="sidx" id="sidx" value="${paraMap.sidx}" />
<input type="hidden" name="sord" id="sord" value="${paraMap.sord}" />
<div class="" style="margin-left:240px">
	<div class="top_item">
		<h2>사업신청 현황</h2>
			<div style="border: solid 1px; margin: 10px 10px">
				<div style="margin-left:15px">
					<label> 사업년도</label> 
					<select id="project_year" name="project_year" style="margin-left:15px" >
						<option value="">연도를 선택하세요</option>
						<option value="2021">2021년</option>
						<option value="2022">2022년</option>
						<option value="2023">2023년</option>
						<option value="2024">2024년</option>
						<option value="2025">2025년</option>
						<option value="2026">2026년</option>
						<option value="2027">2027년</option>
					</select> 
					<label> 사업명 </label>
					<input type="text" id="project_name" name="project_name" placeholder="검색할 사업명을 입력하세요" value=""/>
					<button type="button" value="검색" style="margin-left:15px" onClick="javascript:doSearch();">검색</button>
				</div>
				<div style="margin-left:15px">
					<label>진행상태</label>
					<select name="process_status" id="process_status">
						<option value="">전체</option>
						<option value="00">임시저장</option>
						<option value="20">접수중</option>
						<option value="50">접수종료</option>
						<option value="90">취소</option>
					</select>
				</div>
			</div>
		<div class="bottom_item">
		<h4>사업신청 대상사업 건수 : ${paraMap.count} 건</h2>
		
		<table  style="border:1px solid; display:list-item ; margin:10px 10px auto;">
			<tr  align="center">
				<td>순번</td>
				<td>공고사업명</td>
				<td>사업수행기간</td>
				<td>진행상태</td>
				<td>상태별기능</td>
			</tr>
			<c:forEach var="data" items="${result }" varStatus="status">
			<tr>
				<td>${status.count}</td>
				<td>${data.subject_name }</td>
				<td>${data.subject_sdate } ~ ${data.subject_edate }</td>
				<td>
				<c:if test="${ data.process_step eq '00' || data.process_step eq '0 ' }">
						[신청]
					</c:if>
					<c:if test="${ data.process_step eq '20'}">
						[협약]
					</c:if>  
					<c:if test="${ data.process_step eq '40'}">
						[잔금처리]
					</c:if>
					<c:if test="${ data.process_step eq '99'}">
						[종료]
					</c:if>  
				</td>
				<td>
					
				 </td>
				<td>
					<a href="/subject/apply.do?seqNo=${data.subject_seqno}">바로가기</a>
				</td>
			</tr>
			</c:forEach>			
		</table>
		</div>
		<select name="rows" id="rows" onchange="doSearch();" title="표시목록수">
						<option value="10">10/30/50/100 건씩 조회</option>
						<option value="10">10건씩 조회</option>
						<option value="30">30건씩 조회</option>
						<option value="50">50건씩 조회</option>
						<option value="100">100건씩 조회</option>
					</select>
	</div>
	

</div>
<!-- paging -->
<div class="boardBottomArea" style="padding-left:300px">
	<div id="page_space">
		${ sPageInfo }
	</div>
</div>
</form>