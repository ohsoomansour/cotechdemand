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
	 var options = {
    	fmstSeq: ${paraMap.tracedata.fmst_seqno},
        types: list,
        callback: function(data){
        	if(data == 0 || data == undefined){
        		alert("파일등록에 실패하였습니다. 동일 상황이 반복되면 관리자에게 문의해주세요.");
		    	return false;
		    	}
        	dotraceSubmit(data);
		},
    };
    window.uploadSrc.create($('#uploadArea'), options);	    	
    var subject_status = "${paraMap.tracedata.subject_proc_status }";
    if(subject_status == '50'){
    	$('#add-button-row').remove();
        }		
        
}

//유효성체크
function validataCheck(stat,btn){
	console.log("validateCheck")
	//null체크 후 
	
	var check = confirm("작성하신 사업계획서를 저장하시겠습니까? ")
		if (check == true) {
			uploadFile(stat)
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
		//alert("")
		//공고등록
		dotraceSubmit();
	}
}
//서명하기
function dotraceSubmit(fmst_seqno){
	var url = "/subject/traceSubmit.do"
		var form = $('#frm')[0];
		var data = new FormData(form);
		if(fmst_seqno != undefined){
			data.append("fmst_seqno",fmst_seqno);
			}
		$.ajax({
		       url : url,
		       type: "post",
		       processData: false,
		       contentType: false,
		       data: data,
		       dataType: "json",
		       success : function(res){
			      if(res.result == 1){
			    	  alert('신청 되었습니다');
			    	  goList();
				      }
			      else{
			    	  alert("실패되었습니다.");
				      }
		       	console.log("결과",res);   
		       },
		       error : function(){
		    	   alert('게시판 등록에 실패했습니다.');    
		       },
		       complete : function(){
			       
		       	//parent.fncList();
		       	//parent.$("#dialog").dialog("close");
		       }
		});
}
function goList(){
	 window.location.href="/subject/traceList.do"
	}
