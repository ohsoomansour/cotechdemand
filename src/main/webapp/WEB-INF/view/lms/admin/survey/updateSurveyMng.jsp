<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<script src="${pageContext.request.contextPath}/plugins/ckeditor/ckeditor.js"></script>
<script>
$(document).ready(function(){
		//설문계획 수정
		$('#submit').click(function(){		
			for (instance in CKEDITOR.instances) {
		        CKEDITOR.instances[instance].updateElement();
		    }
				$.ajax({
		            url : "/admin/updateSurveyMng.do",
		            type: "POST",
		            data: $('#frm').serialize(),
		            dataType: "json",
		            success : function(){
		            	alert_popup('설문계획이 수정되었습니다.');          	
		            },
		            error : function(){
		            	alert_popup('설문계획 수정에 실패했습니다.');    
		            },
		            complete : function(){
		            	parent.fncList();
		            	parent.$("#dialog").dialog("close");
		            }
				}); 
		});	
		
		initDatePicker(['#startDate', '#endDate', '#openDate']);	
		
		CKEDITOR.replace('evalBody',{
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
});
</script>
<form action="#" id="frm" name="frm" method="post" enctype="multipart/form-data">
	<input type="hidden" id="evalSeq" name="eval_seq" value="${ paraMap.eval_seq }" />			
	<div class="modal_pop_cont">
		<div class="table2 mTop10">
		<table>
			<colgroup>
				<col style="width:10%" />
				<col />
			</colgroup>
			<tbody class="line">
		  		<!-- 설문계획 제목-->		  	
		  		<tr>
		  			<th>설문계획 제목</th>
		  			<td class="left">
		  				<input type="text" id="evalTitle" name="eval_title" class="form-control" value="${ data.eval_title }"/>
		  			</td>
		  		</tr>	  						  					  				  				  		
		  		<!-- 설문계획 내용 -->		  			  		  		
		  		<tr>
		  			<th>설문계획 내용</th>
		  			<td class="left">
 						<textarea id="evalBody" name="eval_body" class="form-control" style="height: 200px">${ data.eval_body }</textarea>
		  			</td>
		  		</tr>	
		  		<!-- 설문 날짜 -->
		  		<tr>
					<th>설문 날짜</th>
					<td class="left form-inline">
						<input type="text" id="startDate" class="form-control w110" name="eval_sday" value="${ data.eval_sday }">
						&nbsp;~&nbsp;
						<input type="text" id="endDate" class="form-control w110" name="eval_eday" value="${ data.eval_eday }">
					</td>
				</tr>		  					  		        	
		  		<!-- 설문계획 사용여부 -->			        		  		
		  		<tr>
		  			<th>사용여부</th>
					<td class="left form-inline">
			            <select id="useYn" name="useyn" class="form-control">
							<option value="Y" <c:if test="${ data.useyn == 'Y' }">  selected="selected"</c:if>>사용</option> 
							<option value="N" <c:if test="${ data.useyn == 'N' }">  selected="selected"</c:if>>미사용</option>                	
				        </select>
		  			</td>
		  		</tr>   		 		
		  	</table><br> 	
		  	<div class="btnList alignRight mTop10">
				<button type="button" id="submit" class="btn btn-primary btn-sm">수정</button>
			</div>	
		</div>
	</div>
</form>