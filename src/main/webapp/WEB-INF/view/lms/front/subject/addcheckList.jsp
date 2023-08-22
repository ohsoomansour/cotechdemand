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
	$.datepicker.setDefaults($.datepicker.regional['ko']);
    
    $("#check_sdate").datepicker({
        dateFormat: 'yy-mm',
        monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
        monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
        changeMonth: true,
        changeYear: true,
        showButtonPanel: true,
        closeText : "선택",
        onClose: function(dateText, inst) {
            var month = $("#ui-datepicker-div .ui-datepicker-month :selected").val();
            var year = $("#ui-datepicker-div .ui-datepicker-year :selected").val();
            $(this).val($.datepicker.formatDate('yymm', new Date(year, month, 1)));
        },
        beforeShow: function(input, inst) {
        	$('#ui-datepicker-div').addClass("only_ym");
        }
    
    }); 
    $("#check_edate").datepicker({
        dateFormat: 'yy-mm',
        monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
        monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
        changeMonth: true,
        changeYear: true,
        showButtonPanel: true,
        closeText : "선택",
        onClose: function(dateText, inst) {
            var month = $("#ui-datepicker-div .ui-datepicker-month :selected").val();
            var year = $("#ui-datepicker-div .ui-datepicker-year :selected").val();
            $(this).val($.datepicker.formatDate('yymm', new Date(year, month, 1)));
        },
        beforeShow: function(input, inst) {
        	$('#ui-datepicker-div').addClass("only_ym");
        }
    
    }); 
    
	//$('#subject_proc_status').val(${subject_proc_status}).prop("selected",true);
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
	function doDetail(subject_seqno,project_seqno,tsac_check_date){
		$('#subject_seqno').val(subject_seqno);
		$('#project_seqno').val(project_seqno);
		$('#tsac_check_date').val(tsac_check_date);
		$('#frm2').submit();
	}
</script>
<form action="/subject/addcheckDetail.do" id="frm2" name="frm2" method="post">
	<input type="hidden" name="subject_seqno" id="subject_seqno" value="" />
	<input type="hidden" name="project_seqno" id="project_seqno" value="" />
	<input type="hidden" name="tsac_check_date" id="tsac_check_date" value="" />
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
					<h3 class="tit_corp">현장실태조사</h3>
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
								<input type="text" style="width:890px;margin-left:14px" id="subject_title" name="subject_title" placeholder="검색할 과제명을 입력하세요" value="${paraMap.subject_title }" title="과제명"/>
							</div>
							<br/>
							<div class="search_cu_box b_name_box">
								<span>협약번호</span> 
								<input type="text" style="width:400px; margin-right:22px;" id="subject_ref" name="subject_ref" placeholder="검색할 협약번호를 입력하세요" value="${paraMap.subject_ref }" title="협약번호"/>
							</div>
							<div class="search_cu_box">
								<span>진행상태</span> <select class="select_normal select_status" style="width:402px;"
									name="subject_proc_status" id="subject_proc_status" <%-- value="${paraMap.subject_proc_status }" --%> title="진행상태">
									<option title="전체" value="">전체</option>
									<option title="전체(현장실태조사완료 제외)" value="">전체 (현장실태조사완료 제외)</option>
									<option value="10" title="현장실태조사대상" >현장실태조사대상</option>
									<option value="20" title="점검자료제출" >점검자료제출</option>
<!-- 									<option value="30">점검자료제출</option> -->
									<option value="50" title="현장실태조사완료">현장실태조사완료</option>
									<option value="80" title="보완대상">보완대상</option>
<!-- 									<option value="90">점검거부</option> -->
								</select>
							</div>
							<div class="btn_wrap">
								<button type="button" class="btn_step"  onClick="javascript:doSearch();">
									<span>검색</span>
								</button>
							</div>
								
								
							
<%-- 							<div class="search_cu_box b_name_box">
								<span>점검 대상월</span> 
								<input type="text" name="check_sdate" id="check_sdate" placeholder="점검시작월" value="${paraMap.check_sdate }" />
								<input type="text" name="check_edate" id="check_edate" placeholder="점검종료월" value="${paraMap.check_edate }"/>
							</div>
 --%>							
						</div>
					</div>
					<div class="subject_corp">
						<h3 class="tbl_ttc">
							현장실태조사 목록&nbsp;<span class="total_cnt">총 ${paraMap.count} 건</span>
						</h3>
						<div class="ttc_select">
							<select class="select_normal " name="rows" id="rows" title="표시목록수">
								<option title="10건" value="10">10건</option>
								<option title="30건" value="30">30건</option>
								<option title="50건" value="50">50건</option>
								<option title="100건" value="100">100건</option>
							</select>
						</div>
					</div>
					<div class="tbl_comm tbl_public">
						<table class="tbl">
							<caption class="caption_hide">현장실태조사 리스트</caption>
							<colgroup>
								<col style="width: 50px;" />
								<col style="width: 100px;" />
								<col style="width: 180px;" />
								<col style="width: 200px;" />
								<col style="width: 200px;" />
								<col style="width: 150px;" />
								<col style="width: 150px;" />
								<col style="width: 80px;" />
								<col style="width: 90px;" />
							</colgroup>
							<thead>
								<tr>
									<th>순번</th>
									<th>점검월</th>
									<th>협약번호</th>
									<th>과제명</th>
									<th>협약기간</th>
									<th>현장실태조사일시</th>
									<th>수요기업<br/>공급기업</th>
									<th>진행상태</th>
									<th>상세보기</th>
								</tr>
							</thead>
							<tbody>
								<c:forEach var="data" items="${result }" varStatus="status">
									<tr>
										<td>${status.count}</td>
										<td>${fn:substring(data.tsac_check_date,0,4)}-${fn:substring(data.tsac_check_date,4,6)}</td>
										<td>${data.subject_ref}</td>
										<td>${data.subject_title }</td>
										<td>${data.subject_sdate} ~ ${data.subject_edate}</td>
										<td>
											<c:if test="${data.tsac_addcheck_date eq '' }" >
												미실시
											</c:if>
											<c:if test="${data.tsac_addcheck_date ne '' }" >
												${data.tsac_addcheck_date }
											</c:if>
										
										</td>
										<td>${data.tmdc_biz_name}<br/>${data.tmsc_biz_name}</td>
										<td>
											<%-- <c:if test="${data.tsac_subject_proc_status  eq '00' }">
												준비
											</c:if> --%>
											<c:if test="${data.tsac_subject_proc_status  eq '10' }">
												현장실태조사대상
											</c:if>
											<c:if test="${data.tsac_subject_proc_status  eq '20' }">
												점검자료제출
											</c:if>
<%-- 											<c:if test="${data.tsac_subject_proc_status  eq '30' }">
												점검
											</c:if> --%>
											<c:if test="${data.tsac_subject_proc_status  eq '50' }">
												현장실태조사완료
											</c:if>
											<c:if test="${data.tsac_subject_proc_status  eq '80' }">
												보완대상
											</c:if>
<%-- 											<c:if test="${data.tsac_subject_proc_status  eq '90' }">
												점검거부
											</c:if>
 --%>										</td>
										<td>
											<a href="javascript:void(0);" onclick="doDetail('${data.subject_seqno}','${data.project_seqno}' ,'${data.tsac_check_date}');" title="현장실태조사 상세조회" >[상세조회]</a>
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