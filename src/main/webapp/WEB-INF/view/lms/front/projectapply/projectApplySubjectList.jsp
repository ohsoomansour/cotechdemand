<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<script>
	$(document).ready(function() {
		setParam();
	});

	function setParam() {
		var yearVal = '${paraMap.project_year}';
		var nameVal = '${paraMap.project_title}';
		var statusVal = '${paraMap.project_proc_status}';
		$('#project_year').val(yearVal);
		$('#project_title').val(nameVal);
		$('#project_proc_status').val(statusVal);
	}

	function doSearch(e) {
		$('#page').val(1);
		$('#frm').submit();
	}

	//페이징
	function fncList(page) {
		$('#page').val(page);
		$('#frm').submit();
	}
	function doPerform(subject_seqno){
		$('#subject_seqno').val(subject_seqno);
		$('#frm2').submit();
	}
</script>
<form action="/subject/applyPerformance.do" id="frm2" name="frm2" method="post">
	<input type="hidden" name="subject_seqno" id="subject_seqno" value="" />
</form>

<form action="#" id="frm" name="frm" method="get">
	<input type="hidden" name="page" id="page" value="${paraMap.page}" />
	<%-- <input type="hidden" name="rows" id="rows" value="${paraMap.rows}" /> --%>
	<input type="hidden" name="sidx" id="sidx" value="${paraMap.sidx}" />
	<input type="hidden" name="sord" id="sord" value="${paraMap.sord}" />
	
	<!-- compaVcContent s:  -->
	<div id="compaVcContent" class="cont_cv">
		<div id="mArticle" class="assig_app">
			<h2 class="screen_out">본문영역</h2>
			<div class="wrap_cont">
				<!-- page_title s:  -->
				<div class="area_tit">
					<h3 class="tit_corp">사업신청 및 과제수행 현황</h3>
				</div>
				<!-- //page_title e:  -->
				<!-- page_content s:  -->
				<div class="area_cont">
					<div class="search_box">
						<div class="search_box_inner">
							<div class="search_cu_box">
								<span>사업년도</span> 
								<select class="select_normal select_year" id="project_year" name="project_year" >
									<option value="">검색년도</option>
									<option value="2021">2021년</option>
									<option value="2022">2022년</option>
									<option value="2023">2023년</option>
									<option value="2024">2024년</option>
									<option value="2025">2025년</option>
									<option value="2026">2026년</option>
									<option value="2027">2027년</option>
								</select>
							</div>
							<div class="search_cu_box">
								<span>진행상태</span> <select class="select_normal select_status"
									name="project_proc_status" id="project_proc_status">
									<option value="">전체</option>
									<option value="00">임시저장</option>
									<option value="20">접수중</option>
									<option value="50">접수종료</option>
									<option value="90">취소</option>
								</select>
							</div>
							<div class="search_cu_box b_name_box">
								<span>사업명</span> 
								<input type="text" class="b_name"id="project_title" name="project_title" placeholder="검색할 사업명을 입력하세요" value="" />
							</div>
							<div class="btn_wrap">
								<button type="button" class="btn_step"  onClick="javascript:doSearch();">
									<span>검색</span>
								</button>
							</div>
						</div>
					</div>
					<div class="subject_corp">
						<h3 class="tbl_ttc">
							사업신청 현황  <span class="total_cnt">${paraMap.count} 건</span>
						</h3>
						<div class="ttc_select">
							<select class="select_normal " name="rows" id="rows"
								onchange="doSearch();" title="표시목록수">
								<option value="10">10건</option>
								<option value="30">30건</option>
								<option value="50">50건</option>
								<option value="100">100건</option>
							</select>
						</div>
					</div>
					<div class="tbl_comm tbl_public">
						<table class="tbl">
							<caption class="caption_hide">사업신청 과제신청 리스트</caption>
							<colgroup>
								<col style="width: 100px;" />
								<col />
								<col style="width: 280px;" />
								<col style="width: 100px;" />
								<col style="width: 150px;" />
							</colgroup>
							<thead>
								<tr>
									<th>번호</th>
									<th>사업명</th>
									<th>사업수행기간</th>
									<th>진행상태</th>
									<th>신청관리</th>
								</tr>
							</thead>
							<tbody>
								<c:forEach var="data" items="${result }" varStatus="status">
									<tr>
										<td>${data.project_seqno}</td>
										<td class="ta_left"><a
											href="/projectapply/detail.do?seqNo=${data.project_seqno}">${data.project_title }</a></td>
										<td>${data.project_apply_sdate }~
											${data.project_apply_edate }</td>

										<td>
											<c:if test="${ data.status eq '00' || data.status eq '0 ' }">
												<span class="lb lb_apply">임시저장</span>
											</c:if> 
											<c:if test="${ data.status eq '10'}">
												<span class="lb lb_convention">접수중</span>
											</c:if> 
											<c:if test="${ data.status eq '20'}">
												<span class="lb lb_convention">접수중</span>
											</c:if> 
											<c:if test="${ data.status eq '40'}">
												<span class="lb lb_apply">접수종료</span>
											</c:if> 
											<c:if test="${ data.status eq '99'}">
												<span class="lb lb_apply">취소</span>
											</c:if>
										</td>
										<td>
											<%-- <c:if test="${ data.status eq '00'}">
													
											</c:if>
											<c:if test="${ data.status ne '00'}">
												
												<a href="javascript:void(0);" class="btn_step" onclick="doPerform('${data.subject_seqno}')">신청관리<span class="icon ico_go"></span></a>
												
											</c:if> --%>
											<a href="/subject/apply.do?seqNo=${data.project_seqno}" class="btn_step">신청관리<span class="icon ico_go"></span></a>
										</td>
										
									</tr>
								</c:forEach>
							</tbody>
						</table>
					</div>
					<!-- paging -->
	
					<div class="paging_comm">${ sPageInfo }</div>
				</div>
				<!-- //page_content e:  -->
			</div>
		</div>
	</div>
	<!-- //compaVcContent e:  -->


	
</form>