<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<script src="${pageContext.request.contextPath}/plugins/ckeditor/ckeditor.js"></script>
<script>
$(document).ready(function(){
	initDatePicker([$('#evalSday'), $('#evalEday')]);
	
	//설문지등록
	$('#submit').click(function(){
		
		if(!isBlank('설문지 제목', '#pprTitle')){
		if($('#evalSeq').val() == ''){
			alert_popup('설문조사 계획을 선택해주세요.');
			}else{			
				for (instance in CKEDITOR.instances) {
			        CKEDITOR.instances[instance].updateElement();
			    }
					$.ajax({
			            url : "/admin/addSurveyPaper.do",
			            type: "post",
			            data: $('#frm').serialize(),
			            dataType: "json",
			            success : function(){
			            	alert_popup('설문지가 등록되었습니다.');          	
			            },
			            error : function(){
			            	alert_popup('설문지 등록에 실패했습니다.');    
			            },
			            complete : function(){
			            	parent.fncList();
			            	parent.$("#dialog").dialog("close");
			            }
					});
			}
		}
	});	
	
	CKEDITOR.replace('pprBody',{
		filebrowserUploadUrl:'/admin/uploadEditorImg'
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
		var idx = Number($('input[name="item_idx"]').length);
		
		var html = "<tr id="+idx+">";
		html += "<td class='form-inline w60'><input type='text' class='form-control' name='item_idx' value='" + (idx+1) +"')' readonly style='width:60px;text-align: center'></td>";
		html += "<td class='form-inline w180'><input type='text' class='form-control w200' name='item_title'></td>";
		html += "<td class='form-inline w50'><a href='javascript:void(0);' class='btn btn-default btn-sm' onClick='deleteQueItem(" + idx + ");return false' onkeypress='this.onclick;'>삭제</a></td>";
		html += "</tr>";
		$('#resultQue').append(html);
	});
});

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
	<input type="hidden" id="pprSeq" name="ppr_seq" value="${ paraMap.ppr_seq }" />
	<input type="hidden" id="itemSeq" name="item_seq" value="${ paraMap.item_seq }" />		
	<input type="hidden" id="evalSeq" name="eval_seq" value=""/>		
	<input type="hidden" id="seqTblnm" name="seq_tblnm" value="${ paraMap.seq_tblnm }" />			
	<div class="modal_pop_cont">
		<div class="table2 mTop10">
		<table>
			<colgroup>
				<col style="width:10%" />
				<col />
			</colgroup>
			<tbody class="line">	
				<tr>
					<th>사업명</th>
					<td class="left form-group">
						<select id="scWhere" name="sc_where" class="form-control w200">
							<option value="">전체</option>			
							<option value="ppr_title">사업년도</option>
							<option value="reguid">등록자</option>
							<option value="moduid">수정자</option>												
						</select>
						<input type="text" id="scKeywd" name="sc_keywd" class="form-control w400" size="40" placeholder="검색어를 입력하세요."> 
					</td>	
				</tr>			  	
		  		<tr>
		  			<th>설문제목</th>
		  			<td class="left">
		  				<input type="text" id="pprTitle" name="ppr_title" class="form-control"/>
		  			</td>
		  		</tr>	
		  		<tr>
		  			<th>설문대상</th>
		  			<td class="left form-group">
						<select id="research" name="research" class="form-control">
							<option value="all">전체/수요기업/공급기업</option>
						</select>
					</td>
		  		</tr>	
				<tr>
					<th>설문기간</th>
					<td class="left form-group">
						<input type="text" id="strDate" name="eval_sday" class="form-control w300">
						~
						<input type="text" id="endDate" name="eval_eday" class="form-control w300">
					</td>
				</tr>			  			  			  					  				  				  				  					  		        	 		 		
		  	</table><br><br> 	
		  	<div class="btnList alignRight mTop10">
				<button type="button" id="submit" class="btn btn-primary btn-sm">등록</button>
			</div>	
		</div>
	</div>
</form>