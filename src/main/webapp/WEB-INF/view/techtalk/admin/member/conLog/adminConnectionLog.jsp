<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<script>
	$(document).ready(function(){	
		
		initDatePicker([$('#strDate'), $('#endDate')]);
		
		$("#list").jqGrid({
			url : "/admin/listConnLog.do", 
			mtype : "POST",
			datatype : 'json',
			postData: {
				siteId:$('#siteid').val()
			},
			colNames : [
						'',
						'접속일시',
						'접속 구분',
						'접속 유형',
						'접속 상태',
						'사용자',
						'사용자 IP 주소',
						'비고'
			],
			colModel : [
						{name:'connlog_seq', 		index:'connlog_seq',	align:"center",			hidden: true},
						{name:'condtm', 			index:'condtm', 		align:"center"},
						{name:'conn_pcd', 			index:'conn_pcd', 		align:"center"},
						{name:'conn_tcd', 			index:'conn_tcd', 		align:"center"},
						{name:'conn_scd', 			index:'conn_scd', 		align:"center"},
						{name:'userid', 			index:'userid',			align:"center"},		
						{name:'conn_ip', 			index:'conn_ip',		align:"center"},		
						{name:'note', 				index:'note',			align:"center"}		
			],
			pager: $('#pager'),
			rowNum:10,
			rowList:[10,20,30],
			jsonReader: {
				root : 'rows',
	            total : 'total',
	            page : 'page',
	           repeatitems : false
			},
			viewrecords: true,
			imgpath : '',
			caption : '',	
			autowidth: true,
			height : 'auto',
			shrinkToFit:true,
			multiboxonly : true,
			rownumbers : true,
			loadComplete: function(){	
	            $('#list').jqGrid( 'setGridWidth', $(".contents").width()-30 );
	            $(window).on('resize.jqGrid', function () {
	               $('#list').jqGrid( 'setGridWidth', $(".contents").width()-30 );
	            });  
			}//END loadComplete1
		});	// jqgrid 끝
		
		// 검색 버튼	
		$('#btnSearch').click(function(event) {
			event.preventDefault();
			fncSearch();
		});
		
	});//jquery
	
	function fncList(){
		$('#list').trigger('reloadGrid');
	};
	function fncSearch() {
		var startDate = $('#strDate').val();
		var endDate = $('#endDate').val();
		var connState = $('#connState').val();
		var userId = $('#userId').val();
		$('#list').setGridParam({datatype : 'json',
			postData : {
				startdate : startDate,
				enddate : endDate,
				connectionstate : connState,
				userid : userId
			},		
		});
		$('#list').setGridParam({
			page : 1
		});
		fncList();
	}

</script>

<div class="contents">
	<div class="content_wrap">
		<!-- contents -->
		<div class="well searchDetail">
		   	<table class="table1" >
					<tr>
						<th>접속일자</th>
						<td class="form-inline">
							<input type="text" id="strDate" class="form-control">
							~
							<input type="text" id="endDate" class="form-control">
						</td>
						
						<th>접속상태</th>
						<td class="form-inline">
							<select id="connState" name="connState" class="form-control">
							<option value="">전체</option>
								<c:forEach var ="item" items="${ connLogCode }" >
									<option value="${item.commcd}">${item.cdnm}</option>
								</c:forEach>
							</select>
						</td>
						<th>사용자</th>
						<td class="form-inline">
							<input type="text" id="userId" name="userId" class="form-control">
						</td>
						<td>
							<button type="button" id= "btnSearch" class="btn btn-primary btn-sm" >검색</button>
						</td>	
					</tr>
			</table>
		</div>
		<!-- jqGrid -->
		<div id="gridWrapper" class="mTop30">
			<table id="list" class="scroll" cellpadding="0" cellspacing="0"></table>
			<div id="pager" class="scroll"></div>
		</div>
	</div>
</div>