<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<script src="${pageContext.request.contextPath}/plugins/file-uploader/jquery.dm-uploader.min.js?v=1"></script>
<script src="${pageContext.request.contextPath}/plugins/file-uploader/file-uploader.js?v=1"></script>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/plugins/file-uploader/style.css?v=1">
<script>
var before_btn = '.btn_list';
window.onload = function(){
	var list = new Array();
	<c:forEach items="${code}" var="list">
		var item ={};
		item.text = "${list.doc_name}";
		item.value = "${list.value}";
		item.isRequired = "false";
		list.push(item);
	</c:forEach>
	//해당부분 추후 db초기화시 삭제 예정
	var etc = {};
	etc.text = '기타'; etc.value='ETC',etc.isRequired="false";
	list.push(etc);
	//여기까지삭제
	console.log(list);
	 var options = {
    	fmstSeq: ${paraMap.permitdata.fmst_seqno},
    	//fmstSeq: 11,
        types: list,
        callback: function(data){
        	if(data == 0 || data == undefined){
        		alert("파일등록에 실패하였습니다. 동일 상황이 반복되면 관리자에게 문의해주세요.");
		    	return false;
		    	}
	    	doPermitSubmit(data);
		},
    };
    window.uploadSrc.create($('#uploadArea'), options);	  
    var subject_status = "${paraMap.permitdata.subject_proc_status }";
    if(subject_status == '50'){
    	$('#add-button-row').remove();
        }	      
    

}

