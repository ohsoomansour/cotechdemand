<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<script src="${pageContext.request.contextPath}/plugins/file-uploader/jquery.dm-uploader.min.js?v=1"></script>
<script src="${pageContext.request.contextPath}/plugins/file-uploader/file-uploader.js?v=1"></script>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/plugins/file-uploader/style.css?v=1">
<script>
window.onload = function(){
	<c:if test="${!empty paraMap.queresult }">
	var list = new Array();
	<c:forEach items="${ paraMap.queresult}" var="list">
		var item = {};
		item.ppr_seq = "${list.ppr_seq}";
		item.que_seq = "${list.que_seq}";
		item.apl_ans = "${list.apl_ans}";
		list.push(item);
	</c:forEach>
	for(var i=0; i<list.length;i++){
		$("input[type=radio]").each(function(rd){
			var value = $(this).val();
			if(value == list[i].apl_ans){
				console.log("정답",value,list[i].apl_ans);
				$(this).prop("checked",true);
			}else{//틀렷을떄
				console.log("실패",value,list[i].apl_ans);
			}
			});
		}
	</c:if>
	
}
$(document).ready(function(){
	$('#aplSdtm').val('${ aplSdtm }') //설문 시작 시간
});
//유효성체크
function validataCheck(stat){
   console.log("validateCheck")
   //null체크 후 
   
   var check = confirm("설문조사를 완료하시겠습니까? ")
      if (check == true) {
         doSurveySubmit();
      }
}
//서명하기
function doSurveySubmit(){
   var url = "/subject/surveySubmit.do"
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
               if(res.result == 0){
            	   alert("실패되었습니다.");
                  }
               else{
            	   alert('제출 되었습니다');
                  }
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

</script>
<form id="frm" name="frm" action ="/subject/surveySubmit.do" method="post" >
<input type="hidden" id="aplSdtm" name="apl_sdtm" value="${ paraMap.apl_sdtm }" />
<input type="hidden" id="aplEdtm" name="apl_edtm" value="${ paraMap.apl_edtm }" />
<div id="compaVcContent" class="cont_cv">
   <div id="mArticle" class="assig_app">
      <h2 class="screen_out">본문영역</h2>
      <div class="wrap_cont">
         <!-- page_title s:  -->
         <div class="area_tit">
            <h3 class="tit_corp">서비스 만족도 조사 </h3>
         </div>
         <!-- //page_title e:  -->
         <!-- page_content s:  -->
         <div class="area_cont">
            <h4 class="subject_corp">과제정보</h4>
            
            <input type="hidden" id="project_seqno" name="project_seqno" value="${paraMap.project_seqno }"/>
            <input type="hidden" id="subject_seqno" name="subject_seqno"  value="${paraMap.subject_seqno }"/>
            <input type="hidden" id="ppr_seq" name="ppr_seq"  value="${paraMap.surveydata.ppr_seq }"/>
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
         
         <c:if test="${!empty que}">
         	<c:if test="${paraMap.surveydata.subject_proc_status eq '20' }">
         		<div class="area_cont">
                         <div class="survey_box">
                             <div class="survey_box_top">
                                 <h4>설문 안내</h4>
                                 <span>※  본 설문은 익명성이 보장되는 설문 조사입니다.</span>
                                 <span>※ 설문에 앞서 공정한 설문 투표를 권유드립니다.</span>
                             </div>
                         </div>
                                              
                         <c:forEach var="que" items="${ que }" varStatus="status">
		                     <input type="hidden" name="que_pcd" value="${ que.que_pcd }">
		                     <input type="hidden"  name="que_seq" value="${ que.que_seq }">                         
	                         <div class="survey_list">
	                             <div class="survey_q">${ status.count }. ${ que.que_title }</div>
	                             <div class="survey_a">
	                                 <!-- <ul class="multi_c"> -->
	                                    <c:forEach var="queitem" items="${ queitem }"  varStatus="status1">
			                               <c:if test="${ que.que_pcd eq '객관식'}">
			                                  <c:if test="${ que.que_seq eq queitem.que_seq }">
			                                  	<input type="radio" id="answer_${ que.que_seq }_${ status1.index }" class="queType_${ status.index }" name="apl_ans_${ status.index }" value="${ queitem.item_title }" onclick="rmOverlap(this,${status.index })" title="${que_item.item_title }"/>
			                                    <label for="answer_${ que.que_seq }_${ status1.index }" class="chk">
			                                    	${ queitem.item_title }
			                                    </label>
			                                 </c:if>
			                              </c:if>
	                           			</c:forEach>
			                           <!-- 객관식 (점수) -->
			                           <c:forEach var="queitem" items="${ queitem }"  varStatus="status3">
			                               <c:if test="${ que.que_pcd eq '객관식(점수)'}">
			                                  <c:if test="${ que.que_seq eq queitem.que_seq }">
			                                  	<input type="radio" id="answer_${ que.que_seq }_${ status3.index }" class="queType_${ status.index }" name="apl_ans_${ status.index }" value="${ queitem.item_title }" title="${ queitem.item_title }" onclick="rmOverlap(this,${status.index })" />	                                  
			                                    <label for="answer_${ que.que_seq }_${status3.index }" class="chk">
			                                    	&nbsp;${ queitem.item_title }&nbsp;&nbsp;(${ queitem.item_value }점)
			                                    </label>
			                                 </c:if>
			                              </c:if>
			                           </c:forEach>
			                           <!-- 주관식 -->
			                               <c:if test="${ que.que_pcd eq '주관식'}">
			                                  	<label for="answerS"><input type="text" id="answerS" class="form-control" name="apl_ans_${ status.index }" title="${que.que_title } 주관식답" /></label>
			                                  	<label for="answerS">
			                                  		<input type="text" id="answerS" class="form-control" name="apl_ans_${ status.index }" title="주관식 ${ status.index }번 입력">
			                                  	</label>
			                               </c:if>
	                                    <!-- </ul> -->
	                             </div>
	                         </div>
                         </c:forEach>
                         <div class="wrap_btn _center">
                         </div>
         		</div>
         		<div class="wrap_btn _center">
         			<a href="/subject/surveyList.do"  class="btn_list" id="btn_list" title="목록으로 이동">목록으로 이동</a>
					<a href="javascript:void(0);" onclick="validataCheck('submit')" class="btn_appl" id="btn_submit" title="응답결과 제출">응답결과 제출</a>
		         </div>
         	</c:if>
            <c:if test="${paraMap.surveydata.subject_proc_status eq '50' }">
           
            	<div class="area_cont">
                         <div class="survey_box">
                             <div class="survey_box_top">
                                 <h4>설문 안내</h4>
                                 <span>※  본 설문은 익명성이 보장되는 설문 조사입니다.</span>
                                 <span>※ 설문에 앞서 공정한 설문 투표를 권유드립니다.</span>
                             </div>
                         </div>
                         
                         <div class="tbl_comm tbl_public">
                         	<table class="tbl">
                         		<caption >설문 내용</caption>
                         		<colgroup>
								<col style="width: 50px;" />
								<col/>
								<col style="width: 150px;" />
							</colgroup>
							<thead>
								<tr>
									<th>순번</th>
									<th>문항</th>
									<th>응답내용</th>
								</tr>
							</thead>
							<tbody>
								<c:forEach var="queResult" items="${paraMap.queresult }" varStatus="status">
									<tr>
										<td>${ status.count }</td>
										<td>${ queResult.que_title }</td>
										<td>${ queResult.apl_ans }</td>
									</tr>
								</c:forEach>
								
							</tbody>
                         	</table>
                         </div>
					<!-- //page_content e:  -->
         		</div>
         		<div class="wrap_btn _center">
         			<a href="/subject/surveyList.do"  class="btn_appl" id="btn_list" title="목록으로 이동">목록으로 이동</a>
		         </div>
            </c:if>
         </c:if>
         
      </div>
   </div>
</div>
</form>