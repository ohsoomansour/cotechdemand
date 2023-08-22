<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<script>
var list = new LinkedList();
var check = 0;
$(document).ready(function(){
	$('#submit').click(function(){
		if(check == 1 && $('#ctgrNm').val() == ''){
			alert_popup('카테고리명을 입력해주세요.');
			setTimeout(function(){
				$('#ctgrNm').focus();
	       	}, 500);
		}else{
			$.ajax({
	            url : "/admin/addBoardCtgr.do",
	            type: "post",
	            data: $('#frm').serialize(),
	            dataType: "json",
	            success : function(){
	            	alert_popup('카테고리가 등록되었습니다.');          	
	            },
	            error : function(){
	            	alert_popup('카테고리 등록에 실패했습니다.');    
	            },
	            complete : function(){
	            	parent.fncList();
	            	parent.$("#dialog").dialog("close");
	            }
			}); 
		}
	});
	
	//게시판 카테고리 추가
	$('#addCtgr').button().click(function(event){	
		check = 1;	
		event.preventDefault();

		var rows = new Map();
		rows.set("index", list.length);
		list.append(rows);
		
		ctgrView();
	});			
});

//게시판 카테고리 목록
function ctgrView(){
	
	$('#resultCtgr').empty();
	$('#noCtgr').remove();
	
	for(var i = 0; i < list.length; i++){	
		var html = '';
		html = "<tr>";
		html += "<td class='left form-inline'>";
		html += "";
		html += "</td>";
		html += "<td class='left form-inline'>";
		html += "<input type='text' id='ctgrNm' class='form-control w190' name='ctgrnm' value=''>";
		html += "</td>";
		html += "<td class='left form-inline'>";
		html += " ";
		html += "</td>";		
		html += "<td class='left form-inline'>";
		html += "<a href='javascript:void(0);' class='btn btn-default btn-sm' onClick='newDeleteCtgr(" + i + ");return false' onkeypress='this.onclick;'>삭제</a>";
		html += "</td>";
		html += "</tr>";

		$('#resultCtgr').append(html);
	} 
}

//게시판 카테고리 삭제
function newDeleteCtgr(i) {
	list.remove(i);
	ctgrView(); 
}

//등록된 게시판 카테고리 삭제
function deleteCtgr(ctgr_seq){
	$.ajax({
		url : "/admin/deleteBoardCtgr.do?ctgr_seq=" + ctgr_seq,
		type: "GET",
		success : function(){
			alert_popup('카테고리가 삭제되었습니다.');
		},
		error : function(){
			alert_popup('카테고리 삭제에 실패했습니다.');
		},
        complete : function(){
            location.reload();
        }			
	});
};
</script>
<form action="#" id="frm" name="frm" method="post">	
	<input type="hidden" id="boardSeq" name="board_seq" value="${ paraMap.board_seq }" />		
	<div class="modal_pop_cont">
		<button id="addCtgr" class="btn btn-default btn-sm">추가</button>
			<table id="resultTable" style="text-align: center">
				<colgroup>
					<col width="10%" />
					<col width="25%" />
					<col width="10%" />
					<col width="5%" />
				</colgroup>
				<tr>
					<th class="ui-state-default" style="text-align: center">카테고리 번호</th>
					<th class="ui-state-default" style="text-align: center">카테고리명</th>
					<th class="ui-state-default" style="text-align: center">등록자</th>					
					<th class="ui-state-default" style="text-align: center">삭제</th>
				</tr>
				<c:choose>
					<c:when test="${ not empty category }">
						<c:forEach items="${ category }" var="data" varStatus="status">
							<tr>
								<td class="form-inline">
									<input type="text" id="ctgrSeqs" class="form-control w60" name="ctgr_seqs" value="${ data.ctgr_seq }" readonly="readonly">
								</td>
								<td class="form-inline">
									<input type="text" id="ctgrNms" class="form-control w190" name="ctgrnms" value="${ data.ctgrnm }" >
								</td>
								<td class="form-inline">
									${ data.reguid }
								</td>								
								<td class="form-inline">
									<a href="javascript:void(0);" class="btn btn-default btn-sm" onClick="deleteCtgr('${ data.ctgr_seq }');return false" onkeypress="this.onclick;">삭제</a>
								</td>
							</tr>
						</c:forEach>
					</c:when>
				<c:otherwise>
				<tr id="noCtgr">
					<td>
					</td>
					<td style="text-align: center">
				 		등록된 카테고리가 없습니다.
					</td>
				</tr>
				</c:otherwise>
				</c:choose>
				<tbody id="resultCtgr">
				</tbody>	
			</table>	   	
			<div class="btnList alignRight mTop10">       
				<button type="button" id="submit" class="btn btn-primary btn-sm">등록</button>	
			</div>
	</div>	
</form>