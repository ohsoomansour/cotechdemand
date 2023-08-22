<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<script>
	$(document).ready(function(){
		
		initDatePicker([$('#strDate'), $('#endDate')]);
		
		$("#list").jqGrid({
			url : '/admin/listMember.do', 
			mtype : 'POST',
			datatype : 'json',
			postData:{
				siteId:$('#siteId').val()
				},
			colNames : [
						"",
						"아이디",
						"이름",
						"학번",
						"성별",
						"나이",
						"주소",
						"이메일",
						"전화번호",
						"가입일자",
						"권한"
						
			],
			colModel : [
						{name:'userno', 			index:'userno',			width:15,			align:'center',			hidden: true},
						{name:'userid', 			index:'userid',			width:20,			align:'center'},						
						{name:'usernm', 			index:'usernm',			width:20,			align:'center'},
						{name:'stdno', 				index:'stdno',			width:30,			align:'center'},
						{name:'gender', 			index:'gender',			width:15,			align:'center'},
						{name:'age', 				index:'age',			width:15,			align:'center'},
						{name:'addr', 				index:'addr',			width:80,			align:'center'},
						{name:'email', 				index:'email',			width:40,			align:'center'},
						{name:'mphone', 			index:'mphone',			width:40,			align:'center'},
						{name:'regdtm', 			index:'regdtm',			width:40,			align:'center'},
						{name:'button', 			index:'button',			width:40,			align:'center'}
						
			],
			pager: $('#pager'),
			rowNum:10,
			rowList:[10, 20, 30],
			jsonReader: {
				root : 'rows',
	            total : 'total',
	            page : 'page',
	            repeatitems : false
			},
			viewrecords: true,
			imgpath : "",
			caption : "",
			autowidth: true,
			height: 'auto',
			//loadonce: true,
			multiselect: true,
			shrinkToFit: true,
			multiboxonly : true,
			loadComplete: function(){
				var ids = $('#list').getDataIDs();
                var linkId = '';
                var useYn = '';
                for (var i = 0; i < ids.length; i++) {
                
                    var rowData = $('#list').getRowData(ids[i]);
                    console.log(rowData);
                    var cl = ids[i];
                    
                    var btnModifyAuth = "<button class='btn btn-default btn-sm' onclick=" + 'fncAuthView("L","' + rowData.userno + '","권한조회")' + ">조회</button><button class='btn btn-default btn-sm' onclick=" + 'fncAuthView("U","' + rowData.userno + '","권한수정")' + ">수정</button>";
                    $('#list').setRowData(cl, {
                        button : btnModifyAuth
                    });
                }; //END for()
                $('#list').jqGrid( 'setGridWidth', $(".contents").width()-30 );
                $(window).on('resize.jqGrid', function () {
                   $('#list').jqGrid( 'setGridWidth', $(".contents").width()-30 );
                });
            } //END loadComplete1
		});	// jqgrid 끝
				
		// 전체 SMS 버튼 2020/03/23 - 추정완
		$('#btnSendSmsAll').click(function(event) {
 			event.preventDefault();
		});
		
		// SMS발송 버튼 2020/03/23 - 추정완
		$('#btnSendSms').click(function(event) {
 			event.preventDefault();
		});
		
		// 검색 버튼 2020/03/20 - 추정완
		$('#btnSearch').click(function(event) {
			event.preventDefault();
			fncList();
		});
		// 포인트 지급 버튼	2020/04/29 - 박인정
		$('#btnUpdatePoint').click(function(event) {
			event.preventDefault();
			fncUpdatePoint();
		});
	});	//jquery 종료
	
	// 조회 - 2020/03/20 추정완
	function fncList() {

        $('#list').setGridParam({datatype : 'json',
            postData : {
            	division_type : $("#divisionType").val(),
            	division_value : $("#divisionValue").val(),       	
            	gender_value : $('#gender option:selected').val(),
            	student_state : $("#studentState").val(),
            	strdate : $("#strDate").val().replace(/-/gi, ""),
            	enddate : $("#endDate").val().replace(/-/gi, ""),
            	strage : $("#strAge").val(),
            	endage : $("#endAge").val(),
            	major : $('#major').val()
            },    
        });
    	$('#list').setGridParam({
			page : 1
		});
		$('#list').trigger('reloadGrid');
	}
	
    // 권한  조회 및 수정 팝업 추가 2020/07/06 - 추정완
    function fncAuthView(mode, userno, title) {
    	var url = '/admin/movePopMemberAuth.do?mode=' + mode + '&userno=' + userno;
    	openDialog({
            title:title,
            width:800,
            height:600,
            url: url
     	}); 
    }
	
</script>

<div class="contents">
  <div class="content_wrap">
    <!-- contents -->
   	<!-- 검색영역  -->	
   	<div class="well searchDetail">
   		<table class="table1" >
			<colgroup><col width="7%"/><col width="43%"/><col width="7%"/><col width="43%"/></colgroup>
			<tr>
				<th>구분</th>
				<td class="form-inline">
					<select id="divisionType" name="divisionType" class="form-control">
						<option value="all">전체</option>
						<option value="userId">아이디</option>
						<option value="userNm">이름</option>
						<option value="mPhone">전화번호</option>
					</select>
					<input type="text" id="divisionValue" name="divisionValue" class="form-control w300">
				</td>
			</tr>
			<tr>
				<th>성별</th>
				<td class="form-inline">
					<select id="gender" class="form-control">
						<option value="">전체</option>
						<c:forEach items="${genderList}" var="gender">
							<option value="${gender.commcd}">${gender.cdnm}</option>
						</c:forEach>
					</select>
				</td>
			</tr>
			<tr>
				<th>가입일자</th>
				<td class="form-inline">
					<input type="text" id="strDate" name="strDate" class="form-control">
					~
					<input type="text" id="endDate" name="endDate" class="form-control">
				</td>
			</tr>
			<tr>
				<th>연령대</th>
				<td class="form-inline">
					<input type="text" id="strAge" name="strAge" class="form-control w80" onkeyup="validateInputVal('num', this)">
					~
					<input type="text" id="endAge" name="endAge" class="form-control w80" onkeyup="validateInputVal('num', this)">
				<td>
			</tr>
		</table> 
		<div class="btnWrap alignRight mTop10">
			<button type="button" id= "btnSearch" name="btnSearch" class="btn btn-primary btn-sm" >검색</button>
		</div>
   	</div>

    <!-- jqGrid -->
    <div id="gridWrapper" class="mTop20">
		<table id="list" class="scroll"></table> 
		<div id="pager" class="scroll"></div> 
	</div>
	
	<!-- 버튼 -->
<!-- 	 <div class="btnList alignRight clearFix mTop20">
		<button type="button" id="btnRequestExcel" class="btn btn-primary btn-sm">엑셀 다운로드</button>
		<button type="button" id="btnSendSmsAll" class="btn btn-primary btn-sm">전체 SMS</button>
		<button type="button" id="btnSendSms" class="btn btn-primary btn-sm">SMS발송</button>
	</div> -->
  </div>
</div>
