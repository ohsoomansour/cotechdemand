<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<script>
$(document).ready(function(){	

});
//설문페이지로 이동
function moveSurveyView(eval_seq, ppr_seq, survey_state, state) {
	if(state ==  '종료'){
		alert_popup('종료된 설문입니다.');
	}else{
		$('#eval_seq').val(eval_seq);
		$('#ppr_seq').val(ppr_seq);
		if(survey_state == 'N'){
			$('#frm').submit();
		}else{
			alert_popup('이미 참여한 설문입니다.');
		}
	}
}
</script>
<form action="/front/listTakeSurvey.do" id="frm" name="frm" method="get">
<input type="hidden" id="eval_seq" name="eval_seq" value=""/>
<input type="hidden" id="ppr_seq" name="ppr_seq" value=""/>
<div id="compaVcContent" class="cont_cv">
		<div id="mArticle" class="assig_app">
			<h2 class="screen_out">본문영역</h2>
			<div class="wrap_cont">
				<!-- page_title s:  -->
				<div class="area_tit">
					<h3 class="tit_corp">설문조사 현황</h3>
				</div>
				<!-- //page_title e:  -->
				<!-- page_content s:  -->
					<div class="tbl_comm tbl_public">
						<table class="tbl">
							<caption class="caption_hide">과제신청 리스트</caption>
							<colgroup>
								<col style="width: 35%;" />
								<col style="width: 25%;" />
								<col style="width: 20%;" />
								<col style="width: 15%;" />
							</colgroup>
							<thead>
								<tr>
									<th>제목</th>
									<th>설문기간</th>
									<th>완료기간</th>
									<th>진행상태</th>
								</tr>
							</thead>
							<tbody>
								<c:forEach var="data" items="${ data }">
								<tr>								
									<td >${ data.ppr_title }</td>	
									<td >${ data.eval_sday } ~ ${ data.eval_eday }</td>																				
									<c:choose>
										<c:when test="${ data.state eq '종료' }">
											<c:if test="${ empty applydate }">
												<td >
													-
												</td>
											</c:if>											
											<c:forEach var="applydate" items="${ applydate }">										
												<c:if test="${ data.ppr_seq eq applydate.ppr_seq }">
													<td >
														${ applydate.apl_edtm }
													</td>
												</c:if>
											</c:forEach>
											<td >
												<span style="width: 70px; color: red">
													<a href="javascript:void(0);" onClick="moveSurveyView('${ data.eval_seq }','${ data.ppr_seq }','${ data.survey_state }','${ data.survey_state }');return false" onkeypress="this.onclick;"><span style="color: red">설문종료</span></a>								
												</span>
											</td>
										</c:when>										
										<c:when test="${ data.survey_state eq 'Y' }">
											<c:forEach var="applydate" items="${ applydate }">
												<c:if test="${ data.ppr_seq eq applydate.ppr_seq }">
													<td >
														${ applydate.apl_edtm }
													</td>
												</c:if>
											</c:forEach>
											<td >
												<span style="width: 70px; color: red">
													<a href="javascript:void(0);" onClick="moveSurveyView('${ data.eval_seq }','${ data.ppr_seq }','${ data.survey_state }','${ data.survey_state }');return false" onkeypress="this.onclick;"><span style="color: red">설문완료</span></a>								
												</span>
											</td>
										</c:when>									
										<c:otherwise>
											<td >
												-
											</td>
											<td >
												<span style="width: 70px; color: blue">
													<a href="javascript:void(0);" onClick="moveSurveyView('${ data.eval_seq }','${ data.ppr_seq }','${ data.survey_state }','${ data.survey_state }');" onkeypress="this.onclick;"><span style="color: blue">설문완료</span></a>
												</span>
											</td>
										</c:otherwise>
									</c:choose>								
								</tr>
							</c:forEach>
							</tbody>
						</table>
					</div>
				</div>
			</div>
		</div>
</form>