<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<script>
	$(document).ready(function(){
		$("#list").jqGrid({
			url : "/admin/listBanner.do", 
			mtype : "POST",
			datatype : 'json',
			postData:{
				},
			colNames : [
						'',
						'순번',
						'배너명',
						'이미지',
						'사용여부',
						'시작일',
						'마감일',
						'등록자',
						'수정자',
						'등록일',
						'수정일'
			],
			colModel : [
						{name:'banner_seq', 		index:'banner_seq',		align:"center",			hidden: true},
						{name:'banner_idx', 		index:'banner_idx',		align:"center",			width: 50},
						{name:'banner_title', 		index:'banner_title',	align:"center"},
						{name:'banner_img', 		index:'banner_img',		align:"center",			hidden: true},
						{name:'useyn', 				index:'useyn',			align:"center",			width: 70},
						{name:'banner_sday', 		index:'banner_sday',	align:"center"},
						{name:'banner_eday', 		index:'banner_eday',	align:"center"},
						{name:'reguid', 			index:'reguid',			align:"center"},
						{name:'moduid', 			index:'moduid',			align:"center"},
						{name:'regdtm', 			index:'regdtm',			align:"center"},
						{name:'moddtm', 			index:'moddtm',			align:"center"}
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
			height: 'auto',
			shrinkToFit:true,
			multiboxonly : true,			
			loadComplete: function(){	
				var ids = $('#list').getDataIDs();
				var bannerIdx = '';
                for (var i = 0; i < ids.length; i++) {
                
                    var rowData = $('#list').getRowData(ids[i]);
                    var cl = ids[i];
                    
                    var bannerIdxs = new Array();
                    bannerIdxs[rowData.banner_idx] = 'selected';
                    
                    if(rowData.useyn == 'Y'){
                    	console.log(rowData.useyn);
	                	bannerIdx = "<select id='"+rowData.banner_seq+"' name='"+rowData.banner_seq+"' onchange='fncUpdateBannerIdx(this.id, this.value, \""+rowData.banner_idx+"\")'>"
	                    +"<option value='' "+bannerIdxs[0]+">-</option>"
	           			+"<option value='1' "+bannerIdxs[1]+">1</option>"
	           			+"<option value='2' "+bannerIdxs[2]+">2</option>"
	           			+"<option value='3' "+bannerIdxs[3]+">3</option>"
	           			+"<option value='4' "+bannerIdxs[4]+">4</option>"
	           			+"<option value='5' "+bannerIdxs[5]+">5</option>"
	           			+"</select>"
	           			
	           			 $("#list").setRowData(cl, {banner_idx : bannerIdx});
                    }
                    	
                   				
                }; //END for()
                	

	            $('#list').jqGrid( 'setGridWidth', $(".contents").width()-30 );
	            $(window).on('resize.jqGrid', function () {
	               $('#list').jqGrid( 'setGridWidth', $(".contents").width()-30 );
	            });  
			}//END loadComplete1
		});	// jqgrid 끝


		$('#btnModifyBanner').click(function(){
			var rowData =fncGetSelectedRowData();
			fncModifyBanner(rowData);
		});
		$('#btnDeleteBanner').click(function(){
			var rowData =fncGetSelectedRowData();
			fncDeleteBanner(rowData);
		});		
		$('#btnInsertBanner').click(function(){
			fncInsertBanner();
		});
	
	});//jquery

	
	// jqGrid 셀 선택여부 추가 
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
	
	//배너 수정 팝업 2020/05/12 
	function fncModifyBanner(rowData){

		if(rowData ==null){
			alert_popup('수정할 배너 선택 후 수정 버튼을 눌러주세요');
		}
		else{
			var url='/admin/updateBannerForm.do?banner_seq=' + rowData.banner_seq;
			openDialog({
		        title:"배너 수정",
		        width:1000,
		        height:600,
		        url: url
	     	});
		}	
	}
	
	//배너 등록 팝업 2020/05/12 - 박인정
	function fncInsertBanner(){
		var url = '/admin/insertBannerForm.do'
			openDialog({
		        title:"배너 등록",
		        width:1000,
		        height:600,
		        url: url
		     });
	}
	
	//검색
	function fncList(){
		$('#list').trigger('reloadGrid');
	};
	function fncSearch() {
		var useYn = $('#useYn').val();
		var bannerTitle = $('#bannerTitle').val();
		$('#list').setGridParam({datatype : 'json',
			postData : {
				useyn : useYn,
				bannertitle : bannerTitle
			},		
		});
		$('#list').setGridParam({
			page : 1
		});
		fncList();
	}
	
	//배너삭제 
	function fncDeleteBanner(rowData){
		if(rowData == null){
			alert_popup('삭제할 배너를 선택후 삭제버튼을 눌러주세요!')
		}else{
			var confrm = confirm("배너를 삭제하시겠습니까?");
	        if (confrm) {
		        $.ajax({
		            url: '/admin/deleteBanner.do',
		            type: 'post',
		            data: {
		            	banner_seq : rowData.banner_seq,
		            	banner_img : rowData.banner_img
		            },
		            dataType: 'json',
		            success: function(transport){
		            	$('#list').trigger('reloadGrid');
		        	},
		            error: function(){
		            }
		        });
	        }
			$('#list').setGridParam({
				page : 1
			});
			fncList();
		}
	}
	
	//배너 순번 변경
	function fncUpdateBannerIdx(banner_seq,banner_idx){
    	$.ajax({
			url: '/admin/checkBanner.do',
			type: 'post',
			data: {
            	banner_seq : banner_seq,
            	banner_idx : banner_idx
            },
			dataType: 'json',
			success: function(result){
				var data = result.check;
				if(parseInt(data) > 0) {		
					alert_popup("해당순번이 존재합니다");	
					location.reload();
				}else {			// 배너의 해당 순번이 없을때만 저장
					$.ajax({
			            url: '/admin/updateBannerIdx.do',
			            type: 'post',
			            data: {
			            	banner_seq : banner_seq,
			            	banner_idx : banner_idx
			            },
			            dataType: 'json',
			            success: function(transport){
			            	$('#list').trigger('reloadGrid');
			            },
			            error: function(){
			            }
			        });
				}
			}
		});
    }
</script>

<div class="contents">
	<div class="content_wrap">
	<!-- contents -->
	<div class="well searchDetail ">
		<table class="table1" >
			<colgroup>
				<col style="width:100px">
				<col>
				<col style="width:100px">
				<col>
			</colgroup>
			<tr>							
				<th>사용여부</th>
				<td class="form-inline">
					<select id="useYn" name="useYn" class="form-control">
						<option value="">전체</option>
						<option value="Y">사용</option>
						<option value="N">미사용</option>
					</select>
				<td>	
						
				<th>배너명</th>
				<td class="form-inline">
					<input type="text" id="bannerTitle" name="bannerTitle" class="form-control w300">	
				</td>
				<td class="form-inline">	
					<input type="button" id= "btnSearch" class="btn btn-primary btn-sm" value="검색" onclick="fncSearch();">					
				</td>
			</tr>
		</table>
	</div>
		<!-- 버튼 -->
		<div class="btnList alignRight mTop20">
			<button type="button" id="btnInsertBanner" class="btn btn-primary btn-sm">등록</button>
			<button type="button" id="btnModifyBanner" class="btn btn-primary btn-sm">수정</button>
			<button type="button" id="btnDeleteBanner" class="btn btn-primary btn-sm">삭제</button>
		</div>
		<!-- jqGrid -->
		<div id="gridWrapper" class="mTop20">
			<table id="list" class="scroll" cellpadding="0" cellspacing="0"></table>
			<div id="pager" class="scroll"></div>
		</div>
			
	</div>
</div>