<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<script>
$(document).ready(function(){	
	var board_seq = $('#boardSeq').val();
	setTimeout(function(){
		$('#scWhere').focus();
	}, 500);
	
	$('#addItemBtn').click(function(){
		var action="/front/addBoardItem.do"
    	
    	var form = document.createElement('form');

    	form.setAttribute('method', 'post');

    	form.setAttribute('action', action);

    	document.charset = "utf-8";

   		var hiddenField = document.createElement('input');
   		hiddenField.setAttribute('type', 'hidden');
   		hiddenField.setAttribute('name', 'board_seq');
   		hiddenField.setAttribute('value', '${ paraMap.board_seq}');
   		
   		form.appendChild(hiddenField);
    	document.body.appendChild(form);

    	form.submit(); 	
	});	
});

//상세보기 화면
function moveDetail(bitem_seq, bitem_pcd, reguid) {
 	var useAuth = ${use_auth}; 
	var frm = document.createElement('form'); 
	// set attribute (form) 
	frm.name = 'frm3'; 
	frm.method = 'post'; 
	frm.action = '/front/viewBoardItem.do'; 
	// create element (input) 
	var input1 = document.createElement('input'); 
	var input2 = document.createElement('input'); 
	var input3 = document.createElement('input'); 
	// set attribute (input) 
	input1.setAttribute("type", "hidden"); 
	input1.setAttribute("name", "bitem_seq"); 
	input1.setAttribute("value", bitem_seq); 
	input2.setAttribute("type", "hidden"); 
	input2.setAttribute("name", "menucd"); 
	input2.setAttribute("value", ""); 
	input3.setAttribute("type", "hidden"); 
	input3.setAttribute("name", "board_seq"); 
	input3.setAttribute("value", "${ paraMap.board_seq }"); 
	// append input (to form) 
	frm.appendChild(input1); 
	frm.appendChild(input2); 
	frm.appendChild(input3); 
	// append form (to body) 
	document.body.appendChild(frm); 
	// submit form 



	
	if(bitem_pcd != 'BITEM_P002'){ //비밀글 체크
		$('#bitemSeq').val(bitem_seq);
/* 		$('#menucd').val(useAuth.menucd); */
		frm.submit();
	}else if(bitem_pcd == 'BITEM_P002' && reguid == '${ userid }'){ //자신의 게시물이면 조회가능
		$('#bitemSeq').val(bitem_seq);
	/* 	$('#menucd').val(useAuth.menucd); */
		frm.submit();
	}
	/* else if(useAuth.insert_yn == 'Y' &&  useAuth.update_yn == 'Y' &&  useAuth.delete_yn == 'Y'){ //메뉴 관련 슈퍼 권한 존재시 조회 가능
		$('#bitemSeq').val(bitem_seq);
		$('#menucd').val(useAuth.menucd);
		var frm = document.frm2;
		frm.submit();		
	} */
	else{	
		alert_popup(reguid +'님의 비밀글입니다.');
	}
	return false;
}

//페이징
function fncList(page) {
	$('#page').val(page);
	$('#frm').submit();
}
</script>

