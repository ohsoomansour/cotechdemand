<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<script>
$(document).ready(function(){	

});

//상세보기 화면
function moveDetail(infoSeq) {
	location.href = '/front/viewInfo.do?infoSeq=' + infoSeq;	
}

//페이징
function fncList(page) {
	$('#page').val(page);
	$('#frm').submit();
}
</script>
<form action="#" id="frm" name="frm" method="get">
<input type="hidden" name="page" id="page" value="${paraMap.page}" />
<input type="hidden" name="rows" id="rows" value="${paraMap.rows}" />
<input type="hidden" name="sidx" id="sidx" value="${paraMap.sidx}" />
<input type="hidden" name="sord" id="sord" value="${paraMap.sord}" />
<div id="compaVcContent" class="cont_cv">
		<div id="mArticle" class="assig_app">
			<h2 class="screen_out">본문영역</h2>
			<div class="wrap_cont">
				<!-- page_title s:  -->
				<div class="area_tit">
					<h3 class="tit_corp">공지사항</h3>
				</div>
				<!-- //page_title e:  -->
				<!-- page_content s:  -->
					<div class="tbl_comm tbl_public">
						<table class="tbl">
							<caption class="caption_hide">공지사항</caption>
							<colgroup>
								<col style="width: 35%;" />
								<col style="width: 25%;" />
								<col style="width: 20%;" />
								<col style="width: 15%;" />
							</colgroup>
							<thead>
								<tr>
									<th>순번</th>
									<th>제목</th>	
									<th>등록일시</th>												
									<th>조회수</th>	
								</tr>
							</thead>
							<tbody>
							<c:choose>
								<c:when test="${ not empty data }">
									<c:forEach var="data" items="${ data }">
										<tr>
											<td>${ data.infoseq }</td>
											<td>		
												<a href="javascript:void(0);" onClick="moveDetail('${ data.infoseq }');return false" onkeypress="this.onclick;">${ data.infotitle }</a>&nbsp; 																																														
											</td>
											<td>${ data.regdtm }</td>
											<td>${ data.readcnt }</td>												
										</tr>
									</c:forEach>
								</c:when>
								<c:otherwise>
									<td colspan="6">작성된 공지사항이 없습니다.</td>
								</c:otherwise>
							</c:choose>
							</tbody>
						</table>
					</div>
				</div>
			</div>
		</div>
</form>