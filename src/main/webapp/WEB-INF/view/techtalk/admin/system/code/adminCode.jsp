<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<script>
	var subGridTableId = '';
	var subGridPagerId = '';

	$(document).ready(function(){
		var useAuth = ${use_auth};
		checkUseAuth(useAuth, [$('#btnMainInsert')], [$('#btnMainUpdate')], [$('#btnMainDelete')]);
		$('#list').jqGrid({
			url : '/admin/listMainCode.do', 
			mtype : 'POST',
			datatype : 'json',
			postData:{
				siteId:$('#siteId').val()
			},
			colNames : [
						'메인코드',
						'메인그룹코드',
						'메인코드',
						'코드구분',
						'사용여부',
						'등록일자',
						'수정일자',
						'서브코드'
			],
			colModel : [
						{name:'commcd',				index:'commcd',			align:'center'},
						{name:'commcd_gcd',			index:'commcd_gcd',		align:'center'},
						{name:'cdnm',				index:'cdnm',			align:'center'},
						{name:'commcd_pcd',			index:'commcd_pcd',		align:'center'},
						{name:'useyn',				index:'useyn',			align:'center'},
						{name:'regdtm',				index:'regdtm',			align:'center'},
						{name:'moddtm',				index:'moddtm',			align:'center'},
						{name:'button',				index:'button',			align:'center'}
			],
			pager: $('#pager'),
			rowNum: 10,
			rowList:[10, 20, 30],
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
			height: 'auto',
			shrinkToFit:true,
			multiboxonly : true,
			onSelectRow : function(rowid, status, e){
			},
			loadComplete: function(){
				var ids = $('#list').getDataIDs();
				for (var i = 0; i < ids.length; i++) {
	                
                    var rowData = $('#list').getRowData(ids[i]);
                    var cl = ids[i];
                    var commcdPcd = '';
                    if(rowData.commcd_pcd == 'Z') {
                    	commcdPcd = '시스템코드';
                    }
                    else if(rowData.commcd_pcd == 'P') {
                    	commcdPcd = '구분코드'
                    }
                    else if(rowData.commcd_pcd == 'T') {
                    	commcdPcd = '유형코드'
                    }
                    else if(rowData.commcd_pcd == 'S') {
                    	commcdPcd = '상태코드'
                    }
                    else if(rowData.commcd_pcd == 'D') {
                    	commcdPcd = '사용자정의코드'
                    }
                    else if(rowData.commcd_pcd == 'N') {
                    	commcdPcd = '단위코드'
                    }
                    else if(rowData.commcd_pcd == 'I') {
                    	commcdPcd = '순위코드'
                    }
                    else if(rowData.commcd_pcd == '-') {
                    	commcdPcd = '기타코드'
                    }
                    var btnModifyCode = "<button type='button' name="+ 'subI' + i + " class='btn btn-default btn-sm non-display' onclick=" + 'fncSubCodeInsertView("' + rowData.commcd + '","' + rowData.commcd_gcd + '","' + rowData.commcd_pcd + '")' + ">등록</button>";
                    $('#list').setRowData(cl, {
                        button : btnModifyCode,
                        commcd_pcd : commcdPcd
                    });
                    checkUseAuth(useAuth, [$('button[name="subI' + i + '"]')], null, null);
                }; //END for()
				
                $('#list').jqGrid( 'setGridWidth', $(".contents").width()-30 );
                $(window).on('resize.jqGrid', function () {
                   $('#list').jqGrid( 'setGridWidth', $(".contents").width()-30 );
                });
                
                
            }, //END loadComplete1
            // 서브
			subGrid: true,
			subGridRowExpanded:function(subgrid_id, row_id) {
				console.log(row_id, subgrid_id);
				var rowData = $('#list').getRowData(row_id);
				var commcdGcd = rowData.commcd_gcd;
				var subHtml = '';
				subGridTableId = subgrid_id + "T";
				subGridPagerId = subgrid_id + "P";
				console.log(subGridTableId, subGridPagerId);
				subHtml = "<table id='" + subGridTableId + "' class='scroll'></table><div id='" + subGridPagerId + "' class='scroll'></div>";
				$('#' + subgrid_id).html(subHtml);
				
				$('#' + subGridTableId).jqGrid({
					url : '/admin/listSubCode.do', 
					mtype : 'POST',
					datatype : 'json',
					postData:{
						siteId:$('#siteId').val(),
						commcd_gcd: commcdGcd
					},
					colNames : [
								'서브코드',
								'서브그룹코드',
								'서브코드',
								'코드 구분',
								'사용여부',
								'등록일자',
								'수정일자',
								'버튼'
					],
					colModel : [
								{name:'commcd',				index:'commcd',			align:'center'},
								{name:'commcd_gcd',			index:'commcd_gcd',		align:'center'},
								{name:'cdnm',				index:'cdnm',			align:'center'},
								{name:'commcd_pcd',			index:'commcd_pcd',		align:'center'},
								{name:'useyn',				index:'useyn',			align:'center'},
								{name:'regdtm',				index:'regdtm',			align:'center'},
								{name:'moddtm',				index:'moddtm',			align:'center'},
								{name:'button',				index:'button',			align:'center'}
					],
					pager: $('#' + subGridPagerId),
					rowNum: 10,
					rowList:[10, 20, 30],
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
					height: 'auto',
					shrinkToFit:true,
					multiboxonly : true,
					onSelectRow : function(rowid, status, e){
					},
					loadComplete: function(){
						var ids = $('#' + subGridTableId).getDataIDs();
						for(var i = 0; i < ids.length; i++) {
							var rowData = $('#' + subGridTableId).getRowData(ids[i]);
							var commcdPcd = '';
		                    if(rowData.commcd_pcd == 'Z') {
		                    	commcdPcd = '시스템코드';
		                    }
		                    else if(rowData.commcd_pcd == 'P') {
		                    	commcdPcd = '구분코드'
		                    }
		                    else if(rowData.commcd_pcd == 'T') {
		                    	commcdPcd = '유형코드'
		                    }
		                    else if(rowData.commcd_pcd == 'S') {
		                    	commcdPcd = '상태코드'
		                    }
		                    else if(rowData.commcd_pcd == 'D') {
		                    	commcdPcd = '사용자정의코드'
		                    }
		                    else if(rowData.commcd_pcd == 'N') {
		                    	commcdPcd = '단위코드'
		                    }
		                    else if(rowData.commcd_pcd == 'I') {
		                    	commcdPcd = '순위코드'
		                    }
		                    else if(rowData.commcd_pcd == '-') {
		                    	commcdPcd = '기타코드'
		                    }
							var cl = ids[i];
							var buttonModify = "<button name="+ 'subU' + i + " class='btn btn-default btn-sm non-display' onclick=" + 'fncSubCodeUpdateView("' + rowData.commcd + '","' + rowData.commcd_gcd + '")' + ">수정</button><button name=" + 'subD' + i + " class='btn btn-default btn-sm non-display' onclick=" + 'fncSubCodeDeleteView("' + rowData.commcd + '","' + rowData.commcd_gcd + '")' + ">삭제</button>";
							$('#' + subGridTableId).setRowData(cl, {
								commcd_pcd : commcdPcd,
								button : buttonModify
							});
							checkUseAuth(useAuth, null, [$('button[name="subU' + i + '"]')], [$('button[name="subD' + i + '"]')]);
						}
		            } //END loadComplete1
				})
			}
		});	// jqgrid 끝
		
		//검색 버튼 기능 추가 2020/04/30 - 추정완
		$('#btnSearch').click(function() {
			fncSearch();
		});
		//메인코드 등록 버튼 기능 추가 2020/04/28 - 추정완
		$('#btnMainInsert').click(function() {
			fncMainCodeInsertView();
		});
		//메인코드 수정 버튼 기능 추가 2020/04/28 - 추정완
		$('#btnMainUpdate').click(function() {
			fncMainCodeUpdateView();
		});
		//메인코드 삭제 버튼 기능 추가 2020/05/01 - 추정완
		$('#btnMainDelete').click(function() {
			fncMainCodeDeleteView();
		});
	});	
	//jqGrid reload 함수 2020/03/25 - 추정완
	function fncList() {
		$("#list").trigger('reloadGrid');
	};
	
	function fncSubList() {
		$("#" + subGridTableId).trigger('reloadGrid');
	};
	
	//jqGrid 셀 선택여부 추가 2020/03/25 - 추정완
    function fncGetSelectedRowData() {
        var selRowId = $('#list').getGridParam('selrow');
        var rowData;
        if(selRowId != null) {
        	rowData = $('#list').getRowData(selRowId);
        }
        else{
        	rowData = null;
        }
        return rowData;
    };
    
    //검색 버튼 기능 추가 2020/04/30 - 추정완
    function fncSearch() {
  	
    	$('#list').setGridParam({datatype : 'json',
            postData : {
            	search_pcd : $('#searchPCD').val(),
            	search_con : $('#searchCON').val(),
            	search_text : $('#searchTEXT').val()
            },    
        });
    	$("#list").setGridParam({
			page : 1
		});
    	fncList();
    }
    
	//메인코드 등록 팝업 추가 2020/04/28 - 추정완
	function fncMainCodeInsertView() {
		var url = '/admin/formCode.do?mode=MI';
    	openDialog({
            title:"메인코드등록",
            width:520,
            height:350,
            url: url
     	});
	}
	//메인코드 수정 팝업 추가 2020/04/28 - 추정완
	function fncMainCodeUpdateView() {
		var updateDataM = fncGetSelectedRowData();
		if(updateDataM != null) {
			var url = '/admin/formCode.do?mode=MU&c_commcd=' + updateDataM.commcd + '&c_commcd_gcd=' + updateDataM.commcd_gcd;
	    	openDialog({
	            title:"메인코드수정",
	            width:520,
	            height:350,
	            url: url
	     	});
		}
		else{
			alert_popup('수정하고 싶은 메인코드를 선택해주세요!');
		}

	}
	//메인코드 삭제 팝업 추가 2020/05/01 - 추정완
	function fncMainCodeDeleteView() {
		var deleteDataM = fncGetSelectedRowData();
		if(deleteDataM != null) {
			var deleteConfirm = confirm('사용중인 코드가 존재할 수 있습니다. 그래도 삭제 하시겠습니까?');
			if(deleteConfirm) {
				$.ajax({
					type : 'POST',
					url : '/admin/deleteCode.do',
					data : {
						type : 'mainCode',
						c_commcd : deleteDataM.commcd,
						c_commcd_gcd : deleteDataM.commcd_gcd
					},
					dataType : 'json',
					traditional : true,
					success: function(){
						alert_popup('정상 삭제처리 되었습니다.');
					},
					error : function(e) {

					},
					complete : function() {
						fncList();
					}
				});
			}
			else{
				alert_popup('취소 되었습니다.');
			}
		}
		else{
			alert_popup('삭제하고 싶은 메인코드를 선택해주세요!');
		}
	}
	//서브코드 등록 팝업 추가 2020/04/28 - 추정완
	function fncSubCodeInsertView(c_commcd, c_commcd_gcd, c_commcd_pcd) {
		var url = '/admin/formCode.do?mode=SI&' + 'c_commcd_gcd=' + c_commcd_gcd + '&c_commcd=' + c_commcd + '&c_commcd_pcd=' + c_commcd_pcd;
    	openDialog({
            title:"서브코드등록",
            width:520,
            height:500,
            url: url
     	});
	}
	//서브코드 수정 팝업 추가 2020/04/30 - 추정완
	function fncSubCodeUpdateView(commcd, commcd_gcd) {
		var url = '/admin/formCode.do?mode=SU&' + 'commcd=' + commcd + '&commcd_gcd=' + commcd_gcd;
    	openDialog({
            title:"서브코드수정",
            width:520,
            height:350,
            url: url
     	});
	}
	//서브코드 삭제 팝업 추가 2020/05/01 - 추정완
	function fncSubCodeDeleteView(commcd, commcd_gcd) {
		var deleteConfirm = confirm('사용중인 코드가 존재할 수 있습니다. 그래도 삭제 하시겠습니까?');
		if(deleteConfirm) {
			$.ajax({
				type : 'POST',
				url : '/admin/deleteCode.do',
				data : {
					type : 'subCode',
					commcd : commcd,
					commcd_gcd : commcd_gcd
				},
				dataType : 'json',
				traditional : true,
				success: function(){
					alert_popup('정상 삭제처리 되었습니다.');
				},
				error : function(e) {

				},
				complete : function() {
					fncSubList();
				}
			});
		}
		else{
			alert_popup('취소 되었습니다.');
		}
	}
