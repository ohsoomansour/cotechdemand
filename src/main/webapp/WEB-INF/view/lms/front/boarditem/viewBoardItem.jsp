<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<script>
var userid = '${ paraMap.userid }';
var reguid = '${ recom.reguid }';
var bitem_seq = '${ paraMap.bitem_seq }';
var seq_tblnm = $('seqTblnm').val();
$(document).ready(function(){
	//댓글 폼 셋팅
	//listCmmt();
	
	//게시물 추천 폼 셋팅
	//recomBitemForm();

	//작성자와 세션아이디가 같지않으면 조회수 증가
	if('${ paraMap.userid }' != '${ data.reguid }'){
		updateViewCnt(); //조회수 증가
	}
	
	var board_seq = $('#boardSeq').val();
	var recom_userkey = $('#recomUserkey');
	
	$('#moveListBtn').click(function(){
		var action="/front/listBoardItem.do"
	    	
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
		//location.href = '/front/listBoardItem.do?board_seq=' + board_seq;			
	});		
	
	$('#updateItemBtn').click(function(){
		var action="/front/updateBoardItem.do"
       	
      	var form = document.createElement('form');

      	form.setAttribute('method', 'post');

      	form.setAttribute('action', action);

      	document.charset = "utf-8";

   		var hiddenField = document.createElement('input');
   		hiddenField.setAttribute('type', 'hidden');
   		hiddenField.setAttribute('name', 'board_seq');
   		hiddenField.setAttribute('value', '${ paraMap.board_seq}');
   		form.appendChild(hiddenField);

   		var hiddenField2 = document.createElement('input');
   		hiddenField2.setAttribute('type', 'hidden');
   		hiddenField2.setAttribute('name', 'bitem_seq');
   		hiddenField2.setAttribute('value', '${ paraMap.bitem_seq }');
   		form.appendChild(hiddenField2);
   		
      	document.body.appendChild(form);

      	form.submit(); 	
		//location.href = '/front/updateBoardItem.do?bitem_seq=' + bitem_seq + "&board_seq=" + board_seq;			
	});	
	
	$('#deleteItemBtn').click(function(){
			var ok = confirm("정말로 삭제하시겠습니까?");
   			if (ok) {
   	   			var url = '/front/deleteBoardItem.do?bitem_seq=' + bitem_seq + "&board_seq=" + board_seq;
   				$.ajax({
 			       url : url,
 			       type: "get",
 			       processData: false,
 			       contentType: false,
 			       dataType: "json",
 			       success : function(res){
 				      if(res.result >= 0){
 				    	var action="/front/listBoardItem.do"
 				        	
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
	
			        	alert_popup('삭제 되었습니다',undefined,form);
 					      }
 				      else{
 				    	 alert_popup("실패 했습니다.");
 					      }
 			       	console.log("결과",res);   
 			       },
 			       error : function(){
 			    	  alert_popup('게시판 등록에 실패했습니다.');    
 			       },
 			       complete : function(){
 				       
 			       	//parent.fncList();
 			       	//parent.$("#dialog").dialog("close");
 			       }
 			});		        			
   			}			
	});	
});
//댓글목록
function listCmmt(){
	$.ajax({
		url : "/front/listBoardCmmt.do",
		type : "GET",
		data : { 'bitem_seq' : bitem_seq },
		success : function(data){
		var html = '';
		
        	for(var i = 0; i < data.cmmt.length; i++){
	           	var strCmmtbody = "'" + data.cmmt[i].cmmt_body + "'"; //문자열 넘기기
	            html += '<div id="cmmt_' + data.cmmt[i].cmmt_seq + '">';
	            html += '<div id="cmmtInfo"' + data.cmmt[i].cmmt_seq + '">'+'작성자 : ' + data.cmmt[i].reguid + ' / 작성일자 : ' + data.cmmt[i].regdtm;     
	            if(userid == data.cmmt[i].reguid) {     
	            	html += '<a href="javascript:void(0);" onclick="updateCmmtForm(' + data.cmmt[i].cmmt_seq + ', ' + strCmmtbody + ');" title="수정">&nbsp;&nbsp;[수정]</a>&nbsp;';
	            	html += '<a href="javascript:void(0);" onclick="deleteCmmt(' + data.cmmt[i].cmmt_seq + ');" title="삭제">[삭제]</a></div>';
	            }
	            html += '<div id="cmmtBody" class="cmmt_body' + data.cmmt[i].cmmt_seq + '"> <p>' + data.cmmt[i].cmmt_body + '</p>';
	            html += '</div></div>';
        	}

        $("#cmmtArea").append(html);
		}
	})
}

