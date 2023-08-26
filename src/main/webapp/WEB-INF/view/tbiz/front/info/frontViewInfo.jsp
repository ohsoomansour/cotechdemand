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

	//작성자와 세션아이디가 같지않으면 조회수 증가
	if('${ paraMap.userid }' != '${ data.reguid }'){
		updateViewCnt(); //조회수 증가
	}
	
	var board_seq = $('#boardSeq').val();
	var recom_userkey = $('#recomUserkey');
	
	$('#moveListBtn').click(function(){
		location.href = '/front/listInfo.do';			
	});		
	
	$('#updateItemBtn').click(function(){
		location.href = '/front/updateBoardItem.do?bitem_seq=' + bitem_seq + "&board_seq=" + board_seq;			
	});	
	
	$('#deleteItemBtn').click(function(){
			var ok = confirm("정말로 삭제하시겠습니까?");
   			if (ok) {
   				location.href = '/front/deleteBoardItem.do?bitem_seq=' + bitem_seq + "&board_seq=" + board_seq;				        			
   			}			
	});	
});

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
</script>
<input type="hidden" id="boardSeq" class="board_seq" value="${ paraMap.board_seq }"> 
<input type="hidden" id="seqTblnm" name="seq_tblnm" value="${ paraMap.seq_tblnm }" />	  	
<input type="hidden" id="cmmtSeq" class="cmmt_seq" value="${ paraMap.cmmt_seq }">  
<input type="hidden" id="recomUserkey" class="recom_userkey" value="${ paraMap.recom_userkey }"> 
<input type="hidden" id="recomCnt" value="${ data.recom_cnt }">		

<div class="sub_contents_area_fix">
    <div class="table2 mTop20">
		<table>
    	<tr>
        	<th style="width: 200px ;text-align: center">제목</th>
        	<td class="left form-inline">${ data.infotitle }</td>
    	</tr>   	
    	<tr>
        	<th style="width: 200px ;text-align: center">작성자</th>
        	<td class="left form-inline">${ data.reguid }</td>
    	</tr>
    	<tr>
        	<th style="width: 200px ;text-align: center">작성일자</th>
        	<td class="left form-inline">${ data.regdtm }</td>
    	</tr>
    	<c:if test="${ board.attach_yn eq 'Y'}">
    	<tr>
        	<th style="width: 200px ;text-align: center">첨부파일</th>
			<c:choose>
				<c:when test="${ !empty file }">			            	      
        			<td class="left form-inline"><c:forEach var="file" items="${ file }"><a href="/front/downloadBoardAttach.do?attf_seq=${ file.attf_seq }">${ file.file_name }</a><br></c:forEach></td>
	             </c:when>
	             <c:otherwise>
	            	 <td class="left form-inline"><span style="color:gray">첨부파일이 없습니다.</span></td>
	             </c:otherwise>
	          </c:choose>		        	
    	</tr>
    	</c:if>
    	<tr>
        	<th style="width: 200px ;text-align: center">조회수</th>
        	<td id="viewCnt" class="left form-inline">${ data.readcnt }</td>
    	</tr>		    	
    	<tr>
        	<th style="width: 200px ;text-align: center">내용</th>
        	<td class="left form-inline">${ data.infocontent }</td>
    	</tr>		    			    			    			    			    	
    </table>
   </div>		    	
	<div>
		<c:if test="${ data.reguid eq paraMap.userid }">
			<!-- 수정  -->
			<button type="button" id="updateItemBtn" class="btn btn-primary btn-sm">수정</button>
			<!-- 삭제 -->
			<button type="button" id="deleteItemBtn" class="btn btn-primary btn-sm">삭제</button> 
		</c:if> 		
			<!-- 목록 -->	
		<div class="btnList alignRight mTop15 form-inline">							
			<button type="button" id="moveListBtn" class="btn btn-default btn-sm">목록</button>
		</div>
	</div>
</div>
