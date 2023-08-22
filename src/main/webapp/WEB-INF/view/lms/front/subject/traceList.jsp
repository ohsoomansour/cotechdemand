<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<script>
	$(document).ready(function() {
		setParam();
		setTimeout(function(){
			$('#project_title').focus();
		}, 500);
		
	});

	function setParam() {
		var subject_proc_status = '${paraMap.subject_proc_status}'
		$('#subject_proc_status').val(subject_proc_status).prop("selected",true);
		var page_rows = '${paraMap.rows}'
		$('#rows').val(page_rows).prop("selected", true);
	}

	function doConfirmSearch(){
		var selectedVal = $('#rows option:selected').val();
		var check = confirm(selectedVal+"건을 조회 하시겠습니까?");
		if(check) {
			doSearch();
		}else{
			return false;
		}
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
	function doDetail(subject_seqno,project_seqno){
		$('#subject_seqno').val(subject_seqno);
		$('#project_seqno').val(project_seqno);
		$('#frm2').submit();
	}
</script>
<form action="/subject/traceDetail.do" id="frm2" name="frm2" method="post">
	<input type="hidden" name="subject_seqno" id="subject_seqno" value="" />
	<input type="hidden" name="project_seqno" id="project_seqno" value="" />
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
					<h3 class="tit_corp">사업수행관리 - 추적조사 현황</h3>
				</div>
				<!-- //page_title e:  -->
				<!-- page_content s:  -->
				<div class="area_cont">
					<div class="search_box">
						<div class="search_box_inner">
							<div class="search_cu_box b_name_box">
								<span>사업명</span> 
								<input type="text" style="width:890px;margin-left:14px" id="project_title" name="project_title" placeholder="검색할 사업명을 입력하세요" value="${paraMap.project_title }" title="사업명" />
							</div>
							<div class="search_cu_box b_name_box">
								<span>과제명</span> 
								<input type="text" style="width:890px;margin-left:14px" id="subject_title" name="subject_title" placeholder="검색할 과제명을 입력하세요" value="${paraMap.subject_title }"  title="과제명" />
							</div>
							<br/>
							<div class="search_cu_box b_name_box">
								<span>협약번호</span> 
								<input type="text" style="width:400px; margin-right:22px;" id="subject_ref" name="subject_ref" placeholder="검색할 협약번호를 입력하세요" value="${paraMap.subject_ref }"  title="협약번호" />
							</div>
							<div class="search_cu_box">
								<span>진행상태</span>
								<select class="select_normal select_status" style="width:402px;"
									name="subject_proc_status" id="subject_proc_status" title="진행상태">
									<option title="전체" value="">전체</option>
									<option title="준비" value="00">준비</option>
									<option title="작성" value="10">작성</option>
									<option title="등록" value="20">등록</option>
									<option title="검토" value="30">검토</option>
									<option title="확인" value="50">확인</option>
									<option title="거부" value="90">거부</option>
								</select>
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
							추적조사 현황  <span class="total_cnt">${paraMap.count} 건</span>
						</h3>
						<div class="ttc_select">
							<select class="select_normal " name="rows" id="rows"
								onchange="doConfirmSearch();" title="표시목록수">
								<option title="10건" value="10">10건</option>
								<option title="30건" value="30">30건</option>
								<option title="50건" value="50">50건</option>
								<option title="100건" value="100">100건</option>
							</select>
						</div>
					</div>
					<div class="tbl_comm tbl_public">
						<table class="tbl">
							<caption class="caption_hide">추적조사 리스트</caption>
							<colgroup>
								<col style="width: 50px;" />
								<col style="width: 100px;" />
								<col style="width: 200px;" />
								<col style="width: 150px;" />
								<col style="width: 150px;" />
								<col style="width: 100px;" />
								<col style="width: 80px;" />
								<col style="width: 90px;" />
							</colgroup>
							<thead>
								<tr>
									<th>순번</th>
									<th>협약번호</th>
									<th>바우처 과제명</th>
									<th>수요기업<br/>공급기업</th>
									<th>협약기간</th>
									<th>진행상태</th>
									<th>수행결과</th>
									<th>상세보기</th>
								</tr>
							</thead>
							<tbody>
								<c:forEach var="data" items="${result }" varStatus="status">
									<tr>
										<td>${status.count}</td>
										<td>${data.subject_ref}</td>
										<td>${data.subject_title }</td>
										<td>${data.tmdc_biz_name}<br/>${data.tmsc_biz_name}</td>
										<td>${data.subject_sdate} ~ ${data.subject_edate}</td>
										<td>
											<c:if test="${data.ts_subject_proc_step eq '000'}">
												사업공고
											</c:if>
											<c:if test="${data.ts_subject_proc_step eq '110'}">
												사업신청
											</c:if>
											<c:if test="${data.ts_subject_proc_step eq '120'}">
												협약체결
											</c:if>
											<c:if test="${data.ts_subject_proc_step eq '130'}">
												권한부여
											</c:if>
											<c:if test="${data.ts_subject_proc_step eq '141'}">
												선금신청
											</c:if>
											<c:if test="${data.ts_subject_proc_step eq '142'}">
												잔금신청
											</c:if>
											<c:if test="${data.ts_subject_proc_step eq '143'}">
												잔금반납
											</c:if>
											<c:if test="${data.ts_subject_proc_step eq '151'}">
												진도점검
											</c:if>
											<c:if test="${data.ts_subject_proc_step eq '152'}">
												현장실태조사
											</c:if>
											<c:if test="${data.ts_subject_proc_step eq '160'}">
												설문조사
											</c:if>
											<c:if test="${data.ts_subject_proc_step eq '170'}">
												최종평가
											</c:if>
											<c:if test="${data.ts_subject_proc_step eq '180'}">
												추적조사
											</c:if>
										<td>
											<c:if test="${data.tst_subject_proc_status eq  '00'}">
												준비
											</c:if>
											<c:if test="${data.tst_subject_proc_status eq  '10'}">
												작성
											</c:if>
											<c:if test="${data.tst_subject_proc_status eq  '20'}">
												등록
											</c:if>
											<c:if test="${data.tst_subject_proc_status eq  '30'}">
												검토
											</c:if>
											<c:if test="${data.tst_subject_proc_status eq  '50'}">
												확인
											</c:if>
											<c:if test="${data.tst_subject_proc_status eq  '90'}">
												거부
											</c:if>
										</td>
										<td>
											<a href="javascript:void(0);" onclick="doDetail('${data.subject_seqno}','${data.project_seqno}');" title="추적조사 상세조회">[상세조회]</a>
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