//댓글 등록
function writeCmmt(){
	if($('[name=cmmt_body]').val() == ''){
		alert_popup('댓글의 내용을 입력해주세요.');
	}else{
		$.ajax({
            url : "/front/addBoardCmmt.do?bitem_seq=" + bitem_seq + "&seq_tblnm=" + seq_tblnm,
            type: "POST",
            data: $('[name=cmmt_body]').serialize(),
            dataType: "json",
            error : function(){
            	alert_popup('댓글 등록에 실패했습니다.');    
            },
            complete : function(){
            	$('[name=cmmt_body]').val('');
             	$("#cmmtArea").empty();   
            	listCmmt();  
            }
		}); 
	}
}

//댓글 수정 폼
function updateCmmtForm (cmmt_seq, cmmt_body){
    $('.cmmt_body'+cmmt_seq).empty();   
	 var strCmmtbody = "'" + cmmt_body + "'"; //문자열 넘기기
    
    var html ='';
    html += '<input type="text" name="cmmt_body_' + cmmt_seq + '" value="' + cmmt_body + '" style="width: 350px" title="댓글 내용" />';
    html += '<span>&nbsp;<button type="button" class="btn btn-primary btn-sm" onclick="updateCmmt(' + cmmt_seq 	+ ');" title="수정">수정</button></span>';
    html += '<span>&nbsp;<button type="button" class="btn btn-default btn-sm" onclick="cancleUpdate(' + cmmt_seq + ', ' + strCmmtbody + ');" title="취소">취소</button></span>';    
    
	$('.cmmt_body'+cmmt_seq).append(html);
}

//댓글 수정 취소
function cancleUpdate(cmmt_seq, cmmt_body){
	$('.cmmt_body'+cmmt_seq).empty();	
	  
	var html ='';
	html += '<div id="cmmtBody" class="cmmt_body' + cmmt_seq + '"> <p>' + cmmt_body + '</p>';
	$('.cmmt_body'+cmmt_seq).append(html); 
}

//댓글 수정
function updateCmmt(cmmt_seq){
    var cmmt_body = $('[name=cmmt_body_'+cmmt_seq+']').val();
    
	$.ajax({
		url : "/front/updateBoardCmmt.do?cmmt_seq=" + cmmt_seq,
		type: "POST",
        data : {'cmmt_body' : cmmt_body},		
		error : function(){
			alert_popup('댓글 수정에 실패했습니다.');
		},
        complete : function(){
        	$('.cmmt_body'+cmmt_seq).empty();	
      	  
        	var html ='';
        	html += '<div id="cmmtBody" class="cmmt_body' + cmmt_seq + '"> <p>' + cmmt_body + '</p>';
        	$('.cmmt_body'+cmmt_seq).append(html); 
        }			
	});
}

//댓글 삭제
function deleteCmmt(cmmt_seq){
	if(confirm('댓글을 삭제하시겠습니까?') == true){	
	$.ajax({
		url : "/front/deleteBoardCmmt.do?cmmt_seq=" + cmmt_seq,
		type: "POST",
		error : function(){
			alert_popup('댓글 삭제에 실패했습니다.');
		},
        complete : function(){
        	$("#cmmt_"+cmmt_seq+"").remove();
        }			
	});
	}else{
		return;
	}
};

//추천
function recomBtn() {
	$.ajax({
        url : "/front/addBoardRecom.do?bitem_seq=" + bitem_seq,
        type: "POST",
        dataType: "json",         
        error : function(){
        	alert_popup('추천에 실패했습니다.');    
        },
        complete : function(){            	
        	$('#recomCntForm').empty();
        	
        	$('#recomCnt').val(Number($('#recomCnt').val()) + 1);
        	
        	var html = $('#recomCnt').val() + " <button type='button' id='cancleBtn' class='btn btn-primary btn-sm' onclick='cancleBtn();' title='추천'>추천</button>";
        	$('#recomCntForm').append(html);
        }
	});  	
}

