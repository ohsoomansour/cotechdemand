<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<script>
$(document).ready(function(){	
	var notice_seqno = $('#notice_seqno').val();
	setTimeout(function(){
		$('#sc_keywd').focus();
	}, 500);	
});

function moveDetail(notice_seqno, fmst_seqno){
	$('#notice_seqno').val(notice_seqno);
	$('#fmst_seqno').val(fmst_seqno);
	var frm = document.createElement('form'); 
	// set attribute (form) 
	frm.name = 'frm3'; 
	frm.method = 'post'; 
	frm.action = '/front/viewNotice.do'; 
	// create element (input) 
	var input1 = document.createElement('input'); 
	var input2 = document.createElement('input'); 
	var input3 = document.createElement('input'); 
	var input4 = document.createElement('input'); 
	// set attribute (input) 
	input1.setAttribute("type", "hidden"); 
	input1.setAttribute("name", "notice_seqno"); 
	input1.setAttribute("value", notice_seqno); 
	input2.setAttribute("type", "hidden"); 
	input2.setAttribute("name", "fmst_seqno"); 
	input2.setAttribute("value", fmst_seqno); 
	input3.setAttribute("type", "hidden"); 
	input3.setAttribute("name", "member_seqno"); 
	input3.setAttribute("value", "${ userInfo.member_seqno }"); 
	input4.setAttribute("type", "hidden"); 
	input4.setAttribute("name", "id"); 
	input4.setAttribute("value", "${ userInfo.id }"); 
	// append input (to form) 
	frm.appendChild(input1); 
	frm.appendChild(input2); 
	frm.appendChild(input3);
	frm.appendChild(input4); 
	// append form (to body) 
	document.body.appendChild(frm); 
	frm.submit();
}
/* function doSearch(e) {
	$('#page').val(1);
	$('#frm').submit();
} */

//페이징
function fncList(page) {
	$('#page').val(page);
	
	$('#frm').submit();
}
</script>
<form action="/front/viewNotice.do" id="frm2" name="frm2" method="post">
	<input type="hidden" id="notice_seqno" name="notice_seqno" value=""/>
	<input type="hidden" id="fmst_seqno" name="fmst_seqno" value=""/>
	<input type="hidden" name="member_seqno" value="${userInfo.member_seqno}">
	<input type="hidden" name="id" value="${userInfo.id}">
</form>

<form action="#" id="frm" name="frm" method="get">
<input type="hidden" name="page" id="page" value="${paraMap.page}" />
<input type="hidden" name="sidx" id="sidx" value="${paraMap.sidx}" />
<input type="hidden" name="sord" id="sord" value="${paraMap.sord}" />


<div id="compaVcContent" class="cont_cv">
		<div id="mArticle" class="assig_app">
			<h2 class="screen_out">본문영역</h2>
			<div class="wrap_cont">
				<!-- page_title s:  -->
				<div class="area_tit">
					<h3 class="tit_corp">통지</h3>
				</div>
				<!-- //page_title e:  -->
				<div class="area_cont">
					<div class="search_box">
						<div class="search_box_inner">
							<div class="search_cu_box">
						    	<span>확인여부</span> 
						    	<select id="scConfirm" class="select_normal select_year" name="sc_confirm" title="확인여부">
									<option title="전체" value="">전체</option>			
									<option title="확인" value="1999-01-02">확인</option>
									<option title="미확인" value="1999-01-01">미확인</option>		
								</select>
							</div>
							<div class="search_cu_box">
						    	<select id="sc_where" class="select_normal select_year" name="sc_where" title="구분">
									<option title="전체" value="notice_all">전체</option>			
									<option title="제목" value="notice_title">제목</option>
									<option title="내용" value="notice_body">내용</option>												
								</select>							
								<input type="text" class="b_name" id="sc_keywd" name="sc_keywd" placeholder="검색어를 입력하세요." value="" title="검색어"/>
							</div>
							<div class="btn_wrap">
								<button type="submit" class="btn_step">
									<span>검색</span>
								</button>
							</div>
						</div>
					</div>	
					<div class="subject_corp">
						<h3 class="tbl_ttc">
							통지 목록 <span class="total_cnt">총 ${paraMap.count} 건</span>
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
				<!-- page_content s:  -->
					<div class="tbl_comm tbl_public">
						<table class="tbl">
							<caption class="caption_hide">통지 리스트</caption>
							<colgroup>
								<col style="width:5%" />
								<col style="width:50%" />
								<col style="width:15%" />
								<col style="width:15%" />
								<col style="width:15%" />
							</colgroup>
							<thead>
								<tr>
									<th>번호</th>
									<th>제목</th>	
									<th>통지일시</th>
									<th>확인여부</th>
									<th>확인일시</th>
								</tr>
							</thead>
							<tbody>
							<c:choose>
								<c:when test="${ not empty data }">
									<c:forEach var="data" items="${ data }">
										<tr>
											<td>${ data.notice_seqno }</td>
											<td style="text-align:left;">
											<c:if test="${ data.new_mark eq 'Y' }"><span class="red">[NEW]&nbsp;</span></c:if>
											<a href="javascript:void(0);" onclick="moveDetail('${data.notice_seqno}','${ data.fmst_seqno }')" title="통지${data.notice_title }상세보기">${ data.notice_title }</a>
											<td>${ data.notice_send_date }</td>			
											<c:choose>
												<c:when test="${data.notice_confirm_date eq '1999-01-01'}">
													<td>미확인</td>
													<td>-</td>
												</c:when>
												<c:otherwise>
													<td>확인</td>
													<td>${ data.notice_confirm_date }</td>
												</c:otherwise>
											</c:choose>
										</tr>
									</c:forEach>
								</c:when>
								<c:otherwise>
									<td colspan="6">작성된 게시물이 없습니다.</td>
								</c:otherwise>
							</c:choose>
							</tbody>
						</table>
					</div>
					<div class="paging_comm">${ sPageInfo }</div>
				</div>
				</div>
			</div>
		</div>
</form>