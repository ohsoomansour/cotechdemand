<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<script src="${pageContext.request.contextPath}/plugins/ckeditor/ckeditor.js"></script>
<script>
$(document).ready(function(){
	//문항 등록
	$('#submit').click(function(){	
		for (instance in CKEDITOR.instances) {
	        CKEDITOR.instances[instance].updateElement();
	    }

		if($('input:radio[name="que_pcd"]').is(":checked") == false){
			alert_popup('문항 구분을 선택해주세요.');	
		
		}else if($('#queTitle').val() == ''){
			alert_popup('문항 제목을 입력해주세요.');
			setTimeout(function(){
				$('#queTitle').focus();
			}, 500);
			
		}else if($('#ctgrData').val() == ''){
			alert_popup('카테고리를 선택해주세요.');
			setTimeout(function(){
				$('#ctgrData').focus();
			}, 500);
		
		/* 객관식 문항  */
		}else if($('input:radio[id="queOption"]').is(":checked") == true && $('input[name="item_title"]').val() == ''){
			alert_popup('객관식 문항 제목을 입력해주세요.');
			setTimeout(function(){
				$('input[name="item_title"]').focus();
			}, 500);
			
		/* 객관식(다중)문항  */	
		}else if($('input:radio[id="queMultiOption"]').is(":checked") == true && $('input[name="item_title"]').val() == ''){
			alert_popup('객관식 문항 제목을 입력해주세요.');
			setTimeout(function(){
				$('input[name="item_title"]').focus();		
			}, 500);
			
		}else if($('#queBody').val() == ''){
			alert_popup('문항 내용을 입력해주세요.');
			setTimeout(function(){
				$('##queBody').focus();
			}, 500);
				
				
		}else{			
			$.ajax({
	            url : "/admin/addSurveyQue.do",
	            type: "post",
	            data: $('#frm').serialize(),
	            dataType: "json",
	            success : function(){
	            	alert_popup('문항이 등록되었습니다.');          	
	            },
	            error : function(){
	            	alert_popup('문항 등록에 실패했습니다.');    
	            },
	            complete : function(){
	            	parent.fncList();
	            	parent.$("#dialog").dialog("close");
	            }
			}); 
		}
	});	
		
	CKEDITOR.replace('queBody',{
		filebrowserUploadUrl:'/admin/uploadEditorImg'
	}); 
	CKEDITOR.on('dialogDefinition', function (ev) {
		var dialogName = ev.data.name;
		var dialog = ev.data.definition.dialog;
		var dialogDefinition = ev.data.definition;
	
			if (dialogName == 'image') {
				dialog.on('show', function (obj) {
					this.selectPage('Upload'); 
				});
				
		        var infoTab = dialogDefinition.getContents('info'); 
			        infoTab.remove('txtHSpace'); 
			        infoTab.remove('txtVSpace');
			        infoTab.remove('txtBorder');
			        infoTab.remove('txtWidth');
			        infoTab.remove('txtHeight');
			        infoTab.remove('ratioLock');	        
					dialogDefinition.removeContents('advanced'); 
					dialogDefinition.removeContents('Link'); 				
			}
	});
	
	//역량진단 카테고리 (드롭다운메뉴)
	$("#ctgrData").mcDropdown("#ctgrMenu", {
			allowParentSelect: true    
			, delim: ">"
			, valueAttr: "id"    
			, select: function(id) {
			$('#ctgrSeq').val(id);
			}
		}); 
	
	//객관식 문항 등록
	$('#addQueItem').click(function(){	
		queItemView();
	});
});

//문항 유형별 조건
function queType(){
	var correct = $('#correct'); //문항 정답
	var ansCorrect = $('#ansCorrect'); //문항 정답 Input
	var queItem = $('#queItem'); //객관식 문항
	var resultQue = $('#resultQue'); //객관식 문항 목록
	
	//주관식
	var similiar = $('#similar'); //답안 유사
	//OX형
	var queOX = $('#ox'); // OX퀴즈
	var ansOX = $('.ansOX'); //OX형 정답
	//설문형 척도
	var survey = $('#survey'); //설문형척도
	var ansSurvey = $('.ansSurvey') //설문형척도 정답 
	
	//객관식
	if ($('input:radio[id="queOption"]').is(":checked") == true){
		queItem.show();
		queOX.hide();
		survey.hide();
		ansOX.removeAttr('name');		
		ansSurvey.removeAttr('name');		
		
		$('.ansSurvey').attr('disabled', false);
		$('.ansOX').attr('disabled', false);
	//객관식(다중)
	}else if ($('input:radio[id="queMultiOption"]').is(":checked") == true){		
		queItem.show();	
		queOX.hide();
		survey.hide();
		ansOX.removeAttr('name');		
		ansSurvey.removeAttr('name');	
		
		$('.ansSurvey').attr('disabled', false);
		$('.ansOX').attr('disabled', false);			
	//주관식	
	}else if ($('input:radio[id="queSubjective"]').is(":checked") == true){		
		queItem.hide();
		queOX.hide();
		survey.hide();
		
		$('.ansSurvey').attr('disabled', false);
		$('.ansOX').attr('disabled', false);
	//설문형	
	}else if ($('input:radio[id="queSurvey"]').is(":checked") == true){
		survey.show();
		queItem.hide();
		queOX.hide();
		ansSurvey.attr('name','item_title');	
		ansOX.removeAttr('name');	
		
		$('.ansSurvey').attr('disabled', false);
		$('.ansOX').attr('disabled', true);
	//OX형
	}else{
		queItem.hide();
		queOX.show();
		survey.hide();	
		ansOX.attr('name','item_title');	
		ansSurvey.removeAttr('name');		
		
		$('.ansSurvey').attr('disabled', true);
		$('.ansOX').attr('disabled', false);
	}
}

