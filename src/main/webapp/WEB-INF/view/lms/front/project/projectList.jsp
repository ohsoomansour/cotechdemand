<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<script>
	$(document).ready(function() {
		setParam();
		setTimeout(function(){
			$('#project_year').focus();
		}, 500);
		
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
	function doDetail(project_seqno){
		$('#project_seqno').val(project_seqno);
		$('#frm3').submit();
		}
	function doSubjectDetail(project_seqno){
		$('#project_seqno2').val(project_seqno);
		$('#frm2').submit();
	}
</script>
<form action="/project/detail.do" id="frm3" name="frm3" method="post">
	<input type="hidden" name="project_seqno" id="project_seqno" value="" />
</form>
<form action="/subject/apply.do" id="frm2" name="frm2" method="post">
	<input type="hidden" name="project_seqno" id="project_seqno2" value="" />
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
					<h3 class="tit_corp">사업공고</h3>
				</div>
				<!-- //page_title e:  -->
				<!-- page_content s:  -->
				<div class="area_cont">
					<div class="search_box">
						<div class="search_box_inner">
							<div class="search_cu_box">
								<span>사업년도</span> 
								<select class="select_normal select_year" id="project_year" name="project_year" title="사업년도" >
									<option title="사업년도" value="">사업년도</option>
									<option title="2021년" value="2021">2021년</option>
									<option title="2022년" value="2022">2022년</option>
									<option title="2023년" value="2023">2023년</option>
									<option title="2024년" value="2024">2024년</option>
									<option title="2025년" value="2025">2025년</option>
									<option title="2026년" value="2026">2026년</option>
									<option title="2027년" value="2027">2027년</option>
								</select>
							</div>
							<div class="search_cu_box">
								<span>진행상태</span> <select class="select_normal select_status"
									name="project_proc_status" id="project_proc_status" title="진행상태">
									<option title="전체" value="">전체</option>
									<option title="준비" value="00">준비</option>
									<option title="작성" value="10">작성</option>
									<option title="신청접수" value="20">신청접수</option>
									<option title="접수완료" value="50">접수완료</option>
									<option title="취소" value="90">취소</option>
								</select>
							</div>
							<div class="search_cu_box b_name_box">
								<span>사업명</span> 
								<input type="text" class="b_name" id="project_title" name="project_title" placeholder="검색할 사업명을 입력하세요" value=""  title="사업명"/>
							</div>
							<div class="btn_wrap">
								<button type="button" class="btn_step"  onClick="javascript:doSearch();" title="검색">
									<span>검색</span>
								</button>
							</div>
						</div>
					</div>
					<div class="subject_corp">
						<h3 class="tbl_ttc">
							사업공고 목록 <span class="total_cnt">총 ${paraMap.count} 건</span>
						</h3>
						<div class="ttc_select">
							<select class="select_normal " name="rows" id="rows" title="사업건수"
								 title="표시목록수">
								<option title="10건" value="10">10건</option>
								<option title="30건" value="30">30건</option>
								<option title="50건" value="50">50건</option>
								<option title="100건" value="100">100건</option>
							</select>
						</div>
					</div>
					<div class="tbl_comm tbl_public">
						<table class="tbl">
							<caption class="caption_hide">사업공고 리스트</caption>
							<colgroup>
								<col style="width: 100px;" />
								<col style="width: 120px;" />
								<col />
								<col style="width: 280px;" />
								<col style="width: 100px;" />
								<col style="width: 150px;" />
							</colgroup>
							<thead>
								<tr>
									<th scope="col">번호</th>
									<th scope="col">사업년도</th>
									<th scope="col">사업명</th>
									<th scope="col">사업신청서 접수기간</th>
									<th scope="col">진행상태</th>
									<th scope="col">사업신청서 제출</th>
								</tr>
							</thead>
							<tbody>
								<c:forEach var="data" items="${result }" varStatus="status">
									<tr>
										<td>${data.project_seqno}</td>
										<td>${data.project_year} </td>
										<td class="ta_left"><a
											href="javascript:void(0);" onclick="doDetail('${data.project_seqno}' );">${data.project_title }</a></td>
										<td>${data.project_apply_sdate }~
											${data.project_apply_edate }</td>

										<td>
											<c:if test="${ data.project_proc_status eq '10' }">
												<span class="lb lb_apply">임시저장</span>
											</c:if> 
											<c:choose>
												<c:when test="${ data.project_proc_status eq 20 and data.edate_chk eq 'N' and data.sdate_chk eq 'N'}">
													<span class="lb lb_ing">접수중</span>
												</c:when>
												<c:when test="${ data.project_proc_status eq 50}">
													<span class="lb lb_apply">접수완료</span>
												</c:when>
												<c:when test="${ data.edate_chk eq 'Y' and data.project_proc_status eq 20}">
													<span class="lb lb_end">접수마감</span>
												</c:when>
												<c:when test="${ data.sdate_chk eq 'Y' }">
													<span class="lb lb_convention">접수예정</span>
												</c:when>
											</c:choose>
										</td>
										<td>
											<c:choose>
												<c:when test="${ data.project_proc_status eq 20 and data.edate_chk eq 'N' and data.sdate_chk eq 'N'}">
													<a href="javascript:void(0);" onclick="doSubjectDetail('${data.project_seqno}' );" class="btn_step" title="신청관리">
												신청관리<span class="icon ico_go"></span></a>
												</c:when>
												<c:otherwise>
													-
												</c:otherwise>
											</c:choose>
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