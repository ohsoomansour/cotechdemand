<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<script src="${pageContext.request.contextPath}/plugins/ckeditor/ckeditor.js" ></script>
<script src="${pageContext.request.contextPath}/plugins/multifile-master/jquery.MultiFile.js" ></script>
<script>

$(document).ready(function(){
	
	initDatePicker([$('#strDate'), $('#endDate')]);	

	$('#btnInsertBanner').click(function(){
		fncInsertBanner();
	});
	
	$('#btnInsBannerCancel').click(function(){
		parent.$('#dialog').dialog('close');
	});	

	$('input.view').MultiFile({
	    maxfile: 1024,				       
		max: 1,
		accept: 'png|jpg|jpeg|bmp|',
		STRING:{			
		remove:'<img src="/images/admin/ico/trash.png">',
		denied : "$ext 는(은) 업로드 할수 없는 파일확장자입니다.\n(업로드 가능 확장자 : 'png|jpg|jpeg|bmp|')",				
		toomany: "업로드할 수 있는 파일의 최대 갯수는 $max개 입니다.",
		toobig: "$file 파일은 업로드 가능한 크기를 초과했습니다.($size)"			
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

function fncInsertBanner(){
	
	var form = $('#frm')[0];
    var data = new FormData(form);	    
    var file_data = $("input[name='view']")[0].files;

    for(var i = 0; i < file_data.length; i++) {
    	data.set('view', file_data[i]);
    }
    
    console.log('banner color: ' + $('#bgColor').val());
       
	if(!isBlank("배너명", '#bannerTitle'))
	if(!isBlank("배경색상", '#bgColor')) 
	{		
		$.ajax({				
			url : '/admin/insertBanner.do',
			type : 'post',
			enctype: 'multipart/form-data',
			data: data,
			processData: false, 
			contentType: false,
			cache: false,
			success: function(){
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
			<tbody class="line">	
				<tr>
					<th>배너명</th>
					<td class="left form-inline"><input type="text" id="bannerTitle" name="banner_title" class="form-control"></td>
				</tr>		
				<tr>
					<th>링크 주소</th>
					<td class="left form-inline"><input type="text" id="bannerUrl" name="banner_url" class="form-control"></td>
				</tr>		
				<tr>
					<th>배너시작일자</th>
					<td class="left form-inline"><input type="text" id="strDate" name="banner_sday" class="form-control"></td>
				</tr>
				<tr>
					<th>배너마감일자</th>
					<td class="left form-inline"><input type="text" id="endDate" name="banner_eday" class="form-control"></td>
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
				<tr>
					<th>배경색상</th>				
					<td class="left form-inline"><input type="text" id="bgColor" name="bgcolor" class="form-control" value=""></td>
				</tr>					
			</tbody>
		</table>
		<!-- 배너 등록 버튼 -->
			<div class="btnList alignRight mTop30">
				<input type="button" class="btn btn-default btn-sm" id="btnInsertBanner" value="확인">
				<input type="button" class="btn btn-default btn-sm" id="btnInsBannerCancel" value="닫기">
			</div>
		</div>
	</div>
</form>