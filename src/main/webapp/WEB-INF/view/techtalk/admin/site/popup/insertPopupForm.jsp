<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<script src="${pageContext.request.contextPath}/plugins/ckeditor/ckeditor.js" ></script>
<script src="${pageContext.request.contextPath}/plugins/multifile-master/jquery.MultiFile.js" ></script>
<script>
	$(document).ready(function(){
	
		initDatePicker([$('#strDate'), $('#endDate')]);
	
		$('#btnInsertPopup').click(function(){
			fncInsertPopup();
		});
		
		$('#btnInsPopupCancel').click(function(){
			parent.$('#dialog').dialog('close');
		});	
	
		$('input.view').MultiFile({
		    maxfile: 1024,				       
			max: 1,
			accept: 'png|jpg|jpeg|bmp|',
			STRING:{			
			remove:'<img src="/images/admin/ico/trash.png">',
		    denied : "<fmt:message key='error.upload.text4'><fmt:param value = '$file'/></fmt:message>",				
			toomany: "<fmt:message key='error.upload.text1'><fmt:param value = '$max'/></fmt:message>",
			toobig: "<fmt:message key='error.upload.text3'><fmt:param value = '$size'/><fmt:param value = '$file'/></fmt:message>"					
			},
		  	list:"#fileList" 		
		});	   
		
	});
	
	function fncInsertPopup(){
		
		var form = $('#frm')[0];
	    var data = new FormData(form);	    
	    var file_data = $("input[name='view']")[0].files;

	    for(var i = 0; i < file_data.length; i++) {
	    	data.set('view', file_data[i]);
	    }	       
		
		if(!isBlank('팝업명', '#popupTitle'))
		if(!isBlank('내용', '#popupBody'))
		{
			$.ajax({
				url : '/admin/insertPopup.do',
				type : 'post',
				enctype: 'multipart/form-data',
				data: data,
				processData: false, 
				contentType: false,
				cache: false,	            
	            success : function(){
	            	alert_popup('정상 등록 되었습니다.');
				},
				error : function(e) {
					alert_popup('오류 상황 : ' + e);
				},
				complete : function() {
	            	parent.fncList();
	            	parent.$("#dialog").dialog("close");
				}			
			});
		}
	}


</script>    
    
    
<form action="#" id="frm" name="frm" method="post" enctype="multipart/form-data">
<input type="hidden" id="seqTblnm" name="seq_tblnm" value="${ paraMap.seq_tblnm }" />	
	<div class="modal_pop_cont"> 
	<!-- 배너 등록-->
		<div class="table2 mTop5">
		<table>
			<colgroup>
				<col style="width:30%"/><col style="width:70%"/>
			</colgroup>	
				<tr>
					<th>팝업명</th>
					<td class="left form-inline"><input type="text" id="popupTitle" name="popup_title" class="form-control" ></td>
				</tr>			
				<tr>
					<th>팝업시작일자</th>
					<td class="left form-inline"><input type="text" id="strDate" name="popup_sday" class="form-control"></td>
				</tr>
				<tr>
					<th>팝업마감일자</th>
					<td class="left form-inline"><input type="text" id="endDate" name="popup_eday" class="form-control"></td>
				</tr>									
				<tr>
					<th>팝업구분</th>
						<td class="left form-inline">
							<select id="popupPcd" name="popup_pcd"  class="form-control" >
							<c:forEach var="item" items="${	popupPcd }" >							
							<option value="${ item.commcd }">${ item.cdnm }</option>
							</c:forEach>
						 	</select>
						</td>
				</tr>	
				<tr>
					<th>위치</th>
						<td class="left form-inline">
							X:
							<input type="text" id="left" name="popup_left" class="form-control">
						 	Y:
						 	<input type="text" id="top" name="popup_top" class="form-control" >
						</td>
				</tr>
				<tr>
					<th>사이즈</th>
						<td class="left form-inline">
							width:
							<input type="text" id="width" name="popup_width" class="form-control">
							height:
							<input type="text" id="height" name="popup_height" class="form-control" >
						</td>
				</tr>										
				<tr>
					<th>사용여부</th>
						<td class="left form-inline">
							<select id="useYn" name="useyn"  class="form-control" >
							<option value="Y">사용</option>
							<option value="N">미사용</option>
						  </select>
						</td>
				</tr>																																			
				<tr>
					<th>이미지</th>
					<td class="left form-inline">
 		           		<input type="file" class="view with-preview" name="view" style="height:25px;padding-bottom: 5px"> 
						<div id="fileList" style="border:2px solid #c9c9c9;min-height:50px"></div><br>	
					</td>	
				</tr>	
		</table>

		<!-- 배너 등록 버튼 -->
			<div class="btnList alignRight mTop30">
				<input type="button" class="btn btn-default btn-sm" id="btnInsertPopup" value="확인" >
				<input type="button" class="btn btn-default btn-sm" id="btnInsPopupCancel" value="닫기">
			</div>
		</div>
	</div>
</form>