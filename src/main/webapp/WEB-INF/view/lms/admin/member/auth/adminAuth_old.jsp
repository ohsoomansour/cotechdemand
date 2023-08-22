<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<script>
	$(document).ready(function(){
		
		var useAuth = ${use_auth};
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
						'권한번호',
						'코드명',
						'권한명',
						'사용여부',						
						'등록자',
						'등록일',
						'수정자',
						'수정일'
			],
			colModel : [
						{name:'commcd_seq',			index:'commcd_seq',		align:'center',		hidden : true},
						{name:'commcd',				index:'commcd',			align:'center'},
						{name:'cdnm',				index:'cdnm',			align:'center'},
						{name:'useyn',				index:'useyn',			align:'center'},
						{name:'reguid',				index:'reguid',			align:'center'},
						{name:'regdtm',				index:'regdtm',			align:'center'},
						{name:'moduid',				index:'moduid',			align:'center'},
						{name:'moddtm',				index:'moddtm',			align:'center'}
											
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
			height: '300',
			shrinkToFit:true,
			multiboxonly : true,
			rownumbers : true,
			onSelectRow : function(rowid, status, e){
				//열 선택 시 jstree 체크박스 모두 해제
				var menuList = [];
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
		
		// 테스트용 버튼 추가 2020/04/25
		$('#btnTest').click(function() {
			console.log('테스트용 버튼 클릭 했습니다!');
		});	
		
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
					var useAuth = new Array();
					//체크된 노드 메뉴 등록/수정/삭제 옵션 체크박스 선택된 데이터 변수 저장
					$("#menuTree1").find(".jstree-undetermined").each(function (index, item) {
						var useAuthCheck = $("input[name='" + item.id + "']:checked");
						var useAuthNum = 0;
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
					var authMenuSeq = new Array();
					var authMenuState = new Array();
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
					//체크된 노드 메뉴 등록/수정/삭제 옵션 체크박스 선택된 데이터 변수 저장
					$("#menuTree2").find(".jstree-undetermined").each(function (index, item) {
						var useAuthCheck = $("input[name='" + item.id + "']:checked");
						var useAuthNum = 0;
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
							alert('저장되었습니다.');

						},
						error : function(e) {
							alert(e);
						},
						complete : function() {
							fncList();
							fncMenuTreeSetting();
							location.reload();
						}
					});
					
				}
				else{
					alert('취소 되었습니다.');
				}
			}
			else{
				alert('권한을 선택해주세요!');
			}
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
	/* 사양 문제로 인한 주석 처리
    // 특정 노드 옵션 클릭 여부 확인 기능 추가 2020/04/26 - 추정완
    function fncNodeOptionCheck(id) {
    	var childNodeList = $('#' + id).children().find('li');
    	if(($('#' + id).attr('class') == 'jstree-closed jstree-checked') || ($('#' + id).attr('class') == 'jstree-checked jstree-closed') || ($('#' + id).attr('class') == 'jstree-last jstree-checked jstree-closed') || ($('#' + id).attr('class') == 'jstree-last jstree-closed jstree-checked')) {	
    		var optCheckBoxP = $('input[name="' + id + '"]');
        	for(var i = 0; i < optCheckBoxP.length; i++) {
        		if(optCheckBoxP[i].checked == true) {
        			for(var j = 0; j < childNodeList.length; j++) {
        				var optCheckBoxC = $('input[name="' + childNodeList[j].id+ '"]');
        				console.log('자식 체크 박스 : ' + optCheckBoxC.length);
        				for(var k = 0; k < optCheckBoxC.length; k++) {
        					if(i == k) {
        						optCheckBoxC[k].checked = true;
        					}
        				}
        			}
            		
        		}
        		else{
        			for(var j = 0; j < childNodeList.length; j++) {
        				var optCheckBoxC = $('input[name="' + childNodeList[j].id+ '"]');
        				for(var k = 0; k < optCheckBoxC.length; k++) {
        					if(i == k) {
        						optCheckBoxC[k].checked = false;
        					}
        				}
        			}
        		}
        	}
    	}
    }
    */
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
						'plugins' : ['themes', 'html_data', 'checkbox', 'ui', 'cookies'],
						'cookies' : {
							'save_selected' : false
						}
					})
					.bind('loaded.jstree', function(event, data) {
						$(this).jstree('open_all');
					})
					//권한 체크 시 라디오 박스 출력
					.on('check_node.jstree', function(e, data) {
						var node = data.rslt.obj[0];
						//클릭한 노드 옵션 나오게하기
						$("span[id='" + node.id + "']").css('display', 'inline');
						
						/* 사양변경으로 주석처리
						if(($('#' + node.id).parents('li').attr('class') == 'jstree-open jstree-checked') || ($('#' + node.id).parents('li').attr('class') == 'jstree-last jstree-open jstree-checked')) {
							var parentId = $('#' + node.id).parents('li').attr('id');
							$("span[id='" + parentId + "']").css('display', 'inline');
						}
						*/
						
						var optCheckBox = $("input[name='" + node.id + "']");
						for(var i = 0; i < optCheckBox.length; i++) {
							optCheckBox[i].checked = false;
						}
						
						if(node.value == 1) {
							if(($('#' + node.id).attr('class') == 'jstree-closed jstree-checked') || ($('#' + node.id).attr('class') == 'jstree-checked jstree-closed') || ($('#' + node.id).attr('class') == 'jstree-last jstree-checked jstree-closed') || ($('#' + node.id).attr('class') == 'jstree-last jstree-closed jstree-checked')) {
								$("span[id='" + node.id + "']").css('display', 'none');
							}
							$.ajax({
								type : 'POST',
								url : '/admin/menuGet.do',
								data : {
									menucd : node.id
								},
								dataType : 'json',
								traditional : true,
								success: function(data) {
									var menuInfo = data.menuInfo;
									if(menuInfo.menu_pcd == 'L' || menuInfo.menu_pcd == 'A' || menuInfo.menu_pcd == 'M') {
										$("span[id='" + menuInfo.menucd + "']").css('display', 'inline');
									}
								}
							});
							$.ajax({
								type : 'POST',
								url : '/admin/listNodeChildGet.do',
								data : {
									up_cd : node.id
								},
								dataType : 'json',
								traditional : true,
								success : function(data) {
									var childNode = data.childNode;
									for(var i = 0; i < childNode.length; i++) {
										$("span[id='" + childNode[i].menucd + "']").css('display', 'inline');
										if(childNode[i].menu_lvl == '2') {

											$.ajax({
												type : 'POST',
												url : '/admin/listNodeChildGet.do',
												data : {
													up_cd : childNode[i].menucd
												},
												dataType : 'json',
												traditional : true,
												success : function(data) {
													var childNode = data.childNode;
													for(var j = 0; j < childNode.length; j++) {
														$("span[id='" + childNode[j].menucd + "']").css('display', 'inline');
													}
												},
												error : function() {
													
												}
											});
										}
									}
								},
								error : function() {
									
								},
								complete : function() {
									
								}
								
							});
						}
						else if(node.value == 2) {
							console.log(node.id);
							$.ajax({
								type : 'POST',
								url : '/admin/menuGet.do',
								data : {
									menucd : node.id
								},
								dataType : 'json',
								traditional : true,
								success: function(data) {
									var menuInfo = data.menuInfo;
									if(menuInfo.menu_pcd == 'L' || menuInfo.menu_pcd == 'A' || menuInfo.menu_pcd == 'M') {
										$("span[id='" + menuInfo.menucd + "']").css('display', 'inline');
									}
								}
							});
							$.ajax({
								type : 'POST',
								url : '/admin/listNodeChildGet.do',
								data : {
									up_cd : node.id
								},
								dataType : 'json',
								traditional : true,
								success : function(data) {
									var childNode = data.childNode;
									for(var i = 0; i < childNode.length; i++) {
										$("span[id='" + childNode[i].menucd + "']").css('display', 'inline');
									}
								},
								error : function() {
									
								},
								complete : function() {
									
								}
								
							});
						}
						else if(node.value == 3) {
							$.ajax({
								type : 'POST',
								url : '/admin/menuGet.do',
								data : {
									menucd : node.id
								},
								dataType : 'json',
								traditional : true,
								success: function(data) {
									var menuInfo = data.menuInfo;
									console.log(menuInfo.menu_pcd);
									if(menuInfo.menu_pcd == 'L' || menuInfo.menu_pcd == 'A' || menuInfo.menu_pcd == 'M') {
										$("span[id='" + menuInfo.menucd + "']").css('display', 'inline');
									}
								}
							});
						}
					})
					//권한 체크 시 라디오 박스 사라짐
					.on('uncheck_node.jstree', function(e, data) {
						var node = data.rslt.obj[0];
						//클릭한 노드 옵션 나오게하기
						$("span[id='" + node.id + "']").css('display', 'none');
						
						/* 사양변경으로 주석처리
						if(($('#' + node.id).parents('li').attr('class') == 'jstree-open jstree-checked') || ($('#' + node.id).parents('li').attr('class') == 'jstree-last jstree-open jstree-checked')) {
							var parentId = $('#' + node.id).parents('li').attr('id');
							$("span[id='" + parentId + "']").css('display', 'inline');
						}
						*/
						
						var optCheckBox = $("input[name='" + node.id + "']");
						for(var i = 0; i < optCheckBox.length; i++) {
							optCheckBox[i].checked = false;
						}
						
						if(node.value == 1) {
							$.ajax({
								type : 'POST',
								url : '/admin/listNodeChildGet.do',
								data : {
									up_cd : node.id
								},
								dataType : 'json',
								traditional : true,
								success : function(data) {
									var childNode = data.childNode;
									for(var i = 0; i < childNode.length; i++) {
										$("span[id='" + childNode[i].menucd + "']").css('display', 'none');
										if(childNode[i].menu_lvl == 2) {
											$.ajax({
												type : 'POST',
												url : '/admin/listNodeChildGet.do',
												data : {
													up_cd : childNode[i].menucd
												},
												dataType : 'json',
												traditional : true,
												success : function(data) {
													var childNode = data.childNode;
													for(var j = 0; j < childNode.length; j++) {
														$("span[id='" + childNode[j].menucd + "']").css('display', 'none');
													}
												},
												error : function() {
													
												}
											});
										}
									}
								},
								error : function() {
									
								},
								complete : function() {
									
								}
								
							});
						}
						else if(node.value == 2) {
							$.ajax({
								type : 'POST',
								url : '/admin/listNodeChildGet.do',
								data : {
									up_cd : node.id
								},
								dataType : 'json',
								traditional : true,
								success : function(data) {
									var childNode = data.childNode;
									for(var i = 0; i < childNode.length; i++) {
										$("span[id='" + childNode[i].menucd + "']").css('display', 'none');
									}
								},
								error : function() {
									
								},
								complete : function() {
									
								}
								
							});
						}
						else if(node.value == 3) {
							$("span[id='" + node.id + "']").css('display', 'none');
							if($('#' + node.id).parents('li').attr('class') == 'jstree-open jstree-undetermined') {
								var parentNodeId = $('#' + node.id).parents('li').attr('id');
								$("span[id='" + parentNodeId + "']").css('display', 'none');
							}
						}
					})
				}
				
				// 홈페이지 메뉴 가져오기
				var strMenuTree_H = data.strMenuTree_H;
				if(strMenuTree_H != undefined) {
					$('#menuTree1').html(strMenuTree_H);
					$('#menuTree1').jstree({
						'plugins' : ['themes', 'html_data', 'checkbox', 'ui', 'cookies'],
						'cookies' : {
							'save_selected' : false
						}
					})
					.bind('loaded.jstree', function(event, data) {
						$(this).jstree('open_all');
					})
					//권한 체크 시 라디오 박스 출력
					.on('check_node.jstree', function(e, data) {
						var node = data.rslt.obj[0];						
						/* 사양변경으로 주석처리
						if(($('#' + node.id).parents('li').attr('class') == 'jstree-open jstree-checked') || ($('#' + node.id).parents('li').attr('class') == 'jstree-last jstree-open jstree-checked')) {
							var parentId = $('#' + node.id).parents('li').attr('id');
							$("span[id='" + parentId + "']").css('display', 'inline');
						}
						*/
						
						var optCheckBox = $("input[name='" + node.id + "']");
						for(var i = 0; i < optCheckBox.length; i++) {
							optCheckBox[i].checked = false;
						}
						
						if(node.value == 1) {
							if(($('#' + node.id).attr('class') == 'jstree-closed jstree-checked') || ($('#' + node.id).attr('class') == 'jstree-checked jstree-closed') || ($('#' + node.id).attr('class') == 'jstree-last jstree-checked jstree-closed') || ($('#' + node.id).attr('class') == 'jstree-last jstree-closed jstree-checked')) {
								$("span[id='" + node.id + "']").css('display', 'none');
							}
							$.ajax({
								type : 'POST',
								url : '/admin/menuGet.do',
								data : {
									menucd : node.id
								},
								dataType : 'json',
								traditional : true,
								success: function(data) {
									var menuInfo = data.menuInfo;
									if(menuInfo.menu_pcd == 'L' || menuInfo.menu_pcd == 'A' || menuInfo.menu_pcd == 'M') {
										$("span[id='" + menuInfo.menucd + "']").css('display', 'inline');
									}
								}
							});
							$.ajax({
								type : 'POST',
								url : '/admin/listNodeChildGet.do',
								data : {
									up_cd : node.id
								},
								dataType : 'json',
								traditional : true,
								success : function(data) {
									var childNode = data.childNode;
									for(var i = 0; i < childNode.length; i++) {
										if(childNode[i].menu_pcd == 'L' || childNode[i].menu_pcd == 'A' || childNode[i].menu_pcd == 'M') {
											$("span[id='" + childNode[i].menucd + "']").css('display', 'inline');
										}
										if(childNode[i].menu_lvl == '2') {
											$.ajax({
												type : 'POST',
												url : '/admin/listNodeChildGet.do',
												data : {
													up_cd : childNode[i].menucd
												},
												dataType : 'json',
												traditional : true,
												success : function(data) {
													var childNode = data.childNode;
													for(var j = 0; j < childNode.length; j++) {
														if(childNode[j].menu_pcd == 'L' || childNode[j].menu_pcd == 'A' || childNode[j].menu_pcd == 'M') {
															$("span[id='" + childNode[i].menucd + "']").css('display', 'inline');
														}
													}
												},
												error : function() {
													
												}
											});
										}
									}
								},
								error : function() {
									
								},
								complete : function() {
									
								}
								
							});
						}
						else if(node.value == 2) {
							console.log(node.id);
							$.ajax({
								type : 'POST',
								url : '/admin/menuGet.do',
								data : {
									menucd : node.id
								},
								dataType : 'json',
								traditional : true,
								success: function(data) {
									var menuInfo = data.menuInfo;
									if(menuInfo.menu_pcd == 'L' || menuInfo.menu_pcd == 'A' || menuInfo.menu_pcd == 'M') {
										$("span[id='" + menuInfo.menucd + "']").css('display', 'inline');
									}
								}
							});
							$.ajax({
								type : 'POST',
								url : '/admin/listNodeChildGet.do',
								data : {
									up_cd : node.id
								},
								dataType : 'json',
								traditional : true,
								success : function(data) {
									var childNode = data.childNode;
									for(var i = 0; i < childNode.length; i++) {
										if(childNode[i].menu_pcd == 'L' || childNode[i].menu_pcd == 'A' || childNode[i].menu_pcd == 'M') {
											$("span[id='" + childNode[i].menucd + "']").css('display', 'inline');
										}
									}
								},
								error : function() {
									
								},
								complete : function() {
									
								}
								
							});
						}
						else if(node.value == 3) {
							$.ajax({
								type : 'POST',
								url : '/admin/menuGet.do',
								data : {
									menucd : node.id
								},
								dataType : 'json',
								traditional : true,
								success: function(data) {
									var menuInfo = data.menuInfo;
									if(menuInfo.menu_pcd == 'L' || menuInfo.menu_pcd == 'A' || menuInfo.menu_pcd == 'M') {
										$("span[id='" + menuInfo.menucd + "']").css('display', 'inline');
									}
								}
							});
						}
					})
					//권한 체크 시 라디오 박스 사라짐
					.on('uncheck_node.jstree', function(e, data) {
						var node = data.rslt.obj[0];
						//클릭한 노드 옵션 나오게하기
						$("span[id='" + node.id + "']").css('display', 'none');
						
						/* 사양변경으로 주석처리
						if(($('#' + node.id).parents('li').attr('class') == 'jstree-open jstree-checked') || ($('#' + node.id).parents('li').attr('class') == 'jstree-last jstree-open jstree-checked')) {
							var parentId = $('#' + node.id).parents('li').attr('id');
							$("span[id='" + parentId + "']").css('display', 'inline');
						}
						*/
						
						var optCheckBox = $("input[name='" + node.id + "']");
						for(var i = 0; i < optCheckBox.length; i++) {
							optCheckBox[i].checked = false;
						}
						
						if(node.value == 1) {
							$.ajax({
								type : 'POST',
								url : '/admin/listNodeChildGet.do',
								data : {
									up_cd : node.id
								},
								dataType : 'json',
								traditional : true,
								success : function(data) {
									var childNode = data.childNode;
									for(var i = 0; i < childNode.length; i++) {
										$("span[id='" + childNode[i].menucd + "']").css('display', 'none');
										if(childNode[i].menu_lvl == 2) {
											$.ajax({
												type : 'POST',
												url : '/admin/listNodeChildGet.do',
												data : {
													up_cd : childNode[i].menucd
												},
												dataType : 'json',
												traditional : true,
												success : function(data) {
													var childNode = data.childNode;
													for(var j = 0; j < childNode.length; j++) {
														$("span[id='" + childNode[j].menucd + "']").css('display', 'none');
													}
												},
												error : function() {
													
												}
											});
										}
									}
								},
								error : function() {
									
								},
								complete : function() {
									
								}
								
							});
						}
						else if(node.value == 2) {
							$.ajax({
								type : 'POST',
								url : '/admin/listNodeChildGet.do',
								data : {
									up_cd : node.id
								},
								dataType : 'json',
								traditional : true,
								success : function(data) {
									var childNode = data.childNode;
									for(var i = 0; i < childNode.length; i++) {
										$("span[id='" + childNode[i].menucd + "']").css('display', 'none');
									}
								},
								error : function() {
									
								},
								complete : function() {
									
								}
								
							});
						}
						else if(node.value == 3) {
							$("span[id='" + node.id + "']").css('display', 'none');
							if($('#' + node.id).parents('li').attr('class') == 'jstree-open jstree-undetermined') {
								var parentNodeId = $('#' + node.id).parents('li').attr('id');
								$("span[id='" + parentNodeId + "']").css('display', 'none');
							}
						}
					})
				}
			}
		});
	}
	
	// 권한 사용자 선택 시 메뉴 리스트 선택 2020/04/20 - 추정완
	function fncMenuTreeSelect(rowData) {
		console.log(rowData.commcd);
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
						if(authMenuList[i].menu_pcd == 'L') {
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
		console.log('권한 팝업창 상태 : ' + mode);
    	var url = '/admin/movePopAuth.do?mode=' + mode;
    	openDialog({
            title:"권한등록",
            width:520,
            height:350,
            url: url
     	});
	}
	// 권한 수정 버튼 기능 추가 2020/04/21 - 추정완
	function fncAuthUpdate(mode) {
		console.log('권한 옵션 상태 : ' + mode);
		var updateData = fncGetSelectedRowData();
		if(updateData == null) {
			alert('수정을 원하시는 권한을 선택 후 수정 버튼을 눌러주세요!');
		}
		else{
			var url = '/admin/movePopAuth.do?mode=U&commcd_seq=' + updateData.commcd_seq;
	    	openDialog({
	            title:"권한수정",
	            width:520,
	            height:350,
	            url: url
	     	});
		}
	}
	//권한 삭제 버튼 기능 추가 2020/04/21 - 추정완
	function fncAuthDelete(mode) {
		console.log('권한 옵션 상태 : ' + mode);
		var deleteData = fncGetSelectedRowData();
		console.log(deleteData);
		if(deleteData == null) {
			alert('삭제를 원하시는 권한을 선택 후 삭제 버튼을 눌러주세요!');
		}
		else{
			if(confirm('[' + deleteData.cdnm + '] 권한을 삭제하시겠습니까?')) {
				$.ajax({
					type : 'POST',
					url : '/admin/authOption.do?mode=D',
					data : {
						commcd_seq : deleteData.commcd_seq,
						role_pcd : deleteData.commcd
					},
					success : function(data) {
						if(data.memberAuthCnt > 0) {
							alert('권한을 사용중인 사용자가 있습니다.');
						}
						else{
							alert('정상 삭제처리 되었습니다.');
						}
					},
					error : function() {
						alert('삭제처리 중 문제가 발생했습니다.');
					},
					complete : function() {
						fncList();
					}
				});
			}
			else{
				alert('취소 되었습니다.');
			}
		}
	}
</script>
<div class="contents">
  <div class="content_wrap">
    <!-- contents -->
    <!-- 버튼 -->
    <div class="btnList alignRight mTop15">
    	<button id="btnInsert" class="btn btn-primary btn-sm non-display">등록</button>
    	<button id="btnUpdate" class="btn btn-primary btn-sm non-display">수정</button>
    	<button id="btnDelete" class="btn btn-primary btn-sm non-display">삭제</button>
    </div>
    <!-- jqGrid -->
    <div id="gridWrapper" class="mTop15">
		<table id="list" class="scroll" cellpadding="0" cellspacing="0"></table> 
		<div id="pager" class="scroll" style="text-align:center;"></div> 
	</div>
	
	<!-- 메뉴트리 -->
	<div class="mTop15">
		<button class="btn btn-default btn-sm" id="btnMenuInsert">메뉴 저장</button>
		<button class="btn btn btn-primary btn-sm" id="btnTest">테스트용 버튼</button>
	</div>
	<div>
	     <div style="text-align:center;float:left;width:50%">홈페이지</div>
	     <div style="text-align:center;float:left;width:50%">관리자</div>    
	</div>
  	<div>
  		<div id="menuTree1" class="menuTree" style="height:500px;overflow-y:auto;float:left;width:50%"></div>
		<div id="menuTree2" class="menuTree" style="height:500px;overflow-y:auto;float:left;width:50%"></div>	
    </div>

  </div>
</div>