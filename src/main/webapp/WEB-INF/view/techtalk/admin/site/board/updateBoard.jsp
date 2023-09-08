<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<script>
$(document).ready(function(){
	var board_seq = $('#boardSeq').val();	

	$('#submit').click(function(){
		$.ajax({
            url : '/admin/updateBoard.do',
            data: $('#frm').serialize(),
            type: "post",
            dataType: "json",
            success : function(){
            	alert_popup('게시판이 수정되었습니다.');          	
            },
            error : function(){
            	alert_popup('게시판 수정에 실패했습니다.');    
            },
            complete : function(){
            	parent.fncList();
            	parent.$("#dialog").dialog("close");
            }
		});      
	});
});

//체크박스 값 합계
function optSum(frm)
{
   var sum = 0;
   var count = frm.board_opts.length;
   for(var i=0; i < count; i++ ){
       if( frm.board_opts[i].checked == true ){
	    sum += parseInt(frm.board_opts[i].value);
       }
   }
   frm.board_opt.value = sum;
}
</script>
<form action="#" id="frm" name="frm" method="post">
<input type="hidden" id="boardSeq" name="board_seq" value="${ paraMap.board_seq }" />		
<input type="hidden" id="boardOption" name="board_opt" class="board_option" value="${ data.board_opt }" />			
	<div class="modal_pop_cont">
		<div class="table2 mTop10">
		  	<table>
		  		<!-- 게시판 명-->		  	
		  		<tr>
		  			<th>게시판명</th>
		  			<td class="left form-inline">
		  				<input type="text" id="boardNm" name="boardnm" class="form-control" value="${ data.boardnm }"/>	  				
		  			</td>
		  		</tr>	
		  		<!-- 게시판 구분 -->		  		  		
		  		<tr>
		  			<th>게시판 구분</th>
		  			<td class="left form-inline">
		  				<input type=radio id="pcdService" name="board_pcd" class="pcd_service" value="BOARD_P001" <c:if test="${ data.board_pcd eq 'BOARD_P001'}">checked</c:if>><label for="pcdService" >서비스</label>		  			
		  				<input type=radio id="pcdTest" name="board_pcd" class="pcd_test" value="BOARD_P002" <c:if test="${ data.board_pcd eq 'BOARD_P002'}">checked</c:if>><label for="pcdTest">테스트</label> 
		  				<input type=radio id="pcdMng" name="board_pcd" class="pcd_mng" value="BOARD_P003" <c:if test="${ data.board_pcd eq 'BOARD_P003'}">checked</c:if>><label for="pcdMng">관리툴</label>		  				 				
		  			</td>
		  		</tr>	
		  		<!-- 게시판 유형 -->		  		
		  		<tr>
		  			<th>게시판 유형</th>
		  			<td class="left form-inline">
		  				<input type=radio id="tcdBoard" name=board_tcd class="tcd_board" value="BOARD_T002" <c:if test="${ data.board_tcd eq 'BOARD_T002'}">checked</c:if>><label for="tcdBoard">게시판</label>	  			
		  				<input type=radio id="tcdNotice" name="board_tcd" class="tcd_notice" value="BOARD_T001" <c:if test="${ data.board_tcd eq 'BOARD_T001'}">checked</c:if>><label for="tcdNotice">공지사항</label>	  
		  				<input type=radio id="tcdGallery" name="board_tcd" class="tcd_gallery" value="BOARD_T003" <c:if test="${ data.board_tcd eq 'BOARD_T003'}">checked</c:if>><label for="tcdGallery">갤러리</label>	
		  				<input type=radio id="tcdAttach" name="board_tcd" class="pcd_attach" value="BOARD_T005" <c:if test="${ data.board_tcd eq 'BOARD_T005'}">checked</c:if>><label for="tcdAttach">자료실</label>	
		  				<input type=radio id="tcdQnA" name="board_tcd" class="tcd_qna" value="BOARD_T004" <c:if test="${ data.board_tcd eq 'BOARD_T004'}">checked</c:if>><label for="tcdQnA">질문답변</label>		  					  					  								
		  			</td>
		  		</tr>	 
		  		<!-- 게시판 설명-->		  		 		  		
		  		<tr>
		  			<th>게시판 설명</th>
		  			<td class="left">
		  				<input type="text" id="boardCmmt" name="board_cmmt" class="form-control" value="${ data.board_cmmt }"/>
		  			</td>
		  		</tr>
		  		<!-- 게시판 옵션 -->
			    <tr>
			        <th>게시판 옵션</th>
		  			<td class="left form-inline">
						<input type="checkbox" value="1" id="commentYN" name="board_opts" class="board_opt" onClick="optSum(this.form);" <c:if test="${ data.cmmt_yn eq 'Y' }">checked</c:if>/><label for="commentYN">댓글기능</label>
						<input type="checkbox" value="2" id="recomeYN" name="board_opts" class="board_opt" onClick="optSum(this.form);" <c:if test="${ data.recom_yn eq 'Y' }">checked</c:if>><label for="recomeYN">추천기능</label><br>						
						<input type="checkbox" value="4" id="fileYN" name="board_opts" class="board_opt" onClick="optSum(this.form);" <c:if test="${ data.attach_yn eq 'Y' }">checked</c:if>><label for="fileYN">파일 첨부기능</label><br>
						첨부파일 수 : <input type="text" name="attf_maxcnt" class="form-control w70" value="${ data.attf_maxsize }"> Byte<br>		
						첨부파일 사이즈 : <input type="text" name="attf_maxsize" class="form-control w70" value="${ data.attf_maxcnt }" > 개<br>
						첨부파일 확장자 : <input type="text" name="attf_availext" class="form-control w180" value="${ data.attf_availext }">  예) jpg,txt,exe (컴마로 구분)																															
			       </td>
			    </tr>		  		
		  		<tr>
		  		<!-- 게시판 사용여부 -->					  		
		  			<th>사용여부</th>
		  			<td class="left form-inline">
			            <select id="useYn" class="form-control" name="useyn">			            
							<option value="Y" <c:if test="${ data.useyn == 'Y' }">  selected="selected"</c:if>>사용</option> 
							<option value="N" <c:if test="${ data.useyn == 'N' }">  selected="selected"</c:if>>미사용</option>		                	
				        </select>
		  			</td>
		  		</tr>   		 		
		  	</table>  		
		  		<div class="btnList alignLeft mTop10">
					<button id="submit" type="button" class="btn btn-primary btn-sm">수정</button>
				</div>	
		</div>
	</div>
</form>