<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<script src="${pageContext.request.contextPath}/plugins/ckeditor/ckeditor.js" ></script>
<script>
var maxIdx = Number('${ maxidx.max_idx }');
$(document).ready(function(){

	//페이지 로드시 해당 문항 타입별로 데이터 셋팅
	var correct = $('#correct'); //문항 정답
	var ansCorrect = $('#ansCorrect'); //문항 정답
	var similiar = $('#similar'); //답안 유사
	var oxCorrect = $('#oxCorrect'); //OX형 정답
	var queItem = $('#queItem');
	
	//객관식
	if ($('input:radio[id="queOption"]').is(":checked") == true){
		correct.show();	
		queItem.show();
		oxCorrect.removeAttr('name');
	//객관식(다중)
	}else if ($('input:radio[id="queMultiOption"]').is(":checked") == true){		
		correct.show();	
		queItem.show();
		oxCorrect.removeAttr('name');
	//주관식	
	}else if ($('input:radio[id="queSubjective"]').is(":checked") == true){		
		similiar.show();
	//설문형	
	}else if ($('input:radio[id="queSurvey"]').is(":checked") == true){
		correct.show();	
		oxCorrect.removeAttr('name');
	//OX형
	}else{
		oxCorrect.show();
		ansCorrect.removeAttr('name');
	}
	
	//문항 수정
	$('#submit').click(function(){
		if($('input:radio[name="que_pcd"]').is(":checked") == false){
			alert_popup('문항 구분을 선택해주세요.');	
		
		}else if($('#queTitle').val() == ''){
			alert_popup_focus('문항 제목을 입력해주세요.','#queTitle');

		/* 객관식 문항  */
		}else if($('input:radio[id="queOption"]').is(":checked") == true && $('input[name="item_title"]').val() == ''){
			alert_popup('객관식문항의 제목을 입력해주세요.');
			$('input[name="item_title"]').focus();	
			
		/* 객관식(다중)문항  */	
		}else if($('input:radio[id="queMultiOption"]').is(":checked") == true && $('input[name="item_title"]').val() == ''){
			alert_popup('객관식문항의 제목을 입력해주세요.');
			$('input[name="item_title"]').focus();	
			
		}else if($('#queBody').val() == ''){
			alert_popup('문항 내용을 입력해주세요.');
			$('##queBody').focus();	
			
		}else{			
			$.ajax({
	            url : "/admin/updateSurveyQue.do",
	            type: "post",
	            data: $('#frm').serialize(),
	            dataType: "json",
	            success : function(){
	            	alert_popup('문항이 수정되었습니다.');          	
	            },
	            error : function(){
	            	alert_popup('문항 수정에 실패했습니다.');    
	            },
	            complete : function(){
	            	parent.fncList();
	            	parent.$("#dialog").dialog("close");
	            }
			}); 
		}
	});	
	
	CKEDITOR.replace('queBody',{
		filebrowserUploadUrl:'/admin/uploadImg'
	}); 

	CKEDITOR.on('dialogDefinition', function (ev) {
		var dialogName = ev.data.name;
		var dialog = ev.data.definition.dialog;
		var dialogDefinition = ev.data.definition;
	
			if (dialogName == 'image') {
				dialog.on('show', function (obj) {
					this.selectPage('Upload'); //업로드텝으로 시작
				});
				
		        var infoTab = dialogDefinition.getContents('info'); 
			        infoTab.remove('txtHSpace'); 
			        infoTab.remove('txtVSpace');
			        infoTab.remove('txtBorder');
			        infoTab.remove('txtWidth');
			        infoTab.remove('txtHeight');
			        infoTab.remove('ratioLock');	        
					dialogDefinition.removeContents('advanced'); // 자세히탭 제거
					dialogDefinition.removeContents('Link'); // 링크탭 제거					
			}
	});   
	
	//객관식 문항 등록
	$('#addQueItem').click(function(){	
		queItemView();
	});	
});

//리스트 출력
function queItemView(){
	
	var i = Number($('input[name="item_idx"]').length) + 1;	
	var idx = maxIdx + i;

	var html = "<tr id="+idx+">";
	html += "<td class='form-inline w60'><input type='text' class='form-control' name='item_idx' value='" + idx +"')' style='width:60px;text-align: center' disabled='disabled'></td>";
	html += "<td class='form-inline w180'><input type='text' class='form-control w200' name='item_title'></td>";
	html += "<td class='form-inline w50'><a href='javascript:void(0);' class='btn btn-default btn-sm' onClick='deleteQueItem(" + idx + ");return false' onkeypress='this.onclick;'>삭제</a></td>";
	html += "</tr>";
	$('#resultQue').append(html);
	
}	

//리스트에 담긴 항목 제거
function deleteQueItem(idx) {
	$('#' + idx).remove();	
	updateQueItemIdx();
}

//함수 실행시 idx 리셋
function updateQueItemIdx(){
	
	var length = $('input[name="item_idx"]').length;
	for(var i = 0; i < length; i++){
		$('input[name="item_idx"]').eq(i).val((i+1)+maxIdx);
	}
}