</script>
<form name="frm" id="frm" action="/subject/checkSubmit.do" method="post">
	<input type="hidden" name="project_seqno" id="project_seqno" value="${paraMap.project_seqno}" />
	<input type="hidden" name="subject_seqno" id="subject_seqno" value="${paraMap.subject_seqno}" />
	<input type="hidden" name="vat_cost" id="vat_cost" value="${paraMap.vat_cost}" />
	<div id="compaVcContent" class="cont_cv">
		<div id="mArticle" class="assig_app">
			<h2 class="screen_out">본문영역</h2>
			<div class="wrap_cont">
				<!-- page_title s:  -->
				<div class="area_tit">
					<h3 class="tit_corp">사업수행 - 추적조사 상세조회</h3>
				</div>
				<!-- //page_title e:  -->
				<!-- page_content s:  -->
				<div class="area_cont">
					<h4 class="subject_corp">과제정보</h4>
					<div class="box_info2">
						<dl>
							<dt>협약번호</dt>
							<dd>${paraMap.subject_ref }</dd>
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
							<dd>${paraMap.dcdata.biz_name}</dd>
							<dt>공급기업</dt>
							<dd>${paraMap.scdata.biz_name}</dd>
						</dl>
						<dl class="col4">
							<dt>협약기간</dt>
							<dd>2021.03.01 ~ 2021.12.31</dd>
							<dt>진행상태</dt>
							<dd>
								<span class="lb lb_apply">협약체결</span>
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
				<!-- <div class="area_cont area_cont2">
	                 <div class="subject_corp">
	                     <h4>제출서류</h4>
	                 </div>
	                 <div  id="uploadArea"></div>
	             </div> -->
				<div class="wrap_btn _center">
					<a href="/subject/traceList.do" class="btn_list" title="목록으로 이동">목록으로 이동</a>
					<!-- <a href="javascript:void(0);" class="btn_appl" onclick="validataCheck('20','#btn_submit');" id="btn_submit">추적조사 확인하기</a> -->
				</div>
				<%-- <div class="area_cont area_cont2">
					<div class="subject_corp">
						<h4>과제진행상태 – 전체 진행상태를 히스토리로 관리</h4>
					</div>
					<div class="tbl_comm tbl_public">
						<table class="tbl ">
							<caption class="caption_hide">과제진행상태</caption>
							<colgroup>
								<col style="width: 100px;" />
								<col style="width: 170px;" />
								<col />
								<col style="width: 100px;" />
								<col style="width: 150px;" />
								<col style="width: 150px;" />
							</colgroup>
							<thead>
								<tr>
									<th>진행단계</th>
									<th>문서구분</th>
									<th>첨부파일명</th>
									<th>파일크기(KB)</th>
									<th>전담기관 확인여부</th>
									<th>다운로드</th>
								</tr>
							</thead>
							<tbody>
								<tr class="st_on">
									<th>협약체결</th>
									<td class="tbl_txt_point">단계완료</td>
									<td class="ta_left tbl_txt_point">[내용 검토 – 현재와면을 선택된 단계의
										내용으로재조회]</td>
									<td>-</td>
									<td>-</td>
									<td>-</td>
								</tr>
								<tr>
									<th rowspan="4">사업수행</th>
									<td>과제계획서</td>
									<td class="ta_left"><a href="#">[TTMSoft]_연구개발서비스_사업수행계획서.hwp</a></td>
									<td>1024KB</td>
									<td><a href="javascript:void(0);" class="btn_step">확인취소</a></td>
									<td><a href="javascript:void(0);" class="btn_step">다운로드<span
											class="icon ico_down"></span></a></td>
								</tr>
								<tr>
									<td>사업비사용실적보고서</td>
									<td class="ta_left"><a href="#">[TTMSoft]_연구개발서비스_사업수행계획서.hwp</a></td>
									<td>1024KB</td>
									<td><a href="javascript:void(0);" class="btn_step">확인취소</a></td>
									<td><a href="javascript:void(0);" class="btn_step">다운로드<span
											class="icon ico_down"></span></a></td>
								</tr>
								<tr>
									<td>사업비사용실적보고서</td>
									<td class="ta_left"><a href="#">[TTMSoft]_연구개발서비스_사업수행계획서.hwp</a></td>
									<td>1024KB</td>
									<td><a href="javascript:void(0);" class="btn_step">확인취소</a></td>
									<td><a href="javascript:void(0);" class="btn_step">다운로드<span
											class="icon ico_down"></span></a></td>
								</tr>
								<tr>
									<td>사업비사용실적보고서</td>
									<td class="ta_left"><a href="#">[TTMSoft]_연구개발서비스_사업수행계획서.hwp</a></td>
									<td>1024KB</td>
									<td><a href="javascript:void(0);" class="btn_step">확인취소</a></td>
									<td><a href="javascript:void(0);" class="btn_step">다운로드<span
											class="icon ico_down"></span></a></td>
								</tr>
								<tr class="st_en">
									<th>사업종료</th>
									<td colspan="5">* 해당단계에 활성화 됩니다.</td>
								</tr>
								<tr class="st_en">
									<th>추적조사</th>
									<td colspan="5">* 해당단계에 활성화 됩니다.</td>
								</tr>
							</tbody>
						</table>
					</div>
					<div class="wrap_btn">
						<a href="javascript:void(0);" class="btn_step btn_all_down">첨부파일양식
							일괄 다운로드 <span class="icon ico_down"></span>
						</a>
					</div>
				</div> --%>
				<!-- //page_content e:  -->
			</div>
		</div>
	</div>