//추천 취소
function cancleBtn() {
	$.ajax({
        url : "/front/cancleBoardRecom.do?bitem_seq=" + bitem_seq,
        type: "POST",
        dataType: "json",         
        error : function(){
        	alert_popup('추천취소에 실패했습니다.');    
        },
        complete : function(){
        	$('#recomCntForm').empty();
 
        	$('#recomCnt').val(Number($('#recomCnt').val()) - 1);
        	
        	var html = $('#recomCnt').val() + " <button type='button' id='recomBtn' class='btn btn-default btn-sm' onclick='recomBtn();' title='추천'>추천</button>";
        	$('#recomCntForm').append(html);
        }
	});  
}

//게시물 추천 폼
function recomBitemForm(){
	  var html = '';
	  if(userid != reguid){
	  	html += $('#recomCnt').val() + " <button type='button' id='recomBtn' class='btn btn-default btn-sm' onclick='recomBtn();' title='추천'>추천</button>";
	  }else{
	 	 html += $('#recomCnt').val() + " <button type='button' id='cancleBtn' class='btn btn-primary btn-sm' onclick='cancleBtn();' title='추천'>추천</button>";
	  }
	  $('#recomCntForm').append(html);	
}	

//조회수 증가
function updateViewCnt(){
	var bitem_seq = '${ data.bitem_seq }';
	var bitem_seecnt = Number('${ data.bitem_seecnt }');	
	
	$.ajax({
		url : "/front/updateViewCnt.do?bitem_seq=" + bitem_seq,
		type: "POST",
        complete : function(){
        	$('#viewCnt').empty();
            var html = bitem_seecnt + 1;
            $('#viewCnt').append(html);
        }			
	});
};


//이전글 상세보기
/* function beforeDetail(bitem_seq, bitem_pcd, board_seq, reguid) {
	var useAuth = ${use_auth};
	
	if(bitem_pcd != 'BITEM_P002'){ //비밀글 체크
		$('#bitemSeq').val(bitem_seq);
		$('#menucd').val(useAuth.menucd);
		var frm = document.frm2;
		frm.submit();
	}else if(bitem_pcd == 'BITEM_P002' && reguid == '${ userid }'){ //자신의 게시물이면 조회가능
		$('#bitemSeq').val(bitem_seq);
		$('#menucd').val(useAuth.menucd);
		var frm = document.frm2;
		frm.submit();
	}else if(useAuth.insert_yn == 'Y' &&  useAuth.update_yn == 'Y' &&  useAuth.delete_yn == 'Y'){ //메뉴 관련 슈퍼 권한 존재시 조회 가능
		$('#bitemSeq').val(bitem_seq);
		$('#menucd').val(useAuth.menucd);
		var frm = document.frm2;
		frm.submit();	
	}else{	
		alert('이전게시물은 ' + reguid + '님의 비밀글입니다.');
	}
	return false;
} */

//다음글 상세보기
/* function nextDetail(bitem_seq, bitem_pcd, board_seq, reguid) {
	var useAuth = ${use_auth};
	
	if(bitem_pcd != 'BITEM_P002'){ //비밀글 체크
		$('#bitemSeq').val(bitem_seq);
		$('#menucd').val(useAuth.menucd);
		var frm = document.frm2;
		frm.submit();
 	}else if(bitem_pcd == 'BITEM_P002' && reguid == '${ userid }'){ //자신의 게시물이면 조회가능
		$('#bitemSeq').val(bitem_seq);
		$('#menucd').val(useAuth.menucd);
		var frm = document.frm2;
		frm.submit();
	}else if(useAuth.insert_yn == 'Y' &&  useAuth.update_yn == 'Y' &&  useAuth.delete_yn == 'Y'){ //메뉴 관련 슈퍼 권한 존재시 조회 가능
		$('#bitemSeq').val(bitem_seq);
		$('#menucd').val(useAuth.menucd);
		var frm = document.frm2;
		frm.submit();
	}else{	
		alert('다음게시물은 ' + reguid + '님의 비밀글입니다.');
	}
	return false;
} */
</script>
<%-- 
<form action="/front/viewBoardItem.do" id="frm2" name="frm2" method="post">
	<input type="hidden" id="bitemSeq" name="bitem_seq" value=""/>
	<input type="hidden" id="menucd" name="menucd" value=""/>
	<input type="hidden" id="boardSeq" name="board_seq" class="board_seq" value="${ paraMap.board_seq }" />
