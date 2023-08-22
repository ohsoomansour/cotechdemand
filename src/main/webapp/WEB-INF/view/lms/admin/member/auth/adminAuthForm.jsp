<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<script>
	var overlapCheck = 0;
	$(document).ready(function(){
		var mode = '${mode}';
		console.log(mode);
		if(mode == 'U') {
			$('#codeNm').val('${authInfo.commcd}');
			$('#authNm').val('${authInfo.cdnm}');
			$('#authCmmt').val('${authInfo.commcd_cmmt}');
			var useYN = '${authInfo.useyn}';
			var authYN = '${authInfo.commcd_val1}';
			console.log(useYN);
			console.log(authYN);
			var UseRadioCheck = $('input[name="useCheck"]');
			for(var i = 0; i < UseRadioCheck.length; i++) {
				if(UseRadioCheck[i].value == useYN) {
					UseRadioCheck[i].checked = true;
				}
			}
			var authRadioCheck = $('input[name="authCheck"]');
			for(var i = 0; i < authRadioCheck.length; i++) {
				if(authRadioCheck[i].value == authYN) {
					authRadioCheck[i].checked = true;
				}
			}
		}
		$('#btnAuthInsert').click(function() {
			fncAuthInsert();
		});
		$('#btnAuthUpdate').click(function() {
			fncAuthUpdate();
		});
		$('#btnAuthCancel').click(function() {
			parent.$('#dialog').dialog('close');
		});

	});
	
	//코드 중복체크 기능 추가 2020/04/21 - 추정완
	function fncCodeCheck(mode) {
		console.log(mode);
		var commcd = $('#codeNm').val();
		$.ajax({
			type : 'POST',
			url : '/admin/codeCheck.do',
			dataType : 'json',
			data : {
				commcd : commcd
			},
			traditional : true,
			success: function(data){
				console.log(data.check);
				overlapCheck = data.check;
				if(mode == 'I') {
					if(data.check == 1) {
						$('#codeCheck').html('중복된 코드가 존재합니다. 다른 코드를 입력하세요!');
						$('#codeCheck').css({'color' : 'red'}, {'font-weight' : 'bold'});
					}
					else{
						$('#codeCheck').html('사용가능한 코드입니다.');
						$('#codeCheck').css({'color' : 'GREEN'}, {'font-weight' : 'bold'});
					}
				}
				else if(mode == 'U') {
					if(data.check == 1) {
						$('#codeCheck').html('중복된 코드가 존재합니다. 다른 코드를 입력하세요!');
						$('#codeCheck').css({'color' : 'red'}, {'font-weight' : 'bold'});
					}
					else{
						$('#codeCheck').html('사용가능한 코드입니다.');
						$('#codeCheck').css({'color' : 'GREEN'}, {'font-weight' : 'bold'});
					}
				}
			},
			error : function(e) {
				alert_popup('오류 상황 : ' + e);
			},
			complete : function() {
				
			}
		})
	}
	
	//권한등록 버튼 기능 추가  2020/04/21 - 추정완
	function fncAuthInsert() {
		var codeNm = $('#codeNm').val();
		var authNm = $('#authNm').val();
		var authCmmt = $('#authCmmt').val();
		var useCheck = $("input[name='useCheck']:checked").val();
		var authCheck = $("input[name='authCheck']:checked").val();
		console.log(codeNm + " : " + authNm + " : " + authCmmt + " : " + useCheck);
		
		if(!isBlank('코드명', '#codeNm'))
		if(!isBlank('권한명', '#authNm'))
		if(!isBlank('권한설명', '#authCmmt'))
			if(overlapCheck == 0) {
				$.ajax({
					type : 'POST',
					url : '/admin/authOption.do?mode=I',
					dataType : 'json',
					data : {
						codenm : codeNm,
						authnm : authNm,
						authcmmt : authCmmt,
						usecheck : useCheck,
						authcheck : authCheck
					},
					traditional : true,
					success: function(){
						alert_popup('정상 등록 되었습니다.');
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
			else {
				alert_popup('중복된 코드가 있습니다. 다른 코드로 작성해주세요!');
			}		
	}
	//권한수정 버튼 기능 추가 2020/04/21 - 추정완
	function fncAuthUpdate() {
		var code = '${authInfo.commcd}';
		var codeGcd = '${authInfo.commcd_gcd}';
		var codeNm = $('#codeNm').val();
		var authNm = $('#authNm').val();
		var authCmmt = $('#authCmmt').val();
		var useCheck = $("input[name='useCheck']:checked").val();
		var authCheck = $("input[name='authCheck']:checked").val();
		console.log(codeNm + " : " + authNm + " : " + authCmmt + " : " + useCheck);
		if(!isBlank('코드명', '#codeNm'))
		if(!isBlank('권한명', '#authNm'))
		if(!isBlank('권한설명', '#authCmmt'))
			if(overlapCheck == 0) {
				$.ajax({
					type : 'POST',
					url : '/admin/authOption.do?mode=U',
					dataType : 'json',
					data : {
						codenm : codeNm,
						authnm : authNm,
						authcmmt : authCmmt,
						usecheck : useCheck,
						authcheck : authCheck,
						c_commcd : code,
						c_commcd_gcd : codeGcd
					},
					traditional : true,
					success: function(){
						alert_popup('정상 수정 되었습니다.');

					},
					error : function(e) {
						alert_popup('오류 상황 : ' + e);
					},
					complete : function() {
						parent.fncList();
						parent.location.reload();
						parent.$('#dialog').dialog('close');
					}
				});
			}
			else {
				alert_popup('중복된 코드가 있습니다. 다른 코드로 작성해주세요!');
			}
	}
</script>
<div class="modal_pop_cont"> 
	<!-- 권한등록 및 수정-->
	<div class="table2 mTop5" id="divInsertUpdate">
		<table>
			<colgroup>
				<col style="width:30%"/><col style="width:70%"/>
			</colgroup>
			<tbody class="line">
				<tr>
					<th>코드명</th>
					<td class="left form-inline" >
						<c:choose>
							<c:when test="${mode == 'I'}">
								<input type="text" id="codeNm" size="40" onchange="fncCodeCheck('I')" maxlength="20" onkeyup="validateInputVal('en_num', this)" class="form-control"> 
							</c:when>
							<c:when test="${mode == 'U'}">
								<input type="text" id="codeNm" size="40" onchange="fncCodeCheck('U')" maxlength="20" onkeyup="validateInputVal('en_num', this)" class="form-control">
							</c:when>
						</c:choose>
						<div id="codeCheck"></div>
					</td>
				</tr>
				<tr>
					<th>권한명</th>
					<td class="left form-inline" ><input type="text" id="authNm" size="40" onkeyup="validateInputVal('ko_en_num', this)" class="form-control"></td>
				</tr>
				<tr>
					<th>권한설명</th>
					<td class="left form-inline" ><textarea cols="40" id="authCmmt" rows="5" class="form-control"></textarea></td>
				</tr>
				<tr>
					<th>사용여부</th>
					<td class="left form-inline" >
						<input type="radio" name="useCheck" value="Y" checked="checked"><label>사용</label>
						&nbsp&nbsp
						<input type="radio" name="useCheck" value="N"><label>미사용</label>
					</td>
				</tr>
				<tr>
					<th>권한여부</th>
					<td class="left form-inline" >
						<input type="radio" name="authCheck" value="Y" checked="checked"><label>사용</label>
						&nbsp&nbsp
						<input type="radio" name="authCheck" value="N"><label>미사용</label>
					</td>
				</tr>
			</tbody>
		</table>
		<c:choose>
			<c:when test="${mode == 'I'}">
				<!-- 권한등록 버튼 -->
				<div class="btnList alignRight mTop30">
					<button type="button" class="btn btn-primary btn-sm" id="btnAuthInsert">등록</button>
					<button type="button" class="btn btn-primary btn-sm" id="btnAuthCancel">닫기</button>
				</div>
			</c:when>
			<c:when test="${mode == 'U'}">
				<!-- 권한수정 버튼 -->
				<div class="btnList alignRight mTop30">
					<button type="button" class="btn btn-primary btn-sm" id="btnAuthUpdate">수정</button>
					<button type="button" class="btn btn-primary btn-sm" id="btnAuthCancel">닫기</button>
				</div>
			</c:when>
		</c:choose>

	</div>
</div>