//유효성체크
function validataCheck(stat,btn){
	console.log("validateCheck")
	//null체크 후 
	
	var check = confirm("[바우처 사용권한]을 부여하시겠습니까? ")
		if (check == true) {
			doPermitSubmit(stat,btn)
			//doPermitSubmit();
		}
	
}
function uploadFile(stat,btn){
	before_btn = btn;
	status = stat;
	var empty = document.getElementsByClassName('file-empty')[0];
	//console.log(empty);
	if(empty==undefined){
		//파일전송후 공고등록
		uploadSrc.startUpload();
	}
	else{
		//공고등록
		doPermitSubmit();
	}
}
//권하부여하기
function doPermitSubmit(fmst_seqno){
	var url = "/subject/permitSubmit.do"
	var form = $('#frm')[0];
	var data = new FormData(form);
	if(fmst_seqno != undefined){
		data.append("fmst_seqno",fmst_seqno);
	}
	data.append("subject_proc_status",status);
	$.ajax({
		url : url,
       type: "post",
       processData: false,
       contentType: false,
       data: data,
       dataType: "json",
       success : function(res){
    	   if(res.result == 0){
		    	  alert('이미 신청 되었습니다');
			      }
		      else{
		    	  alert("부여 되었습니다.");
			      goList();
			      }
	       	console.log("결과",res);
       },
       error : function(){
    	alert('실패했습니다.');    
       },
       complete : function(){
       }
	}); 
}
function goList(){
	window.location.href="/subject/permitList.do"
}
</script>
<form id="frm" name="frm" action ="/subject/permitSubmit.do" method="post" >
<div id="compaVcContent" class="cont_cv">
	<div id="mArticle" class="assig_app">
		<h2 class="screen_out">본문영역</h2>
		<div class="wrap_cont">
			<!-- page_title s:  -->
			<div class="area_tit">
				<h3 class="tit_corp">사업수행 - 사용권한부여 상세보기</h3>
			</div>
			<!-- //page_title e:  -->
			<!-- page_content s:  -->
			<div class="area_cont">
				<h4 class="subject_corp">과제정보</h4>
				
				<input type="hidden" id="project_seqno" name="project_seqno" value="${paraMap.project_seqno }"/>
				<input type="hidden" id="subject_seqno" name="subject_seqno"  value="${paraMap.subject_seqno }"/>
				<div class="box_info2">
					<dl>
						<dt>협약번호</dt>
						<dd>${paraMap.subject_ref } </dd>
					</dl>
					<dl>
						<dt>사업명</dt>
						<dd>${paraMap.project_title }</dd>
					</dl>
					<dl>
						<dt>과제명</dt>
						<dd>${paraMap.subject_title }</dd>
					</dl>
					<dl class="col4">
						<dt>수요기업</dt>
						<dd>${paraMap.dcdata.biz_name }</dd>
						<dt>공급기업</dt>
						<dd>${paraMap.scdata.biz_name }</dd>
					</dl>
					<dl class="col4">
						<dt>협약기간</dt>
						<dd>${paraMap.subject_sdate } ~ ${paraMap.subject_edate }</dd>
						<dt>진행상태</dt>
						<dd>
						 <c:if test="${paraMap.subject_proc_step eq '110'}">
							<span class="lb lb_apply">사업신청 단계</span>
						</c:if>
						<c:if test="${paraMap.subject_proc_step eq '120'}">
							<span class="lb lb_apply">협약체결 단계</span>
						</c:if>  
						<c:if test="${paraMap.subject_proc_step eq '130'}">
							<span class="lb lb_apply">권한부여 단계</span>
						</c:if>  
						<c:if test="${paraMap.subject_proc_step eq '141'}">
							<span class="lb lb_apply">선금신청 단계</span>
						</c:if>
						<c:if test="${paraMap.subject_proc_step eq '142'}">
							<span class="lb lb_apply">잔금신청 단계</span>
						</c:if> 
						<c:if test="${paraMap.subject_proc_step eq '143'}">
							<span class="lb lb_apply">잔금반납 단계</span>
						</c:if> 
						<c:if test="${paraMap.subject_proc_step eq '151'}">
							<span class="lb lb_apply">진도점검 단계</span>
						</c:if> 
						<c:if test="${paraMap.subject_proc_step eq '152'}">
							<span class="lb lb_apply">현장실태조사 단계</span>
						</c:if> 
						<c:if test="${paraMap.subject_proc_step eq '160'}">
							<span class="lb lb_apply">설문조사 단계</span>
						</c:if> 
						<c:if test="${paraMap.subject_proc_step eq '170'}">
							<span class="lb lb_apply">최종평가 단계</span>
						</c:if> 
						<c:if test="${paraMap.subject_proc_step eq '180'}">
							<span class="lb lb_apply">추적조사 단계</span>
						</c:if> 
						</dd>
					</dl>
				</div>
				

			</div>
			<!-- <div class="area_cont area_cont2">
                 <div class="subject_corp">
                     <h4>협약내용</h4>
                 </div>
                 	[상세보기]
             </div> -->
             <div class="area_cont area_cont2">
                 <div class="subject_corp">
                     <h4>협약금액</h4>
                 </div>
                 <div class="tbl_comm tbl_public">
						<table class="tbl">
							<caption class="caption_hide">사업수행 협약금액</caption>
							<colgroup>
								<col>
								<col>
								<col>
								<col>
								<col>
								<col>
							</colgroup>
							<thead>
								<tr>
									<th>구분</th>
									<th>정부지원금</th>
									<th>수요기업 자부담금</th>
									<th>소계</th>
									<th>부가가치세</th>
									<th>합계</th>
								</tr>
							</thead>
							<tbody>
								
									<tr>
										<td>사업비</td>
										<td>${paraMap.gov_cost }</td>
										<td>${paraMap.com_cost }</td>
										<td>${paraMap.gov_cost + paraMap.com_cost }</td>
										<td>${paraMap.vat_cost }</td>
										<td>${paraMap.voucher_total }</td>
									</tr>
							</tbody>
						</table>
					</div>
             </div>
			<div class="area_cont area_cont2">
                 <div class="subject_corp">
                     <h4>제출서류</h4>
                 </div>
                 <div  id="uploadArea"></div>
             </div>
			
			<div class="wrap_btn _center">
				<a href="/subject/permitList.do"  class="btn_list" title="목록으로 이동">목록으로 이동</a>
				<c:if test="${paraMap.permitdata.subject_proc_status eq '50' }" >
					
				</c:if>
				<c:if test="${paraMap.permitdata.subject_proc_status ne '50' }" >
					<a href="javascript:void(0);" onclick="validataCheck('50','#btn_submit')" class="btn_appl" id="btn_submit" title="목록으로 이동">[바우처 사용 통보]</a>	
				</c:if>
			</div>
			<!-- //page_content e:  -->
		</div>
	</div>
</div>
</form>