</script>
<div class="contents">
  <div class="content_wrap">
    <!-- contents -->
    <!-- 검색영역  -->	
   	<div class="well searchDetail">
   		<table class="table1">
   			<colgroup><col width="5%"/><col width="15%"/><col width="5%"/><col width="60%"/><col width="1%"/></colgroup>
   			<tr>
   				<th>코드 구분</th>
   				<td class="form-inline">
   					<select class="form-control" id="searchPCD">
   						<option value="">전체</option>
   						<c:forEach items="${commcd_pcd}" var="list">
   							<option value="${list.commcd}">${list.cdnm}</option>
   						</c:forEach>
   					</select>
   				</td>
   				<th>검색조건</th>
   				<td class="form-inline">
   					<select class="form-control" id="searchCON">
   						<option value="all">전체</option>
   						<option value="commcd">코드</option>
   						<option value="cdnm">코드명</option>
   					</select>
   					<input type="text" id="searchTEXT" class="form-control" size="20" placeholder="검색어를 입력하세요.">
   				</td>
   				<td>
   					<button class="btn btn-primary btn-sm" id="btnSearch">검색</button>
   				</td>
   			<tr>
   		</table>
   	</div>
   	
   	<!-- 버튼 -->
   	<div class="btnList alignRight mTop15">
   		<button id="btnMainInsert" class="btn btn-primary btn-sm non-display">메인코드등록</button>
   		<button id="btnMainUpdate" class="btn btn-primary btn-sm non-display">메인코드수정</button>
   		<button id="btnMainDelete" class="btn btn-primary btn-sm non-display">메인코드삭제</button>
   	</div>
   	
    <!-- jqGrid -->
    <div id="gridWrapper" class="mTop15">
		<table id="list" class="scroll" cellpadding="0" cellspacing="0"></table> 
		<div id="pager" class="scroll" style="text-align:center;"></div> 
	</div>
   </div>
</div>