<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<script>
	var codeOverlap = 'N';
	var mode = '${paraMap.mode}';
	
	$(document).ready(function(){
		
		if(mode == 'MU') {	//메인코드 수정
			var PCD = '${codeInfo.commcd_pcd}';
			var option = $('#pcdCode option');
			for(var i = 0; i < option.length; i++) {
				if(option[i].value == PCD) {
					console.log(i);
					$("#pcdCode option:eq('" + i +  "')").prop("selected", true);
				}
			}
			var useYN = '${codeInfo.useyn}';
			var radio = $("input[name='mainUseCheckU']");
			for(var i = 0; i < radio.length; i++) {
				if(radio[i].value == useYN) {
					radio[i].checked = true;
				}
			}
		}else if(mode == 'SU') {	//서브코드 수정
			var PCD = '${codeInfo.commcd_pcd}';
			var option = $('#pcdCode option');
			for(var i = 0; i < option.length; i++) {
				if(option[i].value == PCD) {
					$("#pcdCode option:eq('" + i +  "')").prop("selected", true);
				}
			}
			var useYN = '${codeInfo.useyn}';
			var radio = $("input[name='subUseCheckU']");
			for(var i = 0; i < radio.length; i++) {
				if(radio[i].value == useYN) {
					radio[i].checked = true;
				}
			}
		}else if(mode == 'SI') {
			var PCD = '${paraMap.c_commcd_pcd}';
			var option = $('#pcdCode option');
			for(var i = 0; i < option.length; i++) {
				if(option[i].value == PCD) {
					$("#pcdCode option:eq('" + i +  "')").prop("selected", true);
				}
			}
		}

		// 코드 등록 
		$('#btnCodeInsert').click(function() {
			fncInsertOrUpdateCode('/admin/insertCode.do');
		});
		
		// 코드 수정 
		$('#btnCodeUpdate').click(function() {
			fncInsertOrUpdateCode('/admin/updateCode.do');
		});
				
		// 다이얼로그 창 닫기 
		$('#btnCodeCancel').click(function() {
			parent.$('#dialog').dialog('close');
		});
	});

	//코드 중복검사 기능 추가 2020/04/30 - 추정완
	function fncCheckCodeOverlap() {

		var code = $('#code').val();
		
		// 코드를 입력 안했거나 기존 코드이름과 같을 경우..
		if(code == "" || code == '${codeInfo.commcd}'){
			$('#mainCodeHtml').html('');
			return false;
		}

		$.ajax({
			type : 'POST',
			url : '/admin/checkCodeOverlap.do',
			data : {
				commcd : code,
			},
			dataType : 'json',
			traditional : true,
			success: function(data){
				if(data.codeOverlap == 0) {			
					codeOverlap = 'N';
					$('#mainCodeHtml').html('사용가능한 코드입니다.').css({'color' : 'green'}, {'font-weight' : 'bold'});
				}else{
					codeOverlap = 'Y';
					$('#mainCodeHtml').html('중복된 코드입니다.').css({'color' : 'red'}, {'font-weight' : 'bold'});										
				}
			},
			error : function(e) {

			},
			complete : function() {

			}
		});
	}
	
	//메인코드 등록버튼 기능 추가 2020/04/28 - 추정완
	function fncInsertOrUpdateCode(url) {
		
		if(codeOverlap == 'Y') {
			alert_popup('중복된 코드를 입력하셨습니다.');
			$('#code').focus();
			return false;
		}
		
		var codeGcd = '';
		var code = '';

		if(mode == 'SI'){
			codeGcd = '${paraMap.c_commcd_gcd}';
			code = '${paraMap.c_commcd}';
		}else if(mode == 'MU' || mode == 'SU'){
			codeGcd = '${codeInfo.commcd_gcd}';
			code = '${codeInfo.commcd}';
		}
		
		if(!isBlank('코드 유형', '#tcdCode'))
		if(!isBlank('코드', '#code'))	
		if(!isBlank('코드명(KR)', '#codeKr'))
		if(!isBlank('코드명(EN)', '#codeEn')){		
			$.ajax({
				type : 'POST',
				url : url,
				data : {
					mode : mode,
					c_commcd : code,
					c_commcd_gcd : codeGcd,
					commcd : $('#code').val(),
					cdnm : $('#codeKr').val(),
					cdnm_en : $('#codeEn').val(),
					commcd_cmmt : $('#codeCmmt').val(),
					commcd_val1 : $('#codeVal1').val(),
					commcd_val2 : $('#codeVal2').val(),
					commcd_pcd : $('#pcdCode').val(),
					commcd_tcd : $('#tcdCode').val(),
					useyn :  $("input[name='useCheck']:checked").val()
				},
				dataType : 'json',
				traditional : true,
				success: function(data){
					if(mode == 'MI' || mode == 'SI'){
						alert_popup('코드 정보가 등록되었습니다.');
					}else if(mode == 'MU' || mode == 'SU'){
						alert_popup('코드 정보가 수정되었습니다.');
					}
				},
				error : function(e) {
	
				},
				complete : function() {
					if(mode == 'MI' || mode == 'MU') {
						parent.fncList();
					}else if(mode == 'SI' || mode == 'SU') {
						parent.fncSubList();
					}
					parent.$('#dialog').dialog('close');
				}
			});
		}		
	}