//객관식 문항 삭제
function deleteSurveyQueItem(item_seq){
	$.ajax({
        url : "/admin/deleteSurveyQueItem.do?item_seq=" + item_seq,
        type: "GET",
        success : function(){        	
        },
        error : function(){
        	alert_popup('객관식 문항 삭제에 실패했습니다.');    
        },
        complete : function(){
        	$('#' + item_seq).remove();
        	maxIdx =  $('input[name="item_idxs"]').length;
        	updateQueItemIdx();
        }
	});
}
</script>
<form action="#" id="frm" name="frm" method="post">
	<input type="hidden" id="queSeq" name="que_seq" value="${ paraMap.que_seq }" />		
	<input type="hidden" id="ctgrSeq" name="ctgr_seq" value="${ data.ctgr_seq }" />			
	<div class="modal_pop_cont">
		<div class="table2 mTop10">
		<table>
			<colgroup>
				<col style="width:10%" />
				<col />
			</colgroup>
			<tbody class="line">
		  		<!-- 문항 제목-->		  	
		  		<tr>
		  			<th>문항 제목</th>
		  			<td class="left">
		  				<input type="text" id="QueTitle" name="que_title" class="form-control" value="${ data.que_title }"/>
		  			</td>
		  		</tr>		  		
		  		<!-- 문항 구분 -->		  			  		
		  		<tr>
		  			<th>문항 구분</th>
					<td class="left form-group">
		  				<input type="radio" id="queOption" name="que_pcd" class="que_option" value="QUE_P001" onclick="return(false);" <c:if test="${ data.que_pcd eq 'QUE_P001' }">checked</c:if>><label for="queOption">객관식</label>&nbsp;	
		  				<%-- <input type="radio" id="queMultiOption" name="que_pcd" class="que_multioption" value="QUE_P004" onclick="return(false);" <c:if test="${ data.que_pcd eq 'QUE_P004' }">checked</c:if>><label for="queMultiOption">객관식(다중)</label>&nbsp;		 --%>	  				  
		  				<input type="radio" id="queSubjective" name="que_pcd" class="que_subjective" value="QUE_P002" onclick="return(false);" <c:if test="${ data.que_pcd eq 'QUE_P002' }">checked</c:if>><label for="queSubjective">주관식</label>&nbsp;	
<%-- 		  			<input type="radio" id="queSurvey" name="que_pcd" class="que_servey" value="QUE_P003" onclick="return(false);" <c:if test="${ data.que_pcd eq 'QUE_P003' }">checked</c:if>><label for="queSurvey">설문형</label>&nbsp;	
		  				<input type="radio" id="queOX" name="que_pcd" class="que_ox" value="QUE_P005" onclick="return(false);" <c:if test="${ data.que_pcd eq 'QUE_P005' }">checked</c:if>><label for="queOX">OX형</label><br> --%>
		  				<span class="red">※ 문항 구분은 수정이 불가능합니다.</span>		
					</td>
		  		</tr>	 
		  		<!-- 객관식 문항 목록 -->		  			
		  		<tr id="queItem" style="display: none">
		  			<th>객관식 문항</th>
		  			<td class="left">
	  					<div id="queItem" style="overflow-y:auto; overflow-x:hidden; width:100%; height:300px; border:2px solid #c9c9c9;min-height:50px;text-align: center">
	  						<div class="btnList alignRight mTop10">
	  							<button type="button" id="addQueItem" class="btn btn-default btn-sm">추가</button>	
	  							<table>
									<tr>
										<th class="ui-state-default">문항 순서</th>					
										<th class="ui-state-default">문항 제목</th>		
										<th class="ui-state-default">삭제</th>										
									</tr>
									<c:forEach var="queitem" items="${ queitem }">
										<tr id="${ queitem.item_seq }">
											<td class="form-inline w60">
												<input type="hidden" id="itemSeq" class="form-control" name="item_seqs" value="${ queitem.item_seq }" >
												<input type="text" id="itemIdx" class="form-control" name="item_idxs" value="${ queitem.item_idx }" style='width:60px;text-align: center' disabled="disabled">
											</td>
											<td class="form-inline w180">
												<input type="text" id="itemTitles" class="form-control w200" name="item_titles" value="${ queitem.item_title }">
											</td>
											<td class="form-inline w50">
												<a href="javascript:void(0);" class="btn btn-default btn-sm" onClick="deleteSurveyQueItem('${ queitem.item_seq }'); return false" onkeypress="this.onclick;">삭제</a>
											</td>
										</tr>
									</c:forEach>
									<tbody id="resultQue">
									</tbody>		
								</table>	   							
	  						</div>
	  					</div>								  					  								
		  			</td>
		  		</tr>			  		 			  			  				  				  				  		
		  		<!-- 문항 내용 -->		  			  		  		
		  		<tr>
		  			<th>문항 내용</th>
		  			<td class="left form-inline">
 						<textarea id="queBody" name="que_body" class="form-control" style="height: 200px">${ data.que_body }</textarea>
 						※  문항에 대한 예시나 지문에 사용됩니다.
		  			</td>
		  		</tr>		  					  		        	
		  		<!-- 문항 사용여부 -->			        		  		
		  		<tr>
		  			<th>사용여부</th>
		  			<td class="left form-inline">
			            <select name ="useyn" class="form-control w150">
					         <option value="Y" <c:if test="${ data.useyn == 'Y' }">  selected="selected"</c:if>>사용</option>
					         <option value="N" <c:if test="${ data.useyn == 'N' }">  selected="selected"</c:if>>미사용</option>		                	
				        </select>
		  			</td>
		  		</tr>   		 		
		  	</table>  	
		  		<div class="btnList alignRight mTop10">
					<button type="button" id="submit" class="btn btn-primary btn-sm">수정</button>
				</div>	
		</div>
	</div>
</form>