function queItemView(){
	
	var idx = Number($('input[name="item_idx"]').length);
	
	var html = "<tr id="+idx+">";
	html += "<td class='form-inline w60'><input type='text' class='form-control' name='item_idx' value='" + (idx+1) +"')' readonly style='width:60px;text-align: center'></td>";
	html += "<td class='form-inline w180'><input type='text' class='form-control w200' name='item_title'></td>";
	html += "<td class='form-inline w50'><a href='javascript:void(0);' class='btn btn-default btn-sm' onClick='deleteQueItem(" + idx + ");return false' onkeypress='this.onclick;'>삭제</a></td>";
	html += "</tr>";
	$('#resultQue').append(html);
}


function deleteQueItem(idx) {
	
	$('#' + idx).remove();
	
	var length = $('input[name="item_idx"]').length;
	console.log(length);
	for(var i = 0; i < length; i++){
		$('input[name="item_idx"]').eq(i).val(i+1);
	}
}
</script>
<form action="#" id="frm" name="frm" method="post" enctype="multipart/form-data">
	<input type="hidden" id="queSeq" name="que_seq" value="${ paraMap.que_seq }" />	
	<input type="hidden" id="itemSeq" name="item_seq" value="${ paraMap.item_seq }" />	
	<input type="hidden" id="seqTblnm" name="seq_tblnm" value="${ paraMap.seq_tblnm }" />			
	<input type="hidden" id="ctgrSeq" name="ctgr_seq" value="" />			
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
		  				<input type="text" id="queTitle" name="que_title" class="form-control"/>
		  			</td>
		  		</tr>		  					  		
		  		<!-- 문항 구분 -->		  			  		
		  		<tr>
		  			<th>문항 구분</th>
					<td class="left form-group">
		  				<input type="radio" id="queOption" name="que_pcd" class="que_option" value="QUE_P001" onclick="queType(this);"><label for="queOption">객관식</label>&nbsp;	
<!-- 		  				<input type="radio" id="queMultiOption" name="que_pcd" class="que_multioption" value="QUE_P004" onclick="queType(this);"><label for="queMultiOption">객관식(다중)</label>&nbsp;			 -->  				  
		  				<input type="radio" id="queSubjective" name="que_pcd" class="que_subjective" value="QUE_P002" onclick="queType(this);"><label for="queSubjective">주관식</label>&nbsp;	
<!-- 		  				<input type="radio" id="queSurvey" name="que_pcd" class="que_servey" value="QUE_P003" onclick="queType(this);"><label for="queSurvey">설문형 척도</label>&nbsp;	
		  				<input type="radio" id="queOX" name="que_pcd" class="que_ox" value="QUE_P005" onclick="queType(this);"><label for="queOX">OX형</label>	 -->
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
										<th class="ui-state-default w60">문항 순서</th>					
										<th class="ui-state-default w180">문항 제목</th>		
										<th class="ui-state-default w50">삭제</th>										
									</tr>
									<tbody id="resultQue">
									</tbody>		
								</table>	   							
	  						</div>
	  					</div>								  					  								
		  			</td>
		  		</tr>		
		  		<!-- 설문형 척도-->		  			
		  		<tr id="survey" style="display: none">
		  			<th>보기</th>
		  			<td class="left form-inline">
		  				<span style="color: red">※ 설문형 척도 문항 보기는 자동으로 등록됩니다.</span>
		  				<input type="hidden" id="ansSurvey1" name="item_title" class="ansSurvey" value="매우 그렇다" disabled="disabled">
		  				<input type="hidden" id="ansSurvey2" name="item_title" class="ansSurvey" value="그렇다" disabled="disabled">
		  				<input type="hidden" id="ansSurvey3" name="item_title" class="ansSurvey" value="보통" disabled="disabled">
		  				<input type="hidden" id="ansSurvey4" name="item_title" class="ansSurvey" value="그렇지 않다" disabled="disabled">
		  				<input type="hidden" id="ansSurvey5" name="item_title" class="ansSurvey" value="매우 그렇지 않다" disabled="disabled">				  					  								
		  			</td>
		  		</tr>		
		  		<!-- OX형 -->  
		  		<tr id="ox" style="display: none">
		  			<th>보기</th>
		  			<td class="left form-inline">
		  				<span style="color: red">※ OX형 문항 보기는 자동으로 등록됩니다.</span>
		  				<input type="hidden" name="item_title" class="ansOX" value="O" disabled="disabled"/>
		  				<input type="hidden" name="item_title" class="ansOX" value="X" disabled="disabled"/>
		  			</td>
		  		</tr>						  		  		  		 		  		  				  				  				  		
		  		<!-- 문항 내용 -->		  			  		  		
		  		<tr>
		  			<th>문항 내용</th>
		  			<td class="left">
 						<textarea id="queBody" name="que_body" class="form-control" style="height: 200px"></textarea>
 						※  문항의 대한 예시나 지문 등의 사용됩니다.
		  			</td>
		  		</tr>		  					  		        	
		  		<!-- 문항 사용여부 -->			        		  		
		  		<tr>
		  			<th>사용여부</th>
		  			<td class="left">
			            <select id="useYn" class="form-control w150" name ="useyn">
					         <option value="Y">사용</option>
					         <option value="N">미사용</option>		                	
				        </select>
		  			</td>
		  		</tr>   		 		
		  	</table>  	
		  		<div class="btnList alignRight mTop10">
					<button type="button" id="submit" class="btn btn-primary btn-sm">등록</button>
				</div>	
		</div>
	</div>
</form>