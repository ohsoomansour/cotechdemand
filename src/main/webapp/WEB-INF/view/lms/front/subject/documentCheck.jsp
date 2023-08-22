<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<link rel="stylesheet" href="http://code.jquery.com/ui/1.8.18/themes/base/jquery-ui.css?v=1" type="text/css" />  
<!-- <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js?v=1"></script>  
<script src="http://code.jquery.com/ui/1.8.18/jquery-ui.min.js?v=1"></script>
 -->
<!-- 업로더 -->
<script src="${pageContext.request.contextPath}/plugins/file-uploader/jquery.dm-uploader.min.js?v=1"></script>
<script src="${pageContext.request.contextPath}/plugins/file-uploader/file-uploader.js?v=1"></script>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/plugins/file-uploader/style.css?v=1">

<script>
window.onload = function(){
	setTimeout(function(){
		$('#documentUpdateBtn').focus();
	}, 500);
}
function doData(stat) {
	var url = "/subject/applyDocumentSubmit.do";
	var form = $('#frm')[0];
	var data = new FormData(form);
	var project_seqno = $('#project_seqno').val();
	if(stat == "submit"){
		data.append("subject_proc_status","30");
		}
	$.ajax({
	       url : url,
	       type: "post",
	       processData: false,
	       contentType: false,
	       data: data,
	       dataType: "json",
	       success : function(res){
	    	   alert('제출되었습니다.');
	    	   location.href= "/subject/applyList.do";
	       },
	       error : function(){
	    	  alert('게시판 등록에 실패했습니다.');    
	       },
	       complete : function(){
	       }
	}); 
}

function niceClick(){
	window.open("https://www.one-click.co.kr/cm/CM0100M001GE.nice?cporcd=280&pdt_seq=1");
}

function documentUpdate(){
	location.reload();
}

function documentPdf(){
	var url = "/apiCheckList.do"
	var form = $('#frm')[0];
	var data = new FormData(form);
	$.ajax({
	       url : url,
	       type: "post",
	       processData: false,
	       contentType: false,
	       data: data,
	       dataType: "json",
	       success : function(res){
				location.reload();
				
	       },
	       error : function(){
	    	 alert("실패");
	       },
	       complete : function(){
		       
	       }
	});
}
</script>
<form id="frm" name="frm" action="/subject/documentCheck.do" method="post">
	<input type="hidden" name="project_seqno" id="project_seqno" value="${apply.project_seqno }" />
	<input type="hidden" name="subject_seqno" id="subject_seqno" value="${apply.subject_seqno }" />
	<div id="compaVcContent" class="cont_cv">
		<div id="mArticle" class="assig_app">
			<h2 class="screen_out">본문영역</h2>
			<div class="wrap_cont">
				<div class="area_tit">
					<h3 class="tit_corp">사업신청 (서류제출) </h3>
				</div>
				<!-- //page_title e:  -->
				<!-- page_content s:  -->
				<div class="area_cont">
					<h4 class="subject_corp">문서제출여부</h4>
					<div class="wrap_btn _left" style="padding-top: 5px">
						<button onclick="documentUpdate();" class="btn_step btn_all_down" id="documentUpdateBtn">문서 업데이트</button>
					</div>
					<div class="tbl_comm tbl_public" style="margin-top: 10px">
						<table class="tbl">
							<caption class="caption_hide">사업신청 필수 문서 제출 여부</caption>
							<colgroup>
								<col>
								<col>
							</colgroup>
							<thead>
								<tr>
									<th>문서명</th>
									<th>상태</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td>휴폐업조회</td>
									<c:if test="${ser1 eq 0}">
										<td>정상</td>
									</c:if>
									<c:if test="${ser1 ne 0}">
										<td>불합격</td>
									</c:if>
								</tr>
								<tr>
									<td>신용도판단정보(채무불이행)</td>
									<c:if test="${ser2 eq 0}">
										<td>정상</td>
									</c:if>
									<c:if test="${ser2 ne 0}">
										<td>불합격</td>
									</c:if>
								</tr>
								<c:if test="${!empty taxList}">
									<c:forEach var="taxlist" items="${taxList}" varStatus="status">
										<tr>
											<td>${taxlist.txvscfwnm}</td>
											<c:if test='${taxlist.txvsacqsdatstsnm eq "검증완료"}'>
												<td>합격</td>
											</c:if>
											<c:if test='${taxlist.txvsacqsdatstsnm ne "검증완료"}'>
												<td>불합격</td>
											</c:if>
											
										</tr>
									</c:forEach>
								</c:if>
								<c:if test="${empty taxList}">
									<tr>
										<td>사업자등록증명</td>
										<td>미인증</td>
									</tr>
									<tr>
										<td>표준재무제표증명</td>
										<td>미인증</td>
									</tr>
									<tr>
										<td>납세증명</td>
										<td>미인증</td>
									</tr>
									<tr>
										<td>지방세 납세증명</td>
										<td>미인증</td>
									</tr>
								</c:if>
							</tbody>
						</table>
					</div>
				</div>
				<div class="wrap_btn _center">
				${subject }
					<a href="/subject/applyList.do" class="btn_list" title="목록으로 이동">목록으로 이동</a>
					<c:if test="${apply.subject_proc_status eq '10' }">
						<a href="javascript:void(0);" onclick="niceClick();" class="btn_appl" title="새창열림 나이스문서 제출하기" target="_blank">나이스문서 제출하기</a>
						<a href="javascript:void(0);" onclick="doData('submit');" class="btn_appl" title="사업신청서 제출">사업신청서 제출 </a>
					</c:if>
					<%-- <c:if test="${ser1 eq '0' and ser2 eq '0' and taxList[0].txvsacqsdatstsnm eq '검증완료' and taxList[1].txvsacqsdatstsnm eq '검증완료' and taxList[2].txvsacqsdatstsnm eq '검증완료' and taxList[3].txvsacqsdatstsnm eq '검증완료'}">
						<c:if test="${subject.subject_proc_status eq'10'}">
						<a href="javascript:void(0);" onclick="niceClick();" class="btn_appl">나이스문서 제출하기</a>
						<a href="javascript:void(0);" onclick="doData('submit');" class="btn_appl">사업신청서 제출 </a>
						</c:if>
					</c:if> --%>
					
				</div>
			</div>
		</div>
	</div>
</form>