</form>
<%-- <form id="frm" name="frm" action ="" method="post" >
<div id="compaVcContent" class="cont_cv">
	<div id="mArticle" class="assig_app">
		<h2 class="screen_out">본문영역</h2>
		<div class="wrap_cont">
			<!-- page_title s:  -->
			<div class="area_tit">
				<h3 class="tit_corp">사업수행-현장실태조사</h3>
			</div>
			<!-- //page_title e:  -->
			<!-- page_content s:  -->
			<div class="area_cont">
				<h4 class="subject_corp">과제정보</h4>
				
				<input type="hidden" id="project_seqno" name="project_seqno" value="${paraMap.project_seqno }"/>
				<input type="hidden" id="subject_seqno" name="subject_seqno"  value="${paraMap.subject_seqno }"/>
				<input type="hidden" id="check_date" name="check_date"  value="${paraMap.checkdata.check_date }"/>
				<div class="box_info2">
					<dl>
						<dt>협약번호</dt>
						<dd>${paraMap.subject_ref }</dd>
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
         <!--     
			<div class="area_cont area_cont2">
                 <div class="subject_corp">
                     <h4>제출서류</h4>
                 </div>
                 <div  id="uploadArea"></div>
             </div> -->
			
			<!-- <div class="wrap_btn _center">
				<a href="javascript:void(0);" onclick="validataCheck('submit')" class="btn_appl">[현장실태조사  자료제출]</a>
			</div> -->
			<div class="area_cont area_cont2">
				<div class="subject_corp">
					<h4>과제진행상태 – 전체 진행상태를 히스토리로 관리</h4>
				</div>
				<div class="tbl_comm tbl_public">
					<table class="tbl ">
						<caption class="caption_hide">과제진행상태</caption>
						<colgroup>
							<col style="width: 100px;" />
							<col style="width: 170px;" />
							<col />
							<col style="width: 100px;" />
							<col style="width: 150px;" />
							<col style="width: 150px;" />
						</colgroup>
						<thead>
							<tr>
								<th>진행단계</th>
								<th>문서구분</th>
								<th>첨부파일명</th>
								<th>파일크기(KB)</th>
								<th>전담기관 확인여부</th>
								<th>다운로드</th>
							</tr>
						</thead>
						<tbody>
							<tr class="st_on">
								<th>협약체결</th>
								<td class="tbl_txt_point">단계완료</td>
								<td class="ta_left tbl_txt_point">[내용 검토 – 현재와면을 선택된 단계의
									내용으로재조회]</td>
								<td>-</td>
								<td>-</td>
								<td>-</td>
							</tr>
							<tr>
								<th rowspan="4">사업수행</th>
								<td>과제계획서</td>
								<td class="ta_left"><a href="javascript:void(0);">[TTMSoft]_연구개발서비스_사업수행계획서.hwp</a></td>
								<td>1024KB</td>
								<td><a href="javascript:void(0);" class="btn_step">확인취소</a></td>
								<td><a href="javascript:void(0);" class="btn_step">다운로드<span
										class="icon ico_down"></span></a></td>
							</tr>
							<tr>
								<td>사업비사용실적보고서</td>
								<td class="ta_left"><a href="javascript:void(0);">[TTMSoft]_연구개발서비스_사업수행계획서.hwp</a></td>
								<td>1024KB</td>
								<td><a href="javascript:void(0);" class="btn_step">확인취소</a></td>
								<td><a href="javascript:void(0);" class="btn_step">다운로드<span
										class="icon ico_down"></span></a></td>
							</tr>
							<tr>
								<td>사업비사용실적보고서</td>
								<td class="ta_left"><a href="javascript:void(0);">[TTMSoft]_연구개발서비스_사업수행계획서.hwp</a></td>
								<td>1024KB</td>
								<td><a href="javascript:void(0);" class="btn_step">확인취소</a></td>
								<td><a href="javascript:void(0);" class="btn_step">다운로드<span
										class="icon ico_down"></span></a></td>
							</tr>
							<tr>
								<td>사업비사용실적보고서</td>
								<td class="ta_left"><a href="javascript:void(0);">[TTMSoft]_연구개발서비스_사업수행계획서.hwp</a></td>
								<td>1024KB</td>
								<td><a href="javascript:void(0);" class="btn_step">확인취소</a></td>
								<td><a href="javascript:void(0);" class="btn_step">다운로드<span
										class="icon ico_down"></span></a></td>
							</tr>
							<tr class="st_en">
								<th>사업종료</th>
								<td colspan="5">* 해당단계에 활성화 됩니다.</td>
							</tr>
							<tr class="st_en">
								<th>추적조사</th>
								<td colspan="5">* 해당단계에 활성화 됩니다.</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="wrap_btn">
					<a href="javascript:void(0);" class="btn_step btn_all_down">첨부파일양식
						일괄 다운로드 <span class="icon ico_down"></span>
					</a>
				</div>
			</div>
			<!-- //page_content e:  -->
		</div>
	</div>
</div>
</form>
 --%>