</form> --%>
<input type="hidden" id="boardSeq" class="board_seq" value="${ paraMap.board_seq }"> 
<input type="hidden" id="seqTblnm" name="seq_tblnm" value="${ paraMap.seq_tblnm }" />	  	
<input type="hidden" id="cmmtSeq" class="cmmt_seq" value="${ paraMap.cmmt_seq }">  
<input type="hidden" id="recomUserkey" class="recom_userkey" value="${ paraMap.recom_userkey }"> 
<input type="hidden" id="recomCnt" value="${ data.recom_cnt }">		
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
					<h3 class="tit_corp">문의하기</h3>
				</c:if>
			</div>
			<!-- //page_title e:  -->
			<!-- page_content s:  -->
			<div class="area_cont">
				<div class="tbl_view tbl_public">
					<table class="tbl">
						<caption >
							<c:if test="${paraMap.board_seq eq 100 }">
								사업공통 공지사항 상세화면 페이지
							</c:if>
							<c:if test="${paraMap.board_seq eq 101 }">
								문의하기 상세화면 페이지
							</c:if>
						</caption>
						<colgroup>
							<col style="width: 10%">
							<col>
						</colgroup>
						<tbody class="view">
							<tr>
								<th>제목</th>
								<td class="ta_left">
									${ data.bitem_title }
								</td>
							</tr>
							<tr>
								<th>작성자</th>
								<td class="ta_left" >
									${ data.reguid }
								</td>
							</tr>
							<tr>
								<th>작성일자</th>
								<td class="ta_left" >
									${ data.regdtm }
								</td>
							</tr>
							<tr>
								<th>조회수</th>
								<td class="ta_left" >
									${ data.bitem_seecnt }
								</td>
							</tr>
							<tr>
								<th>내용</th>
								<td class="ta_left"> 
								
									<div class="form-control" style="max-width:100%;max-height:100%;min-height:200px;"> <c:out value="${ data.bitem_body }"  escapeXml="false"/> </div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="tbl_comm tbl_public" style="margin-top:30px; border-top:0px;">
					<div class="tbl_comm tbl_public" style="margin-top:30px; border-top:0px;">
						<table class="tbl ">
							<caption style="position:absolute !important;  width:1px;  height:1px; overflow:hidden; clip:rect(1px, 1px, 1px, 1px);">문의자 첨부서류</caption>
							<colgroup>
								<col style="width: 100px;" />
								<col />
								<col style="width: 280px;" />
								<col style="width: 100px;" />
								<col style="width: 150px;" />
								<col style="width: 150px;" />
							</colgroup>
							<thead>
								<tr>
									<th>번호</th>
									<th>파일구분</th>
									<th>첨부파일명</th>
									<th>파일크기(KB)</th>
									<th>필수여부</th>
									<th>다운로드</th>
								</tr>
							</thead>
							<tbody>
								<c:forEach var="list" items="${fileList}" varStatus="status">
									<tr>
										<td>${status.count}</td>
										<td class="ta_left">
											<c:if test="${list.f_type eq 'BA' }">
												사업신청서
											</c:if> 
											<c:if test="${list.f_type eq 'MA'  }">
											매칭신청서
											</c:if> 
											<c:if test="${list.f_type eq 'CC'  }">
											기업확인서
											</c:if> 
											<c:if test="${list.f_type eq 'ETC'  }">
											기타
											</c:if>
										</td>
										<td class="ta_left">${list.f_org_nm}</td>
										<td>${list.trans_size }</td>
										<td>필수</td>
										<td>
											<a class="btn_step" href="/file/download.do?fmst_seq=${list.fmst_seq }&fslv_seq=${list.fslv_seq}" title="다운로드">
											다운로드
											<span class="icon ico_down"></span>
											</a>
										</td>
									</tr>
								</c:forEach>
								
								<c:if test="${empty fileList}">
									<tr>
										<td colspan="6">
										첨부서류가 없습니다.
										</td>
									</tr>
								</c:if>
							</tbody>
						</table>
					</div>
				<c:if test="${empty cmmt }">
					<div class="wrap_btn _center">
						<c:if test="${paraMap.board_seq eq 101 }">
			 				<c:if test="${ data.reguid eq paraMap.userid }">
				 			<!-- 수정  -->
							<button type="button" id="updateItemBtn" class="btn_appl" title="수정">수정</button>
							<!-- 삭제 -->
							<button type="button" id="deleteItemBtn" class="btn_appl" title="삭제">삭제</button> 
							</c:if> 		
						</c:if>
						<!-- 목록 -->					
						<button type="button" id="moveListBtn" class="btn_appl" title="목록으로 이동">목록으로 이동</button>
					</div>
				</c:if>
			</div>
			<c:if test="${!empty cmmt }">
			<div class="area_tit">
				<h3 class="tit_corp">답변</h3>
			</div>
			<div class="area_cont">
				<div class="tbl_view tbl_public">
					<table class="tbl">
					<caption class="caption_hide">답변화면 페이지</caption>
						<colgroup>
							<col style="width: 10%">
							<col>
						</colgroup>
						<tbody class="view">
							<tr>
								<th>제목</th>
								<td class="ta_left" >
									${cmmt.cmmt_title}
								</td>
							</tr>
							<tr>
								<th>작성자</th>
								<td class="ta_left" >
									${cmmt.reguid}
								</td>
							</tr>
							<tr>
								<th>작성일자</th>
								<td class="ta_left" >
									${fn:substring(cmmt.regdtm,0,19)} 
								</td>
							</tr>
							<c:if test="${cmmt.regdtm ne cmmt.moddtm}">
								<tr>
									<th>수정일자</th>
									<td class="ta_left" >
										${fn:substring(cmmt.moddtm,0,19)} 
									</td>
								</tr>							
							</c:if>
							<tr>
								<th>내용</th>
								<td class="ta_left" >
									<div class="form-control" style="max-width:100%;max-height:100%;min-height:200px;"> <c:out value="${cmmt.cmmt_body}"  escapeXml="false"/> </div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="tbl_comm tbl_public" style="margin-top:30px; border-top:0px;" >
					<table class="tbl ">
						<caption style="position:absolute !important;  width:1px;  height:1px; overflow:hidden; clip:rect(1px, 1px, 1px, 1px);">답변자 첨부서류</caption>
						<colgroup>
							<col style="width: 100px;" />
							<col />
							<col style="width: 280px;" />
							<col style="width: 100px;" />
							<col style="width: 150px;" />
							<col style="width: 150px;" />
						</colgroup>
						<thead>
							<tr>
								<th>번호</th>
								<th>파일구분</th>
								<th>첨부파일명</th>
								<th>파일크기(KB)</th>
								<th>필수여부</th>
								<th>다운로드</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="list" items="${cmmtfileList}" varStatus="status">
								<tr>
									<td>${status.count}</td>
									<td class="ta_left">
										<c:if test="${list.f_type eq 'BA' }">
											사업신청서
										</c:if> 
										<c:if test="${list.f_type eq 'MA'  }">
										매칭신청서
										</c:if> 
										<c:if test="${list.f_type eq 'CC'  }">
										기업확인서
										</c:if> 
										<c:if test="${list.f_type eq 'ETC'  }">
										기타
										</c:if>
									</td>
									<td class="ta_left">${list.f_org_nm}</td>
									<td>${list.trans_size }</td>
									<td>필수</td>
									<td>
										<a class="btn_step" href="/file/download.do?fmst_seq=${list.fmst_seq }&fslv_seq=${list.fslv_seq}" title="다운로드">
										다운로드
										<span class="icon ico_down"></span>
										</a>
									</td>
								</tr>
							</c:forEach>
							
							<c:if test="${empty cmmtfileList}">
								<tr>
									<td colspan="6">
									첨부서류가 없습니다.
									</td>
								</tr>
							</c:if>
						</tbody>
					</table>
				</div>
				<div class="wrap_btn _center">
					<c:if test="${paraMap.board_seq eq 101 }">
		 				<c:if test="${ data.reguid eq paraMap.userid }">
			 			<!-- 수정  -->
						<button type="button" id="updateItemBtn" class="btn_appl" title="수정">수정</button>
						<!-- 삭제 -->
						<button type="button" id="deleteItemBtn" class="btn_appl" title="삭제">삭제</button> 
						</c:if> 		
					</c:if>
					<!-- 목록 -->					
					<button type="button" id="moveListBtn" class="btn_appl" title="목록으로 이동">목록으로 이동</button>
			</div>
				
				<%-- <div style="padding-left: 20px">
					   	<c:if test="${ board.cmmt_yn eq 'Y'}">
							<div id="cmmtArea"></div>				
							<input type="text" id="cmmtBody" name="cmmt_body" placeholder="댓글을 입력하세요." style="width: 350px">			
							<button type="button" id="writeBtn" class="btn btn-primary btn-sm" onclick="writeCmmt()">등록</button><br><br>	
						</c:if>
				</div> --%>
			</div>
			</c:if>
			
			<%-- <div class="area_cont">
