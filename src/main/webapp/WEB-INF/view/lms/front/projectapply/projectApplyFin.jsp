<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<script>
	
</script>
<%
	String status = request.getParameter("status");
	pageContext.setAttribute("status", status);
%>
<div id="compaVcContent" class="cont_cv">
	<div id="mArticle" class="assig_app">
		<h2 class="screen_out">본문영역</h2>
		<div class="wrap_cont">
			<!-- page_title s:  -->
			<div class="area_tit">
				<c:if test="${ status eq 'save' }">
					<h3 class="tit_corp">사업신청서 저장 완료</h3>
				</c:if>
				<c:if test="${ status eq 'submit' }">
					<h3 class="tit_corp">사업신청서 접수 완료</h3>
				</c:if>
				<c:if test="${ status eq 'update' }">
					<h3 class="tit_corp">사업신청서 수정 완료</h3>
				</c:if>
			</div>
			<!-- //page_title e:  -->
			<!-- page_content s:  -->
			<div class="area_cont">
				<div class="box_complete">
					<c:if test="${ status eq 'update' }">
						<p class="bc_list">사업신청서 수정이  완료되었습니다.</p>
					</c:if>
					<c:if test="${ status ne 'update' }">
						<p class="bc_list">사업신청서 접수가 완료되었습니다.</p>
				</c:if>
					
					<p class="bc_list">
						<strong>[과제관리 - 사업신청현황]</strong>에서 신청하신 사업신청서에 대한 진행상황을 확인할 수
						있습니다.
					</p>

				</div>
				<div class="wrap_btn _center">
					<a href="/subject/list.do" class="btn_appl">[사업신청현황] 바로가기 </a>
				</div>
			</div>

			<!-- //page_content e:  -->
		</div>
	</div>
</div>
<%-- <div class="">
	<div class="top_item">
		
		<br />
		<br />
		<br />
		<br />
		<div style="border: 1px solid">
			<c:if test="${ status eq 'save' }">
				<span> 사업신청서 저장이 완료되었습니다.</span>
				<br />
			</c:if>
			<c:if test="${ status eq 'submit' }">
				<span> 사업신청서 접수가 완료되었습니다.</span>
				<br />
			</c:if>

			<span> [과제관리 - 과제신청현황] 에서 신청하신 사업신청서에 대한 진행상황을 확인할 수 있습니다.</span></br>
		</div>
		<br /> <br />
		<br />
		<br />
		<button type="button" onclick="location.href='/projectapply/list.do'">[과제신청현황]
			으로 이동</button>

	</div>


</div> --%>
