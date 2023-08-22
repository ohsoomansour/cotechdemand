<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<link rel="stylesheet" href="http://code.jquery.com/ui/1.8.18/themes/base/jquery-ui.css?v=1" type="text/css" />  
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js?v=1"></script>  
<script src="http://code.jquery.com/ui/1.8.18/jquery-ui.min.js?v=1"></script>
<script>
$(document).ready(function(){	
	$('#aplSdtm').val('${ aplSdtm }') //설문 시작 시간
	
	//설문지제출
	$('#submit').click(function(){
  		$.ajax({
            url : "/front/listTakeSurvey.do",
            type: "post",
            data: $('#frm').serialize(),
            dataType: "json",
            success : function(){
            	alert_popup('설문지 제출이 완료되었습니다. 감사합니다.');          	
            },
            error : function(){
            	alert_popup('설문지 제출에 실패하였습니다.');    
            },
            complete : function(){
				window.location.href = "/subject/surveyList.do";
            }
		});  
	});	
});

//체크박스 중복 체크 제거
function rmOverlap (chk, index) {
	var chkQue = $('.queType_' + index + '');
	for (var i = 0; i < chkQue.length; i++) {
		if (chkQue[i] != chk) {
			chkQue[i].checked = false;
		}
	}
}
</script>
<form action="#" id="frm" name="frm" method="post">
<input type="hidden" id="pprSeq" name="ppr_seq" value="${ paraMap.ppr_seq }" />
<input type="hidden" id="aplSdtm" name="apl_sdtm" value="${ paraMap.apl_sdtm }" />
<input type="hidden" id="aplEdtm" name="apl_edtm" value="${ paraMap.apl_edtm }" />
<!-- compaVcContent s:  -->
<div id="compaVcContent" class="cont_cv">
	<div id="mArticle" class="assig_app">
		<h2 class="screen_out">본문영역</h2>
		<div class="wrap_cont">
                     <!-- page_title s:  -->
			<div class="area_tit">
				<h3 class="tit_corp">서비스 만족도 조사</h3>
			</div>
			<!-- //page_title e:  -->
			<!-- page_content s:  -->
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
                                 <ul class="multi_c">
                                 	<c:forEach var="queitem" items="${ queitem }"  varStatus="status1">
									    <c:if test="${ que.que_pcd eq '객관식'}">
									    	<c:if test="${ que.que_seq eq queitem.que_seq }">
												<label for="answer_${ que.que_seq }_${ status1.index }" class="chk"><input type="radio" id="answer_${ que.que_seq }_${ status1.index }" class="queType_${ status.index }" name="apl_ans_${ status.index }" value="${ queitem.item_title }" onclick="rmOverlap(this,${status.index })">${ queitem.item_title }</label>
											</c:if>
										</c:if>
									</c:forEach>
									<!-- 객관식 다중 -->
									<c:if test="${ que.que_pcd eq '다선택'}">
										<c:forEach var="queitem" items="${ queitem }"  varStatus="status2">				
											<c:if test="${ que.que_seq eq queitem.que_seq }">
												<label for="answer_${ que.que_seq}_${ status2.index }" class="chk"><input type="checkbox" id="answer_${ que.que_seq }_${ status2.index }" class="queType_${ status.index }" name="apl_ans_${ status.index }" value="${ queitem.item_title }">${ queitem.item_title }</label>
											</c:if>
										</c:forEach>
									</c:if>	
									<!-- OX형 -->
									<c:if test="${ que.que_pcd eq 'OX형'}">
										<li><div class="box_radioinp"><label for="answerYO" class="chk"><input type="radio" id="answerYO" class="queType_${ status.index }" name="apl_ans_${ status.index }" value="O" onclick="rmOverlap(this,${status.index })">O</label></div></li>
										<li><div class="box_radioinp"><label for="answerYX" class="chk"><input type="radio" id="answerYX" class="queType_${ status.index }" name="apl_ans_${ status.index }" value="X" onclick="rmOverlap(this,${status.index })">X</label></div></li>
									</c:if>
									<!-- 설문형 척도 -->
									<c:if test="${ que.que_pcd eq '설문형'}">
										<li><div class="box_checkinp"><label for="ansSurvey1"><input type="checkbox" id="ansSurvey1" class="queType_${ status.index }" name="apl_ans_${ status.index }" value="매우 그렇다" onclick="rmOverlap(this,${status.index })" >매우그렇다</label></div></li>
										<li><div class="box_checkinp"><label for="ansSurvey2"><input type="checkbox" id="ansSurvey2" class="queType_${ status.index }" name="apl_ans_${ status.index }" value="그렇다" onclick="rmOverlap(this,${status.index })">그렇다</label></div></li>
										<li><div class="box_checkinp"><label for="ansSurvey3"><input type="checkbox" id="ansSurvey3" class="queType_${ status.index }" name="apl_ans_${ status.index }" value="보통" onclick="rmOverlap(this,${status.index })" >보통</label></div></li>
										<li><div class="box_checkinp"><label for="ansSurvey4"><input type="checkbox" id="ansSurvey4" class="queType_${ status.index }" name="apl_ans_${ status.index }" value="그렇지 않다" onclick="rmOverlap(this,${status.index })" >그렇지 않다</label></div></li>
										<li><div class="box_checkinp"><label for="ansSurvey5"><input type="checkbox" id="ansSurvey5" class="queType_${ status.index }" name="apl_ans_${ status.index }" value="매우 그렇지 않다" onclick="rmOverlap(this,${status.index })" >매우 그렇지 않다</label></div></li>
									</c:if>
									<!-- 주관식 -->
									<c:if test="${ que.que_pcd eq '주관식'}">
										<input type="text" id="answerS" class="form-control" name="apl_ans_${ status.index }">
									</c:if>
									<!-- 객관식 (점수) -->
									<c:forEach var="queitem" items="${ queitem }"  varStatus="status3">
									    <c:if test="${ que.que_pcd eq '객관식(점수)'}">
									    	<c:if test="${ que.que_seq eq queitem.que_seq }">
												<label for="answer_${ que.que_seq }_${ status3.index }" class="chk"><input type="radio" id="answer_${ que.que_seq }_${ status3.index }" class="queType_${ status.index }" name="apl_ans_${ status.index }" value="${ queitem.item_title }" onclick="rmOverlap(this,${status.index })">${ queitem.item_title } : ${ queitem.item_value }점</label>
											</c:if>
										</c:if>
									</c:forEach>
                                    </ul>
                             </div>
                             
                         </div>
                         </c:forEach>
                         <div class="wrap_btn _center">
                             <!-- <a href="javascript:void(0);" class="btn_list">초기화</a> -->
 							<button type="button" id="submit" class="btn_appl">제출하기</button>                            
                             <!-- <button type="button" id="submit" class="btn btn-primary btn-lg">제출하기</button> -->
                         </div>
			</div>
			<!-- //page_content e:  -->
		</div>
	</div>
</div>

</form>				     		   
