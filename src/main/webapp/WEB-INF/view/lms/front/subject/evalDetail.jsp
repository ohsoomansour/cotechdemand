<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<script src="${pageContext.request.contextPath}/plugins/file-uploader/jquery.dm-uploader.min.js?v=1"></script>
<script src="${pageContext.request.contextPath}/plugins/file-uploader/file-uploader.js?v=1"></script>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/plugins/file-uploader/style.css?v=1">
<script>
var before_btn = "#btn_list";
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
    	fmstSeq: ${paraMap.evaldata.fmst_seqno},
    	//fmstSeq: 11,
        types: list,
        callback: function(data){
        	if(data == 0 || data == undefined){
        		alert("파일등록에 실패하였습니다. 동일 상황이 반복되면 관리자에게 문의해주세요.");
		    	return false;
		    	}
	    	doEvalSubmit(data);
		},
    };
    window.uploadSrc.create($('#uploadArea'), options);	    
    var subject_status = "${paraMap.evaldata.subject_proc_status }";
    if(subject_status == '50'){
    	$('#add-button-row').remove();
        }	
    
}

//유효성체크
function validataCheck(stat,btn){
	console.log("validateCheck")
	//null체크 후 
	
	var check = confirm("[최종평가 자료]를 제출하시겠습니까? ")
		if (check == true) {
			uploadFile(stat,btn)
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
		doEvalSubmit();
	}
}
//서명하기
function doEvalSubmit(fmst_seqno){
	var url = "/subject/evalSubmit.do"
		var form = $('#frm')[0];
		var data = new FormData(form);
		if(fmst_seqno != undefined){
			data.append("fmst_seqno",fmst_seqno);
			}
		//var data = $('#frm').serialize();
			$.ajax({
			       url : url,
			       type: "post",
			       processData: false,
			       contentType: false,
			       data: data,
			       dataType: "json",
			       success : function(res){
				      if(res.result != 0){
				    	  alert("제출되었습니다.");
				    	  goList();
					      }
				      else{
				    	  alert('에러발생하였습니다');
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
	window.location.href="/subject/evalList.do";
}
</script>
<form id="frm" name="frm" action ="/subject/evalSubmit.do" method="post" >
<div id="compaVcContent" class="cont_cv">
	<div id="mArticle" class="assig_app">
		<h2 class="screen_out">본문영역</h2>
		<div class="wrap_cont">
			<!-- page_title s:  -->
			<div class="area_tit">
				<h3 class="tit_corp">최종평가 상세정보</h3>
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
						 <c:if test="${paraMap.evaldata.subject_proc_status eq '00'}">
							<span class="lb lb_apply">제출대상</span>
						</c:if>
						<c:if test="${paraMap.evaldata.subject_proc_status eq '10'}">
							<span class="lb lb_apply">작성</span>
						</c:if>  
						<c:if test="${paraMap.evaldata.subject_proc_status eq '20'}">
							<span class="lb lb_apply">최종평가대기</span>
						</c:if>  
						<c:if test="${paraMap.evaldata.subject_proc_status eq '30'}">
							<span class="lb lb_apply">검토</span>
						</c:if>
						<c:if test="${paraMap.evaldata.subject_proc_status eq '50'}">
							<span class="lb lb_apply">최종평가완료</span>
						</c:if> 
						<c:if test="${paraMap.evaldata.subject_proc_status eq '59'}">
							<span class="lb lb_apply">평가완료(불합격)</span>
						</c:if> 
						<c:if test="${paraMap.evaldata.subject_proc_status eq '80'}">
							<span class="lb lb_apply">보완대상</span>
						</c:if> 
						<c:if test="${paraMap.evaldata.subject_proc_status eq '90'}">
							<span class="lb lb_apply">평가거부</span>
						</c:if> 
						</dd>
					</dl>
				</div>
				

			</div>
             
			<div class="area_cont area_cont2" >
                 <div class="subject_corp">
                     <h4>제출서류</h4>
                 </div>
                 <div  id="uploadArea"></div>
             </div>
			
			<div class="wrap_btn _center">
				<a href="/subject/evalList.do"  class="btn_appl" id="btn_list" title="목록으로 이동" >목록으로 이동</a>
				<c:if test="${paraMap.evaldata.subject_proc_status eq '00' ||paraMap.evaldata.subject_proc_status eq '10' ||paraMap.evaldata.subject_proc_status eq '20'}">
					<a href="javascript:void(0);" onclick="validataCheck('20')" class="btn_appl" id="btn_submit" title="최종평가 자료제출">[최종평가] 자료제출</a>
				</c:if>
				<c:if test="${paraMap.evaldata.subject_proc_status eq '80'}" >
					<a href="javascript:void(0);" onclick="validataCheck('20')" class="btn_appl" id="btn_re_submit" title="최종평가 자료 재제출">[최종평가] 자료 재제출</a>
				</c:if>
			</div>
			<!-- //page_content e:  -->
		</div>
	</div>
</div>
</form>
