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
<form action="/subject/contractDetail.do" id="frm2" name="frm2" method="post">
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
					<h3 class="tit_corp">협약체결</h3>
				</div>
				<!-- //page_title e:  -->
				<!-- page_content s:  -->
				<div class="area_cont">
					<div class="search_box">
						<div class="search_box_inner">
							<div class="search_cu_box b_name_box">
								<span>사업명</span> 
								<input type="text" style="width:890px;margin-left:14px" id="project_title" name="project_title" placeholder="검색할 사업명을 입력하세요" value="${paraMap.project_title }"  title="사업명"/>
							</div>
							<div class="search_cu_box b_name_box">
								<span>과제명</span> 
								<input type="text" style="width:890px;margin-left:14px" id="subject_title" name="subject_title" placeholder="검색할 과제명을 입력하세요" value="${paraMap.subject_title }" title="과제명"/>
							</div>
							<br/>
							<div class="search_cu_box b_name_box">
								<span>협약번호</span> 
								<input type="text" style="width:400px; margin-right:22px;" id="subject_ref" name="subject_ref" placeholder="검색할 협약번호를 입력하세요" value="${paraMap.subject_ref }" title="협약번호"/>
							</div>
							<div class="search_cu_box">
								<span>진행상태</span> <select class="select_normal select_status" style="width:393px;"
									name="subject_proc_status" id="subject_proc_status" title="진행상태">
									<option title="전체" value="">전체</option>
									<option title="준비" value="00">준비</option>
									<option title="협약진행" value="20">협약진행</option>
									<option title="협약완료" value="50">협약완료</option>
									<option title="취소" value="99">취소</option>
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
							협약체결 목록 <span class="total_cnt">총 ${paraMap.count} 건</span>
						</h3>
						<div class="ttc_select">
							<select class="select_normal " name="rows" id="rows"  title="표시목록수">
								<option title="10건" value="10">10건</option>
								<option title="30건" value="30">30건</option>
								<option title="50건" value="50">50건</option>
								<option title="100건" value="100">100건</option>
							</select>
						</div>
					</div>
					<div class="tbl_comm tbl_public">
						<table class="tbl">
							<caption class="caption_hide">협약체결  리스트</caption>
							<colgroup>
								<col style="width: 50px;" />
								<col style="width: 150px;" />
								<%-- <col style="width: 90px;" />
								<col style="width: 120px;" /> --%>
								<col style="width: 200px;" />
								<col style="width: 180px;" />
								<col style="width: 130px;" />
								<col style="width: 100px;" />
								<col style="width: 70px;" />
								<col style="width: 90px;" />
							</colgroup>
							<thead>
								<tr>
									<th>순번</th>
									<th>협약번호</th>
									<!-- <th>지원분야</th>
									<th>상세서비스</th> -->
									<th>바우처 과제명</th>
									<th>협약기간</th>
									<th>수요기업<br/>공급기업</th>
									<th>총사업비</th>
									<th>상태</th>
									<th>상세보기</th>
								</tr>
							</thead>
							<tbody>
								<c:forEach var="data" items="${result }" varStatus="status">
									<tr>
										<td>${status.count}</td>
										<td>${data.subject_ref}</td>
										<%-- <td>${data.complete_sign_date }</td> --%>
										<%-- <td>
											<c:if test="${data.sector_lev1 eq 'BS' }">
												사업화지원
											</c:if>
											<c:if test="${data.sector_lev1 eq 'TS' }">
												기술개발지원
											</c:if>
										</td>
										<td>
											<c:if test="${data.sector_lev1 eq 'BS' }">
												<c:if test="${data.sector_lev2 eq 10 }" >
													성능평가 인증
												</c:if>
												<c:if test="${data.sector_lev2 eq 20 }" >
													인허가 컨설팅
												</c:if>
												<c:if test="${data.sector_lev2 eq 30 }" >
													IP 관리 컨설팅
												</c:if>
												<c:if test="${data.sector_lev2 eq 40 }" >
													사업화 컨설팅
												</c:if>
											</c:if>
											<c:if test="${data.sector_lev1 eq 'TS' }">
												<c:if test="${data.sector_lev2 eq 10 }" >
													시제품 제작 지원
												</c:if>
												<c:if test="${data.sector_lev2 eq 20 }" >
													기존기술 개선 R&D 지원
												</c:if>
												<c:if test="${data.sector_lev2 eq 30 }" >
													신기술 개발 R&D 지원
												</c:if>
											</c:if>
										</td> --%>
										<td>${data.subject_title }</td>
										<td>${data.subject_sdate} ~ ${data.subject_edate}</td>
										<td>${data.tmdc_biz_name}<br/>${data.tmsc_biz_name}</td>
										<td>
											${data.total_cost }
										</td>
										<td>
											<c:if test="${data.tc_subject_proc_status  eq '00' }">
												준비
											</c:if>
											<c:if test="${data.tc_subject_proc_status  eq '20' }">
												협약진행
											</c:if>
											<c:if test="${data.tc_subject_proc_status  eq '50' }">
												협약완료
											</c:if>
											<c:if test="${data.tc_subject_proc_status  eq '90' }">
												취소
											</c:if>
										</td>
										<td>
											<a href="javascript:void(0);" onclick="doDetail('${data.subject_seqno}','${data.project_seqno}' );" title="협약체결 상세조회">[상세조회]</a>
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