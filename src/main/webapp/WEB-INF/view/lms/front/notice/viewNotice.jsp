<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<script>
var notice_seqno = '${ paraMap.notice_seqno }';
$(document).ready(function(){
	
	var notice_seqno = $('#notice_seqno').val();
	//var recom_userkey = $('#recomUserkey');

	
	
});

function moveDetail(notice_seqno){
	if(confirm("통지확인을 하시겠습니까?")){
		$.ajax({
			url : '/front/noticeConfirm.do',
			type : 'POST',
			dataType : 'json',
			data : {
				notice_seqno : notice_seqno
				},
			success : function(){
				},
				error : function() {
				}
			});
		}else{
			return false;
			}	
	
	noticeList();
}

function noticeList (){
	window.location.href = '/front/noticeList.do'
}
</script>
<form action="/front/noticeConfirm.do" id="frm2" name="frm2" method="post">
	<!-- <input type="hidden" id="notice_seqno" name="notice_seqno" value=""/> -->
</form>
<input type="hidden" id="notice_seqno" value="${ paraMap.noticeSeqno }"> 
<div id="compaVcContent" class="cont_cv">
	<div id="mArticle" class="assig_app">
		<h2 class="screen_out">본문영역</h2>
		<div class="wrap_cont"> 
			<!-- page_content s:  -->
			<div class="area_tit">
				<h3 class="tit_corp">통지</h3>
			</div>
			<!-- //page_title e:  -->
			<!-- page_content s:  -->
			<div class="area_cont">
				<div class="tbl_view tbl_public">
					<table class="tbl">
						<caption>사업공통 통지 상세화면 페이지</caption>
						<colgroup>
							<col style="width: 10%">
							<col>
						</colgroup>
						<tbody class="view">
							<tr>
								<th>통지제목</th>
								<td class="ta_left">
									<div style="max-width:100%;max-height:100%"> <c:out value="${paraMap.notice_title }"  escapeXml="false"/> </div>
								</td>
							</tr>
							<tr>
								<th>통지일시</th>
								<td class="ta_left">
									<div style="max-width:100%;max-height:100%"> <c:out value="${paraMap.notice_send_date }"  escapeXml="false"/> </div>
								</td>
							</tr>
							<tr>
								<th>통지내용</th>
								<td class="ta_left">
									<div style="max-width:100%;max-height:100%"> <c:out value="${paraMap.notice_contents }"  escapeXml="false"/> </div>
								</td>
							</tr>
							<tr>
								<th>통보확인여부</th>
								<td class="ta_left">
									<input type="hidden" id="notice_confirm_date" name="notice_confirm_date" />
									<c:choose>
										<c:when test="${paraMap.notice_confirm_date eq '1999-01-01 00:00:00'}">
											<div class="form-control" style="max-width:100%;max-height:100%">미확인 </div>
										</c:when>
										<c:otherwise>
											<div class="form-control" style="max-width:100%;max-height:100%"> 확인 </div>
										</c:otherwise>
									</c:choose>
									
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="wrap_btn _center">
					<a href="/front/noticeList.do" class="btn_list">목록으로 이동</a> 
					<c:if test="${paraMap.notice_confirm_date eq '1999-01-01 00:00:00'}">
						<a href="javascript:void(0);" onclick="moveDetail('${paraMap.notice_seqno}')" class="btn_appl">통지확인</a> 
					</c:if>
				</div>
			</div>
			<!-- //page_content e:  -->
		</div>
	</div>
</div>