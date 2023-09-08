<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<script>
	$(document).ready(function(){
		$('#divLookUp').css('display', 'none');
		$('#divUpdate').css('display', 'none');
		var mode = '${mode}';
		var userno = '${userno}';
		if(mode == 'L') {
			$('#divLookUp').css('display', 'block');
		}
		else if(mode == 'U') {
			$('#divUpdate').css('display', 'block');
			$.ajax({
				url : '/admin/listMemberAuth.do',
				type : 'POST',
				dataType : 'json',
				data : {
					userno : userno
				},
				success : function(transport) {
					// 사용자 권한 체크
					var memberAuth = transport.memberAuthList;
					var listAuth = [];
					for(var i = 0; i < memberAuth.length; i++) {
						if(memberAuth[i].useyn == 'Y') {
							listAuth.push(memberAuth[i].role_pcd);
						}
					}
					var checkBox = $("input[class='kindsListCheck']");
					for(var i = 0; i < checkBox.length; i++) {
						for(var j = 0; j < listAuth.length; j++) {
							if(checkBox[i].value == listAuth[j]) {
								checkBox[i].checked = true;
							}
						}
					}
				},
				error : function() {
					
				}
			});
		}
		$('#btnAuthUpdate').click(function() {
			fncAuthUpdate(userno);
		});
		$('#btnAuthCancle').click(function() {
			parent.$('#dialog').dialog('close');
		})
	});
	// 권한 수정 2020/04/14 - 추정완
	function fncAuthUpdate(userno) {
		console.log("userno : " + userno);
		var authCheck = $("input[class='kindsListCheck']");
		var authCode = [];
		for(var i = 0; i < authCheck.length; i++) {
			if(authCheck[i].checked) {
				authCode.push(authCheck[i].value);
			}
		}
		if(authCode.length != 0) {
			$.ajax({
		        type:'POST',
		        url:'/admin/updateMemberAuth.do',
		        dataType : 'json',
		        data : {
		        	userno : userno,
		        	authCode : authCode
		        },
		        traditional : true,
		        success: function(){
		        	alert_popup('수정성공!');
		        },
		        error: function(e) {
		        	alert_popup('오류 : ' + e);
		        },
		        complete: function() {
		        	parent.$('#dialog').dialog('close');
		        }
		    });	
		}
		else {
			alert_popup('권한이 1개 이상 선택되어야 합니다.');
		}
	};
</script>
<div class="modal_pop_cont"> 
		<div class="titWrap clearFix">
			<p class="tit_name">이름 : ${userInfo.usernm}</p>
		</div>
	<div class="table2 mTop5" id="divLookUp">
		
		<!-- 권한조회 -->
		<table>
			<colgroup>
				<col style="width:10%" />
				<col />
			</colgroup>
			<tbody class="line">
				<!-- 타이틀 -->
				<tr>
					<th>순번</th>
					<th>코드</th>
					<th>이름</th>
					<th>등록날짜</th>
					<th>수정날짜</th>
				</tr>
				<c:forEach items="${authLookUpList}" var="list">
					<tr>
						<td>${list.rownum}</td>
						<td>${list.role_pcd}</td>
						<td>${list.cdnm}</td>
						<td>${list.insertdt}</td>
						<td>${list.updatedt}</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
	</div>
	<div class="table2 mTop5" id="divUpdate">
		<!-- 권한수정 -->
		<table>
			<colgroup>
				<col style="width:10%" />
				<col />
			</colgroup>
			<tbody class="line">
				<!-- 권한 리스트 -->
				<tr>
					<th>권한</th>
					<td class="left form-inline">
						<c:forEach items="${authKindsList}" var="kindList">
							<label class="spanBox">
							<c:choose>
								<c:when test="${kindList.useyn eq 'Y'}">
									<input type="checkbox" id="${kindList.commcd}" name="${kindList.commcd}" class="kindsListCheck" value="${kindList.commcd}">
								</c:when>
								<c:when test="${kindList.useyn eq 'N'}">
									<input type="checkbox" id="${kindList.commcd}" name="${kindList.commcd}" class="kindsListCheck" value="${kindList.commcd}" disabled="disabled">
								</c:when>
							</c:choose>				
							${kindList.cdnm}
							</label>
						</c:forEach>
					</td>
				</tr>
			</tbody>
		</table>
		<!-- 버튼 -->
		<div class="btnList alignRight mTop30">
			<button type="button" class="btn btn-primary btn-sm" id="btnAuthUpdate">저장</button>
			<button type="button" class="btn btn-primary btn-sm" id="btnAuthCancle">닫기</button>
		</div>
	</div>
</div>