<form action="#" id="frm" name="frm" method="post">
<input type="hidden" name="page" id="page" value="${paraMap.page}" />
<input type="hidden" name="rows" id="rows" value="${paraMap.rows}" />
<input type="hidden" name="sidx" id="sidx" value="${paraMap.sidx}" />
<input type="hidden" name="sord" id="sord" value="${paraMap.sord}" />
<input type="hidden" id="boardSeq" name="board_seq" class="board_seq" value="${ paraMap.board_seq }" />
<div id="compaVcContent" class="cont_cv">
		<div id="mArticle" class="assig_app">
			<h2 class="screen_out">본문영역</h2>
			<div class="wrap_cont">
				<!-- page_title s:  -->
				<div class="area_tit">
					<c:if test="${paraMap.board_seq eq 100 }">
						<h3 class="tit_corp">공지사항</h3>
					</c:if>
					<c:if test="${paraMap.board_seq eq 101 }">
						<h3 class="tit_corp">문의게시판</h3>
					</c:if>
				</div>
				<!-- //page_title e:  -->
					<div class="search_box">
						<div class="search_box_inner">
							<div class="search_cu_box b_name_box" style="padding-left: 200px">
						    	<select id="scWhere" class="select_normal select_year" name="sc_where" title="구분">
									<option value="all" title="전체">전체</option>			
									<option value="bitem_title" title="제목">제목</option>
									<option value="reguid" title="작성자">작성자</option>
									<option value="bitem_body" title="내용">내용</option>												
								</select>							
								<input type="text" class="b_name" id="scKeywd" name="sc_keywd" placeholder="검색어를 입력하세요." value="" title="검색어"/>
							</div>
							<div class="btn_wrap">
								<button type="submit" class="btn_step" title="검색">
									<span>검색</span>
								</button>
							</div>
						</div>
					</div>				
				<!-- page_content s:  -->
					<div class="tbl_comm tbl_public">
						<table class="tbl">
							<c:if test="${paraMap.board_seq eq 100 }">
								<caption class="caption_hide">공지사항 리스트</caption>
							</c:if>
							<c:if test="${paraMap.board_seq eq 101 }">
								<caption class="caption_hide">문의게시판 리스트</caption>
							</c:if>
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
									<c:if test="${ board.recom_yn eq 'Y' }">
									<th>추천수</th>			
									</c:if>						
									<th>조회수</th>																						
									<th>작성자</th>
									<th>작성일자</th>
								</tr>
							</thead>
							<tbody>
							<c:choose>
								<c:when test="${ not empty data }">
									<c:forEach var="data" items="${ data }">
										<tr>
											<td>${ data.bitem_seq }</td>
											<td style="text-align:left;">
												<c:if test="${ data.new_mark eq 'Y' }"><span class="red">[NEW]&nbsp;</span></c:if>
												<c:if test="${ data.bitem_pcd eq 'BITEM_P002' }"><img src="/images/front/lock.png"></c:if>										
													<a href="javascript:void(0);" onClick="moveDetail('${ data.bitem_seq }','${ data.bitem_pcd }','${ data.reguid }');return false" onkeypress="this.onclick;" title="상세보기">${ data.bitem_title }</a>&nbsp; 
												<c:if test="${ data.image_yn eq 'Y'}"><img src="/images/front/image.png"></c:if>
												<c:if test="${ data.fmst_seqno ne '' }"><img src="/images/front/file.png"></c:if>
												<c:if test="${ data.cmmt_count ne 0}"><span style="color: blue">[답변 완료]</span></c:if>																					
												<c:if test="${ board.recom_yn eq 'Y' }">
											<td>${ data.recom_cnt }</td>	
											</c:if>										
											<td>${ data.bitem_seecnt }</td>	
											<td>${ data.reguid }</td>																				
											<td>${ data.regdtm }</td>
										</tr>
									</c:forEach>
								</c:when>
								<c:otherwise>
									<tr>
									<c:choose>
									<c:when test="${ board.recom_yn eq 'Y' }">
										<td colspan="6">작성된 게시물이 없습니다.</td>
									</c:when>
									<c:otherwise>
										<td colspan="5">작성된 게시물이 없습니다.</td>
									</c:otherwise>
									</c:choose>
									</tr>
								</c:otherwise>
							</c:choose>
							</tbody>
						</table>
					</div>
					<c:if test="${paraMap.board_seq eq 100 }">
					</c:if>
					<c:if test="${paraMap.board_seq eq 101  and sessionScope.user_name ne null}">
						 <div class="btnList alignRight mTop10" style="float:right; padding-top: 15px">	
							<button type="button" id="addItemBtn" class="btn_step" title="문의하기">문의하기</button>
						</div>	 
					</c:if>
				</div>
				<div class="paging_comm">${ sPageInfo }</div>
			</div>
		</div>
</form>