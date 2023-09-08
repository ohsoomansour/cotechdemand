<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<script>
	$(document).ready(function(){
			
		var useAuth = ${use_auth};
		console.log(useAuth);
		checkUseAuth(useAuth, [$('#btnInsert')], [$('#btnUpdate')], [$('#btnDelete')]);
		
		//jstree 셋팅
		fncMenuTreeSetting();		
		//jqgrid 셋팅
		$('#list').jqGrid({
			url : '/admin/listAuth.do', 
			mtype : 'POST',
			datatype : 'json',
			postData:{
				siteId:$('#siteId').val()
				},
			colNames : [
						'그룹코드명',
						'코드명',
						'권한명',				
						'등록자',
						'등록일',
						'수정자',
						'수정일',
						'관리자 권한여부',
						'사용여부',
			],
			colModel : [
						{name:'commcd_gcd',			index:'commcd_gcd',		align:'center',		hidden : true},
						{name:'commcd',				index:'commcd',			align:'center'},
						{name:'cdnm',				index:'cdnm',			align:'center'},
						{name:'reguid',				index:'reguid',			align:'center'},
						{name:'regdtm',				index:'regdtm',			align:'center'},
						{name:'moduid',				index:'moduid',			align:'center'},
						{name:'moddtm',				index:'moddtm',			align:'center'},
						{name:'commcd_val1',		index:'commcd_val1',	align:'center'},
						{name:'useyn',				index:'useyn',			align:'center'},
											
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
			rownumbers : true,
			onSelectRow : function(rowid, status, e){
				//열 선택 시 jstree 체크박스 모두 해제
				var menuList = [];
				var checkBox = $("input[type='checkbox']");
				for(var i = 0; i < checkBox.length; i++) {
					checkBox[i].checked = false;
				}
				$('#menuTree1').find('li').each(function(index, item) {
					$("#" + item.id + "").attr('class', $("#" + item.id + "").attr('class').replace('jstree-undetermined', 'jstree-unchecked'));
					$("#" + item.id + "").attr('class', $("#" + item.id + "").attr('class').replace('jstree-checked', 'jstree-unchecked'));
					$("span[id='" + item.id + "']").css('display', 'none');
				});
				$('#menuTree2').find('li').each(function(index, item) {
					$("#" + item.id + "").attr('class', $("#" + item.id + "").attr('class').replace('jstree-undetermined', 'jstree-unchecked'));
					$("#" + item.id + "").attr('class', $("#" + item.id + "").attr('class').replace('jstree-checked', 'jstree-unchecked'));
					$("span[id='" + item.id + "']").css('display', 'none');
				});
				//열 데이터 가져오기
				var rowData = $('#list').getRowData(rowid);
				//열 데이터를 이용한 권한 선택 데이터
				fncMenuTreeSelect(rowData);
			},
			loadComplete: function(){
                $('#list').jqGrid( 'setGridWidth', $(".contents").width()-30 );
                $(window).on('resize.jqGrid', function () {
                   $('#list').jqGrid( 'setGridWidth', $(".contents").width()-30 );
                });
            } //END loadComplete1
		});	// jqgrid 끝
		// 등록버튼 추가 2020/04/21
		$('#btnInsert').click(function() {
			var mode = 'I';
			fncAuthInsert(mode);
		});
		// 수정버튼 구차 2020/04/24
		$('#btnUpdate').click(function() {
			var mode = 'U';
			fncAuthUpdate(mode);
		})
		// 삭제버튼 추가 2020/04/21
		$('#btnDelete').click(function() {
			var mode = 'D';
			fncAuthDelete(mode);
		});
		// 메뉴저장 기능 추가 2020/04/22
		$('#btnMenuInsert').click(function() {
			var rowData = fncGetSelectedRowData();
			if(rowData != null) {
				if(confirm('선택한 메뉴를 저장하시겠습니까?')) {
					var useAuth = new Array();			//옵션저장
					var authMenuSeq = new Array();		//코드저장
					var authMenuState = new Array();	//구분상태저장
					
					/* 홈페이지 메뉴 */
					//체크된 노드 메뉴 등록/수정/삭제 옵션 체크박스 선택된 데이터 변수 저장
					$("#menuTree1").find(".jstree-undetermined").each(function (index, item) {
						var useAuthCheck = $("input[name='" + item.id + "']:checked");
						var useAuthNum = 0;
						for(var i = 0; i < useAuthCheck.length; i++) {
							useAuthNum = useAuthNum + Number(useAuthCheck[i].value);
						}
						useAuth.push(useAuthNum);
			        });
					$('#menuTree1').jstree('get_checked').each(function(index, item) {
						var useAuthCheck = $("input[name='" + item.id + "']:checked");
						var useAuthNum = 0;
						for(var i = 0; i < useAuthCheck.length; i++) {
							useAuthNum = useAuthNum + Number(useAuthCheck[i].value);
						}
						useAuth.push(useAuthNum);
					});
					$('#menuTree1').jstree('get_checked').children().find('li').each(function(index, item) {
						var useAuthCheck = $("input[name='" + item.id + "']:checked");
						var useAuthNum = 0;
						for(var i = 0; i < useAuthCheck.length; i++) {
							useAuthNum = useAuthNum + Number(useAuthCheck[i].value);
						}
						useAuth.push(useAuthNum);
					});
					//체크된 노드 아이디 값 저장
					$("#menuTree1").find(".jstree-undetermined").each(function (index, item) {
						authMenuSeq.push(item.id);
						authMenuState.push('jstree-undetermined');
			        });
					$('#menuTree1').jstree('get_checked').each(function(index, item) {
						authMenuSeq.push(item.id);
						authMenuState.push('jstree-checked');
					});
					$('#menuTree1').jstree('get_checked').children().find('li').each(function(index, item) {
						authMenuSeq.push(item.id);
						authMenuState.push('jstree-checked');
					});
					
					/* 관리자 메뉴 */
					//체크된 노드 메뉴 등록/수정/삭제 옵션 체크박스 선택된 데이터 변수 저장
					$("#menuTree2").find(".jstree-undetermined").each(function (index, item) {
						var useAuthCheck = $("input[name='" + item.id + "']:checked");
						var useAuthNum = 0;
						for(var i = 0; i < useAuthCheck.length; i++) {
							useAuthNum = useAuthNum + Number(useAuthCheck[i].value);
						}
						useAuth.push(useAuthNum);
			        });
					$('#menuTree2').jstree('get_checked').each(function(index, item) {
						var useAuthCheck = $("input[name='" + item.id + "']:checked");
						var useAuthNum = 0;
						for(var i = 0; i < useAuthCheck.length; i++) {
							useAuthNum = useAuthNum + Number(useAuthCheck[i].value);
						}
						useAuth.push(useAuthNum);
					});
					$('#menuTree2').jstree('get_checked').children().find('li').each(function(index, item) {
						var useAuthCheck = $("input[name='" + item.id + "']:checked");
						var useAuthNum = 0;
						for(var i = 0; i < useAuthCheck.length; i++) {
							useAuthNum = useAuthNum + Number(useAuthCheck[i].value);
						}
						useAuth.push(useAuthNum);
					});
					//체크된 노드 아이디 값 저장
					$("#menuTree2").find(".jstree-undetermined").each(function (index, item) {
						authMenuSeq.push(item.id);
						authMenuState.push('jstree-undetermined');
			        });
					$('#menuTree2').jstree('get_checked').each(function(index, item) {
						authMenuSeq.push(item.id);
						authMenuState.push('jstree-checked');
					});
					$('#menuTree2').jstree('get_checked').children().find('li').each(function(index, item) {
						authMenuSeq.push(item.id);
						authMenuState.push('jstree-checked');
					});
					
				
					//변수에 저장한 모든 데이터를 이용해 메뉴 저장
					$.ajax({
						type : 'POST',
						url : '/admin/saveMenu.do',
						dataType : 'json',
						data : {
							authMenuSeq : authMenuSeq,
							role_pcd : rowData.commcd,
							useAuth : useAuth,
							authMenuState : authMenuState
						},
						traditional : true,
						success : function() {
							alert_popup('저장되었습니다.');

						},
						error : function(e) {
							alert_popup(e);
						},
						complete : function() {
							fncList();
							fncMenuTreeSetting();
							location.reload();
						}
					});
					
				}
				else{
					alert_popup('취소 되었습니다.');
				}
			}
			else{
				alert_popup('권한을 선택해주세요!');
			}
		});
		
		$('#btnOpenAllMenu').click(function(){
			$.jstree._focused().open_all();
		});
		
		$('#btnCloseAllMenu').click(function(){
			$.jstree._focused().close_all();
		});
	});
	
	// jqGrid 셀 선택여부 추가 2020/03/25 - 추정완
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

	// 메뉴 트리 셋팅 추가 2020/04/20 - 추정완
	function fncMenuTreeSetting() {
		$.ajax({
			type:'POST',
			url:'/admin/listTreeAuth.do',
			success:function(data) {
				// 관리자 메뉴 가져오기
				var strMenuTree_A = data.strMenuTree_A;
				if(strMenuTree_A != undefined) {
					$('#menuTree2').html(strMenuTree_A);
					$('#menuTree2').jstree({
						'plugins' : ['themes', 'html_data', 'checkbox', 'ui']
					})
					//권한 체크 시 라디오 박스 출력
					.bind('change_state.jstree', function(e, data) {	// 
						
						var tagName = data.args[0].tagName;
					    var refreshing = data.inst.data.core.refreshing;
					    if ((tagName == "A" || tagName == "INS") &&
					      (refreshing != true && refreshing != "undefined")) {
					    	var nodeId = data.rslt.attr('id');					
							
					    	if(true == data.rslt.hasClass('jstree-checked')){							
								var optCheckBox = $("input[name='" + nodeId + "']");
								for(var i = 0; i < optCheckBox.length; i++) {
									optCheckBox[i].checked = false;
								}
								//클릭한 노드 menu_pcd 확인
								$.ajax({
									type : 'POST',
									url : '/admin/menuGet.do',
									data : {
										menucd : nodeId
									},
									dataType : 'json',
									traditional : true,
									success: function(data) {
										var menuInfo = data.menuInfo;
										if(menuInfo.menu_pcd == 'MENU_P001' || menuInfo.menu_pcd == 'MENU_P002' || menuInfo.menu_pcd == 'MENU_P003') {
											$("span[id='" + menuInfo.menucd + "']").css('display', 'inline');
										}
									}
								});
								//클릭한 노드 부모노드 menu_pcd 확인
								$('#' + nodeId).parents('li').each(function(index, item) {
									$.ajax({
										type : 'POST',
										url : '/admin/menuGet.do',
										data : {
											menucd : item.id
										},
										dataType : 'json',
										traditional : true,
										success: function(data) {
											var menuInfo = data.menuInfo;
											if(menuInfo.menu_pcd == 'MENU_P001' || menuInfo.menu_pcd == 'MENU_P002' || menuInfo.menu_pcd == 'MENU_P003') {
												$("span[id='" + menuInfo.menucd + "']").css('display', 'inline');
											}
										}
									});
								});
								//클릭한 노드 자식노드 menu_pcd 확인
								$('#' + nodeId).children().find('li').each(function(index, item) {
									$.ajax({
										type : 'POST',
										url : '/admin/menuGet.do',
										data : {
											menucd : item.id
										},
										dataType : 'json',
										traditional : true,
										success: function(data) {
											var menuInfo = data.menuInfo;
											if(menuInfo.menu_pcd == 'MENU_P001' || menuInfo.menu_pcd == 'MENU_P002' || menuInfo.menu_pcd == 'MENU_P003') {
												$("span[id='" + menuInfo.menucd + "']").css('display', 'inline');
											}
										}
									});
								});
							}else{
								
								//클릭해제노드 옵션 제거
								$("span[id='" + nodeId + "']").css('display', 'none');
								//클릭해제노드 옵션 체크된 거 제거
								var optCheckBox = $("input[name='" + nodeId + "']");
								for(var i = 0; i < optCheckBox.length; i++) {
									optCheckBox[i].checked = false;
								}
								//클릭부모노드 옵션 제거
								$('#' + nodeId).parents('li').each(function(index, item) {
									if($('#' + item.id).attr('class').indexOf('jstree-unchecked') != -1) {
										$("span[id='" + item.id + "']").css('display', 'none');
									}
								});
								//클릭자식노드 옵션 제거
								$('#' + nodeId).children().find('li').each(function(index, item) {
									if($('#' + item.id).attr('class').indexOf('jstree-unchecked') != -1) {
										$("span[id='" + item.id + "']").css('display', 'none');
									}
								}); 
							}	    	
					    } // if end
					})
				}
				
				// 홈페이지 메뉴 가져오기
				var strMenuTree_H = data.strMenuTree_H;
				if(strMenuTree_H != undefined) {
					$('#menuTree1').html(strMenuTree_H);
					$('#menuTree1').jstree({
						'plugins' : ['themes', 'html_data', 'checkbox', 'ui'],
					})
					.bind('change_state.jstree', function(e, data) {	// 
						
						var tagName = data.args[0].tagName;
					    var refreshing = data.inst.data.core.refreshing;
					    if ((tagName == "A" || tagName == "INS") &&
					      (refreshing != true && refreshing != "undefined")) {
					    	var nodeId = data.rslt.attr('id');					
							
					    	if(true == data.rslt.hasClass('jstree-checked')){							
								var optCheckBox = $("input[name='" + nodeId + "']");
								for(var i = 0; i < optCheckBox.length; i++) {
									optCheckBox[i].checked = false;
								}
								//클릭한 노드 menu_pcd 확인
								$.ajax({
									type : 'POST',
									url : '/admin/menuGet.do',
									data : {
										menucd : nodeId
									},
									dataType : 'json',
									traditional : true,
									success: function(data) {
										var menuInfo = data.menuInfo;
										if(menuInfo.menu_pcd == 'MENU_P001' || menuInfo.menu_pcd == 'MENU_P002' || menuInfo.menu_pcd == 'MENU_P003') {
											$("span[id='" + menuInfo.menucd + "']").css('display', 'inline');
										}
									}
								});
								//클릭한 노드 부모노드 menu_pcd 확인
								$('#' + nodeId).parents('li').each(function(index, item) {
									$.ajax({
										type : 'POST',
										url : '/admin/menuGet.do',
										data : {
											menucd : item.id
										},
										dataType : 'json',
										traditional : true,
										success: function(data) {
											var menuInfo = data.menuInfo;
											if(menuInfo.menu_pcd == 'MENU_P001' || menuInfo.menu_pcd == 'MENU_P002' || menuInfo.menu_pcd == 'MENU_P003') {
												$("span[id='" + menuInfo.menucd + "']").css('display', 'inline');
											}
										}
									});
								});
								//클릭한 노드 자식노드 menu_pcd 확인
								$('#' + nodeId).children().find('li').each(function(index, item) {
									$.ajax({
										type : 'POST',
										url : '/admin/menuGet.do',
										data : {
											menucd : item.id
										},
										dataType : 'json',
										traditional : true,
										success: function(data) {
											var menuInfo = data.menuInfo;
											if(menuInfo.menu_pcd == 'MENU_P001' || menuInfo.menu_pcd == 'MENU_P002' || menuInfo.menu_pcd == 'MENU_P003') {
												$("span[id='" + menuInfo.menucd + "']").css('display', 'inline');
											}
										}
									});
								});
							}else{
								//클릭해제노드 옵션 제거
								$("span[id='" + nodeId + "']").css('display', 'none');
								//클릭해제노드 옵션 체크된 거 제거
								var optCheckBox = $("input[name='" + nodeId + "']");
								for(var i = 0; i < optCheckBox.length; i++) {
									optCheckBox[i].checked = false;
								}
								//클릭부모노드 옵션 제거
								$('#' + nodeId).parents('li').each(function(index, item) {
									if($('#' + item.id).attr('class').indexOf('jstree-unchecked') != -1) {
										$("span[id='" + item.id + "']").css('display', 'none');
									}
								});
								//클릭자식노드 옵션 제거
								$('#' + nodeId).children().find('li').each(function(index, item) {
									if($('#' + item.id).attr('class').indexOf('jstree-unchecked') != -1) {
										$("span[id='" + item.id + "']").css('display', 'none');
									}
								}); 
							}	    	
					    } // if end
					})
				}
			}
		});
	}
	
	// 권한 사용자 선택 시 메뉴 리스트 선택 2020/04/20 - 추정완
	function fncMenuTreeSelect(rowData) {
		if(rowData.commcd_val1 == 'N') {
			$('#menuTree2').jstree('lock');
		}
		else{
			$('#menuTree2').jstree('unlock');
		}
		$.ajax({
			type : 'POST',
			url : '/admin/menuDataAuth.do',
			dataType : 'json',
			data : {
				commcd : rowData.commcd
			},
			async: false,
			traditional : true,
			success : function(data) {
				var authMenuList = data.authMenuList;
				for(var i = 0; i < authMenuList.length; i++) {
					if(authMenuList[i].useyn == 'Y') {
						$('#' + authMenuList[i].menucd).removeClass('jstree-unchecked');
						$('#' + authMenuList[i].menucd).addClass(authMenuList[i].note);
						if(authMenuList[i].menu_pcd == 'MENU_P001') {
							$("span[id='" + authMenuList[i].menucd + "']").css('display', 'inline');
							if(authMenuList[i].insert_yn == 'Y') {
								var checkbox = $('input[name="' + authMenuList[i].menucd + '"]');
								for(var k = 0; k < checkbox.length; k++) {
									if(checkbox[k].value == '1') {
										checkbox[k].checked = true;
									}
								}
							}
							else{
								var checkbox = $('input[name="' + authMenuList[i].menucd + '"]');
								for(var k = 0; k < checkbox.length; k++) {
									if(checkbox[k].value == '1') {
										checkbox[k].checked = false;
									}
								}
							}
							if(authMenuList[i].update_yn == 'Y') {
								var checkbox = $('input[name="' + authMenuList[i].menucd + '"]');
								for(var k = 0; k < checkbox.length; k++) {
									if(checkbox[k].value == '2') {
										checkbox[k].checked = true;
									}
								}
							}
							else{
								var checkbox = $('input[name="' + authMenuList[i].menucd + '"]');
								for(var k = 0; k < checkbox.length; k++) {
									if(checkbox[k].value == '2') {
										checkbox[k].checked = false;
									}
								}
							}
							if(authMenuList[i].delete_yn == 'Y') {
								var checkbox = $('input[name="' + authMenuList[i].menucd + '"]');
								for(var k = 0; k < checkbox.length; k++) {
									if(checkbox[k].value == '4') {
										checkbox[k].checked = true;
									}
								}
							}
							else{
								var checkbox = $('input[name="' + authMenuList[i].menucd + '"]');
								for(var k = 0; k < checkbox.length; k++) {
									if(checkbox[k].value == '4') {
										checkbox[k].checked = false;
									}
								}
							}
						}
					}
				}
			},
			error : function() {
				
			},
			complete : function() {
				
			}
		});
	}
	// jqGrid reload 함수 2020/03/25 - 추정완
	function fncList() {
		$('#list').trigger('reloadGrid');
	};
	// 권한 등록 버튼 기능 추가 2020/04/21 - 추정완
	function fncAuthInsert(mode) {
    	var url = '/admin/movePopAuth.do?mode=' + mode;
    	openDialog({
            title:"권한등록",
            width:520,
            height:500,
            url: url
     	});
	}
	// 권한 수정 버튼 기능 추가 2020/04/21 - 추정완
	function fncAuthUpdate(mode) {
		var updateData = fncGetSelectedRowData();
		if(updateData == null) {
			alert_popup('수정을 원하시는 권한을 선택 후 수정 버튼을 눌러주세요!');
		}
		else{
			var url = '/admin/movePopAuth.do?mode=U&commcd=' + updateData.commcd + '&commcd_gcd=' + updateData.commcd_gcd;
	    	openDialog({
	            title:"권한수정",
	            width:520,
	            height:500,
	            url: url
	     	});
		}
	}
	//권한 삭제 버튼 기능 추가 2020/04/21 - 추정완
	function fncAuthDelete(mode) {
		var deleteData = fncGetSelectedRowData();

		if(deleteData == null) {
			alert_popup('삭제를 원하시는 권한을 선택 후 삭제 버튼을 눌러주세요!');
		}
		else{
			if(confirm('[' + deleteData.cdnm + '] 권한을 삭제하시겠습니까?')) {
				$.ajax({
					type : 'POST',
					url : '/admin/authOption.do?mode=D',
					data : {
						commcd : deleteData.commcd,
						commcd_gcd : deleteData.commcd_gcd,
						role_pcd : deleteData.commcd
					},
					success : function(data) {
						if(data.memberAuthCnt > 0) {
							alert_popup('권한을 사용중인 사용자가 있습니다.');
						}
						else{
							alert_popup('정상 삭제처리 되었습니다.');
						}
					},
					error : function() {
						alert_popup('삭제처리 중 문제가 발생했습니다.');
					},
					complete : function() {
						fncList();
						location.reload();
					}
				});
			}
			else{
				alert_popup('취소 되었습니다.');
			}
		}
	}
</script>
<div class="contents">
  <div class="content_wrap">
  	<div class="clearFix mTop30">
  		<h3 class="contentTit2 fL lh30">권한목록</h3>
  		<div class="btnList fR ">
	    	<button type="button" id="btnInsert" class="btn btn-primary btn-sm non-display">등록</button>
	    	<button type="button" id="btnUpdate" class="btn btn-primary btn-sm non-display">수정</button>
	    	<button type="button" id="btnDelete" class="btn btn-primary btn-sm non-display">삭제</button>
	    </div>
  	</div>
    <!-- contents -->
    <!-- 버튼 -->
    
    <!-- jqGrid -->
    <div id="gridWrapper" class="mTop15">
		<table id="list" class="scroll" cellpadding="0" cellspacing="0"></table> 
		<div id="pager" class="scroll" style="text-align:center;"></div> 
	</div>
	
	<div class="clearFix mTop20">
  		<h3 class="contentTit2 fL lh30">메뉴권한</h3>
  		<div class="btnList fR ">
  			<button type="button" class="btn btn-primary btn-sm" id="btnOpenAllMenu">메뉴전체 열기</button>
  		    <button type="button" class="btn btn-primary btn-sm" id="btnCloseAllMenu">메뉴전체 닫기</button>
  			<button type="button" class="btn btn-primary btn-sm" id="btnMenuInsert">메뉴권한 저장</button>
	    </div>
  	</div>
	<!-- 메뉴트리 -->
	<div class="clearFix mTop10">
		<div class="auth_tree">
		     <div class="tree_title lh30">사용자</div>
		     <div id="menuTree1" class="menuTree "></div>		     
		</div>
	  	<div class="auth_tree">
	  		<div class="tree_title lh30">관리자</div>    
	  		<div id="menuTree2" class="menuTree "></div>	
	    </div>
    </div>
  </div>
</div>