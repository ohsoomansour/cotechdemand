<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<script src="${pageContext.request.contextPath}/plugins/ckeditor/ckeditor.js" ></script>
<script src="${pageContext.request.contextPath}/plugins/multifile-master/jquery.MultiFile.js" ></script>
<script>
	$(document).ready(function(){

		initDatePicker([ $('#bannerSday'), $('#bannerEday')]);	
		
		var useYN = '${banner.useyn}';
		var radioCheck = $('input[name="useyn"]');
		for(var i = 0; i < radioCheck.length; i++) {
			if(radioCheck[i].value == useYN) {
				radioCheck[i].checked = true;
			}
		}
		var bannerPcd = '${banner.banner_pcd}';
		var bannerPcd2 = document.getElementById('bannerPcd');
		for(var i =0; i<bannerPcd2.length; i++){
			if(bannerPcd2[i].value == bannerPcd){	
				$('#bannerPcd').val(bannerPcd);
			}
		}
		var bannerTcd = '${banner.banner_tcd}';
		var bannerTcd2 = document.getElementById('bannerTcd');
		for(var i =0; i<bannerTcd2.length; i++){
			if(bannerTcd2[i].value == bannerTcd){	
				$('#bannerTcd').val(bannerTcd);
			}
		}

		$('#btnBannerUpdate').click(function(){
			fncBannerUpdate();
		});
		$('#btnBannerCancel').click(function(){
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
		
		
		$('#bgColor').minicolors({
			animationSpeed: 50,
			animationEasing:'swing',
			changeDelay: 0,
			control:'hue',
			defaultValue:'',
			format:'hex',
			showSpeed: 100,
			hideSpeed: 100,
			inline:false,
			keywords:'',
			letterCase:'lowercase',
			opacity:false,
			position:'bottom left',
			theme:'default',
			swatches: [],
			
			change:null,
			hide:null,
			show:null,
		});
		
	});
	
	function fncBannerUpdate(){

		if($('input[name="useyn"]:checked').val() == 'N'){
			$('#bannerIdx').val("");
		}
		
		var form = $('#frm')[0];
	    var data = new FormData(form);

		if(!isBlank("제목", '#bannerTitle')){
			$.ajax({
				type : 'POST',
				url : '/admin/updateBanner.do',
				enctype: 'multipart/form-data',
				data : data,
				processData: false,
		        contentType: false,
		        cache: false,
				success: function(){
					alert_popup('정상 수정 되었습니다.');
				},
				error : function(e) {
					alert_popup('오류 상황 : ' + e);
				},
				complete : function() {
					parent.fncList();
					parent.$('#dialog').dialog('close');
				}
			});		
		}
	}
	
	function deleteBannerView(seq, view){
		
		$.ajax({
            url : "/admin/deleteBannerView.do",
            type : "post",
            datatype : 'json',
            data : 
            { 
            	banner_seq : seq,
            	banner_img : view
            },
            success : function(result){ 
            	alert_popup('선택하신 이미지가 삭제되었습니다.');
            	$('#viewInfo').empty();
            }
		});     		
	}
		
</script>
<form action="#" id="frm" name="frm" method="post" enctype="multipart/form-data">
<input type="hidden" id="bannerSeq" name="banner_seq" value="${paraMap.banner_seq}">
<input type="hidden" id="bannerIdx" name="banner_idx" value="${banner.banner_idx}">

<div class="modal_pop_cont"> 
	<!-- 배너 수정-->
	<div class="table2 mTop5">
		<table>
			<colgroup>
				<col style="width:30%"/><col style="width:70%"/>
			</colgroup>

				<tr>
					<th>배너명</th>
					<td class="left form-inline"><input type="text" id="bannerTitle" name="banner_title" class="form-control" value="${banner.banner_title}"></td>
				</tr>
				<tr>
					<th>링크 주소</th>
					<td class="left form-inline"><input type="text" id="bannerUrl" name="banner_url" class="form-control" value="${banner.banner_url}"></td>
				</tr>		
				<tr>
					<th>배너시작일자</th>
					<td class="left form-inline"><input type="text" id="bannerSday" name="banner_sday" class="form-control" value="${banner.banner_sday}"></td>
				</tr>
				<tr>
					<th>배너마감일자</th>
					<td class="left form-inline"><input type="text" id="bannerEday" name="banner_eday" class="form-control" value="${banner.banner_eday}"></td>
				</tr>						
				<tr>
					<th>배너구분</th>
						<td class="left form-inline">
							<select id="bannerPcd" name="banner_pcd"  class="form-control" >
								<c:forEach var="item" items="${ bannerPcd }" >							
									<option value="${ item.commcd }">${ item.cdnm }</option>
								</c:forEach>
						 	</select>
						</td>
				</tr>	
				<tr>
					<th>링크타겟</th>
						<td class="left form-inline">
							<select id="bannerTcd" name="banner_tcd"  class="form-control" >
								<c:forEach var="item" items="${ bannerTcd }" >							
									<option value="${ item.commcd }">${ item.cdnm }</option>
								</c:forEach>
						 	</select>
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
								<c:if test="${ banner.banner_img ne '' }">
									<a href="#" onclick="deleteBannerView('${ banner.banner_seq }', '${ banner.banner_img }'); return false;">
										<img src="/images/admin/ico/trash.png">${ viewName }
										<img class="image_preview" src="${ banner.banner_img }"><br>
									</a>
								</c:if>
							</span>
						</div>
					</td>	
				</tr>	
				<tr>
					<th>배경색상</th>				
					<td class="left form-inline"><input type="text" id="bgColor" name="bgcolor" class="form-control" value="${banner.bgcolor }"></td>
				</tr>					
		</table>
		
		<!-- 포인트 수정 버튼 -->
		<div class="btnList alignRight mTop30">
			<button type="button" class="btn btn-default btn-sm" id="btnBannerUpdate">수정</button>
			<button type="button" class="btn btn-default btn-sm" id="btnBannerCancel">닫기</button>
		</div>
	</div>
</div>
</form>