<!--                          <h4 class="subject_corp">공지사항</h4>
 -->                         <div class="box_info2">
                             <dl>
                                 <dt>제목</dt>
                                 <dd>${ data.bitem_title }</dd>
                             </dl>
							 <c:if test="${ !empty data.ctgrnm  }">                             
                             <dl>
                                 <dt>카테고리</dt>
                                 <dd>${ data.ctgrnm }</dd>
                             </dl>
                             </c:if>
                             <dl>
                                 <dt>작성자</dt>
                                 <dd>${ data.reguid }&nbsp;</dd>
                             </dl>
                             <dl class="col4">
                                 <dt>작성일자</dt>
                                 <dd>${ data.regdtm }</dd>
                             </dl>
                             <dl> 
                                 <dt>첨부파일</dt>
								 <c:choose>
									<c:when test="${ !empty file }">			            	      
					        			<dd class="left form-inline"><c:forEach var="file" items="${ file }"><a href="/front/downloadBoardAttach.do?attf_seq=${ file.attf_seq }">${ file.file_name }</a><br></c:forEach></dd>
						             </c:when>
						             <c:otherwise>
						            	 <dd class="left form-inline"><span style="color:gray">첨부파일이 없습니다.</span></dd>
						             </c:otherwise>
						          </c:choose>                                 
                             </dl>
                             <dl>
                                 <dt>조회수</dt>
                                 <dd>${ data.bitem_seecnt }</dd>
                             </dl>
                             <dl>
	                             <dt>내용</dt>
	                             <dd>${ data.bitem_body }</dd>           
                             </dl>
	    					 <c:if test="${ board.recom_yn eq 'Y'}">                             
	                             <dl>
		                             <dt>추천</dt>
		                             <dd id="recomCntForm"></dd>           
	                             </dl> 
                             </c:if>                            
                         </div>
                         
                     </div>
                     <div class="area_cont area_cont2">
					<!-- 댓글 시작 --> 
					<div style="padding-left: 20px">
					   	<c:if test="${ board.cmmt_yn eq 'Y'}">
							<div id="cmmtArea"></div>				
							<input type="text" id="cmmtBody" name="cmmt_body" placeholder="댓글을 입력하세요." style="width: 350px">			
							<button type="button" id="writeBtn" class="btn btn-primary btn-sm" onclick="writeCmmt()">등록</button><br><br>	
						</c:if>
					</div>
					<!-- 댓글 끝 -->	
					<!-- 이전글, 다음글 시작 -->
					<div style="padding-left: 70px">		
						<table class="table table-striped" style="font-size: 14px; width: 200px;">
				            <c:if test="${ !empty before.bitem_title }">		        
				            <tr>
				                <th>&nbsp;이전글</th>
				                <td class="left form-inline">&nbsp;<a href="javascript:void(0);" onClick="beforeDetail('${ before.bitem_seq }','${ before.bitem_pcd }','${ before.board_seq }','${ before.reguid }');return false" onkeypress="this.onclick;">${ before.bitem_title }</a></td>
				            </tr>
				            </c:if>
				            <c:if test="${ !empty next.bitem_title }">
				            <tr>
				                <th>&nbsp;다음글</th>    
				                <td class="left form-inline">&nbsp;<a href="javascript:void(0);" onClick="nextDetail('${ next.bitem_seq }','${ next.bitem_pcd }','${ next.board_seq }','${ next.reguid }');return false" onkeypress="this.onclick;">${ next.bitem_title }</a></td>
				            </tr>	
				            </c:if>	            			
				  			</table>
				   	</div>
				   	<!-- 이전글, 다음글  끝 -->
					<div class="wrap_btn _center">
					<c:if test="${paraMap.board_seq eq 101 }">
			 				<c:if test="${ data.reguid eq paraMap.userid }">
				 			<!-- 수정  -->
								<button type="button" id="updateItemBtn" class="btn_appl">수정</button>
							<!-- 삭제 -->
								<button type="button" id="deleteItemBtn" class="btn_appl">삭제</button> 
							</c:if> 		
					</c:if>
 							<!-- 목록 -->					
						<button type="button" id="moveListBtn" class="btn_appl">목록으로 이동</button>
					</div>
             </div> --%>
			<!-- //page_content e:  -->
		</div>
	</div>
</div>
</div>