</script>
<div class="modal_pop_cont">
	<!-- 메인 코드 등록 및 수정 -->
	<div id="divCodeForm" class="table2 mTop5">
		<table>
			<colgroup>
				<col style="width:30%"/><col style="width:70%"/>
			</colgroup>
			<tbody class="line">
				<c:if test="${(paraMap.mode eq 'MI') or (paraMap.mode eq 'MU')}">
					<tr>
						<th>코드 유형(테이블명)</th>
						<td class="left form-inline"><input type="text" size="40" id="tcdCode" class="form-control" onkeyup="validateInputVal('en_num_bar', this)" value="${codeInfo.commcd_tcd}"></td>
					</tr>
					<tr>
						<th>코드 구분</th>
						<td class="left form-inline">
							<select id="pcdCode"  class="form-control">
								<c:forEach items="${commcd_pcd}" var="list">
									<option value="${list.commcd}">${list.cdnm}</option>
								</c:forEach>
							</select>
						</td>
					</tr>
				</c:if>
				<tr>
					<th>코드</th>
					<td class="left form-inline">
						<input type="text" size="40" id="code" class="form-control" onchange="fncCheckCodeOverlap()" onkeyup="validateInputVal('en_num_bar', this)" value="${codeInfo.commcd}">
						<div id="mainCodeHtml"></div>
					</td>
				</tr>
				<tr>
					<th>코드명(KR)</th>
					<td class="left form-inline"><input type="text" size="40" id="codeKr" class="form-control" value="${codeInfo.cdnm}" onkeyup="validateInputVal('ko_num_bar', this)"></td>
				</tr>
				<tr>
					<th>코드명(EN)</th>
					<td class="left form-inline"><input type="text" size="40" id="codeEn" class="form-control" value="${codeInfo.cdnm_en}" onkeyup="validateInputVal('en_num_bar', this)"></td>
				</tr>
				<tr>
					<th>코드 값1</th>
					<td class="left form-inline"><input type="text" size="40" id="codeVal1" class="form-control" value="${codeInfo.commcd_val1}"></td>
				</tr>
				<tr>
					<th>코드 값2</th>
					<td class="left form-inline"><input type="text" size="40" id="codeVal2" class="form-control" value="${codeInfo.commcd_val2}"></td>
				</tr>
				<tr>
					<th>코드 설명</th>
					<td class="left form-inline"><textarea cols="40" id="codeCmmt" class="form-control" rows="5">${codeInfo.commcd_cmmt}</textarea></td>
				</tr>
				<tr>
					<th>사용여부</th>
					<td>
						<input type="radio" name="useCheck" value="Y" checked="checked"><label>사용</label>
						&nbsp;&nbsp;
						<input type="radio" name="useCheck" value="N"><label>미사용</label>
					</td>
				</tr>
			</tbody>
		</table>
		<div class="btnList alignRight mTop30">
			<c:if test="${paraMap.mode eq 'MI' or paraMap.mode eq 'SI'}">
				<button type="button" class="btn btn-primary btn-sm" id="btnCodeInsert">등록</button>
			</c:if>
			<c:if test="${paraMap.mode eq 'MU' or paraMap.mode eq 'SU'}">
				<button type="button" class="btn btn-primary btn-sm" id="btnCodeUpdate">수정</button>
			</c:if>
			<button type="button" class="btn btn-primary btn-sm" id="btnCodeCancel">닫기</button>
		</div>
	</div>
</div>
