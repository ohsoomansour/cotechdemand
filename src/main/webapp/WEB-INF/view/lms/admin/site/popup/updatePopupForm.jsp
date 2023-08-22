<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<script src="${pageContext.request.contextPath}/plugins/ckeditor/ckeditor.js" ></script>
<script src="${pageContext.request.contextPath}/plugins/multifile-master/jquery.MultiFile.js" ></script>
<script>
	$(document).ready(function(){
	
		initDatePicker([$('#strDate'), $('#endDate')]);
		
		var useYN = '${popup.useyn}';
		var radioCheck = $('input[name="useyn"]');
		for(var i = 0; i < radioCheck.length; i++) {
			if(radioCheck[i].value == useYN) {
				radioCheck[i].checked = true;
			}
		}
		var popupPcd = '${popup.popup_pcd}';
		var popupPcd2 = document.getElementById('popupPcd');
		for(var i =0; i<popupPcd2.length; i++){
			if(popupPcd2[i].value == popupPcd){	
				$('#popupPcd').val(popupPcd);
			}
		}
		
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

		$('#btnUpdatePopup').click(function(){
			fncUpdatePopup();
		});
		$('#btnPopupCancel').click(function(){
			parent.$('#dialog').dialog('close');
		});
	});
	
		function fncUpdatePopup(){
			
			var form = $('#frm')[0];
		    var data = new FormData(form);

			if(!isBlank('팝업명', '#popupTitle')){
				$.ajax({
					url : '/admin/updatePopup.do',
					type : 'POST',
					enctype: 'multipart/form-data',
					data : data,
					processData: false,
			        contentType: false,
			        cache: false,	            
		            success : function(){
		            	alert_popup('정상 수정 되었습니다.');
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

	function deletePopupView(seq, view){
			
		$.ajax({
	    	url : "/admin/deletePopupView.do",
	        type : "post",
	        datatype : 'json',
	        data : 
	        { 
	            popup_seq : seq,
	            popup_img : view
	         },
	         success : function(result){ 
	        	 alert_popup('선택하신 이미지가 삭제되었습니다.');
	            $('#viewInfo').empty();
	         }
		});     		
	}

</script>    
    
    
<form action="#" id="frm" name="frm" method="post" enctype="multipart/form-data">
<input type="hidden" id="popupSeq" name="popup_seq" value="${ paraMap.popup_seq}" />	
	<div class="modal_pop_cont"> 
	<!-- 팝업 등록-->
		<div class="table2 mTop5">
		<table>
			<colgroup>
				<col style="width:30%"/><col style="width:70%"/>
			</colgroup>	
				<tr>
					<th>팝업명</th>
					<td class="left form-inline"><input type="text" id="popupTitle" name="popup_title" class="form-control" value="${popup.popup_title }"></td>
				</tr>			
				<tr>
					<th>팝업시작일자</th>
					<td class="left form-inline"><input type="text" id="strDate" name="popup_sday" class="form-control" value="${popup.popup_sday }"></td>
				</tr>
				<tr>
					<th>팝업마감일자</th>
					<td class="left form-inline"><input type="text" id="endDate" name="popup_eday" class="form-control" value="${popup.popup_eday }"></td>
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
							<input type="text" id="left" name="left" class="form-control" value="${popup.popup_left }">
						 	Y:
						 	<input type="text" id="top" name="top" class="form-control" value="${popup.popup_top }">
						</td>
				</tr>
				<tr>
					<th>사이즈</th>
						<td class="left form-inline">
							width:
							<input type="text" id="width" name="width" class="form-control" value="${popup.popup_width }">
							height:
							<input type="text" id="height" name="height" class="form-control" value="${popup.popup_height }">
						</td>
				</tr>					
				<tr>
					<th>사용여부</th>
					<td class="left form-inline">
						<input type="radio" name="useyn" value="Y" checked="checked"><label>사용</label>
						&nbsp&nbsp
						<input type="radio" name="useyn" value="N"><label>미사용</label>
					</td>
				</tr>																																			
				<tr>
					<th>이미지</th>
					<td class="left form-inline">
 		           		<input type="file" class="view with-preview" name="view" style="height:25px;padding-bottom: 5px"> 
						<div id="fileList" style="border:2px solid #c9c9c9;min-height:50px">
							<span id="viewInfo">
								<c:if test="${ popup.popup_img ne '' }">
									<a href="#" onclick="deletePopupView('${ popup.popup_seq }', '${ popup.popup_img }'); return false;">
										<img src="/images/admin/ico/trash.png">${ viewName }
										<img class="image_preview" src="${ popup.popup_img }"><br>
									</a>
								</c:if>
							</span>
						</div>
					</td>	
				</tr>	
		</table>

		<!-- 팝업 등록 버튼 -->
			<div class="btnList alignRight mTop30">
				<button type="button" class="btn btn-default btn-sm" id="btnUpdatePopup" >수정</button>
				<button type="button" class="btn btn-default btn-sm" id="btnPopupCancel">닫기</button>
			</div>
		</div>
	</div>
</form>